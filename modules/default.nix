{ pkgs, lib, ... }:

{
    imports = [
        ./nixos/bspwm.nix
        ./nixos/picom.nix
        ./nixos/sddm.nix
        ./nixos/xserver.nix
        ./nixos/main-user.nix
        ./nixos/river.nix
    ];

    xserver.enable =
        lib.mkDefault true;
    bspwm.enable =
        lib.mkDefault true;
    picom.enable =
        lib.mkDefault true;
    sddm.enable =
        lib.mkDefault true;
    river.enable =
        lib.mkDefault false;
    river.enableWayland =
        lib.mkDefault false;
}
