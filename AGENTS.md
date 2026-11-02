# AGENTS.md

Guidance for AI coding agents working in this repository.

## What this repo is

A personal Neovim configuration written in Lua, packaged as a Nix flake. It supports two modes from a single codebase:

- **Nix-managed mode**: `nix build` / `nix run` produces a wrapped `nvim` (`neovim-custom`) with every plugin and external tool (LSP servers, formatters, etc.) pinned and provided by Nix.
- **Standalone mode**: plain Neovim using `lazy.nvim` to fetch plugins at runtime (pinned by `lazy-lock.json`).

The Lua namespace is `riu` (`lua/riu/...`).

## Repository layout

```
init.lua            Entry point. Loads riu.core, then riu.nix or riu.lazy
lua/riu/            All Lua config (core options/keymaps, plugin setup)
flake.nix           Flake: nixpkgs (nixos-unstable) + alejandra; exposes packages.x86_64-linux.{neovim-custom,default}
flake.lock          Pinned flake inputs
neovim.nix          Builds the wrapped Neovim: plugin list, packpath, PATH, wrapper flags
nix/                Helper Nix files (plugins-extra.nix for extra plugins, bin.nix for external binaries)
lazy-lock.json      lazy.nvim lockfile (standalone mode only)
```

## How startup works (read before changing anything)

`init.lua` always runs `require("riu.core")`, then branches on `vim.g.nix_managed`:

```lua
require("riu.core")
if vim.g.nix_managed then
  require("riu.nix")    -- plugins already on packpath via Nix
else
  require("riu.lazy")   -- lazy.nvim bootstraps and installs plugins
end
```

`neovim.nix` wraps `nvim` so that it:

1. prepends a generated packpath (all plugins symlinked into `pack/nix/start`) to `packpath` and `rtp`,
2. prepends the repo source directory to `rtp` (so `require("riu...")` resolves),
3. sets `vim.g.nix_managed = true`,
4. launches with `-u <repo>/init.lua`,
5. prefixes `PATH` with the binaries from `nix/bin.nix`.

Consequences:

- **Plugin configuration must work in both modes.** Put shared plugin settings in modules that both `riu.nix` and `riu.lazy` can load. Do not call `lazy.nvim` APIs from code that runs in Nix mode, and do not assume plugins are missing from the runtime path in Nix mode.
- **Never hardcode paths** to `~/.config/nvim` or the Nix store in Lua. Use `vim.fn.stdpath(...)` or `require` by module name.
- **Never install tools at runtime in Nix mode** (no Mason-style installers). External tools belong in `nix/bin.nix`.

## Common tasks

### Add or change a plugin

1. Add the plugin spec/setup under `lua/riu/` following how existing plugins are organized (check neighboring files first and match their structure).
2. Standalone mode: register it in the `riu.lazy` plugin specs, then run `:Lazy sync` to update `lazy-lock.json`.
3. Nix mode: add it to the `plugins` list in `neovim.nix` (use `vimPlugins.<name>` from nixpkgs when it exists). For plugins missing from nixpkgs, either use `pkgs.vimUtils.buildVimPlugin` with `fetchFromGitHub` and a pinned `rev` + hash (as done for `vim-table-mode` and `neovim-ayu`) or add it to `nix/plugins-extra.nix`.
4. Keep both modes in sync: a plugin present in one list but not the other is a bug.

### Add an LSP server, formatter, or other external tool

Add the package to `nix/bin.nix` so it is on `PATH` in Nix mode, then configure it in Lua. Do not rely on tools being installed globally.

### Update dependencies

- Flake inputs: `nix flake update` (or `nix flake lock --update-input <name>`).
- lazy.nvim plugins: `:Lazy update` then commit `lazy-lock.json`.
- Unpinned fetches: when bumping a `fetchFromGitHub` plugin, update `rev` and the hash together.

## Build, run, and verify

There is no test suite. Verify changes with these checks:

```sh
nix flake check                     # evaluates the flake
nix build .#neovim-custom           # builds the wrapped Neovim
./result/bin/nvim --headless +qa    # starts and exits; should print no errors
nix run .                           # interactive smoke test
```

For Lua-only changes you can also sanity-check startup without Nix:

```sh
nvim --headless "+lua require('riu.core')" +qa
```

Before reporting work as done, run the headless startup check and confirm there are no error messages. If you cannot run Nix or Neovim in your environment, say so explicitly rather than claiming the change works.

## Code style

- **Lua**: 2-space indentation, `local` for everything that is not an intentional export, small modules that return a table or call `setup()`. Prefer `vim.keymap.set` with a `desc` field on every mapping (needed for which-key). Prefer `vim.api.nvim_create_autocmd` with a named augroup over `vim.cmd` autocommands.
- **Nix**: formatted with [alejandra](https://github.com/kamadorueda/alejandra) (a flake input). Run `nix run github:kamadorueda/alejandra -- .` or the repo's pinned version before committing.
- Match the surrounding file's conventions before introducing a new style.

## Boundaries

- **Do not edit** `flake.lock` or `lazy-lock.json` by hand. Regenerate them with the commands above.
- **Do not commit** build outputs (`result`, `result-*`) or local state; keep `.gitignore` up to date.
- **Do not add** new top-level dependencies, plugin managers, or a different config namespace without asking. The `riu` namespace and the dual Nix/lazy layout are intentional.
- **Do not weaken pinning**: no floating `rev`/`branch` for Nix-fetched plugins, no `latest` tags.
- Keep changes small and focused. One concern per commit, with a short imperative commit message.

## When unsure

If a change touches how Neovim is launched (`neovim.nix` wrapper flags, `init.lua` branching, `riu.nix` / `riu.lazy`), explain the reasoning and the effect on both modes before making it. A mistake there breaks startup entirely.
