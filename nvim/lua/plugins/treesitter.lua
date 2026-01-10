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

local ensure_installed = {
	"bash",
	"c",
	"json",
	"yaml",
	"diff",
	"html",
	"astro",
	"javascript",
	"typescript",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"vim",
	"vimdoc",
}

return {

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {},
			},
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = ensure_installed,
				auto_install = true,
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
