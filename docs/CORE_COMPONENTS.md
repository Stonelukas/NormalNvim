# Core Components Documentation

<!--toc:start-->
- [Core Components Documentation](#core-components-documentation)
  - [Entry Point & Loading System](#entry-point-loading-system)
    - [init.lua - Safe Loading Architecture](#initlua---safe-loading-architecture)
  - [Base Configuration Modules](#base-configuration-modules)
    - [1-options.lua - Configuration Variables](#1-optionslua---configuration-variables)
    - [2-lazy.lua - Plugin Manager Setup](#2-lazylua---plugin-manager-setup)
    - [3-autocmds.lua - Auto Commands](#3-autocmdslua---auto-commands)
    - [4-mappings.lua - Keybinding System](#4-mappingslua---keybinding-system)
  - [Utility Systems](#utility-systems)
    - [base/utils/init.lua - Core Utilities](#baseutilsinitlua---core-utilities)
    - [base/utils/lsp.lua - LSP Configuration](#baseutilslsplua---lsp-configuration)
    - [base/utils/ui.lua - UI Toggles](#baseutilsuilua---ui-toggles)
    - [base/health.lua - Health Check System](#basehealthlua---health-check-system)
    - [base/icons/ - Icon Management](#baseicons---icon-management)
<!--toc:end-->

## Entry Point & Loading System

### init.lua - Safe Loading Architecture

**Overview**: The main entry point for NormalNvim with error-safe loading, async execution, and proper initialization order.

**Core Functions**:
```lua
load_source(source)           -- Safe loading with error handling
load_sources(source_files)    -- Synchronous batch loading
load_sources_async(files)     -- Asynchronous loading for non-critical modules
load_colorscheme(colorscheme) -- Safe colorscheme application
```

**Loading Sequence**:
1. **Critical modules** (sync): `base.1-options` → `base.2-lazy` → `base.3-autocmds`
2. **Colorscheme application**: Apply theme from `vim.g.default_colorscheme`
3. **Non-critical modules** (async): `base.4-mappings` (50ms delay)

**Error Handling**:
- **pcall protection**: All requires wrapped in safe calls
- **Error reporting**: Failed loads displayed with full error context
- **Graceful degradation**: Failed modules don't crash initialization

**Performance Optimizations**:
- **vim.loader.enable()**: Bytecode caching for faster startups
- **Async loading**: Non-critical modules loaded after UI is available
- **Single colorscheme load**: Only applies if `vim.g.default_colorscheme` is set

**Critical Design Rules**:
- ⚠️ **Never change loading order** of first three base modules
- ⚠️ **Never make 4-mappings synchronous** - it's async for performance
- ⚠️ **Always test error scenarios** when modifying loading functions

---

## Base Configuration Modules

### 1-options.lua - Configuration Variables

**Overview**: Neovim editor options, global variables, and feature toggles. This is the first module loaded and sets the foundation for all other configuration.

**Key Configuration Categories**:

**Theme & UI**:
```lua
vim.g.default_colorscheme = "astrodark"  -- Default theme
vim.opt.termguicolors = true             -- 24-bit RGB colors
vim.opt.signcolumn = "yes"               -- Always show sign column
vim.opt.cursorline = true                -- Highlight current line
```

**Editor Behavior**:
```lua
vim.opt.expandtab = true                 -- Use spaces instead of tabs
vim.opt.shiftwidth = 2                   -- Indentation width
vim.opt.clipboard = "unnamedplus"        -- System clipboard integration
vim.opt.ignorecase = true                -- Case insensitive search
vim.opt.smartcase = true                 -- Smart case sensitivity
```

**Feature Toggles** (Global variables that control plugin behavior):
- `vim.g.autopairs_enabled` - Auto-close brackets/quotes
- `vim.g.cmp_enabled` - Completion engine
- `vim.g.diagnostics_mode` - LSP diagnostics (0=off, 1=signs, 2=virtual text, 3=both)
- `vim.g.inlay_hints_enabled` - LSP inlay hints
- `vim.g.lsp_document_highlight` - Highlight references under cursor

**Performance Settings**:
```lua
vim.g.big_file = { size = 1024 * 100, lines = 10000 }  -- Big file thresholds
vim.opt.updatetime = 300                                -- Plugin trigger delay
vim.opt.undofile = true                                 -- Persistent undo
```

**Hot Reload**: Changes to this file automatically reload via hot-reload.nvim

**Customization Approach**:
1. **Fork-friendly**: All options exposed as variables
2. **Override-safe**: Plugin configurations check these variables
3. **Performance-aware**: Big file detection optimizes heavy plugins

---

### 2-lazy.lua - Plugin Manager Setup

**Overview**: Lazy.nvim plugin manager configuration with auto-installation, update channels, and performance optimization.

**Core Features**:
- **Auto-installation**: Installs lazy.nvim if not present
- **Update channels**: Stable vs nightly plugin versions
- **Performance**: Lazy loading, caching, and startup optimization
- **Version locking**: Snapshot system for stability

**Configuration Structure**:
```lua
-- Auto-install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- Clone and setup lazy.nvim
end

-- Plugin specifications
require("lazy").setup({
  spec = {
    { import = "plugins.1-base-behaviors" },
    { import = "plugins.2-ui" },
    { import = "plugins.3-dev-core" },
    { import = "plugins.4-dev" },
  },
  -- Performance and UI options
})
```

**Update System**:
- **Stable channel**: Tested, stable plugin versions (default)
- **Nightly channel**: Latest features, potentially unstable
- **Snapshot system**: `:DistroFreezePluginVersions` locks current versions
- **Rollback capability**: `:DistroUpdateRevert` reverts last update

**Performance Optimizations**:
- **Lazy loading**: Plugins load on events, commands, or file types
- **Caching**: Bytecode caching and module caching
- **Startup profiling**: Built-in startup time analysis

---

### 3-autocmds.lua - Auto Commands

**Overview**: Auto commands for file type detection, UI behaviors, and event-driven functionality. Critical for proper plugin initialization.

**Key Auto Command Groups**:

**File Type Detection**:
- Custom file type associations
- Language-specific settings
- Plugin activation triggers

**UI Behaviors**:
- Window management
- Buffer lifecycle events
- Visual feedback triggers

**Plugin Integration**:
- LSP attachment events
- Completion setup
- Syntax highlighting

**Performance Considerations**:
- **Event-driven**: Only active when needed
- **Buffer-specific**: Commands scoped to relevant buffers
- **Group management**: Organized in named groups for cleanup

**Critical Nature**: This module must load before plugins to ensure proper event handling

---

### 4-mappings.lua - Keybinding System

**Overview**: Complete keybinding system with leader-based navigation, plugin integration, and which-key support. Loads asynchronously for performance.

**Architecture**:
```lua
-- Base mappings structure
local maps = utils.get_mappings_template()

-- Leader key configuration
vim.g.mapleader = " "  -- Space as leader key

-- Mapping categories
maps.n["<leader>w"] = { "<cmd>w<cr>", desc = "Save" }
maps.n["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" }
```

**Mapping Categories**:

**Essential Operations**:
- File operations: save, quit, close buffer
- Buffer navigation: next/previous buffer
- Search: clear highlighting, find
- Terminal: toggle terminal

**Plugin Integration**:
- Telescope: `<leader>f*` (find operations)
- Git: `<leader>g*` (git operations)
- LSP: `<leader>l*` (language server)
- UI: `<leader>u*` (toggles)
- Debugger: `<leader>d*` (DAP)
- Testing: `<leader>T*` (neotest)

**LSP Mappings** (Auto-applied when LSP attaches):
```lua
function M.lsp_mappings(client, bufnr)
  return {
    n = {
      gd = { vim.lsp.buf.definition, desc = "Go to definition" },
      gr = { vim.lsp.buf.references, desc = "References" },
      gh = { vim.lsp.buf.hover, desc = "Hover documentation" },
      ["<leader>la"] = { vim.lsp.buf.code_action, desc = "Code action" },
      ["<leader>lr"] = { vim.lsp.buf.rename, desc = "Rename" },
    }
  }
end
```

**Which-key Integration**:
- Automatic registration of mappings with descriptions
- Hierarchical menu structure
- Icon support via utils.get_icon()

**Async Loading**: Loads 50ms after startup to avoid blocking initial UI

---

## Utility Systems

### base/utils/init.lua - Core Utilities

**Overview**: Essential utility functions used throughout NormalNvim for shell commands, mappings, notifications, and plugin management.

**Core Functions**:

**Command Execution**:
```lua
M.run_cmd(cmd, show_error)  -- Execute shell commands safely
-- Cross-platform command execution with error handling
-- Returns: command output or nil if failed
```

**Plugin Management**:
```lua
M.is_available(plugin)      -- Check if plugin is available in lazy
M.get_plugin_opts(plugin)   -- Get plugin options from lazy config
-- Used extensively for conditional plugin features
```

**File Operations**:
```lua
M.is_big_file(bufnr)        -- Check if file exceeds size/line limits
M.os_path(path)             -- Convert path to OS-specific format
-- Performance optimization for large files
```

**Mapping Utilities**:
```lua
M.set_mappings(map_table, base)     -- Set keymappings with which-key integration
M.get_mappings_template()           -- Get empty mapping table for all modes
M.which_key_register()              -- Register queued which-key mappings
```

**Auto Command Utilities**:
```lua
M.add_autocmds_to_buffer(augroup, bufnr, autocmds)   -- Add buffer-specific autocmds
M.del_autocmds_from_buffer(augroup, bufnr)           -- Remove buffer autocmds
```

**Icon System**:
```lua
M.get_icon(icon_name, fallback_to_empty_string)
-- Returns nerd font icons or fallback characters
-- Handles vim.g.fallback_icons_enabled automatically
```

**Notification System**:
```lua
M.notify(msg, type, opts)   -- Enhanced vim.notify with default title
-- Scheduled execution to avoid blocking UI
```

**URL Handling**:
```lua
M.set_url_effect()          -- Enable URL highlighting
M.open_with_program(path)   -- Open files/URLs with system programs
```

**Event System**:
```lua
M.trigger_event(event, is_urgent)  -- Trigger custom events
-- Supports both User events and Neovim events
```

**Design Patterns**:
- **Error-safe**: All functions use pcall protection
- **Cross-platform**: Handles Windows, macOS, Linux differences
- **Performance-aware**: Caching and lazy loading where appropriate
- **Plugin-agnostic**: Works with any plugin that follows conventions

---

### base/utils/lsp.lua - LSP Configuration

**Overview**: LSP configuration utilities for mason-lspconfig integration, default settings, and user customizations.

**Core Functions**:

**Default LSP Settings**:
```lua
M.apply_default_lsp_settings()
-- Sets up: diagnostic icons, hover borders, diagnostic configuration, formatting
-- Only executed once during mason-lspconfig setup
```

**Diagnostic Configuration**:
```lua
M.diagnostics = {
  [0] = { -- diagnostics off
    underline = false, virtual_text = false, signs = false
  },
  [1] = { -- status only
    virtual_text = false, signs = false
  },
  [2] = { -- virtual text off, signs on
    virtual_text = false
  },
  [3] = default_diagnostics, -- all on
}
```

**LSP Mappings**:
```lua
M.apply_user_lsp_mappings(client, bufnr)
-- Applies LSP-specific keybindings when LSP server attaches
-- Integrates with base/4-mappings.lua lsp_mappings function
```

**Server Configuration**:
```lua
M.apply_user_lsp_settings(server_name)
-- Returns customized LSP server options
-- Handles: capabilities, flags, server-specific settings
```

**Special Server Handling**:
- **jsonls**: SchemaStore.nvim integration for JSON schemas
- **yamlls**: SchemaStore.nvim integration for YAML schemas
- **Extensible**: Easy to add custom server configurations

**Capabilities Configuration**:
```lua
M.capabilities = vim.lsp.protocol.make_client_capabilities()
-- Enhanced with: completion, snippets, folding, documentation
-- Optimized for nvim-cmp and other completion plugins
```

**Integration Points**:
- **mason-lspconfig**: Called via M.setup(server) for each server
- **none-ls**: Mapping integration for external tools
- **Formatting**: Configurable format-on-save behavior

**Error Handling**:
- **Graceful fallbacks**: Missing schemas don't break functionality
- **Safe loading**: All external requires protected with pcall
- **Diagnostic resilience**: Invalid diagnostic modes fallback to defaults

---

### base/utils/ui.lua - UI Toggles

**Overview**: Dynamic UI control functions for toggling interface elements, diagnostics, and visual features.

**Toggle Functions**:
```lua
M.toggle_diagnostics()      -- Cycle through diagnostic modes (0-3)
M.toggle_background()       -- Switch between dark/light themes
M.toggle_autopairs()        -- Enable/disable auto-closing brackets
M.toggle_cmp()              -- Enable/disable completion
M.toggle_notifications()    -- Enable/disable notification system
```

**State Management**:
- **Global variables**: Uses vim.g.* variables for persistent state
- **Immediate feedback**: Changes apply instantly without restart
- **Status integration**: Works with status line indicators

**UI Element Controls**:
- **Line numbers**: Relative/absolute/off cycling
- **Sign column**: Auto/always/never
- **Color column**: Toggle visual line limit indicator
- **Cursor line**: Toggle current line highlighting

**Integration**:
- **Keybindings**: All functions mapped in 4-mappings.lua under `<leader>u*`
- **Which-key**: Descriptive names and grouping
- **Status line**: Current state displayed in status line

---

### base/health.lua - Health Check System

**Overview**: Comprehensive health check system for validating NormalNvim dependencies and configuration.

**Usage**: `:checkhealth base`

**Check Categories**:

**Version Information**:
```lua
-- NormalNvim version (from distroupdate if available)
-- Neovim version with stability warnings
-- Branch information (stable/nightly)
```

**Essential Dependencies** (Errors if missing):
- **git**: Core functionality, plugin management
- **luarocks**: Package management
- **node/yarn**: JavaScript ecosystem
- **cargo**: Rust tools, spectre, dooku
- **yazi**: File browser
- **fd**: File finding for spectre

**Optional Dependencies** (Warnings if missing):
- **Git tools**: lazygit, gitui, delta
- **Testing**: jest, pytest, cargo nextest, nunit
- **Compilers**: Language-specific compilers and interpreters
- **Documentation**: doxygen, godoc, markmap

**Language Support Checks**:
- **C/C++**: gcc, g++, nasm
- **Python**: python, nuitka, pyinstaller
- **Java**: java, javac
- **C#**: csc, mono, dotnet
- **Go**: go, godoc
- **Web**: node, yarn
- **And many more...**

**Check Logic**:
```lua
for _, program in ipairs(programs) do
  local found = false
  for _, cmd in ipairs(program.cmd) do
    if vim.fn.executable(cmd) == 1 then
      found = true
      break
    end
  end
  
  if found then
    vim.health.ok(message)
  else
    vim.health[program.type](message)  -- error or warn
  end
end
```

**Health Categories**:
- **vim.health.ok()**: Dependency found and working
- **vim.health.error()**: Critical dependency missing
- **vim.health.warn()**: Optional dependency missing
- **vim.health.info()**: Informational messages

**Custom Health Checks**:
- **Neovim version**: Validates >= 0.10.0 requirement
- **Prerelease warnings**: Warns about nightly Neovim instability
- **Complex tools**: Special handling for dotnet, nunit, cargo nextest

---

### base/icons/ - Icon Management

**Overview**: Icon system with nerd font support and ASCII fallbacks for terminals without font support.

**Structure**:
```
base/icons/
├── icons.lua           # Nerd font icons (default)
└── fallback_icons.lua  # ASCII fallback icons
```

**Usage**:
```lua
local utils = require("base.utils")
local icon = utils.get_icon("DiagnosticError")
-- Returns: nerd font icon or ASCII fallback based on vim.g.fallback_icons_enabled
```

**Icon Categories**:
- **Diagnostics**: Error, Warning, Info, Hint indicators
- **Git**: Branch, modified, added, removed status
- **File types**: Language and file type indicators
- **UI elements**: Arrows, separators, status indicators
- **LSP**: Language server and completion indicators
- **DAP**: Debugger breakpoints and status

**Fallback System**:
```lua
vim.g.fallback_icons_enabled = true  -- Use ASCII fallbacks
-- Automatically activated when nerd fonts not available
```

**Integration Points**:
- **Status line**: File type and git status icons
- **Completion**: Kind indicators in nvim-cmp
- **Diagnostics**: Error and warning symbols
- **File browsers**: File type identification
- **Which-key**: Menu item indicators

**Performance**:
- **Lazy loading**: Icons loaded only when first requested
- **Caching**: Icons cached in utils module after first load
- **Conditional loading**: Only loads required icon pack

**Customization**:
- **Easy modification**: Add new icons to existing categories
- **Consistent naming**: Standard icon names across all components
- **Fallback-aware**: All icons have ASCII equivalents
