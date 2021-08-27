# b64.nvim

Base64 encode and decode inside of vim.

Usage: Highlight some text then`:B64Encode<cr>` or `:B64Decode<cr>`

#### Install

```lua
-- packer
use { 'taybart/b64.nvim' }
```

```vim
" vim-plug
Plug 'taybart/b64.nvim'
```

#### Recommended Keymaps

```vim
vnoremap <silent> <leader>be :<c-u>lua require("b64").encode()<cr>
vnoremap <silent> <leader>bd :<c-u>lua require("b64").decode()<cr>
```
