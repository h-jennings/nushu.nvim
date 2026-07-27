local M = {}

---@param colors NushuColors
---@param config? NushuConfig
function M.setup(colors, config)
    local theme = colors.theme
    config = config or require("nushu").config

    return {
        -- ColorColumn	Used for the columns set with 'colorcolumn'.
        ColorColumn = { bg = theme.ui.bg_p1 },
        -- Conceal		Placeholder characters substituted for concealed text (see 'conceallevel').
        Conceal = { fg = theme.ui.nontext },
        -- CurSearch	Used for highlighting a search pattern under the cursor (see 'hlsearch').
        CurSearch = { fg = "#ffffff", bg = theme.ui.bg_cursearch },
        -- Cursor		Character under the cursor.
        Cursor = { fg = theme.ui.cursor_fg, bg = theme.ui.cursor_bg },
        -- lCursor		Character under the cursor when |language-mapping| is used (see 'guicursor').
        lCursor = { link = "Cursor" },
        -- CursorIM	Like Cursor, but used when in IME mode.
        CursorIM = { link = "Cursor" },
        -- CursorColumn	Screen-column at the cursor, when 'cursorcolumn' is set.
        CursorColumn = { link = "CursorLine" },
        -- CursorLine	Screen-line at the cursor, when 'cursorline' is set.
        CursorLine = { bg = theme.ui.bg_cursorline },
        -- Directory	Directory names (and other special names in listings).
        Directory = { fg = theme.syn.constant },
        -- DiffAdd		Diff mode: Added line. |diff.txt|
        DiffAdd = { bg = theme.diff.add },
        -- DiffChange	Diff mode: Changed line. |diff.txt|
        DiffChange = { bg = theme.diff.change },
        -- DiffDelete	Diff mode: Deleted line. |diff.txt|
        DiffDelete = { fg = theme.vcs.removed, bg = theme.diff.delete },
        -- DiffText	Diff mode: Changed text within a changed line. |diff.txt|
        DiffText = { bg = theme.diff.text },
        -- EndOfBuffer	Filler lines (~) after the end of the buffer.
        EndOfBuffer = { fg = theme.ui.bg },
        -- TermCursor	Cursor in a focused terminal.
        TermCursor = { fg = theme.ui.cursor_fg, bg = theme.ui.cursor_bg },
        -- ErrorMsg	Error messages on the command line.
        ErrorMsg = { fg = theme.diag.error },
        -- WinSeparator	Separators between window splits.
        WinSeparator = { fg = theme.ui.border, bg = config.dimInactive and theme.ui.bg_dim or theme.ui.none },
        VertSplit = { link = "WinSeparator" },
        -- Folded		Line used for closed folds.
        Folded = { fg = theme.ui.fg_dim, bg = theme.ui.bg_p1 },
        -- FoldColumn	'foldcolumn'
        FoldColumn = { fg = theme.ui.nontext, bg = theme.ui.bg_gutter },
        -- SignColumn	Column where |signs| are displayed.
        SignColumn = { fg = theme.ui.nontext, bg = theme.ui.bg_gutter },
        -- IncSearch	'incsearch' highlighting; also used for the text replaced with ":s///c".
        IncSearch = { link = "CurSearch" },
        -- Substitute	|:substitute| replacement text highlighting.
        Substitute = { fg = "#ffffff", bg = theme.vcs.removed },
        -- LineNr		Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
        LineNr = { fg = theme.ui.cursor_line_nr_foreground, bg = theme.ui.bg_gutter },
        -- CursorLineNr	Like LineNr when 'cursorline' is set and 'cursorlineopt' contains "number" or is "both", for the cursor line.
        CursorLineNr = { fg = theme.ui.cursor_line_nr_active_foreground, bg = theme.ui.bg_gutter },
        -- MatchParen	Character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
        MatchParen = { bg = theme.ui.word_write },
        -- ModeMsg		'showmode' message (e.g., "-- INSERT --").
        ModeMsg = { fg = theme.ui.fg_dim, bold = config.bold },
        -- MsgArea		Area for messages and cmdline.
        MsgArea = vim.o.cmdheight == 0 and { link = "StatusLine" } or { fg = theme.ui.fg_dim },
        -- MsgSeparator	Separator for scrolled messages |msgsep|.
        MsgSeparator = { bg = theme.ui.bg_dim },
        -- MoreMsg		|more-prompt|
        MoreMsg = { fg = theme.diag.info },
        -- NonText		'@' at the end of the window, characters from 'showbreak' etc.
        NonText = { fg = theme.ui.nontext },
        -- Normal		Normal text.
        Normal = { fg = theme.ui.fg, bg = config.transparent and theme.ui.none or theme.ui.bg },
        -- NormalFloat	Normal text in floating windows.
        NormalFloat = { fg = theme.ui.float.fg, bg = config.transparent and theme.ui.none or theme.ui.float.bg },
        -- FloatBorder	Border of floating windows.
        FloatBorder = {
            fg = theme.ui.float.fg_border,
            bg = config.transparent and theme.ui.none or theme.ui.float.bg_border,
        },
        -- FloatTitle	Title of floating windows.
        FloatTitle = {
            fg = theme.ui.fg,
            bg = config.transparent and theme.ui.none or theme.ui.float.bg_border,
            bold = config.bold,
        },
        -- FloatFooter	Footer of floating windows.
        FloatFooter = {
            fg = theme.ui.nontext,
            bg = config.transparent and theme.ui.none or theme.ui.float.bg_border,
        },
        -- NormalNC	Normal text in non-current windows.
        NormalNC = config.dimInactive and { fg = theme.ui.fg_dim, bg = theme.ui.bg_dim } or { link = "Normal" },
        -- Pmenu		Popup menu: Normal item.
        Pmenu = { fg = theme.ui.pmenu.fg, bg = config.transparent and theme.ui.none or theme.ui.pmenu.bg },
        -- PmenuSel	Popup menu: Selected item.
        PmenuSel = { fg = theme.ui.pmenu.fg_sel, bg = theme.ui.pmenu.bg_sel },
        -- PmenuKind	Popup menu: Normal item "kind".
        PmenuKind = { fg = theme.ui.fg_dim, bg = config.transparent and theme.ui.none or theme.ui.pmenu.bg },
        -- PmenuKindSel	Popup menu: Selected item "kind".
        PmenuKindSel = { fg = theme.ui.fg_dim, bg = theme.ui.pmenu.bg_sel },
        -- PmenuExtra	Popup menu: Normal item "extra text".
        PmenuExtra = { fg = theme.ui.fg_dim, bg = config.transparent and theme.ui.none or theme.ui.pmenu.bg },
        -- PmenuExtraSel	Popup menu: Selected item "extra text".
        PmenuExtraSel = { fg = theme.ui.fg_dim, bg = theme.ui.pmenu.bg_sel },
        -- PmenuSbar	Popup menu: Scrollbar.
        PmenuSbar = { bg = config.transparent and theme.ui.none or theme.ui.pmenu.bg_sbar },
        -- PmenuThumb	Popup menu: Thumb of the scrollbar.
        PmenuThumb = { bg = theme.ui.pmenu.bg_thumb },
        -- Question	|hit-enter| prompt and yes/no questions.
        Question = { link = "MoreMsg" },
        -- QuickFixLine	Current |quickfix| item in the quickfix window.
        QuickFixLine = { bg = theme.ui.bg_highlight },
        -- Search		Last search pattern highlighting (see 'hlsearch').
        Search = { bg = theme.ui.bg_search },
        -- SpecialKey	Unprintable characters: Text displayed differently from what it really is.
        SpecialKey = { fg = theme.ui.whitespace },
        -- SpellBad	Word that is not recognized by the spellchecker. |spell|
        SpellBad = { undercurl = config.undercurl, underline = not config.undercurl, sp = theme.diag.error },
        -- SpellCap	Word that should start with a capital. |spell|
        SpellCap = { undercurl = config.undercurl, underline = not config.undercurl, sp = theme.diag.warning },
        -- SpellLocal	Word that is recognized by the spellchecker as one that is used in another region. |spell|
        SpellLocal = { undercurl = config.undercurl, underline = not config.undercurl, sp = theme.diag.warning },
        -- SpellRare	Word that is recognized by the spellchecker as one that is hardly ever used. |spell|
        SpellRare = { undercurl = config.undercurl, underline = not config.undercurl, sp = theme.diag.warning },
        -- StatusLine	Status line of current window.
        StatusLine = { fg = theme.ui.fg_dim, bg = config.transparent and theme.ui.none or theme.ui.bg_dim },
        -- StatusLineNC	Status lines of not-current windows.
        StatusLineNC = { fg = theme.ui.nontext, bg = config.transparent and theme.ui.none or theme.ui.bg_dim },
        -- TabLine		Tab pages line, not active tab page label.
        TabLine = { fg = theme.ui.fg_dim, bg = config.transparent and theme.ui.none or theme.ui.bg_dim },
        -- TabLineFill	Tab pages line, where there are no labels.
        TabLineFill = { bg = config.transparent and theme.ui.none or theme.ui.bg_dim },
        -- TabLineSel	Tab pages line, active tab page label.
        TabLineSel = { fg = theme.ui.fg, bg = config.transparent and theme.ui.none or theme.ui.bg },
        -- Title		Titles for output from ":set all", ":autocmd" etc.
        Title = { fg = theme.syn.heading, bold = config.bold },
        -- Visual		Visual mode selection.
        Visual = { bg = theme.ui.bg_visual },
        -- VisualNOS	Visual mode selection when vim is "Not Owning the Selection".
        VisualNOS = { link = "Visual" },
        -- WarningMsg	Warning messages.
        WarningMsg = { fg = theme.diag.warning },
        -- Whitespace	"nbsp", "space", "tab", "multispace", "lead" and "trail" in 'listchars'.
        Whitespace = { fg = theme.ui.whitespace },
        -- WildMenu	Current match in 'wildmenu' completion.
        WildMenu = { link = "PmenuSel" },
        -- WinBar		Window bar of current window.
        WinBar = { fg = theme.ui.fg_dim, bg = theme.ui.none },
        -- WinBarNC	Window bar of not-current windows.
        WinBarNC = { fg = theme.ui.fg_dim, bg = config.dimInactive and theme.ui.bg_dim or theme.ui.none },

        debugPC = { bg = theme.diff.delete },
        debugBreakpoint = { fg = theme.diag.error, bg = theme.ui.bg_gutter },

        -- LSP document highlights (editor.document_highlight.read/write in Zed)
        LspReferenceText = { bg = theme.ui.word_read },
        LspReferenceRead = { link = "LspReferenceText" },
        LspReferenceWrite = { bg = theme.ui.word_write },
        -- LspInlayHint: inlay hint fg/bg from the VS Code original
        LspInlayHint = { fg = theme.diag.hint, bg = theme.ui.scrollbar_thumb },
        LspCodeLens = { fg = theme.ui.fg_dim },
        LspSignatureActiveParameter = { bg = theme.ui.word_write },

        DiagnosticError = { fg = theme.diag.error },
        DiagnosticWarn = { fg = theme.diag.warning },
        DiagnosticInfo = { fg = theme.diag.info },
        DiagnosticHint = { fg = theme.diag.hint },
        DiagnosticOk = { fg = theme.diag.ok },

        DiagnosticFloatingError = { fg = theme.diag.error },
        DiagnosticFloatingWarn = { fg = theme.diag.warning },
        DiagnosticFloatingInfo = { fg = theme.diag.info },
        DiagnosticFloatingHint = { fg = theme.diag.hint },
        DiagnosticFloatingOk = { fg = theme.diag.ok },

        DiagnosticSignError = { fg = theme.diag.error, bg = theme.ui.bg_gutter },
        DiagnosticSignWarn = { fg = theme.diag.warning, bg = theme.ui.bg_gutter },
        DiagnosticSignInfo = { fg = theme.diag.info, bg = theme.ui.bg_gutter },
        DiagnosticSignHint = { fg = theme.diag.hint, bg = theme.ui.bg_gutter },
        DiagnosticSignOk = { fg = theme.diag.ok, bg = theme.ui.bg_gutter },

        DiagnosticVirtualTextError = { link = "DiagnosticError" },
        DiagnosticVirtualTextWarn = { link = "DiagnosticWarn" },
        DiagnosticVirtualTextInfo = { link = "DiagnosticInfo" },
        DiagnosticVirtualTextHint = { link = "DiagnosticHint" },
        DiagnosticVirtualTextOk = { link = "DiagnosticOk" },

        -- vim.diagnostic.config({ virtual_lines = ... })
        DiagnosticVirtualLinesError = { link = "DiagnosticError" },
        DiagnosticVirtualLinesWarn = { link = "DiagnosticWarn" },
        DiagnosticVirtualLinesInfo = { link = "DiagnosticInfo" },
        DiagnosticVirtualLinesHint = { link = "DiagnosticHint" },
        DiagnosticVirtualLinesOk = { link = "DiagnosticOk" },

        DiagnosticUnderlineError = {
            undercurl = config.undercurl,
            underline = not config.undercurl,
            sp = theme.diag.error,
        },
        DiagnosticUnderlineWarn = {
            undercurl = config.undercurl,
            underline = not config.undercurl,
            sp = theme.diag.warning,
        },
        DiagnosticUnderlineInfo = {
            undercurl = config.undercurl,
            underline = not config.undercurl,
            sp = theme.diag.info,
        },
        DiagnosticUnderlineHint = {
            undercurl = config.undercurl,
            underline = not config.undercurl,
            sp = theme.diag.hint,
        },
        DiagnosticDeprecated = { strikethrough = true, fg = theme.syn.deprecated },
        DiagnosticUnnecessary = { fg = theme.ui.fg_dim },

        -- vcs (legacy diff syntax groups)
        diffAdded = { fg = theme.vcs.added },
        diffRemoved = { fg = theme.vcs.removed },
        diffDeleted = { fg = theme.vcs.removed },
        diffChanged = { fg = theme.vcs.changed },
        diffOldFile = { fg = theme.vcs.removed },
        diffNewFile = { fg = theme.vcs.added },

        healthError = { fg = theme.diag.error },
        healthSuccess = { fg = theme.diag.ok },
        healthWarning = { fg = theme.diag.warning },
    }
end

return M
