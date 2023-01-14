  -------------------
  --- Load config ---
  -------------------

  if vim.g.vscode then
	  require('personal/bootstrap').bootstrap()
  else
    local fn = vim.fn
    -- nvim data path defaults to ~/.local/share/nvim/
    --local runtime_dir = fn.stdpath('data')
    --local install_path = fn.stdpath(runtime_dir)..'/site/pack/packer/start/packer.nvim'
    local install_path = '/home/runner/.local/share/nvim' .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    end
    require('personal/bootstrap').bootstrap()
  end