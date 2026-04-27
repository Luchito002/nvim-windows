local function enhance(hex, factor, sat_boost)
  local r = tonumber(hex:sub(2, 3), 16)
  local g = tonumber(hex:sub(4, 5), 16)
  local b = tonumber(hex:sub(6, 7), 16)

  local function boost(c)
    return math.min(255, math.floor(c + (255 - c) * factor))
  end

  r, g, b = boost(r), boost(g), boost(b)

  local avg = (r + g + b) / 3

  local function saturate(c)
    return math.max(0, math.min(255, math.floor(c + (c - avg) * sat_boost)))
  end

  r, g, b = saturate(r), saturate(g), saturate(b)

  return string.format("#%02x%02x%02x", r, g, b)
end

local base_colors = {
  "#8A6A6A",
  "#8A845F",
  "#6A7F95",
  "#8A7A65",
  "#6F8A6F",
  "#7F6A8A",
  "#6A8A8A",
}

local function set_indent_hl()
  for i, color in ipairs(base_colors) do
    vim.api.nvim_set_hl(0, "SnacksIndent" .. i, {
      fg = enhance(color, 0.20, 0.45),
    })

    vim.api.nvim_set_hl(0, "SnacksIndentScope" .. i, {
      fg = enhance(color, 0.65, 0.90),
      bold = true,
    })
  end
end

set_indent_hl()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_indent_hl,
})

return {
  enabled = false,

  indent = {
    char = "┊",
    hl = {
      "SnacksIndent1",
      "SnacksIndent2",
      "SnacksIndent3",
      "SnacksIndent4",
      "SnacksIndent5",
      "SnacksIndent6",
      "SnacksIndent7",
    },
  },

  scope = {
    enabled = true,
    char = "┊",
    hl = {
      "SnacksIndentScope1",
      "SnacksIndentScope2",
      "SnacksIndentScope3",
      "SnacksIndentScope4",
      "SnacksIndentScope5",
      "SnacksIndentScope6",
      "SnacksIndentScope7",
    },
  },

  animate = {
    enabled = true,
    style = "out",
  },
}
