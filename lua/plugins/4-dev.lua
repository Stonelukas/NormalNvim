-- Dev
-- Plugins you actively use for coding.

--    Sections:
--       ## SNIPPETS
--       -> luasnip                        [snippet engine]
--       -> friendly-snippets              [snippet templates]

--       ## GIT
--       -> gitsigns.nvim                  [git hunks]
--       -> fugitive.vim                   [git commands]

--       ## ANALYZER
--       -> aerial.nvim                    [symbols tree]
--       -> litee-calltree.nvim            [calltree]

--       ## CODE DOCUMENTATION
--       -> dooku.nvim                     [html doc generator]
--       -> markdown-preview.nvim          [markdown previewer]
--       -> markmap.nvim                   [markdown mindmap]

--       ## ARTIFICIAL INTELLIGENCE
--       -> neural                         [chatgpt code generator]
--       -> copilot                        [github code suggestions]
--       -> guess-indent                   [guess-indent]

--       ## COMPILER
--       -> compiler.nvim                  [compiler]
--       -> overseer.nvim                  [task runner]


--       ## TESTING
--       -> neotest.nvim                   [unit testing]
--       -> nvim-coverage                  [code coverage]

--       ## LANGUAGE IMPROVEMENTS
--       -> guttentags_plus                [auto generate C/C++ tags]

local is_windows = vim.fn.has("win32") == 1 -- true if on windows

return {
  --  SNIPPETS ----------------------------------------------------------------
  --  Vim Snippets engine  [snippet engine] + [snippet templates]
  --  https://github.com/L3MON4D3/LuaSnip
  --  https://github.com/rafamadriz/friendly-snippets
  {
    "L3MON4D3/LuaSnip",
    build = not is_windows and "make install_jsregexp" or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      "zeioth/NormalSnippets",
      "benfowler/telescope-luasnip.nvim",
    },
    event = "User BaseFile",
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
    },
    config = function(_, opts)
      if opts then require("luasnip").config.setup(opts) end
      vim.tbl_map(
        function(type) require("luasnip.loaders.from_" .. type).lazy_load() end,
        { "vscode", "snipmate", "lua" }
      )
      -- friendly-snippets - enable standardized comments snippets
      require("luasnip").filetype_extend("typescript", { "tsdoc" })
      require("luasnip").filetype_extend("javascript", { "jsdoc" })
      require("luasnip").filetype_extend("lua", { "luadoc" })
      require("luasnip").filetype_extend("python", { "pydoc" })
      require("luasnip").filetype_extend("rust", { "rustdoc" })
      require("luasnip").filetype_extend("cs", { "csharpdoc" })
      require("luasnip").filetype_extend("java", { "javadoc" })
      require("luasnip").filetype_extend("c", { "cdoc" })
      require("luasnip").filetype_extend("cpp", { "cppdoc" })
      require("luasnip").filetype_extend("php", { "phpdoc" })
      require("luasnip").filetype_extend("kotlin", { "kdoc" })
      require("luasnip").filetype_extend("ruby", { "rdoc" })
      require("luasnip").filetype_extend("sh", { "shelldoc" })
    end,
  },

  --  GIT ---------------------------------------------------------------------
  --  Git signs [git hunks]
  --  https://github.com/lewis6991/gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    enabled = vim.fn.executable("git") == 1,
    event = "User BaseGitFile",
    opts = function()
      local get_icon = require("base.utils").get_icon
      return {
        max_file_length = vim.g.big_file.lines,
        signs = {
          add = { text = get_icon("GitSign") },
          change = { text = get_icon("GitSign") },
          delete = { text = get_icon("GitSign") },
          topdelete = { text = get_icon("GitSign") },
          changedelete = { text = get_icon("GitSign") },
          untracked = { text = get_icon("GitSign") },
        },
      }
    end,
  },

  --  Git fugitive mergetool + [git commands]
  --  https://github.com/lewis6991/gitsigns.nvim
  --  PR needed: Setup keymappings to move quickly when using this feature.
  --
  --  We only want this plugin to use it as mergetool like "git mergetool".
  --  To enable this feature, add this  to your global .gitconfig:
  --
  --  [mergetool "fugitive"]
  --  	cmd = nvim -c \"Gvdiffsplit!\" \"$MERGED\"
  --  [merge]
  --  	tool = fugitive
  --  [mergetool]
  --  	keepBackup = false
  {
    "tpope/vim-fugitive",
    enabled = vim.fn.executable("git") == 1,
    dependencies = { "tpope/vim-rhubarb" },
    cmd = {
      "Gvdiffsplit",
      "Gdiffsplit",
      "Gedit",
      "Gsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GRename",
      "GDelete",
      "GRemove",
      "GBrowse",
      "Git",
      "Gstatus",
    },
    config = function()
      -- NOTE: On vim plugins we use config instead of opts.
      vim.g.fugitive_no_maps = 1
    end,
  },

  --  ANALYZER ----------------------------------------------------------------
  --  [symbols tree]
  --  https://github.com/stevearc/aerial.nvim
  {
    "stevearc/aerial.nvim",
    event = "User BaseFile",
    opts = {
      filter_kind = { -- Symbols that will appear on the tree
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
      },
      open_automatic = false, -- Open if the buffer is compatible
      nerd_font = (vim.g.fallback_icons_enabled and false) or true,
      autojump = true,
      link_folds_to_tree = false,
      link_tree_to_folds = false,
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      disable_max_lines = vim.g.big_file.lines,
      disable_max_size = vim.g.big_file.size,
      layout = {
        min_width = 28,
        default_direction = "right",
        placement = "edge",
      },
      show_guides = true,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ["[y"] = "actions.prev",
        ["]y"] = "actions.next",
        ["[Y"] = "actions.prev_up",
        ["]Y"] = "actions.next_up",
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
      },
    },
    config = function(_, opts)
      require("aerial").setup(opts)
      -- HACK: The first time you open aerial on a session, close all folds.
      vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
        desc = "Aerial: When aerial is opened, close all its folds.",
        callback = function()
          local is_aerial = vim.bo.filetype == "aerial"
          local is_ufo_available =
            require("base.utils").is_available("nvim-ufo")
          if
            is_ufo_available
            and is_aerial
            and vim.b.new_aerial_session == nil
          then
            vim.b.new_aerial_session = false
            require("aerial").tree_set_collapse_level(0, 0)
          end
        end,
      })
    end,
  },

  -- Litee calltree [calltree]
  -- https://github.com/ldelossa/litee.nvim
  -- https://github.com/ldelossa/litee-calltree.nvim
  -- press ? inside the panel to show help.
  {
    "ldelossa/litee.nvim",
    event = "User BaseFile",
    opts = {
      notify = { enabled = false },
      tree = {
        icon_set = "default", -- "nerd", "codicons", "default", "simple"
      },
      panel = {
        orientation = "bottom",
        panel_size = 10,
      },
    },
    config = function(_, opts) require("litee.lib").setup(opts) end,
  },
  {
    "ldelossa/litee-calltree.nvim",
    dependencies = "ldelossa/litee.nvim",
    event = "User BaseFile",
    opts = {
      on_open = "panel", -- or popout
      map_resize_keys = false,
      keymaps = {
        expand = "<CR>",
        collapse = "c",
        collapse_all = "C",
        jump = "<C-CR>",
      },
    },
    config = function(_, opts)
      require("litee.calltree").setup(opts)

      -- Highlight only while on calltree
      vim.api.nvim_create_autocmd({ "WinEnter" }, {
        desc = "Clear highlights when leaving calltree + UX improvements.",
        callback = function()
          vim.defer_fn(function()
            if vim.bo.filetype == "calltree" then
              vim.wo.colorcolumn = "0"
              vim.wo.foldcolumn = "0"
              vim.cmd("silent! PinBuffer") -- stickybuf.nvim
              vim.cmd(
                "silent! hi LTSymbolJump ctermfg=015 ctermbg=110 cterm=italic,bold,underline guifg=#464646 guibg=#87afd7 gui=italic,bold"
              )
              vim.cmd(
                "silent! hi LTSymbolJumpRefs ctermfg=015 ctermbg=110 cterm=italic,bold,underline guifg=#464646 guibg=#87afd7 gui=italic,bold"
              )
            else
              vim.cmd("silent! highlight clear LTSymbolJump")
              vim.cmd("silent! highlight clear LTSymbolJumpRefs")
            end
          end, 100)
        end,
      })
    end,
  },

  --  CODE DOCUMENTATION ------------------------------------------------------
  --  dooku.nvim [html doc generator]
  --  https://github.com/zeioth/dooku.nvim
  {
    "zeioth/dooku.nvim",
    cmd = {
      "DookuGenerate",
      "DookuOpen",
      "DookuAutoSetup",
    },
    opts = {},
  },

  --  [markdown previewer]
  --  https://github.com/iamcco/markdown-preview.nvim
  --  Note: If you change the build command, wipe ~/.local/data/nvim/lazy
  {
    "iamcco/markdown-preview.nvim",
    build = function(plugin)
      -- guard clauses
      local yarn = (vim.fn.executable("yarn") and "yarn")
        or (vim.fn.executable("npx") and "npx -y yarn")
        or nil
      if not yarn then error("Missing `yarn` or `npx` in the PATH") end

      -- run cmd
      local cd_cmd = "!cd " .. plugin.dir .. " && cd app"
      local yarn_install_cmd = "COREPACK_ENABLE_AUTO_PIN=0 "
        .. yarn
        .. " install --frozen-lockfile"
      vim.cmd(cd_cmd .. " && " .. yarn_install_cmd)
    end,
    init = function()
      local plugin =
        require("lazy.core.config").spec.plugins["markdown-preview.nvim"]
      vim.g.mkdp_filetypes =
        require("lazy.core.plugin").values(plugin, "ft", true)
    end,
    ft = { "markdown", "markdown.mdx" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  },

  --  [markdown markmap]
  --  https://github.com/zeioth/markmap.nvim
  --  Important: Make sure you have yarn in your PATH before running markmap.
  {
    "zeioth/markmap.nvim",
    build = "mise use -g npm:markmap-cli",
    cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
    config = function(_, opts) require("markmap").setup(opts) end,
  },

  --  ARTIFICIAL INTELLIGENCE  -------------------------------------------------

  --  copilot [github code suggestions]
  --  https://github.com/zbirenbaum/copilot.lua
  --  As alternative to chatgpt, you can use copilot uncommenting this.
  --  Then you must run :Copilot auth
  {
    "zbirenbaum/copilot.lua",
    event = "User BaseFile",
    opts = {
      suggestion = {
        enabled = true, -- Enable
        auto_trigger = true, -- Automatically trigger suggestions.
        debounce = 50, -- Debounce time in milliseconds.
        keymap = {
          accept = "<M-#>", -- Accept the suggestion.
          accept_word = "<C-l>", -- Accept the suggestion word.
          accept_line = "<C-ö>", -- Accept the suggestion line.
          next = "<C-j>", -- Go to next suggestion.
          prev = "<C-k>", -- Go to previous suggestion.
          dismiss = "<M-ö>", -- Dismiss the suggestion.
          open = "<C-o>", -- Open the suggestion in a new buffer.
          open_automatically = true, -- Open the suggestion automatically.
          on_open = function() -- Function to run when suggestion is opened.
            vim.cmd("startinsert") -- Start insert mode when suggestion is opened.
          end,
        },
      },
      panel = {
        layout = {
          position = "right", -- Position of the copilot panel.
        },
        enable = true, -- Enable the copilot panel.
        auto_refresh = true, -- Automatically refresh the panel.
      },
      workspace_folders = {
        "~/projects/", -- Add your projects folder here.
        "~/tools/", -- Add your tools folder here.
      },
      filetypes = {
        markdown = false, -- Disable copilot on markdown files.
        gitcommit = false, -- Disable copilot on git commit messages.
        gitrebase = false, -- Disable copilot on git rebase messages.
        ["*"] = true, -- Enable copilot on all other filetypes.
        sh = function()
          if
            string.match(
              vim.fs.basename(vim.api.nvim_buf_get_name(0)),
              "^%.env.*"
            )
          then
            -- disable for .env files
            return false
          end
          return true
        end,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    end,
  },
  -- [claudecode.nvim]
  -- https://github.com/coder/claudecode.nvim
  -- This plugin is a wrapper around the Claude API.
  -- It allows you to use Claude as a code assistant.
  -- Claude Code can even interact with your codebase.
  {
    "coder/claudecode.nvim",
    event = "User BaseFile",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal = {
        split_width_percentage = 0.4, -- Width of the terminal split.
      },
    },
    keys = {
      {
        "<leader>ac",
        "<cmd>ClaudeCode<cr>",
        desc = "Toggle Claude",
      },
      {
        "<leader>af",
        "<cmd>ClaudeCodeFocus<cr>",
        desc = "Focus Claude",
      },
      {
        "<leader>ar",
        "<cmd>ClaudeCode --resume<cr>",
        desc = "Resume Claude",
      },
      {
        "<leader>aC",
        "<cmd>ClaudeCode --continue<cr>",
        desc = "Continue Claude",
      },
      {
        "<leader>ab",
        "<cmd>ClaudeCodeAdd %<cr>",
        desc = "Add current buffer",
      },
      {
        "<leader>as",
        "<cmd>ClaudeCodeSend<cr>",
        mode = "v",
        desc = "Send to Claude",
      },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  -- [claude-code.nvim]
  -- https://github.conm/greggh/claude-code.nvim
  -- This plugin is a wrapper around the Claude API.
  -- It allows you to use Claude as a code assistant.
  {
    "greggh/claude-code.nvim",
    event = "User BaseFile",
    enabled = false, -- Disable for testing other plugin.
    cmd = { "ClaudeCode", "ClaudeCodeToggle" },
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    opts = {
      window = {
        position = "vertical", -- Position of the window.
        float = {
          border = "rounded", -- Border style of the window.
          width = "60%", -- Width of the window.
          height = "70%", -- Height of the window.
          row = "center", -- Row position of the window.
          col = "center", -- Column position of the window.
          relative = "editor", -- Relative position of the window.
        },
      },
      keymaps = {
        toggle = {
          normal = "<F4>", -- F4 in normal mode
          terminal = "<F4>", -- F4 in terminal mode (with auto-escape)
        },
      },
    },
    config = function(_, opts) require("claude-code").setup(opts) end,
  },

  -- [guess-indent]
  -- https://github.com/NMAC427/guess-indent.nvim
  -- Note that this plugin won't autoformat the code.
  -- It just set the buffer options to tabluate in a certain way.
  {
    "NMAC427/guess-indent.nvim",
    event = "User BaseFile",
    opts = {},
  },

  --  COMPILER ----------------------------------------------------------------
  --  compiler.nvim [compiler]
  --  https://github.com/zeioth/compiler.nvim
  {
    "zeioth/compiler.nvim",
    cmd = {
      "CompilerOpen",
      "CompilerToggleResults",
      "CompilerRedo",
      "CompilerStop",
    },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
  },

  --  overseer [task runner]
  --  https://github.com/stevearc/overseer.nvim
  --  If you need to close a task immediately:
  --  press ENTER in the output menu on the task you wanna close.
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerClearCache",
    },
    opts = {
      task_list = { -- the window that shows the results.
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
      -- component_aliases = {
      --   default = {
      --     -- Behaviors that will apply to all tasks.
      --     "on_exit_set_status",                   -- don't delete this one.
      --     "on_output_summarize",                  -- show last line on the list.
      --     "display_duration",                     -- display duration.
      --     "on_complete_notify",                   -- notify on task start.
      --     "open_output",                          -- focus last executed task.
      --     { "on_complete_dispose", timeout=300 }, -- dispose old tasks.
      --   },
      -- },
    },
  },


  --  TESTING -----------------------------------------------------------------
  --  Run tests inside of nvim [unit testing]
  --  https://github.com/nvim-neotest/neotest
  --
  --
  --  MANUAL:
  --  -- Unit testing:
  --  To tun an unit test you can run any of these commands:
  --
  --    :Neotest run      -- Runs the nearest test to the cursor.
  --    :Neotest stop     -- Stop the nearest test to the cursor.
  --    :Neotest run file -- Run all tests in the file.
  --
  --  -- E2e and Test Suite
  --  Normally you will prefer to open your e2e framework GUI outside of nvim.
  --  But you have the next commands in ../base/3-autocmds.lua:
  --
  --    :TestNodejs    -- Run all tests for this nodejs project.
  --    :TestNodejsE2e -- Run the e2e tests/suite for this nodejs project.
  {
    "nvim-neotest/neotest",
    cmd = { "Neotest" },
    dependencies = {
      "sidlatau/neotest-dart",
      "Issafalcon/neotest-dotnet",
      "jfpedroza/neotest-elixir",
      "fredrikaverpil/neotest-golang",
      "rcasia/neotest-java",
      "nvim-neotest/neotest-jest",
      "olimorris/neotest-phpunit",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "lawrence-laz/neotest-zig",
    },
    opts = function()
      return {
        -- your neotest config here
        adapters = {
          require("neotest-dart"),
          require("neotest-dotnet"),
          require("neotest-elixir"),
          require("neotest-golang"),
          require("neotest-java"),
          require("neotest-jest"),
          require("neotest-phpunit"),
          require("neotest-python"),
          require("neotest-rust"),
          require("neotest-zig"),
        },
      }
    end,
    config = function(_, opts)
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message
              :gsub("\n", " ")
              :gsub("\t", " ")
              :gsub("%s+", " ")
              :gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup(opts)
    end,
  },

  --  Shows a float panel with the [code coverage]
  --  https://github.com/andythigpen/nvim-coverage
  --
  --  Your project must generate coverage/lcov.info for this to work.
  --
  --  On jest, make sure your packages.json file has this:
  --  "tests": "jest --coverage"
  --
  --  If you use other framework or language, refer to nvim-coverage docs:
  --  https://github.com/andythigpen/nvim-coverage/blob/main/doc/nvim-coverage.txt
  {
    "andythigpen/nvim-coverage",
    cmd = {
      "Coverage",
      "CoverageLoad",
      "CoverageLoadLcov",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
      "CoverageSummary",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      summary = {
        min_coverage = 80.0, -- passes if higher than
      },
    },
    config = function(_, opts) require("coverage").setup(opts) end,
  },

  -- LANGUAGE IMPROVEMENTS ----------------------------------------------------
  -- guttentags_plus [auto generate C/C++ tags]
  -- https://github.com/skywind3000/gutentags_plus
  -- This plugin is necessary for using <C-]> (go to ctag).
  {
    "skywind3000/gutentags_plus",
    ft = { "c", "cpp", "lisp" },
    dependencies = { "ludovicchabant/vim-gutentags" },
    config = function()
      -- NOTE: On vimplugins we use config instead of opts.
      vim.g.gutentags_plus_nomap = 1
      vim.g.gutentags_resolve_symlinks = 1
      vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. "/tags"
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Auto generate C/C++ tags",
        callback = function()
          local is_c = vim.bo.filetype == "c" or vim.bo.filetype == "cpp"
          if is_c then
            vim.g.gutentags_enabled = 1
          else
            vim.g.gutentags_enabled = 0
          end
        end,
      })
    end,
  },
} -- end of return
