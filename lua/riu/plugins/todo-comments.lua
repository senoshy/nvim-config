local function setup_todo_comments()
  local todo_comments = require("todo-comments")

  todo_comments.setup({
    keywords = {
      FIX = {
        icon = " ",
        color = "error",
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
      },
      TODO = { icon = " ", color = "info", alt = { "Personal" } },
      HACK = { icon = " ", color = "warning", alt = { "DONTSKIP" } },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO", "READ", "COLORS", "Custom" } },
      TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      FORGETNOT = { icon = " ", color = "hint" },
    },
    highlight = {
      multiline = true,
      multiline_pattern = "^.",
      multiline_context = 10,
      before = "",
      keyword = "wide",
      after = "fg",
      pattern = {
        [[.*<(KEYWORDS)\s*:]],
        [[]],
        [[]],
      },
      comments_only = false,
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      pattern = [[\b(KEYWORDS)\b]],
    },
  })

  local keymap = vim.keymap.set

  -- File Navigation
  keymap("n", "]t", function()
    todo_comments.jump_next()
  end, { desc = "Next todo comment" })

  keymap("n", "[t", function()
    todo_comments.jump_prev()
  end, { desc = "Previous todo comment" })

  -- Project-Wide Search (Fully unlocked for NixOS!)
  keymap("n", "<leader>pt", function()
    require("snacks").picker.todo_comments()
  end, { desc = "All Todo Comments" })

  keymap("n", "<leader>pT", function()
    -- Changed "FIXME" to "FIX" because "FIX" is your defined canonical keyword
    require("snacks").picker.todo_comments({ keywords = { "TODO", "FORGETNOT", "FIX" } })
  end, { desc = "Main Todo Comments" })
end

return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = setup_todo_comments,
}
