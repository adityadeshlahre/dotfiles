-- Custom Telescope configuration

---@module 'lazy'
---@type LazySpec
return {
  {
    'custom/telescope',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    init = function()
      local function override_telescope_keymaps()
        local builtin = require 'telescope.builtin'

        -- Custom find_files with filters
        vim.keymap.set(
          'n',
          '<leader>sf',
          function()
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
          end,
          { desc = '[S]earch [F]iles' }
        )

        -- Custom live_grep with filters
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

        -- Live grep in open files
        vim.keymap.set('n', '<leader>s/', function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
            additional_args = function() return { '--glob', '!**/node_modules/*' } end,
          }
        end, { desc = '[S]earch [/] in Open Files' })
      end

      -- Apply overrides after telescope loads
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TelescopeLazyLoad',
        callback = function()
          override_telescope_keymaps()
        end,
      })
    end,
  },
}
