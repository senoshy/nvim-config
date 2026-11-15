local function setup_autopairs()
  local cmp_autopairs = require('nvim-autopairs.completition.cmp')
  local cmp = require('cmp')

  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
end

return {
  'windwp/nvim-autopairs',
  event = { 'InsertEnter' },
  config = setup_autopairs
}
