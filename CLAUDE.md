# CLAUDE.md

<!--toc:start-->
- [CLAUDE.md](#claudemd)
  - [Project Overview](#project-overview)
  - [Core Architecture](#core-architecture)
    - [Entry Point & Loading System](#entry-point-loading-system)
    - [Directory Structure](#directory-structure)
    - [Plugin Loading Strategy](#plugin-loading-strategy)
  - [Development Commands](#development-commands)
    - [Health & Diagnostics](#health-diagnostics)
    - [Plugin Management](#plugin-management)
    - [LSP & Development Tools](#lsp-development-tools)
    - [File Management & Navigation](#file-management-navigation)
  - [Key Configuration Files](#key-configuration-files)
    - [Core Options (`lua/base/1-options.lua`)](#core-options-luabase1-optionslua)
    - [Plugin Configuration Patterns](#plugin-configuration-patterns)
    - [LSP Configuration (`lua/base/utils/lsp.lua`)](#lsp-configuration-luabaseutilslsplua)
  - [Key Mappings (Leader = Space)](#key-mappings-leader-space)
    - [Essential Shortcuts](#essential-shortcuts)
    - [Plugin-specific](#plugin-specific)
    - [LSP Mappings (Auto-applied)](#lsp-mappings-auto-applied)
  - [Configuration Customization](#configuration-customization)
    - [Recommended Approach](#recommended-approach)
    - [Common Customizations](#common-customizations)
    - [Hot Reload System](#hot-reload-system)
  - [Dependencies & Requirements](#dependencies-requirements)
    - [Essential (Error if missing)](#essential-error-if-missing)
    - [Optional (Warnings)](#optional-warnings)
    - [System Requirements](#system-requirements)
  - [Update & Maintenance Workflow](#update-maintenance-workflow)
    - [Update Channels](#update-channels)
    - [Safe Update Process](#safe-update-process)
  - [Common Issues & Solutions](#common-issues-solutions)
    - [Performance Issues](#performance-issues)
    - [Plugin Conflicts](#plugin-conflicts)
    - [LSP Issues](#lsp-issues)
<!--toc:end-->

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a NormalNvim configuration - a batteries-included Neovim distribution built for stability and productivity. NormalNvim is designed as a foundation for users to fork and customize rather than frequently update from upstream.

## Core Architecture

### Entry Point & Loading System
- `init.lua`: Main entry point with error-safe loading functions
- **Loading Order**: `base.1-options` → `base.2-lazy` → `base.3-autocmds` → colorscheme → `base.4-mappings` (async)
- **Critical**: Never change the execution order of the first three base modules

### Directory Structure
```
lua/
├── base/                    # Core configuration (don't break loading order)
│   ├── 1-options.lua       # Neovim options & global variables
│   ├── 2-lazy.lua          # Plugin manager setup & auto-installation
│   ├── 3-autocmds.lua      # Auto commands (order-critical)
│   ├── 4-mappings.lua      # All keybindings & LSP mappings
│   ├── health.lua          # Health check system (:checkhealth base)
│   ├── icons/              # Icon definitions (nerd fonts)
│   └── utils/              # Utility functions
│       ├── init.lua        # Core utilities
│       ├── lsp.lua         # LSP configuration helpers
│       └── ui.lua          # UI toggle functions
├── plugins/                # Plugin configurations (lazy-loaded)
│   ├── 1-base-behaviors.lua # Core behaviors & workflow plugins
│   ├── 2-ui.lua            # UI, themes, and visual enhancements
│   ├── 3-dev-core.lua      # LSP, treesitter, completion, mason
│   └── 4-dev.lua           # Language-specific & advanced dev tools
└── lazy_snapshot.lua       # Plugin version lockfile (auto-generated)
```

### Plugin Loading Strategy
- **Lazy Loading**: All plugins use event-based loading for performance
- **Mason Integration**: Auto-installs LSP servers, formatters, linters
- **Channel System**: "stable" (default) vs "nightly" update channels
- **Version Locking**: `:DistroFreezePluginVersions` creates snapshot

## Development Commands

### Health & Diagnostics
```bash
# Check system dependencies and NormalNvim health
:checkhealth base

# Check plugin health
:checkhealth lazy
```

### Plugin Management
```bash
# Update checking & management
:Lazy                        # Open plugin manager
:DistroUpdate               # Update NormalNvim distribution
:DistroFreezePluginVersions # Lock current plugin versions
:DistroUpdateRevert         # Rollback last distro update

# Mason (LSP/tools management)
:Mason                      # Open Mason interface
:MasonUpdateAll             # Update all Mason packages
```

### LSP & Development Tools
```bash
# LSP information & management
:LspInfo                    # Show LSP client info
:LspRestart                 # Restart LSP clients
:NullLsInfo                 # Show none-ls (null-ls) info

# Formatting
:Format                     # Format current buffer with LSP

# Treesitter
:TSInstall all              # Install all parsers
:TSUpdate                   # Update parsers
```

### File Management & Navigation
```bash
# File browsers (prefer yazi if available)
:Yazi                       # Open yazi file browser
:Neotree toggle             # Toggle neo-tree sidebar

# Project search & replace
:Spectre                    # Global search & replace interface
```

## Key Configuration Files

### Core Options (`lua/base/1-options.lua`)
- **Theme**: `vim.g.default_colorscheme = "astrodark"`
- **Global Toggles**: All UI features have `vim.g.*_enabled` flags
- **Performance**: `vim.g.big_file` settings for large file handling
- **Auto Features**: autoformat, autopairs, diagnostics, etc.

### Plugin Configuration Patterns
- **Self-contained**: Each plugin config is independent
- **Conditional Loading**: Uses `is_available()` utility for optional features
- **Event-based**: Plugins load on specific events (`User BaseFile`, `User BaseDefered`)
- **Android Support**: Special handling for Termux environment

### LSP Configuration (`lua/base/utils/lsp.lua`)
- **Auto-setup**: Mason-managed servers auto-configured via `utils_lsp.setup()`
- **Schema Integration**: Uses SchemaStore.nvim for JSON schemas
- **None-ls Integration**: Formatting/linting via external tools
- **Custom Mappings**: Applied through `apply_user_lsp_mappings()`

## Key Mappings (Leader = Space)

### Essential Shortcuts
- `<leader>w` - Save file
- `<leader>q` - Quit with confirmation
- `<leader>c` - Close buffer (smart)
- `<Tab>/<S-Tab>` - Next/previous buffer
- `<F7>` - Toggle terminal
- `<ESC>` - Clear search highlighting + normal ESC function

### Plugin-specific
- `<leader>e` - Toggle Neotree
- `<leader>r` - Open file browser (yazi)
- `<leader>f*` - Telescope find commands
- `<leader>g*` - Git operations (gitsigns, fugitive)
- `<leader>u*` - UI toggles
- `<leader>l*` - LSP operations
- `<leader>d*` - Debugger (DAP)
- `<leader>T*` - Testing (neotest)

### LSP Mappings (Auto-applied)
- `gd` - Go to definition
- `gr` - Go to references
- `gh` - Hover documentation
- `<leader>la` - Code actions
- `<leader>lr` - Rename symbol
- `<leader>lf` - Format buffer

## Configuration Customization

### Recommended Approach
1. **Fork First**: Fork NormalNvim repository before cloning
2. **Modify Incrementally**: Change small pieces at a time
3. **Test Health**: Run `:checkhealth base` after changes
4. **Version Lock**: Use `:DistroFreezePluginVersions` for stability

### Common Customizations
- **Theme**: Change `vim.g.default_colorscheme` in `lua/base/1-options.lua`
- **Add Plugins**: Create new files in `lua/plugins/` directory
- **Disable Features**: Set `vim.g.*_enabled = false` flags
- **Custom Mappings**: Add to `lua/base/4-mappings.lua`

### Hot Reload System
- Changes to `1-options.lua` and `4-mappings.lua` auto-reload via hot-reload.nvim
- Colorscheme changes apply immediately
- Other configuration changes may require restart

## Dependencies & Requirements

### Essential (Error if missing)
- `git`, `luarocks`, `node`, `yarn`, `cargo` - Core toolchain
- `yazi` - File browser
- `fd` - File finder for spectre

### Optional (Warnings)
- `lazygit`/`gitui` - Git TUI
- Language-specific tools (see `:checkhealth base` for full list)
- `markmap` - Mind mapping for markdown

### System Requirements
- **Neovim**: ≥0.11 required
- **Nerd Font**: Required for icons (fallback available via `vim.g.fallback_icons_enabled`)
- **Terminal**: True color support recommended

## Update & Maintenance Workflow

### Update Channels
- **Stable** (default): Tested, stable versions
- **Nightly**: Latest features, potentially unstable
- Configure via `updates_config.channel` in `lua/base/2-lazy.lua`

### Safe Update Process
1. Check current health: `:checkhealth base`
2. Freeze current state: `:DistroFreezePluginVersions`
3. Update: `:DistroUpdate`
4. Test functionality
5. If issues: `:DistroUpdateRevert`

## Common Issues & Solutions

### Performance Issues
- Large files automatically disable treesitter (see `vim.g.big_file`)
- Android-specific optimizations included
- Plugin lazy-loading configured for fast startup

### Plugin Conflicts
- Use `:Lazy` to check plugin status
- Check LSP conflicts with `:LspInfo`
- Disable problematic features via global flags

### LSP Issues
- Check Mason installations: `:Mason`
- Restart LSP: `:LspRestart`
- Verify none-ls setup: `:NullLsInfo`

This configuration prioritizes stability and productivity over flashy features. All changes should maintain the philosophy of "bread and butter" reliability.
