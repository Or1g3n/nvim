return {
  {
    'folke/tokyonight.nvim',
    lazy = false, -- Load it eagerly (not lazily)
    priority = 1000, -- Make sure to load this before other plugins
    config = function()
      -- Set your colorscheme configuration here
      require('tokyonight').setup({
        style = "storm", -- Choose between "storm", "moon", "night", "day"
        transparent = false, -- Enable terminal transparency
        terminal_colors = true, -- Use terminal colors
        styles = {
          -- sidebars = "transparent", -- Transparent sidebars (like nvim-tree)
          floats = "transparent", -- Transparent floating windows
        },
      })
      -- Set the colorscheme
      vim.cmd([[colorscheme tokyonight]])
    end
  }
}
