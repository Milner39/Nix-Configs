{
  shellPackage,
  binaryPath
}:

{
  home.file.".config/environment.d/90-shell.conf" = {
    text = ''
      SHELL=${shellPackage}${binaryPath}
    '';
  };
}