-- basic configuration
-- ===================

-- use Vim settings, rather than Vi settings
vim.opt.compatible = false

-- set leader key as space
vim.g.mapleader = " "

-- show row number
vim.opt.number = true

-- set encoding
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'

-- indenting
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- fuzzy find inside projects folder
-- =================================

-- search down into subfolders
-- provides tab-completion for all file-related tasks
vim.opt.path:append('**')

-- display all matching files during tab complete
vim.opt.wildmenu = true

-- tag jumping
-- ===========

-- create the 'tags' file
vim.cmd('command! MakeTags !ctags -R')

-- <C ]> to go to tag under cursor
-- <g C ]> for ambiguous tags
-- <C t> to jump back the tag stack

-- plugins
-- =======

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- setup lazy.nvim
local plugins = {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "nvim-telescope/telescope.nvim", tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "junegunn/goyo.vim", name = "goyo" },
  { "jpalardy/vim-slime", name = "vim-slime" },
  { "fladson/vim-kitty", name = "vim-kitty" },
}
local opts = {}
require("lazy").setup(plugins, opts)

-- setup telescope
local builtin = require("telescope.builtin")
local telescope = require("telescope")

telescope.setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '--no-ignore',
      '--glob', '!.git/'
    },
    file_ignore_patterns = { ".git/" },
  },
  pickers = {
    find_files = {
      hidden = true,
      no_ignore = true,
      file_ignore_patterns = { ".git/" }
    }
  }
}

vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

-- setup treesitter
local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = {"bash", "lua", "c", "python", "go", "html", "css", "javascript", "typescript", "svelte", "markdown"},
  highlight = { enable = true },
  indent = { enable = true },
})

-- setup catppuccin
require("catppuccin").setup({
    flavour = "frappe",
})
vim.cmd.colorscheme "catppuccin"

-- setup vim-slime
vim.g.slime_target = "kitty"
vim.g.slime_paste_file = vim.fn.expand("$HOME/.slime_paste")
vim.g.slime_python_ipython = 1

vim.api.nvim_set_keymap('x', '<c-c><c-c>', '<Plug>SlimeRegionSend', {noremap = true})
vim.api.nvim_set_keymap('n', '<c-c><c-c>', '<Plug>SlimeParagraphSend', {noremap = true})
