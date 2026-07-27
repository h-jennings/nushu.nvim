# nushu.nvim

A Neovim port of the **Nushu** theme — a reduced-contrast fork of GitHub's
default themes that keeps the familiar Primer syntax palette on warm,
comfortable backgrounds. Dark and light variants included.

## Requirements

- Neovim ≥ 0.9
- `termguicolors` (set automatically on load)

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "h-jennings/nushu.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("nushu").setup({
            -- your options here
        })
        vim.cmd([[colorscheme nushu]])
    end,
}
```

## Usage

```vim
" Follow 'background' (dark -> Nushu Dark, light -> Nushu Light)
colorscheme nushu

" Pin a specific variant regardless of 'background'
colorscheme nushu-dark
colorscheme nushu-light
```

With `colorscheme nushu`, changing `:set background=light` (e.g. via
auto-dark-mode.nvim) re-applies the matching variant automatically.

## Configuration

Defaults shown. `setup()` may be called before or after `:colorscheme`.

```lua
require("nushu").setup({
    bold = true,           -- gate all bold usage (titles, headings)
    italics = true,        -- gate all italic usage (markup emphasis, links, ghost text)
    undercurl = true,      -- undercurl for diagnostics/spell (underline when false)
    transparent = false,   -- no background color
    dimInactive = false,   -- dim non-current windows
    terminalColors = true, -- set vim.g.terminal_color_*
    commentStyle = {},     -- extra styles, e.g. { italic = true }
    functionStyle = {},
    keywordStyle = {},
    statementStyle = {},
    typeStyle = {},
    colors = { palette = {}, theme = { dark = {}, light = {}, all = {} } },
    overrides = function(colors) -- add/modify highlights
        return {}
    end,
    background = { dark = "dark", light = "light" }, -- 'background' -> variant map
    theme = "dark",        -- used when background mapping is disabled
})
```

Nushu itself uses no comment or keyword italics — the `italics` flag only
affects markup emphasis, links, and ghost text.

### Overriding colors

Two layers are overridable: the raw **palette** (named hex values) and the
per-variant semantic **theme** (`ui`, `syn`, `diag`, `diff`, `vcs`, `term`):

```lua
require("nushu").setup({
    colors = {
        palette = { darkBg = "#201c19" },
        theme = {
            dark = { ui = { float = { bg = "#2b2723" } } },
            all = { ui = { bg_gutter = "NONE" } },
        },
    },
})
```

### Overriding highlight groups

`overrides` receives the resolved colors for the active variant, so overrides
survive dark/light switches:

```lua
require("nushu").setup({
    overrides = function(colors)
        local theme = colors.theme
        return {
            NormalFloat = { bg = theme.ui.bg },
            ["@string"] = { fg = theme.syn.string, italic = true },
        }
    end,
})
```

## Lualine

A matching lualine theme ships with the plugin and is picked up by
`theme = "auto"`. Mode colors mirror the Nushu Zed theme's vim mode indicator
(normal blue, insert green, visual purple, replace orange, command pink). Set
`vim.g.nushu_lualine_bold = true` for bold mode sections.

## Attribution

- [wheredoesyourmindgo/nushu-vscode-theme](https://github.com/wheredoesyourmindgo/nushu-vscode-theme)
  — the original Nushu theme this port is derived from
- [GitHub Primer](https://primer.style/) — the syntax color palette
- [h-jennings/nushu-zed-theme](https://github.com/h-jennings/nushu-zed-theme)
  — the Zed port used as the color source of truth
- [kanso.nvim](https://github.com/webhooked/kanso.nvim) /
  [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) (MIT) — the
  architectural basis for this plugin's structure

## License

MIT — see [LICENSE](./LICENSE).
