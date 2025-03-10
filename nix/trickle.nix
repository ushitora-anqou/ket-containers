{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  libevent,
  libtirpc,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  # cf. https://github.com/NixOS/nixpkgs/blob/742e1fdecbbe014d7a34a2e1edfef08b13ce690d/pkgs/by-name/tr/trickle/package.nix#L10
  # cf. https://github.com/NixOS/nixpkgs/issues/368974#issuecomment-2564592608
  pname = "trickle";
  version = "1.07";
  src = fetchFromGitHub {
    owner = "mariusae";
    repo = "trickle";
    rev = "09a1d955c6554eb7e625c99bf96b2d99ec7db3dc";
    hash = "sha256-cqkNPeTo+noqMCXsxh6s4vKoYwsWusafm/QYX8RvCek=";
  };
  buildInputs = [
    libevent
    libtirpc
  ];
  nativeBuildInputs = [autoreconfHook];
  patches = [
    ./trickle-1.patch
    ./trickle-2.patch
  ];
  preConfigure = ''
    sed -i 's|libevent.a|libevent.so|' configure
    sed -i 's/if test "$HAVEMETHOD" = "no"; then/if false; then/' configure
    sed -i '1i#define DLOPENLIBC "${stdenv.cc.libc}/lib/libc.so.6"' trickle-overload.c
  '';
  preBuild = ''
    sed -i '/#define in_addr_t/ s:^://:' config.h
  '';
  NIX_LDFLAGS = [
    "-levent"
    "-ltirpc"
  ];
  env.NIX_CFLAGS_COMPILE = toString [
    "-I${libtirpc.dev}/include/tirpc"
    "-Wno-pointer-sign"
  ];
  configureFlags = ["--with-libevent"];
  hardeningDisable = ["format"];
  meta = {
    description = "Lightweight userspace bandwidth shaper";
    license = lib.licenses.bsd3;
    homepage = "https://monkey.org/~marius/pages/?page=trickle";
    platforms = lib.platforms.linux;
    mainProgram = "trickle";
  };
}
