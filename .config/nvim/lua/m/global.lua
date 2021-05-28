--- Pretty print
P = function(v)
  print(vim.inspect(v))
  return v
end

--- Reload module
R = function(p)
  package.loaded[p] = nil
  return require(p)
end
