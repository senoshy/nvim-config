{
  symlinkJoin,
  neovim-unwrapped,
  makeWrapper,
  vimPlugins,
  runCommand,
  lib,
  pkgs,
  inputs ? null,
  plugin_srcs ? {},
  plugin_revs ? {},
}: let
  extraPlugins = import ./nix/plugins-extra.nix {
    inherit lib;
    vimUtils = pkgs.vimUtils;
    plugin_srcs = plugin_srcs;
    plugin_revs = plugin_revs;
  };

  plugins = with vimPlugins;
    [
      lualine-nvim
      base16-nvim
      tokyodark-nvim
      material-nvim
      indent-blankline-nvim
      auto-session
      which-key-nvim
      nvim-autopairs
      oil-nvim
      snacks-nvim
      todo-comments-nvim
      plenary-nvim
      nvim-web-devicons
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      luasnip
      friendly-snippets
      cord-nvim
      nvim-lspconfig
      cmp-nvim-lsp
      nvim-navic
      nvim-tree-lua
      diffview-nvim
      gitsigns-nvim
      nvim-treesitter.withAllGrammars
      vimtex
      bufferline-nvim
      (pkgs.vimUtils.buildVimPlugin {
        pname = "vim-table-mode";
        version = "bb025308";
        src = pkgs.fetchFromGitHub {
          owner = "dhruvasagar";
          repo = "vim-table-mode";
          rev = "bb025308a45c67c7c8f0763ba37bc2ee3f534df0";
          sha256 = "0mkq8v8l9zbl2l12whzsnbz3fmg7ssqk4qb2syw8hxw1j9sb8wm0";
        };
      })
      direnv-vim
      (pkgs.vimUtils.buildVimPlugin {
        pname = "neovim-ayu";
        version = "unstable-2026-01-09";
        src = pkgs.fetchFromGitHub {
          owner = "shatur";
          repo = "neovim-ayu";
          rev = "e5a9f0fa2918d6b5f57c21b3ac014314ee5e41c8";
          hash = "sha256-L53zl5XYPvT8gPpPC4IyYpK1CZk7Iv6au3xYu6OD/uY=";
        };
        doCheck = false;
      })
    ]
    ++ extraPlugins;

  allPlugins = lib.unique (
    let
      collectDeps = plugin: [plugin] ++ (lib.concatMap collectDeps (plugin.dependencies or []));
    in
      lib.concatMap collectDeps plugins
  );

  extraPackages = import ./nix/bin.nix {inherit pkgs inputs;};

  packpath = runCommand "nvim-packpath" {} ''
    mkdir -p $out/pack/nix/start
    ${lib.concatMapStringsSep "\n" (
        plugin: "ln -sf ${plugin} $out/pack/nix/start/${lib.getName plugin}"
      )
      allPlugins}
  '';
in
  symlinkJoin {
    name = "neovim-custom";
    paths = [neovim-unwrapped];
    nativeBuildInputs = [makeWrapper];

    propagatedBuildInputs = extraPackages;

    postBuild = ''
      wrapProgram $out/bin/nvim \
        --prefix PATH : ${lib.makeBinPath extraPackages} \
        --add-flags '--cmd "lua vim.opt.packpath:prepend(\"${packpath}\")"' \
        --add-flags '--cmd "lua vim.opt.rtp:prepend(\"${packpath}\")"' \
        --add-flags '--cmd "lua vim.opt.rtp:prepend(\"${./.}\")"' \
        --add-flags '--cmd "lua vim.g.nix_managed = true"' \
        --add-flags '-u "${./init.lua}"'
    '';

    passthru = {
      inherit packpath;
      unwrapped = neovim-unwrapped;
    };
  }
