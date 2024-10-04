-- keymaps.lua

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open Global Command Palette
vim.api.nvim_set_keymap("n", "<Space>C", ":Telescope commands<CR>", { noremap = true, silent = true })

-- Open Custom Command Palette
vim.api.nvim_set_keymap(
  "n",
  "<Space>c",
  "<cmd>lua require('functions/palette').Show_custom_palette()<CR>",
  { noremap = true, silent = true }
)

-- Session Management
vim.api.nvim_set_keymap(
  "n",
  "<leader>ss",
  "<cmd>lua require('functions/sessions').save_session()<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>sl",
  "<cmd>lua require('functions/sessions').load_session()<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>sd",
  "<cmd>lua require('functions/sessions').delete_session()<CR>",
  { noremap = true, silent = true }
)
