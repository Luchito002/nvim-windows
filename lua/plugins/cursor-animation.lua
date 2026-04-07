return {
  "sphamba/smear-cursor.nvim",
  enabled = true,
  opts = {
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    scroll_buffer_space = true,
    smear_insert_mode = true,
  },
  config = function()
    vim.opt.guicursor = "n-v-c:block-Cursor,i:block-Cursor"

    vim.api.nvim_set_hl(0, "Cursor", {
      fg = "#55f6ff",
      bg = "NONE",
      reverse = true,
    })
  end
}
