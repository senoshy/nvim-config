local nixmng = vim.g.nix_managed

require("senoshy.core")

if nixmng then
    require("senoshy.nix")
else
    require("senoshy.lazy")
end
