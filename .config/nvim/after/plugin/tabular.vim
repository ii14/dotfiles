if !exists('g:tabular_loaded')
  finish
endif

AddTabularPattern dict /^[^:]*\zs:/l1
