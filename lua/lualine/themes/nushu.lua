-- Lualine theme for nushu.nvim. Discovered automatically by lualine when
-- `theme = "auto"` (vim.g.colors_name is "nushu"). Mode colors mirror the
-- Nushu Zed theme's vim mode indicator.
local theme = require("nushu.colors").setup().theme

local nushu = {}

nushu.normal = {
    a = { bg = theme.diag.info, fg = theme.ui.fg_reverse },
    b = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
    c = { bg = theme.ui.bg_dim, fg = theme.ui.fg_dim },
}

nushu.insert = {
    a = { bg = theme.diag.ok, fg = theme.ui.fg_reverse },
    b = { bg = theme.ui.bg_p2, fg = theme.diag.ok },
}

nushu.command = {
    a = { bg = theme.syn.keyword, fg = theme.ui.fg_reverse },
    b = { bg = theme.ui.bg_p2, fg = theme.syn.keyword },
}

nushu.visual = {
    a = { bg = theme.syn.fun, fg = theme.ui.fg_reverse },
    b = { bg = theme.ui.bg_p2, fg = theme.syn.fun },
}

nushu.replace = {
    a = { bg = theme.ui.special, fg = theme.ui.fg_reverse },
    b = { bg = theme.ui.bg_p2, fg = theme.ui.special },
}

nushu.terminal = {
    a = { bg = theme.diag.ok, fg = theme.ui.fg_reverse },
    b = { bg = theme.ui.bg_p2, fg = theme.diag.ok },
}

nushu.inactive = {
    a = { bg = theme.ui.bg_dim, fg = theme.ui.fg_dim },
    b = { bg = theme.ui.bg_dim, fg = theme.ui.fg_dim },
    c = { bg = theme.ui.bg_dim, fg = theme.ui.nontext },
}

if vim.g.nushu_lualine_bold then
    for _, mode in pairs(nushu) do
        if mode.a then
            mode.a.gui = "bold"
        end
    end
end

return nushu
