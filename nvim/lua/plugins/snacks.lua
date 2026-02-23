return {
	{
		"folke/snacks.nvim",
		lazy = false,
		---@type snacks.Config
		opts = {
			picker = {
				sources = {
					files = {
						hidden = true,
						exclude = { "node_modules" },
					},
					grep = {
						hidden = true,
						exclude = { "node_modules" },
					},
				},
				matcher = {
					smartcase = true,
				},
				win = {
					input = {
						keys = {
							["<C-c>"] = { "close", mode = { "i", "n" } },
							["<C-s>"] = { "edit_split", mode = { "i", "n" } },
							["<C-v>"] = { "edit_vsplit", mode = { "i", "n" } },
							["<C-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
							["<C-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
						},
					},
					list = {
						keys = {
							["q"] = "close",
						},
					},
				},
				layout = {
					preset = function()
						return vim.o.columns >= 100 and "default" or "vertical"
					end,
				},
			},
		},
		keys = {
			{ "<leader>f", function() Snacks.picker.files() end, desc = "Find Files" },
			{ "<leader>F", function() Snacks.picker.files({ ignored = true }) end, desc = "Find Files (incl. ignored)" },
			{ "<leader>b", function() Snacks.picker.buffers() end, desc = "Buffers" },
			{ "<leader>r", function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = "Recent" },
			{ "<leader>R", function() Snacks.picker.recent() end, desc = "Recent (all)" },
			{ "<leader>j", function() Snacks.picker.jumps() end, desc = "Jumplist" },
			{ "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
			{ "<leader>sG", function() Snacks.picker.grep({ ignored = true }) end, desc = "Grep (incl. ignored)" },
			{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Word under cursor" },
			{ "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer" },
			{ "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Document diagnostics" },
			{ "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Workspace diagnostics" },
			{ "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
			{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Key Maps" },
			{ "<leader>sm", function() Snacks.picker.marks() end, desc = "Jump to Mark" },
			{ "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
			{ "<leader>sH", function() Snacks.picker.highlights() end, desc = "Search Highlight Groups" },
			{ "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
			{ "<leader>s:", function() Snacks.picker.command_history() end, desc = "Command History" },
			{ '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
			{ "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
			{ "<leader>sc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
			{ "<leader>st", function() Snacks.picker.pickers() end, desc = "Find Pickers" },
			{ "<leader>gc", function() Snacks.picker.git_log() end, desc = "commits" },
			{ "<leader>gs", function() Snacks.picker.git_status() end, desc = "status" },
			{ "<leader>B", function() Snacks.picker.explorer() end, desc = "Browse Files" },
		},
	},
}
