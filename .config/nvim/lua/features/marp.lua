local Job = require("plenary.job")
local Marp = {}

function Marp.preview()
  Job:new({
    command = "marp",
    args = { "-p", vim.fn.expand("%:p") },
    on_exit = function(j, return_val)
      print(return_val)
      print(j:result())
    end,
  }):sync() -- or start()
end

vim.api.nvim_create_user_command("MarpPreview", function()
  Marp.preview()
end, {})

return Marp
