return {
	"lervag/vimtex", -- nvim latex
	dependenies = {
		"KeitaNakamura/tex-conceal.vim",
	},
	lazy = false,
	config = function()
		vim.g["vimtex_view_method"] = "skim"
		vim.g["vimtex_context_pdf_viewer"] = "okular"
		vim.g["vimtex_compiler_method"] = "latexmk"
		vim["conceallevel"] = 1
		vim.g["tex_conceal_frac"] = 1
		vim.g["tex_conceal"] = "abdgm"
		local keymap = vim.keymap -- for conciseness
		keymap.set(
			"n",
			"<leader>ht",
			"<cmd>help vimtex-default-mappings<cr>",
			{ desc = "call help vimtex-default-mappings" }
		)
	end,
}
