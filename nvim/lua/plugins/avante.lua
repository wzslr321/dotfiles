vim.g.avante_file_search = {
  -- Exclude common directories you don't want to search
  exclude_dirs = {
    "node_modules",
    ".git",
    "dist",
    "build",
    ".next"
  },
  -- Set max depth for file search
  max_depth = 5,
  -- Set root directory to current working directory
  root_dir = vim.fn.getcwd()
}

