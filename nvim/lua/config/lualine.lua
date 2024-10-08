require("lualine").setup({
  sections = {
    lualine_c = {
      { "filename", path = 1 },
      { require("functions/now-playing").get_now_playing },
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
  },
})
