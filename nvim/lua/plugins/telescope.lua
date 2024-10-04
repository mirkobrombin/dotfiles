return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-telescope/telescope-file-browser.nvim" },
  config = function()
    require("telescope").setup({})
    require("telescope").load_extension("file_browser")
  end,
}
