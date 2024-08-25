{ config, pkgs, lib, ... }:
{
    # =============== GENERAL =============== #
    home.username = "dexter";
    home.homeDirectory = "/home/dexter";

    nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
            "steam"
            "steam-original"
            "steam-run"
        ];


    home.packages = [
        # PACKAGES

        # Useful
        pkgs.brave
        pkgs.btop
        pkgs.tree

        # Programming
        pkgs.rustup

        # Misc
        pkgs.freetube
        pkgs.vesktop
        pkgs.steam

        # Theming
        pkgs.bibata-cursors
        pkgs.sweet
        pkgs.candy-icons

        # Fonts
        (pkgs.nerdfonts.override { fonts = [ "Iosevka" "0xProto" ]; })
    ];

    home.file = {
        ".icons/default".source =
            "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice";
    };

    home.sessionVariables = {
        EDITOR = "nvim";
        XDG_CONFIG_HOME = "${config.home.homeDirectory}/bin/config";
        XDG_CACHE_HOME = "${config.home.homeDirectory}/bin/cache";
        XDG_DATA_HOME = "${config.home.homeDirectory}/bin/local/share";
        ZDOTDIR = "${config.home.homeDirectory}/bin/zsh";
        RUSTUP_HOME = "${config.home.homeDirectory}/.config/Languages/rustup";
        PATH = "${config.home.homeDirectory}/.config/Languages/cargo/bin:$PATH";
    };

    # =============== HOME DIRECTORY =============== #
    # homeDirectory = {
    #     directories = {
    #         "bin" = {};
    #         "Downloads" = {};
    #         "nixos" = {};
    #         "Personal" = {};
    #     };
    # };

    # xdg.configFile = {
    #     zshrc = "~/bin/zshrc";
    # };

    # =============== DOTFILES =============== #
    git = {
        enable = true;
        userName = "Dexter Hedman";
        userEmail = "dexterhedman05@proton.me";

        ignores = [ "*~" "*.swp" ];
        extraConfig = {
            init.defaultBranch = "main";
            pull.rebase = false;
        };
    };

    zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        envExtra = ''
            export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
        '';
    };

    bat.enable = true;
    zoxide.enable = true;
    fzf.enable = true;

    # =============== GTK =============== #
    gtk.enable = true;

    gtk.cursorTheme.package = pkgs.bibata-cursors;
    gtk.cursorTheme.name = "Bibata-Modern-Ice";

    gtk.theme.package = pkgs.nordic;
    gtk.theme.name = "Nordic";

    gtk.iconTheme.package = pkgs.candy-icons;
    gtk.iconTheme.name = "candy-icons";

    # =============== QT =============== #
    qt.enable = true;

    # =============== DON'T TOUCH! =============== #
    home.stateVersion = "24.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
