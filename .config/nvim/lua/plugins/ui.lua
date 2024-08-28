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
					lualine_y = { "filetype" },
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
}
