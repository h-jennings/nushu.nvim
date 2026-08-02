--- Generates the nushu-dark/nushu-light yazi flavors from nushu's own palette.
---
---     nvim -l tools/gen-yazi-flavors.lua
---
--- Chrome is written from lua/nushu/themes.lua. Icons are re-tinted out of the
--- vendored preset, because `[icon]` is the only place yazi hardcodes color —
--- 725 Material Design hexes, too many to maintain by hand across upgrades.

local repo = vim.fn.fnamemodify(vim.fn.resolve(debug.getinfo(1, "S").source:sub(2)), ":p:h:h")
package.path = repo .. "/lua/?.lua;" .. repo .. "/lua/?/init.lua;" .. package.path

-- : Color math {{{

local function to_rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function to_hex(r, g, b)
    local function clamp(v)
        return math.max(0, math.min(255, math.floor(v + 0.5)))
    end
    return string.format("#%02x%02x%02x", clamp(r), clamp(g), clamp(b))
end

---@return number hue 0..360, number saturation 0..1, number lightness 0..1
local function to_hsl(hex)
    local r, g, b = to_rgb(hex)
    r, g, b = r / 255, g / 255, b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local l = (max + min) / 2
    if max == min then
        return 0, 0, l
    end
    local d = max - min
    local s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    local h
    if max == r then
        h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
        h = (b - r) / d + 2
    else
        h = (r - g) / d + 4
    end
    return h * 60, s, l
end

local function from_hsl(h, s, l)
    h = (h % 360) / 360
    if s == 0 then
        return to_hex(l * 255, l * 255, l * 255)
    end
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    local function channel(t)
        t = t % 1
        if t < 1 / 6 then
            return p + (q - p) * 6 * t
        elseif t < 1 / 2 then
            return q
        elseif t < 2 / 3 then
            return p + (q - p) * (2 / 3 - t) * 6
        end
        return p
    end
    return to_hex(channel(h + 1 / 3) * 255, channel(h) * 255, channel(h - 1 / 3) * 255)
end

--- Keep the hue, substitute a fixed saturation and lightness. The preset icons
--- span S 0.1..1.0, and that variance is what reads as noisy — pinning S/L
--- makes one family of them while hue still separates one filetype from another.
local function retone(hex, s, l)
    local h = to_hsl(hex)
    return from_hsl(h, s, l)
end

-- : }}}

-- : Icon tones {{{

--- The nine tones every preset icon color collapses onto, hue-matched to nushu's
--- accents. Softer than the syntax colors: icons sit beside filenames drawn at
--- full `fg` and must not outrank the name.
---@param p PaletteColors
---@param variant "dark"|"light"
local function icon_tones(p, variant)
    local src, s, l
    if variant == "dark" then
        s, l = 0.38, 0.62
        src = {
            red = p.darkRed,
            orange = p.darkOrange,
            yellow = p.darkYellow,
            green = p.darkGreenBright,
            cyan = p.darkCyan,
            blue = p.darkTermBlue,
            purple = p.darkPurple,
            pink = p.darkPink,
        }
    else
        s, l = 0.42, 0.40
        src = {
            red = p.lightRed,
            orange = p.lightOrange,
            yellow = p.lightYellowWarn,
            green = p.lightGreenDeep,
            cyan = p.lightCyan,
            blue = p.lightAccent,
            purple = p.lightPurple,
            pink = p.lightPink,
        }
    end

    local tones = {}
    for name, hex in pairs(src) do
        tones[name] = retone(hex, s, l)
    end
    -- A warm grey, not the palette's cool `fg_dim`, which goes slightly green
    -- against these backgrounds.
    tones.grey = variant == "dark" and p.darkFgFaint or p.lightFgPlaceholder
    return tones
end

--- Thresholds follow the measured hue clusters in yazi's icon set.
local function tone_for(hex, tones)
    local h, s = to_hsl(hex)
    if s < 0.12 then
        return tones.grey
    elseif h < 20 or h >= 340 then
        return tones.red
    elseif h < 45 then
        return tones.orange
    elseif h < 70 then
        return tones.yellow
    elseif h < 160 then
        return tones.green
    elseif h < 200 then
        return tones.cyan
    elseif h < 250 then
        return tones.blue
    elseif h < 290 then
        return tones.purple
    end
    return tones.pink
end

-- : }}}

-- : TOML emission {{{

--- Fixed key order: Lua table iteration is unspecified, so without it every
--- regeneration would reshuffle keys into a fake diff.
local function style(t)
    local parts = {}
    for _, key in ipairs({ "fg", "bg" }) do
        if t[key] then
            parts[#parts + 1] = string.format('%s = "%s"', key, t[key])
        end
    end
    for _, key in ipairs({ "bold", "dim", "italic", "underline", "reversed" }) do
        if t[key] then
            parts[#parts + 1] = key .. " = true"
        end
    end
    if #parts == 0 then
        return "{}"
    end
    return "{ " .. table.concat(parts, ", ") .. " }"
end

---@param colors NushuColors
---@param variant "dark"|"light"
---@param tones table<string, string>
local function chrome(colors, variant, tones)
    local ui, syn, diag, vcs = colors.theme.ui, colors.theme.syn, colors.theme.diag, colors.theme.vcs
    local o = {}
    local function w(fmt, ...)
        o[#o + 1] = select("#", ...) > 0 and string.format(fmt, ...) or fmt
    end

    w("# Nushu (%s) — generated by tools/gen-yazi-flavors.lua, do not edit by hand.", variant)
    w("# Regenerate with: nvim -l tools/gen-yazi-flavors.lua")
    w("")
    w("#:schema https://yazi-rs.github.io/schemas/theme.json")
    w("")
    w("# : Manager {{{")
    w("")
    w("[mgr]")
    w("cwd = %s", style({ fg = ui.fg_dim }))
    w("")
    w("# Underline alone locates the match; the preset also stacked bold + italic.")
    w("find_keyword  = %s", style({ fg = syn.special2, bold = true, underline = true }))
    w("find_position = %s", style({ fg = ui.nontext, bold = true }))
    w("")
    w("symlink_target = %s", style({ fg = ui.nontext, italic = true }))
    w("")
    w("# fg and bg match so the gutter marker reads as a solid rule.")
    w("marker_copied   = %s", style({ fg = vcs.added, bg = vcs.added }))
    w("marker_cut      = %s", style({ fg = vcs.removed, bg = vcs.removed }))
    w("marker_marked   = %s", style({ fg = diag.info, bg = diag.info }))
    w("marker_selected = %s", style({ fg = vcs.changed, bg = vcs.changed }))
    w('marker_symbol   = "│"')
    w("")
    w("count_copied   = %s", style({ fg = ui.fg_reverse, bg = vcs.added }))
    w("count_cut      = %s", style({ fg = ui.fg_reverse, bg = vcs.removed }))
    w("count_selected = %s", style({ fg = ui.fg_reverse, bg = vcs.changed }))
    w("")
    w("# The preset's `gray` is ANSI 7, which lands on nushu's terminal white —")
    w("# brighter than the float border Neovim draws around yazi, so the column")
    w("# dividers outshouted the frame holding them.")
    w('border_symbol = "│"')
    w("border_style  = %s", style({ fg = ui.border }))
    w("")
    w("# : }}}")
    w("")
    w("# : Tabs {{{")
    w("")
    w("[tabs]")
    w("active   = %s", style({ fg = ui.fg, bg = ui.bg_p2, bold = true }))
    w("inactive = %s", style({ fg = ui.nontext, bg = ui.bg_dim }))
    w("")
    w("# : }}}")
    w("")
    w("# : Mode {{{")
    w("")
    w("# The one saturated thing on screen, matched to the lualine mode badge.")
    w("[mode]")
    w("normal_main = %s", style({ fg = ui.fg_reverse, bg = diag.info, bold = true }))
    w("normal_alt  = %s", style({ fg = diag.info, bg = ui.bg_p2 }))
    w("")
    w("select_main = %s", style({ fg = ui.fg_reverse, bg = syn.fun, bold = true }))
    w("select_alt  = %s", style({ fg = syn.fun, bg = ui.bg_p2 }))
    w("")
    w("unset_main = %s", style({ fg = ui.fg_reverse, bg = ui.special, bold = true }))
    w("unset_alt  = %s", style({ fg = ui.special, bg = ui.bg_p2 }))
    w("")
    w("# : }}}")
    w("")
    w("# : Indicator of hovered file {{{")
    w("")
    w("# Background tint rather than the preset's `reversed`, which swaps fg and bg")
    w("# and so throws away the file's own color mid-hover.")
    w("[indicator]")
    w("parent  = %s", style({ bg = ui.bg_cursorline }))
    w("current = %s", style({ bg = ui.bg_p2 }))
    w("preview = %s", style({ bg = ui.bg_cursorline }))
    w("")
    w("# : }}}")
    w("")
    w("# : Status bar {{{")
    w("")
    w("[status]")
    w("overall = %s", style({ fg = ui.fg, bg = ui.bg_dim }))
    w("")
    w("# Only write and exec are worth spotting; the preset gave all four a hue.")
    w("perm_sep   = %s", style({ fg = ui.whitespace }))
    w("perm_type  = %s", style({ fg = ui.nontext }))
    w("perm_read  = %s", style({ fg = ui.nontext }))
    w("perm_write = %s", style({ fg = vcs.changed }))
    w("perm_exec  = %s", style({ fg = vcs.added }))
    w("")
    w("progress_label  = %s", style({ fg = ui.fg, bold = true }))
    w("progress_normal = %s", style({ fg = diag.info, bg = ui.bg_p2 }))
    w("progress_error  = %s", style({ fg = diag.error, bg = ui.bg_p2 }))
    w("")
    w("# : }}}")
    w("")
    w("# : Which {{{")
    w("")
    w("# Mirrors nushu's which-key groups.")
    w("[which]")
    w("cols            = 3")
    w("mask            = %s", style({ bg = ui.bg_dim }))
    w("cand            = %s", style({ fg = syn.fun }))
    w("rest            = %s", style({ fg = ui.nontext }))
    w("desc            = %s", style({ fg = ui.fg }))
    w('separator       = "  "')
    w("separator_style = %s", style({ fg = ui.whitespace }))
    w("")
    w("# : }}}")
    w("")
    w("# : Floating windows {{{")
    w("")
    w("# FloatBorder/FloatTitle treatment; the preset bordered all of these in blue.")

    local float_border, float_title = ui.float.fg_border, ui.fg
    for _, section in ipairs({ "confirm", "spot", "pick", "input", "cmp", "tasks" }) do
        w("")
        w("[%s]", section)
        w("border = %s", style({ fg = float_border }))
        if section == "confirm" or section == "spot" or section == "input" then
            w("title  = %s", style({ fg = float_title, bold = true }))
        end
        if section == "confirm" then
            w("body    = %s", style({ fg = ui.fg }))
            w("list    = %s", style({ fg = ui.fg_dim }))
            w("btn_yes = %s", style({ fg = ui.fg_reverse, bg = diag.info, bold = true }))
            w("btn_no  = %s", style({ fg = ui.fg_dim }))
        elseif section == "spot" then
            w("tbl_col  = %s", style({ fg = ui.fg_dim, bold = true }))
            w("tbl_cell = %s", style({ fg = ui.fg, bg = ui.bg_p2 }))
        elseif section == "pick" then
            w("active   = %s", style({ fg = ui.fg, bg = ui.bg_p2, bold = true }))
            w("inactive = %s", style({ fg = ui.fg_dim }))
        elseif section == "input" then
            w("value    = %s", style({ fg = ui.fg }))
            w("selected = %s", style({ bg = ui.bg_visual }))
        elseif section == "cmp" then
            w("active   = %s", style({ fg = ui.fg, bg = ui.bg_p2 }))
            w("inactive = %s", style({ fg = ui.fg_dim }))
        elseif section == "tasks" then
            w("title   = %s", style({ fg = float_title, bold = true }))
            w("hovered = %s", style({ fg = ui.fg, bg = ui.bg_p2 }))
        end
    end

    w("")
    w("# : }}}")
    w("")
    w("# : Notification {{{")
    w("")
    w("# Left saturated: here the color is the message.")
    w("[notify]")
    w("title_info  = %s", style({ fg = diag.info }))
    w("title_warn  = %s", style({ fg = diag.warning }))
    w("title_error = %s", style({ fg = diag.error }))
    w("")
    w("# : }}}")
    w("")
    w("# : Help menu {{{")
    w("")
    w("[help]")
    w("on      = %s", style({ fg = syn.fun }))
    w("run     = %s", style({ fg = ui.fg_dim }))
    w("desc    = %s", style({ fg = ui.fg }))
    w("hovered = %s", style({ bg = ui.bg_p2, bold = true }))
    w("footer  = %s", style({ fg = ui.fg_dim, bg = ui.bg_dim }))
    w("")
    w("# : }}}")
    w("")
    w("# : File-specific styles {{{")
    w("")
    w("# Shares the icon tones so a name and its icon agree. orphan/dummy get a red")
    w('# foreground; the preset\'s `bg = "red"` painted the whole row.')
    w("[filetype]")
    w("rules = [")
    w('\t{ mime = "image/*", fg = "%s" },', tones.yellow)
    w('\t{ mime = "{audio,video}/*", fg = "%s" },', tones.purple)
    w(
        '\t{ mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", fg = "%s" },',
        tones.red
    )
    w('\t{ mime = "application/{pdf,doc,rtf}", fg = "%s" },', tones.cyan)
    w('\t{ mime = "vfs/{absent,stale}", fg = "%s" },', ui.whitespace)
    w('\t{ url = "*", is = "orphan", fg = "%s" },', diag.error)
    w('\t{ url = "*", is = "exec", fg = "%s" },', tones.green)
    w('\t{ url = "*", is = "dummy", fg = "%s" },', diag.error)
    w('\t{ url = "*/", is = "dummy", fg = "%s" },', diag.error)
    w('\t{ url = "*/", fg = "%s" },', tones.blue)
    w("]")
    w("")
    w("# : }}}")
    w("")

    return table.concat(o, "\n")
end

--- Glyphs and match rules pass through verbatim; only `fg` changes.
local function icons(preset_path, tones)
    local f = assert(io.open(preset_path, "r"), "missing vendored preset: " .. preset_path)
    local text = f:read("*a")
    f:close()

    local start = text:find("%[icon%]")
    assert(start, "no [icon] section in " .. preset_path)

    local n = 0
    local section = text:sub(start):gsub('fg = "(#%x%x%x%x%x%x)"', function(hex)
        n = n + 1
        return string.format('fg = "%s"', tone_for(hex, tones))
    end)

    return "# : Icons {{{\n\n" .. section, n
end

-- : }}}

-- : tmTheme for file previews {{{

--- yazi previews through syntect, which wants TextMate scopes rather than
--- highlight groups. Scopes follow the mapping in lua/nushu/themes.lua.
---@param colors NushuColors
---@param variant "dark"|"light"
local function tmtheme(colors, variant)
    local ui, syn = colors.theme.ui, colors.theme.syn

    local rules = {
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

    local o = {}
    local function w(s)
        o[#o + 1] = s
    end

    w('<?xml version="1.0" encoding="UTF-8"?>')
    w('<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">')
    w('<plist version="1.0">')
    w("<dict>")
    w("\t<!-- Generated by tools/gen-yazi-flavors.lua, do not edit by hand. -->")
    w("\t<key>name</key>")
    w(string.format("\t<string>Nushu %s</string>", variant == "dark" and "Dark" or "Light"))
    w("\t<key>settings</key>")
    w("\t<array>")
    w("\t\t<dict>")
    w("\t\t\t<key>settings</key>")
    w("\t\t\t<dict>")
    for _, kv in ipairs({
        { "background", ui.bg },
        { "foreground", ui.fg },
        { "caret", ui.cursor_bg },
        { "lineHighlight", ui.bg_cursorline },
        { "selection", ui.bg_visual },
        { "invisibles", ui.whitespace },
    }) do
        w(string.format("\t\t\t\t<key>%s</key>", kv[1]))
        w(string.format("\t\t\t\t<string>%s</string>", kv[2]))
    end
    w("\t\t\t</dict>")
    w("\t\t</dict>")
    for _, rule in ipairs(rules) do
        w("\t\t<dict>")
        w(string.format("\t\t\t<key>name</key>\n\t\t\t<string>%s</string>", rule[1]))
        w(string.format("\t\t\t<key>scope</key>\n\t\t\t<string>%s</string>", rule[2]))
        w("\t\t\t<key>settings</key>")
        w("\t\t\t<dict>")
        w(string.format("\t\t\t\t<key>foreground</key>\n\t\t\t\t<string>%s</string>", rule[3]))
        w("\t\t\t</dict>")
        w("\t\t</dict>")
    end
    w("\t</array>")
    w("</dict>")
    w("</plist>")

    return table.concat(o, "\n") .. "\n"
end

-- : }}}

-- : Flavor packaging {{{

local LICENSE_HEADER = [[
MIT License

Copyright (c) 2026 Hunter Jennings

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local function write(path, contents)
    local dir = vim.fn.fnamemodify(path, ":h")
    vim.fn.mkdir(dir, "p")
    local f = assert(io.open(path, "w"), "cannot write " .. path)
    f:write(contents)
    f:close()
end

local function readme(variant, tones)
    local names = {}
    for _, name in ipairs({ "red", "orange", "yellow", "green", "cyan", "blue", "purple", "pink", "grey" }) do
        names[#names + 1] = string.format("| %s | `%s` |", name, tones[name])
    end
    return string.format(
        [[
# Nushu %s (yazi flavor)

The yazi half of [nushu.nvim](https://github.com/h-jennings/nushu.nvim) — a port
of the Nushu theme, warm brown-black backgrounds with a GitHub Primer-derived
accent set.

Generated from the Neovim theme's palette by `tools/gen-yazi-flavors.lua`. Do not
edit by hand; override styles in your own `theme.toml`, which yazi merges on top.

## Install

Copy both variants into your yazi config directory:

    ~/.config/yazi/flavors/nushu-dark.yazi/
    ~/.config/yazi/flavors/nushu-light.yazi/

then in `~/.config/yazi/theme.toml`:

    [flavor]
    dark  = "nushu-dark"
    light = "nushu-light"

## Icon tones

yazi's icon set hardcodes 725 Material Design colors at a median saturation of
0.76. They're mapped by hue onto nine nushu tones, pinned to one saturation and
lightness so they read as a family rather than a rainbow:

| Tone | %s |
| --- | --- |
%s

## License

MIT, same as nushu.nvim. `tmtheme.xml` likewise (`LICENSE-tmtheme`).
]],
        variant == "dark" and "Dark" or "Light",
        variant,
        table.concat(names, "\n")
    )
end

-- : }}}

local total_icons = 0
for _, variant in ipairs({ "dark", "light" }) do
    -- colors.lua memoizes the resolved theme on the nushu module, so without
    -- this reset the light pass re-emits the dark palette.
    package.loaded["nushu.colors"] = nil
    package.loaded["nushu.themes"] = nil
    local nushu = require("nushu")
    nushu._CURRENT_THEME = nil
    local colors = require("nushu.colors").setup({ theme = variant })

    local tones = icon_tones(colors.palette, variant)
    local icon_section, n = icons(string.format("%s/tools/vendor/yazi-theme-%s.toml", repo, variant), tones)
    total_icons = total_icons + n

    local dir = string.format("%s/extras/yazi/nushu-%s.yazi", repo, variant)
    write(dir .. "/flavor.toml", chrome(colors, variant, tones) .. "\n" .. icon_section)
    write(dir .. "/tmtheme.xml", tmtheme(colors, variant))
    write(dir .. "/README.md", readme(variant, tones))
    write(dir .. "/LICENSE", LICENSE_HEADER)
    write(dir .. "/LICENSE-tmtheme", LICENSE_HEADER)

    io.write(string.format("nushu-%s.yazi   %d icon colors re-toned\n", variant, n))
    local ordered = {}
    for _, name in ipairs({ "red", "orange", "yellow", "green", "cyan", "blue", "purple", "pink", "grey" }) do
        ordered[#ordered + 1] = name .. "=" .. tones[name]
    end
    io.write("  tones: " .. table.concat(ordered, " ") .. "\n")
end
io.write(string.format("done — %d icon entries across 2 flavors\n", total_icons))
