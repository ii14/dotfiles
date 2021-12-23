local uv = vim.loop

local M = {}

--- Preprocess ifile and write it to ofile
function M.compile(ofile, ifile)
  ifile = ifile or ofile..'.in'
  local input = vim.fn.readfile(ifile)
  local output = {}
  local defines = {}

  for lnum, line in ipairs(input) do
    local lhs, rhs = line:match('^"DEFINE%s+(%S+)%s+(.+)%s*$')
    if lhs and rhs then
      defines[lhs] = rhs
    elseif not line:match('^%s*"') then
      local idx = 1
      while true do
        local s, e, match = line:find('${(.-)}', idx)
        if s == nil then break end

        local sub = defines[match]
        if not sub then
          error(string.format('%s:%d: "%s" definition not found', ifile, lnum, match))
        end

        line = line:sub(0, s - 1) .. sub .. line:sub(e + 1)
        idx = e + 1 + (#sub - #match - 4)
      end
    end
    table.insert(output, line)
  end

  vim.fn.writefile(output, ofile)
end

--- Check timestamps if ofile has to be generated from ifile
function M.checkts(ofile, ifile)
  ifile = ifile or ofile..'.in'
  local istat = uv.fs_stat(ifile)
  if not istat then
    error('could not stat input file')
  end

  local ostat = uv.fs_stat(ofile)
  if not ostat then
    return true
  end

  local i = istat.mtime
  local o = ostat.mtime
  return i.sec > o.sec or (i.sec == o.sec and i.nsec > o.nsec)
end

--- Ensure ofile is compiled from ifile
function M.ensure(ofile, ifile)
  ifile = ifile or ofile..'.in'
  if M.checkts(ofile, ifile) then
    M.compile(ofile, ifile)
  end
  return true
end

return M
