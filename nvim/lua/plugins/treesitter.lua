return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup()

			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					if pcall(vim.treesitter.start) then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})

			require("nvim-treesitter").install({
				"bash", "c", "go", "gomod", "gosum",
				"json", "yaml", "diff", "html", "astro",
				"javascript", "typescript", "tsx", "css",
				"lua", "luadoc", "markdown", "markdown_inline",
				"nix", "python", "query", "vim", "vimdoc", "cooklang", "rust",
			})
		end,
	},
	{
		"davidmh/mdx.nvim",
		lazy = false,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
		},
		config = function()
			local hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
			---@diagnostic disable-next-line: missing-fields
			require("Comment").setup({
				pre_hook = function(ctx)
					local ok, result = pcall(hook, ctx)
					if ok then return result end
				end,
			})
		end,
	},
}
