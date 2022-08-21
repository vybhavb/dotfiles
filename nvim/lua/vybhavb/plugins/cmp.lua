local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

local function init(...)
  local cmp = require'cmp'

  local source_mapping = {
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    cmp_tabnine = "[TN]",
    Copilot = "",
    path = "[Path]",
  }

  local lspkind = require("lspkind")

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ behavior= cmp.ConfirmBehavior.Replace, select = true }),
      ['<C-n>'] = cmp.mapping({
        c = function()
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
            end
        end,
        i = function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end
        }),
      ['<C-p>'] = cmp.mapping({
        c = function()
          if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
              vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
          end
        end,
        i = function(fallback)
          if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
              fallback()
          end
        end
      }),
    }),
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol",
        max_width = 50,
        symbol_map = {
          Copilot = "",
          cmp_tabnine = "[TN]"
        }
      })
    },
    sources = cmp.config.sources({
      { name = "copilot", group_index = 2 },
      { name = "cmp_tabnine" , group_index = 2 },
      { name = 'nvim_lsp' , group_index = 2 },
      { name = 'path', group_index = 2 },
      { name = 'luasnip' , group_index = 2 }, -- For luasnip users.
      { name = 'buffer' },
   })
  })
  -- Use buffer source for `/`.
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':'.
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})

  local tabnine = require("cmp_tabnine.config")
  tabnine:setup({
    max_lines = 1000,
    max_num_results = 5,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = "..",
  })
end

return {
  init = init
}
