local Qf = {}

function Qf.qf()
  local winid = (function()
    local tabnr = vim.api.nvim_get_current_tabpage()
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.tabnr == tabnr and win.quickfix == 1 and win.loclist == 0 then
        return win.winid
      end
    end
  end)()

  if winid == nil then
    vim.cmd('copen')
  elseif winid == vim.api.nvim_get_current_win() then
    vim.api.nvim_win_close(winid, false)
  else
    vim.api.nvim_set_current_win(winid)
  end
end

return Qf
