return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nsidorenco/neotest-vstest",
  },
  config = function()
    local sep = package.config:sub(1, 1)

    local function get_sdk_path()
      local handle = io.popen("dotnet --list-sdks")
      if not handle then
        return nil
      end

      local output = handle:read("*a") or ""
      handle:close()

      local sdk = output:match("%b[]")
      if not sdk then
        return nil
      end

      local path = sdk:sub(2, -2)
      if path == "" then
        return nil
      end

      if not path:match("[\\/]$") then
        path = path .. sep
      end

      return path
    end

    vim.g.neotest_vstest = {
      sdk_path = get_sdk_path(),
      timeout_ms = 30 * 5 * 1000,
      broad_recursive_discovery = true,
      discovery_directory_filter = function(search_path)
        local normalized = search_path:gsub("\\", "/")
        return normalized:match("/%.git$")
          or normalized:match("/%.vs$")
          or normalized:match("/bin$")
          or normalized:match("/obj$")
          or normalized:match("/node_modules$")
      end,
    }

    local neotest = require("neotest")

    local function current_file()
      return vim.fn.expand("%:p")
    end

    local function current_dir()
      return vim.fn.expand("%:p:h")
    end

    local function nearest_project_file()
      local file = current_file()
      if file == "" then
        return nil
      end

      local start_dir = vim.fs.dirname(file)
      local projects = vim.fs.find(function(name, _)
        return name:match("%.csproj$") or name:match("%.fsproj$")
      end, {
        upward = true,
        type = "file",
        path = start_dir,
        limit = 1,
      })

      return projects[1]
    end

    require("neotest").setup({
      summary = {
        open = "topleft vsplit | vertical resize 50",
      },
      adapters = {
        require("neotest-vstest"),
      },
    })

    vim.keymap.set("n", "<leader>tt", function()
      local proj = nearest_project_file()
      if proj then
        neotest.run.run(proj)
      else
        neotest.run.run(current_dir())
      end
    end, { desc = "Test nearest (project fallback)" })

    vim.keymap.set("n", "<leader>tf", function()
      local proj = nearest_project_file()
      if proj then
        neotest.run.run(proj)
      else
        neotest.run.run(current_dir())
      end
    end, { desc = "Test file (project fallback)" })

    vim.keymap.set("n", "<leader>tp", function()
      neotest.run.run(current_dir())
    end, { desc = "Test project" })

    vim.keymap.set("n", "<leader>ta", function()
      neotest.run.run(vim.fn.getcwd())
    end, { desc = "Test all" })

    vim.keymap.set("n", "<leader>ts", function()
      neotest.summary.open()
    end, { desc = "Test summary open" })

    vim.keymap.set("n", "<leader>to", function()
      neotest.output.open({ enter = true })
    end, { desc = "Test output" })
  end,
}
