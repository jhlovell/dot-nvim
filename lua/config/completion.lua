-------------------------------------------------------
-- Native LSP autocomplete (vim.lsp.completion, no plugins)
-------------------------------------------------------

-- Native completion menu behavior
vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
  desc = "Enable native LSP completion",
})
