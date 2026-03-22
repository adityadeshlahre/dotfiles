-- Custom Telescope configuration

local function override_telescope_keymaps()
  local builtin = require 'telescope.builtin'

  vim.keymap.set('n', '<leader>sf', function()
    builtin.find_files {
      find_command = {
        'rg',
        '--files',
        '--hidden',
        '--glob',
        '!.git/**',
        '--glob',
        '!node_modules/**',
        '--glob',
        '!.dist/*',
        '--glob',
        '!*.lock',
        '--glob',
        '!.nx/**',
        '--glob',
        '!.next/**',
        '--glob',
        '!yarn.lock',
      },
    }
  end, { desc = '[S]earch [F]iles' })

  vim.keymap.set('n', '<leader>sg', function()
    builtin.live_grep {
      additional_args = function()
        return {
          '--no-ignore',
          '--glob',
          '!**/node_modules/*',
          '--glob',
          '!**/.git/*',
          '--glob',
          '!**/dist/*',
          '--glob',
          '!**/.next/*',
          '--glob',
          '!**/yarn.lock',
          '--glob',
          '!**/package-lock.json',
          '--glob',
          '!**/pnpm-lock.yaml',
          '--glob',
          '!**/tags',
          '--glob',
          '!bun.lockb',
          '--glob',
          '!bun.lock',
          '--glob',
          '!**/.DS_Store',
        }
      end,
    }
  end, { desc = '[S]earch by [G]rep' })

  vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
      additional_args = function() return { '--glob', '!**/node_modules/*' } end,
    }
  end, { desc = '[S]earch [/] in Open Files' })
end

override_telescope_keymaps()
