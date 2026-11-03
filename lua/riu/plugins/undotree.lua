return {
  "mbbill/undotree",
  config = function()
    if vim.fn.exists(":UndotreeToggle") ~= 1 then
      return
    end
    vim.keymap.set("n", "<leader>u", "<CMD>UndotreeToggle<CR>", { desc = "Toggle Undo Tree Visualizer" })
  end,
}
