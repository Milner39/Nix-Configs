{
  config,
  lib,
  ...
} @ args:

let
  # Create the "root" of the custom module tree
  # All sub modules will be available under this attribute
  # Example: `./programs/shells/bash` will be `modules.programs.shells.bash`
  moduleRootName = "modules";


  # Create args for root module
  moduleRootArgs = args // {
    configRoot = config;
    configRelative = config.${moduleRootName};
  };



# === ⣏⡱ ⣏⡉ ⡎⠑ ⡇⢸ ⣏⡱ ⢎⡑ ⡇ ⡎⢱ ⡷⣸   ⢉⠝ ⡎⢱ ⡷⣸ ⣏⡉ ===
# === ⠇⠱ ⠧⠤ ⠣⠔ ⠣⠜ ⠇⠱ ⠢⠜ ⠇ ⠣⠜ ⠇⠹   ⠮⠤ ⠣⠜ ⠇⠹ ⠧⠤ ===

  # Function to get the names of subdirectories (modules) in a directory
  getSubdirNames = dir : let
    dirContent = builtins.readDir dir;
    submodules = builtins.filter
      (contentName: # Filter to get directories that don't start with "_"
        builtins.substring 0 1 contentName != "_" &&
        dirContent.${contentName} == "directory"
      )
      (builtins.attrNames dirContent);
  in submodules;



  # Function to build a single module
  buildModule = { file, args } : let
    fileExists = builtins.pathExists file;
    module = (if fileExists
      then (
        let file = (import file args); 
        in {
          options = file.options;
          config = (builtins.removeAttrs file [ "options" ]);
        }
      )
      else {
        options = {};
        config = {};
      }
    );
  in module;



  # Function to recursively traverse directory and build module tree
  buildModuleTree = { dir, args } : let
    # Get the module in the current directory
    currentModule = buildModule {
      file = dir + ./default.nix;
      args = args;
    };


    # Get submodules by the name of the folder they are in
    submodules = builtins.listToAttrs (map (dirName: {
      name = dirName;
      value = buildModuleTree {
        dir = dir + "/${dirName}";
        args = args // { configRelative = args.configRelative.dirName; };
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

# === ⣏⡱ ⣏⡉ ⡎⠑ ⡇⢸ ⣏⡱ ⢎⡑ ⡇ ⡎⢱ ⡷⣸   ⢉⠝ ⡎⢱ ⡷⣸ ⣏⡉ ===
# === ⠇⠱ ⠧⠤ ⠣⠔ ⠣⠜ ⠇⠱ ⠢⠜ ⠇ ⠣⠜ ⠇⠹   ⠮⠤ ⠣⠜ ⠇⠹ ⠧⠤ ===


  # Create the module tree
  result = buildModuleTree {
    dir = ./.;
    args = moduleRootArgs;
  };

in
{
  options.${moduleRootName} = result.options;
  config = result.config;
}