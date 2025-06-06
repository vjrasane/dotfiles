return {
	"NeogitOrg/neogit",
  enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		"nvim-telescope/telescope.nvim", -- optional
		"ibhagwan/fzf-lua", -- optional
		"echasnovski/mini.pick", -- optional
	},
	config = true,
	keys = {
		{
			"<leader>gg",
			function()
				require("neogit").open()
			end,
			desc = "Open Neogit",
		},
	},
}
