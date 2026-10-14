{
  config,
  lib,
  ...
}:

let
  cfg = config.services.storage;
in
{
  options.services.storage = {
    enable = lib.mkEnableOption "udisks2 and wheel polkit rules for removable storage";
  };

  config = lib.mkIf cfg.enable {
    services.udisks2.enable = true;

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel") &&
            (action.id == "org.freedesktop.udisks2.filesystem-mount-other-seat" ||
             action.id == "org.freedesktop.udisks2.filesystem-unmount-others"))
          return polkit.Result.YES;
      });
    '';
  };
}
