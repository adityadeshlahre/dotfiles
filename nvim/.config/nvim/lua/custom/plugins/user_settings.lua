-- Custom user settings

---@module 'lazy'
---@type LazySpec
return {
  {
    'custom/user_settings',
    init = function()
      vim.g.neovide_opacity = 0.8
      vim.g.neovide_normal_opacity = 1.0
      vim.o.relativenumber = true
      vim.o.wrap = true
    end,
  },
}
