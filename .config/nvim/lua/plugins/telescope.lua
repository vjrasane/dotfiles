return {
	{
		"nvim-telescope/telescope.nvim",
		-- cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-file-browser.nvim",
			"ahmedkhalf/project.nvim",
			"s1n7ax/nvim-window-picker",
		},
		opts = function()
			local actions = require("telescope.actions")
			local open_with_window_picker = function(prompt_bufnr)
				local action_state = require("telescope.actions.state")
				local path = require("plenary.path")

				actions.close(prompt_bufnr)
				local selected_entry = action_state.get_selected_entry()
				local _, entry_path = next(selected_entry)
				if not entry_path then
					return
				end
				local winid = require("window-picker").pick_window({
					filter_rules = {
						include_current_win = true,
					},
				})
				if not winid then
					return
				end
				local full_path = path:new(entry_path):absolute()
				vim.api.nvim_set_current_win(winid)
				vim.cmd("edit " .. vim.fn.fnameescape(full_path))
			end

			return {
				pickers = {},
				extensions = {},
				defaults = {
					hidden = true,
					sorting_strategy = "ascending", -- layout_strategy = "center",
					layout_strategy = "center",
					file_ignore_patterns = {
						"node_modules",
					},
					prompt_prefix = " ",
					selection_caret = "\u{e602} ",
					-- open files in the first window that is an actual file.
					-- use the current window if no other window is available.
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == "" then
								return win
							end
						end
						return 0
					end,
					mappings = {
						i = {
							["<C-c>"] = actions.close,
							["<a-i>"] = find_files_no_ignore,
							["<a-h>"] = find_files_with_hidden,
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up,
							["<C-s>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-x>"] = open_with_window_picker,
						},
						n = {
							["q"] = actions.close,
						},
					},
				},
			}
		end,
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("file_browser")
			require("telescope").load_extension("projects")
		end,
		keys = {
			{
				"<leader>t",
				function()
					require("telescope.builtin").builtin()
				end,
				desc = "Find Telescope Pickers",
			},
			{
				"<leader>b",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Buffers",
			},
			{
				"<leader>f",
				function()
					require("telescope.builtin").find_files({ hidden = true })
				end,
				desc = "Find Files (cwd)",
			},
			{ "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			{
				"<leader>sc",
				function()
					require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>sL",
				function()
					require("utils.telescope").find_logs()
				end,
				desc = "Find Logs",
			},
			{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
			{
				"<leader>sg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>sj",
				function()
					require("telescope.builtin").jumplist()
				end,
				desc = "Jumplist",
			},
			{
				"<leader>sG",
				function()
					require("telescope.builtin").live_grep({ cwd = require("config.root").get_cwd_root() })
				end,
				desc = "Grep (root)",
			},
			{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
			{ "<leader>s:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sA", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{
				"<leader>sS",
				function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols({
						symbols = require("utils.telescope").kind_filter,
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
			{
				"<leader>B",
				":Telescope file_browser path=%:p:h=%:p:h<cr>",
				desc = "Browse Files",
				silent = true,
			},
			{
				"<leader>sp",
				function()
					local ex = require("telescope").extensions.projects
					ex.projects()
				end,
			},
		},
	},
}
