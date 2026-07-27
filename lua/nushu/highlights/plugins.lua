local M = {}

---@param colors NushuColors
---@param config? NushuConfig
function M.setup(colors, config)
    local theme = colors.theme
    config = config or require("nushu").config

    return {
        -- gitsigns.nvim
        GitSignsAdd = { fg = theme.vcs.added, bg = theme.ui.bg_gutter },
        GitSignsChange = { fg = theme.vcs.changed, bg = theme.ui.bg_gutter },
        GitSignsDelete = { fg = theme.vcs.removed, bg = theme.ui.bg_gutter },
        GitSignsTopdelete = { link = "GitSignsDelete" },
        GitSignsChangedelete = { link = "GitSignsChange" },
        GitSignsUntracked = { fg = theme.vcs.untracked, bg = theme.ui.bg_gutter },
        GitSignsStagedAdd = { fg = theme.vcs.added, bg = theme.ui.bg_gutter },
        GitSignsStagedChange = { fg = theme.vcs.changed, bg = theme.ui.bg_gutter },
        GitSignsStagedDelete = { fg = theme.vcs.removed, bg = theme.ui.bg_gutter },
        GitSignsAddInline = { bg = theme.diff.text },
        GitSignsChangeInline = { bg = theme.diff.change },
        GitSignsDeleteInline = { bg = theme.diff.text_delete },
        GitSignsAddPreview = { bg = theme.diff.add },
        GitSignsDeletePreview = { bg = theme.diff.delete },
        GitSignsCurrentLineBlame = { fg = theme.ui.nontext },

        -- snacks.nvim: picker
        SnacksPicker = { link = "NormalFloat" },
        SnacksPickerBorder = { link = "FloatBorder" },
        SnacksPickerTitle = { link = "FloatTitle" },
        SnacksPickerBoxTitle = { link = "FloatTitle" },
        SnacksPickerInputTitle = { link = "FloatTitle" },
        SnacksPickerInputBorder = { link = "FloatBorder" },
        SnacksPickerPrompt = { fg = theme.ui.accent },
        -- quickInputList.focusForeground: picker matches are yellow in VS Code
        SnacksPickerMatch = { fg = theme.syn.special2 },
        SnacksPickerDir = { fg = theme.ui.fg_dim },
        SnacksPickerDimmed = { fg = theme.ui.nontext },
        SnacksPickerRow = { fg = theme.ui.fg },
        SnacksPickerListCursorLine = { bg = theme.ui.bg_p2 },
        SnacksPickerPreviewCursorLine = { bg = theme.ui.bg_cursorline },
        SnacksPickerSelected = { fg = theme.ui.special },
        SnacksPickerCursor = { link = "Cursor" },
        SnacksPickerPickWin = { fg = theme.ui.fg_reverse, bg = theme.ui.accent, bold = config.bold },
        SnacksPickerPickWinCurrent = { fg = theme.ui.fg_reverse, bg = theme.ui.special, bold = config.bold },

        -- snacks.nvim: indent guides
        SnacksIndent = { fg = theme.ui.indent_line, nocombine = true },
        SnacksIndentChunk = { fg = theme.ui.indent_line, nocombine = true },
        SnacksIndentScope = { fg = theme.ui.active_indent_line, nocombine = true },

        -- snacks.nvim: dashboard
        SnacksDashboardHeader = { fg = theme.ui.accent },
        SnacksDashboardTitle = { fg = theme.ui.fg, bold = config.bold },
        SnacksDashboardDesc = { fg = theme.ui.fg },
        SnacksDashboardIcon = { fg = theme.ui.accent },
        SnacksDashboardKey = { fg = theme.syn.keyword },
        SnacksDashboardSpecial = { fg = theme.ui.special },
        SnacksDashboardDir = { fg = theme.ui.fg_dim },
        SnacksDashboardFooter = { fg = theme.ui.fg_dim },

        -- snacks.nvim: input
        SnacksInputNormal = { link = "NormalFloat" },
        SnacksInputBorder = { link = "FloatBorder" },
        SnacksInputTitle = { link = "FloatTitle" },
        SnacksInputIcon = { fg = theme.ui.accent },
        SnacksInputPrompt = { fg = theme.ui.accent },

        -- snacks.nvim: notifier
        SnacksNotifierInfo = { fg = theme.diag.info },
        SnacksNotifierWarn = { fg = theme.diag.warning },
        SnacksNotifierError = { fg = theme.diag.error },
        SnacksNotifierDebug = { fg = theme.ui.fg_dim },
        SnacksNotifierTrace = { fg = theme.ui.fg_dim },
        SnacksNotifierIconInfo = { fg = theme.diag.info },
        SnacksNotifierIconWarn = { fg = theme.diag.warning },
        SnacksNotifierIconError = { fg = theme.diag.error },
        SnacksNotifierBorderInfo = { link = "FloatBorder" },
        SnacksNotifierBorderWarn = { link = "FloatBorder" },
        SnacksNotifierBorderError = { link = "FloatBorder" },

        -- blink.cmp
        BlinkCmpMenu = { link = "Pmenu" },
        BlinkCmpMenuBorder = { fg = theme.ui.float.fg_border, bg = theme.ui.pmenu.bg },
        BlinkCmpMenuSelection = { bg = theme.ui.pmenu.bg_sel },
        BlinkCmpScrollBarGutter = { bg = theme.ui.pmenu.bg_sbar },
        BlinkCmpScrollBarThumb = { bg = theme.ui.pmenu.bg_thumb },
        BlinkCmpLabel = { fg = theme.ui.pmenu.fg },
        BlinkCmpLabelDeprecated = { fg = theme.ui.fg_dim, strikethrough = true },
        BlinkCmpLabelDetail = { fg = theme.ui.fg_dim },
        BlinkCmpLabelDescription = { fg = theme.ui.fg_dim },
        -- list.highlightForeground: completion matches are info blue in VS Code
        BlinkCmpLabelMatch = { fg = theme.diag.info },
        BlinkCmpGhostText = vim.tbl_extend(
            "force",
            { fg = theme.ui.nontext },
            not config.italics and {} or { italic = true }
        ),
        BlinkCmpDoc = { link = "NormalFloat" },
        BlinkCmpDocBorder = { link = "FloatBorder" },
        BlinkCmpDocCursorLine = { bg = theme.ui.bg_cursorline },
        BlinkCmpSignatureHelp = { link = "NormalFloat" },
        BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
        BlinkCmpSignatureHelpActiveParameter = { bg = theme.ui.word_write },
        BlinkCmpSource = { fg = theme.ui.fg_dim },
        BlinkCmpKind = { fg = theme.ui.fg_dim },
        -- kind colors follow VS Code's symbolIcon.* palette: orange for
        -- classes/fields/variables, purple for callables, blue for values
        BlinkCmpKindText = { fg = theme.ui.fg },
        BlinkCmpKindMethod = { fg = theme.syn.fun },
        BlinkCmpKindFunction = { fg = theme.syn.fun },
        BlinkCmpKindConstructor = { fg = theme.syn.fun },
        BlinkCmpKindField = { fg = theme.ui.special },
        BlinkCmpKindVariable = { fg = theme.ui.special },
        BlinkCmpKindClass = { fg = theme.ui.special },
        BlinkCmpKindInterface = { fg = theme.ui.special },
        BlinkCmpKindModule = { fg = theme.syn.constant },
        BlinkCmpKindProperty = { fg = theme.ui.special },
        BlinkCmpKindUnit = { fg = theme.syn.number },
        BlinkCmpKindValue = { fg = theme.syn.number },
        BlinkCmpKindEnum = { fg = theme.ui.special },
        BlinkCmpKindKeyword = { fg = theme.syn.keyword },
        BlinkCmpKindSnippet = { fg = theme.syn.special1 },
        BlinkCmpKindColor = { fg = theme.ui.special },
        BlinkCmpKindFile = { fg = theme.ui.fg },
        BlinkCmpKindReference = { fg = theme.syn.property },
        BlinkCmpKindFolder = { fg = theme.ui.accent },
        BlinkCmpKindEnumMember = { fg = theme.syn.constant },
        BlinkCmpKindConstant = { fg = theme.syn.constant },
        BlinkCmpKindStruct = { fg = theme.ui.special },
        BlinkCmpKindEvent = { fg = theme.ui.special },
        BlinkCmpKindOperator = { fg = theme.syn.operator },
        BlinkCmpKindTypeParameter = { fg = theme.syn.constant },
        BlinkCmpKindCopilot = { fg = theme.ui.fg_dim },

        -- trouble.nvim
        TroubleNormal = { fg = theme.ui.fg, bg = config.transparent and theme.ui.none or theme.ui.bg_dim },
        TroubleNormalNC = { link = "TroubleNormal" },
        TroubleText = { fg = theme.ui.fg },
        TroubleCount = { fg = theme.syn.special2, bg = theme.ui.bg_p2 },
        TroubleIndent = { fg = theme.ui.indent_line },
        TroublePos = { fg = theme.ui.fg_dim },
        TroubleSource = { fg = theme.ui.fg_dim },
        TroubleCode = { fg = theme.ui.fg_dim },
        TroubleDirectory = { fg = theme.ui.fg_dim },
        TroubleFileName = { fg = theme.syn.constant },
        TroubleIconDirectory = { fg = theme.ui.accent },

        -- which-key.nvim
        WhichKey = { fg = theme.syn.fun },
        WhichKeyGroup = { fg = theme.syn.constant },
        WhichKeyDesc = { fg = theme.ui.fg },
        WhichKeySeparator = { fg = theme.ui.fg_dim },
        WhichKeyValue = { fg = theme.ui.fg_dim },
        WhichKeyNormal = { link = "NormalFloat" },
        WhichKeyBorder = { link = "FloatBorder" },
        WhichKeyTitle = { link = "FloatTitle" },
        WhichKeyIcon = { fg = theme.ui.accent },

        -- nvim-treesitter-context
        TreesitterContext = { bg = theme.ui.bg_p1 },
        TreesitterContextLineNumber = { fg = theme.ui.nontext, bg = theme.ui.bg_p1 },
        TreesitterContextBottom = { underline = true, sp = theme.ui.border },
        TreesitterContextSeparator = { fg = theme.ui.border },

        -- lazy.nvim
        LazyNormal = { link = "NormalFloat" },
        LazyButton = { fg = theme.ui.fg, bg = theme.ui.bg_p2 },
        LazyButtonActive = { fg = theme.ui.fg_reverse, bg = theme.ui.accent, bold = config.bold },
        LazyH1 = { fg = theme.ui.fg_reverse, bg = theme.ui.accent, bold = config.bold },
        LazyProgressDone = { fg = theme.ui.accent },
        LazyProgressTodo = { fg = theme.ui.nontext },
        LazySpecial = { fg = theme.ui.accent },
        LazyReasonPlugin = { fg = theme.ui.fg_dim },

        -- copilot.vim (Zed "predictive" color)
        CopilotSuggestion = vim.tbl_extend(
            "force",
            { fg = theme.ui.nontext },
            not config.italics and {} or { italic = true }
        ),
        CopilotAnnotation = { fg = theme.ui.nontext },

        -- quicker.nvim / quickfix
        QuickFixHeaderHard = { link = "Delimiter" },
        QuickFixHeaderSoft = { link = "Delimiter" },
        QuickFixLineNr = { link = "LineNr" },

        -- arrow.nvim
        ArrowFileIndex = { fg = theme.ui.accent },
        ArrowCurrentFile = { fg = theme.ui.special },
        ArrowAction = { fg = theme.syn.keyword },
        ArrowDeleteMode = { fg = theme.diag.error },

        -- telescope.nvim (not installed; cheap links for portability)
        TelescopeNormal = { link = "NormalFloat" },
        TelescopeBorder = { link = "FloatBorder" },
        TelescopeTitle = { link = "FloatTitle" },
        TelescopeSelection = { bg = theme.ui.bg_p2 },
        TelescopeSelectionCaret = { fg = theme.ui.accent },
        TelescopeMatching = { fg = theme.syn.special2 },
        TelescopePromptPrefix = { fg = theme.ui.accent },

        -- nvim-cmp (not installed; cheap links for portability)
        CmpItemAbbr = { fg = theme.ui.pmenu.fg },
        CmpItemAbbrDeprecated = { fg = theme.ui.fg_dim, strikethrough = true },
        CmpItemAbbrMatch = { fg = theme.diag.info },
        CmpItemAbbrMatchFuzzy = { link = "CmpItemAbbrMatch" },
        CmpItemMenu = { fg = theme.ui.fg_dim },
        CmpGhostText = { link = "BlinkCmpGhostText" },
        CmpDocumentation = { link = "NormalFloat" },
        CmpDocumentationBorder = { link = "FloatBorder" },

        -- flash.nvim (not installed; cheap defaults)
        FlashBackdrop = { fg = theme.ui.fg_dim },
        FlashLabel = { fg = theme.ui.fg_reverse, bg = theme.syn.keyword, bold = config.bold },
        FlashMatch = { bg = theme.ui.bg_search },
    }
end

return M
