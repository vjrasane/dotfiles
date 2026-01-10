return {
	"ahmedkhalf/project.nvim",
	event = "VeryLazy",
	config = function()
		require("project_nvim").setup({
			detection_methods = { "pattern" },
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
			silent_chdir = true,
			show_hidden = true,
			ignore_lsp = { "tailwindcss", "jsonls", "emmet_ls" },
			exclude_dirs = { "~/.config/nvim/snippets" },
		})
	end,
}
