local M = {}

local codex_buf
local codex_win
local codex_job
local review_ns = vim.api.nvim_create_namespace("codex_visual_review")
local active_review_ns = vim.api.nvim_create_namespace("codex_visual_review_active")
local visual_review

local function ensure_review_highlights()
    vim.api.nvim_set_hl(0, "CodexReviewHeader", { fg = "#7dcfff", bg = "#1f2335", bold = true })
    vim.api.nvim_set_hl(0, "CodexReviewHint", { fg = "#c0caf5", bg = "#1f2335" })
    vim.api.nvim_set_hl(0, "CodexReviewDelete", { fg = "#f7768e", bg = "#3b2230" })
    vim.api.nvim_set_hl(0, "CodexReviewAddVirt", { fg = "#9ece6a", bg = "#203528" })
    vim.api.nvim_set_hl(0, "CodexReviewAddLine", { bg = "#203528" })
    vim.api.nvim_set_hl(0, "CodexReviewChangeLine", { bg = "#34304a" })
    vim.api.nvim_set_hl(0, "CodexReviewSignAdd", { fg = "#9ece6a", bold = true })
    vim.api.nvim_set_hl(0, "CodexReviewSignChange", { fg = "#bb9af7", bold = true })
    vim.api.nvim_set_hl(0, "CodexReviewKey", { fg = "#e0af68", bg = "#1f2335", bold = true })
    vim.api.nvim_set_hl(0, "CodexReviewPanelTitle", { fg = "#7dcfff", bold = true })
    vim.api.nvim_set_hl(0, "CodexReviewPanelKey", { fg = "#e0af68", bold = true })
    vim.api.nvim_set_hl(0, "CodexReviewPanelDim", { fg = "#737aa2" })
    vim.api.nvim_set_hl(0, "CodexReviewActive", { fg = "#ff9e64", bg = "#1f2335", bold = true })
end

local function stop_visual_review_timer()
    if visual_review and visual_review.timer then
        visual_review.timer:stop()
        visual_review.timer:close()
        visual_review.timer = nil
    end
end

local function project_root()
    local buf = vim.api.nvim_get_current_buf()
    local root = vim.fs.root(buf, { ".git", "pyproject.toml", "package.json", "Cargo.toml", "go.mod" })
    return root or vim.fn.getcwd()
end

local function current_file()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return nil
    end
    return vim.fn.fnamemodify(name, ":p")
end

local function job_is_running()
    return codex_job and vim.fn.jobwait({ codex_job }, 0)[1] == -1
end

local function focus_terminal()
    if codex_win and vim.api.nvim_win_is_valid(codex_win) then
        vim.api.nvim_set_current_win(codex_win)
        return true
    end

    if codex_buf and vim.api.nvim_buf_is_valid(codex_buf) then
        vim.cmd("botright 90vsplit")
        vim.api.nvim_win_set_buf(0, codex_buf)
        codex_win = vim.api.nvim_get_current_win()
        return true
    end

    return false
end

local function open_terminal(args)
    if vim.fn.executable("codex") ~= 1 then
        vim.notify("codex CLI is not on PATH", vim.log.levels.ERROR)
        return
    end

    local has_initial_prompt = args and #args > 0
    if not has_initial_prompt and job_is_running() and focus_terminal() then
        vim.cmd("startinsert")
        return
    end

    vim.cmd("botright 90vsplit")
    vim.cmd("enew")
    codex_buf = vim.api.nvim_get_current_buf()
    codex_win = vim.api.nvim_get_current_win()
    vim.bo.bufhidden = "wipe"
    vim.bo.filetype = "codex"
    vim.bo.scrollback = 20000

    codex_job = vim.fn.termopen(vim.list_extend({ "codex", "--cd", project_root(), "--no-alt-screen" }, args or {}), {
        on_exit = function()
            codex_job = nil
        end,
    })
    vim.keymap.set("t", "<C-s>", "<C-\\><C-n>", { buffer = codex_buf, desc = "Codex scroll mode" })
    vim.keymap.set("t", "<C-g>", function()
        M.visual_review_refresh()
    end, { buffer = codex_buf, desc = "Focus visual review file" })
    vim.keymap.set("n", "q", "i", { buffer = codex_buf, desc = "Return to Codex input" })
    vim.cmd("startinsert")
end

local function send_prompt(prompt)
    if not prompt or prompt == "" then
        return
    end

    if not job_is_running() then
        open_terminal({ prompt })
        return
    end

    focus_terminal()
    -- Bracketed paste keeps multiline prompts together in terminal TUIs.
    vim.api.nvim_chan_send(codex_job, "\x1b[200~" .. prompt .. "\x1b[201~\r")
    vim.cmd("startinsert")
end

local function focus_file(path)
    if not path or path == "" then
        return
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == path then
            vim.api.nvim_set_current_win(win)
            return
        end
    end

    vim.cmd("edit " .. vim.fn.fnameescape(path))
end

local function review_buf()
    if not visual_review then
        return nil
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == visual_review.file then
            return buf
        end
    end

    return nil
end

local function review_win()
    local buf = review_buf()
    if not buf then
        return nil
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
            return win
        end
    end

    return nil
end

local function read_file_lines(path)
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok then
        return nil
    end

    return lines
end

local function current_lines(buf)
    return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
end

local function save_buffer_for_review(buf)
    if not vim.bo[buf].modified then
        return true
    end

    local current = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_current_buf(buf)
    local ok, err = pcall(vim.cmd, "silent write!")
    vim.api.nvim_set_current_buf(current)
    if not ok then
        vim.notify("Could not save buffer before Codex visual review: " .. tostring(err), vim.log.levels.ERROR)
        return false
    end

    vim.notify("Saved buffer before Codex visual prompt so Codex and Neovim review the same file.", vim.log.levels.INFO)
    return true
end

local function same_lines(a, b)
    if not a or not b or #a ~= #b then
        return false
    end

    for i = 1, #a do
        if a[i] ~= b[i] then
            return false
        end
    end

    return true
end

local function diff_text(lines)
    if #lines == 0 then
        return ""
    end

    return table.concat(lines, "\n") .. "\n"
end

local function add_hunk_extmark(buf, hunk, line, col, opts)
    local id = vim.api.nvim_buf_set_extmark(buf, review_ns, line, col, opts)
    hunk.mark_ids = hunk.mark_ids or {}
    table.insert(hunk.mark_ids, id)
    return id
end

local function clear_hunk_extmarks(buf, hunk)
    for _, id in ipairs(hunk.mark_ids or {}) do
        pcall(vim.api.nvim_buf_del_extmark, buf, review_ns, id)
    end
    hunk.mark_ids = {}
    hunk.dismissed = true
end

local function hunk_anchor_lnum(buf, hunk)
    if hunk.mark_id then
        local pos = vim.api.nvim_buf_get_extmark_by_id(buf, review_ns, hunk.mark_id, {})
        if pos and pos[1] then
            return pos[1] + 1
        end
    end

    return hunk.anchor_lnum
end

local function hunk_kind(hunk)
    if hunk.old_count == 0 then
        return "add"
    end
    if hunk.new_count == 0 then
        return "delete"
    end
    return "change"
end

local function active_hunk_count()
    local count = 0
    for _, hunk in ipairs((visual_review and visual_review.hunks) or {}) do
        if not hunk.dismissed then
            count = count + 1
        end
    end
    return count
end

local function first_active_hunk()
    for _, hunk in ipairs((visual_review and visual_review.hunks) or {}) do
        if not hunk.dismissed then
            return hunk
        end
    end
    return nil
end

local function hunk_by_index(index)
    if not visual_review or not index then
        return nil
    end

    for _, hunk in ipairs(visual_review.hunks or {}) do
        if hunk.index == index and not hunk.dismissed then
            return hunk
        end
    end

    return nil
end

local function selected_hunk()
    return hunk_by_index(visual_review and visual_review.active_hunk_index)
end

local function close_review_controls()
    if not visual_review then
        return
    end

    if visual_review.controls_win and vim.api.nvim_win_is_valid(visual_review.controls_win) then
        pcall(vim.api.nvim_win_close, visual_review.controls_win, true)
    end
    if visual_review.controls_buf and vim.api.nvim_buf_is_valid(visual_review.controls_buf) then
        pcall(vim.api.nvim_buf_delete, visual_review.controls_buf, { force = true })
    end
    visual_review.controls_win = nil
    visual_review.controls_buf = nil
end

local function show_active_marker()
    local buf = review_buf()
    if not buf or not visual_review then
        return
    end

    vim.api.nvim_buf_clear_namespace(buf, active_review_ns, 0, -1)
    local hunk = selected_hunk()
    if not hunk then
        return
    end

    local anchor_lnum = hunk_anchor_lnum(buf, hunk)
    if not anchor_lnum then
        return
    end

    vim.api.nvim_buf_set_extmark(buf, active_review_ns, math.max(anchor_lnum - 1, 0), 0, {
        virt_text = {
            {
                string.format("  SELECTED chunk %d/%d - %s", hunk.index, hunk.total, hunk_kind(hunk)),
                "CodexReviewActive",
            },
        },
        virt_text_pos = "eol",
        priority = 200,
    })
end

local function highlight_panel_keys(buf, lines)
    vim.api.nvim_buf_clear_namespace(buf, review_ns, 0, -1)
    for line_index, line in ipairs(lines) do
        if line_index == 1 then
            vim.api.nvim_buf_add_highlight(buf, review_ns, "CodexReviewPanelTitle", line_index - 1, 0, -1)
        end
        for key in line:gmatch("<leader>%a+") do
            local start_col = line:find(key, 1, true)
            if start_col then
                vim.api.nvim_buf_add_highlight(
                    buf,
                    review_ns,
                    "CodexReviewPanelKey",
                    line_index - 1,
                    start_col - 1,
                    start_col + #key - 1
                )
            end
        end
    end
end

local function show_review_controls()
    if not visual_review then
        return
    end

    ensure_review_highlights()
    local win = review_win()
    if not win then
        return
    end

    local total = #(visual_review.hunks or {})
    local active = active_hunk_count()
    local hunk = selected_hunk()
    local selected = hunk and string.format("selected chunk %d/%d - %s", hunk.index, total, hunk_kind(hunk))
        or "selected none"
    local lines = {
        "Codex visual review",
        string.format("chunks  %d active / %d total", active, total),
        selected,
        "accept  <leader>ca",
        "reject  <leader>cx",
        "close   <leader>aR",
    }
    local width = 34

    if not visual_review.controls_buf or not vim.api.nvim_buf_is_valid(visual_review.controls_buf) then
        visual_review.controls_buf = vim.api.nvim_create_buf(false, true)
        vim.bo[visual_review.controls_buf].bufhidden = "wipe"
    end

    local buf = visual_review.controls_buf
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    highlight_panel_keys(buf, lines)
    vim.bo[buf].modifiable = false

    local col = math.max(vim.api.nvim_win_get_width(win) - width - 2, 0)
    local config = {
        relative = "win",
        win = win,
        row = 1,
        col = col,
        width = width,
        height = #lines,
        border = "rounded",
        style = "minimal",
        focusable = false,
        zindex = 60,
        title = " review keys ",
        title_pos = "center",
    }

    if visual_review.controls_win and vim.api.nvim_win_is_valid(visual_review.controls_win) then
        vim.api.nvim_win_set_config(visual_review.controls_win, config)
    else
        visual_review.controls_win = vim.api.nvim_open_win(buf, false, config)
    end
    vim.wo[visual_review.controls_win].winblend = 8
end

local function set_active_hunk(hunk)
    if not visual_review then
        return nil
    end

    if hunk and not hunk.dismissed then
        visual_review.active_hunk_index = hunk.index
    else
        visual_review.active_hunk_index = nil
    end

    show_active_marker()
    show_review_controls()
    return selected_hunk()
end

local function hunk_contains_cursor(buf, hunk, lnum)
    if hunk.dismissed then
        return false
    end

    local anchor_lnum = hunk_anchor_lnum(buf, hunk)
    if not anchor_lnum then
        return false
    end

    if hunk.new_count == 0 then
        return math.abs(lnum - anchor_lnum) <= 1
    end

    return lnum >= anchor_lnum and lnum <= (anchor_lnum + hunk.new_count - 1)
end

local function hunk_title(hunk)
    local kind = "change"
    if hunk.old_count == 0 then
        kind = "add"
    elseif hunk.new_count == 0 then
        kind = "delete"
    end

    return string.format(" Codex chunk %d/%d - %s ", hunk.index, hunk.total, kind)
end

local function render_visual_review()
    local buf = review_buf()
    if not buf or not visual_review then
        return
    end

    ensure_review_highlights()
    vim.api.nvim_buf_clear_namespace(buf, review_ns, 0, -1)
    local new_lines = visual_review.result_lines or current_lines(buf)
    local hunks = vim.diff(diff_text(visual_review.old_lines), diff_text(new_lines), {
        result_type = "indices",
    }) or {}

    visual_review.hunks = {}
    local total = #hunks

    for index, hunk in ipairs(hunks) do
        local old_start, old_count, new_start, new_count = hunk[1], hunk[2], hunk[3], hunk[4]
        local old_lines = old_count > 0
                and vim.list_slice(visual_review.old_lines, old_start, old_start + old_count - 1)
            or {}
        local review_hunk = {
            index = index,
            total = total,
            old_start = old_start,
            old_count = old_count,
            new_start = new_start,
            new_count = new_count,
            old_lines = old_lines,
            new_lines = new_count > 0 and vim.list_slice(new_lines, new_start, new_start + new_count - 1) or {},
            anchor_lnum = math.max(new_start, 1),
            mark_ids = {},
        }
        table.insert(visual_review.hunks, review_hunk)

        local anchor = math.max(new_start - 1, 0)
        local virt_lines_above = true
        if new_count > 0 then
            for line = new_start, new_start + new_count - 1 do
                add_hunk_extmark(buf, review_hunk, line - 1, 0, {
                    line_hl_group = old_count > 0 and "CodexReviewChangeLine" or "CodexReviewAddLine",
                    sign_text = old_count > 0 and "~" or "+",
                    sign_hl_group = old_count > 0 and "CodexReviewSignChange" or "CodexReviewSignAdd",
                })
            end
            anchor = new_start - 1
        elseif anchor >= vim.api.nvim_buf_line_count(buf) then
            anchor = math.max(vim.api.nvim_buf_line_count(buf) - 1, 0)
        elseif new_start > 0 then
            anchor = new_start - 1
            virt_lines_above = false
        end
        review_hunk.anchor_lnum = anchor + 1
        review_hunk.virt_lines_above = virt_lines_above

        local virt_lines = {
            { { hunk_title(review_hunk), "CodexReviewHeader" } },
        }
        if old_count > 0 then
            for offset, line in ipairs(old_lines) do
                local display = line ~= "" and line or "␠"
                table.insert(virt_lines, {
                    {
                        "- " .. display,
                        "CodexReviewDelete",
                    },
                })
            end
        end
        review_hunk.mark_id = add_hunk_extmark(buf, review_hunk, anchor, 0, {
            virt_lines = virt_lines,
            virt_lines_above = virt_lines_above,
            virt_lines_leftcol = true,
        })

        add_hunk_extmark(buf, review_hunk, anchor, 0, {
            virt_text = {
                {
                    string.format("  Codex chunk %d/%d", index, total),
                    "CodexReviewHeader",
                },
            },
            virt_text_pos = "eol",
        })
    end

    if not hunk_by_index(visual_review.active_hunk_index) then
        local hunk = first_active_hunk()
        visual_review.active_hunk_index = hunk and hunk.index or nil
    end
    show_active_marker()
    show_review_controls()
end

local function sync_visual_review_from_disk()
    if not visual_review or visual_review.frozen then
        return false, nil
    end

    local disk_lines = read_file_lines(visual_review.file)
    if not disk_lines then
        return false, nil
    end

    if same_lines(disk_lines, visual_review.old_lines) then
        return false, nil
    end

    local buf = review_buf()
    if not buf then
        return false, nil
    end

    local buf_lines = current_lines(buf)
    if vim.bo[buf].modified and not same_lines(buf_lines, disk_lines) then
        if not visual_review.modified_warning_shown then
            visual_review.modified_warning_shown = true
            vim.notify(
                "Codex visual review saw file changes, but this buffer has unsaved edits. Save, then press <leader>cr.",
                vim.log.levels.WARN
            )
        end
        stop_visual_review_timer()
        return false, nil
    end

    if not same_lines(buf_lines, disk_lines) then
        local restore_view = vim.api.nvim_get_current_buf() == buf and vim.fn.winsaveview() or nil
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, disk_lines)
        vim.bo[buf].modified = false
        if restore_view then
            pcall(vim.fn.winrestview, restore_view)
        end
    end

    return true, disk_lines
end

local function freeze_visual_review(result_lines)
    if not visual_review or visual_review.frozen then
        return
    end

    visual_review.result_lines = vim.deepcopy(result_lines)
    visual_review.frozen = true
    visual_review.pending_lines = nil
    visual_review.pending_since = nil
    stop_visual_review_timer()
    render_visual_review()
end

local function hunk_under_cursor()
    if not visual_review then
        return nil
    end

    local buf = review_buf()
    if not buf or vim.api.nvim_get_current_buf() ~= buf then
        return nil
    end

    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    for _, hunk in ipairs(visual_review.hunks or {}) do
        if hunk_contains_cursor(buf, hunk, lnum) then
            return hunk
        end
    end

    return nil
end

local function sync_active_hunk_from_cursor()
    local hunk = hunk_under_cursor()
    if hunk and hunk.index ~= visual_review.active_hunk_index then
        set_active_hunk(hunk)
    end
end

local function current_review_hunk()
    sync_active_hunk_from_cursor()
    return selected_hunk()
end

local function jump_to_hunk(hunk)
    hunk = set_active_hunk(hunk)
    if not hunk then
        return
    end

    local buf = review_buf()
    local win = review_win()
    if not buf or not win then
        return
    end

    local anchor_lnum = hunk_anchor_lnum(buf, hunk)
    if anchor_lnum then
        vim.api.nvim_set_current_win(win)
        vim.api.nvim_win_set_cursor(win, { math.max(anchor_lnum, 1), 0 })
    end
end

local function notify_visual_review()
    vim.notify("Codex visual review enabled. The floating panel shows the review keys.", vim.log.levels.INFO)
end

local function start_visual_review_timer()
    stop_visual_review_timer()
    if not visual_review then
        return
    end

    visual_review.timer_started_at = vim.uv.now()
    visual_review.timer = vim.uv.new_timer()
    visual_review.timer:start(
        400,
        400,
        vim.schedule_wrap(function()
            if not visual_review then
                return
            end

            local elapsed = vim.uv.now() - visual_review.timer_started_at
            if elapsed > 10 * 60 * 1000 then
                stop_visual_review_timer()
                return
            end

            local changed, disk_lines = sync_visual_review_from_disk()
            if not changed then
                return
            end

            if not visual_review.pending_lines or not same_lines(visual_review.pending_lines, disk_lines) then
                visual_review.pending_lines = vim.deepcopy(disk_lines)
                visual_review.pending_since = vim.uv.now()
                return
            end

            if vim.uv.now() - visual_review.pending_since < 700 then
                return
            end

            freeze_visual_review(disk_lines)

            if not visual_review.first_render_notified and #visual_review.hunks > 0 then
                visual_review.first_render_notified = true
                focus_file(visual_review.file)
                jump_to_hunk(visual_review.hunks[1])
                vim.notify(
                    "Codex visual diff ready. Use <leader>ca to accept hunk, <leader>cx to reject.",
                    vim.log.levels.INFO
                )
            end
        end)
    )
end

function M.visual_review_begin(path)
    local file = path or current_file()
    if not file then
        return
    end

    focus_file(file)
    local buf = vim.api.nvim_get_current_buf()
    if not save_buffer_for_review(buf) then
        return
    end
    visual_review = {
        file = file,
        old_lines = current_lines(buf),
        hunks = {},
        active_hunk_index = nil,
        augroup = vim.api.nvim_create_augroup("CodexVisualReview" .. buf, { clear = true }),
        first_render_notified = false,
        modified_warning_shown = false,
    }
    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
        gitsigns.toggle_signs(false)
        gitsigns.toggle_numhl(false)
        gitsigns.toggle_linehl(false)
        gitsigns.toggle_deleted(false)
        gitsigns.toggle_word_diff(false)
    end
    vim.api.nvim_buf_clear_namespace(buf, review_ns, 0, -1)
    vim.keymap.set("n", "<leader>cr", M.visual_review_refresh, { buffer = buf, desc = "Refresh Codex visual review" })
    vim.keymap.set("n", "<leader>ca", M.accept_visual_hunk, { buffer = buf, desc = "Accept Codex visual hunk" })
    vim.keymap.set("n", "<leader>cx", M.reject_visual_hunk, { buffer = buf, desc = "Reject Codex visual hunk" })
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = visual_review.augroup,
        buffer = buf,
        callback = sync_active_hunk_from_cursor,
    })
    start_visual_review_timer()
    show_review_controls()
    notify_visual_review()
end

function M.visual_review_off()
    stop_visual_review_timer()
    close_review_controls()
    local buf = review_buf()
    if buf then
        vim.api.nvim_buf_clear_namespace(buf, review_ns, 0, -1)
        vim.api.nvim_buf_clear_namespace(buf, active_review_ns, 0, -1)
        for _, key in ipairs({
            "<leader>cr",
            "<leader>ca",
            "<leader>cx",
        }) do
            pcall(vim.keymap.del, "n", key, { buffer = buf })
        end
    end
    if visual_review and visual_review.augroup then
        pcall(vim.api.nvim_del_augroup_by_id, visual_review.augroup)
    end
    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
        gitsigns.toggle_signs(true)
        gitsigns.refresh()
    end
    visual_review = nil
    vim.notify("Codex visual review mode disabled.", vim.log.levels.INFO)
end

function M.visual_review_refresh()
    if not visual_review then
        return
    end

    focus_file(visual_review.file)
    if visual_review.frozen then
        return
    end

    local changed, disk_lines = sync_visual_review_from_disk()
    if not changed then
        vim.notify("No Codex visual changes detected yet.", vim.log.levels.INFO)
        return
    end

    freeze_visual_review(disk_lines)
    if #visual_review.hunks > 0 then
        jump_to_hunk(visual_review.hunks[1])
        vim.notify("Codex visual diff ready.", vim.log.levels.INFO)
    else
        vim.notify("Codex visual prompt did not change this file.", vim.log.levels.INFO)
    end
end

function M.accept_visual_hunk()
    local hunk = current_review_hunk()
    local buf = review_buf()
    if not hunk or not visual_review or not buf then
        vim.notify("No selected Codex visual-review hunk.", vim.log.levels.WARN)
        return
    end

    local before = current_lines(buf)
    clear_hunk_extmarks(buf, hunk)
    if not same_lines(before, current_lines(buf)) then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, before)
        vim.notify(
            "Accept hunk tried to edit the buffer; reverted it. Use reject only to remove lines.",
            vim.log.levels.ERROR
        )
        return
    end
    set_active_hunk(nil)
end

local function reject_hunk(hunk)
    local buf = review_buf()
    if not hunk or not buf or hunk.dismissed then
        return false
    end

    local anchor_lnum = hunk_anchor_lnum(buf, hunk)
    if not anchor_lnum then
        return false
    end

    local start_index
    if hunk.new_count == 0 then
        start_index = hunk.virt_lines_above and anchor_lnum - 1 or anchor_lnum
    else
        start_index = anchor_lnum - 1
    end

    vim.api.nvim_buf_set_lines(buf, start_index, start_index + hunk.new_count, false, hunk.old_lines)
    clear_hunk_extmarks(buf, hunk)
    set_active_hunk(nil)
    return true
end

function M.reject_visual_hunk()
    local hunk = current_review_hunk()
    if not reject_hunk(hunk) then
        vim.notify("No selected Codex visual-review hunk.", vim.log.levels.WARN)
    end
end

local function visual_selection()
    local file = current_file()
    if not file then
        vim.notify("Save the buffer before sending it to Codex.", vim.log.levels.WARN)
        return nil
    end

    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_line = start_pos[2]
    local end_line = end_pos[2]
    local start_col = start_pos[3]
    local end_col = end_pos[3]

    if start_line > end_line then
        start_line, end_line = end_line, start_line
        start_col, end_col = end_col, start_col
    end

    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    if #lines == 0 then
        vim.notify("No visual selection found.", vim.log.levels.WARN)
        return nil
    end

    if #lines == 1 then
        lines[1] = string.sub(lines[1], start_col, end_col)
    else
        lines[1] = string.sub(lines[1], start_col)
        lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end

    return {
        file = file,
        start_line = start_line,
        end_line = end_line,
        text = table.concat(lines, "\n"),
    }
end

local function selection_prompt(task)
    local selection = visual_selection()
    if not selection then
        return nil
    end

    return M.prompt_from_selection(task, selection)
end

function M.prompt_from_selection(task, selection)
    return table.concat({
        task,
        "",
        "File: " .. selection.file,
        "Lines: " .. selection.start_line .. "-" .. selection.end_line,
        "",
        "Selected code:",
        "```",
        selection.text,
        "```",
    }, "\n")
end

function M.open()
    open_terminal()
end

function M.resume()
    open_terminal({ "resume", "--last" })
end

function M.add_buffer()
    local file = current_file()
    if not file then
        vim.notify("Save the buffer before sending it to Codex.", vim.log.levels.WARN)
        return
    end

    send_prompt("Read this file into context and wait for my next instruction: " .. file)
end

function M.ask_selection()
    vim.ui.input({ prompt = "Codex prompt for selection: " }, function(input)
        if not input or input == "" then
            return
        end

        local prompt = selection_prompt(input)
        if prompt then
            M.visual_review_begin(current_file())
            open_terminal({ prompt })
        end
    end)
end

function M.diff()
    vim.cmd("checktime")

    if vim.fn.exists(":DiffviewOpen") == 2 then
        vim.cmd("DiffviewOpen")
        return
    end

    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
        gitsigns.diffthis()
        return
    end

    vim.notify("Install diffview.nvim or gitsigns.nvim to review diffs.", vim.log.levels.WARN)
end

function M.help(use_visual_selection)
    local selected = use_visual_selection and visual_selection() or nil

    local function ask_with_selection()
        if not selected then
            M.ask_selection()
            return
        end

        vim.ui.input({ prompt = "Codex prompt for selection: " }, function(input)
            if not input or input == "" then
                return
            end

            M.visual_review_begin(selected.file)
            open_terminal({ M.prompt_from_selection(input, selected) })
        end)
    end

    local function normal(keys)
        return function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "m", false)
        end
    end

    local actions = {
        { label = "Open / focus Codex", key = "<leader>ac", run = M.open },
        { label = "Resume last Codex session", key = "<leader>ar", run = M.resume },
        { label = "Send current file to open Codex", key = "<leader>ab", run = M.add_buffer },
        {
            label = "Prompt Codex with visual selection",
            key = "visual <leader>as",
            run = ask_with_selection,
        },
        { label = "Disable visual inline review", key = "<leader>aR", run = M.visual_review_off },
        { label = "Open Codex/git diff review", key = "<leader>ad", run = M.diff },
        {
            label = "Open full git diff review",
            key = "<leader>gd",
            run = function()
                vim.cmd("DiffviewOpen")
            end,
        },
        {
            label = "Open current file diff",
            key = "<leader>gD",
            run = function()
                vim.cmd("DiffviewOpen -- %")
            end,
        },
        {
            label = "Close diff review",
            key = "<leader>gq",
            run = function()
                vim.cmd("DiffviewClose")
            end,
        },
        { label = "Next hunk", key = "]h", run = normal("]h") },
        { label = "Previous hunk", key = "[h", run = normal("[h") },
        { label = "Preview hunk", key = "<leader>hp", run = normal("<leader>hp") },
        { label = "Accept hunk", key = "<leader>ha", run = normal("<leader>ha") },
        { label = "Reject hunk", key = "<leader>hx", run = normal("<leader>hx") },
        { label = "Accept buffer", key = "<leader>hA", run = normal("<leader>hA") },
        { label = "Reject buffer", key = "<leader>hX", run = normal("<leader>hX") },
    }

    vim.ui.select(actions, {
        prompt = "Codex / AI action  (shortcut shown on the right)",
        format_item = function(item)
            return string.format("%-38s %s", item.label, item.key)
        end,
    }, function(choice)
        if choice then
            choice.run()
        end
    end)
end

function M.review()
    open_terminal({ "review" })
end

function M.apply()
    open_terminal({ "apply" })
end

return M
