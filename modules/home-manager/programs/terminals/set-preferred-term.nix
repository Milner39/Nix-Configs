{
  lib,
  enable ? true,
  package,
  binaryPath,
}:

{
  home.sessionVariables."TERM_PREFERRED" = lib.mkIf enable (
    "${package}${binaryPath}"
  );
}