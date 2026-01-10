return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = false,
				command_palette = false,
				long_message_to_split = false,
				inc_rename = false,
				lsp_doc_border = true,
			},
			cmdline = {
				enabled = false,
			},
			messages = {
				enabled = false,
			},
			popupmenu = {
				enabled = false,
			},
			views = {
				hover = {
					border = { style = "rounded" },
				},
			},
		},
		config = function(_, opts)
			require("noice").setup(opts)

			-- Configure diagnostics with borders
			vim.diagnostic.config({
				float = {
					border = "rounded",
					source = "always",
				},
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{
		"petertriho/nvim-scrollbar",
		-- enabled = false,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("scrollbar").setup({
				show_in_active_only = true,
				max_lines = 50000,
				hide_if_all_visible = true,
				excluded_buftypes = {
					"terminal",
				},
				excluded_filetypes = {
					"cmp_docs",
					"cmp_menu",
					"noice",
					"prompt",
					"TelescopePrompt",
					"gitcommit",
				},
			})
		end,
	},
	{
		"rcarriga/nvim-notify",
		event = "VimEnter",
		config = function()
			vim.notify = require("notify")
		end,
	},
	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mini.indentscope").setup({
				symbol = "│",
				options = { try_as_border = true },
				draw = {
					animation = require("mini.indentscope").gen_animation.none(),
				},
			})
		end,
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
}
