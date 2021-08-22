" Debugger plugin using gdb.
"
" Author: Bram Moolenaar
" Copyright: Vim license applies, see ":help license"
" Last Change: 2021 May 16
"
" WORK IN PROGRESS - Only the basics work
" Note: On MS-Windows you need a recent version of gdb.  The one included with
" MingW is too old (7.6.1).
" I used version 7.12 from http://www.equation.com/servlet/equation.cmd?fa=gdb
"
" There are two ways to run gdb:
" - In a terminal window; used if possible, does not work on MS-Windows
"   Not used when g:termdebug_use_prompt is set to 1.
" - Using a "prompt" buffer; may use a terminal window for the program
"
" For both the current window is used to view source code and shows the
" current statement from gdb.
"
" USING A TERMINAL WINDOW
"
" Opens two visible terminal windows:
" 1. runs a pty for the debugged program, as with ":term NONE"
" 2. runs gdb, passing the pty of the debugged program
" A third terminal window is hidden, it is used for communication with gdb.
"
" USING A PROMPT BUFFER
"
" Opens a window with a prompt buffer to communicate with gdb.
" Gdb is run as a job with callbacks for I/O.
" On Unix another terminal window is opened to run the debugged program
" On MS-Windows a separate console is opened to run the debugged program
"
" The communication with gdb uses GDB/MI.  See:
" https://sourceware.org/gdb/current/onlinedocs/gdb/GDB_002fMI.html
"
" For neovim compatibility, the vim specific calls were replaced with neovim
" specific calls:
"   term_start -> term_open
"   term_sendkeys -> chansend
"   term_getline -> getbufline
"   job_info && term_getjob -> using linux command ps to get the tty
"   balloon -> nvim floating window
"
" The code for opening the floating window was taken from the beautiful
" implementation of LanguageClient-Neovim:
" https://github.com/autozimu/LanguageClient-neovim/blob/0ed9b69dca49c415390a8317b19149f97ae093fa/autoload/LanguageClient.vim#L304
"
" Neovim terminal also works seamlessly on windows, which is why the ability
" Author: Bram Moolenaar
" Copyright: Vim license applies, see ":help license"

" In case this gets sourced twice.
if exists(':Termdebug')
  finish
endif

" The command that starts debugging, e.g. ":Termdebug vim".
" To end type "quit" in the gdb window.
command! -nargs=* -complete=file -bang Termdebug
  \ call termdebug#StartDebug(<bang>0, <f-args>)
command! -nargs=+ -complete=file -bang TermdebugCommand
  \ call termdebug#StartDebugCommand(<bang>0, <f-args>)
