# Nushu Light (yazi flavor)

The yazi half of [nushu.nvim](https://github.com/h-jennings/nushu.nvim) — a port
of the Nushu theme: warm cream backgrounds
with a GitHub Primer-derived accent set.

Generated from the Neovim theme's palette by `tools/gen-yazi-flavors.lua` in that
repository. Do not edit by hand; override styles in your own `theme.toml`, which
yazi merges on top and which always wins.

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

| Tone | Hex |
| --- | --- |
| red | `#913b41` |
| orange | `#915e3b` |
| yellow | `#91743b` |
| green | `#3b9154` |
| cyan | `#3b8b91` |
| blue | `#3b6391` |
| purple | `#593b91` |
| pink | `#913b70` |
| grey | `#7a766b` |

## License

MIT, same as nushu.nvim. `tmtheme.xml` likewise (`LICENSE-tmtheme`).
