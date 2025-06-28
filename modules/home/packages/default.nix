# Auto-import all package category modules
{
  imports =
    with builtins;
    map
      (fn: ./${fn})
      (filter 
        (fn: fn != "default.nix" && hasSuffix ".nix" fn) 
        (attrNames (readDir ./.)));
}