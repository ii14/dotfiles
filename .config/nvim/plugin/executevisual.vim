" Description: Execute visual selection

" TODO: proper range handling
command! -range ExecuteVisual call s:ExecuteVisual()

function! s:ExecuteVisual(...)
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  let lines[-1] = lines[-1][:column_end - 2]
  let lines[0] = lines[0][column_start - 1:]
  execute join(lines, "\n")
endfunction
