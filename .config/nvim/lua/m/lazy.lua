local lazy = {}

function lazy.trouble()
  require('trouble').setup{
    icons = false,
    fold_open = "v",
    fold_closed = ">",
    signs = {
      error = "E",
      warning = "W",
      hint = "H",
      information = "i",
      other = "-",
    },
    padding = false,
  }
end

return lazy
