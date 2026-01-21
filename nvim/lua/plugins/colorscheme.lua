return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			integrations = {
				treesitter = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				cmp = true,
				gitsigns = true,
				telescope = { enabled = true },
				semantic_tokens = true,
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
