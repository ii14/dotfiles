--- Pretty print
_G.P = function(...)
  local objs = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objs))
  return ...
end

--- Reload module
_G.R = function(p)
  package.loaded[p] = nil
  return require(p)
end

--- neovim API
_G.nvim = {}
for k, v in pairs(vim.api) do
  _G.nvim[k:gsub('^nvim_', '')] = v
end

--- for each
function _G.each(thing)
  local function start(x)
    return x(x)
  end

  local function body(x)
    local doit = function(...)
      thing(...)
      return x(x)
    end
    return doit
  end

  return start(body)
end
