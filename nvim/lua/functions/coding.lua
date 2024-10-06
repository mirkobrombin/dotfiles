local M = {}

-- Helper function to extract the comment prefix
local function get_comment_prefix()
  local commentstring = vim.bo.commentstring
  if commentstring:find("%%s") then
    return commentstring:match("(.-)%%s")
  else
    return commentstring
  end
end

-- Removes all comments in the current file
M.remove_all_comments = function()
  local comment_prefix = get_comment_prefix()
  if not comment_prefix or comment_prefix == "" then
    print("No comment format found for this file")
    return
  end

  local result = vim.fn.search(vim.pesc(comment_prefix))
  if result == 0 then
    print("No comments found in this file")
    return
  end

  vim.cmd("%s/" .. vim.pesc(comment_prefix) .. ".*//g")
  print("All comments removed from the file")
end

-- Removes the comment from the current line
M.remove_comment_at_line = function()
  local comment_prefix = get_comment_prefix()
  if not comment_prefix or comment_prefix == "" then
    print("No comment format found for this file")
    return
  end

  local line_num = vim.fn.line(".")
  local line_content = vim.fn.getline(line_num)

  local updated_line = line_content:gsub(vim.pesc(comment_prefix) .. ".*", "")

  if updated_line == line_content then
    print("No comment found on this line")
    return
  end

  vim.fn.setline(line_num, updated_line)
  print("Comment removed from the current line")
end

-- Removes consecutive comment blocks
M.remove_comment_block = function()
  local line_num = vim.fn.line(".")
  local total_lines = vim.fn.line("$")

  local in_comment_block = false
  local first_comment_line = nil
  local last_comment_line = nil

  for current_line = line_num, total_lines do
    local line_content = vim.fn.getline(current_line)

    if not in_comment_block then
      if line_content:find("/%*") then
        in_comment_block = true
        first_comment_line = current_line
      end
    end

    if in_comment_block then
      if line_content:find("%*/") then
        last_comment_line = current_line
        break
      end
    end
  end

  if not first_comment_line or not last_comment_line then
    first_comment_line = line_num
    last_comment_line = line_num

    while first_comment_line > 1 do
      local line_content = vim.fn.getline(first_comment_line)
      if not line_content:match("^%s*//") and not line_content:match("^%s*#") then
        break
      end
      first_comment_line = first_comment_line - 1
    end
    first_comment_line = first_comment_line + 1

    while last_comment_line <= total_lines do
      local line_content = vim.fn.getline(last_comment_line)
      if not line_content:match("^%s*//") and not line_content:match("^%s*#") then
        break
      end
      last_comment_line = last_comment_line + 1
    end
    last_comment_line = last_comment_line - 1
  end

  if not first_comment_line or not last_comment_line or first_comment_line > last_comment_line then
    print("No comment block found")
    return
  end

  vim.cmd(first_comment_line .. "," .. last_comment_line .. "d")
  print("Comment block removed")
end

return M
