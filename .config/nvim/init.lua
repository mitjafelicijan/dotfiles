vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

local opt = vim.opt

opt.exrc = true
opt.secure = true
opt.spelllang = "en_us"
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.number = true
opt.cursorline = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.wrap = false
opt.backup = false
opt.swapfile = false
opt.undofile = false
opt.updatetime = 100
opt.timeoutlen = 400
opt.ttimeoutlen = 100
opt.shortmess:append("c")
opt.clipboard = "unnamedplus"
opt.path:append("**")
opt.mouse = ""

opt.foldmethod = "syntax"
opt.foldlevel = 99
opt.foldopen = ""
opt.scrolloff = 10
opt.smoothscroll = true
opt.wildignore:append("**/.git/*,**/.hg/*,**/.svn/*,**/vendor,tags,*.o,*.a,*.so")
opt.completeopt = "menu,menuone,popup,noselect,noinsert"
opt.complete:append("t")

opt.background = "dark"
opt.guicursor = "n-v-c-sm-i-ci-ve:block,r-cr-o:hor20"
opt.winborder = "solid"
opt.laststatus = 3
opt.splitkeep = "screen"

if vim.fn.executable("rg") == 1 then
	opt.grepprg = "rg --vimgrep --no-heading --smart-case"
	opt.grepformat = "%f:%l:%c:%m"
end

local function setup_highlights()
	-- local float_bg, bar_bg, bar_fg = "#080808", "#444444", "#ffffff"
	local float_bg, bar_bg, bar_fg = "#333333", "#444444", "#ffffff"

	local hls = {
		NormalFloat = { bg = float_bg },
		FloatBorder = { fg = float_bg, bg = float_bg },
		MiniPickBar = { fg = bar_fg, bg = bar_bg, bold = true },
		MiniPickSide = { fg = float_bg, bg = float_bg },
		Pmenu = { bg = float_bg },
		PmenuSel = { bg = bar_bg, fg = bar_fg },
		StatusLine = { fg = "#000000", bg = "#9e9e9e", ctermfg = 16, ctermbg = 247, bold = true },
		User1 = { fg = "#ffffff", bg = "#464646", ctermfg = 231, ctermbg = 238, bold = true },
	}

	for name, config in pairs(hls) do
		vim.api.nvim_set_hl(0, name, config)
	end

	local pick_links = { "FloatTitle", "FloatFooter", "MiniPickBorderText", "MiniPickPrompt", "MiniPickPromptPrefix", "MiniPickPromptCaret" }
	for _, name in ipairs(pick_links) do
		vim.api.nvim_set_hl(0, name, { link = "MiniPickBar" })
	end
end

local ui_group = vim.api.nvim_create_augroup("UserUI", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", { group = ui_group, callback = setup_highlights })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "minipick",
	callback = function()
		vim.wo.signcolumn, vim.wo.winblend = "no", 0
	end,
})

local function on_attach(bufnr)
	local function bufkey(mode, lhs, rhs)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
	end
	bufkey("n", "<C-k>", vim.lsp.buf.hover)
	bufkey("n", "<C-j>", vim.lsp.buf.hover)
	bufkey("n", "gr", vim.lsp.buf.references)
	bufkey("n", "gd", vim.lsp.buf.definition)
	bufkey("n", "ga", vim.lsp.buf.code_action)
	bufkey("n", "re", vim.lsp.buf.rename)
	bufkey("n", "<C-Up>", vim.diagnostic.goto_prev)
	bufkey("n", "<C-Down>", vim.diagnostic.goto_next)
	bufkey("i", "<C-n>", function() vim.lsp.omnifunc(0, "") end)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLSP", { clear = true }),
	callback = function(args) on_attach(args.buf) end,
})

vim.diagnostic.config({
	float = { border = "solid" },
})

local default_config = {
	capabilities = vim.lsp.protocol.make_client_capabilities(),
}
default_config.capabilities.textDocument.completion.completionItem.snippetSupport = true
default_config.capabilities.textDocument.hover.contentFormat = { "plaintext" }

local servers = {
	clangd = { cmd = { "clangd", "--background-index" } },
	pyright = { cmd = { "pyright-langserver", "--stdio" } },
	gopls = { cmd = { "gopls" } },
	biome = { cmd = { "biome", "lsp-proxy" } },
}

for name, config in pairs(servers) do
	vim.lsp.config[name] = vim.tbl_deep_extend("force", vim.deepcopy(default_config), config)
	vim.lsp.enable(name)
end

local status_timer = nil
function _G.StatusLspName()
	local names = vim.iter(vim.lsp.get_clients({ bufnr = 0 })):map(function(c) return c.name end):totable()
	return #names > 0 and (" " .. table.concat(names, ",") .. " ") or ""
end

function _G.StatusGitBranch()
	local summary = vim.b.minigit_summary or {}
	local head = summary.head_name or ""
	return head ~= "" and ("  " .. head .. " ") or ""
end

function _G.ShowDiagnostics()
	if status_timer then status_timer:stop() end
	status_timer = vim.defer_fn(function()
		local line = vim.api.nvim_win_get_cursor(0)[1] - 1
		local diagnostics = vim.diagnostic.get(0, { lnum = line })
		if #diagnostics == 0 then
			vim.api.nvim_echo({{"", ""}}, false, {})
			return
		end
		table.sort(diagnostics, function(a, b) return a.severity < b.severity end)
		local d = diagnostics[1]
		local hls_map = { [1] = "ErrorMsg", [2] = "WarningMsg", [3] = "Directory", [4] = "MoreMsg" }
		vim.api.nvim_echo({{d.message:gsub("\n", " "), hls_map[d.severity] or "Normal"}}, false, {})
	end, 50)
end

vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, { group = ui_group, callback = _G.ShowDiagnostics })
opt.statusline = "%1*%{v:lua.StatusGitBranch()}%* %f %r%m %=%1*%{v:lua.StatusLspName()}%* %-14.(%l,%c%V%) %P"

local keymap = vim.keymap.set
keymap("n", "<C-Right>", vim.cmd.bnext)
keymap("n", "<C-Left>", vim.cmd.bprevious)
keymap("n", "<C-q>", vim.cmd.copen)
keymap("n", "<C-p>", function() require("mini.pick").builtin.files() end)
keymap("n", "<C-b>", function() require("mini.pick").builtin.buffers() end)
keymap("n", "<Leader>d", function() vim.cmd("bd!") end)
keymap("n", "<Leader>q", vim.cmd.nohlsearch)
keymap("n", "<Leader>x", vim.diagnostic.setqflist)
keymap("n", "<Leader>w", function() require("mini.pick").builtin.grep({ tool = "rg" }) end)

vim.cmd.colorscheme("wildcharm")

require("mini.pick").setup({
	options = { use_icons = false, content_from_bottom = true },
	source = {
		show = function(buf_id, items, query)
			return require("mini.pick").default_show(buf_id, items, query, { icons = false })
		end,
	},
	window = {
		prompt_caret = "",
		prompt_prefix = "> ",
		config = function()
			local b, s = { " ", "MiniPickBar" }, { " ", "MiniPickSide" }
			return {
				anchor = "SW", row = vim.o.lines - 1, col = 0,
				width = vim.o.columns, height = 16,
				border = { b, b, b, s, b, b, b, s }
			}
		end,
	},
})

require("mini.git").setup({})
