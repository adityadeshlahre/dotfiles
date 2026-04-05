return {
  'f-person/git-blame.nvim',
  cmd = {
    'GitBlameToggle',
    'GitBlameEnable',
    'GitBlameDisable',
    'GitBlameCopySHA',
    'GitBlameCopyCommitURL',
    'GitBlameOpenCommitURL',
    'GitBlameCopyFileURL',
    'GitBlameOpenFileURL',
  },
  opts = {
    enabled = false,
    message_template = ' <author> • <date> • <summary> • <<sha>>',
  },
  init = function()
    if vim.fn.maparg('<leader>gb', 'n') == '' then
      vim.keymap.set('n', '<leader>gb', '<cmd>GitBlameToggle<CR>', {
        desc = 'Toggle Git [B]lame',
        silent = true,
      })
    end
  end,
}
