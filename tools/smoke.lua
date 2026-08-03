--- Clean-room checks that the colorscheme loads and behaves the way the README
--- documents. No user config is involved.
---
---     nvim -l tools/smoke.lua
---
--- Exits non-zero if any check fails, so CI can gate on it.

local repo = vim.fn.fnamemodify(vim.fn.resolve(debug.getinfo(1, "S").source:sub(2)), ":p:h:h")
vim.opt.runtimepath:prepend(repo)

local nushu = require("nushu")

local failures = 0

local function check(name, fn)
    -- Each check starts from stock config; setup() mutates module state.
    nushu.config = vim.deepcopy(nushu._DEFAULT_CONFIG)
    nushu._THEME_SET_BY_USER = nil
    local ok, err = pcall(fn)
    if ok then
        io.write("  ok    " .. name .. "\n")
    else
        failures = failures + 1
        io.write("  FAIL  " .. name .. "\n        " .. tostring(err) .. "\n")
    end
end

local function hl(name)
    return vim.api.nvim_get_hl(0, { name = name, link = false })
end

-- `g:colors_name` echoes the entry point that was used: plain "nushu" when
-- following 'background', and the variant's own name when one is pinned, which
-- is what lets Neovim re-source the right file.
for _, cs in ipairs({ "nushu", "nushu-dark", "nushu-light" }) do
    check(":colorscheme " .. cs, function()
        vim.cmd.colorscheme(cs)
        assert(vim.g.colors_name == cs, "colors_name is " .. tostring(vim.g.colors_name))
        assert(vim.g.nushu_variant, "nushu_variant unset")
        local n = hl("Normal")
        assert(n.fg and n.bg, "Normal has no fg/bg")
    end)
end

check("'background' switches the variant", function()
    vim.cmd.colorscheme("nushu")
    vim.o.background = "light"
    assert(vim.g.nushu_variant == "light", "expected light, got " .. tostring(vim.g.nushu_variant))
    vim.o.background = "dark"
    assert(vim.g.nushu_variant == "dark", "expected dark, got " .. tostring(vim.g.nushu_variant))
end)

-- Pinning is the regression-prone part: Neovim re-sources `g:colors_name` on
-- every 'background' change, so each of these asserts the pin survives it.
for _, variant in ipairs({ "dark", "light" }) do
    check(":colorscheme nushu-" .. variant .. " survives a 'background' change", function()
        vim.cmd.colorscheme("nushu-" .. variant)
        assert(vim.g.colors_name == "nushu-" .. variant, "colors_name is " .. tostring(vim.g.colors_name))
        vim.o.background = variant == "dark" and "light" or "dark"
        assert(vim.g.nushu_variant == variant, "pin lost, got " .. tostring(vim.g.nushu_variant))
        vim.o.background = "dark"
        assert(vim.g.nushu_variant == variant, "pin lost on second toggle")
    end)
end

check("plain :colorscheme nushu clears a previous pin", function()
    vim.cmd.colorscheme("nushu-light")
    vim.cmd.colorscheme("nushu")
    assert(vim.g.colors_name == "nushu", "colors_name is " .. tostring(vim.g.colors_name))
    vim.o.background = "light"
    assert(vim.g.nushu_variant == "light", "should follow 'background', got " .. tostring(vim.g.nushu_variant))
    vim.o.background = "dark"
    assert(vim.g.nushu_variant == "dark", "should follow 'background', got " .. tostring(vim.g.nushu_variant))
end)

-- "dark" is the default value, so this only pins if setup() records that the
-- key was passed rather than comparing it against the default.
for _, variant in ipairs({ "dark", "light" }) do
    check("setup{ theme = '" .. variant .. "' } pins the variant", function()
        nushu.setup({ theme = variant })
        vim.cmd.colorscheme("nushu")
        vim.o.background = variant == "dark" and "light" or "dark"
        assert(vim.g.nushu_variant == variant, "pin lost, got " .. tostring(vim.g.nushu_variant))
        vim.o.background = "dark"
    end)
end

check("lualine theme resolves under a pinned variant", function()
    vim.cmd.colorscheme("nushu-light")
    for _, mod in ipairs({ "lualine.themes.nushu-light", "lualine.themes.nushu" }) do
        package.loaded[mod] = nil
        local t = require(mod)
        assert(t.normal and t.normal.a and t.normal.a.bg, mod .. " missing normal.a.bg")
    end
end)

check("mapping both backgrounds to one variant pins it", function()
    nushu.setup({ background = { dark = "dark", light = "dark" } })
    vim.cmd.colorscheme("nushu")
    vim.o.background = "light"
    assert(vim.g.nushu_variant == "dark", "pin lost, got " .. tostring(vim.g.nushu_variant))
    vim.o.background = "dark"
end)

check("setup() after :colorscheme re-applies", function()
    vim.cmd.colorscheme("nushu")
    nushu.setup({ bold = false })
    assert(vim.g.colors_name == "nushu", "colorscheme lost")
end)

check("palette and highlight overrides apply", function()
    nushu.setup({
        colors = { palette = { darkBg = "#000000" } },
        overrides = function(colors)
            return { Normal = { fg = colors.theme.syn.string } }
        end,
    })
    vim.cmd.colorscheme("nushu-dark")
    local n = hl("Normal")
    assert(n.bg == 0x000000, "palette override ignored, bg=" .. tostring(n.bg))
    assert(n.fg == 0xa5d6ff, "overrides function ignored, fg=" .. tostring(n.fg))
end)

check("transparent drops backgrounds", function()
    nushu.setup({ transparent = true })
    vim.cmd.colorscheme("nushu-dark")
    assert(hl("Normal").bg == nil, "Normal still has a background")
end)

check("terminalColors populates the ANSI palette", function()
    vim.cmd.colorscheme("nushu-dark")
    assert(vim.g.terminal_color_0, "terminal_color_0 unset")
    assert(vim.g.terminal_color_15, "terminal_color_15 unset")
end)

check("lualine theme resolves", function()
    package.loaded["lualine.themes.nushu"] = nil
    local t = require("lualine.themes.nushu")
    assert(t.normal and t.normal.a and t.normal.a.bg, "missing normal.a.bg")
end)

if failures == 0 then
    io.write("\nall checks passed\n")
    os.exit(0)
end
io.write("\n" .. failures .. " check(s) failed\n")
os.exit(1)
