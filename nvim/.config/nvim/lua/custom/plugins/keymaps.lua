-- Custom keymaps

---@module 'lazy'
---@type LazySpec
return {
  {
    'custom/keymaps',
    init = function()
      -- Floaterm toggle
      vim.keymap.set('n', '<leader>ft', '<cmd>FloatermToggle<CR>', { desc = 'Toggle floating terminal' })

      -- Diagnostic keymaps
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic [E]rror' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
      vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR } end, { desc = 'Next error' })
      vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR } end, { desc = 'Previous error' })
      vim.keymap.set('n', '<leader>td', '<cmd>Telescope diagnostics bufnr=0<CR>', { desc = 'Show buffer diagnostics (Telescope)' })
      vim.keymap.set('n', '<leader>tD', '<cmd>Telescope diagnostics<CR>', { desc = 'Show all diagnostics (Telescope)' })

      -- Close current buffer
      vim.keymap.set('n', '<leader>Q', ':bd<CR>', { desc = 'Close current buffer' })

      -- Disable arrow keys in normal mode
      vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
      vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
      vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
      vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

      -- Visual mode indentation
      vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Indent selected lines' })
      vim.keymap.set('v', '<S-Tab>', '<gv', { desc = 'Unindent selected lines' })

      -- Move selected lines up/down in visual mode
      vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
      vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })
    end,
  },
}
