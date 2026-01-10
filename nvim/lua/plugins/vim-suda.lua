return {
	"lambdalisue/vim-suda",
	event = { "BufReadPre", "BufNewFile" },
	cmd = {
		"SudaRead",
		"SudaWrite",
	},
}
