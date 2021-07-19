local M = {}

function M.encode()
  M.encdec(M.enc)
end
function M.decode()
  M.encdec(M.dec)
end

function M.encdec(op)
  local paste = vim.opt.paste
  vim.opt.paste=true
  -- use b register
  local reg = 'b'

  -- save old reg contents
  local buf_cache = vim.fn.getreg(reg)

	-- Reselect the visual mode text, cut to reg b
	vim.cmd('normal! gv"'..reg..'x')

  local update = op(vim.fn.getreg(reg))

  local cur_col = vim.api.nvim_win_get_cursor(0)[2]
  local line_end = vim.fn.strwidth(vim.api.nvim_get_current_line())

  -- insert new text
  if cur_col == line_end-1 then
    vim.cmd('normal! A'..update)
  else
    vim.cmd('normal! i'..update)
  end

  if vim.g.b64_select_after_serde == 1 then
    -- Select the new text
    vim.cmd('normal! `[v`]h')
  end

  -- restore buffer contents
  vim.fn.setreg(reg, buf_cache)
  vim.opt.paste=paste
end

-- http://lua-users.org/wiki/BaseSixtyFour
local dic='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
-- encoding
function M.enc(data)
  return ((data:gsub('.', function(x)
    local r,b='',x:byte()
    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
    return r;
  end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
  if (#x < 6) then return '' end
  local c=0
  for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
  return dic:sub(c+1,c+1)
end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function M.dec(data)
  data = string.gsub(data, '[^'..dic..'=]', '')
  return (data:gsub('.', function(x)
    if (x == '=') then return '' end
    local r,f='',(dic:find(x)-1)
    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    return r;
  end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
  if (#x ~= 8) then return '' end
  local c=0
  for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
  return string.char(c)
end))
end

return M
