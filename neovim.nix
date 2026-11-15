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
      cord-nvim
      oil-nvim 
      nvim-autopairs
      fzf-lua
      nvim-cmp
    ]
    ++
    [(pkgs.vimUtils.buildVimPlugin {
        pname = "mini.nvim";
        version = "0.18.0";
        src = pkgs.fetchFromGitHub {
          owner = "nvim-mini";
          repo = "mini.nvim";
          tag = "v0.18.0";
          hash = "sha256-kCcyl4KUEY51UeGYmvuLD1hswWbwKhHGUt/0XLbPuUw=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        pname = "render-markdown.nvim";
        version = "8.14.0";
        src = pkgs.fetchFromGitHub {
          owner = "MeanderingProgrammer";
          repo = "render-markdown.nvim";
          tag = "v8.14.0";
          hash = "sha256-pG8lAo4qucIu+gAwrEaK79VkDFTLcuuPBYhq3sg951E=";
        };
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
        --prefix PATH : ${lib.makeBinPath extraPackages}         \
        --add-flag --cmd                                          \
        --add-flag 'lua vim.opt.packpath:prepend("${packpath}")'  \
        --add-flag --cmd                                          \
        --add-flag 'lua vim.opt.rtp:prepend("${packpath}")'       \
        --add-flag --cmd                                          \
        --add-flag 'lua vim.opt.rtp:prepend("${./.}")'            \
        --add-flag --cmd                                          \
        --add-flag 'lua vim.g.nix_managed = true'                 \
        --add-flag -u                                             \
        --add-flag ${./init.lua}
    '';

    passthru = {
      inherit packpath;
      unwrapped = neovim-unwrapped;
    };
  }
