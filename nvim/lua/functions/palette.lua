local M = {}

-- Custom Command Palette
function M.Show_custom_palette()
  local actions = {
    -- A

    -- B
    { "Backup Current File", ":lua require('functions/backup').backup_file()" },

    -- C
    { "Select All and Copy", ":lua vim.cmd('normal! ggVGy')" },
    { "Create New Note", ":lua require('functions/notes').new_note()" },

    -- D
    { "Dashboard", ":Dashboard" },
    { "Delete All Buffers", ":bufdo bd" },
    { "Delete Current File", ":lua vim.fn.delete(vim.fn.expand('%')) | bdelete!" },
    { "Delete Note", ":lua require('functions/notes').delete_note()" },

    -- E

    -- F
    { "Find Word in Current Directory", ":Telescope live_grep" },
    { "Find and Replace in Current File", ":lua require('functions/find-replace').find_and_replace()" },

    -- G

    -- H

    -- I

    -- J

    -- K

    -- L
    { "LazyVim Extra", ":LazyExtras" },
    {
      "LazyGit",
      function()
        vim.cmd("LazyGit")
        vim.defer_fn(function()
          if not vim.bo.filetype == "lazygit" then
            vim.cmd("LazyGit")
          end
        end, 200)
      end,
    },

    -- M
    {
      "Make Float",
      ":lua require('toggleterm.terminal').Terminal:new({ direction = 'float' }):toggle()",
    },

    -- N
    { "New File", ":enew" },
    { "New File in Current Path", ":lua require('functions/files').create_new_file()" },
    { "New File Picking the Path", ":lua require('functions/files').create_file_with_telescope()" },
    { "New Terminal", ":split | terminal" },

    -- O
    { "Open File", ":Telescope find_files" },
    { "Open Recent", ":Telescope oldfiles" },

    -- P

    -- Q
    { "Quit", ":q" },
    { "Quit All", ":qa" },
    { "Quit All Without Saving", ":qa!" },

    -- R
    { "Remove All Comments", ":lua require('functions/coding').remove_all_comments()" },
    { "Remove Comment at Line", ":lua require('functions/coding').remove_comment_at_line()" },
    { "Remove Comment Block", ":lua require('functions/coding').remove_comment_block()" },

    -- S
    { "Save All Files", ":wa" },
    { "Save Current File", ":w" },
    { "Save Neovim Session", ":lua require('functions/sessions').save_session()" },
    { "Show Symbols Outline", ":Telescope lsp_document_symbols" },

    -- T
    { "Toggle Notes", ":lua require('functions/notes').toggle_notes()" },
    {
      "Toggle Outline",
      function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Space>cs", true, false, true), "m", false)
      end,
    },

    -- U
    { "Undo Make Float", ":lua require('toggleterm.terminal').Terminal:close_all()" },
    -- V

    -- W

    -- X

    -- Y

    -- Z
    { "Load Neovim Session", ":lua require('functions/sessions').load_session()" },
    { "Delete Neovim Session", ":lua require('functions/sessions').delete_session()" },
  }

  local opts = {}
  for _, action in pairs(actions) do
    table.insert(opts, {
      display = action[1],
      cmd = action[2],
    })
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Custom Palette",
      finder = require("telescope.finders").new_table({
        results = opts,
        entry_maker = function(entry)
          return {
            value = entry.cmd,
            display = entry.display,
            ordinal = entry.display,
          }
        end,
      }),
      sorter = require("telescope.config").values.generic_sorter({}),
      attach_mappings = function(_, map)
        map("i", "<CR>", function(prompt_bufnr)
          local selection = require("telescope.actions.state").get_selected_entry()
          require("telescope.actions").close(prompt_bufnr)
          if type(selection.value) == "function" then
            selection.value()
          else
            vim.cmd(selection.value)
          end
        end)
        return true
      end,
    })
    :find()
end

return M
