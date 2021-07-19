# b64.nvim

Install:

```shell
# packer
use { 'taybart/b64.nvim' }
# vim-plug
Plug 'taybart/b64.nvim'
```

Usage:

Highlight some text then`:B64Encode` or `:B64Decode`

Recommended Keymaps:

```vim
vnoremap <silent> <leader>be :<c-u>lua require("b64").encode()<cr>
vnoremap <silent> <leader>bd :<c-u>lua require("b64").decode()<cr>
```
