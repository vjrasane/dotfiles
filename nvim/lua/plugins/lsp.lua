local on_attach = function(event)
	local map = function(mode, keys, func, desc)
		vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	map("n", "gr", function()
		Snacks.picker.lsp_references()
	end, "[G]oto [R]eferences")
	map("n", "gI", function()
		Snacks.picker.lsp_implementations()
	end, "[G]oto [I]mplementation")
	map("n", "<leader>D", function()
		Snacks.picker.lsp_type_definitions()
	end, "Type [D]efinition")
	map("n", "<leader>ds", function()
		Snacks.picker.lsp_symbols({ filter = { kind = false } })
	end, "[D]ocument [S]ymbols")
	map("n", "<leader>ws", function()
		Snacks.picker.lsp_workspace_symbols()
	end, "[W]orkspace [S]ymbols")
	map("n", "<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
	map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	map({ "n", "x" }, "<leader>cA", function()
		vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
	end, "[C]ode [A]ction (Source)")
	map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	local client = vim.lsp.get_client_by_id(event.data.client_id)

	if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		map("n", "<leader>ch", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, "[T]oggle Inlay [H]ints")
	end
end

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile", "VeryLazy" },
		enabled = true,
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
			"b0o/schemastore.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = on_attach,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			capabilities =
				vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.config("gopls", {
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})

			vim.lsp.config("rust_analyzer", {
				root_markers = { "Cargo.toml", "rust-project.json" },
				settings = {
					["rust-analyzer"] = {
						diagnostics = {
							enable = true,
						},
						check = {
							command = "clippy",
						},
					},
				},
			})

			vim.lsp.config("cooklang", {
				cmd = { "cook", "lsp" },
				filetypes = { "cook" },
				root_markers = { ".git" },
			})

			vim.lsp.config("cssls", {})

			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			vim.lsp.config("emmet_language_server", {
				filetypes = { "html", "css", "javascriptreact", "typescriptreact", "astro" },
			})

			vim.lsp.config("eslint", {})

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.astro" },
				callback = function(ev)
					local client = vim.lsp.get_clients({ bufnr = ev.buf, name = "eslint" })[1]
					if client then
						local diag =
							vim.diagnostic.get(ev.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
						if #diag > 0 then
							vim.cmd("EslintFixAll")
						end
					end
				end,
			})

			vim.lsp.enable({
				"astro",
				"tailwindcss",
				"pyright",
				"gopls",
				"lua_ls",
				"cooklang",
				"rust_analyzer",
				"cssls",
				"jsonls",
				"eslint",
				"emmet_language_server",
			})
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		opts = {
			settings = {
				expose_as_code_action = "all",
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
					includeCompletionsForModuleExports = true,
					includeCompletionsWithInsertText = true,
					importModuleSpecifierPreference = "shortest",
				},
			},
		},
	},
	{
		"antosha417/nvim-lsp-file-operations",
		event = "LspAttach",
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
}
