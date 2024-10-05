local M = {}

-- Find and replace in the whole buffer
M.find_and_replace = function()
  local old = vim.fn.input("Find: ")
  local new = vim.fn.input("Replace with: ")
  vim.cmd(":%s/" .. old .. "/" .. new .. "/g")
end

return M
