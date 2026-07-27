local M = {}

--- LSP semantic token highlights. Almost entirely links into the
--- syntax/treesitter layer so treesitter stays canonical; `@lsp.type.variable`
--- and `@lsp.type.comment` are intentionally empty to defer to treesitter,
--- which has better information for those captures.
---@param colors NushuColors
---@param config? NushuConfig
function M.setup(colors, config)
    config = config or require("nushu").config
    local theme = colors.theme
    return {
        ["@lsp.type.class"] = { link = "Type" },
        ["@lsp.type.decorator"] = { link = "@attribute" },
        ["@lsp.type.enum"] = { link = "Type" },
        ["@lsp.type.enumMember"] = { link = "Constant" },
        ["@lsp.type.function"] = { link = "Function" },
        ["@lsp.type.interface"] = { link = "Type" },
        ["@lsp.type.keyword"] = { link = "Keyword" },
        ["@lsp.type.macro"] = { link = "@function.macro" },
        ["@lsp.type.method"] = { link = "Function" },
        ["@lsp.type.namespace"] = { link = "@module" },
        ["@lsp.type.parameter"] = { link = "@variable.parameter" },
        ["@lsp.type.property"] = { link = "@property" },
        ["@lsp.type.struct"] = { link = "Type" },
        ["@lsp.type.type"] = { link = "Type" },
        ["@lsp.type.typeParameter"] = { link = "Type" },
        ["@lsp.type.variable"] = {}, -- defer to treesitter
        ["@lsp.type.comment"] = {}, -- defer to treesitter

        ["@lsp.mod.deprecated"] = { strikethrough = true, fg = theme.syn.deprecated },
        -- NOTE: no broad @lsp.mod.readonly link — it would outrank
        -- @lsp.type.function and turn const-assigned functions (hooks) blue
        -- instead of purple. Readonly is handled per-type via typemod below.
        ["@lsp.typemod.property.readonly"] = { link = "Constant" },

        -- Default-library types (Omit, Partial, Promise, ...) resolve through
        -- the `support` scope in the VS Code original: blue, unlike the grey
        -- of custom types
        ["@lsp.typemod.type.defaultLibrary"] = { link = "Constant" },
        ["@lsp.typemod.class.defaultLibrary"] = { link = "Constant" },
        ["@lsp.typemod.interface.defaultLibrary"] = { link = "Constant" },
        ["@lsp.typemod.enum.defaultLibrary"] = { link = "Constant" },
        ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "Constant" },

        ["@lsp.typemod.function.builtin"] = { link = "@function.builtin" },
        ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
        ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
        ["@lsp.typemod.variable.constant"] = { link = "Constant" },
        ["@lsp.typemod.variable.readonly"] = { link = "Constant" },
        ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
        ["@lsp.typemod.variable.global"] = { link = "Constant" },
        ["@lsp.typemod.variable.static"] = { link = "Constant" },
        ["@lsp.typemod.variable.injected"] = { link = "@variable" },
    }
end

return M
