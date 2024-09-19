return {
	"nvim-lualine/lualine.nvim",
	event = "UiEnter",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	opts = function()
		vim.o.laststatus = vim.g.lualine_laststatus

		local function cwd()
			local home = vim.env.HOME
			local current_dir = vim.fn.getcwd()
			return current_dir:gsub(home, "~")
		end

		return {
			options = {
				theme = "auto",
				globalstatus = true,
				section_separators = "",
				component_separators = "|",
				disabled_filetypes = {
					statusline = { "dashboard", "alpha", "starter" },
					winbar = { "oil" },
				},
			},
			sections = {
				lualine_a = {
					{ "filename", path = 1 },
				},
				lualine_b = { "diff" },
				lualine_c = {},
				lualine_x = {},
				lualine_y = { { "filetype" }, { "encoding" } },
				lualine_z = { "location" },
			},
			winbar = {
				lualine_a = {},
				lualine_b = { "filename" },
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "neo-tree", "lazy", "oil" },
		}
	end,
}
