return {
  'mbbill/undotree',
  'folke/zen-mode.nvim',
  'kyazdani42/nvim-web-devicons',
  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',
  'sbdchd/neoformat',
  {
    'mbbill/undotree',
    config = function() 
      vim.keymap.set("n", "<F9>", ":UndotreeToggle<CR>")
    end
  },
  'sbdchd/neoformat',
  'nvim-lua/plenary.nvim',
  {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup {
        icons = true,
      }
      vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
        {silent = true, noremap = true}
      )
    end
  },
}
