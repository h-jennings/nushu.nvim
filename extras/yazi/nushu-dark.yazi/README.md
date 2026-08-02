# Nushu Dark (yazi flavor)

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

| Tone | dark |
| --- | --- |
| red | `#c37d79` |
| orange | `#c39879` |
| yellow | `#c3ad79` |
| green | `#79c384` |
| cyan | `#79bec3` |
| blue | `#799cc3` |
| purple | `#9879c3` |
| pink | `#c379a1` |
| grey | `#7e746a` |

## License

MIT, same as nushu.nvim. `tmtheme.xml` likewise (`LICENSE-tmtheme`).
