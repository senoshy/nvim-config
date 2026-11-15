local function setup_autopairs()
  local ok, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
  local ok_cmp, cmp = pcall(require, 'cmp')
  if not ok or not ok_cmp then
    return
  end

  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
end

return {
  'windwp/nvim-autopairs',
  event = { 'InsertEnter' },
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    require('nvim-autopairs').setup({})
    setup_autopairs()
  end
}
