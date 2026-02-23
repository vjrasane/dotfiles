return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			custom_highlights = function(colors)
				return {
					LineNr = { fg = colors.overlay1 },
					CursorLineNr = { fg = colors.lavender, style = { "bold" } },
				}
			end,
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
