# Utility functions for module imports
{ lib, ... }:

rec {
  # Standard auto-import function for .nix files
  autoImport = dir:
    with builtins;
    map
      (fn: dir + "/${fn}")
      (filter
        (fn: fn != "default.nix" && hasSuffix ".nix" fn)
        (attrNames (readDir dir)));

  # Auto-import with exclusion list
  autoImportExclude = dir: excludes:
    with builtins;
    map
      (fn: dir + "/${fn}")
      (filter
        (fn: 
          fn != "default.nix" && 
          hasSuffix ".nix" fn &&
          !(elem fn excludes)
        )
        (attrNames (readDir dir)));

  # Import all subdirectories that contain default.nix
  autoImportDirs = dir:
    with builtins;
    map
      (subdir: dir + "/${subdir}")
      (filter
        (subdir:
          let
            subdirPath = dir + "/${subdir}";
            subdirType = readDir dir;
          in
            subdirType.${subdir} == "directory" &&
            pathExists (subdirPath + "/default.nix")
        )
        (attrNames (readDir dir)));

  # Filter imports by platform
  filterByPlatform = system: modules:
    with builtins;
    filter
      (module:
        let
          moduleName = baseNameOf (toString module);
          isDarwin = system == "darwin" || hasPrefix "darwin" system;
          isLinux = system == "linux" || hasPrefix "linux" system;
        in
          # Include module if it's not platform-specific
          (!hasInfix "darwin" moduleName && !hasInfix "linux" moduleName && !hasInfix "nixos" moduleName) ||
          # Or if it matches the current platform
          (isDarwin && hasInfix "darwin" moduleName) ||
          (isLinux && (hasInfix "linux" moduleName || hasInfix "nixos" moduleName))
      )
      modules;

  # Safely import a module with error handling
  safeImport = path: default:
    if builtins.pathExists path
    then import path
    else default;

  # Import and merge multiple modules
  importAndMerge = modules: args:
    lib.mkMerge (map (m: import m args) modules);
}