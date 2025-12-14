-- ~/.config/nvim/lua/plugins/dap.lua
return {
  ---------------------------------------------------------------------------
  -- Core DAP
  ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "DAP Continue/Start",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "DAP Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "DAP Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "DAP Step Out",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "DAP Conditional Breakpoint",
      },
      {
        "<leader>dl",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Logpoint message: "))
        end,
        desc = "DAP Logpoint",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "DAP REPL",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "DAP UI Toggle",
      },
    },
    config = function()
      local dap = require("dap")

      -- Signs (nice gutter icons)
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "✖", texthl = "DiagnosticHint", numhl = "" })

      -- Prefer project venv for debugpy; fall back to Mason
      local proj_py = vim.fn.getcwd() .. "/.venv/bin/python"
      local mason_py = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      local adapter_py = (vim.fn.executable(proj_py) == 1) and proj_py or mason_py

      dap.adapters.python = {
        type = "executable",
        command = adapter_py,
        args = { "-m", "debugpy.adapter" },
      }

      -- Base Python configs
      dap.configurations.python = dap.configurations.python
        or {
          {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            console = "integratedTerminal",
            justMyCode = false,
          },
          {
            type = "python",
            request = "attach",
            name = "Attach :5678",
            connect = { host = "127.0.0.1", port = 5678 },
            justMyCode = false,
            subProcess = true,
            redirectOutput = true,
          },
        }

      -- Streamlit: launch via module (no attach needed)
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Streamlit: launch (module, current file)",
        module = "streamlit",
        args = {
          "run",
          "${file}",
          "--server.address",
          "0.0.0.0",
          "--server.port",
          os.getenv("PORT") or "8501",
          "--server.headless",
          "true",
          "--server.runOnSave",
          "false",
        },
        console = "integratedTerminal",
        justMyCode = false,
        subProcess = true,
        cwd = vim.fn.getcwd(),
        env = {
          PYTHONPATH = vim.fn.getcwd(),
          STREAMLIT_SERVER_FILE_WATCHER_TYPE = "none",
        },
      })

      -- Load project-local configs
      pcall(function()
        require("dap.ext.vscode").load_launchjs(nil, { python = { "python" } })
      end)
      local local_dap = vim.fn.getcwd() .. "/.nvim/dap.lua"
      if vim.fn.filereadable(local_dap) == 1 then
        pcall(dofile, local_dap)
      end

      -- Convenience command
      vim.api.nvim_create_user_command("DebugUIToggle", function()
        require("dapui").toggle()
      end, {})

      -- Robust auto-open (avoid race)
      local dapui_ok, dapui = pcall(require, "dapui")
      if dapui_ok then
        dap.listeners.after.event_initialized["dapui_auto"] = function()
          vim.defer_fn(function()
            dapui.open()
          end, 50)
        end
        dap.listeners.before.event_terminated["dapui_auto"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_auto"] = function()
          dapui.close()
        end
      end
    end,
  },

  ---------------------------------------------------------------------------
  -- UI (fill all fields to silence diagnostics) + required dependency
  ---------------------------------------------------------------------------
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio", -- REQUIRED
    },
    config = function()
      local dapui = require("dapui")
      dapui.setup({
        -- add the fields your diagnostics are asking for:
        icons = { expanded = "▾", collapsed = "▸", current_frame = "➤" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        element_mappings = {}, -- you can add per-element mappings later
        expand_lines = true,
        force_buffers = true,
        floating = {
          max_height = 0.9,
          max_width = 0.9,
          border = "rounded",
          mappings = { close = { "q", "<Esc>" } },
        },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
        controls = {
          enabled = false, -- keep toolbar off (you use keymaps)
          element = "repl",
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⤶",
            step_over = "⤼",
            step_out = "⤷",
            step_back = "⟲",
            run_last = "↻",
            terminate = "■",
          },
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40, -- columns
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10, -- lines
            position = "bottom",
          },
        },
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- Inline variable values
  ---------------------------------------------------------------------------
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
    config = true,
  },

  ---------------------------------------------------------------------------
  -- Adapter installer/manager (no auto setup to avoid double config)
  ---------------------------------------------------------------------------
  {
    "jay-babu/mason-nvim-dap.nvim",
    lazy = true,
    dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "python" },
      automatic_setup = false,
    },
  },
}
