# Development Workflows & Customization Guide

<!--toc:start-->
- [Development Workflows & Customization Guide](#development-workflows--customization-guide)
  - [Getting Started](#getting-started)
    - [Initial Setup](#initial-setup)
    - [First Launch Checklist](#first-launch-checklist)
    - [Essential Commands](#essential-commands)
  - [Daily Development Workflows](#daily-development-workflows)
    - [Project Navigation](#project-navigation)
    - [File Management](#file-management)
    - [Code Development](#code-development)
    - [Testing & Debugging](#testing--debugging)
    - [Git Integration](#git-integration)
  - [Customization Guide](#customization-guide)
    - [Safe Customization Approach](#safe-customization-approach)
    - [Theme Customization](#theme-customization)
    - [Feature Toggles](#feature-toggles)
    - [Adding New Plugins](#adding-new-plugins)
    - [Keybinding Customization](#keybinding-customization)
    - [LSP Configuration](#lsp-configuration)
  - [Performance Optimization](#performance-optimization)
    - [Startup Time](#startup-time)
    - [Large File Handling](#large-file-handling)
    - [Memory Management](#memory-management)
    - [Platform-Specific Optimizations](#platform-specific-optimizations)
  - [Troubleshooting](#troubleshooting)
    - [Common Issues](#common-issues)
    - [Plugin Conflicts](#plugin-conflicts)
    - [LSP Problems](#lsp-problems)
    - [Performance Issues](#performance-issues)
  - [Advanced Workflows](#advanced-workflows)
    - [Multi-Language Projects](#multi-language-projects)
    - [Remote Development](#remote-development)
    - [Documentation Generation](#documentation-generation)
    - [CI/CD Integration](#cicd-integration)
<!--toc:end-->

## Getting Started

### Initial Setup

**Fork-First Approach** (Recommended):
```bash
# 1. Fork NormalNvim repository on GitHub
# 2. Clone YOUR fork (not the original)
git clone https://github.com/YOUR_USERNAME/NormalNvim.git ~/.config/nvim

# 3. Launch Neovim - plugins will auto-install
nvim

# 4. Check health after installation
:checkhealth base
```

**Direct Clone** (Not recommended for customization):
```bash
git clone https://github.com/NormalNvim/NormalNvim.git ~/.config/nvim
```

**Why Fork?**
- You control updates and customizations
- No conflicts with upstream changes
- Easy to maintain personal modifications
- Can contribute back via pull requests

### First Launch Checklist

1. **Let plugins install** - First launch will take 2-3 minutes
2. **Run health check**: `:checkhealth base`
3. **Install missing dependencies** based on health check results
4. **Set up Mason tools**: `:Mason` → Install LSP servers for your languages
5. **Install treesitter parsers**: `:TSInstall all`
6. **Test basic functionality**:
   - File navigation: `<Space>ff` (find files)
   - Buffer management: `<Tab>` (next buffer)
   - Terminal: `<F7>` (toggle terminal)
   - LSP: Open a code file and test `gd` (go to definition)

### Essential Commands

**Distribution Management**:
- `:DistroUpdate` - Update NormalNvim from your fork/upstream
- `:DistroUpdateRevert` - Rollback last update
- `:DistroFreezePluginVersions` - Lock current plugin versions

**Plugin Management**:
- `:Lazy` - Plugin manager interface
- `:Mason` - LSP/tool manager
- `:MasonUpdateAll` - Update all Mason packages

**Health & Diagnostics**:
- `:checkhealth base` - NormalNvim health check
- `:LspInfo` - LSP server status
- `:TSUpdate` - Update treesitter parsers

---

## Daily Development Workflows

### Project Navigation

**Opening Projects**:
```bash
# Method 1: Open directory (project auto-detected)
nvim /path/to/project

# Method 2: Open from within Neovim
:cd ~/projects/myapp
:e .
```

**Project Root Detection**:
NormalNvim automatically detects project roots using these patterns:
- `.git`, `.hg`, `.svn`, `.bzr` (VCS)
- `Makefile`, `package.json`, `.solution` (Build files)
- Custom patterns in `project.nvim` configuration

**Navigation Workflow**:
1. **`<Space>ff`** - Find files in project
2. **`<Space>fg`** - Live grep search
3. **`<Space>fb`** - Browse open buffers
4. **`<Space>fr`** - Recent files
5. **`<Space>e`** - Toggle file tree (Neotree)
6. **`<Space>r`** - File browser (yazi)

### File Management

**Buffer Workflow**:
- **`<Tab>`** / **`<S-Tab>`** - Navigate between buffers
- **`<Space>c`** - Close current buffer (smart)
- **`<Space>w`** - Save file
- **`<Space>q`** - Quit with confirmation

**Advanced File Operations**:
- **`<Space>fs`** - Search and replace in project (Spectre)
- **`:Yazi`** - Full-featured file management
- **Hot reload** - Configuration changes apply immediately

**Session Management**:
```vim
" Sessions are managed automatically by session-manager
" Manual session commands:
:SessionManager load_session
:SessionManager save_current_session
:SessionManager delete_session
```

### Code Development

**LSP-Powered Development**:
1. **Navigation**:
   - **`gd`** - Go to definition
   - **`gr`** - Find references
   - **`gi`** - Go to implementation
   - **`<Space>ls`** - Document symbols

2. **Code Actions**:
   - **`<Space>la`** - Code actions
   - **`<Space>lr`** - Rename symbol
   - **`<Space>lf`** - Format document
   - **`gh`** - Hover documentation

3. **Diagnostics**:
   - **`]d`** / **`[d`** - Next/previous diagnostic
   - **`<Space>ld`** - Show line diagnostics
   - **`<Space>lq`** - Diagnostic quickfix list

**Completion Workflow**:
- **`<C-Space>`** - Manual completion trigger
- **`<Tab>`** - Accept completion / expand snippet
- **`<C-n>`** / **`<C-p>`** - Navigate completion items
- **`<C-b>`** / **`<C-f>`** - Scroll documentation

**Code Intelligence**:
- **Auto-pairs**: Brackets, quotes auto-close
- **Treesitter**: Syntax-aware selections with `af`, `if`, `ac`, `ic`
- **Folding**: `za` (toggle), `zR` (open all), `zM` (close all)

### Testing & Debugging

**Testing Workflow**:
1. **Run tests**: `<Space>tt` (test file), `<Space>ta` (all tests)
2. **Debug tests**: `<Space>td` (debug nearest test)
3. **View output**: `<Space>to` (test output)
4. **Test summary**: `<Space>ts` (test summary)

**Debugging Workflow**:
1. **Set breakpoints**: `<Space>db` (toggle breakpoint)
2. **Start debugging**: `<Space>dc` (continue/start)
3. **Step through code**:
   - `<Space>ds` - Step over
   - `<Space>di` - Step into
   - `<Space>do` - Step out
4. **Inspect variables**: Use DAP UI panels
5. **Debug console**: REPL for evaluation

**Coverage Analysis**:
```vim
:Coverage      " Load and display coverage
:CoverageSummary  " Show coverage summary
```

### Git Integration

**Basic Git Operations**:
- **`<Space>gg`** - Git status (fugitive/lazygit)
- **`<Space>gf`** - Git file history
- **`<Space>gd`** - Git diff current file
- **`<Space>gb`** - Git blame

**Git Signs** (inline git status):
- **`]g`** / **`[g`** - Next/previous git hunk
- **`<Space>gp`** - Preview hunk
- **`<Space>gr`** - Reset hunk
- **`<Space>gs`** - Stage hunk

**Advanced Git Workflow**:
1. **Review changes**: `<Space>gd` (diff), `<Space>gp` (preview hunks)
2. **Stage selectively**: `<Space>gs` (stage hunks)
3. **Commit**: `<Space>gg` (open git tool) or `:Git commit`
4. **Push/Pull**: Use integrated git tool or terminal

---

## Customization Guide

### Safe Customization Approach

**Golden Rules**:
1. **Always fork before customizing** - Never modify the original repository
2. **Make incremental changes** - Change one thing at a time
3. **Test after each change** - Run `:checkhealth base` after modifications
4. **Version lock for stability** - Use `:DistroFreezePluginVersions`
5. **Keep customizations minimal** - Less is more for maintainability

**Customization Workflow**:
```bash
# 1. Create a branch for your customizations
git checkout -b my-customizations

# 2. Make changes to configuration files
# 3. Test changes
nvim
:checkhealth base

# 4. Commit your changes
git add .
git commit -m "feat: add custom theme configuration"

# 5. Lock plugin versions for stability
# In Neovim:
:DistroFreezePluginVersions
```

### Theme Customization

**Changing Default Theme**:
```lua
-- In lua/base/1-options.lua
vim.g.default_colorscheme = "tokyonight-night"  -- or any installed theme
```

**Adding New Themes**:
```lua
-- Create lua/plugins/my-themes.lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    event = "User LoadColorSchemes",
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = true,
        mini = true,
      },
    },
  },
}
```

**Preview Themes**:
- **`<Space>ft`** - Telescope theme selector
- Change theme instantly and see results

### Feature Toggles

**Core Feature Toggles** (in `lua/base/1-options.lua`):
```lua
-- Completion
vim.g.cmp_enabled = true                    -- Enable/disable completion

-- Diagnostics (0=off, 1=signs, 2=virtual_text, 3=both)
vim.g.diagnostics_mode = 3                  

-- LSP Features
vim.g.inlay_hints_enabled = true            -- LSP inlay hints
vim.g.lsp_document_highlight = true         -- Highlight references
vim.g.lsp_round_borders_enabled = true      -- Rounded LSP hover borders

-- UI Features
vim.g.autopairs_enabled = true              -- Auto-close brackets
vim.g.url_effect_enabled = true             -- URL highlighting
vim.g.fallback_icons_enabled = false        -- ASCII icons fallback

-- Performance
vim.g.big_file = {                          -- Big file detection
  size = 1024 * 100,    -- 100KB
  lines = 10000         -- 10K lines
}
```

**Plugin-Specific Toggles**:
```lua
-- Disable specific plugins by commenting them out or adding conditions
-- In plugin files, wrap with:
if vim.g.my_custom_feature_enabled then
  return {
    -- plugin configuration
  }
else
  return {}
end
```

### Adding New Plugins

**Plugin File Structure**:
```lua
-- Create lua/plugins/my-plugins.lua
return {
  {
    "plugin-author/plugin-name",
    event = "VeryLazy",  -- or specific trigger event
    cmd = { "PluginCommand" },  -- optional command-based loading
    ft = { "python", "javascript" },  -- optional filetype-based loading
    dependencies = { "required-plugin" },  -- optional dependencies
    opts = {
      -- plugin configuration options
    },
    config = function(_, opts)
      -- custom setup function if needed
      require("plugin-name").setup(opts)
    end,
  },
}
```

**Loading Strategies**:
- **`event = "VeryLazy"`** - Load after startup
- **`event = "User BaseDefered"`** - Load with other deferred plugins
- **`cmd = { "Command" }`** - Load on command execution
- **`ft = { "filetype" }`** - Load on file type
- **`keys = { "<leader>x" }`** - Load on key press

**Integration Checklist**:
1. **Check availability**: Use `utils.is_available("plugin-name")` for conditional features
2. **Add keybindings**: Add to `lua/base/4-mappings.lua`
3. **Add to which-key**: Include descriptions for discoverability
4. **Test thoroughly**: Ensure no conflicts with existing plugins
5. **Update health check**: Add to `lua/base/health.lua` if needed

### Keybinding Customization

**Adding Custom Keybindings**:
```lua
-- In lua/base/4-mappings.lua, add to the maps table
local maps = utils.get_mappings_template()

-- Normal mode mapping
maps.n["<leader>x"] = { "<cmd>MyCommand<cr>", desc = "My custom command" }

-- Visual mode mapping
maps.v["<leader>y"] = { '"*y', desc = "Copy to system clipboard" }

-- Insert mode mapping
maps.i["<C-h>"] = { "<Left>", desc = "Move cursor left" }

-- Multiple modes
maps["nv"] = {
  ["<leader>z"] = { ":lua MyFunction()<cr>", desc = "Custom function" }
}
```

**Which-key Integration**:
```lua
-- Group mappings under a prefix
maps.n["<leader>m"] = { desc = utils.get_icon("Settings", true) .. "My Tools" }
maps.n["<leader>ma"] = { ":MyCommand<cr>", desc = "Action A" }
maps.n["<leader>mb"] = { ":MyOtherCommand<cr>", desc = "Action B" }
```

**LSP-Specific Mappings**:
```lua
-- In lua/base/4-mappings.lua, modify the lsp_mappings function
M.lsp_mappings = function(client, bufnr)
  local maps = utils.get_mappings_template()
  
  -- Add custom LSP mapping
  maps.n["<leader>lx"] = { 
    function() 
      vim.lsp.buf.custom_action() 
    end, 
    desc = "Custom LSP action" 
  }
  
  return maps
end
```

### LSP Configuration

**Adding Language Servers**:
```lua
-- In lua/base/utils/lsp.lua, modify apply_user_lsp_settings
function M.apply_user_lsp_settings(server_name)
  local server = require("lspconfig")[server_name]
  local opts = vim.tbl_deep_extend("force", server, { 
    capabilities = M.capabilities, 
    flags = M.flags 
  })

  -- Custom server configurations
  if server_name == "my_language_server" then
    opts.settings = {
      myLanguage = {
        diagnostics = { enable = true },
        completion = { enable = true },
      }
    }
  end

  return opts
end
```

**Mason Integration**:
```lua
-- In lua/plugins/3-dev-core.lua, add to ensure_installed
{
  "williamboman/mason-lspconfig.nvim",
  opts = {
    ensure_installed = {
      "lua_ls", "bashls", "clangd", "pyright", 
      "tsserver", "rust_analyzer",
      "my_new_language_server",  -- Add here
    },
  },
}
```

---

## Performance Optimization

### Startup Time

**Measuring Startup Time**:
```bash
# Measure total startup time
nvim --startuptime startup.log +q && tail -1 startup.log

# Profile startup with lazy.nvim
nvim --headless -c 'autocmd User LazyVeryLazy quitall' +q
```

**Optimization Strategies**:
1. **Lazy loading**: Ensure plugins load only when needed
2. **Event-based loading**: Use appropriate events (`User BaseDefered`, `VeryLazy`)
3. **Command/filetype loading**: Load plugins only when commands are used or filetypes opened
4. **Reduce auto-installed tools**: Only install LSP servers/tools you actually use

**Startup Configuration**:
```lua
-- In lua/base/1-options.lua, optimize startup
vim.opt.updatetime = 300        -- Faster plugin triggers
vim.opt.timeoutlen = 500        -- Faster which-key popup
vim.g.loaded_netrw = 1          -- Disable netrw (we use neotree/yazi)
vim.g.loaded_netrwPlugin = 1
```

### Large File Handling

**Big File Detection**:
```lua
-- In lua/base/1-options.lua
vim.g.big_file = {
  size = 1024 * 100,    -- 100KB threshold
  lines = 10000         -- 10K lines threshold
}
```

**Automatic Optimizations**:
- **Treesitter**: Automatically disabled for big files
- **LSP**: Reduced functionality for large files
- **Syntax highlighting**: Falls back to basic vim syntax
- **Folding**: Disabled to prevent performance issues

**Manual Optimizations**:
```vim
" For very large files, disable more features
:set eventignore=all          " Disable all autocommands
:set lazyredraw              " Don't redraw during macros
:syntax off                  " Disable syntax highlighting
```

### Memory Management

**Plugin Memory Management**:
- **garbage-day.nvim**: Automatically cleans up LSP memory
- **Lazy loading**: Keeps unused plugins out of memory
- **Buffer limits**: NormalNvim manages buffer lifecycle

**Manual Memory Management**:
```vim
:lua collectgarbage()         " Force Lua garbage collection
:LspRestart                   " Restart LSP servers to free memory
```

### Platform-Specific Optimizations

**Android (Termux)**:
```lua
-- Automatic Android detection and optimizations
local is_android = vim.fn.isdirectory('/data') == 1

if is_android then
  -- Smaller yazi window
  floating_window_scaling_factor = 1.0
  
  -- Reduced animations
  vim.g.animate_enabled = false
  
  -- Simpler UI
  vim.g.fancy_ui_enabled = false
end
```

**Windows**:
```lua
-- Windows-specific optimizations
local is_windows = vim.fn.has("win32") == 1

if is_windows then
  -- Better shell integration
  vim.opt.shell = "pwsh"
  
  -- Path handling
  vim.opt.shellslash = true
end
```

---

## Troubleshooting

### Common Issues

**Plugins Not Loading**:
1. Check `:Lazy` for plugin status and errors
2. Verify dependencies are installed: `:checkhealth base`
3. Check for syntax errors in configuration files
4. Try `:Lazy reload` to refresh plugin specs

**Icons Not Showing**:
1. Install a Nerd Font and configure your terminal
2. Enable fallback icons: `vim.g.fallback_icons_enabled = true`
3. Check font configuration in terminal settings

**Slow Startup**:
1. Profile startup: `nvim --startuptime startup.log`
2. Check for plugins loading eagerly instead of lazily
3. Reduce auto-installed Mason tools
4. Use `:Lazy profile` to identify slow plugins

**Configuration Not Reloading**:
1. Hot reload only works for specific files (`1-options.lua`, `4-mappings.lua`)
2. Other changes require Neovim restart
3. Check for syntax errors preventing reload

### Plugin Conflicts

**LSP Conflicts**:
```vim
:LspInfo                     " Check active LSP servers
:LspRestart                  " Restart all LSP servers
:checkhealth lsp             " Check LSP health
```

**Completion Conflicts**:
```vim
:lua =vim.g.cmp_enabled      " Check if completion is enabled
:CmpStatus                   " Check nvim-cmp status
```

**Treesitter Issues**:
```vim
:TSUpdate                    " Update parsers
:TSInstall all               " Install all parsers
:TSModuleInfo                " Check module status
```

### LSP Problems

**Language Server Not Attaching**:
1. Check if language server is installed: `:Mason`
2. Verify file type detection: `:set filetype?`
3. Check LSP logs: `:LspLog`
4. Manual server start: `:LspStart servername`

**No Completions/Diagnostics**:
1. Verify LSP server supports feature: `:LspInfo`
2. Check client capabilities are set correctly
3. Restart LSP: `:LspRestart`
4. Check none-ls configuration: `:NullLsInfo`

**Formatting Not Working**:
1. Check if formatter is installed: `:Mason`
2. Verify none-ls configuration: `:NullLsInfo`
3. Manual format: `:lua vim.lsp.buf.format()`
4. Check format-on-save settings

### Performance Issues

**High CPU Usage**:
1. Check for infinite loops in LSP/treesitter
2. Disable problematic plugins temporarily
3. Use `:profile start profile.log` and `:profile file *` to identify issues
4. Restart LSP servers: `:LspRestart`

**High Memory Usage**:
1. Check LSP memory with `:LspInfo`
2. Restart memory-heavy processes
3. Enable garbage collection plugin (garbage-day.nvim)
4. Close unused buffers: `:%bd|e#`

**Laggy Typing**:
1. Check if it's specific to certain file types
2. Disable treesitter temporarily: `:TSDisable highlight`
3. Check LSP responsiveness: `:LspInfo`
4. Profile with `:set verbose=9` to identify slow operations

---

## Advanced Workflows

### Multi-Language Projects

**Project Structure Example**:
```
my-fullstack-app/
├── frontend/          # React/TypeScript
├── backend/           # Python/FastAPI
├── mobile/            # React Native
├── docs/              # Markdown
└── scripts/           # Shell scripts
```

**LSP Configuration**:
NormalNvim automatically detects and configures LSP servers for:
- **Frontend**: tsserver, eslint, prettier
- **Backend**: pyright, black, isort
- **Mobile**: tsserver (shared with frontend)
- **Docs**: marksman (markdown)
- **Scripts**: bashls

**Workflow Integration**:
1. **Root detection**: Works at project root level
2. **Workspace configuration**: LSP servers understand monorepo structure
3. **Cross-language references**: Some LSP servers support cross-language features

### Remote Development

**SSH/Remote Editing**:
```bash
# Edit remote files directly
nvim scp://user@server/path/to/file

# Use with yazi for remote file browsing
yazi scp://user@server/path/
```

**Container Development**:
```bash
# Docker container editing
docker exec -it container_name nvim /path/to/code

# With volume mounts
docker run -v $(pwd):/workspace -it my-dev-image nvim /workspace
```

**Performance Considerations**:
- Disable heavy plugins for remote editing
- Use minimal configuration for low-bandwidth connections
- Consider using terminal multiplexers (tmux/screen)

### Documentation Generation

**Built-in Documentation Tools**:
1. **Dooku.nvim**: Multi-language documentation generator
2. **Markmap.nvim**: Mind maps from markdown
3. **Markdown Preview**: Live preview for documentation

**Documentation Workflow**:
```vim
" Generate project documentation
:DookuGenerate

" Open generated docs
:DookuOpen

" Create mind map from current markdown file
:MarkmapOpen

" Live markdown preview
:MarkdownPreview
```

**Integration with Build Systems**:
- Documentation generation integrated with compiler.nvim
- Automatic docs building on save (configurable)
- Git hooks for documentation updates

### CI/CD Integration

**Pre-commit Hooks**:
```bash
# Install pre-commit in your project
pip install pre-commit

# Configure .pre-commit-config.yaml
hooks:
  - repo: local
    hooks:
      - id: lint-lua
        name: Lint Lua files
        entry: stylua --check
        language: system
        files: \.lua$
```

**GitHub Actions Integration**:
```yaml
# .github/workflows/nvim-config.yml
name: NormalNvim Configuration
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Neovim
        run: |
          wget -O nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
          chmod +x nvim.appimage
          ./nvim.appimage --version
      - name: Test Configuration
        run: |
          ./nvim.appimage --headless -c 'checkhealth base' -c 'qa'
```

**Continuous Documentation**:
- Automatic documentation generation on commits
- Integration with GitHub Pages for documentation hosting
- Documentation versioning with releases

This comprehensive guide covers the essential workflows and customization patterns for NormalNvim, enabling both productive daily use and safe, maintainable customizations.