local Sudo = {}
local Log = {}

function Log.info(msg)
  vim.cmd("echohl Directory")
  Log._echo_multiline(msg)
  vim.cmd("echohl None")
end

function Log.err(msg)
  vim.cmd("echohl ErrorMsg")
  Log._echo_multiline(msg)
  vim.cmd("echohl None")
end

function Log.warn(msg)
  vim.cmd("echohl WarningMsg")
  Log._echo_multiline(msg)
  vim.cmd("echohl None")
end

function Log._echo_multiline(msg)
  for _, s in ipairs(vim.fn.split(msg, "\n")) do
    vim.cmd("echom '" .. s:gsub("'", "''") .. "'")
  end
end

Sudo.sudo_exec = function(cmd, print_output)
  vim.fn.inputsave()
  local password = vim.fn.inputsecret("Password: ")
  vim.fn.inputrestore()
  if not password or #password == 0 then
    Log.warn("Invalid password, sudo aborted")
    return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    print("\r\n")
    Log.err(out)
    return false
  end
  if print_output then
    print("\r\n", out)
  end
  return true
end

Sudo.sudo_write = function(tmpfile, filepath)
  if not tmpfile then
    tmpfile = vim.fn.tempname()
  end
  if not filepath then
    filepath = vim.fn.expand("%")
  end
  if not filepath or #filepath == 0 then
    Log.err("E32: No file name")
    return
  end
  -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1M` and `bs=1m` are non-POSIX
  local cmd = string.format(
    "dd if=%s of=%s bs=1048576",
    vim.fn.shellescape(tmpfile),
    vim.fn.shellescape(filepath)
  )
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec(string.format("write! %s", tmpfile), true)
  if Sudo.sudo_exec(cmd) then
    Log.info(string.format([[\r\n"%s" written]], filepath))
    vim.cmd("e!")
  end
  vim.fn.delete(tmpfile)
end

return Sudo
