{
  homeConfigurations = {
    dev = (builtins.getFlake "path:../flakes/homes/dev")
      .outputs.homeConfigurations.dev;
  };
}