{
  lib,
  enable ? true,
  shellPackage,
  binaryPath,
}:

{
  home.sessionVariables."TERM_PREFERRED" = lib.mkIf enable (
    "${shellPackage}${binaryPath}"
  );
}