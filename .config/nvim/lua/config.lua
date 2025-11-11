vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true
vim.opt.termguicolors = true -- True color support

vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

vim.opt.showmode = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
local setup_clipboard = function()
	vim.opt.clipboard = "unnamedplus"
	if vim.fn.has("wsl") == 1 then
		vim.g.clipboard = {
			name = "WslClipboard",
			copy = {
				["+"] = "clip.exe",
				["*"] = "clip.exe",
			},
			paste = {
				["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
				["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			},
			cache_enabled = false,
		}
	end
end
vim.schedule(setup_clipboard)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitkeep = "screen"

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 1000

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8 -- Columns of context

vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

vim.opt.autowrite = true

vim.opt.completeopt = "menu,menuone,noselect"

vim.opt.conceallevel = 0 -- Hide * markup for bold and italic

vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.tabstop = 2 -- Number of spaces tabs count for

vim.opt.formatoptions = "jcroqlnt" -- tcqj

vim.opt.laststatus = 3 -- global statusline

vim.opt.list = true -- Show some invisible characters (tabs...

vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup

vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of an indent

vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })

vim.opt.smartindent = true -- Insert indents automatically

vim.opt.spelllang = { "en" }

vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode

vim.opt.winminwidth = 5 -- Minimum window width

vim.opt.wrap = true

-- Folding
vim.opt.foldlevel = 99
-- vim.opt.foldtext = "v:lua.require'utils'.ui.foldtext()"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.g.suda_smart_edit = 1
