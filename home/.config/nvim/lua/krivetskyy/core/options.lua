local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true
opt.number = true

--tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = true

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split line
-- local function set_textwidth()
-- 	-- Установите минимальное и максимальное значения для textwidth
-- 	local min_tw = 80
-- 	local max_tw = 120
-- 	local width = vim.api.nvim_win_get_width(0)
-- 	local new_tw = math.floor(width * 0.8) -- Рассчитываем 80% от ширины окна
--
-- 	-- Применяем ограничения минимального и максимального значения
-- 	new_tw = math.max(min_tw, new_tw)
-- 	new_tw = math.min(max_tw, new_tw)
--
-- 	-- Устанавливаем значение textwidth
-- 	vim.opt.textwidth = new_tw
-- end
-- Вызываем set_textwidth при запуске и при изменении размера окна
-- vim.api.nvim_create_autocmd({ "VimEnter", "VimResized" }, { callback = set_textwidth })

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")

opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})
