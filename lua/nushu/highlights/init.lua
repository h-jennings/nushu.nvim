local M = {}

---@param highlights table<string, table>
---@param termcolors ColorSpec[]
function M.highlight(highlights, termcolors)
    for hl, spec in pairs(highlights) do
        vim.api.nvim_set_hl(0, hl, spec)
    end
    for i, tcolor in ipairs(termcolors) do
        vim.g["terminal_color_" .. i - 1] = tcolor
    end
end

---@param colors NushuColors
---@param config? NushuConfig
function M.setup(colors, config)
    config = config or require("nushu").config

    local highlights = {}
    for _, highlight in ipairs({ "editor", "syntax", "treesitter", "lsp", "plugins" }) do
        local mod = require("nushu.highlights." .. highlight)
        for hl, spec in pairs(mod.setup(colors, config)) do
            highlights[hl] = spec
        end
    end

    for hl, spec in pairs(config.overrides(colors)) do
        if highlights[hl] and next(spec) then
            -- nvim_set_hl ignores other keys when link is present, so an
            -- override of a linked group must drop the link to take effect
            highlights[hl].link = nil
        end
        highlights[hl] = vim.tbl_extend("force", highlights[hl] or {}, spec)
    end

    return highlights
end

return M
