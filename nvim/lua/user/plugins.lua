local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim' if fn.empty(fn.glob(install_path)) > 0 then fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Initialize packer
require('packer').init({
  compile_path = vim.fn.stdpath('data')..'/site/plugin/packer_compiled.lua',
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'solid' })
    end,
  },
})

-- Install plugins
local use = require('packer').use

use('wbthomason/packer.nvim') -- Let packer manage itself

use('tpope/vim-commentary')

use('tpope/vim-surround')

use('preservim/nerdtree')

use('github/copilot.vim')

use({
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
  requires = { 
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'nvim-telescope/telescope-live-grep-args.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
  },
  config = function()
      require('user.plugins.telescope')
  end,
})

use({
    'nvim-lualine/lualine.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
        require('user.plugins.lualine')
    end,
})

use({
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  requires = {
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = function()
    require('user.plugins.treesitter')
  end,
})

use({
    'voldikss/vim-floaterm',
    config = function() 
        vim.g.floaterm_height = 0.4
        vim.g.floaterm_wintype = 'split'
        vim.keymap.set('n', '<leader>t', ':FloatermToggle<CR>')
        vim.keymap.set('t', '<leader>t', '<C-\\><C-n>:FloatermToggle<CR>')
    end,
})

use({
    'lewis6991/gitsigns.nvim',
    config = function()
        require('user.plugins.gitsigns')
    end,
})

use({
    'tpope/vim-fugitive',
    requires = 'tpope/vim-rhubarb',
})

use('tpope/vim-unimpaired')

use({
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
        require('user.plugins.bufferline')
    end,
})

use({
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
        require('user/plugins/nvim-tree')
    end,
})

use({ 
    "catppuccin/nvim", as = "catppuccin",
    config = function()
        vim.cmd('colorscheme catppuccin-mocha')

        vim.api.nvim_set_hl(0, 'NvimTreeIndentMarker', { fg = '#3c3836' })

        vim.api.nvim_set_hl(0, 'StatusLineNonText', {
            fg = vim.api.nvim_get_hl_by_name('NonText', true).foreground,
            bg = vim.api.nvim_get_hl_by_name('StatusLine', true).foreground,
        })
    end,
})

use({
    'neovim/nvim-lspconfig',
    requires = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim'
    },

    config = function()
        require('user.plugins.lspconfig')
    end,
})

if packer_bootstrap then
  require('packer').sync()
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile>
  augroup end
]])