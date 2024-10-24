{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];

  imports = [
    inputs.home-manager.nixosModules.default
    ./hardware-configuration.nix
  ];

  # =============== SYSTEM SETTINGS =============== #

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "dexter";
  networking.networkmanager.enable = true;

  # Dbus
  services.dbus.enable = true;
  services.seatd.enable = true;

  # Timezone
  time.timeZone = "Europe/Stockholm";

  # Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # TTY settings
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Audio
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # dconf
  programs.dconf.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.xbanish.enable = true;

  # System-wide packages
  environment.systemPackages = with pkgs; [
    polybar
    feh
    kitty
    git
    yazi
    pwvucontrol
    catppuccin-sddm-corners
    wget
    unzip
    xbanish
    nixfmt-rfc-style
  ];

  # Home manager
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "dexter" = import ./home.nix;
    };
  };

  # Set main user
  main-user.enable = true;
  main-user.userName = "dexter";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # DO NOT TOUCH!!!!!
  system.stateVersion = "24.05";

  # =============== GAMING =============== #
  programs.steam.enable = true;

  services.udev = {
    enable = true;
    packages = with pkgs; [
      xpad
      xboxdrv
    ];
  };

  systemd.services.xboxdrv = {
    description = "Xbox Controller Daemon";
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.xboxdrv}/bin/xboxdrv --daemon --detach --mimic-xpad --deadzone 4000";
      Restart = "always";
    };
  };
}
