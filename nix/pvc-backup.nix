{
  backblaze-b2,
  busybox,
  cacert,
  callPackage,
  dockerTools,
  iana-etc,
  kubernetes,
  runtimeShell,
  trickle,
  zstd,
  ...
}:
dockerTools.buildLayeredImage {
  name = "ghcr.io/ushitora-anqou/ket-pvc-backup";
  tag = "0.1.2";
  created = "now";
  extraCommands = "mkdir -m 1777 tmp";
  contents = [
    backblaze-b2
    busybox
    iana-etc
    trickle
    zstd

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
      "SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
      "HOME=/workdir"
    ];
    WorkingDir = "/workdir";
  };
}
