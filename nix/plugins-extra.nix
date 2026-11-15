{
  lib,
  vimUtils,
  plugin_srcs ? {},
  plugin_revs ? {},
}: let
  mk = name: src: rev:
    if src == null
    then null
    else
      vimUtils.buildVimPlugins {
        pname = name;
        version =
          if rev == null
          then null
          else "rev-" + rev;
        src = src;

        doCheck = false;
      };
in
  lib.filter (x: x != null) []
