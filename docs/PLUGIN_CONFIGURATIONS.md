# Plugin Configuration Documentation

<!--toc:start-->
- [Plugin Configuration Documentation](#plugin-configuration-documentation)
  - [Plugin Organization](#plugin-organization)
  - [1-base-behaviors.lua - Core Behaviors](#1-base-behaviorslua---core-behaviors)
    - [File Management](#file-management)
    - [Project Management](#project-management)
    - [Text Processing](#text-processing)
    - [Buffer Management](#buffer-management)
    - [Terminal Integration](#terminal-integration)
    - [Search & Replace](#search--replace)
    - [Special Features](#special-features)
  - [2-ui.lua - User Interface](#2-uilua---user-interface)
    - [Themes](#themes)
    - [Greeter & Dashboard](#greeter--dashboard)
    - [Notifications & Feedback](#notifications--feedback)
    - [Visual Enhancements](#visual-enhancements)
    - [Search Interface](#search-interface)
    - [UI Components](#ui-components)
    - [Icons & Symbols](#icons--symbols)
  - [3-dev-core.lua - Development Core](#3-dev-corelua---development-core)
    - [Syntax Highlighting](#syntax-highlighting)
    - [LSP Infrastructure](#lsp-infrastructure)
    - [Auto Completion](#auto-completion)
  - [4-dev.lua - Development Tools](#4-devlua---development-tools)
    - [Testing Framework](#testing-framework)
    - [Debugging (DAP)](#debugging-dap)
    - [Documentation](#documentation)
    - [Language-Specific Tools](#language-specific-tools)
    - [Code Intelligence](#code-intelligence)
<!--toc:end-->

## Plugin Organization

NormalNvim organizes plugins into four categories for maintainability and performance:

- **1-base-behaviors**: Core workflow behaviors and essential functionality
- **2-ui**: Visual interface, themes, and user experience enhancements  
- **3-dev-core**: Essential development tools (LSP, completion, syntax highlighting)
- **4-dev**: Advanced development tools (testing, debugging, documentation)

Each plugin is configured with:
- **Lazy loading**: Event-based or command-based loading for performance
- **Conditional loading**: `is_available()` checks for optional dependencies
- **Platform awareness**: Android and Windows-specific optimizations
- **Feature toggles**: Global variables for user customization

---

## 1-base-behaviors.lua - Core Behaviors

**Overview**: Essential plugins that modify core Neovim behaviors and add fundamental workflow capabilities.

### File Management

**yazi.nvim** - Modern file browser
```lua
{
  "mikavilpas/yazi.nvim",
  event = "User BaseDefered",
  cmd = { "Yazi", "Yazi cwd", "Yazi toggle" },
  opts = {
    open_for_directories = true,
    floating_window_scaling_factor = (is_android and 1.0) or 0.71
  },
}
```
- **Purpose**: System file browser integration with yazi
- **Commands**: `:Yazi`, `:Yazi cwd`, `:Yazi toggle`
- **Key Features**: Directory opening, floating windows, Android optimization
- **Dependencies**: yazi system package required

**neotree** - Tree-style file explorer
```lua
{
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  cmd = { "Neotree" },
  opts = {
    -- Sidebar file explorer configuration
    close_if_last_window = true,
    enable_git_status = true,
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      }
    }
  }
}
```
- **Purpose**: Sidebar file tree navigation
- **Integration**: Git status, file icons, filtering
- **Performance**: Command-based loading, smart window management

### Project Management

**project.nvim** - Project detection and management
```lua
{
  "zeioth/project.nvim",
  event = "User BaseDefered",
  cmd = "ProjectRoot",
  opts = {
    patterns = {
      ".git", "_darcs", ".hg", ".bzr", ".svn",
      "Makefile", "package.json", ".solution", ".solution.toml"
    },
    exclude_dirs = { "~/" },
    silent_chdir = true,
    manual_mode = false,
    exclude_chdir = {
      filetype = {"", "OverseerList", "alpha"},
      buftype = {"nofile", "terminal"},
    },
  },
}
```
- **Purpose**: Automatic project root detection and directory changing
- **Detection**: Git repositories, build files, package managers
- **Behavior**: Silent directory changing, buffer type exclusions
- **Integration**: Works with LSP and other tools expecting project context

### Text Processing

**trim.nvim** - Automatic whitespace management
```lua
{
  "cappyzawa/trim.nvim",
  event = "BufWrite",
  opts = {
    trim_on_write = true,
    trim_trailing = true,
    trim_last_line = false,
    trim_first_line = false,
  },
}
```
- **Purpose**: Automatic trailing whitespace removal on save
- **Behavior**: Preserves intentional line breaks, configurable patterns
- **Performance**: Only loads on buffer write events

**nvim-autopairs** - Automatic bracket/quote pairing
```lua
{
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,          -- Use treesitter for intelligent pairing
    ts_config = {
      lua = { "string" },     -- Language-specific rules
      javascript = { "string", "template_string" },
    }
  }
}
```
- **Purpose**: Auto-close brackets, quotes, and other pairs
- **Intelligence**: Treesitter integration for context-aware pairing
- **Toggle**: Controlled by `vim.g.autopairs_enabled`

### Buffer Management

**mini.bufremove** - Smart buffer deletion
```lua
{
  "echasnovski/mini.bufremove",
  event = "User BaseDefered",
  opts = {}
}
```
- **Purpose**: Delete buffers without closing windows
- **Integration**: Preserves window layout and special buffers
- **Commands**: Smart buffer removal with confirmation

**stickybuf.nvim** - Lock special buffers
```lua
{
  "arnamak/stickybuf.nvim",
  event = "User BaseDefered",
  opts = {
    get_auto_pin = function(bufnr)
      -- Pin special buffer types to their windows
      local buftype = vim.bo[bufnr].buftype
      local filetype = vim.bo[bufnr].filetype
      return vim.tbl_contains(special_buftypes, buftype) 
          or vim.tbl_contains(special_filetypes, filetype)
    end
  }
}
```
- **Purpose**: Prevent special buffers (terminal, help, etc.) from being replaced
- **Behavior**: Automatic pinning of special buffer types
- **Integration**: Works with aerial, terminal, and other specialized buffers

### Terminal Integration

**toggleterm.nvim** - Terminal management
```lua
{
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    size = 20,
    open_mapping = [[<F7>]],
    hide_numbers = true,
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    direction = "horizontal",
    close_on_exit = true,
    shell = vim.o.shell,
  }
}
```
- **Purpose**: Integrated terminal with multiple terminal support
- **Features**: Floating/split terminals, persistent sessions, command execution
- **Keybindings**: F7 toggle, insert mode support
- **Integration**: Git integration, command runners

### Search & Replace

**nvim-spectre** - Project-wide search and replace
```lua
{
  "nvim-pack/nvim-spectre",
  cmd = "Spectre",
  opts = {
    live_update = true,
    line_sep_start = "┌-----------------------------------------",
    result_padding = "¦  ",
    line_sep       = "└-----------------------------------------",
  }
}
```
- **Purpose**: Advanced search and replace across entire project
- **Features**: Live preview, regex support, file filtering
- **Dependencies**: fd for file finding, ripgrep for searching
- **UI**: Custom interface with visual feedback

### Special Features

**nvim-ufo** - Advanced folding
```lua
{
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "User BaseDefered",
  opts = {
    provider_selector = function(bufnr, filetype, buftype)
      return {'treesitter', 'indent'}
    end
  }
}
```
- **Purpose**: Enhanced folding with treesitter and LSP integration
- **Providers**: Treesitter-based intelligent folding, indent fallback
- **Performance**: Async folding computation

**zen-mode.nvim** - Distraction-free writing
```lua
{
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  opts = {
    window = {
      backdrop = 0.95,
      width = 80,
      height = 1,
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
      },
    }
  }
}
```
- **Purpose**: Focus mode for distraction-free editing
- **Features**: Centered window, hidden UI elements, customizable width
- **Integration**: Preserves essential functionality while minimizing distractions

**hop.nvim** - Visual navigation
```lua
{
  "smoka7/hop.nvim",
  cmd = { "HopWord", "HopLine", "HopChar1", "HopChar2" },
  opts = { keys = "etovxqpdygfblzhckisuran" }
}
```
- **Purpose**: Jump to any word/line/character visually
- **Navigation**: EasyMotion-style movement with character hints
- **Performance**: Command-based loading, optimized key sequences

**nvim-lightbulb** - Code action indicator
```lua
{
  "kosayoda/nvim-lightbulb",
  event = "LspAttach",
  opts = {
    autocmd = { enabled = true },
    sign = { enabled = true, text = "💡" },
    float = { enabled = false },
    virtual_text = { enabled = false },
  }
}
```
- **Purpose**: Visual indicator for available LSP code actions
- **Display**: Sign column lightbulb when actions available
- **Performance**: LSP-event based loading, minimal UI impact

---

## 2-ui.lua - User Interface

**Overview**: Visual enhancements, themes, and user experience improvements that make Neovim more pleasant and productive to use.

### Themes

**tokyonight.nvim** - Popular dark theme
```lua
{
  "folke/tokyonight.nvim",
  event = "User LoadColorSchemes",
  opts = {
    dim_inactive = false,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
    },
  },
}
```
- **Variants**: night, storm, day, moon
- **Features**: Italic support, inactive window dimming
- **Integration**: Full plugin ecosystem support

**astrotheme** - NormalNvim default theme
```lua
{
  "AstroNvim/astrotheme",
  event = "User LoadColorSchemes", 
  opts = {
    palette = "astrodark",
    plugins = { ["dashboard-nvim"] = true },
  },
}
```
- **Default**: astrodark variant used by default
- **Integration**: Dashboard and plugin-specific theming
- **Variants**: astrodark, astrolight, astromars

### Greeter & Dashboard

**alpha-nvim** - Start screen
```lua
{
  "goolord/alpha-nvim",
  cmd = "Alpha",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    -- Custom header and buttons configuration
    dashboard.section.buttons.val = {
      dashboard.button("n", "  New File", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", "  Recent Files", ":Telescope oldfiles <CR>"),
      dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
      dashboard.button("s", "  Settings", ":e $MYVIMRC <CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }
    return dashboard
  end
}
```
- **Purpose**: Customizable start screen with quick actions
- **Features**: ASCII art header, quick action buttons, recent files
- **Lazy Loading**: Command-based loading for faster startup

### Notifications & Feedback

**nvim-notify** - Enhanced notifications
```lua
{
  "rcarriga/nvim-notify", 
  event = "User BaseDefered",
  opts = {
    timeout = 3000,
    max_height = function() return math.floor(vim.o.lines * 0.75) end,
    max_width = function() return math.floor(vim.o.columns * 0.75) end,
    background_colour = "Normal",
    fps = 30,
    icons = {
      DEBUG = "",
      ERROR = "",
      INFO = "",
      TRACE = "✎",
      WARN = ""
    },
    level = 2,
    minimum_width = 50,
    render = "default",
    stages = "fade_in_slide_out",
    top_down = true
  }
}
```
- **Purpose**: Rich notification system with animations
- **Features**: Multiple render styles, timeout management, icon support
- **Performance**: Configurable FPS and size limits

**mini.animate** - Smooth animations
```lua
{
  "echasnovski/mini.animate",
  event = "User BaseDefered",
  opts = {
    cursor = { enable = false },  -- Disable cursor animations
    scroll = {
      enable = true,
      timing = 50,  -- Fast scroll animations
    },
    resize = { enable = true },
    open = { enable = true },
    close = { enable = true },
  }
}
```
- **Purpose**: Smooth animations for window operations
- **Customization**: Selective animation enabling/disabling
- **Performance**: Optimized timing for responsive feel

### Visual Enhancements

**mini.indentscope** - Indent guides
```lua
{
  "echasnovski/mini.indentscope",
  event = "User BaseDefered",
  opts = {
    symbol = "│",
    options = { try_as_border = true },
    draw = {
      delay = 100,
      animation = function() return 20 end,
    }
  }
}
```
- **Purpose**: Visual indent guides for current scope
- **Features**: Animated scope highlighting, customizable symbols
- **Performance**: Delayed rendering to avoid blocking

**nvim-scrollbar** - Visual scrollbar
```lua
{
  "petertriho/nvim-scrollbar",
  event = "User BaseDefered",
  opts = {
    show = true,
    show_in_active_only = false,
    set_highlights = true,
    folds = 1000,
    max_lines = 1000,
    hide_if_all_visible = true,
    throttle_ms = 100,
    handle = {
      text = " ",
      color = nil,
      cterm = nil,
    },
    marks = {
      Search = {
        text = { "-", "=" },
        priority = 0,
        color = nil,
        cterm = nil,
      },
      Error = {
        text = { "-", "=" },
        priority = 1,
        color = nil,
        cterm = nil,
      },
    }
  }
}
```
- **Purpose**: Visual scrollbar with search and diagnostic markers
- **Features**: Error indicators, search highlights, fold indicators
- **Performance**: Throttled updates, hide when not needed

**highlight-undo** - Undo highlighting
```lua
{
  "tzachar/highlight-undo.nvim",
  event = "User BaseDefered",
  opts = {
    duration = 300,
    undo = {
      hlgroup = 'IncSearch',
      mode = 'n',
      lhs = 'u',
      map = 'undo',
      opts = {}
    },
    redo = {
      hlgroup = 'IncSearch', 
      mode = 'n',
      lhs = '<C-r>',
      map = 'redo',
      opts = {}
    },
  }
}
```
- **Purpose**: Highlight changed text after undo/redo operations
- **Features**: Customizable duration and highlight groups
- **UX**: Visual feedback for undo operations

### Search Interface

**telescope.nvim** - Fuzzy finder
```lua
{
  "nvim-telescope/telescope.nvim",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim"
  },
  cmd = "Telescope",
  opts = {
    defaults = {
      prompt_prefix = "   ",
      selection_caret = "  ",
      path_display = { "truncate" },
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
    }
  }
}
```
- **Purpose**: Universal fuzzy finder for files, buffers, grep, etc.
- **Features**: File finding, live grep, buffer switching, git integration
- **Performance**: FZF native backend for speed
- **UI**: Customizable layouts and previews

### UI Components

**heirline.nvim** - Modular status line
```lua
{
  "rebelot/heirline.nvim",
  dependencies = { "zeioth/heirline-components.nvim" },
  event = "User BaseDefered",
  opts = function()
    local lib = require("heirline-components.all")
    return {
      opts = {
        disable_winbar_cb = function(args)
          return not require("base.utils").is_available("aerial.nvim")
              or args.buf_name:match("Neogit")
        end,
      },
      statusline = lib.statusline,
      winbar = lib.winbar,
      tabline = lib.tabline,
    }
  end
}
```
- **Purpose**: Highly customizable status line, winbar, and tabline
- **Components**: Git status, LSP info, diagnostics, file info
- **Integration**: Works with all major plugins
- **Performance**: Modular loading, conditional components

**which-key.nvim** - Key binding hints
```lua
{
  "folke/which-key.nvim",
  event = "User BaseDefered",
  opts = {
    plugins = { spelling = true, presets = { operators = false } },
    window = {
      border = "none",
      position = "bottom",
      margin = { 1, 0, 1, 0 },
      padding = { 1, 2, 1, 2 },
      winblend = 0,
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
  }
}
```
- **Purpose**: On-screen keybinding help and documentation
- **Features**: Hierarchical key mapping display, descriptions, icons
- **Integration**: Automatic registration of all plugin keybindings
- **UX**: Contextual help reduces learning curve

### Icons & Symbols

**nvim-web-devicons** - File type icons
```lua
{
  "nvim-tree/nvim-web-devicons",
  opts = {
    override = {
      default_icon = {
        icon = "",
        name = "Default",
      },
    },
    override_by_filename = {
      [".gitignore"] = { icon = "", color = "#f1502f", name = "Gitignore" },
      ["README.md"] = { icon = "", color = "#519aba", name = "Readme" },
    },
  }
}
```
- **Purpose**: File type icons for various UI components
- **Features**: Extensive file type coverage, color coding
- **Integration**: Used by file browsers, completion, status line

**lspkind.nvim** - LSP completion icons
```lua
{
  "onsails/lspkind.nvim",
  opts = {
    mode = "symbol_text",
    preset = "codicons",
    symbol_map = {
      Text = "󰉿",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰜢",
      Variable = "󰀫",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "󰑭",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "󰈇",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "󰙅",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "",
    },
  }
}
```
- **Purpose**: Icons for LSP completion items and symbols
- **Features**: Comprehensive symbol mapping, customizable presets
- **Integration**: Works with nvim-cmp and other completion systems

---

## 3-dev-core.lua - Development Core

**Overview**: Essential development tools including LSP, completion, and syntax highlighting. These plugins form the foundation of the development experience.

### Syntax Highlighting

**nvim-treesitter** - Advanced syntax highlighting
```lua
{
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  event = "User BaseDefered",
  build = ":TSUpdate",
  opts = {
    auto_install = false,  -- Use :TSInstall all manually
    highlight = {
      enable = true,
      disable = function(_, bufnr) return utils.is_big_file(bufnr) end,
    },
    incremental_selection = { enable = true },
    indent = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "around function" },
          ["if"] = { query = "@function.inner", desc = "inside function" },
          ["ac"] = { query = "@class.outer", desc = "around class" },
          ["ic"] = { query = "@class.inner", desc = "inside class" },
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "Next function start" },
          ["]c"] = { query = "@class.outer", desc = "Next class start" },
        },
      },
    },
  }
}
```
- **Purpose**: Context-aware syntax highlighting and text objects
- **Features**: Smart selections, navigation, code structure understanding
- **Performance**: Big file detection automatically disables for large files
- **Text Objects**: Intelligent code selections (functions, classes, blocks)

**render-markdown.nvim** - Live markdown rendering
```lua
{
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "norg", "rmd", "org" },
  opts = {
    heading = {
      enabled = true,
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      enabled = true,
      sign = false,
      style = "full",
      position = "left",
      language_pad = 0,
      disable_background = { "diff" },
    },
    dash = {
      enabled = true,
      icon = "─",
      width = "full",
    },
  }
}
```
- **Purpose**: Live markdown preview in normal mode
- **Features**: Heading icons, code block styling, table rendering
- **Performance**: Filetype-based loading only for markdown files

### LSP Infrastructure

**mason.nvim** - LSP package manager
```lua
{
  "williamboman/mason.nvim",
  cmd = {
    "Mason", "MasonInstallAll", "MasonUninstallAll", "MasonUpdate"
  },
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  }
}
```
- **Purpose**: Install and manage LSP servers, DAP adapters, linters, formatters
- **Features**: Cross-platform package management, UI for package browsing
- **Integration**: Automatic installation of development tools

**mason-lspconfig.nvim** - LSP server auto-configuration
```lua
{
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "mason.nvim" },
  event = "User BaseFile",
  opts = {
    ensure_installed = {
      "lua_ls", "bashls", "clangd", "pyright", "tsserver", "rust_analyzer"
    },
    automatic_installation = true,
  },
  config = function(_, opts)
    require("mason-lspconfig").setup(opts)
    require("mason-lspconfig").setup_handlers({
      function(server) utils_lsp.setup(server) end
    })
  end
}
```
- **Purpose**: Automatic LSP server setup and configuration
- **Features**: Auto-installation, server handlers, configuration management
- **Integration**: Works with base/utils/lsp.lua for custom configurations

**nvim-lspconfig** - LSP client configurations
```lua
{
  "neovim/nvim-lspconfig",
  dependencies = { "mason-lspconfig.nvim" },
  event = "User BaseFile",
  config = function()
    utils_lsp.apply_default_lsp_settings()
  end
}
```
- **Purpose**: LSP client configurations for various language servers
- **Integration**: Configured through utils_lsp module
- **Features**: Diagnostic display, hover, definitions, references

**none-ls.nvim** - External tool integration
```lua
{
  "nvimtools/none-ls.nvim",
  dependencies = { "mason.nvim", "none-ls-autoload.nvim" },
  event = "User BaseFile",
  opts = function()
    return {
      debug = false,
      sources = {
        -- Auto-loaded from mason installations
      }
    }
  end
}
```
- **Purpose**: Integrate external formatters, linters as LSP sources
- **Features**: Format on save, diagnostics from external tools
- **Performance**: Auto-loading of mason-installed tools

**SchemaStore.nvim** - JSON/YAML schemas
```lua
{
  "b0o/SchemaStore.nvim",
  lazy = true,
  -- Used by jsonls and yamlls in utils_lsp.apply_user_lsp_settings
}
```
- **Purpose**: Provides schemas for JSON and YAML files
- **Integration**: Automatic schema detection for package.json, tsconfig.json, etc.
- **Features**: Auto-completion and validation for structured files

### Auto Completion

**nvim-cmp** - Completion engine
```lua
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",     -- LSP completions
    "hrsh7th/cmp-buffer",       -- Buffer completions
    "hrsh7th/cmp-path",         -- Path completions
    "hrsh7th/cmp-cmdline",      -- Command line completions
    "L3MON4D3/LuaSnip",        -- Snippet engine
    "saadparwaiz1/cmp_luasnip", -- Snippet completions
  },
  event = "InsertEnter",
  opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    
    return {
      enabled = function()
        return vim.g.cmp_enabled and vim.bo.buftype ~= "prompt"
      end,
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
      }),
      formatting = {
        format = require("lspkind").cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },
    }
  end
}
```
- **Purpose**: Intelligent auto-completion with multiple sources
- **Sources**: LSP, snippets, buffer text, file paths, command line
- **Features**: Ghost text, fuzzy matching, priority-based sorting
- **Integration**: Icons from lspkind, snippets from LuaSnip
- **Performance**: Insert mode loading, conditional enabling

**LuaSnip** - Snippet engine
```lua
{
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    history = true,
    delete_check_events = "TextChanged",
    region_check_events = "CursorMoved",
  }
}
```
- **Purpose**: Powerful snippet expansion and management
- **Features**: Programmable snippets, history, jump navigation
- **Integration**: Works with nvim-cmp for completion
- **Snippets**: Includes friendly-snippets collection

**Java Support** - nvim-java
```lua
{
  "nvim-java/nvim-java",
  ft = { "java" },
  dependencies = {
    "nvim-java/lua-async-await",
    "nvim-java/nvim-java-core",
    "nvim-java/nvim-java-test",
    "nvim-java/nvim-java-dap",
    "MunifTanjim/nui.nvim",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
}
```
- **Purpose**: Comprehensive Java development support
- **Features**: Project management, testing, debugging
- **Integration**: LSP, DAP, and test runner integration
- **Performance**: Filetype-based loading for Java files only

---

## 4-dev.lua - Development Tools

**Overview**: Advanced development tools for testing, debugging, documentation, and language-specific features. These plugins enhance the development workflow with specialized functionality.

### Testing Framework

**neotest** - Test runner framework
```lua
{
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    "rouge8/neotest-rust",
  },
  event = "User BaseFile",
  opts = function()
    return {
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          args = { "--log-level", "DEBUG", "--quiet" },
          runner = "pytest",
        }),
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function() return vim.fn.getcwd() end,
        }),
        require("neotest-vitest"),
        require("neotest-rust")({
          args = { "--no-capture" },
          dap_adapter = "lldb",
        }),
      },
      discovery = { enabled = false },
      diagnostic = { enabled = true },
      floating = {
        border = "rounded",
        max_height = 0.6,
        max_width = 0.6,
      },
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        passed = "",
        running = "",
        skipped = "",
        unknown = "",
      },
      output = { enabled = true, open_on_run = "short" },
      quickfix = {
        enabled = false,
        open = false,
      },
      status = { enabled = true, signs = true, virtual_text = false },
      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },
    }
  end
}
```
- **Purpose**: Universal test runner with language-specific adapters
- **Languages**: Python (pytest), JavaScript/TypeScript (Jest, Vitest), Rust (cargo test)
- **Features**: Test discovery, running, debugging, output display
- **UI**: Tree view of tests, status indicators, floating results
- **Integration**: DAP integration for test debugging

### Debugging (DAP)

**nvim-dap** - Debug Adapter Protocol client
```lua
{
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
  },
  event = "User BaseFile",
  config = function()
    local dap = require("dap")
    
    -- Python debugging
    dap.adapters.python = {
      type = "executable",
      command = vim.fn.stdpath("data") .. "/mason/bin/debugpy-adapter",
    }
    
    -- Node.js debugging
    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
    }
    
    -- C# debugging
    dap.adapters.coreclr = {
      type = "executable",
      command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
      args = { "--interpreter=vscode" },
    }
  end
}
```
- **Purpose**: Debugging support for multiple languages
- **Features**: Breakpoints, variable inspection, call stack, stepping
- **Languages**: Python, Node.js, C#, Rust, Go, and more
- **UI**: Integrated with dap-ui for comprehensive debugging interface

**nvim-dap-ui** - Debug UI
```lua
{
  "rcarriga/nvim-dap-ui",
  opts = {
    icons = { expanded = "", collapsed = "", current_frame = "" },
    mappings = {
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    expand_lines = vim.fn.has("nvim-0.7") == 1,
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.25 },
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 0.25,
        position = "bottom",
      },
    },
    controls = {
      enabled = true,
      element = "repl",
      icons = {
        pause = "",
        play = "",
        step_into = "",
        step_over = "",
        step_out = "",
        step_back = "",
        run_last = "",
        terminate = "",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      border = "single",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
  }
}
```
- **Purpose**: Rich debugging interface with panels and controls
- **Layout**: Scopes, breakpoints, call stack, REPL, console
- **Features**: Variable inspection, watch expressions, debug controls
- **Integration**: Seamless integration with nvim-dap

### Documentation

**dooku.nvim** - Documentation generator
```lua
{
  "Zeioth/dooku.nvim",
  cmd = { "DookuGenerate", "DookuOpen", "DookuAutoSetup" },
  opts = {
    project_root = { ".git", ".hg", ".svn", ".bzr", "_darcs", "_FOSSIL_", ".fslckout" },
    browser_cmd = "xdg-open",
    on_generate_success = function(cmd)
      vim.notify("Documentation generated successfully", vim.log.levels.INFO)
    end,
    on_generate_error = function(cmd, error_code)
      vim.notify("Documentation generation failed", vim.log.levels.ERROR)
    end,
  }
}
```
- **Purpose**: Generate and view project documentation
- **Languages**: Support for multiple documentation generators (doxygen, rustdoc, godoc)
- **Features**: Auto-detection of project type, browser integration
- **Integration**: Project-aware documentation generation

**markmap.nvim** - Mind map from markdown
```lua
{
  "Zeioth/markmap.nvim",
  cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
  opts = {
    html_output = "/tmp/markmap.html",
    hide_toolbar = false,
    grace_period = 3600000,
  }
}
```
- **Purpose**: Create interactive mind maps from markdown files
- **Features**: Live preview, export options, interactive navigation
- **Dependencies**: markmap CLI tool required

### Language-Specific Tools

**markdown-preview.nvim** - Markdown preview
```lua
{
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install"]() end,
  cmd = {
    "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle"
  },
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_refresh_slow = 0
    vim.g.mkdp_command_for_global = 0
    vim.g.mkdp_open_to_the_world = 0
    vim.g.mkdp_open_ip = ""
    vim.g.mkdp_browser = ""
    vim.g.mkdp_echo_preview_url = 0
    vim.g.mkdp_browserfunc = ""
    vim.g.mkdp_preview_options = {
      mkit = {},
      katex = {},
      uml = {},
      maid = {},
      disable_sync_scroll = 0,
      sync_scroll_type = "middle",
      hide_yaml_meta = 1,
      sequence_diagrams = {},
      flowchart_diagrams = {},
      content_editable = false,
      disable_filename = 0,
    }
    vim.g.mkdp_markdown_css = ""
    vim.g.mkdp_highlight_css = ""
    vim.g.mkdp_port = ""
    vim.g.mkdp_page_title = "「${name}」"
  end
}
```
- **Purpose**: Live markdown preview in browser
- **Features**: Math support (KaTeX), diagrams (mermaid), custom CSS
- **Performance**: Filetype-based loading, auto-close on buffer leave

### Code Intelligence

**compiler.nvim** - Universal compiler
```lua
{
  "Zeioth/compiler.nvim",
  cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
  dependencies = { "stevearc/overseer.nvim" },
  opts = {},
}
```
- **Purpose**: Universal compilation and build system
- **Languages**: Support for 20+ programming languages
- **Features**: Auto-detection of build systems, error parsing
- **Integration**: Works with overseer.nvim for task management

**overseer.nvim** - Task runner
```lua
{
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerOpen", "OverseerClose", "OverseerToggle", "OverseerSaveBundle",
    "OverseerLoadBundle", "OverseerDeleteBundle", "OverseerRunCmd",
    "OverseerRun", "OverseerInfo", "OverseerBuild", "OverseerQuickAction",
    "OverseerTaskAction", "OverseerClearCache"
  },
  opts = {
    strategy = {
      "toggleterm",
      direction = "horizontal",
      autos_croll = true,
      quit_on_exit = "success"
    },
    templates = { "builtin", "user.cpp_build" },
    auto_scroll = true,
    auto_detect_success_color = true,
  }
}
```
- **Purpose**: Advanced task runner and build system manager
- **Features**: Task templates, progress monitoring, integration with terminal
- **Integration**: Works with compiler.nvim and other build tools

**nvim-coverage** - Code coverage display
```lua
{
  "andythigpen/nvim-coverage",
  cmd = {
    "Coverage", "CoverageLoad", "CoverageShow", "CoverageHide",
    "CoverageToggle", "CoverageClear", "CoverageSummary"
  },
  opts = {
    commands = true,
    highlights = {
      covered = { fg = "#C3E88D" },
      uncovered = { fg = "#F07178" },
    },
    signs = {
      covered = { hl = "CoverageCovered", text = "▎" },
      uncovered = { hl = "CoverageUncovered", text = "▎" },
    },
    summary = {
      min_coverage = 80.0,
    },
    lang = {
      python = {
        coverage_command = "coverage json --fail-under=0 -q -o -",
      },
      javascript = {
        coverage_command = "npx nyc report --reporter=json-summary",
      },
    },
  }
}
```
- **Purpose**: Display code coverage information in sign column
- **Languages**: Python, JavaScript, Go, and more
- **Features**: Coverage highlighting, summary reports, configurable thresholds
- **Integration**: Reads coverage files from various testing tools

This comprehensive plugin system provides a complete development environment with modern tooling, intelligent assistance, and professional-grade features while maintaining performance through lazy loading and conditional activation.