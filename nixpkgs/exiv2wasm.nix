{ lib, stdenv, fetchFromGitHub, cmake, clang_12, lld, python3, emscripten, expat2wasm, zlib2wasm, pkg-config }:

let
  version = "0.27.6";
in

stdenv.mkDerivation {
  pname = "exiv2wasm";
  inherit version;

  src = fetchFromGitHub {
    owner = "Exiv2";
    repo = "exiv2";
    rev = "5708bee";
    sha256 = "kgognbw2fKlUAxJQrxwKZnEor8J9zK6y/TMEWrUtCac=";
  };

  dontStrip = true;

  configurePhase = ''
    rm -rf build && mkdir -p build/tmp && cd build
    export EM_CACHE=$PWD/tmp
    emcmake cmake .. \
    -DEXIV2_ENABLE_BMFF=off \
    -DEXIV2_ENABLE_BROTLI=off \
    -DEXIV2_ENABLE_PNG=on \
    -DEXIV2_ENABLE_XMP=on \
    -DEXIV2_ENABLE_INIH=off \
    -DEXIV2_ENABLE_VIDEO=off \
    -DEXPAT_LIBRARY="$(pkg-config --variable=libdir expat)/libexpat.a" \
    -DEXPAT_INCLUDE_DIR="$(pkg-config --variable=includedir expat)" \
    -DZLIB_LIBRARY="$(pkg-config --variable=libdir zlib)/libz.a" \
    -DZLIB_INCLUDE_DIR="$(pkg-config --variable=includedir zlib)" \
    -DBUILD_SHARED_LIBS=off \
    -DBUILD_WITH_STACK_PROTECTOR=off \
    -DCMAKE_INSTALL_PREFIX=$out
  '';

  buildPhase = ''
    emmake make
  '';

  installPhase = ''
    emmake make install
  '';

  nativeBuildInputs = [ cmake clang_12 lld python3 emscripten pkg-config ];
  buildInputs = [ expat2wasm zlib2wasm ];
  doCheck = true;
}
