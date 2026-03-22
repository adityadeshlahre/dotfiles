-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec
return {
  -- Noice.nvim - Better UI for messages and notifications
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      presets = {
        command_palette = true,
      },
      routes = {
        {
          filter = {
            event = 'notify',
            find = 'No information available',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            find = '^$',
          },
          opts = { skip = true },
        },
      },
      views = {
        notify = {
          timeout = 50,
          render = 'default',
        },
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },

  -- Inc-rename - Incremental rename with preview
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    keys = {
      {
        '<leader>rn',
        function() return ':IncRename ' .. vim.fn.expand '<cword>' end,
        desc = 'Incremental rename',
        mode = 'n',
        noremap = true,
        expr = true,
      },
    },
    config = true,
  },

  -- Auto-save - Automatically save changes
  {
    'Pocco81/auto-save.nvim',
    event = 'VeryLazy',
    config = function()
      require('auto-save').setup {
        enabled = true,
        execution_message = {
          message = function() return 'AutoSave: saved at ' .. vim.fn.strftime '%H:%M:%S' end,
          dim = 0.18,
          cleaning_interval = 100,
        },
        debounce_delay = 10000,
        trigger_events = { 'InsertLeave', 'TextChanged' },
        write_all_buffers = false,
      }
      vim.keymap.set({ 'n', 'i' }, '<C-s>', '<Esc>:w<CR>', { desc = 'Save buffer' })
      vim.keymap.set('n', '<leader>ta', ':ASToggle<CR>', { desc = 'Toggle AutoSave' })
    end,
  },

  -- Auto-session - Session management
  {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/tmp' },
      }
      vim.keymap.set('n', '<leader>ls', require('auto-session').search, { desc = '[S]earch [S]essions' })
    end,
  },
}
