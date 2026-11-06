# NvChad-python v2.5-ready-1: suggested additive Python IDE patch

Verified against raw source of branch `v2.5-ready-1` on 2026-11-05.
This is a proposed configuration, NOT a commit pushed to GitHub.
Lua could not be executed in the artifact-generation environment; validate with `nvim`.

## Before changing anything

```bash
PROFILE=${NVIM_APPNAME:-nvim}
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/$PROFILE"
cp -a "$CONFIG_DIR" "$CONFIG_DIR.backup-$(date +%Y%m%d-%H%M%S)"
nvim --version | head -1
```

To copy files, place the **contents** of the `nvchad-python-patch/` directory
under `$CONFIG_DIR` (preserving its `lua/` paths). For your previously
observed `~/.config/nvim-python` profile, run Neovim with
`NVIM_APPNAME=nvim-python nvim` and use that config directory, not
`~/.config/nvim`. This replaces only:

* `lua/autocmds.lua`
* `lua/mappings.lua`
* `lua/plugins/init.lua`
* `lua/configs/conform.lua`

and adds `lua/python_tools.lua`.

Do not replace your existing `lua/configs/lspconfig.lua` (the branch already
has the BasedPyright + Ruff settings). Preserve `lua/chadrc.lua` and options.

## Compatibility

* The parent NvChad v2.5 config uses the *legacy* nvim-treesitter API.
* This patch pins nvim-treesitter to `master` (legacy) instead of the
  incompatible reworked `main`; use Neovim 0.11.x if you want the
  conservative compatibility route. Test carefully before switching to 0.12.
* Neovim 0.11+ is required for vim.lsp.config/vim.lsp.enable.

## Installation inside Nvim

```
:Lazy sync
:MasonUpdate
:MasonInstall basedpyright ruff debugpy stylua
:TSInstall python lua bash json toml
:checkhealth
:LspInfo
:ConformInfo
```

Restart Nvim after installation so the Python DAP configuration picks up
Mason's debugpy environment. `MasonInstallAll` is not a standard Mason command;
explicit installs are clearer.

For pytest, install it in the project environment, e.g.
`<project>/.venv/bin/python -m pip install pytest` if your project uses pip.
For uv/Poetry projects use the project's own dependency manager.

## Mappings (Space is leader)

- F5 or Space p r: run the current Python file in a full-size terminal tab
- Space p t: run pytest for current Python file
- Space p a: run pytest for entire project
- F6: debug start/continue; F9: breakpoint; F10/F11/F12: step over/in/out
- Space d q: end debugging; Space d r: DAP REPL
- Space c a: LSP code action; Space l r: references
- Space d d: diagnostic popup; ]d / [d: next/previous diagnostic
- Existing NvChad: Space f m format, gd definition, Space r a rename

When the terminal tab is open, send `q` to the snake game to quit it.
Then press Ctrl-\\ Ctrl-n to leave terminal-mode and `:q` to close the tab.
The usual NvChad `<C-x>` terminal-mode escape can also work.

## Notes

* The supplied snake requires a terminal at least 35 columns x 12 rows.
  A full new terminal tab avoids a too-short horizontal terminal split.
* Curses interactive apps may need a separate external terminal for DAP
  interactive debugging; F5 is meant for reliable play/run rather than DAP.
* The copied GitHub code in the prompt included HTML/Markdown escapes;
  the actual Python file needs `if __name__ == "__main__":`, `"*"`, etc.
* No files were changed in the user's real installation or GitHub repo.
