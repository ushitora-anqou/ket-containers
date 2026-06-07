{
  fetchurl,
  stdenv,
  glibc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pause";
  version = "0.1.0";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/kubernetes/kubernetes/v1.36.1/build/pause/linux/pause.c";
    hash = "sha256-FKP+IatfjmKTeitFPnbzuUsNPHwEw9Cbw3GV9UwWleo=";
  };
  nativeBuildInputs = [glibc.static];
  unpackPhase = ":";
  buildPhase = ''
    runHook preBuild
    gcc -Os -Wall -Werror -static -DVERSION=v${finalAttrs.version} -o pause $src
    strip pause
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp pause $out/bin
    runHook postInstall
  '';
})
