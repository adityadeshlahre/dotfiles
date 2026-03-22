-- Custom LSP configuration

---@module 'lazy'
---@type LazySpec
return {
  {
    'custom/lsp_config',
    init = function()
      -- Add custom LSP servers to mason
      -- These will be merged with the servers table in init.lua
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

      -- Add custom tools to ensure_installed
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
    end,
  },
}
