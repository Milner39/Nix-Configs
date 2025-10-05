{
  outputs = { flake-parts, ... } @ inputs: 
  flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [];  # Not using `perSystem`, errors if unset

    flake = {
      imports = [ ./outputs ];
    };
  };



  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
}