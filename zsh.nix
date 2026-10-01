{ config, lib, pkgs, ... }:
let
  omz = "${pkgs.oh-my-zsh}/share/oh-my-zsh";

  # grc colourises these by piping their output through a regex filter.
  # Its bundled grc.zsh also wraps docker, make, gcc, kubectl, …; piping
  # breaks `docker run -it` and compiler colours, so only read-only tools.
  grcCommands = [
    "df" "diff" "dig" "du" "id" "ifconfig" "last" "lsof" "mount" "netstat"
    "nmap" "ping" "ps" "traceroute" "uptime" "whois"
  ];
in
{
  # zsh is configured system-wide (/etc/zshrc) — no home-manager zsh.
  # fzf: Ctrl-R history, Tab ** completion, Ctrl-G git pickers (Ctrl-G Ctrl-B
  # branches, Ctrl-G Ctrl-F files, Ctrl-G Ctrl-H commits, …). The scripts call
  # `fzf`, so it must be on PATH too.
  environment.systemPackages = [
    pkgs.fzf
    pkgs.grc
    # Extra completions (lands in share/zsh/site-functions, already on fpath;
    # most dev.nix tools — cargo, gh, uv, pnpm, prek — ship their own).
    pkgs.zsh-completions
  ];

  programs.zsh = {
    enableFzfHistory = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    # fish-style: grey inline suggestion from history (→ accepts) and
    # command highlighting as you type.
    enableAutosuggestions = true;
    enableFastSyntaxHighlighting = true;

    # Replaces the default `prompt suse`; config in starship.nix.
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init zsh)"
    '';

    # nix-darwin would run compinit after interactiveShellInit, too late for
    # the git plugin's compdef calls — run it ourselves first instead.
    enableCompletion = false;

    interactiveShellInit = ''
      # brew shellenv (earlier in this file) already adds
      # $HOMEBREW_PREFIX/share/zsh/site-functions — that's where Docker
      # Desktop puts _docker. brew's own _brew isn't linked there under
      # nix-homebrew, so take it from the package.
      fpath=(${config.nix-homebrew.package}/completions/zsh $fpath)

      autoload -U compinit && compinit

      # Tab completion through an fzf menu. Must follow compinit; fzf's own
      # `**<Tab>` still works since it falls back to the previous Tab widget.
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -G $realpath'

      # oh-my-zsh git plugin standalone (~200 aliases: gst, gco, gsw, gpf, …;
      # `alias | grep git` lists them). lib/git.zsh provides
      # git_current_branch, which aliases like gpsup/ggpull call.
      source ${omz}/lib/git.zsh
      source ${omz}/plugins/git/git.plugin.zsh

      # grc: same mechanism as its grc.zsh, curated command list.
      if [[ -t 1 && $TERM != dumb ]]; then
        for cmd in ${lib.concatStringsSep " " grcCommands}; do
          (( $+commands[$cmd] )) && eval "$cmd() { grc --colour=auto ''${commands[$cmd]} \"\$@\" }"
        done
        unset cmd
      fi

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
