return {
	"s1n7ax/nvim-window-picker",
  enabled = false,
	config = function()
		require("window-picker").setup({
			hint = "floating-big-letter",
		})
	end,
}
