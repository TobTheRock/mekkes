{ pkgs, ... }: {
  home.packages = with pkgs; [
    # python
    python3
    uv
    basedpyright

    # rust
    # ponytail: nixpkgs' single stable toolchain; swap in rustup or fenix when
    # you need nightly or per-project pinning.
    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer

    # c/c++
    # ponytail: no clang/gcc here — Xcode CLT owns the system compiler and SDK
    # on darwin, nixpkgs clang fights it. Only the tooling around it.
    clang-tools
    cmake
    gnumake
  ];
}
