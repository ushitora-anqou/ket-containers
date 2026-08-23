{
  backblaze-b2,
  busybox,
  callPackage,
  dockerTools,
  iana-etc,
  postgresql_18,
  runtimeShell,
  trickle,
  zstd,
  ...
}:
dockerTools.buildLayeredImage {
  name = "ghcr.io/ushitora-anqou/ket-pg-tool";
  tag = "0.1.4";
  created = "now";
  extraCommands = "mkdir -m 1777 tmp";
  contents = [
    busybox
    iana-etc
    postgresql_18

    (callPackage ./pause.nix {})
  ];
  fakeRootCommands = ''
    #!${runtimeShell}
    set -eux
    ${dockerTools.shadowSetup}
    mkdir /workdir
    chown 1000:1000 /workdir
    chmod 777 /workdir
  '';
  enableFakechroot = true;
  config = {
    Entrypoint = ["pause"];
    User = "1000:1000";
    Env = [
      "HOME=/workdir"
    ];
    WorkingDir = "/workdir";
  };
}
