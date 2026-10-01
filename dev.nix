{ pkgs, ... }: {
  home.packages = with pkgs; [
    # python
    uv
    basedpyright

    # rust — fenix overlay
    fenix.complete.toolchain

    # c/c++
    # ponytail: no clang/gcc here — Xcode CLT owns the system compiler and SDK
    # on darwin, nixpkgs clang fights it. Only the tooling around it.
    # CLT also ships libclang (bindgen finds it via xcode-select) and libpcap.
    clang-tools
    cmake
    gnumake
    protobuf # protoc

    # JS
    nodejs_24
    pnpm

    # git hooks
    prek

    # AI
    claude-code
  ];

  # Run `gh auth login` once; the credential helper replaces `gh auth setup-git`
  # (HTTPS clones of private repos, e.g. uv git deps).
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Tobias Waurick";
      email = "tobias.waurick@xneural.ai";
    };
  };
}
