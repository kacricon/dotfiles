{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, hermes-agent }:
  let
    configuration = { lib, pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          # terminal tools
          pkgs.universal-ctags
          pkgs.neovim
          pkgs.tree-sitter
          pkgs.ripgrep
          pkgs.git
          pkgs.git-lfs
          pkgs.tree
          pkgs.tlrc
          pkgs.exercism
          pkgs.terminal-notifier
          pkgs.codex

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
          pkgs.bun
          pkgs.nodejs
          pkgs.python3

          # GUI apps available in nixpkgs
          pkgs.daisydisk

          # external flakes
          hermes-agent.packages.aarch64-darwin.default
        ];

      # Ensure Homebrew commands are available in new shells on Apple Silicon.
      environment.systemPath = [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
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
          extraFlags = ["--force-cleanup"];
        };

        taps = [
          "caarlos0/tap"
        ];

        brews = [
          "caarlos0/tap/timer"  # Not available in nixpkgs
          "rtk"  # Not available in nixpkgs
        ];

        casks = [
          # GUI applications
          "claude-code"
          "codex-app"
          "discord"
          "fantastical"
          "google-chrome"
          "helium-browser"
          "kitty"
          "obsidian"
          "qobuz"
          "rectangle"
          "spotify"
          "stremio"
          "vitals"
        ];

        masApps = {};
      };

      # Determinate Nix owns the Nix installation, daemon, and nix.conf.
      nix.enable = false;

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

      # Allow only explicitly approved unfree nixpkgs packages.
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "daisydisk"
      ];
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

    # Used by setup.sh for the first switch, before darwin-rebuild is installed.
    packages.aarch64-darwin.darwin-rebuild = nix-darwin.packages.aarch64-darwin.darwin-rebuild;
  };
}
