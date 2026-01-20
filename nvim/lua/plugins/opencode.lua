return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Required for ask() and select()
      -- Required for snacks provider
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      -- Configuration for opencode
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        provider = {
          enabled = "terminal",
        },
        events = {
          reload = false,
        },
      }

      -- Required for opts.events.reload
      vim.o.autoread = true

      -- Leader-based keymaps
      vim.keymap.set({ "n", "x" }, "<leader>oa", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask opencode" })

      vim.keymap.set({ "n", "x" }, "<leader>ox", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })

      vim.keymap.set({ "n", "t" }, "<leader>ot", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })

      -- Operator mappings for range-based operations
      vim.keymap.set({ "n", "x" }, "go", function()
        return require("opencode").operator("@this ")
      end, { expr = true, desc = "Add range to opencode" })

      vim.keymap.set("n", "goo", function()
        return require("opencode").operator("@this ") .. "_"
      end, { expr = true, desc = "Add line to opencode" })

      -- Navigation commands for session control
      vim.keymap.set("n", "<leader>ou", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "Opencode half page up" })

      vim.keymap.set("n", "<leader>od", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "Opencode half page down" })

      -- Event handling
      vim.api.nvim_create_autocmd("User", {
        pattern = "OpencodeEvent:*",
        callback = function(args)
          ---@type opencode.cli.client.Event
          local event = args.data.event
          ---@type number
          local port = args.data.port

          -- Do something useful
          if event.type == "session.idle" then
            vim.notify("`opencode` finished responding")
          end
        end,
      })
    end,
  },
}