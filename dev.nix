{ pkgs, ... }: {
  home.packages = with pkgs; [
    # python
    python3
    uv
    basedpyright

    # rust — fenix overlay
    fenix.complete.toolchain
    rust-analyzer-nightly

    # c/c++
    # ponytail: no clang/gcc here — Xcode CLT owns the system compiler and SDK
    # on darwin, nixpkgs clang fights it. Only the tooling around it.
    clang-tools
    cmake
    gnumake
  ];
}
