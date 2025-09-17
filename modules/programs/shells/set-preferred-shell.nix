{
  lib,
  enable,
  shellPackage,
  binaryPath,

}:

/*
  Having `enable` as an argument lets us unconditionally import this function, 
  avoiding infinite recursion due to imports being evaluated "eagerly".
*/
{
  home.file.".config/environment.d/90-shell.conf" = lib.mkIf enable {
    text = ''
      SHELL=${shellPackage}${binaryPath}
    '';
  };
}