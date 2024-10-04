local M = {}

-- Note-Taking Management
M.notes_open = false
M.note_windows = {}
M.note_buffers = {}

function M.toggle_notes()
  if M.notes_open then
    M.close_notes()
  else
    M.open_notes()
  end
end

function M.open_notes()
  local note_dir = vim.fn.expand("~/.nvim-notes")
  vim.fn.mkdir(note_dir, "p")

  local notes = {}
  for _, file in ipairs(vim.fn.readdir(note_dir)) do
    table.insert(notes, file)
  end

  if #notes == 0 then
    M.new_note()
    return
  end

  -- Set a grid layout for the notes
  local total_notes = #notes
  local cols = math.ceil(math.sqrt(total_notes))
  local rows = math.ceil(total_notes / cols)
  local win_width = math.floor(vim.o.columns / cols)
  local win_height = math.floor(vim.o.lines / rows)

  M.note_windows = {}
  M.note_buffers = {}

  for idx, note_file in ipairs(notes) do
    local col = ((idx - 1) % cols) * win_width
    local row = math.floor((idx - 1) / cols) * win_height

    local note_path = note_dir .. "/" .. note_file

    local buf = vim.api.nvim_create_buf(false, true)
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
      print("Failed to create buffer for note: " .. note_file)
      goto continue
    end

    -- Set buffer options
    vim.bo[buf].buftype = "acwrite"
    vim.bo[buf].bufhidden = "hide"
    vim.bo[buf].filetype = "markdown"

    -- Load the note content
    local content = {}
    local file = io.open(note_path, "r")
    if file then
      for line in file:lines() do
        table.insert(content, line)
      end
      file:close()
    else
      print("Failed to open note file: " .. note_path)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

    -- Set up the floating window
    local opts = {
      style = "minimal",
      relative = "editor",
      width = win_width,
      height = win_height,
      row = row,
      col = col,
      border = "rounded",
    }

    local win = vim.api.nvim_open_win(buf, true, opts)
    if not win or not vim.api.nvim_win_is_valid(win) then
      print("Failed to open window for note: " .. note_file)
      goto continue
    end

    -- Trak notes windows and buffers
    table.insert(M.note_windows, win)
    table.insert(M.note_buffers, buf)

    local current_note_path = note_path

    -- Auto-save note content on change
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufLeave" }, {
      buffer = buf,
      callback = function()
        M.save_note(buf, current_note_path)
      end,
    })

    ::continue::
  end

  M.notes_open = true
end

function M.close_notes()
  if M.note_windows then
    for _, win in ipairs(M.note_windows) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end
    M.note_windows = {}
  end
  if M.note_buffers then
    for _, buf in ipairs(M.note_buffers) do
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
    M.note_buffers = {}
  end
  M.notes_open = false
end

function M.save_note(buf, note_path)
  if not buf or not note_path then
    print("Invalid buffer or note path")
    return
  end

  if not vim.api.nvim_buf_is_valid(buf) then
    print("Buffer is not valid")
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local file = io.open(note_path, "w")
  if file then
    for _, line in ipairs(lines) do
      file:write(line .. "\n")
    end
    file:close()
  else
    print("Failed to save note to file: " .. note_path)
  end
end

function M.new_note()
  local note_dir = vim.fn.expand("~/.nvim-notes")
  vim.fn.mkdir(note_dir, "p")
  local note_name = vim.fn.input("Note name: ")
  if note_name == "" then
    print("Note name cannot be empty.")
    return
  end
  local note_path = note_dir .. "/" .. note_name .. ".md"
  local new_file = io.open(note_path, "w")
  if new_file then
    new_file:write("# " .. note_name .. "\n")
    new_file:close()

    -- Ref resh notes if they are open
    if M.notes_open then
      M.close_notes()
      M.open_notes()
    end
  else
    print("Failed to create new note file: " .. note_path)
  end
end

function M.delete_note()
  local note_dir = vim.fn.expand("~/.nvim-notes")
  print("Notes dir is: " .. note_dir)

  require("telescope.builtin").find_files({
    prompt_title = "< Delete Note >",
    cwd = note_dir,
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local function delete_selected()
        local selection = action_state.get_selected_entry()
        if not selection then
          print("No note selected")
          return
        end

        local note_path = note_dir .. "/" .. selection.value

        if not note_path or note_path == "" then
          print("Could not determine the path of the selected note")
          return
        end

        actions.close(prompt_bufnr)
        local confirm = vim.fn.confirm("Delete note: " .. selection.value .. "?", "&Yes\n&No", 2)
        if confirm == 1 then
          local success, err = os.remove(note_path)
          if success then
            print("Deleted note: " .. selection.value)

            -- Refresh notes if they are open
            if M.notes_open then
              M.close_notes()
              M.open_notes()
            end
          else
            print("Failed to delete note due to error: " .. err)
          end
        else
          print("Deletion canceled")
        end
      end

      map("i", "<CR>", delete_selected)
      map("n", "<CR>", delete_selected)

      return true
    end,
  })
end

return M
