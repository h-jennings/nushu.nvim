--- Raw palette for both Nushu variants.
---
--- Every hex in this file traces back to the Nushu Zed theme
--- (h-jennings/nushu-zed-theme, themes/nushu-theme.json) or, where Zed has no
--- equivalent key, the original VS Code theme
--- (wheredoesyourmindgo/nushu-vscode-theme). Names describe the color's role
--- in the GitHub Primer-derived palette, not a specific highlight group.
---
---@class PaletteColors
local palette = {
    -- Dark: backgrounds (warm brown-black ramp)
    darkBg = "#25211d", -- editor background
    darkBgSurface = "#2b2723", -- panels, floats, pmenu, tab bar
    darkBgCursor = "#302b27", -- cursorline
    darkBgHighlight = "#3a3430", -- highlighted line (e.g. quickfix jump)
    darkBgHover = "#34302c", -- list hover / selected element
    darkBgActive = "#3f3b36", -- active element; doubles as the border color
    darkBorder = "#3f3b36",

    -- Dark: foregrounds
    darkFg = "#d7cfc7",
    darkFgMuted = "#7d8590", -- muted text, hints, blame
    darkFgFaint = "#7e746a", -- line numbers, placeholders, ghost text
    darkFgSubtle = "#554d45", -- whitespace / invisibles
    darkGrey = "#b1bac4", -- syntax: variables, punctuation
    darkGreyThumb = "#9b9188", -- scrollbar thumb base

    -- Dark: syntax families (GitHub Primer dark)
    darkPink = "#db61a2", -- keywords, preproc, string escapes
    darkPurple = "#bc8cff", -- functions
    darkPurpleBright = "#d2a8ff",
    darkYellow = "#e3b341", -- types, tags, constructors
    darkBlue = "#79c0ff", -- constants, numbers, properties, headings
    darkNavy = "#a5d6ff", -- strings, regex, links
    darkGreen = "#2ea043", -- comments
    darkAccent = "#1f6feb", -- focus borders, badges
    darkInfo = "#2f81f7", -- cursor, links, info diagnostics

    -- Dark: status / git / diagnostics
    darkRed = "#f85149",
    darkRedBright = "#ffa198",
    darkRedTerm = "#ff7b72",
    darkPinkError = "#f778ba", -- invalid / deprecated / message.error
    darkOrange = "#f0883e", -- active-tab accent, replace mode
    darkConflict = "#db6d28",
    darkYellowWarn = "#d29922", -- warnings, git modified
    darkGreenBright = "#3fb950", -- git added, ok, insert mode
    darkGreenTerm = "#56d364",
    darkAttn = "#bb8009", -- document highlights / bracket match base
    darkSearch = "#9e6a03", -- current search match (opaque)
    darkSearchAll = "#f2cc60", -- other search matches (blended)
    darkSelection = "#264f78", -- visual selection base (blended)
    darkDiffAddLine = "#238636", -- diff added-line base (blended)
    darkDiffDelLine = "#da3633", -- diff deleted-line base (blended)
    darkCyan = "#39c5cf",
    darkCyanBright = "#56d4dd",

    -- Dark: terminal-only slots
    darkTermBlack = "#484f58",
    darkTermBrightBlack = "#6e7681",
    darkTermBlue = "#58a6ff",
    darkTermWhite = "#b1bac4",
    darkTermBrightWhite = "#ffffff",

    -- Light: backgrounds (cream ramp)
    lightBg = "#f8f6f1",
    lightBgSurface = "#efede9",
    lightBgCursor = "#eae8e3",
    lightBgHighlight = "#ddd9d1",
    lightBgHover = "#e4e2dd",
    lightBgActive = "#d6d4cf",
    lightBorder = "#d6d4cf",

    -- Light: foregrounds
    lightFg = "#2b2822",
    lightFgMuted = "#656d76",
    lightFgFaint = "#989489", -- line numbers, disabled
    lightFgPlaceholder = "#7a766b", -- placeholders, ghost text, float border
    lightFgSubtle = "#bbb7ac", -- whitespace / invisibles
    lightGrey = "#57606a", -- syntax: variables, punctuation

    -- Light: syntax families (GitHub Primer light)
    lightPink = "#99286e",
    lightPurple = "#6639ba",
    lightPurpleBright = "#8250df",
    lightYellow = "#633c01",
    lightBlue = "#0550ae",
    lightNavy = "#0a3069",
    lightGreen = "#1a7f37",
    lightGreenDeep = "#116329",
    lightAccent = "#0969da",
    lightAccentBright = "#218bff",

    -- Light: status / git / diagnostics
    lightRed = "#cf222e",
    lightRedBright = "#a40e26",
    lightPinkError = "#611347",
    lightOrange = "#fb8f44",
    lightConflict = "#bc4c00",
    lightYellowWarn = "#9a6700",
    lightYellowGit = "#7d4e00",
    lightYellowGutter = "#d4a72c", -- gutter modified base (blended)
    lightAttn = "#bf8700", -- document highlights / current search match
    lightSearchAll = "#fae17d", -- other search matches (blended)
    lightSelection = "#0969da", -- visual selection base (blended)
    lightDiffAddLine = "#aceebb", -- diff added-line base (blended)
    lightDiffDelLine = "#ffcecb", -- diff deleted-line base (blended)
    lightDiffAddText = "#6fdd8b", -- diff added-word base (blended)
    lightDiffDelText = "#ff8182", -- diff deleted-word base (blended)
    lightCyan = "#1b7c83",
    lightCyanBright = "#3192aa",

    -- Light: terminal-only slots
    lightTermBlack = "#24292f",
    lightTermBrightBlack = "#57606a",
    lightTermYellow = "#4d2d00",
    lightTermWhite = "#6e7781",
    lightTermBrightWhite = "#8c959f",
}

local M = {}

--- Resolve the merged palette and semantic theme colors.
--- Merge order: built-in palette < config.colors.palette, then
--- theme colors < config.colors.theme.all < config.colors.theme[variant].
---@param opts? { theme?: string, colors?: { palette?: table, theme?: table } }
---@return NushuColors
function M.setup(opts)
    opts = opts or {}
    local nushu = require("nushu")
    local override_colors = opts.colors or nushu.config.colors
    local theme = opts.theme or nushu._CURRENT_THEME

    if not theme then
        theme = nushu.config.background[vim.o.background] or nushu.config.theme or "dark"
        nushu._CURRENT_THEME = theme
    end

    local updated_palette_colors = vim.tbl_extend("force", palette, override_colors.palette or {})

    ---@type ThemeColors
    local theme_colors = require("nushu.themes")[theme](updated_palette_colors)

    local theme_overrides =
        vim.tbl_deep_extend("force", override_colors.theme["all"] or {}, override_colors.theme[theme] or {})

    return {
        theme = vim.tbl_deep_extend("force", theme_colors, theme_overrides),
        palette = updated_palette_colors,
    }
end

return M
