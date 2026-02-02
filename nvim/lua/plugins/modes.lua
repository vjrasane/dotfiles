return {
	"vjrasane/modes.nvim",
	event = "VeryLazy",
	config = function()
		require("modes").setup({
			colors = {
				insert = "#a6e3a1",
				visual = "#cba6f7",
				replace = "#f38ba8",
				copy = "#f9e2af",
				delete = "#f38ba8",
				change = "#fab387",
			},
			line_opacity = 0.15,
			set_cursor = false,
			set_cursorline = true,
			set_number = true,
		})
	end,
}
