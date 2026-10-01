{ lib, pkgs, ... }:
let
  # oh-my-zsh git plugin names, so muscle memory carries over.
  gitAliases = {
    g = "git";
    gst = "git status -sb";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit -v";
    gcm = "git commit -m";
    gca = "git commit -v --amend";
    gsw = "git switch";
    gswc = "git switch -c";
    gb = "git branch";
    gd = "git diff";
    gds = "git diff --staged";
    gf = "git fetch --all --prune";
    gl = "git pull";
    gp = "git push";
    gpf = "git push --force-with-lease";
    grb = "git rebase";
    gsta = "git stash push";
    gstp = "git stash pop";
    glog = "git log --oneline --graph --decorate";
  };
in
{
  # zsh is configured system-wide (/etc/zshrc) — no home-manager zsh.
  # fzf: Ctrl-R history, Tab ** completion, Ctrl-G git pickers (Ctrl-G Ctrl-B
  # branches, Ctrl-G Ctrl-F files, Ctrl-G Ctrl-H commits, …). The scripts call
  # `fzf`, so it must be on PATH too.
  environment.systemPackages = [ pkgs.fzf ];

  programs.zsh = {
    enableFzfHistory = true;
    enableFzfCompletion = true;
    enableFzfGit = true;

    # Replaces the default `prompt suse`; config in starship.nix.
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init zsh)"
    '';

    # /etc/zshrc, so every interactive shell gets them (environment.shellAliases
    # would land in /etc/zprofile: login shells only).
    interactiveShellInit = ''
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (n: v: "alias ${n}=${lib.escapeShellArg v}") gitAliases
      )}

      # fzf-backed git helpers.
      # gswf: switch branch, local or remote, previewing its recent log.
      gswf() {
        local b
        b=$(git branch --all --sort=-committerdate --format='%(refname:short)' |
          grep -v HEAD |
          fzf --preview 'git log --oneline --graph --color=always -20 {}') || return
        git switch "''${b#origin/}"
      }

      # gaf: stage changed files, previewing their diff. Tab to multi-select.
      gaf() {
        local files
        files=$(git -c color.status=always status --short |
          fzf --multi --ansi --nth 2.. \
            --preview 'git diff --color=always -- {-1} | head -200' |
          awk '{print $NF}') || return
        git add -- ''${(f)files}
        git status -sb
      }

      # glf: browse history; Enter shows the commit.
      glf() {
        git log --oneline --color=always --decorate |
          fzf --ansi --no-sort \
            --preview 'git show --color=always {1}' \
            --bind 'enter:execute(git show --color=always {1} | less -R)'
      }
    '';
  };
}
