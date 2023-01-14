local M = {}
local settings = function()
  ------------------------
  -- Boilerplate macros --
	------------------------

	local g = vim.g -- sets value to a global vim variable/option
	local o = vim.o -- sets value to a vim variable/option
	local opt = vim.opt -- used when setting returns obj, ideal for array-like options
	local A = vim.api -- access the full nvim API

  ---------------------
  -- Regular options --
	---------------------

  local options = {
  
	  ------------------
    -- Line numbers --
    ------------------
  
	  number = true,
	  numberwidth = 2,
	  relativenumber = false,
	  signcolumn = 'yes',
	  cursorline = true,
  
	  -------------------
    -- Clipboard fix --
    -------------------
  
	  clipboard = 'unnamedplus', -- nvim uses host clipboard
  
	  --------------------
	  -- Backup options --
	  --------------------
  
	  backup = false,
	  writebackup = false,
	  undofile = true,
	  swapfile = false,
  
	  ------------
	  -- Buffer --
	  ------------

	  hidden = true, -- required for multiple buffers to work
    splitright = true,
	  splitbelow = true,
    pumheight = 10, -- set pop up menu hight
  
	  ------------------
	  -- Enable mouse --
	  ------------------
  
	  --mouse = 'a',
	  mouse = 'nicr', -- mouse doesnt force v mode
  
	  -------------
	  -- Editing --
	  -------------
  
	  syntax = 'on',
	  expandtab = true,
	  smarttab = true,
	  cindent = true,
	  autoindent = true,
	  wrap = true,
    showtabline = 2, -- always shows tabs
	  textwidth = 300,
	  tabstop = 4,
	  shiftwidth = 4,
	  softtabstop = -1, -- shiftwidth value is used if negative
	  list = true,
	  listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂',
    undodir = undodir,
    undofile = true,
    fileencoding = 'utf-8',
    --timeoutlen = 500,
    --ttimeoutlen = 500,

    ------------
    -- Search --
    ------------

	  ignorecase = true, -- case sensitive only when upper is typed
	  smartcase = true, 
	  jumpoptions = 'view', -- preserve view while jumping
	  hlsearch = true, -- enable highlight in search

    ----------------
	  -- MSWin mode --
	  ----------------

	  keymodel = 'startsel', -- prevent CTRL-F to abort selection in v mode
	  mousemodel = 'extend', -- right mouse button extends a selection
	  selection = 'inclusive', -- defines the behavior of the selection in v and s modes
	  selectmode = 'key,mouse,cmd' -- allows shift to select
  }

  -------------------------
  -- Mount options table --
  -------------------------

  for k, v in pairs(options) do
    opt[k] = v
  end

  -----------------
	-- Colorscheme --
	-----------------

	local ok, _ = pcall(vim.cmd, 'colorscheme nord') -- load file with known errors
	o.termguicolors = true
	o.background = 'dark'
	-- change cursorLine colors to emphasise position
	A.nvim_set_hl(0, "CursorLine", { cterm=bold, ctermbg=0 })
	A.nvim_set_hl(0, "CursorLineNr", { cterm=bold, ctermbg=0 })
  
	----------------------------------
  -- Options that arent key pairs --
  ----------------------------------

  -- Search
	o.wildmenu = true
	opt.path:append({ "**" }) -- fuzzyfinder

  -- Editing
	opt.iskeyword:append("-")
	opt.whichwrap:append( '<,>,h,l,[,]' )
  opt.shortmess:append('c') -- dont show redundant mesagens from ins-completion-menu

  -- MSWin mode
	if vim.loop.os_uname().sysname == "Windows" then
    opt.guioptions:remove { 'a' } -- CTRL-V works when autoselect must be off. Only needed on Win
  end
end

M.init = function()
  settings()
end
return M