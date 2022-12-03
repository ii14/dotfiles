local m = require('m')
local map, lazy = m.map, m.lazy
local keymaps = {}


-- OVERRIDE DEFAULTS ---------------------------------------------------------------------
-- Swap 0 and ^
map.n('0', '^')
map.n('^', '0')
-- map.n('0', function()
--   local start = vim.api.nvim_get_current_line():find('%S')
--   return (start == nil or start == vim.fn.col('.')) and '0' or '^'
-- end, { expr = true })
-- Yank to the end of the line
map.n('Y', 'y$')
-- Select last yanked or modified text
map.n('gV', '`[v`]')
-- Don't leave visual mode when changing indentation
map.x({ ['<'] = '<gv', ['>'] = '>gv' })
-- Split line, opposite of J
map.n('S', [[i<CR><ESC>k:sil! keepp s/\v +$//<CR>:noh<CR>j^]])
-- Get rid of annoying stuff
map.n('q:', ':')
map.n('Q', '<Nop>')
-- Save initial search position
map.nx({ ['/'] = 'ms/', ['?'] = 'ms?' })
-- Swap {j,k} and {gj,gk}, unless count is given
map.nx({
  ['j'] = [[v:count ? 'j' : 'gj']], ['gj'] = [[v:count ? 'gj' : 'j']],
  ['k'] = [[v:count ? 'k' : 'gk']], ['gk'] = [[v:count ? 'gk' : 'k']],
}, { expr = true })
-- Swap p and P for visual mode
map.x({ ['p'] = 'P', ['P'] = 'p' })

-- Horizontal and vertical scrolling
do
  local function scroll_fn(default)
    local saved = default or 1
    return function(cmd)
      return function()
        local count = vim.v.count
        if count ~= 0 then
          saved = count
          return cmd
        else
          return saved..cmd
        end
      end
    end
  end

  local hscroll = scroll_fn(12)
  local vscroll = scroll_fn(3)

  map.nx({
    ['zh'] = hscroll('zh'),
    ['zl'] = hscroll('zl'),
    ['<C-E>'] = vscroll('<C-E>'),
    ['<C-Y>'] = vscroll('<C-Y>'),
  }, { expr = true })
end

-- n/N always moves in one direction, center the screen afterwards
do
  local function center()
    local topline = vim.fn.winsaveview().topline
    vim.schedule(function()
      if topline ~= vim.fn.winsaveview().topline then
        vim.api.nvim_command('norm! zz')
      end
    end)
  end

  map.n({
    ['n'] = function() center() return vim.v.searchforward == 1 and 'n' or 'N' end,
    ['N'] = function() center() return vim.v.searchforward == 1 and 'N' or 'n' end,
  }, { expr = true })

  -- map.n({
  --   ['n'] = function()
  --     return ('<cmd>set sj=-50<CR>%s<cmd>set sj=%d<CR>'):format(
  --       vim.v.searchforward == 1 and 'n' or 'N', vim.o.scrolljump)
  --   end,
  --   ['N'] = function()
  --     return ('<cmd>set sj=-50<CR>%s<cmd>set sj=%d<CR>'):format(
  --       vim.v.searchforward == 1 and 'N' or 'n', vim.o.scrolljump)
  --   end,
  -- }, { expr = true })
end


-- WINDOWS -------------------------------------------------------------------------------
map.n({
  ['<C-H>'] = '<C-W>h',
  ['<C-J>'] = '<C-W>j',
  ['<C-K>'] = '<C-W>k',
  ['<C-L>'] = '<C-W>l',
})
map.n({
  ['<C-W>t']     = '<cmd>tab split<CR>',
  ['<C-W><C-T>'] = '<cmd>tab split<CR>',
})
map.n('<leader>w', '<C-W>', { remap = true })


-- BUFFERS -------------------------------------------------------------------------------
do
  local buf = lazy.require('m.buf')
  map.n({
    ['<C-N>']      = -buf.next(lazy.vim.v.count1),
    ['<C-P>']      = -buf.prev(lazy.vim.v.count1),
    ['<C-G><C-N>'] = -buf.move_right(lazy.vim.v.count1),
    ['<C-G><C-P>'] = -buf.move_left(lazy.vim.v.count1),
  })
end
map.n('<C-G><C-G>', '2<C-G>')
map.n('<C-B>', '<cmd>Buffers<CR>')


-- FILES ---------------------------------------------------------------------------------
-- fzf
map.n('<C-F>', [[:lua require'm.ui.menus'.bookmarks()<CR>]])
map.n('<leader>f', function()
  vim.fn.system('git rev-parse')
  if vim.v.shell_error == 0 then
    return ':GFiles --exclude-standard --others --cached<CR>'
  else
    return ':Files<CR>'
  end
end, { silent = true, expr = true })
map.n('<leader>F', [[':Files '.m#bufdir()."\<CR>"]], { silent = true, expr = true })

-- lir
map.n('-', [[<cmd>execute 'edit' m#bufdir()[:-2]<CR>]], { silent = true })


-- SEARCH AND REPLACE --------------------------------------------------------------------
map.a({
  ['*']   = '<Plug>(asterisk-*)',
  ['g*']  = '<Plug>(asterisk-g*)',
  ['#']   = '<Plug>(asterisk-#)',
  ['g#']  = '<Plug>(asterisk-g#)',
  ['z*']  = '<Plug>(asterisk-z*)',
  ['gz*'] = '<Plug>(asterisk-gz*)',
  ['z#']  = '<Plug>(asterisk-z#)',
  ['gz#'] = '<Plug>(asterisk-gz#)',
})
map.n('c*', '<Plug>(asterisk-z*)cgn')
map.nx('<leader>c', '<Plug>(asterisk-z*)cgn')
map.n('<leader><CR>', [[<cmd>let @/ = ''<CR>]])


-- MACROS --------------------------------------------------------------------------------
map.a('q', [[reg_recording() is# '' ? '\<Nop>' : 'q']], { expr = true })
map.n('<leader>q', 'q')
map.n('qr', 'q')
map.n('qe', ':Regedit<CR>')


-- QUICKFIX ------------------------------------------------------------------------------
map.n({
  ['qq'] = '<cmd>call m#qf#open()<CR>',
  ['qt'] = '<cmd>call m#qf#toggle()<CR>',
  ['qo'] = '<cmd>call m#qf#show()<CR>',
  ['qc'] = '<cmd>cclose<CR>',
})

-- Unimpaired mappings
map.n({
  ['[q'] = '<cmd>cprev<CR>',
  [']q'] = '<cmd>cnext<CR>',
  ['[Q'] = '<cmd>cfirst<CR>',
  [']Q'] = '<cmd>clast<CR>',
  ['[l'] = '<cmd>lprev<CR>',
  [']l'] = '<cmd>lnext<CR>',
  ['[L'] = '<cmd>lfirst<CR>',
  [']L'] = '<cmd>llast<CR>',
})


-- REGISTERS -----------------------------------------------------------------------------
-- Missing gP mapping for visual mode
map.x('gP', 'P`]<Space>')

-- System clipboard
map.n('<leader>y',  '"+y')
map.n('<leader>Y',  '"+y$')
map.n('<leader>gy', '"+gy', { remap = true })
map.n('<leader>gY', '"+gy$', { remap = true })
map.n('<leader>p',  '"+p')
map.n('<leader>P',  '"+P')
map.n('<leader>gp', '"+gp')
map.n('<leader>gP', '"+gP')
map.x('<leader>y',  '"+y')
map.x('<leader>gy', '"+gy', { remap = true })
map.x('<leader>p',  '"+p')
map.x('<leader>P',  '"+P')
map.x('<leader>gp', '"+gp')
map.x('<leader>gP', '"+gP', { remap = true })

-- Yank and leave the cursor just after the new text
do
  local gy_init = false
  local function gy_fn(res)
    return function()
      if not gy_init then
        gy_init = true
        vim.cmd([[
          function! GY(type) abort
            let c = get({'line': "'[V']", 'char': "`[v`]", 'block': '`[\<C-V>`]'}, a:type, '')
            execute printf("normal! %s\"%sy`]\<Space>", c, v:register)
          endfunction
        ]])
      end
      vim.api.nvim_set_option('opfunc', 'GY')
      return res
    end
  end

  map.nx({
    ['gy']  = gy_fn('g@'),
    ['gY']  = gy_fn('g@$'),
    ['gyy'] = gy_fn('g@_'),
  }, { expr = true })
end


-- TEXT OBJECTS --------------------------------------------------------------------------
map.xo({
  ['ii'] = [[:<C-U>exe luaeval('require"m.textobj".inner_indent()')<CR>]],
  ['ai'] = [[:<C-U>exe luaeval('require"m.textobj".outer_indent()')<CR>]],
}, { silent = true })


-- GIT -----------------------------------------------------------------------------------
-- fugitive
map.n({
  ['<leader>gs'] = ':Git<CR>',
  ['<leader>gl'] = ':Flog<CR>',
  ['<leader>gb'] = ':Git blame<CR>',
  ['<leader>ga'] = ':Gwrite<CR>',
  ['<leader>gd'] = ':DiffviewOpen<CR>',
  ['<leader>gh'] = ':DiffviewFileHistory<CR>',
  ['<leader>g2'] = ':diffget //2<CR>',
  ['<leader>g3'] = ':diffget //3<CR>',
})

-- gitsigns
function keymaps.gitsigns(bufnr)
  local lmap = map.new({ buf = bufnr, silent = true })

  lmap.n({
    [']c'] = [[&diff ? ']c' : '<cmd>lua require"gitsigns".next_hunk()<CR>']],
    ['[c'] = [[&diff ? '[c' : '<cmd>lua require"gitsigns".prev_hunk()<CR>']],
  }, { expr = true })

  lmap.xo('ih', ':<C-U>lua require"gitsigns".select_hunk()<CR>')

  local gitsigns = lazy.require('gitsigns')
  local range = lazy(function()
    return { vim.fn.line('.'), vim.fn.line('v') }
  end)
  lmap.n('<leader>hs', -gitsigns.stage_hunk(),      { desc = 'gitsigns: stage hunk' })
  lmap.x('<leader>hs', -gitsigns.stage_hunk(range), { desc = 'gitsigns: stage hunk' })
  lmap.n('<leader>hu', -gitsigns.undo_stage_hunk(), { desc = 'gitsigns: undo stage hunk' })
  lmap.n('<leader>hr', -gitsigns.reset_hunk(),      { desc = 'gitsigns: reset hunk' })
  lmap.x('<leader>hr', -gitsigns.reset_hunk(range), { desc = 'gitsigns: reset hunk' })
  lmap.n('<leader>hR', -gitsigns.reset_buffer(),    { desc = 'gitsigns: reset buffer' })
  lmap.n('<leader>hp', -gitsigns.preview_hunk(),    { desc = 'gitsigns: preview hunk' })
  lmap.n('<leader>hb', -gitsigns.blame_line(),      { desc = 'gitsigns: blame line' })
end


-- MISC ----------------------------------------------------------------------------------
map.n('<leader>v', [[<cmd>keepjumps norm! ggVG<CR>]])
map.n('<leader>r', [[<cmd>call fzf#run(fzf#wrap({'source': pro#configs(), 'sink': 'Pro'}))<CR>]])
map.n('<leader>o', [[:lua require'm.ui.menus'.options()<CR>]])
map.x('<leader>t', ':Align<Space>')
map.nx('<leader>n', ':norm<Space>')
map.nx('<leader>N', ':norm!<Space>')
map.n('m=', ':Set makeprg<CR>')
map.n('zI', '<cmd>IndentBlanklineRefresh<CR>')


-- LSP AND DIAGNOSTICS -------------------------------------------------------------------
-- LSP buffer local setup in $VIMCONFIG/lua/m/lsp/buf.lua
do
  local diag = lazy.vim.diagnostic
  local lsp = lazy.vim.lsp.buf

  map.n('<leader>ld', [[<cmd>TroubleToggle<CR>]])
  map.n({
    ['g?'] = -diag.open_float(),
    [']g'] = -diag.goto_next({ float = false }),
    ['[g'] = -diag.goto_prev({ float = false }),
    [']G'] = -diag.goto_prev({ float = false, cursor_position = { 0, 0 } }),
    ['[G'] = -diag.goto_next({ float = false, cursor_position = { 0, 0 } }),
  })

  local lmap = map.new({ buf = 0, silent = true })

  -- LSP buffer local mappings
  function keymaps.lsp(client)
    lmap.n('K',     -lsp.hover())
    lmap.i('<C-K>', -lsp.signature_help()) -- TODO: used for digraphs, use <C-L> instead?
    lmap.n('<C-]>', -lsp.definition())
    lmap.n('go',    -lsp.type_definition())
    lmap.n('gd',    -lsp.declaration())
    lmap.n('gD',    -lsp.implementation())
    lmap.n('g]',    -lsp.references())
    lmap.n('gR',    -lsp.rename())
    lmap.n('g0',    -lsp.document_symbol())
    lmap.n('gW',    -lsp.workspace_symbol())
    lmap.n('ga',    -lsp.code_action())
    lmap.x('ga',    -lsp.range_code_action())
    lmap.x('gw',    -lsp.range_formatting())
    lmap.x('gq',    -lsp.range_formatting())

    lmap.n({
      ['g?'] = -diag.open_float(),
      [']d'] = -diag.goto_next({ float = false }),
      ['[d'] = -diag.goto_prev({ float = false }),
      [']D'] = -diag.goto_prev({ float = false, cursor_position = { 0, 0 } }),
      ['[D'] = -diag.goto_next({ float = false, cursor_position = { 0, 0 } }),
    })

    lmap.n('<leader>lS', ':Lsp stop<CR>')

    if client == 'clangd' then
      lmap.n('<leader>a', ':ClangdSwitchSourceHeader<CR>')
    end
  end
end


-- INSERT MODE ---------------------------------------------------------------------------
-- Emacs
map.i('<C-A>', '<C-O>^')
map.i('<C-E>', '<End>')
map.i('<C-F>', '<C-G>u<cmd>call m#bf#iforward()<CR>')
map.i('<C-B>', '<C-G>u<cmd>call m#bf#ibackward()<CR>')

-- Insert stuff
map.i({
  ['<C-R><C-D>']     = [[<C-R>=m#bufdir()<CR>]],
  ['<C-R><C-T>']     = [[<C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>]],
  ['<C-R><C-K>']     = [[<C-K>]],
  ['<C-R><C-Y>']     = [[<C-R>"]],
  ['<C-R><C-Space>'] = [[<C-R>+]],
}, { silent = true })

-- New line below/above
map.i({
  ['<C-G><C-J>'] = '<C-G>u<C-O>o',
  ['<C-G><C-K>'] = '<C-G>u<C-O>O',
})

-- Pairs
map.i('<Plug>(m-pair)', [[<cmd>lua require('m.pairs')()<CR>]])
map.i({
  ['<C-G><CR>']  = '<CR><C-O>O',
  ['<C-G><C-O>'] = '()<C-G>U<Left><Plug>(m-pair)',
  ['<C-G><C-B>'] = '{}<C-G>U<Left><Plug>(m-pair)',
  ['<C-G><C-A>'] = '<><C-G>U<Left><Plug>(m-pair)',
  ['<C-G><C-I>'] = '""<C-G>U<Left>',
}, { remap = true })

-- Luasnip
function keymaps.luasnip()
  local lmap = map.new({ silent = true })

  lmap.i('<Tab>', function()
    if require('luasnip').expand_or_jumpable() then
      return '<Plug>luasnip-expand-or-jump'
    else
      return '<Tab>'
    end
  end, { expr = true })
  lmap.s('<Tab>', -lazy.require('luasnip').jump(1))
  lmap.is('<S-Tab>', -lazy.require('luasnip').jump(-1))
  lmap.is('<Esc>', [[<Esc><cmd>silent LuaSnipUnlinkCurrent<CR>]])
  -- lmap.is('<C-E>', [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<End>']], { expr = true})
end


-- COMMAND LINE --------------------------------------------------------------------------
map.c({
  ['<C-P>'] = [[wildmenumode() ? '<C-P>' : '<Up>']],
  ['<C-N>'] = [[wildmenumode() ? '<C-N>' : '<Down>']],
}, { expr = true })

-- Emacs
map.c('<C-A>', '<Home>')
map.c('<C-F>', '<C-R>=m#bf#cforward()<CR>')
map.c('<C-B>', '<C-R>=m#bf#cbackward()<CR>')
map.c('<C-D>', '<Del>')
map.c('<C-O>', '<C-F>')
map.c('<C-X><C-A>', '<C-A>')
map.c('<C-X><C-X>', '<C-D>')
map.c('<C-X><C-L>', function()
  if not vim.fn.getcmdline():find('^%s*Redir') then
    vim.fn.setcmdpos(vim.fn.getcmdpos() + 6)
    return [[<C-\>e'Redir '..getcmdline()<CR>]]
  end
  return ' <BS>' -- <Ignore> or empty string glitches the cursor
end, { expr = true })

-- Insert stuff
map.c({
  ['<C-R><C-D>']     = [[<C-R>=m#bufdir()<CR>]],
  ['<C-R><C-T>']     = [[<C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>]],
  ['<C-R><C-Y>']     = [[<C-R>"]],
  ['<C-R><C-Space>'] = [[<C-R>+]],
})

-- Remap c_CTRL-{G,T} to free up CTRL-G mapping
map.c('<C-G><C-N>', '<C-G>')
map.c('<C-G><C-P>', '<C-T>')

-- Pairs
map.c({
  ['<C-G><C-O>'] = [[()<Left>]],
  ['<C-G><C-B>'] = [[{}<Left>]],
  ['<C-G><C-A>'] = [[<><Left>]],
  ['<C-G><C-I>'] = [[""<Left>]],
  ['<C-G><C-G>'] = [[\(\)<Left><Left>]],
  ['<C-G><C-W>'] = [[\<\><Left><Left>]],
}, { remap = true })

-- Lua expression
map.c('=', [[getcmdtype() == ':' && getcmdline() == '' ? 'lua=' : '=']], { expr = true })
map.n('<leader>=', ':lua=')

-- Last command with bang
map.n('!:', [[histget('cmd')[-1:] !=# '!' ? ':<Up>!' : ':<Up>']], { expr = true })
map.n('@!', function()
  if vim.api.nvim_eval('len(@:)') <= 0 then
    return '<cmd>echoerr "E30: No previous command line"<CR>'
  elseif vim.api.nvim_eval('@:[-1:]') ~= '!' then
    return '<cmd>execute @:.."!"<CR>'
  else
    return '@:'
  end
end, { desc = 'Rerun last command with bang', expr = true })


-- TERMDEBUG -----------------------------------------------------------------------------
map.n({
  ['<leader>dr'] = ':Run<CR>',
  ['<leader>dS'] = ':Stop<CR>',
  ['<leader>ds'] = ':Step<CR>',
  ['<leader>dn'] = ':Over<CR>',
  ['<leader>df'] = ':Finish<CR>',
  ['<leader>dc'] = ':Continue<CR>',
  ['<leader>db'] = ':Break<CR>',
  ['<leader>dB'] = ':Clear<CR>',
  ['<leader>de'] = ':Eval<CR>',
})


return keymaps
