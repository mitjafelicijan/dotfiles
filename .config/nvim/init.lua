vim.opt.winborder = "double"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.mouse = ""
vim.opt.guicursor = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "popup", "noselect", "noinsert" }

vim.keymap.set("n", "<C-Left>",  ":bprevious<CR>")
vim.keymap.set("n", "<C-Right>", ":bnext<CR>")
vim.keymap.set("n", "<Leader>d", ":bd!<CR>")
vim.keymap.set("n", "<Leader>x", ":Ex .<CR>")
vim.keymap.set("n", "<Leader>f", ":find ")
vim.keymap.set("n", "<Leader>b", ":b ")
vim.keymap.set("n", "<Leader>q", ":nohlsearch<CR>")
vim.keymap.set("n", "<leader>w", ":silent! grep! <cword> | cwindow | redraw!<CR>")

vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#222222" })
vim.api.nvim_set_hl(0, "Keyword", { fg = "#ffcc66" })
vim.api.nvim_set_hl(0, "Statement", { fg = "#ffcc66" })
vim.api.nvim_set_hl(0, "Type", { fg = "#66ccff" })
vim.api.nvim_set_hl(0, "Number", { fg = "#ff9966" })
vim.api.nvim_set_hl(0, "Float", { fg = "#ff9966" })
vim.api.nvim_set_hl(0, "Boolean", { fg = "#ff9966" })

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		vim.opt_local.path = ".,**"
	end,
})

vim.lsp.config("clang", {
	cmd = { "clangd" },
	filetype = { ".c", ".h" },
	root_markers = { ".clangd", ".git", },
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
})

vim.lsp.enable({ "clangd", "gopls" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-q>", vim.diagnostic.setloclist, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	end,
})
