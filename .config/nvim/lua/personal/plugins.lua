local M = {}
--------- Generalise ~/ --------
local PATH = '~/.config/nvim/lua/personal'
--------------------------------
M.init = function()
  -- guide for lua configuring https://github.com/nanotee/nvim-lua-guide
  -- good stuff to add: https://github.com/brainfucksec/neovim-lua/blob/main/nvim/lua/packer_init.lua
  return require('packer').startup(function()
        ---------------------
        -- Package Manager --
        ---------------------
  	-- Comprehensive 'use' table https://github.com/wbthomason/packer.nvim#specifying-plugins
    -- pinned to stable commit hash
  	use { 'wbthomason/packer.nvim', tag = "*" }
        ----------------------------------------
        -- Theme, Icons, Statusbar, Bufferbar --
        ----------------------------------------
  	-- examples for .setup() at https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/plugins.lua
  	use 'kyazdani42/nvim-web-devicons'
  	-- example write theme in lua https://github.com/LunarVim/onedarker.nvim
  	--use {
    --  PATH .. '/themes/custom.nvim',
    --  config = function() require(PATH..'/plugins/custom').setup() end
    --}

    use {
  		'nvim-lualine/lualine.nvim',
  		--after = PATH .. '/themes/custom-line.nvim',
  		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  		config = function() require(PATH .. '/plugins/lualine').setup() end
  	}

	  use {
	  	"folke/which-key.nvim",
	  	config = function() require(PATH .. '/plugins/which-key').setup() end
	  }

	  	-----------------------
      --- File management ---
      -----------------------
	  --@TODO Choose which file tree plugin to use
	  use {
	  	'kyazdani42/nvim-tree.lua',
	  	requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	  }

	  --use {
	  --	"luukvbaal/nnn.nvim",
	  --	config = function() require("nnn").setup() end
	  --}
	end)
end

return M