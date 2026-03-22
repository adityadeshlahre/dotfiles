-- Custom LSP configuration

vim.g.custom_lsp_servers = {
  'ts_ls',
  'jdtls',
  'golangci_lint_ls',
  'eslint',
  'docker_compose_language_service',
  'docker_language_server',
  'dockerls',
  'gopls',
  'pyright',
  'tailwindcss',
}

vim.g.custom_mason_tools = {
  'isort',
  'black',
  'eslint_d',
  'biome',
  'checkstyle',
  'golangci-lint',
  'goimports',
  'prettierd',
  'stylua',
  'delve',
}
