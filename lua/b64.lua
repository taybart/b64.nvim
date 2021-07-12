local M = {}

function M.serde()
  -- use b register
  local reg = 'b'

  -- save old reg contents
  local buf_cache = vim.fn.getreg(reg)

	-- Reselect the visual mode text, cut to reg b
	vim.cmd('normal! gv"bx')

  local update = vim.fn.getreg(reg)
  if op == "enc" then
    -- encode
    update = M.enc(update)
  elseif op == "dec" then
    -- decode
    update = M.dec(update)
  end

  -- insert new text
	vim.cmd('normal! i'..update)

  if vim.g.b64_select_after_serde == 1 then
    -- Select the new text
    vim.cmd('normal! `[v`]h')
  end

  -- restore buffer contents
  vim.fn.setreg(reg, buf_cache)
end

-- http://lua-users.org/wiki/BaseSixtyFour
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding
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
  return b:sub(c+1,c+1)
end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function M.dec(data)
  data = string.gsub(data, '[^'..b..'=]', '')
  return (data:gsub('.', function(x)
    if (x == '=') then return '' end
    local r,f='',(b:find(x)-1)
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
