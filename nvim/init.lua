-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.lualine")

-- WTF MENU
function ShowShortcuts()
  vim.cmd("new")
  vim.cmd("resize 15")
  vim.cmd("vertical resize 50")
  local lines = {
    "--- LEADER SHORTCUTS ---",
    "Leader → / -- SEARCH BY CONTENT",
    "Leader → e -- SHOW TREE",
    "Leader → f → c -- SEARCH IN FILES",
    "",
    "--- INSERT MODE SHORTCUTS ---",
    "CTRL + Enter -- ACCEPT SUGGESTION",
    "",
    "--- VISUAL MODE SHORTCUTS ---",
    "CTRL + s -- SAVE CHANGES",
    "",
    "--- VISUAL MODE COMMANDS ---",
    ":terminal -- OPEN NEW TERMINAL",
    ":split -- SPLIT CURRENT BUFFER (Y axis)",
    ":vsplit -- SPLIT CURRENT BUFFER (X axis)",
  }
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.buflisted = false
  vim.bo.swapfile = false
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.bo.modifiable = false
  vim.wo.spell = false
  vim.cmd("wincmd J")
end

vim.api.nvim_create_user_command("Wtf", ShowShortcuts, {})
vim.opt.relativenumber = false
