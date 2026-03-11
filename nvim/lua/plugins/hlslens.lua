return {
	"kevinhwang91/nvim-hlslens",
	event = "SearchWrapped",
	keys = {
		{ "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zzzv]], desc = "Next search result" },
		{ "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zzzv]], desc = "Prev search result" },
		{ "*", [[*<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word forward" },
		{ "#", [[#<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word backward" },
		{ "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word forward (partial)" },
		{ "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word backward (partial)" },
	},
	opts = {
		calm_down = true,
	},
}
