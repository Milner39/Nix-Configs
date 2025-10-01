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
        builtins.substring 0 1 contentName != "_" &&
        dirContent.${contentName} == "directory"
      )
      (builtins.attrNames dirContent);

  in subDirNames;



  # Function to build a single module
  buildModule = { file, args } : let
    fileExists = builtins.pathExists file;

    module = (if fileExists
      then (
        let file = (import file args);
        in {
          options = if file ? options then file.options else {};
          config = {
            config = if file ? config then file.config else {};
            imports = if file ? imports then file.imports else [];
          };
        }
      )

      else {
        options = {};
        config = {};
      }
    );

  in module;



  # Function to recursively traverse directory and build module tree
  buildModuleTree = { dir, args, path } : let
    # Get the module in the current directory
    currentModule = buildModule {
      file = dir + "/default.nix";
      args = args // { configRelative = (lib.attrByPath path {} configRoot); };
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


    # Merge modules
    result = {
      # Use the current module's options and merge in the submodules' options
      options = currentModule.options // submodulesOptions;
      config = lib.mkMerge ([ currentModule.config ] ++ submodulesConfigs);
    };

  in result;

  # === Functions ===




  # Create the module tree
  result = buildModuleTree {
    dir = ./.;
    args = args // { inherit configRoot; };
    path = [ moduleRootName ];
  };

in
{
  options.${moduleRootName} = result.options;
  config = result.config;
}