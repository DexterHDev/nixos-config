{ config, pkgs, lib, ... }:
let dmenu = pkgs.dmenu.override(
{
    patches = [
        ./dmenu-patches/dmenu-center-20240616-36c3d68.diff
        ./dmenu-patches/dmenu-linesbelowprompt-and-fullwidth-20211014.diff
    ];
});
in
{
    imports = [
#        ../../modules/home-manager/unfree.nix
        ../../modules/home-manager/variables.nix
    ];

    # =============== GENERAL =============== #

    home.username = "dexter";
    home.homeDirectory = "/home/dexter";

    nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
            "steam"
            "steam-original"
            "steam-run"
            "spotify"
        ];

    home.packages = [
        # PACKAGES

        # Useful
        pkgs.brave
        pkgs.btop
        pkgs.tree
        pkgs.ripgrep
        pkgs.xdg-ninja
        pkgs.gnupg
        pkgs.pinentry
        pkgs.pass
        pkgs.protonmail-bridge
        pkgs.neomutt
        pkgs.offlineimap
        pkgs.w3m
        pkgs.mailcap
        dmenu

        # Misc
        pkgs.freetube
        pkgs.steam
        pkgs.spotify
        pkgs.vesktop
        pkgs.oh-my-posh
        pkgs.fzf
        pkgs.mupdf
        pkgs.libreoffice
        pkgs.flameshot
        pkgs.direnv

        # Theming
        pkgs.bibata-cursors
        pkgs.sweet
        pkgs.candy-icons
        pkgs.xbanish

        # Fonts
        (pkgs.nerdfonts.override { fonts = [ "Iosevka" "0xProto" ]; })
        pkgs.times-newer-roman
    ];

#    unfree = {
#        enable = true;
#        steam = true;
#        spotify = true;
#    };
 
    variables = {
        enable = true;
        xdg = true;
        cleaning = true;
        languages = true;
        nvim = true;
        kitty = true;
    };

    home.file = {
        "${config.xdg.dataHome}/icons/default".source =
            "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice";
    };

    # =============== HOME DIRECTORY =============== #

    home.activation.cleanup =
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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

            ignores = [ "*~" "*.swp" ];
            extraConfig = {
                init.defaultBranch = "main";
                pull.rebase = false;
            };
        };

        neovim = 
        let
            toLua = str: "lua << EOF\n${str}\nEOF\n";
            toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
        in
        {
            enable = true;
            defaultEditor = true;

            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;

             extraLuaConfig = ''
                 ${builtins.readFile ./nvim/core/options.lua}
                 ${builtins.readFile ./nvim/core/keymaps.lua}
             '';

            extraPackages = with pkgs; [
                # LSP servers
                lua-language-server
                nil
                rust-analyzer
                gopls

                xclip
            ];

            plugins = with pkgs.vimPlugins; [
                # Theme
                {
                    plugin = catppuccin-nvim;
                    config = toLuaFile ./nvim/plugins/catppuccin.lua;
                }
                
                # Telescope
                {
                    plugin = telescope-nvim;
                    config = toLuaFile ./nvim/plugins/telescope.lua;
                }
                telescope-fzf-native-nvim

                # Lualine
                {
                    plugin = lualine-nvim;
                    config = toLuaFile ./nvim/plugins/lualine.lua;
                }

                # Oil
                {
                    plugin = oil-nvim;
                    config = toLuaFile ./nvim/plugins/oil.lua;
                }

                # Treesitter
                {
                    plugin = (nvim-treesitter.withPlugins (p: [
                        p.tree-sitter-nix
                        p.tree-sitter-lua
                        p.tree-sitter-rust
                        p.tree-sitter-bash
                    ]));
                    config = toLuaFile ./nvim/plugins/treesitter.lua;
                }

                # LSP
                {
                    plugin = nvim-lspconfig;
                    config = toLuaFile ./nvim/plugins/lspconfig.lua;
                }

                # Harpoon
                {
                    plugin = harpoon2;
                    config = toLuaFile ./nvim/plugins/harpoon.lua;
                }

                # Extensions
                nvim-web-devicons
                plenary-nvim

                vim-nix
             ];
        };


        bat.enable = true;
        zoxide.enable = true;
        fzf.enable = true;
    };

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
