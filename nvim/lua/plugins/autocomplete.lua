-- ~/.config/nvim/lua/plugins.lua
return {
  -- Other plugins...

  -- CMP and dependencies
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer", -- Buffer completions
      "hrsh7th/cmp-path", -- Path completions
      "hrsh7th/cmp-cmdline", -- Command line completions
      "saadparwaiz1/cmp_luasnip", -- Snippet completions
      "hrsh7th/cmp-nvim-lsp", -- LSP completions
      "L3MON4D3/LuaSnip", -- Snippet engine
      "mlaursen/vim-react-snippets",
      "rafamadriz/friendly-snippets", -- A collection of snippets
    },
    config = function()
      -- CMP configuration
      local cmp = require("cmp")
      require("vim-react-snippets").lazy_load()
      local luasnip = require("luasnip")

      require("luasnip/loaders/from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })

      -- Use buffer source for `/` and `?`
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}
