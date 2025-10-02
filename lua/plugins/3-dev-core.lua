-- Dev core
-- Plugins that are just there.

--    Sections:
--       ## TREE SITTER
--       -> nvim-treesitter                [syntax highlight]
--       -> render-markdown.nvim           [normal mode markdown]
--       -> nvim-highlight-colors          [hex colors]

--       ## LSP
--       -> nvim-java                      [java support]
--       -> mason-lspconfig                [auto start lsp]
--       -> nvim-lspconfig                 [lsp configs]
--       -> mason.nvim                     [lsp package manager]
--       -> SchemaStore.nvim               [mason extra schemas]
--       -> none-ls-autoload.nvim          [mason package loader]
--       -> none-ls                        [lsp code formatting]
--       -> garbage-day                    [lsp garbage collector]
--       -> lazydev                        [lua lsp for nvim plugins]

--       ## AUTO COMPLETION
--       -> blink.cmp                      [auto completion engine]
--       -> blink-cmp-copilot              [copilot support for blink]

local utils = require("base.utils")
local utils_lsp = require("base.utils.lsp")

return {
  --  TREE SITTER ---------------------------------------------------------
  --  [syntax highlight]
  --  https://github.com/nvim-treesitter/nvim-treesitter
  --  https://github.com/windwp/nvim-treesitter-textobjects
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    event = "User BaseDefered",
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    build = ":TSUpdate",
    opts = {
      auto_install = false, -- Currently bugged. Use [:TSInstall all] and [:TSUpdate all]

      highlight = {
        enable = true,
        disable = function(_, bufnr) return utils.is_big_file(bufnr) end,
      },
      matchup = {
        enable = true,
        enable_quotes = true,
        disable = function(_, bufnr) return utils.is_big_file(bufnr) end,
      },
      incremental_selection = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ak"] = { query = "@block.outer", desc = "around block" },
            ["ik"] = { query = "@block.inner", desc = "inside block" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inside class" },
            ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
            ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
            ["af"] = { query = "@function.outer", desc = "around function " },
            ["if"] = { query = "@function.inner", desc = "inside function " },
            ["al"] = { query = "@loop.outer", desc = "around loop" },
            ["il"] = { query = "@loop.inner", desc = "inside loop" },
            ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]k"] = { query = "@block.outer", desc = "Next block start" },
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next parameter start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", desc = "Next block end" },
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next parameter end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", desc = "Previous block start" },
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous parameter start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", desc = "Previous block end" },
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[A"] = { query = "@parameter.inner", desc = "Previous parameter end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            [">K"] = { query = "@block.outer", desc = "Swap next block" },
            [">F"] = { query = "@function.outer", desc = "Swap next function" },
            [">A"] = { query = "@parameter.inner", desc = "Swap next parameter" },
          },
          swap_previous = {
            ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
            ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
            ["<A"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
          },
        },
      },
    },
    config = function(_, opts)
      -- calling setup() here is necessary to enable conceal and some features.
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  --  render-markdown.nvim [normal mode markdown]
  --  https://github.com/MeanderingProgrammer/render-markdown.nvim
  --  While on normal mode, markdown files will display highlights.
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "markdown" },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      heading = {
        sign = false,
        icons = require("base.utils").get_icon("RenderMarkdown"),
        width = "block",
      },
      code = {
        sign = false,
        width = 'language', -- use 'language' if colorcolumn is important for you.
        right_pad = 1,
      },
      dash = {
        width = 79
      },
      pipe_table = {
        style = 'full', -- use 'normal' if colorcolumn is important for you.
      },
    },
  },

  --  [hex colors]
  --  https://github.com/brenoprata10/nvim-highlight-colors
  {
    "brenoprata10/nvim-highlight-colors",
    event = "User BaseFile",
    cmd = { "HighlightColors" }, -- followed by 'On' / 'Off' / 'Toggle'
    opts = { enabled_named_colors = true },
  },

  --  LSP -------------------------------------------------------------------

  -- nvim-java [java support]
  -- https://github.com/nvim-java/nvim-java
  -- Reliable jdtls support. Must go before mason-lspconfig and lsp-config.
  -- NOTE: Let's use our fork until they merge pull request
  --       https://github.com/nvim-java/nvim-java/pull/376
  {
    "zeioth/nvim-java",
    enabled = false,
    ft = { "java" },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
    },
    opts = {
      -- NOTE: One of these files must be in your project root directory.
      root_markers = {
        'settings.gradle',
        'settings.gradle.kts',
        'pom.xml',
        'build.gradle',
        'mvnw',
        'gradlew',
        'build.gradle',
        'build.gradle.kts',
        '.git',
      },
    },
  },

  --  nvim-lspconfig [lsp configs]
  --  https://github.com/neovim/nvim-lspconfig
  --  This plugin provide default configs for the lsp servers available on mason.
  {
    "neovim/nvim-lspconfig",
    event = "User BaseFile",
    dependencies = "zeioth/nvim-java",
  },

  -- mason-lspconfig [auto start lsp]
  -- https://github.com/mason-org/mason-lspconfig.nvim
  -- This plugin auto starts the lsp servers installed by Mason
  -- every time Neovim trigger the event FileType.
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "User BaseFile",
    opts = function(_, opts)
      if not opts.handlers then opts.handlers = {} end
      opts.handlers[1] = function(server) utils_lsp.setup(server) end
    end,
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      utils_lsp.apply_default_lsp_settings() -- Apply our default lsp settings.
      utils.trigger_event("FileType")        -- This line starts this plugin.
    end,
  },

  --  mason [lsp package manager]
  --  https://github.com/mason-org/mason.nvim
  --  https://github.com/zeioth/mason-extra-cmds
  {
    "mason-org/mason.nvim",
    dependencies = { "zeioth/mason-extra-cmds", opts = {} },
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
      "MasonUpdateAll", -- this cmd is provided by mason-extra-cmds
    },
    opts = {
      registries = {
        "github:mason-org/mason-registry",
      },
      ui = {
        icons = {
          package_installed = require("base.utils").get_icon("MasonInstalled"),
          package_uninstalled = require("base.utils").get_icon("MasonUninstalled"),
          package_pending = require("base.utils").get_icon("MasonPending"),
        },
      },
    }
  },

  --  Schema Store [mason extra schemas]
  --  https://github.com/b0o/SchemaStore.nvim
  --  We use this plugin in ../base/utils/lsp.lua
  "b0o/SchemaStore.nvim",

  -- none-ls-autoload.nvim [mason package loader]
  -- https://github.com/zeioth/mason-none-ls.nvim
  -- This plugin auto starts the packages installed by Mason
  -- every time Neovim trigger the event FileType ().
  -- By default it will use none-ls builtin sources.
  -- But you can add external sources if a mason package has no builtin support.
  {
    "zeioth/none-ls-autoload.nvim",
    event = "User BaseFile",
    dependencies = {
      "mason-org/mason.nvim",
      "zeioth/none-ls-external-sources.nvim"
    },
    opts = {
      -- Here you can add support for sources not oficially suppored by none-ls.
      external_sources = {
        -- diagnostics
        'none-ls-external-sources.diagnostics.cpplint',
        'none-ls-external-sources.diagnostics.eslint',
        'none-ls-external-sources.diagnostics.eslint_d',
        'none-ls-external-sources.diagnostics.flake8',
        'none-ls-external-sources.diagnostics.luacheck',
        'none-ls-external-sources.diagnostics.psalm',
        'none-ls-external-sources.diagnostics.yamllint',

        -- formatting
        'none-ls-external-sources.formatting.autopep8',
        'none-ls-external-sources.formatting.beautysh',
        'none-ls-external-sources.formatting.easy-coding-standard',
        'none-ls-external-sources.formatting.eslint',
        'none-ls-external-sources.formatting.eslint_d',
        'none-ls-external-sources.formatting.jq',
        'none-ls-external-sources.formatting.latexindent',
        'none-ls-external-sources.formatting.reformat_gherkin',
        'none-ls-external-sources.formatting.rustfmt',
        'none-ls-external-sources.formatting.standardrb',
        'none-ls-external-sources.formatting.yq',
      },
    },
  },

  -- none-ls [lsp code formatting]
  -- https://github.com/nvimtools/none-ls.nvim
  {
    "nvimtools/none-ls.nvim",
    event = "User BaseFile",
    opts = function()
      local builtin_sources = require("null-ls").builtins

      -- You can customize your 'builtin sources' and 'external sources' here.
      builtin_sources.formatting.shfmt.with({
        command = "shfmt",
        args = { "-i", "2", "-filename", "$FILENAME" },
      })

      -- Attach the user lsp mappings to every none-ls client.
      return { on_attach = utils_lsp.apply_user_lsp_mappings }
    end
  },

  --  garbage-day.nvim [lsp garbage collector]
  --  https://github.com/zeioth/garbage-day.nvim
  {
    "zeioth/garbage-day.nvim",
    event = "User BaseFile",
    opts = {
      aggressive_mode = false,
      excluded_lsp_clients = {
        "null-ls", "jdtls", "marksman", "lua_ls"
      },
      grace_period = (60 * 15),
      wakeup_delay = 3000,
      notifications = false,
      retries = 3,
      timeout = 1000,
    }
  },

  --  lazy.nvim [lua lsp for nvim plugins]
  --  https://github.com/folke/lazydev.nvim
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = function(_, opts)
      opts.library = {
        -- Any plugin you wanna have LSP autocompletion for, add it here.
        -- in 'path', write the name of the plugin directory.
        -- in 'mods', write the word you use to require the module.
        -- in 'words' write words that trigger loading a lazydev path (optionally).

        -- Core & Infrastructure
        { path = "lazy.nvim", mods = { "lazy" } },
        { path = "plenary.nvim", mods = { "plenary" } },
        { path = "nui.nvim", mods = { "nui" } },
        { path = "promise-async", mods = { "promise-async" } },
        { path = "yazi.nvim", mods = { "yazi" } },
        { path = "project.nvim", mods = { "project_nvim", "telescope" } },
        { path = "trim.nvim", mods = { "trim" } },
        { path = "stickybuf.nvim", mods = { "stickybuf" } },
        { path = "smart-splits.nvim", mods = { "smart-splits" } },
        { path = "toggleterm.nvim", mods = { "toggleterm" } },
        { path = "neovim-session-manager.nvim", mods = { "session_manager" } },
        { path = "nvim-spectre", mods = { "spectre" } },
        { path = "neo-tree.nvim", mods = { "neo-tree" } },
        { path = "nvim-ufo", mods = { "ufo" } },
        { path = "nvim-neoclip.lua", mods = { "neoclip", "telescope" } },
        { path = "zen-mode.nvim", mods = { "zen-mode" } },
        { path = "vim-suda", mods = { "suda" } }, -- has vimscript
        { path = "vim-matchup", mods = { "matchup", "match-up", "treesitter-matchup" } }, -- has vimscript
        { path = "hop.nvim", mods = { "hop", "hop-treesitter", "hop-yank" } },
        { path = "nvim-autopairs", mods = { "nvim-autopairs" } },
        { path = "hot-reload.nvim", mods = { "hot-reload" } },
        { path = "distroupdate.nvim", mods = { "distroupdate" } },

        -- UI & Theming
        { path = "tokyonight.nvim", mods = { "tokyonight" } },
        { path = "astrotheme", mods = { "astrotheme" } },
        { path = "alpha-nvim", mods = { "alpha" } },
        { path = "nvim-notify", mods = { "notify" } },
        { path = "mini.animate", mods = { "mini.animate" } },
        { path = "mini.indentscope", mods = { "mini.indentscope" } },
        { path = "mini.bufremove", mods = { "mini.bufremove" } },
        { path = "heirline.nvim", mods = { "heirline" } },
        { path = "heirline-components.nvim", mods = { "heirline-components" } },
        { path = "dressing.nvim", mods = { "dressing" } },
        { path = "noice.nvim", mods = { "noice", "telescope" } },
        { path = "nvim-web-devicons", mods = { "nvim-web-devicons" } },
        { path = "nvim-scrollbar", mods = { "scrollbar" } },
        { path = "highlight-undo.nvim", mods = { "highlight-undo" } },
        { path = "which-key.nvim", mods = { "which-key" } },

        -- Telescope & Extensions
        { path = "telescope.nvim", mods = { "telescope" } },
        { path = "telescope-undo.nvim", mods = { "telescope", "telescope-undo" } },
        { path = "telescope-fzf-native.nvim", mods = { "telescope", "fzf_lib"  } },
        { path = "telescope-luasnip.nvim", mods = { "telescope", "luasnip" } },

        -- Treesitter & Syntax
        { path = "nvim-treesitter", mods = { "nvim-treesitter" } },
        { path = "nvim-ts-autotag", mods = { "nvim-ts-autotag" } },
        { path = "nvim-treesitter-textobjects", mods = { "nvim-treesitter", "nvim-treesitter-textobjects" } },
        { path = "render-markdown.nvim", mods = { "render-markdown" } },
        { path = "nvim-highlight-colors", mods = { "nvim-highlight-colors" } },

        -- LSP & Language Support
        { path = "nvim-lspconfig", mods = { "lspconfig" } },
        { path = "mason-lspconfig.nvim", mods = { "mason-lspconfig" } },
        { path = "mason.nvim", mods = { "mason", "mason-core", "mason-registry", "mason-vendor" } },
        { path = "mason-extra-cmds", mods = { "masonextracmds" } },
        { path = "SchemaStore.nvim", mods = { "schemastore" } },
        { path = "none-ls-autoload.nvim", mods = { "none-ls-autoload" } },
        { path = "none-ls.nvim", mods = { "null-ls" } },
        { path = "none-ls-external-sources.nvim", mods = { "none-ls-external-sources" } },
        { path = "lazydev.nvim", mods = { "" } },
        { path = "garbage-day.nvim", mods = { "garbage-day" } },
        { path = "lsp_signature", mods = { "lsp_signature" } },
        { path = "nvim-lightbulb", mods = { "nvim-lightbulb" } },
        { path = "lspkind.nvim", mods = { "lspkind" } },

        -- Java Support
        { path = "nvim-java", mods = { "java" } },
        { path = "nvim-java-core", mods = { "java-core" } },
        { path = "nvim-java-refactor", mods = { "java-refactor" } },
        { path = "nvim-java-test", mods = { "java-test" } },
        { path = "lua-async-await", mods = { "async-await" } },
        { path = "spring-boot.nvim", mods = { "spring-boot" } },

        -- Completion & Snippets
        { path = "blink.cmp", mods = { "blink", "blink.cmp" } },
        { path = "blink-cmp-copilot", mods = { "blink-cmp-copilot" } },
        { path = "LuaSnip", mods = { "luasnip" } },
        { path = "friendly-snippets", mods = { "snippets" } }, -- has vimscript
        { path = "NormalSnippets", mods = { "snippets" } }, -- has vimscript

        -- Git Integration
        { path = "gitsigns.nvim", mods = { "gitsigns" } },
        { path = "vim-fugitive", mods = { "fugitive" } }, -- has vimscript
        { path = "vim-rhubarb", mods = { "rhubarb" } }, -- has vimscript

        -- Code Navigation & Analysis
        { path = "aerial.nvim", mods = { "aerial", "telescope", "lualine", "resession" } },
        { path = "litee.nvim", mods = { "litee" } },
        { path = "litee-calltree.nvim", mods = { "litee" } },
        { path = "gutentags_plus", mods = { "gutentags_plus" } }, -- has vimscript
        { path = "vim-gutentags", mods = { "vim-gutentags" } }, -- has vimscript

        -- Documentation & Publishing
        { path = "dooku.nvim", mods = { "dooku" } },
        { path = "markdown-preview.nvim", mods = { "mkdp" } }, -- has vimscript
        { path = "markmap.nvim", mods = { "markmap" } },
        { path = "peek.nvim", mods = { "peek" } },
        { path = "github-preview.nvim", mods = { "github-preview" } },
        { path = "live-server.nvim", mods = { "live-server" } },
        { path = "omni-preview.nvim", mods = { "omni-preview" } },

        -- AI & Assistance
        { path = "neural", mods = { "neural" } },
        { path = "copilot.lua", mods = { "copilot" } },
        { path = "claude-code.nvim", mods = { "claude-code" } },

        -- Development Tools
        { path = "guess-indent.nvim", mods = { "guess-indent" } },
        { path = "compiler.nvim", mods = { "compiler" } },
        { path = "overseer.nvim", mods = { "overseer", "lualine", "neotest", "resession" } },


        -- Testing (Neotest)
        { path = "neotest", mods = { "neotest" } },
        { path = "neotest-dart", mods = { "neotest-dart" } },
        { path = "neotest-dotnet", mods = { "neotest-dotnet" } },
        { path = "neotest-elixir", mods = { "neotest-elixir" } },
        { path = "neotest-golang", mods = { "neotest-golang" } },
        { path = "neotest-java", mods = { "neotest-java" } },
        { path = "neotest-jest", mods = { "neotest-jest" } },
        { path = "neotest-phpunit", mods = { "neotest-phpunit" } },
        { path = "neotest-python", mods = { "neotest-python" } },
        { path = "neotest-rust", mods = { "neotest-rust" } },
        { path = "neotest-zig", mods = { "neotest-zig" } },
        { path = "nvim-coverage", mods = { "coverage" } },

        -- To make it work exactly like neodev, you can add all plugins
        -- without conditions instead like this but it will load slower
        -- on startup and consume ~1 Gb RAM:
        -- vim.fn.stdpath "data" .. "/lazy",

        -- You can also add libs.
        { path = "luvit-meta/library", mods = { "vim%.uv" } },
      }
    end,
    specs = { { "Bilal2453/luvit-meta", lazy = true } },
  },

  --  AUTO COMPLETION --------------------------------------------------------
  --  Blink completion engine [autocompletion engine]
  --  https://github.com/Saghen/blink.cmp
  {
    "Saghen/blink.cmp",
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      { "giuxtaposition/blink-cmp-copilot" }, -- Copilot support for blink
    },
    version = "0.*", -- Use a release tag for stable version
    event = "InsertEnter",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      enabled = function()
        -- Disable in prompt buffers
        if vim.bo.buftype == "prompt" then
          return false
        else
          return vim.g.cmp_enabled
        end
      end,
      
      -- Use 'default' keymap preset with some customizations
      keymap = {
        preset = "default",
        ["<C-y>"] = {}, -- Disable C-y
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_forward()
            else
              return cmp.select_next()
            end
          end,
          "fallback"
        },
        ["<S-Tab>"] = { 
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_backward()
            else
              return cmp.select_prev()
            end
          end,
          "fallback"
        },
        ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
        ["<PageDown>"] = { "scroll_documentation_down", "fallback" },
      },

      appearance = {
        -- Use Nerd Font Mono variant
        nerd_font_variant = "mono",
        
        -- Kind icons from lspkind
        kind_icons = utils.get_icon("kinds"),
      },

      completion = {
        accept = {
          -- Don't auto insert on selection
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            -- Show completion menu with kind icons
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
          },
          -- Use rounded borders if enabled
          border = vim.g.lsp_round_borders_enabled and "rounded" or "none",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          auto_show = false, -- Don't auto show docs
          window = {
            border = vim.g.lsp_round_borders_enabled and "rounded" or "none",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
          },
        },
      },

      -- Configure sources with priorities similar to nvim-cmp setup
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            score_offset = 100, -- Highest priority
          },
          copilot = {
            name = "Copilot",
            module = "blink-cmp-copilot",
            score_offset = 60,
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path", 
            score_offset = 40,
          },
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            score_offset = 20,
          },
        },
      },

      snippets = {
        preset = "luasnip",
      },

      -- Use Rust fuzzy matcher for better performance
      fuzzy = {
        use_frecency = true,
        use_proximity = true,
      },
    },
  },

}

