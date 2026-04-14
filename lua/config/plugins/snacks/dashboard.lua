return {
  enabled = true,

  sections = {
    -- HEADER ASCII
    {
      section = "header",
      val = {
        "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        "████╗  ██║██║   ██║██║████╗ ████║",
        "██╔██╗ ██║██║   ██║██║██╔████╔██║",
        "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      },
      padding = 1,
    },

    -- ACCIONES
    {
      icon = " ",
      title = "操作\n",
      section = "keys",
      gap = 1,
      padding = 1,
    },

    -- BOTÓN EXTRA
    {
      pane = 2,
      icon = " ",
      desc = "エクスプローラーを開く",
      key = "e",
      action = function()
        Snacks.explorer()
      end,
      padding = 1,
    },

    -- RECIENTES
    {
      pane = 2,
      icon = " ",
      title = "最近のファイル",
      section = "recent_files",
      indent = 2,
      padding = 1,
    },

    -- PROYECTOS
    {
      pane = 2,
      icon = " ",
      title = "プロジェクト",
      section = "projects",
      indent = 2,
      padding = 1,
    },

    -- GIT STATUS
    {
      pane = 2,
      icon = " ",
      title = "Git状態",
      section = "terminal",
      enabled = function()
        return Snacks.git.get_root() ~= nil
      end,
      cmd = "git status --short --branch",
      height = 8,
      padding = 1,
      indent = 2,
    },

    -- STARTUP
    {
      section = "startup",
    },
  },
}
