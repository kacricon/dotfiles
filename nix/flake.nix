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
          pkgs.poppler-utils
          pkgs.fd
          pkgs.fzf

          # languages
          pkgs.python3
        ];

      # Fonts
      fonts.packages = [
        pkgs.nerd-fonts.symbols-only
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
          "claude-code"
          "codex"
          "discord"
          "fantastical"
          "figma"
          "google-chrome"
          "kitty"
          "notion"
          "obsidian"
          "qobuz"
          "rectangle"
          "roon"
          "vitals"
          "zen"
        ];

        masApps = {};
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;

      # Keyboard remapping (specs/macos.md)
      system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };

      # macOS system preferences (specs/macos.md)
      system.defaults = {
        dock = {
          autohide = true;
          minimize-to-application = true;
        };

        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          FXPreferredViewStyle = "Nlsv";
          ShowPathbar = true;
        };

        NSGlobalDomain = {
          KeyRepeat = 2;
          InitialKeyRepeat = 15;
          "com.apple.swipescrolldirection" = true;
        };

        screencapture = {
          location = "~/Screenshots";
          disable-shadow = true;
        };

        trackpad = {
          Clicking = true;
        };

        CustomUserPreferences = {
          "com.apple.dock" = {
            appswitcher-all-displays = true;
          };
          "com.knollsoft.Rectangle" = {
            launchOnLogin = true;
            alternateDefaultShortcuts = true;
            gapSize = 5.0;
            subsequentExecutionMode = 1;  # cycle through sizes
            snapEdgeMarginTop = 5.0;
            snapEdgeMarginBottom = 5.0;
            snapEdgeMarginLeft = 5.0;
            snapEdgeMarginRight = 5.0;
          };
        };
      };

      # Ensure ~/Screenshots directory exists
      system.activationScripts.extraActivation.text = ''
        sudo -u jrc mkdir -p /Users/jrc/Screenshots
      '';

      # Primary user for user-scoped defaults and homebrew
      system.primaryUser = "jrc";

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
