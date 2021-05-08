if !exists('g:tabular_loaded')
  finish
endif

AddTabularPattern dict /^[^:]*\zs:/l1
AddTabularPattern edict /^[^=]*\zs=/l1
