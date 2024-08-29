return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
		},
		opts = function()
			vim.o.laststatus = vim.g.lualine_laststatus

			return {
				options = {
					theme = "auto",
					globalstatus = true,
					section_separators = "",
					component_separators = "|",
					disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
				},
				sections = {
					lualine_a = { "branch" },
					lualine_b = { { "filename", path = 1 } },
					lualine_c = {},
					lualine_x = { "diff" },
					lualine_y = { { "filetype" }, { "encoding" } },
					lualine_z = { "location" },
				},
				extensions = { "neo-tree", "lazy", "oil" },
			}
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"petertriho/nvim-scrollbar",
		-- enabled = false,
		event = { "BufReadPre", "BufNewFile" },
		config = true,
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
