local textobjects = {
	move = {
		enable = true,
		goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
		goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
		goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
		goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
	},
	select = {
		enable = true,
		lookahead = true,
		keymaps = {
			-- You can use the capture groups defined in textobjects.scm
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			-- You can optionally set descriptions to the mappings (used in the desc parameter of
			-- nvim_buf_set_keymap) which plugins like which-key display
			["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
			-- You can also use captures from other query groups like `locals.scm`
			["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
		},
		selection_modes = {
			["@parameter.outer"] = "v", -- charwise
			["@function.outer"] = "V", -- linewise
			["@class.outer"] = "<c-v>", -- blockwise
		},
	},
}

return {

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		version = false,
		lazy = false,
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {},
			},
		},
		config = function()
			-- Parsers installed via Nix, just enable highlighting
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
	-- TODO: Uncomment when nvim-treesitter-textobjects supports new nvim-treesitter API
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- 	config = function()
	-- 		require("nvim-treesitter-textobjects").setup(textobjects)
	-- 	end,
	-- },
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			{ "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
		},
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
}
