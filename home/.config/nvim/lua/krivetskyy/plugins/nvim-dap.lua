return {
	"mfussenegger/nvim-dap", -- dap installer
	"nvim-neotest/nvim-nio", -- fuck this plug
	lazy = false,
	enabled = true,
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			event = "VeryLazy",
			dependencies = "mfussenegger/nvim-dap",
			config = function()
				local dap = require("dap")
				local dapui = require("dapui")
				dapui.setup()
				dap.listeners.after.event_initialized["dapui_config"] = function()
					dapui.open()
				end
				dap.listeners.before.event_terminated["dapui_config"] = function()
					dapui.close()
				end
				dap.listeners.before.event_exited["dapui_config"] = function()
					dapui.close()
				end
			end,
		},
		"theHamsta/nvim-dap-virtual-text",
		"nvim-telescope/telescope-dap.nvim",
		"folke/neodev.nvim",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local virtual_text = require("nvim-dap-virtual-text")

		dap.defaults.fallback.exception_breakpoints = { "all" }

		dap.adapters.lldb = {
			type = "executable",
			command = "/usr/local/opt/llvm/bin/lldb-vscode",
			name = "lldb",
		}

		dap.adapters.codelldb = {
			type = "executable",
			command = "/usr/local/opt/llvm/bin/lldb-vscode",
			name = "lldb",
		}

		dap.configurations.c = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					local cwd = vim.fn.getcwd()
					return cwd .. "/bin/debug"
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
				runInTerminal = false,
				postRunCommands = { "process handle -p true -s false -n false SIGWINCH" },
			},
		}

		dap.configurations.cpp = dap.configurations.c
		dap.configurations.objc = dap.configurations.c
		dap.configurations.rust = dap.configurations.cpp

		local lldb = {
			name = "Launch lldb",
			type = "lldb", -- matches the adapter
			request = "launch", -- could also attach to a currently running process
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
			runInTerminal = false,
		}

		dap.configurations.cpp = {
			lldb,
		}

		dap.configurations.c = dap.configurations.cpp
		dap.configurations.rust = dap.configurations.cpp
		vim.keymap.set("n", "<F5>", function()
			require("dap").continue()
		end)
		vim.keymap.set("n", "<F10>", function()
			require("dap").step_over()
		end)
		vim.keymap.set("n", "<F11>", function()
			require("dap").step_into()
		end)
		vim.keymap.set("n", "<F12>", function()
			require("dap").step_out()
		end)
		vim.keymap.set("n", "<Leader>b", function()
			require("dap").toggle_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>B", function()
			require("dap").set_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>lp", function()
			require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end)
		vim.keymap.set("n", "<Leader>dr", function()
			require("dap").repl.open()
		end)
		vim.keymap.set("n", "<Leader>dl", function()
			require("dap").run_last()
		end)
		vim.keymap.set({ "n", "v" }, "<Leader>dw", function()
			require("dap.ui.widgets").hover()
		end)
		vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
			require("dap.ui.widgets").preview()
		end)
		vim.keymap.set("n", "<Leader>df", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.frames)
		end)
		vim.keymap.set("n", "<Leader>ds", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end)

		-- paste icon for breakpoint

		local widgets = require("dap.ui.widgets")
		vim.keymap.set("n", "<leader>i", widgets.hover, { desc = "DAP Inspect" })

		dapui.setup()
		virtual_text.setup()
	end,
}
