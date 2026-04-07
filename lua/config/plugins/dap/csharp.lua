local dap = require("dap")

-- Guardamos el cwd original globalmente
local original_cwd = nil

dap.adapters.coreclr = {
  type = "executable",
  command = "D:/Tools/netcoredbg/netcoredbg.exe",
  args = { "--interpreter=vscode" },
}

-- Restaurar cwd cuando termina el debug
local function restore_cwd()
  if original_cwd and vim.fn.isdirectory(original_cwd) == 1 then
    vim.fn.chdir(original_cwd)
    vim.notify("CWD restaurado a: " .. original_cwd, vim.log.levels.INFO)
    original_cwd = nil
  end
end

dap.listeners.after.event_terminated["restore_cwd"] = restore_cwd
dap.listeners.after.event_exited["restore_cwd"] = restore_cwd

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - smart (ultimate)",
    request = "launch",

    env = {
      ASPNETCORE_ENVIRONMENT = "Development"
    },

    program = function()
      local cwd = vim.fn.getcwd()

      -- Buscar .csproj recursivamente
      local function scan_for_csproj(dir)
        local results = {}
        local handle = vim.loop.fs_scandir(dir)
        if not handle then return results end

        while true do
          local name, type = vim.loop.fs_scandir_next(handle)
          if not name then break end

          local full_path = dir .. "/" .. name

          if type == "file" and name:match("%.csproj$") then
            table.insert(results, full_path)
          elseif type == "directory" and name ~= "bin" and name ~= "obj" then
            local sub = scan_for_csproj(full_path)
            for _, v in ipairs(sub) do table.insert(results, v) end
          end
        end

        return results
      end

      local projects = scan_for_csproj(cwd)

      if #projects == 0 then
        vim.notify("No se encontraron .csproj", vim.log.levels.ERROR)
        return ""
      end

      -- Filtrar ejecutables
      local executable_projects = {}

      for _, path in ipairs(projects) do
        local content = table.concat(vim.fn.readfile(path), "\n")

        if content:match("<OutputType>Exe</OutputType>") then
          table.insert(executable_projects, path)
        end
      end

      -- Fallback heurístico
      if #executable_projects == 0 then
        for _, path in ipairs(projects) do
          if path:match("%.API%.csproj$") or path:match("%.Web%.csproj$") then
            table.insert(executable_projects, path)
          end
        end
      end

      if #executable_projects == 0 then
        vim.notify("No se encontró proyecto ejecutable", vim.log.levels.ERROR)
        return ""
      end

      -- Selección de proyecto
      local selected

      if #executable_projects == 1 then
        selected = executable_projects[1]
      else
        local choices = {}
        for _, p in ipairs(executable_projects) do
          table.insert(choices, p)
        end

        local choice = vim.fn.inputlist(
          vim.list_extend({ "Selecciona proyecto:" }, choices)
        )

        if choice < 1 or choice > #choices then
          return ""
        end

        selected = choices[choice]
      end

      local project_dir = vim.fn.fnamemodify(selected, ":h")
      local project_name = vim.fn.fnamemodify(selected, ":t:r")

      -- Guardar cwd original SOLO una vez
      if not original_cwd then
        original_cwd = vim.fn.getcwd()
      end

      -- Cambiar cwd SOLO para debug
      vim.fn.chdir(project_dir)

      -- 🔨 Build
      vim.notify("Building: " .. project_name, vim.log.levels.INFO)
      vim.fn.system("dotnet build \"" .. project_dir .. "\"")

      -- Buscar bin/Debug/netX.X
      local debug_dir = project_dir .. "/bin/Debug/"
      local handle = vim.loop.fs_scandir(debug_dir)

      if not handle then
        vim.notify("No existe Debug folder. Ejecuta dotnet build", vim.log.levels.ERROR)
        return ""
      end

      local target_dir = nil

      while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end

        if type == "directory" and name:match("^net") then
          target_dir = debug_dir .. name .. "/"
          break
        end
      end

      if not target_dir then
        vim.notify("No se encontró carpeta netX.X", vim.log.levels.ERROR)
        return ""
      end

      -- DLL principal
      local expected_dll = target_dir .. project_name .. ".dll"

      if vim.fn.filereadable(expected_dll) == 1 then
        vim.notify("Debugging: " .. expected_dll, vim.log.levels.INFO)
        return expected_dll
      end

      -- fallback DLL
      local handle2 = vim.loop.fs_scandir(target_dir)
      while true do
        local name, type = vim.loop.fs_scandir_next(handle2)
        if not name then break end

        if type == "file" and name:match("%.dll$") then
          local dll_path = target_dir .. name
          vim.notify("Fallback DLL: " .. dll_path, vim.log.levels.WARN)
          return dll_path
        end
      end

      vim.notify("No se encontró ningún DLL", vim.log.levels.ERROR)
      return ""
    end,
  },
}
