# b64.nvim

Base64 encode and decode inside of vim.


#### Install

```lua
-- packer
use { 'taybart/b64.nvim' }
```

```vim
" vim-plug
Plug 'taybart/b64.nvim'
```

#### Usage

Highlight some text then`:B64Encode<cr>` or `:B64Decode<cr>`

Programatically:

```lua
local p = 'hello world'
local b = require('b64').enc(p)
print(b) -- aGVsbG8gd29ybGQ=
p = require('b64').dec(b)
print(p) -- hello world
```


#### Recommended Keymaps

```vim
vnoremap <silent> <leader>be :<c-u>lua require("b64").encode()<cr>
vnoremap <silent> <leader>bd :<c-u>lua require("b64").decode()<cr>
```
