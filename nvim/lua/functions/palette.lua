local M = {}

-- Custom Command Palette
function M.Show_custom_palette()
  local actions = {
    -- A

    -- B
    { "Buffers: Delete All Buffers", ":bufdo bd" },
    { "Backup: Backup Current File", ":lua require('functions/backup').backup_file()" },

    -- C
    { "Comments: Remove All Comments", ":lua require('functions/coding').remove_all_comments()" },
    { "Comments: Remove Comment at Line", ":lua require('functions/coding').remove_comment_at_line()" },
    { "Comments: Remove Comment Block", ":lua require('functions/coding').remove_comment_block()" },

    -- D
    { "Dashboard: Open Dashboard", ":Dashboard" },
    { "Diagnostics: Show Diagnostics", ":Trouble diagnostics toggle" },

    -- E
    { "Edit: Select All and Copy", ":lua vim.cmd('normal! ggVGy')" },

    -- F
    { "Files: Delete Current File", ":lua vim.fn.delete(vim.fn.expand('%')) | bdelete!" },
    { "Files: New File", ":enew" },
    { "Files: New File in Current Path", ":lua require('functions/files').create_new_file()" },
    { "Files: New File Picking the Path", ":lua require('functions/files').create_file_with_telescope()" },
    { "Files: Open File", ":Telescope find_files" },
    { "Files: Open Recent", ":Telescope oldfiles" },
    { "Files: Rename Current File", ":lua require('functions/files').rename_current_file()" },
    { "Files: Save All Files", ":wa" },
    { "Files: Save Current File", ":w" },

    -- G
    { "Git: LazyGit", ":LazyGit" },

    -- H

    -- I

    -- J

    -- K

    -- L
    { "Lazy: Install and Update Plugins", ":Lazy" },
    { "Lazy: Extra Commands", ":LazyExtras" },

    -- M
    { "Music: Play / Pause", ":lua require('functions/now-playing').toggle_play_pause()" },

    -- N
    { "Notes: Create New Note", ":lua require('functions/notes').new_note()" },
    { "Notes: Delete Note", ":lua require('functions/notes').delete_note()" },
    { "Notes: Toggle Notes", ":lua require('functions/notes').toggle_notes()" },

    -- O
    {
      "Outline: Toggle Outline",
      function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Space>cs", true, false, true), "m", false)
      end,
    },

    -- P

    -- Q
    { "Quit: Quit", ":q" },
    { "Quit: Quit All", ":qa" },
    { "Quit: Quit All Without Saving", ":qa!" },

    -- R

    -- S
    { "Sessions: Save Neovim Session", ":lua require('functions/sessions').save_session()" },
    { "Sessions: Load Neovim Session", ":lua require('functions/sessions').load_session()" },
    { "Sessions: Delete Neovim Session", ":lua require('functions/sessions').delete_session()" },
    { "Search: Find Word in Current Directory", ":Telescope live_grep" },
    { "Search: Find and Replace in Current File", ":lua require('functions/find-replace').find_and_replace()" },
    { "Search: Show Symbols Outline", ":Telescope lsp_document_symbols" },

    -- T
    { "Terminal: New Terminal", ":split | terminal" },
    { "Terminal: Undo Make Float", ":lua require('toggleterm.terminal').Terminal:close_all()" },
    {
      "Terminal: Make Float",
      ":lua require('toggleterm.terminal').Terminal:new({ direction = 'float' }):toggle()",
    },
    { "Tasks: TODOs", ":TodoTelescope" },

    -- U

    -- V

    -- W

    -- X

    -- Y

    -- Z
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
