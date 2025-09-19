{
  lib,
  enable ? true,
  shellPackage,
  binaryPath,
}:

{
  home.environmentVariables."TERM_PREFERRED" = lib.mkIf enable (
    "${shellPackage}${binaryPath}"
  );
}