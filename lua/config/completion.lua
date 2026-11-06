-------------------------------------------------------
-- Native LSP autocomplete (vim.lsp.completion, no plugins)
-------------------------------------------------------

-- Native completion menu behavior
vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- Show the menu as you type, collecting items from the 'complete' sources.
-- Without LSP this is plain buffer-word completion.
vim.opt.autocomplete = true

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      -- autotrigger still handles non-keyword trigger characters like "." and "::"
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

      -- "o" = the LSP omnifunc; listed first so server results get priority
      -- over buffer words. Buffer-local so non-LSP buffers are unaffected.
      local cpt = vim.opt_local.complete
      if not vim.tbl_contains(cpt:get(), "o") then
        cpt:prepend("o")
      end
    end
  end,
  desc = "Enable native LSP completion",
})
