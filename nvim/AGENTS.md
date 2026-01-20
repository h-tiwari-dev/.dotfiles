# AGENTS.md

This file contains guidelines and commands for agentic coding agents working in this Neovim configuration repository.

## Repository Overview

This is a LazyVim-based Neovim configuration repository. The structure follows LazyVim conventions with:
- `init.lua` - Entry point that bootstraps lazy.nvim
- `lua/config/` - Core configuration files (lazy.lua, options.lua, keymaps.lua, autocmds.lua)
- `lua/plugins/` - Plugin specifications and customizations
- `stylua.toml` - Lua formatting configuration

## Build/Lint/Test Commands

### Formatting
```bash
# Format all Lua files
stylua .

# Format specific file
stylua path/to/file.lua

# Check formatting without making changes
stylua --check .
```

### Configuration Validation
```bash
# Test Neovim configuration (run from within Neovim)
:checkhealth

# Validate lazy.nvim plugin setup
:Lazy check

# Update plugins
:Lazy update
```

### Plugin Management
```bash
# Install missing plugins
:Lazy install

# Clean unused plugins
:Lazy clean

# Sync plugins (install + clean + update)
:Lazy sync
```

## Code Style Guidelines

### Lua Formatting (stylua.toml)
- **Indentation**: 2 spaces
- **Column width**: 120 characters
- **Indent type**: Spaces

### Import Conventions
```lua
-- Standard library imports first
local vim = vim
local lazy = require("lazy")

-- Then local module imports
local util = require("lazyvim.util")

-- Plugin imports in spec tables
{ "neovim/nvim-lspconfig" }
```

### Plugin Specification Patterns
```lua
-- Basic plugin addition
return {
  "username/plugin-name",
}

-- Plugin with configuration
return {
  "username/plugin-name",
  opts = {
    -- configuration options
  },
}

-- Plugin with dependencies
return {
  "username/plugin-name",
  dependencies = { "dependency/plugin" },
}

-- Override existing LazyVim plugin
{
  "LazyVim/LazyVim",
  opts = {
    -- override options
  },
}
```

### File Organization
- `lua/config/` - Core Neovim configuration (options, keymaps, autocmds)
- `lua/plugins/` - Plugin specifications, one file per logical group
- Plugin files should return a table of plugin specs
- Use descriptive filenames: `python.lua`, `lsp.lua`, `ui.lua`

### Naming Conventions
- **Files**: lowercase with underscores (`python.lua`, `keymaps.lua`)
- **Variables**: snake_case for global/local, camelCase for plugin opts
- **Functions**: snake_case for utility functions, descriptive names
- **Keymaps**: Use `<leader>` prefix for custom mappings, follow LazyVim conventions

### Error Handling
```lua
-- Use pcall for potentially failing operations
local ok, result = pcall(function()
  return some_function()
end)

if not ok then
  vim.notify("Error: " .. result, vim.log.levels.ERROR)
end

-- Validate plugin options
opts = opts or {}
local config = vim.tbl_deep_extend("force", default_config, opts)
```

### Type Annotations
```lua
-- Use LuaLS type annotations for complex configurations
---@class PluginLspOpts
---@type lspconfig.options
opts = {
  servers = {
    pyright = {},
  },
}

-- Function type annotations
---@param opts table
---@return table
local function setup_plugin(opts)
  -- implementation
end
```

### Configuration Patterns
```lua
-- Options function for dynamic configuration
opts = function(_, opts)
  -- Modify default opts
  opts.some_option = true
  return opts
end

-- Setup function for complex initialization
setup = function(server, opts)
  require("language_server").setup(opts)
  return true
end
```

### Keymap Guidelines
```lua
-- Use desc for all keymaps
vim.keymap.set("n", "<leader>lf", function()
  -- implementation
end, { desc = "Format file" })

-- Buffer-local keymaps for LSP
vim.api.nvim_buf_create_user_command(0, "Format", function()
  vim.lsp.buf.format()
end, { desc = "Format current buffer" })
```

### Autocmd Patterns
```lua
-- Use VeryLazy event for most autocmds
vim.api.nvim_create_autocmd("VeryLazy", {
  callback = function()
    -- setup code
  end,
})

-- Filetype-specific autocmds
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    -- python-specific setup
  end,
})
```

## Plugin Development Guidelines

### Plugin Specs
- Each plugin file should return a table of plugin specifications
- Use `import = "lazyvim.plugins.extras.lang.*"` for language extras
- Disable LazyVim plugins with `{ "plugin/name", enabled = false }`
- Override plugin options using the `opts` function

### Mason Tools
- Add language servers, formatters, and linters to Mason ensure_installed
- Example tools: `stylua`, `pyright`, `eslint`, `prettier`
- Configure LSP settings in plugin specs, not in separate config files

### Opencode Plugin

#### Prerequisites
- Install the opencode CLI tool (required for the plugin to function)
- The opencode CLI must be running before starting Neovim
- Log location: `~/.local/share/opencode/log/`

#### Plugin Configuration
```lua
return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        provider = {
          enabled = "terminal",
          terminal = {
            auto_start = true,
          },
        },
        events = {
          reload = true,
        },
      }
      vim.o.autoread = true
    end,
  },
}
```

#### Keymaps
- `<leader>oa` - Ask opencode (with range support)
- `<leader>ox` - Execute opencode action
- `<leader>ot` - Toggle opencode
- `<leader>ou` - Session half page up
- `<leader>od` - Session half page down
- `go` - Operator mapping for range-based operations
- `goo` - Operator mapping for line-based operations

#### Lualine Integration
```lua
-- In lualine config section
sections = {
  lualine_c = {
    { "opencode", icon = "" },
  },
}
```

#### Troubleshooting
- Check if opencode CLI is running: `ps aux | grep opencode`
- View logs: `cat ~/.local/share/opencode/log/*.log`
- Verify connection: `:lua print(vim.g.opencode_port)`
- Restart opencode: `:OpencodeRestart`

### LSP Configuration
- Use lspconfig plugin specs for server configuration
- Disable type checking for performance when needed (see python.lua)
- Use `setup` function for complex server initialization

## Testing and Validation

### Configuration Testing
1. Start Neovim with `nvim --noplugin` to test basic setup
2. Use `:checkhealth` to verify system and plugin health
3. Test keymaps with `:verbose map <leader>`
4. Validate LSP setup with `:LspInfo`

### Plugin Testing
1. Use `:Lazy` to view plugin status and logs
2. Test individual plugins with `:Lazy load plugin-name`
3. Check for conflicts with `:Lazy profile`

## Common Issues and Solutions

### Plugin Conflicts
- Use `enabled = false` to disable conflicting plugins
- Check `:Lazy` for dependency issues
- Verify plugin load order in lazy.nvim setup

### Performance
- Use lazy loading for heavy plugins (`event = "VeryLazy"`)
- Disable unused features in plugin options
- Monitor startup time with `:Lazy profile`

### LSP Issues
- Verify Mason tools are installed
- Check LSP logs with `:LspLog`
- Use `:LspRestart` to restart language servers