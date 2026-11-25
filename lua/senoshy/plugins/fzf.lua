return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-mini/mini.icons" },
  ---@module "fzf-lua"
  ---@type fzf-lua.Config|{}
  ---@diagnostic disable: missing-fields
  opts = {},
  ---@diagnostic enable: missing-fields
  keys = {
    { "<leader>sf", function() require("fzf-lua").files() end, desc = "[S]earch [F]iles" },
    { "<leader>sg", function() require("fzf-lua").live_grep() end, desc = "[S]earch by [G]rep" },
    { "<leader>sw", function() require("fzf-lua").grep_cword() end, desc = "[S]earch current [W]ord" },
    { "<leader>sb", function() require("fzf-lua").buffers() end, desc = "[S]earch [B]uffers" },
    { "<leader>sh", function() require("fzf-lua").helptags() end, desc = "[S]earch [H]elp" },
    { "<leader>sk", function() require("fzf-lua").keymaps() end, desc = "[S]earch [K]eymaps" },
    { "<leader>sc", function() require("fzf-lua").commands() end, desc = "[S]earch [C]ommands" },
    { "<leader>sd", function() require("fzf-lua").diagnostics_document() end, desc = "[S]earch [D]iagnostics" },
    { "<leader>sD", function() require("fzf-lua").diagnostics_workspace() end, desc = "[S]earch workspace [D]iagnostics" },
    { "<leader>ds", function() require("fzf-lua").lsp_document_symbols() end, desc = "[D]ocument [S]ymbols" },
    { "<leader>ws", function() require("fzf-lua").lsp_workspace_symbols() end, desc = "[W]orkspace [S]ymbols" },
    { "<leader>sm", function() require("fzf-lua").marks() end, desc = "[S]earch [M]arks" },
    { "<leader>s.", function() require("fzf-lua").oldfiles() end, desc = "[S]earch recent files" },
    { "<leader>sr", function() require("fzf-lua").resume() end, desc = "[S]earch [R]esume" },
    { "<leader>gs", function() require("fzf-lua").git_status() end, desc = "[G]it [S]tatus" },
    { "<leader>gc", function() require("fzf-lua").git_commits() end, desc = "[G]it [C]ommits" },
  },
}
