local api, fn = vim.api, vim.fn
local cmp = require('cmp')

local MENU = {
  buffer   = 'BUF',
  luasnip  = 'SNIP',
  nvim_lsp = 'LSP',
  path     = 'PATH',
  syntax   = 'SYN',
}

local function src(source)
  return { config = { sources = { name = source } } }
end

local map = cmp.mapping

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<CR>'] = map.confirm({ select = false }),
    ['<C-Y>'] = map.confirm({ select = true }),
    ['<C-E>'] = function(fallback)
      if cmp.visible() then cmp.abort() end
      if cmp.get_active_entry() == nil then fallback() end
    end,
    ['<C-N>'] = map.select_next_item(),
    ['<C-P>'] = map.select_prev_item(),
    ['<C-X><C-X>'] = map.complete(),
    ['<C-X><C-O>'] = map(map.complete(src('nvim_lsp')), {'i'}),
    ['<C-X><C-N>'] = map(map.complete(src('buffer')), {'i'}),
    ['<C-X><C-S>'] = map(map.complete(src('luasnip')), {'i'}),
    ['<C-T>'] = map.scroll_docs(-3),
    ['<C-D>'] = map.scroll_docs(3),
  },
  sources = {
    -- { name = 'nvim_lsp' }, -- enabled in $VIMCONFIG/lua/m/lsp/buf.lua
    { name = 'syntax' },
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'path' },
  },
  formatting = {
    format = function(entry, item)
      -- abbreviate nvim api
      local source = entry.source
      if source.name == 'nvim_lsp'
          and source.context.filetype == 'lua'
          and item.abbr:find('^nvim_%l') then
        item.abbr = item.abbr:sub(6)
      end
      -- max width
      if item.abbr then
        if #item.abbr > 40 then
          item.abbr = item.abbr:sub(1, 39)..'…'
        end
      end
      -- completion source
      item.menu = MENU[entry.source.name] or entry.source.name
      return item
    end,
  },
})

local autocmd, line

cmp.event:on('menu_opened', function()
  -- close native completion
  if fn.pumvisible() ~= 0 then
    api.nvim_feedkeys(T'<C-E>', 'n', false)
  end

  line = fn.line('.')
  if autocmd then return end

  -- close window when cursor moved to a different line
  autocmd = api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
    desc = 'm.setup: close cmp window',
    callback = function()
      local nline = fn.line('.')
      if line ~= nline then
        line = nline
        cmp.close()
      end
    end,
  })
end)

cmp.event:on('menu_closed', function()
  if autocmd then
    api.nvim_del_autocmd(autocmd)
    autocmd = nil
  end
end)

api.nvim_create_autocmd('InsertEnter', {
  desc = 'm.setup: Register cmp syntax source',
  once = true,
  callback = function()
    cmp.register_source('syntax', require('cmp_syntax'))
  end,
})
