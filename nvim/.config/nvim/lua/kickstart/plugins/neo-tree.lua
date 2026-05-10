-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local plugins = {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

if vim.g.have_nerd_font then
  table.insert(plugins, 'https://github.com/nvim-tree/nvim-web-devicons')
end

vim.pack.add(plugins)

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  window = {
    position = 'left',
    width = 30,
    mappings = {
      ['\\'] = 'close_window',
    },
  },
  filesystem = {
    hijack_netrw_behavior = 'open_default',
    close_if_last_window = true,
    use_libuv_file_watcher = true,
    filtered_items = {
      visible = true,
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_by_name = {
        'node_modules',
        '.DS_Store',
        'thumbs.db',
        '.nx',
        '.venv',
      },
      never_show = {
        'node_modules',
        '.DS_Store',
        'thumbs.db',
        '.nx',
        '.venv',
      },
    },
    follow_current_file = {
      enabled = true,
      leave_dirs_open = true,
    },
  },
}
