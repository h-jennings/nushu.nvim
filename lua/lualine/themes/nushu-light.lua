-- Alias so lualine's `theme = "auto"` keeps resolving when the light variant is
-- pinned: pinning sets vim.g.colors_name to "nushu-light", and lualine looks up
-- lualine/themes/<colors_name>. The shared module already builds itself from
-- whichever variant is active.
return require("lualine.themes.nushu")
