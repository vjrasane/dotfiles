local ensure_installed = {
	"bash",
	"c",
	"go",
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
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({})
		require("nvim-treesitter").install(ensure_installed)
	end,
}

-- return {
-- 	{ -- Highlight, edit, and navigate code
-- 		"nvim-treesitter/nvim-treesitter",
-- 		branch = "main",
-- 		lazy = false,
-- 		dependencies = {
-- 			"nvim-treesitter/nvim-treesitter-textobjects",
-- 			{
-- 				"nvim-treesitter/nvim-treesitter-context",
-- 				opts = {},
-- 			},
-- 		},
-- 		build = ":TSUpdate",
-- 		-- main = "nvim-treesitter.configs", -- Sets main module to use for opts
-- 		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
-- 		opts = {
-- 			ensure_installed = ensure_installed,
-- 			-- Autoinstall languages that are not installed
-- 			auto_install = true,
-- 			highlight = {
-- 				enable = true,
-- 				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
-- 				--  If you are experiencing weird indenting issues, add the language to
-- 				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
-- 				additional_vim_regex_highlighting = { "ruby" },
-- 			},
-- 			indent = { enable = true, disable = { "ruby" } },
-- 			incremental_selection = {
-- 				enable = true,
-- 				keymaps = {
-- 					init_selection = "<C-space>",
-- 					node_incremental = "<C-space>",
-- 					scope_incremental = false,
-- 					node_decremental = "<bs>",
-- 				},
-- 			},
-- 			-- textobjects = textobjects,
-- 		},
-- 	},
-- 	{
-- 		"nvim-treesitter/nvim-treesitter-textobjects",
-- 		branch = "main",
-- 		event = { "BufReadPre", "BufNewFile" },
-- 		opts = {
-- 			move = {
-- 				enable = true,
-- 				goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
-- 				goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
-- 				goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
-- 				goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
-- 			},
-- 			select = {
-- 				enable = true,
-- 				lookahead = true,
-- 				keymaps = {
-- 					-- You can use the capture groups defined in textobjects.scm
-- 					["af"] = "@function.outer",
-- 					["if"] = "@function.inner",
-- 					["ac"] = "@class.outer",
-- 					-- You can optionally set descriptions to the mappings (used in the desc parameter of
-- 					-- nvim_buf_set_keymap) which plugins like which-key display
-- 					["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
-- 					-- You can also use captures from other query groups like `locals.scm`
-- 					["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
-- 				},
-- 				selection_modes = {
-- 					["@parameter.outer"] = "v", -- charwise
-- 					["@function.outer"] = "V", -- linewise
-- 					["@class.outer"] = "<c-v>", -- blockwise
-- 				},
-- 			},
-- 		},
-- 	},
-- 	{
-- 		"numToStr/Comment.nvim",
-- 		event = { "BufReadPre", "BufNewFile" },
-- 		dependencies = {
-- 			"nvim-treesitter/nvim-treesitter",
-- 			{ "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
-- 		},
-- 		config = function()
-- 			---@diagnostic disable-next-line: missing-fields
-- 			require("Comment").setup({
-- 				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
-- 			})
-- 		end,
-- 	},
-- }
