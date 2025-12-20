return {
	{
		"stevearc/oil.nvim",
		-- lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local oil = require("oil")
			local actions = require("oil.actions")

			local open_with_window_picker = function()
				local entry = oil.get_cursor_entry()
				local dir = oil.get_current_dir()
				if not entry or not dir then
					return
				end
				local path = dir .. entry.name
				oil.close()

				local winid = require("window-picker").pick_window({
					filter_rules = {
						include_current_win = true,
					},
				})
				if not winid then
					return
				end
				vim.api.nvim_set_current_win(winid)
				vim.cmd("edit " .. vim.fn.fnameescape(path))
				-- local path = require("plenary.path")
				--
				-- actions.close(prompt_bufnr)
				-- local selected_entry = action_state.get_selected_entry()
				-- local _, entry_path = next(selected_entry)
				-- if not entry_path then
				-- 	return
				-- end
				-- local winid = require("window-picker").pick_window({
				-- 	filter_rules = {
				-- 		include_current_win = true,
				-- 	},
				-- })
				-- if not winid then
				-- 	return
				-- end
				-- local full_path = path:new(entry_path):absolute()
				-- vim.api.nvim_set_current_win(winid)
				-- vim.cmd("edit " .. vim.fn.fnameescape(full_path))
			end
			oil.setup({
				default_file_explorer = true,
				delete_to_trash = true,
				skip_confirm_for_simple_edits = true,
				columns = { "icon" },
				keymaps = {
					["<Esc>"] = "actions.close",
					["<C-h>"] = false,
					["<C-l>"] = false,
					["<C-k>"] = false,
					["<C-j>"] = false,
					["<C-v>"] = {
						actions.select,
						opts = { vertical = true, close = true },
						desc = "Open the entry in a vertical split",
					},
					["<C-s>"] = {
						actions.select,
						opts = { horizontal = true, close = true },
						desc = "Open the entry in a horizontal split",
					},
					["<C-x>"] = {
						open_with_window_picker,
						desc = "Open with window picker",
					},
				},
				win_options = {
					wrap = true,
				},
				view_options = {
					show_hidden = true,
					natural_order = true,
					is_always_hidden = function(name, _)
						return name == ".." or name == ".git"
					end,
				},
			})

			-- vim.api.nvim_create_autocmd("User", {
			-- 	pattern = "OilEnter",
			-- 	callback = vim.schedule_wrap(function(args)
			-- 		if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
			-- 			oil.open_preview()
			-- 		end
			-- 	end),
			-- })
		end,
		keys = {
			{
				"<leader>e",
				function()
					require("oil").open()
				end,
				desc = "Explorer (Oil)",
			},
		},
	},
}
