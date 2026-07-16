# Troubleshooting

## Nvim hangs on `:q` after sleep/wake (esp. in tmux)

**Symptom.** After the machine sleeps and wakes, quitting nvim freezes for several seconds (sometimes tens of seconds) before returning to the shell. Only happens on the first quit after wake; not reproducible on a fresh nvim.

**Cause: LSP shutdown timeout.**

On exit, nvim graceful-shuts every LSP client: sends `shutdown`, waits for a response, sends `exit`, and only force-kills after an internal timeout. LSP subprocesses started before sleep are often in a broken state after wake — the pipes are stale but the process still exists — so nvim sits per client waiting for a `shutdown` reply that never comes. With ~14 servers enabled from `lua/sankar/plugins/mason.lua` (`bashls`, `pyright`, `biome`, `jsonls`, `marksman`, `tailwindcss`, `ts_ls`, `html`, `cssls`, `dockerls`, `lemminx`, `lua_ls`, `mdx_analyzer`, `vimls`), even a few hung ones compound into a long freeze.

Tmux is not the cause — it's just where the freeze is visible. Nvim is holding the shell.

**Confirm before applying the fix.**

- `:qa!` exits instantly, `:q` hangs → LSP confirmed. (`qa!` skips graceful client shutdown.)
- `:lua =vim.lsp.get_clients()` before quitting — dead pids or unresponsive servers in `:LspInfo` are the smoking gun.

**Fix — force-stop LSP on exit.**

Add to `lua/sankar/configs/vim-config.lua` (or another config file loaded at startup):

```lua
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    vim.lsp.stop_client(vim.lsp.get_clients(), true)  -- 2nd arg = force
  end,
})
```

The `true` skips the graceful `shutdown` request and kills client processes outright, so a hung server can't hold up exit.

**Secondary suspect: clipboard provider.**

`vim.opt.clipboard = 'unnamedplus'` shells out to `pbpaste`/`pbcopy` through nvim's clipboard provider on macOS. Right after wake, the pasteboard server can be briefly slow, which sometimes stalls yank-heavy sessions on exit. Much rarer than LSP. If the LSP fix doesn't fully cure it, isolate by setting `vim.g.clipboard = nil` before `:q` and see if the hang disappears.
