local M = {}
M.bootstrap = function()
  require('personal/keybinds').init()
  require('personal/settings').init()
  if not vim.g.vscode then
    require('personal/plugins').init()
  end
end
return M