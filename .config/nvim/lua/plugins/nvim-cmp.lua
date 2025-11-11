return {
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			-- {
			-- 	"L3MON4D3/LuaSnip",
   --      enabled = false,
			-- 	build = (function()
			-- 		-- Build Step is needed for regex support in snippets.
			-- 		-- This step is not supported in many windows environments.
			-- 		-- Remove the below condition to re-enable on windows.
			-- 		if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
			-- 			return
			-- 		end
			-- 		return "make install_jsregexp"
			-- 	end)(),
			-- 	dependencies = {
			-- 		-- `friendly-snippets` contains a variety of premade snippets.
			-- 		--    See the README about individual language/framework/plugin snippets:
			-- 		--    https://github.com/rafamadriz/friendly-snippets
			-- 		{
			-- 			"rafamadriz/friendly-snippets",
			-- 			config = function()
			-- 				require("luasnip.loaders.from_vscode").lazy_load()
			-- 			end,
			-- 		},
			-- 	},
			-- },
			-- "saadparwaiz1/cmp_luasnip",

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			{ "petertriho/cmp-git", dependencies = "nvim-lua/plenary.nvim" },
			{
				"zbirenbaum/copilot-cmp",
				config = function()
					require("copilot_cmp").setup()
				end,
			},
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			-- local luasnip = require("luasnip")
			-- luasnip.config.setup({})

			cmp.setup({
				-- snippet = {
				-- 	expand = function(args)
				-- 		luasnip.lsp_expand(args.body)
				-- 	end,
				-- },
				completion = { completeopt = "menu,menuone,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					--['<Tab>'] = cmp.mapping.select_next_item(),
					--['<S-Tab>'] = cmp.mapping.select_prev_item(),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback() -- insert a real Tab / indent
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback() -- default Shift-Tab behavior
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{ name = "copilot" },
					-- {
					-- 	name = "lazydev",
					-- 	-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
					-- 	group_index = 0,
					-- },
					{ name = "nvim_lsp" },
					-- { name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
					{ name = "git" },
				},
			})

			cmp.setup.filetype("oil", {
				sources = {
					{ name = "path" },
					{ name = "buffer" },
					{ name = "nvim_lsp" },
				},
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		-- Optional dependency
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			-- If you want to automatically add `(` after selecting a function or method
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "InsertEnter",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
}
