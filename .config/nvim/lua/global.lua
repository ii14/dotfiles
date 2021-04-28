P = function(v)
  print(vim.inspect(v))
  return v
end

R = function(package)
  package.loaded[package] = nil
  return require(package)
end
