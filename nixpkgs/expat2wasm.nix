{ lib, stdenv, fetchurl, emscripten, clang_12, cmake, pkg-config, deno }:

let
  version = "2.5.0";
in

stdenv.mkDerivation {
  pname = "expat2wasm";
  inherit version;

  dontStrip = true;

  src = fetchurl {
    url = "https://github.com/libexpat/libexpat/releases/download/R_2_5_0/expat-${version}.tar.gz";
    sha256 = "a5AqsQOENZK+XplQT4RuwQnBq7aS6FNHWH8jek/6EDM=";
  };

  configurePhase = ''
    rm -rf build && mkdir -p build/tmp && cd build
    export EM_CACHE="$PWD/tmp"
    emcmake cmake .. \
      -DEXPAT_SHARED_LIBS=off \
      -DCMAKE_INSTALL_PREFIX="$out" \
      -DCMAKE_EXE_LINKER_FLAGS="-s EXPORT_ES6=1 -s MODULARIZE=1 -s EXPORT_NAME=Expat -s SINGLE_FILE=1"
  '';

  buildPhase = ''
    emmake make
  '';

  installPhase = ''
    emmake make install
  '';

  checkPhase = ''
    echo "================= run expat tests using deno ================="
    echo "Using deno to execute the test"
    export DENO_DIR="$PWD/tmp"
    set -x
    ${deno}/bin/deno eval 'import expat from "./tests/runtests.js"; await expat();'
    set +x
    echo "it seems to work! very good."
    echo "================= /run expat tests using deno ================="
  '';

  doCheck = true;
  nativeBuildInputs = [ emscripten clang_12 cmake pkg-config ];
  buildInputs = [ deno ];
}
