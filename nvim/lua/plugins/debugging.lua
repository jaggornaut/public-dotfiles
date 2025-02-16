return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
			{
				"julianolf/nvim-dap-lldb",
				dependencies = { "mfussenegger/nvim-dap" },
			},
		},
		config = function()
			local bin_locations = vim.fn.stdpath("data") .. "/mason/bin/"
			local dap = require("dap")

			local dapui = require("dapui")

			require("dapui").setup()

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			vim.keymap.set("n", "<F5>", dap.continue, {})
			vim.keymap.set("n", "<F10>", dap.step_over, {})
			vim.keymap.set("n", "<F11>", dap.step_into, {})
			vim.keymap.set("n", "<F12>", dap.step_out, {})
			vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, {})

			-------------------------------C/C++/Rust
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				host = "127.0.0.1",
				executable = {
					command = bin_locations .. "codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					runInTerminal = false,
				},
			}

			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp
		end,
	},
}
