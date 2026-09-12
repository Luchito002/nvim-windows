local keymap = vim.keymap

keymap.set('n', 'x', '"_x')

-- Delete a word backwards
-- keymap.set('n', 'dw', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')


-- New tab
keymap.set('n', 'te', ':tabedit<Return>')

-- Split window
keymap.set('n', 'ss', ':split<Return><C-w>w')
keymap.set('n', 'sv', ':vsplit<Return><C-w>w')

-- Move window
keymap.set('n', '<Space>', '<C-w>w')
keymap.set('n', 's<left>', '<C-w>h')
keymap.set('n', 's<up>', '<C-w>k')
keymap.set('n', 's<down>', '<C-w>j')
keymap.set('n', 's<right>', '<C-w>l')
keymap.set('n', 'sh', '<C-w>h')
keymap.set('n', 'sk', '<C-w>k')
keymap.set('n', 'sj', '<C-w>j')
keymap.set('n', 'sl', '<C-w>l')

-- Result
keymap.set('n', 'n', 'nzzzv', { desc = "Goes to the next result on the search and put the cursor in the middle" })
keymap.set('n', 'N', 'Nzzzv', { desc = "Goes to the prev result on the search and put the cursor in the middle" })

-- Exit terminal mode without delaying <Space> in terminal buffers
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Send Ctrl+C directly to terminal jobs (useful for floating terminals)
keymap.set('t', '<C-c>', function()
  local job = vim.b.terminal_job_id

  if not job then
    return
  end

  local running = vim.fn.jobwait({ job }, 0)[1] == -1

  if not running then
    return
  end

  if vim.bo.filetype == 'snacks_terminal' and vim.fn.has('win32') == 1 then
    vim.fn.jobstop(job)
  else
    vim.fn.chansend(job, vim.api.nvim_replace_termcodes('<C-c>', true, false, true))
  end
end, { desc = 'Interrupt terminal job' })
