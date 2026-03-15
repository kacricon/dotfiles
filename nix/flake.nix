{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          # terminal tools
          pkgs.universal-ctags
          pkgs.neovim
          pkgs.ripgrep
          pkgs.git
          pkgs.git-lfs
          pkgs.tree
          pkgs.tlrc
          pkgs.exercism
          pkgs.terminal-notifier

          # yazi and dependencies
          pkgs.yazi
          pkgs.zoxide
          pkgs.ffmpegthumbnailer
          pkgs.unar
          pkgs.jq
          pkgs.poppler_utils
          pkgs.fd
          pkgs.fzf
        ];

      # Fonts
      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      ];

      # Homebrew integration for GUI apps and packages not available in nixpkgs
      homebrew = {
        enable = true;
        onActivation = {
          cleanup = "zap";  # Uninstall packages not declared here
          autoUpdate = true;
          upgrade = true;
        };

        taps = [
          "caarlos0/tap"
        ];

        brews = [
          "caarlos0/tap/timer"  # Not available in nixpkgs
        ];

        casks = [
          # GUI applications
          "arc"
          "discord"
          "fantastical"
          "figma"
          "kitty"
          "notion"
          "obsidian"
          "rectangle"
          "vitals"
        ];

        masApps = {
          "reMarkable" = 1276493162;
        };
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#laptop
    darwinConfigurations."laptop" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."laptop".pkgs;
  };
}
