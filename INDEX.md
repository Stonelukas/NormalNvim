# NormalNvim Documentation Index

<!--toc:start-->
- [NormalNvim Documentation Index](#normalnvim-documentation-index)
  - [🚀 Quick Start](#-quick-start)
  - [📁 Project Structure](#-project-structure)
    - [Core Architecture](#core-architecture)
    - [Plugin Organization](#plugin-organization)
  - [📚 Configuration Reference](#-configuration-reference)
    - [Core Configuration Files](#core-configuration-files)
    - [Plugin Configuration Files](#plugin-configuration-files)
    - [Utility & Helper Files](#utility-helper-files)
  - [⌨️ Keybindings Reference](#️-keybindings-reference)
    - [Essential Operations](#essential-operations)
    - [Plugin-specific Mappings](#plugin-specific-mappings)
    - [LSP Operations](#lsp-operations)
  - [🔧 Commands & Tools](#-commands-tools)
    - [Distribution Management](#distribution-management)
    - [Plugin Management](#plugin-management)
    - [Development Tools](#development-tools)
    - [Health & Diagnostics](#health-diagnostics)
  - [🎨 Customization Guide](#-customization-guide)
    - [Theme Configuration](#theme-configuration)
    - [Feature Toggles](#feature-toggles)
    - [Adding New Plugins](#adding-new-plugins)
  - [🛠️ Development & Maintenance](#️-development-maintenance)
    - [Dependencies](#dependencies)
    - [Update Process](#update-process)
    - [Troubleshooting](#troubleshooting)
  - [📖 Additional Resources](#-additional-resources)
<!--toc:end-->

## 🚀 Quick Start

**Requirements**: Neovim 0.11+ | [Installation Guide](README.md#how-to-install)

**First Steps**:
1. Fork the repository before cloning (recommended)
2. Clone to your Neovim config directory
3. Launch Neovim and let plugins auto-install
4. Run `:checkhealth base` to verify setup

**Leader Key**: `<Space>` | **Essential Commands**: `<Space>` to see all mappings

## 📁 Project Structure

### Core Architecture

```
~/.config/nvim/
├── init.lua                 # Entry point with safe loading system
├── CLAUDE.md               # Claude Code assistant documentation
├── README.md               # Main project documentation
└── lua/
    ├── base/               # Core configuration (load order critical)
    │   ├── 1-options.lua   # Neovim options & global variables
    │   ├── 2-lazy.lua      # Plugin manager setup
    │   ├── 3-autocmds.lua  # Auto commands (order-critical)
    │   ├── 4-mappings.lua  # All keybindings
    │   ├── health.lua      # Health check system
    │   ├── icons/          # Icon definitions
    │   └── utils/          # Utility functions
    ├── plugins/            # Plugin configurations
    └── lazy_snapshot.lua   # Plugin version lockfile
```

### Plugin Organization

- **`1-base-behaviors.lua`**: Core behaviors & workflow plugins
- **`2-ui.lua`**: UI, themes, and visual enhancements  
- **`3-dev-core.lua`**: LSP, treesitter, completion, mason
- **`4-dev.lua`**: Language-specific & advanced dev tools

## 📚 Configuration Reference

### Core Configuration Files

| File | Purpose | Key Features |
|------|---------|--------------|
| **`init.lua`** | Entry point | Safe loading, error handling, async loading |
| **`base/1-options.lua`** | Neovim settings | Theme selection, editor options, global variables |
| **`base/2-lazy.lua`** | Plugin manager | Auto-installation, update channels, performance |
| **`base/3-autocmds.lua`** | Auto commands | File type detection, UI behaviors |
| **`base/4-mappings.lua`** | Keybindings | All shortcuts, plugin mappings, LSP bindings |

### Plugin Configuration Files

| Category | File | Contents |
|----------|------|----------|
| **Core Behaviors** | `plugins/1-base-behaviors.lua` | Session management, terminal, file operations |
| **UI/Themes** | `plugins/2-ui.lua` | Status line, themes, notifications, animations |
| **Development Core** | `plugins/3-dev-core.lua` | LSP, completion, treesitter, mason, debugging |
| **Development Tools** | `plugins/4-dev.lua` | Testing, documentation, language-specific tools |

### Utility & Helper Files

| File | Purpose |
|------|---------|
| **`base/utils/init.lua`** | Core utilities, plugin availability checks |
| **`base/utils/lsp.lua`** | LSP configuration helpers and mappings |
| **`base/utils/ui.lua`** | UI toggle functions |
| **`base/health.lua`** | Health check system (`:checkhealth base`) |
| **`base/icons/`** | Icon definitions for nerd fonts and fallbacks |

## ⌨️ Keybindings Reference

### Essential Operations

| Key | Action | Category |
|-----|--------|----------|
| **`<Space>`** | Leader key - shows all available mappings | Core |
| **`<Space>w`** | Save file | File Operations |
| **`<Space>q`** | Quit with confirmation | File Operations |
| **`<Space>c`** | Close buffer (smart) | Buffer Management |
| **`<Tab>/<S-Tab>`** | Next/previous buffer | Buffer Navigation |
| **`<F7>`** | Toggle terminal | Terminal |
| **`<ESC>`** | Clear search + normal ESC | Search |

### Plugin-specific Mappings

| Prefix | Category | Example Commands |
|--------|----------|------------------|
| **`<Space>e`** | File Explorer | Toggle Neotree |
| **`<Space>r`** | File Browser | Open yazi |
| **`<Space>f*`** | Telescope Find | Find files, grep, buffers |
| **`<Space>g*`** | Git Operations | Status, commits, blame |
| **`<Space>u*`** | UI Toggles | Line numbers, diagnostics |
| **`<Space>l*`** | LSP Operations | Definitions, references, actions |
| **`<Space>d*`** | Debugger (DAP) | Breakpoints, step, continue |
| **`<Space>T*`** | Testing | Run tests, test file |

### LSP Operations

| Key | Action |
|-----|--------|
| **`gd`** | Go to definition |
| **`gr`** | Go to references |
| **`gh`** | Hover documentation |
| **`<Space>la`** | Code actions |
| **`<Space>lr`** | Rename symbol |
| **`<Space>lf`** | Format buffer |

## 🔧 Commands & Tools

### Distribution Management

| Command | Description |
|---------|-------------|
| **`:DistroUpdate`** | Update distro from git origin |
| **`:DistroUpdateRevert`** | Revert last distro update |
| **`:DistroFreezePluginVersions`** | Save current plugin versions |

### Plugin Management

| Command | Description |
|---------|-------------|
| **`:Lazy`** | Open plugin manager |
| **`:Mason`** | Manage LSP servers/tools |
| **`:MasonUpdateAll`** | Update all Mason packages |

### Development Tools

| Command | Description |
|---------|-------------|
| **`:LspInfo`** | Show LSP client info |
| **`:LspRestart`** | Restart LSP clients |
| **`:Format`** | Format current buffer |
| **`:TSInstall all`** | Install all treesitter parsers |

### Health & Diagnostics

| Command | Description |
|---------|-------------|
| **`:checkhealth base`** | Check NormalNvim health |
| **`:checkhealth lazy`** | Check plugin health |

## 🎨 Customization Guide

### Theme Configuration

**Location**: `lua/base/1-options.lua`
```lua
vim.g.default_colorscheme = "astrodark"  -- Change theme here
```

**Available Themes**: Use `<Space>ft` to preview installed themes

### Feature Toggles

**Global Toggles** (in `1-options.lua`):
- `vim.g.autopairs_enabled` - Auto-close brackets/quotes
- `vim.g.cmp_enabled` - Completion engine
- `vim.g.diagnostics_mode` - LSP diagnostics (0=off, 1=signs, 2=virtual text, 3=both)
- `vim.g.inlay_hints_enabled` - LSP inlay hints
- `vim.g.lsp_document_highlight` - Highlight references under cursor

### Adding New Plugins

1. Create or edit files in `lua/plugins/`
2. Follow lazy.nvim specification
3. Use `is_available()` utility for optional dependencies
4. Test with `:checkhealth base`

## 🛠️ Development & Maintenance

### Dependencies

**Essential**: git, luarocks, node, yarn, cargo, yazi, fd
**Optional**: lazygit, gitui, markmap

**Check Status**: `:checkhealth base`

### Update Process

1. **Check Health**: `:checkhealth base`
2. **Freeze State**: `:DistroFreezePluginVersions` 
3. **Update**: `:DistroUpdate`
4. **Test & Revert if needed**: `:DistroUpdateRevert`

### Troubleshooting

**Performance Issues**:
- Large files automatically disable treesitter
- Android optimizations included
- Plugin lazy-loading configured

**Common Issues**:
- **Icons missing**: Install nerd font or enable `vim.g.fallback_icons_enabled`
- **LSP not working**: Check `:Mason` and `:LspInfo`
- **Plugin conflicts**: Use `:Lazy` to check status

## 📖 Additional Resources

- **[NormalNvim Wiki](https://github.com/NormalNvim/NormalNvim/wiki)** - Comprehensive guides
- **[Installation Guide](README.md#how-to-install)** - Setup instructions  
- **[Dependencies Guide](https://github.com/NormalNvim/NormalNvim/wiki/dependencies)** - Required tools
- **[Plugin List](https://github.com/NormalNvim/NormalNvim/wiki/plugins)** - All included plugins
- **[Basic Mappings](https://github.com/NormalNvim/NormalNvim/wiki/basic-mappings)** - Keybinding reference

---

**Philosophy**: NormalNvim is designed as a stable, batteries-included foundation that you fork and customize rather than frequently update. It prioritizes reliability over flashy features - just bread and butter productivity.