-------------------------------------------------------
-- Format on save
-------------------------------------------------------

-- For clangd / rust_analyzer / gopls / ruff / ts_ls / html / cssls,
-- format-on-save uses each server's own LSP formatting support
-- (LspAttach autocmd at the bottom of this file).

-- lua_ls isn't used for formatting, so Lua is formatted on save by
-- shelling out to stylua instead. Runs via stdin/stdout, wrapped
-- in pcall, so a missing/failing formatter is a silent no-op rather than
-- something that errors on every save or corrupts the buffer.
local function format_with_stdin(cmd)
  return function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local input = table.concat(lines, "\n") .. "\n"
    local ok, result = pcall(function()
      return vim.system(cmd, { stdin = input, text = true }):wait()
    end)
    if ok and result.code == 0 and result.stdout and #result.stdout > 0 then
      local view = vim.fn.winsaveview()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(result.stdout, "\n", { trimempty = true }))
      vim.fn.winrestview(view)
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = format_with_stdin({ "stylua", "-" }),
  desc = "Format Lua on save with stylua",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf

    -- Capability is checked at save time, not here: some servers (ruff)
    -- register formatting dynamically after LspAttach fires. One augroup per
    -- buffer so multiple attached clients don't stack duplicate hooks.
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("lsp_format_" .. bufnr, { clear = true }),
      buffer = bufnr,
      callback = function()
        if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/formatting" }) > 0 then
          vim.lsp.buf.format({ bufnr = bufnr, async = false, timeout_ms = 2000 })
        end
      end,
      desc = "Format on save via LSP",
    })
  end,
})
