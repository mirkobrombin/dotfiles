local M = {}

-- Create new file in current directory
M.create_new_file = function()
  local current_path = vim.fn.expand("%:p:h")
  local new_file = vim.fn.input("New file name: ", current_path .. "/")
  vim.cmd("edit " .. new_file)
end

-- Create new file picking the directory
M.create_file_with_telescope = function()
  require("telescope").extensions.file_browser.file_browser({
    path = vim.fn.expand("%:p:h"),
    select_buffer = true,
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        local new_file = require("telescope.actions.state").get_current_picker(prompt_bufnr):get_selection()
        require("telescope.actions").close(prompt_bufnr)
        vim.cmd("edit " .. new_file.value)
      end)
      return true
    end,
  })
end

-- Rename current file
M.rename_current_file = function()
  local current_file = vim.fn.expand("%:p")
  local new_name = vim.fn.input("New file name: ", current_file)
  if new_name ~= "" and new_name ~= current_file then
    vim.cmd("saveas " .. new_name)
    vim.fn.delete(current_file)
    print("File renamed to " .. new_name)
  else
    print("File rename cancelled or invalid name")
  end
end

return M
