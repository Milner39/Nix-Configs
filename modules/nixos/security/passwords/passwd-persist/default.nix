{
  moduleConfig,
  lib,
  ...
} @ args:

let
  # Get module configuration
  cfg = moduleConfig;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description =

''
Whether to use custom `passwd-persist` script for updating users' 
`hashedPasswordFile`.

The following functionality will only be enabled for users in the `users` 
option list.


When the system is started up: the `activate` script should check if there is a 
non-empty file at `/etc/passwd-persist/hashedPasswordFiles/<user>`

  a) If the file exists, update the password for that user in `/etc/shadow`.
     This is already handled by NixOS since we set the user's hashed password 
     file.

  b) If the file does not exist, create the file and get the hashed password 
     from `/etc/shadow`

When the `passwd-persist` command is used:

  1) The existing `passwd` command will be used to handle the authentication 
     and the updating of `/etc/shadow`.
  
  2) The script will get the new value from `/etc/shadow` and update the 
     hashed password file for that user.
'';

      default = false;
      type = lib.types.bool;
    };

    "users" = lib.mkOption {
      description = "Which users should this module be enabled for.";
      default = null;
      type = lib.types.listOf lib.types.str;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {
    # Allow users' passwords to be changed
    users.mutableUsers = true;
  };
  # === Config ===


  # === Imports ===
  imports = [
    (import ./_scripts args)
  ];
  # === Imports ===
}