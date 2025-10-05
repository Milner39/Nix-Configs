{
  homeConfigurations = {
    # dev = (builtins.getFlake ("path:" + toString ../flakes/homes/dev))
    #   .outputs.homeConfigurations.dev;

    # dev = (import ../flakes/homes/dev/flake.nix)
    #   .outputs.homeConfigurations.dev;
  };
}