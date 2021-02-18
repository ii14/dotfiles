# pro.vim

Simple config management.

`pro.vim` replicates the build configuration feature from IDEs, allowing to quickly switch
between different build settings, like debug or release mode. This plugin does not provide
any functionality of defining configurations per project, it is recommended to use it with
[ii14/exrc.vim](https://github.com/ii14/exrc.vim) plugin or with builtin `'exrc'` option.


## Usage

Define `g:pro` dictionary in `.exrc` file in your project root directory. For example:

```vim
let g:pro = {}

let g:pro.release = {
  \ '&makeprg'     : 'make -j -C build/release',
  \ 'g:qmake#dir'  : 'build/release',
  \ '$MY_ENV_VAR'  : 'example value',
  \ }

let g:pro.debug = {
  \ '&makeprg'     : 'make -j -C build/debug',
  \ 'g:qmake#dir'  : 'build/debug',
  \ 'g:qmake#args' : 'CONFIG+=debug',
  \ }

let g:pro.test = {
  \ '&makeprg'     : 'make -j -C build/test && ./build/test/test',
  \ 'g:qmake#dir'  : 'build/test',
  \ 'g:qmake#args' : 'CONFIG+=debug CONFIG+=test',
  \ }

" Set default config
let g:pro#default = 'debug'
```

Switch between configurations with `:Pro` command:

```vim
:Pro release
```


## Integration with other plugins

### [fzf.vim](https://github.com/junegunn/fzf.vim)

```vim
nnoremap <silent> <leader>r :call fzf#run(fzf#wrap({'source': pro#configs(), 'sink': 'Pro'}))<CR>
```

### [lightline.vim](https://github.com/itchyny/lightline.vim)

```vim
let g:lightline = {}

let g:lightline.active = {
  \ 'left': [
  \   ['mode', 'paste'],
  \   ['pro', 'readonly', 'filename', 'modified'],
  \ ]}

let g:lightline.component_function = {
  \ 'pro': 'pro#selected',
  \ }
```
