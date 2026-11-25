return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',
    'mfussenegger/nvim-dap-python',
    'jbyuki/one-small-step-for-vimkind',
  },
  keys = {
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start / Continue' },
    { '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F12>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>dc', function() require('dap').continue() end, desc = '[D]ebug: [C]ontinue / Start' },
    { '<leader>do', function() require('dap').step_over() end, desc = '[D]ebug: Step [O]ver' },
    { '<leader>di', function() require('dap').step_into() end, desc = '[D]ebug: Step [I]nto' },
    { '<leader>dO', function() require('dap').step_out() end, desc = '[D]ebug: Step [O]ut' },
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = '[D]ebug: Toggle [B]reakpoint' },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end,
      desc = '[D]ebug: Conditional [B]reakpoint',
    },
    { '<leader>du', function() require('dapui').toggle() end, desc = '[D]ebug: Toggle [U]I' },
    { '<leader>de', function() require('dapui').eval() end, mode = { 'n', 'v' }, desc = '[D]ebug: [E]val' },
    { '<leader>dr', function() require('dap').repl.open() end, desc = '[D]ebug: Open [R]EPL' },
    { '<leader>dt', function() require('dap').terminate() end, desc = '[D]ebug: [T]erminate' },
    {
      '<leader>dl',
      function()
        require('osv').launch({ port = 8086 })
      end,
      desc = '[D]ebug: Launch [L]ua (Neovim) server',
    },
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    dapui.setup()
    require('nvim-dap-virtual-text').setup()

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticInfo', linehl = 'Visual' })

    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    -- C / C++ / Rust via codelldb
    dap.adapters.codelldb = {
      type = 'executable',
      command = 'codelldb',
    }

    local codelldb_c_cpp = {
      {
        name = 'Launch executable (codelldb)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
      {
        name = 'Attach to process (codelldb)',
        type = 'codelldb',
        request = 'attach',
        pid = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
      },
    }
    dap.configurations.c = codelldb_c_cpp
    dap.configurations.cpp = codelldb_c_cpp

    dap.configurations.rust = {
      {
        name = 'Launch Rust binary (codelldb)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
      {
        name = 'Attach to process (codelldb)',
        type = 'codelldb',
        request = 'attach',
        pid = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
      },
    }

    -- Python via debugpy
    local debugpy = vim.fn.executable('debugpy-python') == 1 and 'debugpy-python' or 'python3'
    require('dap-python').setup(debugpy)

    -- Lua (Neovim) via one-small-step-for-vimkind
    dap.adapters.nlua = function(callback, config)
      callback({
        type = 'server',
        host = config.host or '127.0.0.1',
        port = config.port or 8086,
      })
    end
    dap.configurations.lua = {
      {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance',
      },
    }
  end,
}
