return {
	{
		"nvim-telescope/telescope.nvim",
		version = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"ahmedkhalf/project.nvim",
		},
		config = function()
			require("telescope").setup({})
			require("telescope").load_extension("projects")
		end,
		keys = {
			{
				"<leader>sp",
				function()
					local telescope_actions = require("telescope.actions")
					local telescope_state = require("telescope.actions.state")
					local project_mod = require("project_nvim.project")

					require("telescope").extensions.projects.projects({
						attach_mappings = function(prompt_bufnr)
							telescope_actions.select_default:replace(function()
								local selected = telescope_state.get_selected_entry(prompt_bufnr)
								if not selected then
									return
								end
								telescope_actions.close(prompt_bufnr)
								project_mod.set_pwd(selected.value, "telescope")
								require("oil").open(selected.value)
							end)
							return true
						end,
					})
				end,
			},
		},
	},
}
