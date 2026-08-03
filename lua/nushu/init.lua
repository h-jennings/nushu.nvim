local M = {}

---@alias ColorSpec string RGB Hex string
---@alias ColorTable table<string, ColorSpec>
---@alias NushuColorsSpec { palette: ColorTable, theme: ColorTable }
---@alias NushuColors { palette: PaletteColors, theme: ThemeColors }

--- default config
---@class NushuConfig
M.config = {
    bold = true,
    italics = true,
    undercurl = true,
    transparent = false,
    dimInactive = false,
    terminalColors = true,
    commentStyle = {},
    functionStyle = {},
    keywordStyle = {},
    statementStyle = {},
    typeStyle = {},
    colors = { theme = { dark = {}, light = {}, all = {} }, palette = {} },
    ---@type fun(colors: NushuColorsSpec): table<string, table>
    overrides = function()
        return {}
    end,
    ---@type { dark: string, light: string }
    background = { dark = "dark", light = "light" },
    theme = "dark",
}

-- Pristine snapshot of the defaults, so callers can restore them.
M._DEFAULT_CONFIG = vim.deepcopy(M.config)

--- Whether one of this colorscheme's entry points is currently active.
--- `g:colors_name` names the specific variant when one is pinned, so an equality
--- check against "nushu" alone would miss the pinned case.
---@return boolean
function M._is_active()
    local name = vim.g.colors_name
    return name == "nushu" or name == "nushu-dark" or name == "nushu-light"
end

--- update global configuration with user settings
---@param config? NushuConfig user configuration
function M.setup(config)
    -- Recorded rather than inferred by comparing against the default: "dark" is
    -- itself the default, so `theme = "dark"` and "left alone" are otherwise
    -- indistinguishable, and only the former should pin.
    if config and config.theme ~= nil then
        M._THEME_SET_BY_USER = true
    end

    M.config = vim.tbl_deep_extend("force", M.config, config or {})

    -- Reload colorscheme if already active so setup() can be called
    -- before or after :colorscheme
    if M._is_active() then
        M.load(M._EXPLICIT_THEME)
    end
end

--- load the colorscheme
---@param theme? string "dark"|"light"; nil follows 'background'
function M.load(theme)
    -- An explicitly requested variant (:colorscheme nushu-dark) pins the
    -- theme; plain :colorscheme nushu clears the pin and follows
    -- vim.o.background.
    if theme then
        M._EXPLICIT_THEME = theme
    else
        M._EXPLICIT_THEME = nil
    end

    -- Priority: explicit variant > theme set via setup() >
    -- background mapping > config.theme
    if M._EXPLICIT_THEME then
        theme = M._EXPLICIT_THEME
    elseif M._THEME_SET_BY_USER then
        theme = M.config.theme
    elseif M.config.background and M.config.background[vim.o.background] then
        theme = M.config.background[vim.o.background]
    else
        theme = M.config.theme
    end
    M._CURRENT_THEME = theme

    -- Ensure this module is resolvable before nested require() calls;
    -- prevents circular-require issues when loading within lazy.nvim
    package.loaded["nushu"] = M

    if vim.g.colors_name then
        vim.cmd("hi clear")
    end

    -- What makes pinning survive. Neovim re-sources `g:colors_name` whenever
    -- 'background' is set, so a pinned variant has to name its own entry point:
    -- left as "nushu", that re-source runs colors/nushu.vim, which calls load()
    -- with no argument, drops the pin and silently reverts to following
    -- 'background' — within a second, under auto-dark-mode.
    vim.g.colors_name = M._EXPLICIT_THEME and ("nushu-" .. theme) or "nushu"
    vim.g.nushu_variant = theme
    vim.o.termguicolors = true

    -- Re-apply when 'background' changes so :set background=light works
    if not M._autocmd_created then
        M._autocmd_created = true
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = function()
                if M._is_active() then
                    -- Drop cached theme modules and the lualine themes so all
                    -- rebuild against the new variant
                    package.loaded["nushu.colors"] = nil
                    package.loaded["nushu.themes"] = nil
                    package.loaded["lualine.themes.nushu"] = nil
                    package.loaded["lualine.themes.nushu-dark"] = nil
                    package.loaded["lualine.themes.nushu-light"] = nil
                    M.load(M._EXPLICIT_THEME)
                    -- :set background alone doesn't fire ColorScheme, but
                    -- statusline plugins listen for it to refresh
                    vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
                end
            end,
        })
    end

    local colors = require("nushu.colors").setup({ theme = theme, colors = M.config.colors })
    local highlights = require("nushu.highlights").setup(colors, M.config)
    require("nushu.highlights").highlight(highlights, M.config.terminalColors and colors.theme.term or {})
end

return M
