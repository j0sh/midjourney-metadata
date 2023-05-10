{ pkgs ? import <nixpkgs> {} }:
let
  expat2wasm =  pkgs.callPackage ./nixpkgs/expat2wasm.nix {};
  zlib2wasm = pkgs.callPackage ./nixpkgs/zlib2wasm.nix {};
  exiv2wasm = pkgs.callPackage ./nixpkgs/exiv2wasm.nix {
    expat2wasm = expat2wasm;
    zlib2wasm = zlib2wasm;
  };
in
pkgs.mkShell {
  packages = [ pkgs.deno expat2wasm zlib2wasm exiv2wasm pkgs.emscripten pkgs.clang_12 pkgs.jq pkgs.htmlq pkgs.curl ];
  nativeBuildInputs = [ pkgs.pkg-config ];
  shellHooks = ''
    mkdir -p ".emcache"
    export PATH="$HOME/.deno/bin:$PATH"
  '';
}
