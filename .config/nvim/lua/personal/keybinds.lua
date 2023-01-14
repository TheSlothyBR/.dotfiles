local M = {}

M.options = {
  -- options set here affect which-key
  noremap = true, 
  silent = true,
  nowait = true
}

--@TODO parse vscode command field from keybinds
local function map(mode, key, action, args)
  local opts = M.options
  if args then
    vim.tbl_extend('force', opts, args)
  end
  vim.keymap.set(mode, key, action, opts)
end

local keys = function()
	local g = vim.g
	local A = vim.api
  -----------------
	-- Map leaders --
	-----------------

	g.mapleader = ' '
	g.maplocalleader = ' '

	--------------
	-- Keybinds --
	--------------

  --[[
    @TODO add vscode command field
    info on bindings: https://github.com/vscode-neovim/vscode-neovim#adding-keybindings
    nvim imode = normal vscode
    other modes are controlled by nvim
    MSWin location: %UserProfile%\AppData\Roaming\Code\User\keybindings.json
    Find in linux: 
      'which code' in bash
      'flatpak info --show-location com.visualstudio.code'
  ]]
  -- vim unused keys: https://vim.fandom.com/wiki/Unused_keys
  local modes = {
    all = {
      ['<BS>'] = {'d<left>', {desc = 'Backspace works like MSWin'}},
      ['jk'] = {'<esc>', {desc = 'Better Esc sequence', nowait = false}},
      ['kj'] = {'<esc>', {desc = 'Better Esc sequence', nowait = false}},
      ['<C-a>'] = {'gggH<C-O>G', {desc = 'Select all'}},
      ['<C-c>'] = {
        '"+y',
        {desc = 'Copy to system clipboard'},
        --@TODO add here vscode cmd with new 'action' field to notify vscode with new cmd
        {
          --'action' = 'VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})',
          command = 'vscode-neovim.send',
          -- the key sequence to activate the binding
          key = 'ctrl+h',
          -- don't activate during insert mode
          when = 'editorTextFocus && neovim.mode != insert',
          -- the input to send to Neovim. May work with keys from here?
          args = '<C-h>'
        }
      },
      ['<C-b>'] = {'I', {desc = 'Move to line start'}},
      ['<C-e>'] = {'A', {desc = 'Move to line end'}},
      ['<C-m>'] = {'<C-v>', {desc = 'Block selection mode'}},
      ['<C-q>'] = {':q<CR>', {desc = 'Quit neovim'}},
      ['<C-s>'] = {':update<CR>', {desc = 'Save current file'}},
      ['<C-v>'] = {'"+gP', {desc = 'paste from system clipboard', noremap = false}},
      ['<C-y>'] = {'<C-R>', {desc = 'Redo'}},
      ['<C-z>'] = {'u', {desc = 'Undo'}},
      ['<leader>d'] = {'o<esc>', {desc = 'Inserts blank line below cursor'}},
      ['<leader>u'] = {'O<esc>', {desc = 'Inserts blank line above cursor'}}
    },

    c = {
      ['<C-a>'] = {'<C-C><gggH<C-O>G', {desc = 'Select all'}},
      ['<C-c>'] = {'<C-R>+', {desc = 'Copy to system clipboard', noremap = false}}
    },

    i = {
      ['jk'] = {'<esc>', {desc = 'Better Esc sequence', nowait = false}},
      ['kj'] = {'<esc>', {desc = 'Better Esc sequence', nowait = false}},
      ['<C-a>'] = {'<C-o>gg<C-o>gH<C-o>G', {desc = 'Select all'}},
      ['<C-b>'] = {'<C-o>I', {desc = 'Move to line start'}},
      ['<C-d>'] = {'<C-o>o', {desc = 'Inserts blank line below cursor'}},
      ['<C-e>'] = {'<C-o>A', {desc = 'Move to line end'}},
      ['<C-f>'] = {'<C-o>/', {desc = 'Find', noremap = false}},
      ['<C-s>'] = {'<C-o>:update<CR>', {desc = 'Save current file'}},
      ['<C-u>'] = {'<C-o>O', {desc = 'Inserts blank line above cursor'}},
      ['<C-v>'] = {'<C-o>"+gP', {desc = 'Paste from system clipboard'}},
      ['<C-y>'] = {'<C-o><C-R>', {desc = 'Redo'}},
      ['<C-z>'] = {'<C-o>u', {desc = 'Undo'}}
    },

    n = {
      ['<C-right>'] = {'<C-w>l', {desc = 'Move to right panel'}},
      ['<C-left>'] = {'<C-w>h', {desc = 'Move to left panel'}},
      ['<C-up>'] = {'<C-w>j', {desc = 'Move to upper panel'}},
      ['<C-down>'] = {'<C-w>k', {desc = 'Move to downward panel'}},
      ['<leader>j'] = {':move .+1<CR>', {desc = 'Move line up'}},
      ['<leader>k'] = {':move .-2<CR>', {desc = 'Move line down'}}
    },

    o = {
      ['<C-a>'] = {'<C-C><gggH<C-O>G', {desc = 'Select all'}}
    },

    s = {
      ['<C-a>'] = {'<C-C><gggH<C-O>G', {desc = 'Select all'}}
    },

    v = {
      ['<C-s>'] = {'<C-C>:update<CR>', {desc = 'Save current file'}},
      ['<C-x>'] = {'"+x', {desc = 'Cut to system clipboard'}},
      ['<Leader>za'] = {'<esc>`>a><esc>`<i<<esc>', {desc = 'Surround visual selection <'}},
      ['<Leader>zb'] = {'<esc>`>a]<esc>`<i[<esc>', {desc = 'Surround visual selection ['}},
      ['<Leader>zc'] = {'<esc>`>a}<esc>`<i{<esc>', {desc = 'Surround visual selection {'}},
      ['<Leader>ze'] = {'<esc>`>a`<esc>`<i`<esc>', {desc = 'Surround visual selection `'}},
      ['<Leader>zp'] = {'<esc>`>a)<esc>`<i(<esc>', {desc = 'Surround visual selection ('}},
      ['<Leader>zq'] = {'<esc>`>a"<esc>`<i"<esc>', {desc = 'Surround visual selection "'}},
      ['<Leader>zs'] = {"<esc>`>a'<esc>`<i'<esc>", {desc = "Surround visual selection '"}}
    },

    x = {
      ['<C-a>'] = {'<C-C>ggVG', {desc = 'Select all'}},
      ['<leader>j'] = {":move '>+1<CR>gv=gv", {desc = 'Move line up'}},
      ['<leader>k'] = {":move '<-2<CR>gv=gv", {desc = 'Move line down'}}
    }
  }

	--------------
	-- Plugins --
	--------------

  -- defined in which-key.lua
  -- <leader>p is a blacklisted keybind to avoid conflict

	------------------
	-- Autocommands --
	------------------

  -- for function args: https://neovim.io/doc/user/api.html#nvim_create_autocmd()
  -- for full event list: https://neovim.io/doc/user/autocmd.html#autocmd-events
	A.nvim_create_autocmd('TextYankPost', {
		group = num_au,
    desc = 'Highlight the yank region',
		callback = function()
			vim.highlight.on_yank({ higroup = 'Visual', timeout = 120 })
		end
	})

  if not vim.g.vscode then
  --@TODO add packer autoreload on change
  end

	-------------------
	-- Register Keys --
	-------------------

  for mode, spec in pairs(modes) do
    for k, t in pairs(spec) do
      local v = t[1]
      local val = t[2]
      if not mode == 'all' then
        map(mode, k, v, val)
      else
        map('', k, v, val)
      end
    end
  end
end

M.init = function()
  if vim.g.vscode then
    -- to bind keys in VSCode with embedded neovim see: https://github.com/vscode-neovim/vscode-neovim#adding-keybindings
    -- bindings in nvim are turned off for safety
    return false
  else
    keys()
  end
end
return M