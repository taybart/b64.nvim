local b64 = {}

-- encode selected text to base64
function b64.encode()
  b64.encdec(b64.enc)
end

-- decode selected text from base64
function b64.decode()
  b64.encdec(b64.dec)
end

-- grab selected text and perform encode/decode
function b64.encdec(op)
  -- save paste mode
  local paste = vim.opt.paste
  -- turn paste on
  vim.opt.paste = true

  -- use b register as cache
  local reg = 'b'
  -- cache old reg contents
  local buf_cache = vim.fn.getreg(reg)

  -- grab previously selected text into reg
  if vim.fn.mode() == 'n' then
    vim.cmd('normal! gv')
  end
  vim.cmd('normal! "' .. reg .. 'x')

  -- perform op passed enc/dec
  local update = op(vim.fn.getreg(reg))

  -- paste update into buffer
  vim.api.nvim_paste(update, true, -1)

  -- should reselect text
  if vim.g.b64_select_after_serde == true then
    -- Select the new text
    vim.cmd('normal! `[v`]h')
  end

  -- restore buffer contents
  vim.fn.setreg(reg, buf_cache)
  -- reset paste mode
  vim.opt.paste = paste
end

-- http://lua-users.org/wiki/BaseSixtyFour
local dic = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
-- encoding
function b64.enc(data)
  return (
    (data:gsub('.', function(x)
      local r, b = '', x:byte()
      for i = 8, 1, -1 do
        r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0')
      end
      return r
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
      if #x < 6 then
        return ''
      end
      local c = 0
      for i = 1, 6 do
        c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0)
      end
      return dic:sub(c + 1, c + 1)
    end) .. ({ '', '==', '=' })[#data % 3 + 1]
  )
end

-- decoding
function b64.dec(data)
  data = string.gsub(data, '[^' .. dic .. '=]', '')
  return (
    data
      :gsub('.', function(x)
        if x == '=' then
          return ''
        end
        local r, f = '', (dic:find(x) - 1)
        for i = 6, 1, -1 do
          r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0')
        end
        return r
      end)
      :gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then
          return ''
        end
        local c = 0
        for i = 1, 8 do
          c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
      end)
  )
end

return b64
