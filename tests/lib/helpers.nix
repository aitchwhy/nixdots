# Test helper functions for nixdots
{ pkgs, lib, ... }:

rec {
  # Test that a module evaluates without errors
  testModuleEval = module: args:
    let
      evaluated = builtins.tryEval (import module args);
    in
    {
      success = evaluated.success;
      module = toString module;
      error = if evaluated.success then null else "Module evaluation failed";
    };

  # Test that imports resolve correctly
  testImports = module:
    let
      hasImports = module ? imports;
      importsExist = if hasImports 
        then builtins.all (imp: builtins.pathExists imp) module.imports
        else true;
    in
    {
      success = importsExist;
      module = toString module;
      error = if importsExist then null else "Some imports do not exist";
    };

  # Test for circular dependencies
  testNoCycles = modules: visited:
    let
      checkModule = module: visited:
        if builtins.elem module visited
        then { success = false; cycle = visited ++ [module]; }
        else
          let
            moduleContent = import module {};
            hasImports = moduleContent ? imports;
            newVisited = visited ++ [module];
          in
            if hasImports
            then builtins.all (imp: (checkModule imp newVisited).success) moduleContent.imports
            else { success = true; };
    in
      builtins.all (m: (checkModule m []).success) modules;

  # Test that a package list is valid
  testPackageList = packages:
    let
      allValid = builtins.all (pkg: pkg ? name) packages;
    in
    {
      success = allValid;
      error = if allValid then null else "Invalid package in list";
    };

  # Test directory structure conventions
  testDirectoryStructure = {
    # Check no packages in modules/home/packages/
    noUserPackagesInModules = !builtins.pathExists ./modules/home/packages;
    
    # Check features only contains system features
    featuresValid = let
      featureFiles = builtins.attrNames (builtins.readDir ./features);
      validFeatures = [ "nix.nix" "shell.nix" "users.nix" ];
    in
      builtins.all (f: builtins.elem f validFeatures) featureFiles;
    
    # Check required directories exist
    requiredDirsExist = builtins.all builtins.pathExists [
      ./modules/darwin
      ./modules/nixos
      ./modules/shared
      ./modules/home
      ./users
      ./machines
      ./lib
      ./features
    ];
  };

  # Run all tests and collect results
  runTests = tests:
    let
      results = builtins.mapAttrs (name: test: test) tests;
      failures = lib.filterAttrs (name: result: !result.success) results;
      failureCount = builtins.length (builtins.attrNames failures);
    in
    {
      success = failureCount == 0;
      total = builtins.length (builtins.attrNames tests);
      passed = (builtins.length (builtins.attrNames tests)) - failureCount;
      failed = failureCount;
      failures = failures;
      results = results;
    };
}