local M = {}
local whichkey = {
		settings = {
			plugins = {
				marks = true, -- shows a list of your marks on ' and `
				registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
				spelling = {
					enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
					suggestions = 20, -- how many suggestions should be shown in the list?
				},

				presets = {  -- the presets plugin, adds help for a bunch of default keybindings in Neovim. No actual key bindings are created
					operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
					motions = true, -- adds help for motions
					text_objects = true, -- help for text objects triggered after entering an operator
					windows = true, -- default bindings on <c-w>
					nav = true, -- misc bindings to work with windows
					z = true, -- bindings for folds, spelling and others prefixed with z
					g = true, -- bindings for prefixed with g
				},
			},

			nvim-tree.utils,
			operators = { gc = "Comments" }, -- add operators that will trigger motion and text object completion. To enable all native operators, set the preset / operators plugin above

      key_labels = {
				-- override the label used to display some keys. It doesn't effect WK in any other way.
				-- For example:
				-- ["<space>"] = "SPC",
				-- ["<cr>"] = "RET",
				-- ["<tab>"] = "TAB",
			},

			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "➜", -- symbol used between a key and it's label
				group = "+", -- symbol prepended to a group
			},

			popup_mappings = {
				scroll_down = '<A-j>', -- binding to scroll down inside the popup
				scroll_up = '<A-k>', -- binding to scroll up inside the popup
			},

			window = {
				border = "none", -- none, single, double, shadow
				position = "bottom", -- bottom, top
				margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
				padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
				winblend = 0
			},

			layout = {
				height = { min = 4, max = 25 }, -- min and max height of the columns
				width = { min = 20, max = 50 }, -- min and max width of the columns
				spacing = 3, -- spacing between columns
				align = "left", -- align columns left, center or right
			},

			ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
			hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
			show_help = false, -- show help message on the command line when the popup is visible
			show_keys = true, -- show the currently pressed key and its label as a message in the command line
			triggers = "auto", -- automatically setup triggers. triggers = {"<leader>"} or specify a list manually
			triggers_blacklist = {  -- list of mode / prefixes that should never be hooked by WhichKey
				i = { "j", "k" },     -- this is mostly relevant for key maps that start with a native binding
				v = { "j", "k" },     -- most people should not need to change this
			},

			disable = {  -- disable the WhichKey popup for certain buf types and file types.
				buftypes = {},
				filetypes = { "TelescopePrompt" }, -- Disabled by deafult for Telescope
			}
		},

  -- Plugins bindings only make sense when Packer is working, so they are defined here
	plugins = {
		p = {
      p = {
        name = 'Packer'
				c = { "<cmd>PackerCompile<cr>", "Regenerate compiled loader file" },
				i = { "<cmd>PackerInstall<cr>", "Clean, then install missing plugins" },
				r = { "<cmd>PackerClean<cr>", "Remove any disabled or unused plugins" },
				s = { "<cmd>PackerSync<cr>", "Perform `PackerUpdate` and then `PackerCompile`" },
				p = { "<cmd>PackerSync --preview<cr>", "Preview PackerSync" },
				e = { "<cmd>PackerStatus<cr>", "Show list of installed plugins" },
				u = { "<cmd>PackerUpdate<cr>", "Clean, then update and install plugins" }
			},

			t = {
		    -- Tree plugin requires special function for injecting keybinds  
        -- Keymapping example https://github.com/nvim-tree/nvim-tree.lua/blob/master/lua/nvim-tree/keymap.lua
		    -- Implementation of newer keybinding method https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt#L639 
				name = 'Tree'
        t = { "", "does tree things" }
			},

			n = {
		    -- Keybinds options https://github.com/luukvbaal/nnn.nvim#mappings
				name = 'nnn'
        n = { "", "does nnn things" }
			}
    }
	}
}

M.setup = function()
  local which_key = require("which-key")
	local mappings = whichkey.plugins
  
  local opts = function(args)
    local options = require('personal/keybinds').options
    vim.tbl_extend('force', options, args)
    return options
  end

	which_key.setup(whichkey.settings)
	which_key.register(mappings, opts({
                                      prefix = '<leader>',
                                      mode = '',
                                      buffer = nil
                                    }))
end
return M