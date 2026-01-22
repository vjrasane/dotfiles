return {
	{
		"nvim-telescope/telescope.nvim",
		-- cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-frecency.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"ahmedkhalf/project.nvim",
		},
		opts = function()
			local actions = require("telescope.actions")

			return {
				pickers = {},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					frecency = {
						db_safe_mode = false,
						show_unindexed = true,
						show_filter_column = false,
						matcher = "fuzzy",
						recency_values = {
							{ age = 4, value = 40 },
							{ age = 14, value = 30 },
							{ age = 31, value = 20 },
							{ age = 90, value = 10 },
							{ age = 240, value = 5 },
							{ age = 1440, value = 2 },
						},
					},
				},
				defaults = {
					hidden = true,
					sorting_strategy = "descending",
					layout_strategy = "flex",
					layout_config = {
						flex = {
							flip_columns = 100, -- switch to vertical layout when width < 100
						},
						horizontal = {
							preview_width = 0.55,
							preview_cutoff = 100, -- hide preview when width < 100 columns
							prompt_position = "bottom",
						},
						vertical = {
							preview_height = 0.5,
							preview_cutoff = 30, -- hide preview when height < 30 (ensures ~10 results visible)
							prompt_position = "bottom",
						},
					},
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
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up,
							["<C-s>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
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
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("file_browser")
			require("telescope").load_extension("frecency")
			require("telescope").load_extension("projects")
		end,
		keys = {
			{
				"<leader>st",
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
					require("telescope").extensions.frecency.frecency({
						workspace = "CWD",
					})
				end,
				desc = "Find Files (frecency)",
			},
			{
				"<leader>F",
				function()
					require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
				end,
				desc = "Find Files (incl. ignored)",
			},
			{ "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			{
				"<leader>R",
				function()
					require("telescope.builtin").oldfiles({ only_cwd = false })
				end,
				desc = "Recent (all)",
			},
			{
				"<leader>sc",
				function()
					require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config"), hidden = true })
				end,
				desc = "Find Config File",
			},
			-- {
			-- 	"<leader>sL",
			-- 	function()
			-- 		require("utils.telescope").find_logs()
			-- 	end,
			-- 	desc = "Find Logs",
			-- },
			{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
			{
				"<leader>sg",
				function()
					require("telescope.builtin").live_grep({
						additional_args = { "--hidden" },
					})
				end,
				desc = "Grep",
			},
			{
				"<leader>sG",
				function()
					require("telescope.builtin").live_grep({
						additional_args = { "--hidden", "--no-ignore" },
					})
				end,
				desc = "Grep (incl. ignored)",
			},
			{
				"<leader>sw",
				function()
					require("telescope.builtin").grep_string({
						additional_args = { "--hidden" },
					})
				end,
				desc = "Word under cursor",
			},
			{
				"<leader>j",
				function()
					require("telescope.builtin").jumplist()
				end,
				desc = "Jumplist",
			},
			-- {
			-- 	"<leader>sG",
			-- 	function()
			-- 		require("telescope.builtin").live_grep({ cwd = require("config.root").get_cwd_root() })
			-- 	end,
			-- 	desc = "Grep (root)",
			-- },
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
			{ "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
			-- {
			-- 	"<leader>sS",
			-- 	function()
			-- 		require("telescope.builtin").lsp_dynamic_workspace_symbols({
			-- 			symbols = require("utils.telescope").kind_filter,
			-- 		})
			-- 	end,
			-- 	desc = "Goto Symbol (Workspace)",
			-- },
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
