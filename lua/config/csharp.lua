vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  pattern = "*.cs",
  callback = function()
    -- Solo si el archivo está vacío
    if vim.api.nvim_buf_line_count(0) > 1 then
      return
    end

    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    if first_line ~= "" then
      return
    end

    local filename = vim.fn.expand("%:t:r")
    local filepath = vim.fn.expand("%:p:h")

    -- ROOT = donde abriste nvim
    local cwd = vim.fn.getcwd()

    local namespace = ""

    if cwd and filepath:find(cwd, 1, true) then
      local relative = filepath:sub(#cwd + 2)
      namespace = relative:gsub("[/\\]", ".")

      -- quitar punto inicial si aparece
      namespace = namespace:gsub("^%.", "")
    end

    -- Detectar tipo
    local tipo = "class"

    if filename:match("^I[A-Z]") then
      tipo = "interface"
    end

    if filepath:lower():match("interfaces") then
      tipo = "interface"
    end

    local lines = {}

    -- Namespace en bloque
    if namespace ~= "" then
      table.insert(lines, "namespace " .. namespace)
      table.insert(lines, "{")
      table.insert(lines, "")
    end

    -- Clase / Interface
    if tipo == "interface" then
      table.insert(lines, "    public interface " .. filename)
      table.insert(lines, "    {")
      table.insert(lines, "    }")
    else
      table.insert(lines, "    public class " .. filename)
      table.insert(lines, "    {")
      table.insert(lines, "    }")
    end

    if namespace ~= "" then
      table.insert(lines, "}")
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

    vim.cmd("normal! gg=G")

    local cursor_line = namespace ~= "" and 5 or 3
    vim.api.nvim_win_set_cursor(0, { cursor_line, 4 })
  end,
})
