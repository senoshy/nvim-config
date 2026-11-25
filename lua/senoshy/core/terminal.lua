-- Integrated persistent terminal (side-by-side `<code> | <terminal>` or bottom split)

local state = {
  buf = nil,
  win = nil,
  layout = 'vertical', -- 'vertical' (right side) or 'horizontal' (bottom)
}

local function is_valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function open_terminal(layout)
  state.layout = layout or state.layout

  if state.layout == 'vertical' then
    local width = math.max(30, math.floor(vim.o.columns * 0.4))
    vim.cmd('botright ' .. width .. 'vsplit')
  else
    local height = math.max(8, math.floor(vim.o.lines * 0.3))
    vim.cmd('botright ' .. height .. 'split')
  end

  state.win = vim.api.nvim_get_current_win()

  if is_valid_buf(state.buf) then
    vim.api.nvim_win_set_buf(state.win, state.buf)
  else
    vim.cmd.terminal()
    state.buf = vim.api.nvim_get_current_buf()
    vim.bo[state.buf].buflisted = false
  end

  vim.wo[state.win].number = false
  vim.wo[state.win].relativenumber = false
  vim.wo[state.win].signcolumn = 'no'
  vim.wo[state.win].winfixwidth = (state.layout == 'vertical')
  vim.wo[state.win].winfixheight = (state.layout == 'horizontal')

  vim.cmd.startinsert()
end

local function toggle_terminal(layout)
  if is_valid_win(state.win) then
    if layout and layout ~= state.layout then
      vim.api.nvim_win_close(state.win, true)
      state.win = nil
      open_terminal(layout)
      return
    end
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
    return
  end

  open_terminal(layout)
end

local function resize_terminal(delta)
  if not is_valid_win(state.win) then
    return
  end
  if state.layout == 'vertical' then
    local cur = vim.api.nvim_win_get_width(state.win)
    vim.api.nvim_win_set_width(state.win, math.max(20, cur + delta))
  else
    local cur = vim.api.nvim_win_get_height(state.win)
    vim.api.nvim_win_set_height(state.win, math.max(5, cur + delta))
  end
end

-- Toggle side-by-side (`<code> | <terminal>`)
vim.keymap.set({ 'n', 't' }, '<C-\\>', function() toggle_terminal('vertical') end, { desc = 'Toggle side terminal' })
vim.keymap.set('n', '<leader>tt', function() toggle_terminal('vertical') end, { desc = '[T]oggle [T]erminal (side)' })
vim.keymap.set('n', '<leader>tT', function() toggle_terminal('horizontal') end, { desc = '[T]oggle [T]erminal (bottom)' })

-- Grow / shrink integrated terminal from anywhere (Normal or Terminal mode)
vim.keymap.set({ 'n', 't' }, '<M-=>', function() resize_terminal(5) end, { desc = 'Grow terminal' })
vim.keymap.set({ 'n', 't' }, '<M-->', function() resize_terminal(-5) end, { desc = 'Shrink terminal' })

-- General window resizing (Normal and Terminal mode)
vim.keymap.set({ 'n', 't' }, '<M-Left>', '<cmd>vertical resize -4<CR>', { desc = 'Decrease window width' })
vim.keymap.set({ 'n', 't' }, '<M-Right>', '<cmd>vertical resize +4<CR>', { desc = 'Increase window width' })
vim.keymap.set({ 'n', 't' }, '<M-Up>', '<cmd>resize +2<CR>', { desc = 'Increase window height' })
vim.keymap.set({ 'n', 't' }, '<M-Down>', '<cmd>resize -2<CR>', { desc = 'Decrease window height' })

-- Seamless navigation between code and terminal splits
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Move to left window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Move to right window' })

-- Exit terminal mode easily
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
