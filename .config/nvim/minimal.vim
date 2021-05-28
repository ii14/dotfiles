set noloadplugins

set splitbelow splitright                 " sane splits
set hidden                                " don't close buffers
set noswapfile                            " disable swap files
set undofile                              " persistent undo history
set directory=$VIMCACHE/swap              " swap files
set backupdir=$VIMCACHE/backup            " backup files
set undodir=$VIMCACHE/undo                " undo files
