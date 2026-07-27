local blend = require("nushu.lib.color").blend

---@class SyntaxElements
--- Color mapping follows the VS Code original's TextMate rules (the Zed port
--- flattened several distinctions): variables/properties/punctuation are plain
--- fg (`variable.other`, `meta.object.member`), types are blue (`entity`,
--- `support`), operators are keyword pink (`keyword.operator`), and yellow is
--- reserved for tags/components/JSON keys (`entity.name.tag`,
--- `support.class.component`, `support.type.property-name.json`).
---@field string ColorSpec strings, regex, inline code
---@field variable ColorSpec plain variables (fg — VS Code `variable.other`)
---@field parameter ColorSpec function parameters (fg — `variable.parameter.function`)
---@field number ColorSpec numbers, booleans
---@field constant ColorSpec constants, enum members, const-declared variables
---@field property ColorSpec object keys, member access (fg — `meta.object.member`)
---@field subtle ColorSpec grey: bare `variable`/`entity.name`, markdown list markers
---@field fun ColorSpec functions and methods
---@field statement ColorSpec statements
---@field keyword ColorSpec keywords
---@field operator ColorSpec operators (keyword pink — `keyword.operator`)
---@field preproc ColorSpec preprocessor, imports
---@field type ColorSpec type references (blue — `entity`/`support`)
---@field tag ColorSpec HTML/JSX tags, components, JSON keys (yellow)
---@field regex ColorSpec regular expressions
---@field heading ColorSpec markdown headings, titles
---@field deprecated ColorSpec invalid/deprecated code
---@field comment ColorSpec comments
---@field punct ColorSpec punctuation, delimiters, brackets (fg — unstyled in VS Code)
---@field special1 ColorSpec string escapes, interpolation braces (keyword pink)
---@field special2 ColorSpec regex escapes, picker match highlight (yellow)
---@field special3 ColorSpec invalid / message.error (error pink)

---@class DiagnosticsElements
---@field error ColorSpec
---@field ok ColorSpec
---@field warning ColorSpec
---@field info ColorSpec
---@field hint ColorSpec

---@class DiffElements pre-blended opaque backgrounds
---@field add ColorSpec added-line background
---@field delete ColorSpec deleted-line background
---@field change ColorSpec changed-line background
---@field text ColorSpec added-word background (inline diff)
---@field text_delete ColorSpec deleted-word background (inline diff)

---@class VCSElements sign/foreground colors
---@field added ColorSpec
---@field removed ColorSpec
---@field changed ColorSpec
---@field untracked ColorSpec
---@field ignored ColorSpec
---@field conflict ColorSpec

---@class FloatElements
---@field fg ColorSpec
---@field bg ColorSpec surface background, one step off the editor bg for contrast
---@field fg_border ColorSpec visible border foreground
---@field bg_border ColorSpec

---@class MenuElements
---@field bg ColorSpec
---@field bg_sel ColorSpec
---@field bg_sbar ColorSpec
---@field bg_thumb ColorSpec
---@field fg ColorSpec
---@field fg_sel ColorSpec "NONE" so fuzzy-match colors pass through

---@class UiElements
---@field fg ColorSpec Normal foreground
---@field fg_dim ColorSpec muted text (StatusLine, hints, blame)
---@field fg_reverse ColorSpec fg for text on colored backgrounds
---@field bg ColorSpec Normal background
---@field bg_dim ColorSpec surface bg (inactive statusline, panels)
---@field bg_p1 ColorSpec lighter bg (ColorColumn, Folded, TreesitterContext)
---@field bg_p2 ColorSpec lighter bg (PmenuSel, TabLineSel, hover)
---@field bg_gutter ColorSpec Sign/FoldColumn, LineNr ("NONE": gutter matches editor)
---@field bg_cursorline ColorSpec CursorLine
---@field bg_highlight ColorSpec highlighted line (quickfix jump target)
---@field special ColorSpec orange accent (active-tab marker, replace mode)
---@field accent ColorSpec blue accent (focus borders, badges, prompts)
---@field nontext ColorSpec LineNr, NonText, showbreak
---@field whitespace ColorSpec listchars invisibles
---@field border ColorSpec WinSeparator and other hard borders
---@field indent_line ColorSpec indent guides (pre-blended)
---@field active_indent_line ColorSpec active indent scope (pre-blended)
---@field bg_visual ColorSpec Visual selection (pre-blended)
---@field bg_search ColorSpec other search matches (pre-blended wash, fg survives)
---@field bg_cursearch ColorSpec current search match (opaque amber)
---@field word_read ColorSpec LspReference read background (pre-blended)
---@field word_write ColorSpec LspReference write / MatchParen background (pre-blended)
---@field cursor_bg ColorSpec
---@field cursor_fg ColorSpec
---@field cursor_line_nr_foreground ColorSpec
---@field cursor_line_nr_active_foreground ColorSpec
---@field scrollbar_thumb ColorSpec pre-blended thumb / inlay-hint background
---@field pmenu MenuElements
---@field float FloatElements
---@field none "NONE"

---@class ThemeColors
---@field ui UiElements
---@field syn SyntaxElements
---@field diag DiagnosticsElements
---@field vcs VCSElements
---@field diff DiffElements
---@field term ColorSpec[] 16 ANSI colors + 2 extended (indexed 16, 17)

return {
    ---@param p PaletteColors
    ---@return ThemeColors
    dark = function(p)
        return {
            ui = {
                none = "NONE",
                fg = p.darkFg,
                fg_dim = p.darkFgMuted,
                fg_reverse = p.darkBg,
                bg = p.darkBg,
                bg_dim = p.darkBgSurface,
                bg_p1 = p.darkBgSurface,
                bg_p2 = p.darkBgHover,
                bg_gutter = "NONE",
                bg_cursorline = p.darkBgCursor,
                bg_highlight = p.darkBgHighlight,
                special = p.darkOrange,
                accent = p.darkAccent,
                nontext = p.darkFgFaint,
                whitespace = p.darkFgSubtle,
                border = p.darkBorder,
                indent_line = blend(p.darkFg, p.darkBg, 0.12),
                active_indent_line = blend(p.darkFg, p.darkBg, 0.24),
                bg_visual = blend(p.darkSelection, p.darkBg, 0.40),
                bg_search = blend(p.darkSearchAll, p.darkBg, 0.50),
                bg_cursearch = p.darkSearch,
                word_read = blend(p.darkAttn, p.darkBg, 0.15),
                word_write = blend(p.darkAttn, p.darkBg, 0.25),
                cursor_bg = p.darkInfo,
                cursor_fg = p.darkBg,
                cursor_line_nr_foreground = p.darkFgFaint,
                cursor_line_nr_active_foreground = p.darkFg,
                scrollbar_thumb = blend(p.darkGreyThumb, p.darkBgSurface, 0.20),
                pmenu = {
                    fg = p.darkFg,
                    fg_sel = "NONE",
                    bg = p.darkBgSurface,
                    bg_sel = p.darkBgHover,
                    bg_sbar = p.darkBgSurface,
                    bg_thumb = blend(p.darkGreyThumb, p.darkBgSurface, 0.20),
                },
                float = {
                    fg = p.darkFg,
                    bg = p.darkBgSurface,
                    fg_border = p.darkFgFaint,
                    bg_border = p.darkBgSurface,
                },
            },
            syn = {
                string = p.darkNavy,
                variable = p.darkFg,
                parameter = p.darkFg,
                number = p.darkBlue,
                constant = p.darkBlue,
                property = p.darkFg,
                subtle = p.darkGrey,
                fun = p.darkPurple,
                statement = p.darkPink,
                keyword = p.darkPink,
                operator = p.darkPink,
                preproc = p.darkPink,
                type = p.darkBlue,
                tag = p.darkYellow,
                regex = p.darkNavy,
                heading = p.darkBlue,
                deprecated = p.darkPinkError,
                comment = p.darkGreen,
                punct = p.darkFg,
                special1 = p.darkPink,
                special2 = p.darkYellow,
                special3 = p.darkPinkError,
            },
            diag = {
                error = p.darkRed,
                warning = p.darkYellowWarn,
                info = p.darkInfo,
                hint = p.darkFgMuted,
                ok = p.darkGreenBright,
            },
            diff = {
                add = blend(p.darkDiffAddLine, p.darkBg, 0.15),
                delete = blend(p.darkDiffDelLine, p.darkBg, 0.15),
                change = blend(p.darkAttn, p.darkBg, 0.15),
                text = blend(p.darkGreenBright, p.darkBg, 0.30),
                text_delete = blend(p.darkRedTerm, p.darkBg, 0.30),
            },
            vcs = {
                added = p.darkGreenBright,
                changed = p.darkYellowWarn,
                removed = p.darkRed,
                untracked = p.darkGreenBright,
                ignored = p.darkTermBrightBlack,
                conflict = p.darkConflict,
            },
            term = {
                p.darkTermBlack, -- black
                p.darkRedTerm, -- red
                p.darkGreenBright, -- green
                p.darkYellowWarn, -- yellow
                p.darkTermBlue, -- blue
                p.darkPurple, -- magenta
                p.darkCyan, -- cyan
                p.darkTermWhite, -- white
                p.darkTermBrightBlack, -- bright black
                p.darkRedBright, -- bright red
                p.darkGreenTerm, -- bright green
                p.darkYellow, -- bright yellow
                p.darkBlue, -- bright blue
                p.darkPurpleBright, -- bright magenta
                p.darkCyanBright, -- bright cyan
                p.darkTermBrightWhite, -- bright white
                p.darkOrange, -- extended color 1
                p.darkConflict, -- extended color 2
            },
        }
    end,

    ---@param p PaletteColors
    ---@return ThemeColors
    light = function(p)
        return {
            ui = {
                none = "NONE",
                fg = p.lightFg,
                fg_dim = p.lightFgMuted,
                fg_reverse = p.lightBg,
                bg = p.lightBg,
                bg_dim = p.lightBgSurface,
                bg_p1 = p.lightBgSurface,
                bg_p2 = p.lightBgHover,
                bg_gutter = "NONE",
                bg_cursorline = p.lightBgCursor,
                bg_highlight = p.lightBgHighlight,
                special = p.lightOrange,
                accent = p.lightAccent,
                nontext = p.lightFgFaint,
                whitespace = p.lightFgSubtle,
                border = p.lightBorder,
                indent_line = blend(p.lightFg, p.lightBg, 0.12),
                active_indent_line = blend(p.lightFg, p.lightBg, 0.24),
                bg_visual = blend(p.lightSelection, p.lightBg, 0.25),
                bg_search = blend(p.lightSearchAll, p.lightBg, 0.50),
                bg_cursearch = p.lightAttn,
                word_read = blend(p.lightAttn, p.lightBg, 0.15),
                word_write = blend(p.lightAttn, p.lightBg, 0.25),
                cursor_bg = p.lightAccent,
                cursor_fg = p.lightBg,
                cursor_line_nr_foreground = p.lightFgFaint,
                cursor_line_nr_active_foreground = p.lightFg,
                scrollbar_thumb = blend(p.lightFgFaint, p.lightBgSurface, 0.20),
                pmenu = {
                    fg = p.lightFg,
                    fg_sel = "NONE",
                    bg = p.lightBgSurface,
                    bg_sel = p.lightBgHover,
                    bg_sbar = p.lightBgSurface,
                    bg_thumb = blend(p.lightFgFaint, p.lightBgSurface, 0.20),
                },
                float = {
                    fg = p.lightFg,
                    bg = p.lightBgSurface,
                    fg_border = p.lightFgPlaceholder,
                    bg_border = p.lightBgSurface,
                },
            },
            syn = {
                string = p.lightNavy,
                variable = p.lightFg,
                parameter = p.lightFg,
                number = p.lightBlue,
                constant = p.lightBlue,
                property = p.lightFg,
                subtle = p.lightGrey,
                fun = p.lightPurple,
                statement = p.lightPink,
                keyword = p.lightPink,
                operator = p.lightPink,
                preproc = p.lightPink,
                type = p.lightBlue,
                tag = p.lightYellow,
                regex = p.lightNavy,
                heading = p.lightBlue,
                deprecated = p.lightPinkError,
                comment = p.lightGreen,
                punct = p.lightFg,
                special1 = p.lightPink,
                special2 = p.lightYellow,
                special3 = p.lightPinkError,
            },
            diag = {
                error = p.lightRed,
                warning = p.lightYellowWarn,
                info = p.lightAccent,
                hint = p.lightFgMuted,
                ok = p.lightGreen,
            },
            diff = {
                add = blend(p.lightDiffAddLine, p.lightBg, 0.30),
                delete = blend(p.lightDiffDelLine, p.lightBg, 0.30),
                change = blend(p.lightYellowGutter, p.lightBg, 0.30),
                text = blend(p.lightDiffAddText, p.lightBg, 0.50),
                text_delete = blend(p.lightDiffDelText, p.lightBg, 0.40),
            },
            vcs = {
                added = p.lightGreenDeep,
                changed = p.lightYellowGit,
                removed = p.lightRed,
                untracked = p.lightGreenDeep,
                ignored = "#6e7781",
                conflict = p.lightConflict,
            },
            term = {
                p.lightTermBlack, -- black
                p.lightRed, -- red
                p.lightGreenDeep, -- green
                p.lightTermYellow, -- yellow
                p.lightAccent, -- blue
                p.lightPurple, -- magenta
                p.lightCyan, -- cyan
                p.lightTermWhite, -- white
                p.lightTermBrightBlack, -- bright black
                p.lightRedBright, -- bright red
                p.lightGreen, -- bright green
                p.lightYellow, -- bright yellow
                p.lightAccentBright, -- bright blue
                p.lightPurpleBright, -- bright magenta
                p.lightCyanBright, -- bright cyan
                p.lightTermBrightWhite, -- bright white
                p.lightOrange, -- extended color 1
                p.lightConflict, -- extended color 2
            },
        }
    end,
}
