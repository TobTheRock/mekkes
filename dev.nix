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
    clang-tools
    cmake
    gnumake

    # JS
#    node
    pnpm
    
    # AI
    claude-code
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "Tobias Waurick";
      email = "tobias.waurick@xneural.ai";
    };
  };
}
