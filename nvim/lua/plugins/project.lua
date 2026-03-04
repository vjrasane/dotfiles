return {
	"DrKJeff16/project.nvim",
	event = "VeryLazy",
	dependencies = {
		"folke/snacks.nvim",
	},
	config = function()
		require("project").setup({
			snacks = {
				enabled = true,
				opts = {
					hidden = false,
					sort = "newest",
					title = "Select Project",
					layout = "select",
				},
			},
			show_hidden = true,
			exclude_dirs = { "~/.config/nvim/snippets" },
			patterns = {
				".git",
				"_darcs",
				".hg",
				".bzr",
				".svn",
				"Makefile",
				"package.json",
				"lazy-lock.json",
				"tsconfig.json",
				".gitlab-ci.yml",
			},
		})
	end,
	keys = {
		{
			"<leader>sp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Select project",
		},
	},
}
