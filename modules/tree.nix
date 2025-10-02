{
  config,
  lib,
  ...
} @ args:

let
  # === Constants ===

  # Name for the "root" of the custom module tree
  # All sub modules will be available under this attribute
  # Example: `./programs/shells/bash`
  # Becomes: `${moduleRootName}.programs.shells.bash`
  moduleRootName = "modules";

  # For readability
  configRoot = config;

  # === Constants ===



  # === Functions ===

  # Function to get the names of subdirectories in a directory
  getSubdirNames = dir : let
    dirContent = builtins.readDir dir;

    subDirNames = builtins.filter
      (contentName: # Filter to get directories that don't start with "_"
        (builtins.substring 0 1 contentName) != "_" &&
        dirContent.${contentName} == "directory"
      )
      (builtins.attrNames dirContent);

  in subDirNames;



  # Function to build a single module
  buildModule = { file, args } : let
    fileExists = builtins.pathExists file;

    module = ({
      # Defaults
      options = {};
      config = {};
      imports = [];
    } // (if fileExists then (import file args) else {}));

  in module;



  # Function to recursively traverse directory and build module tree
  buildModuleTree = { dir, args, path } : let
    # Get the module in the current directory
    currentModule = buildModule {
      file = dir + "/default.nix";
      args = args // {
        # Pass the configuration for this module tree directly
        # avoiding infinite recursion by not reading from final config
        moduleConfig = lib.attrByPath path {} configRoot.${moduleRootName} or {};
      };
    };


    # Get submodules by the name of the folder they are in
    submodules = builtins.listToAttrs (map (dirName: {
      name = dirName;
      value = buildModuleTree {
        dir = dir + "/${dirName}";
        args = args;
        path = path ++ [ dirName ];
      };
    }) (getSubdirNames dir));

    # Get submodules' options by name of submodule
    submodulesOptions = builtins.mapAttrs 
      (_: v: v.options) 
      submodules;

    # Get submodules' configs in a list
    submodulesConfigs = builtins.attrValues (builtins.mapAttrs
      (_: v: v.config) 
      submodules);

    # Get submodules' imports in a flattened list
    submodulesImports = lib.flatten (builtins.attrValues (builtins.mapAttrs
      (_: v: v.imports)
      submodules));


    result = {
      # Use the current module's options and merge in the submodules' options as attrs
      options = currentModule.options // submodulesOptions;

      # Merge modules using lib.mkMerge for proper module system integration
      config = lib.mkMerge ([ currentModule.config ] ++ submodulesConfigs);

      # Collect all imports from the current module and submodules
      imports = currentModule.imports ++ submodulesImports;
    };

  in result;

  # === Functions ===




  # Create the module tree
  result = buildModuleTree {
    dir = ./.;
    args = args // { inherit configRoot; };
    path = [ ];
  };

in
{
  options.${moduleRootName} = result.options;
  config = result.config;
  imports = result.imports;
}