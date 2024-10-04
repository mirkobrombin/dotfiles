-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 80-char Column Marker
vim.opt.colorcolumn = "80"
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd([[highlight ColorColumn ctermbg=none guibg=#3e425f]])
  end,
})
