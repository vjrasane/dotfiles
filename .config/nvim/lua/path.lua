local lz = require("lazy.core.util")
local M = {}

function M.realpath(path)
  if path == "" or path == nil then
    return nil
  end
  path = vim.loop.fs_realpath(path) or path
  return vim.fs.normalize(path)
end

function M.bufpath(buf)
  return M.realpath(vim.api.nvim_buf_get_name(assert(buf)))
end

function M.cwd()
  return M.realpath(vim.loop.cwd()) or ""
end

function M.sep()
  local sep = package.config:sub(1, 1)
  return sep
end

function M.split(path)
  return vim.split(path, "[\\/]")
end

function M.join(parts)
  return table.concat(parts, M.sep())
end

function M.pretty(path, root)
  root = root or M.cwd()
  if path == "" then
    return ""
  end

  if path:find(root, 1, true) == 1 then
    path = path:sub(#root + 2)
  end

  local parts = M.split(path)
  if #parts > 3 then
    parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
  end

  return M.join(parts)
end

return M
