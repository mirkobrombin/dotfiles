local M = {}

-- Session Management Functions
function M.save_session()
  local session_name = vim.fn.input("Session name: ", "", "file")
  if session_name == "" then
    print("Session name cannot be empty.")
    return
  end

  local session_path = "~/.nvim_sessions/" .. session_name .. ".vim"
  local original_sessionoptions = vim.o.sessionoptions

  vim.o.sessionoptions = "buffers,curdir,help,tabpages,winsize"
  vim.cmd("mksession! " .. session_path)
  vim.o.sessionoptions = original_sessionoptions

  print("Session saved as " .. session_name)
end

function M.load_session()
  local Path = require("plenary.path")
  require("telescope.builtin").find_files({
    prompt_title = "< Load Session >",
    cwd = "~/.nvim_sessions",
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        local selected = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)
        local session_path = Path:new(selected.cwd, selected.value)
        vim.cmd("source " .. tostring(session_path))
        print("Session loaded: " .. selected.value)
      end)
      return true
    end,
  })
end

function M.delete_session()
  local session_name = vim.fn.input("Session name to delete: ", "", "file")
  if session_name == "" then
    print("Session name cannot be empty.")
    return
  end
  local session_path = "~/.nvim_sessions/" .. session_name .. ".vim"
  os.remove(vim.fn.expand(session_path))
  print("Session deleted: " .. session_name)
end

return M
