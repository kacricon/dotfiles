#!/bin/sh
set -eu

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/projects/dotfiles}"
REPO_URL="${REPO_URL:-https://github.com/kacricon/dotfiles.git}"
REPO_BRANCH="${REPO_BRANCH:-master}"
NIX_CONFIG_NAME="${NIX_CONFIG_NAME:-laptop}"

NIX_DIR="$DOTFILES_DIR/nix"
NIX_FLAKE="$NIX_DIR#$NIX_CONFIG_NAME"
DARWIN_REBUILD_PACKAGE="$NIX_DIR#darwin-rebuild"
NIX_DAEMON_SH="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
NIX_INSTALLER=""
HOMEBREW_INSTALLER=""

info() { printf '\033[1;34m==> %s\033[0m\n' "$1"; }
ok()   { printf '\033[1;32m==> %s\033[0m\n' "$1"; }
warn() { printf '\033[1;33m==> %s\033[0m\n' "$1"; }
die()  { printf '\033[1;31m==> %s\033[0m\n' "$1" >&2; exit 1; }

cleanup() {
  [ -n "$NIX_INSTALLER" ] && rm -f "$NIX_INSTALLER"
  [ -n "$HOMEBREW_INSTALLER" ] && rm -f "$HOMEBREW_INSTALLER"
  return 0
}

trap cleanup EXIT HUP INT TERM

have() {
  command -v "$1" >/dev/null 2>&1
}

require_command() {
  if ! have "$1"; then
    die "$1 is required but was not found on PATH"
  fi
}

run_git() {
  GIT_TERMINAL_PROMPT=0 git "$@"
}

load_nix_profile() {
  if [ -r "$NIX_DAEMON_SH" ]; then
    # shellcheck disable=SC1090
    . "$NIX_DAEMON_SH"
  fi
}

load_homebrew_path() {
  if [ -x /opt/homebrew/bin/brew ]; then
    PATH="/opt/homebrew/bin:$PATH"
    export PATH
  elif [ -x /usr/local/bin/brew ]; then
    PATH="/usr/local/bin:$PATH"
    export PATH
  fi
}

check_host() {
  if [ "$(id -u)" -eq 0 ]; then
    die "run setup.sh as your normal user, not with sudo"
  fi

  if [ "$(uname -s)" != "Darwin" ]; then
    die "this bootstrap script only supports macOS"
  fi

  if [ "$(uname -m)" != "arm64" ]; then
    die "this dotfiles flake targets Apple Silicon Macs; found $(uname -m)"
  fi
}

ensure_xcode_clt() {
  info "checking xcode command line tools..."
  if xcode-select -p >/dev/null 2>&1; then
    ok "xcode command line tools already installed"
    return
  fi

  info "opening xcode command line tools installer..."
  xcode-select --install >/dev/null 2>&1 || true
  warn "complete the macOS installer dialog to continue"

  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done

  ok "xcode command line tools installed"
}

ensure_nix() {
  info "checking nix..."
  load_nix_profile

  if have nix; then
    ok "nix already installed"
    return
  fi

  require_command curl

  info "installing nix via determinate systems installer..."
  NIX_INSTALLER="$(mktemp "${TMPDIR:-/tmp}/nix-installer.XXXXXX")"

  curl --proto '=https' --tlsv1.2 -fsSL -o "$NIX_INSTALLER" https://install.determinate.systems/nix
  sh "$NIX_INSTALLER" install --no-confirm

  load_nix_profile
  if ! have nix; then
    die "nix installed, but nix is not available on PATH; open a new shell and rerun setup.sh"
  fi

  ok "nix installed"
}

ensure_homebrew() {
  info "checking homebrew..."
  load_homebrew_path

  if have brew; then
    ok "homebrew already installed"
    return
  fi

  require_command curl

  if [ ! -x /bin/bash ]; then
    die "/bin/bash is required to install homebrew"
  fi

  info "installing homebrew..."
  HOMEBREW_INSTALLER="$(mktemp "${TMPDIR:-/tmp}/homebrew-installer.XXXXXX")"

  curl --proto '=https' --tlsv1.2 -fsSL -o "$HOMEBREW_INSTALLER" https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
  NONINTERACTIVE=1 /bin/bash "$HOMEBREW_INSTALLER"

  load_homebrew_path
  if ! have brew; then
    die "homebrew installed, but brew is not available on PATH; open a new shell and rerun setup.sh"
  fi

  ok "homebrew installed"
}

ensure_dotfiles_repo() {
  require_command git

  info "checking dotfiles repo..."
  if [ -d "$DOTFILES_DIR/.git" ]; then
    if [ -n "$(run_git -C "$DOTFILES_DIR" status --porcelain)" ]; then
      warn "dotfiles repo has local changes; skipping automatic update"
      return
    fi

    info "dotfiles repo exists, fetching latest $REPO_BRANCH from public remote..."
    if run_git -C "$DOTFILES_DIR" fetch "$REPO_URL" "$REPO_BRANCH" &&
       run_git -C "$DOTFILES_DIR" merge --ff-only FETCH_HEAD; then
      ok "dotfiles repo up to date"
    else
      warn "could not fast-forward dotfiles repo; continuing with existing checkout"
    fi
    return
  fi

  if [ -e "$DOTFILES_DIR" ]; then
    die "$DOTFILES_DIR already exists but is not a git checkout"
  fi

  info "cloning dotfiles repo..."
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  run_git clone --branch "$REPO_BRANCH" "$REPO_URL" "$DOTFILES_DIR"
  ok "dotfiles repo cloned"
}

run_darwin_switch() {
  info "running darwin-rebuild switch..."
  if have darwin-rebuild; then
    darwin_rebuild="$(command -v darwin-rebuild)"
    sudo -H "$darwin_rebuild" switch --flake "$NIX_FLAKE"
  else
    info "darwin-rebuild is not installed yet; bootstrapping it from the pinned flake..."
    nix_bin="$(command -v nix)"
    sudo -H "$nix_bin" --extra-experimental-features 'nix-command flakes' run "$DARWIN_REBUILD_PACKAGE" -- switch --flake "$NIX_FLAKE"
  fi
  ok "darwin-rebuild complete"
}

apply_dotfiles() {
  require_command make

  info "applying dotfiles..."
  make -C "$DOTFILES_DIR" apply_dotfiles
  ok "dotfiles applied"
}

main() {
  check_host
  ensure_xcode_clt
  ensure_nix
  ensure_homebrew
  ensure_dotfiles_repo
  run_darwin_switch
  apply_dotfiles

  ok "bootstrap complete"

  echo ""
  echo "┌─────────────────────────────────────────────┐"
  echo "│          Post-bootstrap checklist            │"
  echo "├─────────────────────────────────────────────┤"
  echo "│ □ Set git identity:                         │"
  echo "│   git config --global user.name \"Your Name\" │"
  echo "│   git config --global user.email \"you@…\"    │"
  echo "│ □ Install Bitwarden extension in browser    │"
  echo "│ □ Set default browser                       │"
  echo "└─────────────────────────────────────────────┘"
}

main "$@"
