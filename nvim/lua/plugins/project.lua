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

		-- Guard against invalid buffers reaching buf_is_file. A nested
		-- BufEnter fires during nvim_win_set_buf on LSP definition jumps,
		-- where ev.buf may already be invalid. Upstream omits the check.
		local api = require("project.api")
		local orig_buf_is_file = api.buf_is_file
		api.buf_is_file = function(bufnr)
			if bufnr ~= nil and not vim.api.nvim_buf_is_valid(bufnr) then
				return false
			end
			return orig_buf_is_file(bufnr)
		end
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
