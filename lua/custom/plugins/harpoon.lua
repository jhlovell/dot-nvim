return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>ha',
      function()
        require('harpoon'):list():append()
      end,
      desc = 'Add file to Harpoon',
    },
    {
      '<leader>hh',
      function()
        require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
      end,
      desc = 'Open Harpoon UI',
    },
    {
      '<leader>h1',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = 'Go to first item in harpoon',
    },
    {
      '<leader>h2',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = 'Go to second item in harpoon',
    },
    {
      '<leader>h3',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = 'Go to third item in harpoon',
    },
    {
      '<leader>h4',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = 'Go to fourth item in harpoon',
    },
    {
      '<leader>h5',
      function()
        require('harpoon'):list():select(5)
      end,
      desc = 'Go to fifth item in harpoon',
    },
  },
}
