--- TextMate scope rules for the ports that theme by scope instead of highlight group (yazi, Hunk).
---@param syn SyntaxElements
---@return { [1]: string, [2]: string, [3]: string }[] rules of { name, comma-separated scopes, color }
return function(syn)
    return {
        { "Comment", "comment", syn.comment },
        { "String", "string, string.quoted, string.template", syn.string },
        { "Regular expression", "string.regexp", syn.regex },
        { "Escape sequence", "constant.character.escape", syn.special1 },
        { "Number", "constant.numeric", syn.number },
        { "Built-in constant", "constant.language, constant.character", syn.constant },
        { "Other constant", "constant.other", syn.constant },
        { "Variable", "variable, variable.other, meta.object.member", syn.variable },
        { "Function parameter", "variable.parameter", syn.parameter },
        { "Keyword", "keyword, keyword.control, storage, storage.type, storage.modifier", syn.keyword },
        { "Operator", "keyword.operator", syn.operator },
        { "Preprocessor / import", "meta.preprocessor, keyword.other.import, keyword.control.import", syn.preproc },
        { "Function", "entity.name.function, support.function, meta.function-call", syn.fun },
        { "Custom type", "entity.name.type, entity.name.class, entity.other.inherited-class", syn.type },
        { "Default-library type", "support.type, support.class", syn.constant },
        {
            "Tag / component / JSON key",
            "entity.name.tag, support.class.component, support.type.property-name",
            syn.tag,
        },
        { "Punctuation", "punctuation, meta.brace", syn.punct },
        { "Markdown heading", "markup.heading, entity.name.section", syn.heading },
        { "Invalid", "invalid, invalid.illegal", syn.deprecated },
        { "Deprecated", "invalid.deprecated", syn.deprecated },
    }
end
