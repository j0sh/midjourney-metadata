{ lib, stdenv, fetchurl, emscripten, clang_12, pkg-config, deno }:

let
  version = "1.2.13";
in

stdenv.mkDerivation {
  pname = "zlib2wasm";
  inherit version;

  src = fetchurl {
    url = "https://www.zlib.net/zlib-${version}.tar.gz";
    sha256 = "s6JN6XqP28g1uYMxaVAQMLiXcDG8tUs7OsE3QPhGqzA=";
  };

  outputs = [ "out" ];

  dontStrip = true;

  configurePhase = ''
    mkdir -p "$PWD/tmp"
    export EM_CACHE="$PWD/tmp"
    emconfigure ./configure --static --prefix=$out
  '';

  buildPhase = ''
    emmake make
  '';

  installPhase = ''
    emmake make install prefix=$out
  '';

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure \
      --replace '/usr/bin/libtool' 'ar' \
      --replace 'AR="libtool"' 'AR="ar"' \
      --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';

  checkPhase = ''
    echo "================= testing zlib using deno ================="
    echo "Compiling a custom test"
    set -x
    export DENO_DIR="$PWD/tmp"
    emcc -O2 -s EMULATE_FUNCTION_POINTER_CASTS=1 test/example.c -DZ_SOLO \
      -L. libz.a -I . -s EXPORT_ES6=1 -s MODULARIZE=1 -s EXPORT_NAME=ZlibExample -s SINGLE_FILE=1  -o example.js
    echo "Using deno to execute the test"
    ${deno}/bin/deno eval 'import zlib from "./example.js"; await zlib();'
    set +x
    echo "it seems to work! very good."
    echo "================= /testing zlib using deno ================="
  '';

  doCheck = true;
  nativeBuildInputs = [ emscripten clang_12 pkg-config ];
  buildInputs = [ deno ];
}
