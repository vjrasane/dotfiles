return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
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

		local function repo()
			local repo_path = vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'")
			local repo_name = vim.fs.basename(repo_path)
			return repo_name
		end

		local git_ext = {
			sections = {
				lualine_a = {
					{ repo },
				},
				lualine_b = { "branch" },
				lualine_c = {},
				lualine_x = {},
				lualine_y = { { "filetype" }, { "encoding" } },
				lualine_z = { "location" },
			},
			disabled_filetypes = {
				winbar = "gitcommit",
			},
			filetypes = { "gitcommit" },
		}
		return {
			options = {
				theme = "auto",
				globalstatus = true,
				section_separators = "",
				component_separators = "|",
				disabled_filetypes = {
					statusline = { "dashboard", "alpha", "starter" },
					winbar = { "oil", "gitcommit" },
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
			extensions = { "neo-tree", "lazy", "oil", "mason", git_ext },
		}
	end,
}
