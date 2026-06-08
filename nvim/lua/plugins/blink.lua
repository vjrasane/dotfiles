return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		event = "InsertEnter",
		dependencies = {
			"giuxtaposition/blink-cmp-copilot",
			"joshuarubin/iferr.nvim",
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				-- menu = { border = "single" },
				documentation = {
					auto_show = false,
					-- window = { border = "single" },
				},
			},
			signature = {
				enabled = true,
				-- window = { border = "single" }
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "copilot" },
				per_filetype = {
					go = { "iferr", "lsp", "path", "snippets", "buffer", "copilot" },
				},
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 0,
						async = true,
					},
					iferr = {
						name = "iferr",
						module = "iferr.adapters.blink",
						score_offset = 100,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		config = function(_, opts)
			opts.keymap["<C-y>"] = { "accept", require("iferr.adapters.blink").expand, "fallback" }
			require("blink.cmp").setup(opts)
		end,
		opts_extend = { "sources.default" },
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "InsertEnter", "BufReadPost" },
		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = true,
			},
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "InsertEnter",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
}
