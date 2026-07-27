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

-- Snapshot of the defaults, used to tell "user explicitly set this"
-- apart from "still default" during theme resolution.
M._DEFAULT_CONFIG = vim.deepcopy(M.config)

--- update global configuration with user settings
---@param config? NushuConfig user configuration
function M.setup(config)
    M.config = vim.tbl_deep_extend("force", M.config, config or {})

    -- Reload colorscheme if already active so setup() can be called
    -- before or after :colorscheme
    if vim.g.colors_name == "nushu" then
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

    -- Priority: explicit variant > user-changed config.theme >
    -- background mapping > config.theme
    if M._EXPLICIT_THEME then
        theme = M._EXPLICIT_THEME
    elseif M.config.theme ~= M._DEFAULT_CONFIG.theme then
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

    vim.g.colors_name = "nushu"
    vim.g.nushu_variant = theme
    vim.o.termguicolors = true

    -- Re-apply when 'background' changes so :set background=light works
    if not M._autocmd_created then
        M._autocmd_created = true
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "background",
            callback = function()
                if vim.g.colors_name == "nushu" then
                    -- Drop cached theme modules and the lualine theme so both
                    -- rebuild against the new variant
                    package.loaded["nushu.colors"] = nil
                    package.loaded["nushu.themes"] = nil
                    package.loaded["lualine.themes.nushu"] = nil
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
