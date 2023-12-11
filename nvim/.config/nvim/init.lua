-- Set <space> asleader key.
-- NOTE: must happen before plugins are required.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 4 spaces for everything by default.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.o.hlsearch = false

-- Enable 24bit RGB colors in terminal.
vim.opt.termguicolors = true

-- Enable sign column.
vim.opt.signcolumn = 'yes'

-- set line number and make it relative.
vim.opt.nu = true
vim.opt.relativenumber = true

-- use osx system clipboard.
vim.opt.clipboard = 'unnamedplus'

-- display only a status bar only for a currently focused file
vim.opt.laststatus = 3

-- Install lazy.nvim plugin manager.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- LSP configuration
  'neovim/nvim-lspconfig',

  -- Nvim lua dev environment.
  {
    'folke/neodev.nvim',
    opts = {},
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },

  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {

      -- Add LSP completion capabilities.
      'hrsh7th/cmp-nvim-lsp',

      -- Snippet engine and its associated nvim-cmp source.
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
    },
  },

  --  Display function signature while filling out function arguments.
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {},
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },

  -- Treesitter.
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },

    config = function()
      local configs = require 'nvim-treesitter.configs'
      --- @type TSConfig
      local config = {
        ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'go', 'javascript', 'html', 'python' },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },

        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']b'] = { query = '@block.outer', desc = 'Next block start' },
              [']f'] = { query = '@function.outer', desc = 'Next function start' },
              [']a'] = { query = '@parameter.outer', desc = 'Next parameter start' },
            },
            goto_next_end = {
              [']B'] = { query = '@block.outer', desc = 'Next block end' },
              [']F'] = { query = '@function.outer', desc = 'Next function end' },
              [']A'] = { query = '@parameter.outer', desc = 'Next parameter end' },
            },
            goto_previous_start = {
              ['[b'] = { query = '@block.outer', desc = 'Previous block start' },
              ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
              ['[a'] = { query = '@parameter.outer', desc = 'Previous parameter start' },
            },
            goto_previous_end = {
              ['[B'] = { query = '@block.outer', desc = 'Previous block end' },
              ['[F'] = { query = '@function.outer', desc = 'Previous function end' },
              ['[A'] = { query = '@parameter.outer', desc = 'Previous parameter end' },
            },
          },
        },
      }
      configs.setup(config)
    end,
  },

  -- whichkey
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 100
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  -- telescope.nvim
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- colorscheme
  {
    'tanvirtin/monokai.nvim',
    priority = 1000,
    config = function() end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {}, -- this is equalent to setup({}) function
  },
}
local opts = {}

require('lazy').setup(plugins, opts)

local actions = require 'telescope.actions'
require('telescope').setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      width = 0.65,
    },
    --wrap_results = true,
    mappings = {
      i = {
        ['<esc>'] = actions.close,
      },
    },
  },
  pickers = {
    diagnostics = {
      --line_width = 250,
      --theme = "dropdown",
    },

    find_files = {
      hidden = true,
      --theme = "dropdown",
      line_width = 450,
    },
  },
}

-- Telescope keybindings.
local telescope_builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, {})
--vim.keymap.set('n', '<leader>cbf', telescope_builtin.current_buffer_fuzzy_find, {})
--vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
--vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
--vim.keymap.set('n', '<leader>xx', telescope_builtin.diagnostics, {})
--vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, {})
--vim.keymap.set('n', '<leader>xd', vim.diagnostic.open_float, {})
--vim.keymap.set('n', '<leader>cf', telescope_builtin.quickfix, {})
--
--
-- Splits.
vim.keymap.set('n', '<F2>', ':vsplit<CR>')
vim.keymap.set('n', '<F1>', ':split<CR>')
vim.keymap.set('n', '<S-L>', ':vertical resize +5 <CR>')
vim.keymap.set('n', '<S-H>', ':vertical resize -5 <CR>')
vim.keymap.set('n', '<S-J>', ':resize +2 <CR>')
vim.keymap.set('n', '<S-K>', ':resize -2 <CR>')
vim.keymap.set('n', '<C-L>', '<C-W><C-L>')
vim.keymap.set('n', '<C-H>', '<C-W><C-H>')
vim.keymap.set('n', '<C-J>', '<C-W><C-J>')
vim.keymap.set('n', '<C-K>', '<C-W><C-K>')

local wk = require 'which-key'
wk.register({
  f = {
    name = 'Telescope...',
    f = { 'Find Files' },
    b = { 'Buffers' },
    h = { 'Help Tags' },
  },
  g = {
    name = 'LSP motion',
    t = { 'LSP [t]ype Definition' },
  },
}, { prefix = '<leader>' })

wk.register({
  g = {
    d = { 'LSP [d]efinition' },
    I = { 'LSP [I]mplementation' },
  },
}, {})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local cmp = require 'cmp'
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup {
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  completion = {
    completeopt = 'noinsert,menuone,noselect',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm { select = true }, -- accept currently selected item.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  }),
}

local on_lsp_attach = function(_, bufnr)
  local opts2 = { buffer = bufnr, remap = false }
  vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover()
  end, opts2)
  vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, opts2)
  vim.keymap.set('n', 'gI', telescope_builtin.lsp_implementations, opts2)
  vim.keymap.set('n', '<leader>gt', telescope_builtin.lsp_type_definitions, opts2)

  require('lsp_signature').on_attach({
    bind = true,
    doc_lines = 0, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
    hint_enable = false,
    handler_opts = {
      border = 'none', -- double, rounded, single, shadow, none, or a table of borders
    },
  }, bufnr) -- Note: add in lsp client on-attach
end

require('lspconfig').lua_ls.setup {
  capabilities = capabilities,
  on_attach = on_lsp_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      completion = {
        showWord = 'Disable',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
        disable = { 'missing-fields' }, -- missing fields :)
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

require('lspconfig').pyright.setup {
  capabilities = capabilities,
  on_attach = on_lsp_attach,
}

require('lspconfig')['gopls'].setup {
  capabilities = capabilities,
  on_attach = on_lsp_attach,
}

-- efm language server config (for formatting and stuff)
-- TODO check this for acquiring paths to the executable.
-- https://github.com/creativenull/efmls-configs-nvim/blob/main/lua/efmls-configs/fs.lua
require('lspconfig').efm.setup {
  capabilities = capabilities,
  on_attach = on_lsp_attach,
  init_options = { documentFormatting = true },
  filetypes = { 'lua', 'python', 'go' },
  settings = {
    languages = {
      lua = {
        { formatCommand = 'stylua -', formatStdin = true },
      },
      python = {
        { formatCommand = 'black -q -', formatStdin = true },
      },
      go = {
        { formatCommand = 'gofmt', formatStdin = true },
      },
    },
  },
}

-- Diagnostic keymaps.
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })

-- colorscheme setup.
local monokai = require 'monokai'
local palette = monokai.classic
palette.black = '#111111'
palette.base0 = '#161613'
palette.base1 = '#1d1e19'
palette.base2 = '#272822'
palette.base3 = '#3b3c35'
palette.base4 = '#4b4c45'
--palette.base4 = '1c0c027'
palette.white = '#fdfff1'
monokai.setup {
  palette = palette,
  custom_hlgroups = {
    CursorLineNr = { fg = '#ffd866', bold = true },
    Pmenu = { bg = palette.base1 },
    PmenuSbar = { bg = palette.base1 },
    PmenuThumb = { bg = palette.white },
    PMenuSel = { bg = palette.base4 },
  },
}
vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg = palette.base2 })
vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg = palette.base2 })
vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = palette.base2 })

-- disable lsp kind highlights.
vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { fg = palette.white })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { fg = palette.white })

vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { fg = palette.white })
vim.api.nvim_set_hl(0, 'CmpItemKindField', { fg = palette.white })
vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { fg = palette.white })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { fg = palette.white })

vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { fg = palette.white })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { fg = palette.white })
vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { fg = palette.white })

local lualine_theme = {
  normal = {
    a = { fg = palette.base2, bg = palette.green, gui = 'bold' },
    b = { fg = palette.white, bg = palette.base1 },
    c = { fg = palette.white, bg = palette.base1 },
  },
  insert = { a = { fg = palette.black, bg = palette.purple, gui = 'bold' } },
  visual = { a = { fg = palette.black, bg = palette.yellow, gui = 'bold' } },
  replace = { a = { fg = palette.black, bg = palette.red, gui = 'bold' } },
  --[[
  inactive = {
    a = { fg = colors.pink, bg = colors.black, gui = 'bold' },
    b = { fg = colors.white, bg = colors.pink },
    c = { fg = colors.gray, bg = colors.black },
  },
	--]]
}

local lualine_config = require('lualine').get_config()
--print(vim.inspect(lualine_config.options))
lualine_config.options = {
  section_separators = '',
  component_separators = '',
  theme = lualine_theme,
}

require('lualine').setup(lualine_config)

require('barbar').setup {
  icons = {
    buffer_index = true,

    filetype = {
      enabled = false,
    },
  },
  maximum_padding = 1,
}

vim.api.nvim_set_hl(0, 'BufferCurrent', { bg = palette.base3 })
vim.api.nvim_set_hl(0, 'BufferCurrentIndex', { bg = palette.base3 })
vim.api.nvim_set_hl(0, 'BufferCurrentSign', { bg = palette.base3 })
vim.api.nvim_set_hl(0, 'BufferCurrentSignRight', { bg = palette.base3 })

vim.api.nvim_set_hl(0, 'BufferVisible', { bg = palette.base1 })
vim.api.nvim_set_hl(0, 'BufferVisibleIndex', { bg = palette.base1 })
vim.api.nvim_set_hl(0, 'BufferVisibleSign', { bg = palette.base1 })
vim.api.nvim_set_hl(0, 'BufferVisibleSignRight', { bg = palette.base1 })

vim.api.nvim_set_hl(0, 'BufferInactive', { bg = palette.base1 })
vim.api.nvim_set_hl(0, 'BufferInactiveIndex', { bg = palette.base1 })
vim.api.nvim_set_hl(0, 'BufferInactiveSign', { bg = palette.base1 })
vim.api.nvim_set_hl(0, 'BufferInactiveSignRight', { bg = palette.base1 })

vim.api.nvim_set_hl(0, 'BufferTabpageFill', { bg = palette.base2 })

local map = vim.api.nvim_set_keymap
local opts3 = { noremap = true, silent = true }
-- not sure about these keybinds, may conflict with some commands?
map('n', '<M-1>', '<Cmd>BufferGoto 1<CR>', opts3)
map('n', '<M-2>', '<Cmd>BufferGoto 2<CR>', opts3)
map('n', '<M-3>', '<Cmd>BufferGoto 3<CR>', opts3)
map('n', '<M-4>', '<Cmd>BufferGoto 4<CR>', opts3)
map('n', '<M-5>', '<Cmd>BufferGoto 5<CR>', opts3)
map('n', '<M-6>', '<Cmd>BufferGoto 6<CR>', opts3)
map('n', '<M-7>', '<Cmd>BufferGoto 7<CR>', opts3)
map('n', '<M-8>', '<Cmd>BufferGoto 8<CR>', opts3)
map('n', '<M-9>', '<Cmd>BufferGoto 9<CR>', opts3)
map('n', '<M-p>', '<Cmd>BufferPrevious<CR>', opts3)
map('n', '<M-n>', '<Cmd>BufferNext<CR>', opts3)
map('n', '<M-c>', '<Cmd>BufferClose<CR>', opts3)

local lsp_fmt_group = vim.api.nvim_create_augroup('LspFormattingGroup', {})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = lsp_fmt_group,
  callback = function(ev)
    --print(vim.inspect(ev))
    local efm = vim.lsp.get_active_clients { name = 'efm', bufnr = ev.buf }
    if vim.tbl_isempty(efm) then
      return
    end
    vim.lsp.buf.format { name = 'efm' }
  end,
})

-- 2 spaces for everyting lua.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua' },
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
  end,
})
