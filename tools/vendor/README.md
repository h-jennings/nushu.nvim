# Vendored yazi theme presets

Verbatim copies of yazi's built-in presets (`yazi-config/preset/theme-{dark,light}.toml`),
vendored because yazi compiles them into the binary — there's no copy on disk to
read at generation time.

Currently from **yazi v26.5.6**.

`tools/gen-yazi-flavors.lua` reads only `[icon]` out of these, the one section
where yazi hardcodes color. Everything else in the presets uses ANSI color names,
which already resolve through nushu's terminal palette, so the generator writes
those sections from `lua/nushu/themes.lua` instead.

## Refreshing after a yazi upgrade

```sh
tag=v26.5.6   # set to the new version
base=https://raw.githubusercontent.com/sxyazi/yazi/$tag/yazi-config/preset
curl -sfL $base/theme-dark.toml  -o tools/vendor/yazi-theme-dark.toml
curl -sfL $base/theme-light.toml -o tools/vendor/yazi-theme-light.toml
nvim -l tools/gen-yazi-flavors.lua
```

Then update the version above. New *icon* entries are picked up automatically;
a new theme *section* needs adding to the generator's template, and until then
falls back to yazi's own preset value.
