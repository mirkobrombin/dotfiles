local M = {}

-- Backup Function
function M.backup_file()
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    print("No file to backup.")
    return
  end

  local timestamp = os.date("%Y%m%d_%H%M%S")
  local backup_path = file_path .. "." .. timestamp .. ".bak"

  vim.cmd("silent! write")

  local src_file = io.open(file_path, "rb")
  if not src_file then
    print("Failed to open source file.")
    return
  end

  local content = src_file:read("*all")
  src_file:close()

  local dest_file = io.open(backup_path, "wb")
  if not dest_file then
    print("Failed to create backup file.")
    return
  end

  dest_file:write(content)
  dest_file:close()

  print("Backup created: " .. backup_path)
end

return M
