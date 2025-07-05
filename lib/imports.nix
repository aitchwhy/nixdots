# Utility functions for module imports
{ lib, ... }:

rec {
  # Standard auto-import function for .nix files
  autoImport = dir:
    with builtins;
    let
      dirContents = readDir dir;
    in
    map
      (fn: dir + "/${fn}")
      (filter
        (fn: 
          fn != "default.nix" && 
          lib.hasSuffix ".nix" fn &&
          dirContents.${fn} == "regular"
        )
        (attrNames dirContents));

  # Auto-import with exclusion list
  autoImportExclude = dir: excludes:
    with builtins;
    let
      dirContents = readDir dir;
    in
    map
      (fn: dir + "/${fn}")
      (filter
        (fn: 
          fn != "default.nix" && 
          lib.hasSuffix ".nix" fn &&
          dirContents.${fn} == "regular" &&
          !(elem fn excludes)
        )
        (attrNames dirContents));

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
          isDarwin = system == "darwin" || lib.hasPrefix "darwin" system;
          isLinux = system == "linux" || lib.hasPrefix "linux" system;
        in
          # Include module if it's not platform-specific
          (!lib.hasInfix "darwin" moduleName && !lib.hasInfix "linux" moduleName && !lib.hasInfix "nixos" moduleName) ||
          # Or if it matches the current platform
          (isDarwin && lib.hasInfix "darwin" moduleName) ||
          (isLinux && (lib.hasInfix "linux" moduleName || lib.hasInfix "nixos" moduleName))
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