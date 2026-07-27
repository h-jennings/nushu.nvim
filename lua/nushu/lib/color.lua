local M = {}

---@param hex string "#rrggbb"
---@return integer r, integer g, integer b
local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---@param r integer
---@param g integer
---@param b integer
---@return string hex "#rrggbb"
local function rgb_to_hex(r, g, b)
    return string.format("#%02x%02x%02x", r, g, b)
end

--- Blend `fg` over `bg` at the given opacity. Nushu's source themes lean on
--- alpha channels (selections, diff line backgrounds, indent guides) that
--- nvim_set_hl cannot express, so those colors are pre-blended to opaque
--- hexes at theme-build time.
---@param fg string foreground color "#rrggbb"
---@param bg string background color "#rrggbb"
---@param alpha number opacity of fg, 0..1
---@return string hex "#rrggbb"
function M.blend(fg, bg, alpha)
    local fr, fg_, fb = hex_to_rgb(fg)
    local br, bg_, bb = hex_to_rgb(bg)
    local function channel(f, b)
        return math.floor(f * alpha + b * (1 - alpha) + 0.5)
    end
    return rgb_to_hex(channel(fr, br), channel(fg_, bg_), channel(fb, bb))
end

return M
