{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ../../modules/home-manager/variables.nix ];

  # =============== GENERAL =============== #

  home.username = "dexter";
  home.homeDirectory = "/home/dexter";

  home.packages = with pkgs; [
    # PACKAGES

    # Useful
    brave
    btop
    tree
    ripgrep
    xdg-ninja
    gnupg
    pinentry
    pass
    protonmail-bridge
    neomutt
    offlineimap
    w3m
    mailcap
    qmk
    psmisc
    rofi
    yazi

    # Misc
    freetube
    vesktop
    oh-my-posh
    fzf
    mupdf
    libreoffice
    flameshot
    direnv
    sayonara
    pciutils
    usbutils
    xbanish
    xclip
    fastfetch

    # Theming
    catppuccin-cursors.mochaDark
    sweet
    candy-icons

    # Fonts
    nerd-fonts.jetbrains-mono
    times-newer-roman
    maple-mono-NF
  ];

  variables = {
    enable = true;
    xdg = true;
    cleaning = true;
    languages = true;
    nvim = true;
    kitty = true;
    eww = true;
  };

  # =============== HOME DIRECTORY =============== #

  home.activation.cleanup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -rf ~/.gnupg
    rm -f ~/.gtkrc-2.0
    rm -rf ~/.icons
    rm -rf ~/.compose-cache
    rm -rf ~/.nix-defexpr
    rm -rf ~/.nix-profile
    rm -rf ~/.w3m
    rm -rf ~/.wine
    rm -f ~/.zcompdump
  '';

  # =============== CONFIGS =============== #

  programs = {
    git = {
      enable = true;
      userName = "Dexter Hedman";
      userEmail = "dexterhedman05@proton.me";

      ignores = [
        "*~"
        "*.swp"
      ];
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };

    bat.enable = true;
    zoxide.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  # =============== GTK =============== #

  gtk = {
    enable = true;
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
    iconTheme = {
      package = pkgs.candy-icons;
      name = "candy-icons";
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
    };
    cursorTheme.size = 25;
  };

  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
    package = pkgs.catppuccin-cursors.mochaDark;
    name = "catppuccin-mocha-dark-cursors";
    size = 25;
  };

  # =============== QT =============== #

  qt.enable = true;

  # =============== DON'T TOUCH! =============== #

  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
