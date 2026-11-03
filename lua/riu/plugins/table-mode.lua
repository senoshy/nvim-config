local function setup_table_mode()
  vim.g.table_mode_corner = "|"
  vim.g.table_mode_corner_corner = "+"
  vim.g.table_mode_header_fillchar = "="
end

return {
  "dhruvasagar/vim-table-mode",
  event = { "BufReadPost", "BufNewFile" },
  config = setup_table_mode,
}
