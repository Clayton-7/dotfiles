vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
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

vim.opt.so = 9999 -- cursor always on center

-- enable highlight groups
vim.opt.termguicolors = true
vim.o.termguicolors = true

vim.opt.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.cursorline = true
vim.cmd("set rnu")                     -- relative numbers

vim.opt.guifont = { "JetBrains Mono" } -- font
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

    -- terminal
    { 'akinsho/toggleterm.nvim',                config = function() require("toggleterm").setup() end },

    -- debugger
    { 'mfussenegger/nvim-dap' },
    { "rcarriga/nvim-dap-ui",                   requires = { "mfussenegger/nvim-dap" } },

    -- highlight current word
    { "RRethy/vim-illuminate" },
    { 'booperlv/nvim-gomove' }, -- move lines

    -- session manager
    { 'Shatur/neovim-session-manager' },
    { "mcauley-penney/tidy.nvim",               config = function() require("tidy").setup() end }, --trim spaces
    { 'nvim-treesitter/nvim-treesitter-context' },                                                 -- show the function that you are in on top on the code
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },

    {
        'nvim-tree/nvim-web-devicons',
        opts = {},
    },

    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    'sindrets/diffview.nvim', -- see files diff

    -- Detect tabstop and shiftwidth automatically
    -- 'tpope/vim-sleuth',

    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            {
                'j-hui/fidget.nvim',
                tag = 'legacy',
                opts = {
                    window = {
                        blend = 0, -- &winblend for the window
                    },
                }
            },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {
            ignored_next_char = "[%w]",
            enable_check_bracket_line = false,
            fast_wrap = {
                map = '<a-e>',
                chars = { '{', '[', '(', '"', "'" },
                pattern = [=[[%'%"%>%]%)%}%,]]=],
                end_key = '$',
                keys = 'qwertyuiopzxcvbnmasdfghjkl',
                check_comma = true,
                manual_position = true,
                highlight = 'Search',
                highlight_grey = 'Comment'
            },
        }
    },

    "tikhomirov/vim-glsl",  -- glsl syntax highlight
    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
    },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim',  opts = {} },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add          = { text = '▌' }, -- https://www.fileformat.info/info/charset/UTF-32/list.htm?start=8680
                change       = { text = '▎' },
                delete       = { text = '▄' },
                topdelete    = { text = '▔' },
                changedelete = { text = '▏' },
                untracked    = { text = '┆' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
                    { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
                vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
                    { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
                vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = '[P]review [H]unk' })
            end,
        },
    },
    {
        -- Theme inspired by Atom
        'navarasu/onedark.nvim',
        priority = 1000,
        config = function()
            local green = "#99bc80"
            local orange = "#ce7700"
            local light_orange = "#ee9770"
            local yellow = "#dfbe81"

            -- borders on lsp popup
            local border = { border = "rounded" }
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border)
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border)
            vim.diagnostic.config{ float = border }

            require('onedark').setup{
                style = "warm",     -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
                transparent = true, -- Show/hide background
                colors = {
                    orange = green,
                    green = light_orange,
                },
                highlights = {
                    ['@punctuation'] = { fg = yellow },
                    ['@punctuation.bracket'] = { fg = yellow },
                    ['@punctuation.delimiter'] = { fg = yellow },
                    ['@lsp.type.type'] = { fg = green },
                    ['@type'] = { fg = green },
                    ['Type'] = { fg = green },
                    ['@lsp.type.struct'] = { fg = green },
                    ['Structure'] = { fg = green },
                    ['@operator'] = { fg = orange },
                },
            }

            vim.cmd.colorscheme 'onedark'
        end,
    },
    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = true,
                theme = 'onedark',
                section_separators = '',
                component_separators = { left = '⧸', right = '⧹' },
            },
        },
    },

    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            char = '│',
            show_trailing_blankline_indent = false,
        },
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
}, {})

local Path = require('plenary.path')
require('session_manager').setup {
    sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'),               -- The directory where the session files will be saved.
    path_replacer = '__',                                                      -- The character to which the path separator will be replaced for session files.
    colon_replacer = '++',                                                     -- The character to which the colon symbol will be replaced for session files.
    autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
    autosave_last_session = true,                                              -- Automatically save last session on exit and on session switch.
    autosave_ignore_not_normal = true,                                         -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
    autosave_ignore_dirs = {},                                                 -- A list of directories where the session will not be autosaved.
    autosave_ignore_filetypes = {                                              -- All buffers of these file types will be closed before the session is saved.
        'gitcommit',
        'gitrebase',
    },
    autosave_ignore_buftypes = {},    -- All buffers of these bufer types will be closed before the session is saved.
    autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
    max_path_length = 80,             -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
}


-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.api.nvim_command('set commentstring=//%s') -- // default comment symbol if does not have lsp

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup{
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
        file_ignore_patterns = {
            "libs",
            "assets/textures",
            "assets/models",
        },
        layout_strategy = "vertical",
        layout_config = {
            height = 0.99,
            width = 0.99,
            prompt_position = "bottom",
            preview_height = 0.7,
        },
    },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
require("telescope").load_extension("file_browser")

local telescope_bi = require('telescope.builtin')
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
-- vim.keymap.set('n', '<leader>/', function()
vim.keymap.set('n', '<leader>f', function()
    telescope_bi.current_buffer_fuzzy_find {
        layout_config = {
            height = 0.99,
            width = 0.99,
            prompt_position = "bottom",
            preview_height = 0.7,
        },
    }
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.filetype.add{ extension = { wgsl = "wgsl" } }

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
    modules = {},
    sync_install = false,
    ignore_install = {},
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'rust', 'vimdoc', 'vim', 'wgsl' },

    -- Autoinstall languages that are not installed. Defaults to false
    auto_install = true,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevelstart = 99 -- do not close folds when a buffer is opened

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then desc = 'LSP: ' .. desc end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('<leader>i', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<leader>I', vim.lsp.buf.signature_help, 'Signature Documentation')
    nmap('<leader>bf', vim.lsp.buf.format, 'format file')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    vim.o.tabstop = 4
    vim.o.shiftwidth = 4
    vim.o.softtabstop = 4
    vim.o.expandtab = true
    vim.opt.smartindent = true
    vim.opt.formatoptions = "tcqrj"

    -- -- Create a command `:Format` local to the LSP buffer
    -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    --     vim.lsp.buf.format()
    -- end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
local runtime_library = vim.api.nvim_get_runtime_file("", true)
table.insert(runtime_library, "${3rd}/Defold/library")

local servers = {
    -- clangd = {},
    -- gopls = {},
    -- rust_analyzer = {},
    -- gdscript = {},
    wgsl_analyzer = { -- https://github.com/wgsl-analyzer/wgsl-analyzer
        command = "wgsl_analyzer",
        filetypes = { "wgsl" },
    },
    lua_ls = {
        Lua = {
            diagnostics = {
                globals = {
                    'vim',
                    "init",
                    "on_message",
                    "on_input",
                    "gui",
                    "vmath",
                    "timer",
                    "msg",
                    "app",
                    "hash",
                    "sys",
                    "http",
                    "pprint",
                    "launcher",
                    "window",
                    "socket",
                    "sound",
                    "html5",
                    "defos",
                    "update",
                    "final",
                    "websocket",
                    "updater",
                    "go",
                    "appManager",
                    "final",
                    "webview",
                    "rnd",
                    "MD5",
                },
            },
            workspace = {
                checkThirdParty = false,
                library = runtime_library,
            },
            telemetry = { enable = false },
        },
    },
}
-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        }
    end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())


--------------------------------------------------------------------------- terminal

local ui = require("toggleterm.lazy").require("toggleterm.ui")

-- open/close terminal
local function set_terminal(open)
    if (open and not ui.find_open_windows()) or (not open and ui.find_open_windows()) then
        vim.cmd("ToggleTerm")
    end
end

--------------------------------------------------------------------------- DAP
local dap = require('dap')
local dapui = require('dapui')
dapui.setup()

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '➡', texthl = '', linehl = '', numhl = '' })

local function get_executable_path()
    local handle = io.popen('jq ".[0].output" compile_commands.json')
    if handle == nil then return end

    local result = tostring(handle:read("*a"))
    handle:close()

    result = result:gsub("\"", "")

    return result:gsub("\n", "")
end

dap.configurations.c = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = get_executable_path(),
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}

dap.configurations.cpp = dap.configurations.c

-- read launch.json from folder .vscode
require('dap.ext.vscode').load_launchjs(nil, { codelldb = { 'c', 'cpp' } })

dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        command = os.getenv("HOME") .. '/.config/nvim/codelldb/extension/adapter/codelldb', -- download from here: https://github.com/vadimcn/codelldb/releases
        args = { "--port", "${port}" },
    }
}

local function start_debug()
    if vim.api.nvim_get_mode().mode == 't' then set_terminal(false) end

    dap.continue()
    local started = type(dap.session()) == 'table'

    if not started then
        print('cannot debug an empty file!')
    end
end

dap.listeners.after.event_initialized["dapui_config"] = function()
    set_terminal(false)
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local function run()
    vim.cmd('TermExec cmd="clear && ninja run"')
end

local function build(run_app)
    vim.cmd('TermExec cmd="clear && bear -- ninja build"')

    if run_app then run() end
end
--------------------------------------------------------------------------------------------------------------------------------------------------

vim.keymap.set({ 'n', 't' }, "<esc>", function() set_terminal(false) end, { silent = true }) -- close terminal
vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "Toggle breakpoint", silent = true })
vim.keymap.set("n", "<leader>1", dap.step_into, { silent = true })
vim.keymap.set("n", "<leader>2", dap.step_over, { silent = true })
vim.keymap.set("n", "<leader>3", dap.step_out, { silent = true })
vim.keymap.set("n", "<leader>4", dap.terminate, { silent = true })
vim.keymap.set({ 'n', 't' }, "<leader>5", start_debug, { silent = true })                 -- run debug
vim.keymap.set({ 'n', 't' }, "<leader>6", function() build(false) end, { silent = true }) -- build
vim.keymap.set({ 'n', 't' }, "<leader>7", function() build(true) end, { silent = true })  -- build and run
vim.keymap.set({ 'n', 't' }, "<leader>8", run, { silent = true })                         -- run
vim.keymap.set('n', "<leader>9", dapui.eval, { silent = true })                           -- inspect values
-- vim.keymap.set("n", "<C-5>", dap.run_last, { silent = true })
vim.keymap.set("n", "<leader>0", dapui.toggle, { silent = true })


-- put/remove tabs
vim.keymap.set("n", "<tab>", ":><CR>", { silent = true })
vim.keymap.set("n", "<S-tab>", ":<<CR>", { silent = true })
vim.keymap.set("v", "<tab>", ":><CR>gv<CR>k", { silent = true })
vim.keymap.set("v", "<S-tab>", ":<<CR>gv<CR>k", { silent = true })

-- replace words
vim.keymap.set({ "v" }, "<C-f>", ":s/old/new/g")
vim.keymap.set({ "n" }, "<leader>f", ":s/old/new/g")
vim.keymap.set("n", "<leader>F", "*N:%s//new/gc")

vim.keymap.set('n', 'gi', telescope_bi.lsp_references, { desc = '[/] [G]oto [I]mplementation' })

-- Clear highlights
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear all highlights", silent = true })

-- open/close git diff
vim.opt.fillchars:append { diff = "╱" } -- diagonal line on diffs
vim.keymap.set("n", "<leader>od", ":DiffviewOpen<CR>", { desc = "Open diff view", silent = true })
vim.keymap.set("n", "<leader>oh", ":DiffviewFileHistory<CR>", { desc = "Open diff view history ", silent = true })
vim.keymap.set("n", "<leader>cd", ":DiffviewClose<CR>", { desc = "Close diff view", silent = true })

-- move lines
vim.keymap.set("n", "<S-h>", "<Plug>GoNSMLeft", { silent = true })
vim.keymap.set("n", "<S-j>", "<Plug>GoNSMDown", { silent = true })
vim.keymap.set("n", "<S-k>", "<Plug>GoNSMUp", { silent = true })
vim.keymap.set("n", "<S-l>", "<Plug>GoNSMRight", { silent = true })
vim.keymap.set("x", "<S-h>", "<Plug>GoVSMLeft", { silent = true })
vim.keymap.set("x", "<S-j>", "<Plug>GoVSMDown", { silent = true })
vim.keymap.set("x", "<S-k>", "<Plug>GoVSMUp", { silent = true })
vim.keymap.set("x", "<S-l>", "<Plug>GoVSMRight", { silent = true })

-- duplicate lines
vim.keymap.set("n", "<leader>j", "<Plug>GoNSDDown", { silent = true })
vim.keymap.set("n", "<leader>k", "<Plug>GoNSDUp", { silent = true })
vim.keymap.set("x", "<leader>j", "<Plug>GoVSDDown", { silent = true })
vim.keymap.set("x", "<leader>k", "<Plug>GoVSDUp", { silent = true })

vim.keymap.set({ 'n', 't' }, '<leader>t', "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal", silent = true })

-- Switch between header and source C files
vim.keymap.set("n", "<A-o>", function()
    local extension = vim.fn.expand("%:e")

    if extension == "c" then
        vim.cmd(":e %<.h")
    elseif extension == "h" then
        vim.cmd(":e %<.c")
    end
end, { silent = true })

vim.keymap.set("n", "<C-s>", ':w<CR>', { desc = "Save current buffer", silent = true }) -- save
vim.keymap.set("n", "<C-i>", '<C-I>', { silent = true }) -- go forward on jumplist

-- buffers
vim.keymap.set("n", "<c-tab>", function() vim.cmd("bn") end, { desc = "Next buffer", silent = true })
vim.keymap.set("n", "<c-s-tab>", function() vim.cmd("bp") end, { desc = "Previous buffer", silent = true })
vim.keymap.set("n", "<C-q>", ":bn<CR>:bd #<CR>", { desc = "Close current buffer", silent = true }) -- close buffer

-- better windows navegation
vim.keymap.set('n', "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set('n', "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set('n', "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set('n', "<C-l>", "<C-w>l", { silent = true })

vim.keymap.set({ "n", "v" }, "<C-z>", "") -- disable ctrl z
vim.keymap.set("n", "<C-b>", ":Telescope file_browser<CR>", { desc = "File browser", silent = true }) -- File browser

vim.keymap.set("v", "<leader>d", [[c"<C-r>""<Esc>]], { desc = "Wrap selected word with double quotes", silent = true }) -- wrap with double quotes
vim.keymap.set("v", "<leader>q", [[c'<C-r>"'<Esc>]], { desc = "Wrap selected word with single quotes", silent = true }) -- wrap with single quotes

vim.keymap.set("n", "ç", "^", { desc = "Go to the first word on current line", silent = true }) -- go to the first word on the line

-- yank to OS clipboard
vim.keymap.set("n", "<C-S-c>", '"+yy')
vim.keymap.set("v", "<C-S-c>", '"+y')
vim.keymap.set("v", "p", '"_dP', { silent = true })

vim.keymap.set("v", "y", 'ygv', { silent = true }) -- stay on visual mode after yank
vim.keymap.set("i", "<A-p>", "<C-o>p", { silent = true }) -- dont leave insert mode after yank

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=4 sts=4 sw=4 et
