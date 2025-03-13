{
  backblaze-b2,
  busybox,
  cacert,
  callPackage,
  dockerTools,
  iana-etc,
  postgresql_17,
  runtimeShell,
  ...
}:
dockerTools.buildLayeredImage {
  name = "ghcr.io/ushitora-anqou/ket-postgres-backup";
  tag = "0.1.1";
  created = "now";
  extraCommands = "mkdir -m 1777 tmp";
  contents = [
    backblaze-b2
    busybox
    iana-etc
    postgresql_17
    (callPackage ./trickle.nix {})
  ];
  fakeRootCommands = ''
    #!${runtimeShell}
    set -eux
    ${dockerTools.shadowSetup}
    mkdir /workdir
    chown 1000:1000 /workdir
  '';
  enableFakechroot = true;
  config = {
    Entrypoint = ["sleep" "infinity"];
    User = "1000:1000";
    Env = [
      "SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
      "HOME=/workdir"
    ];
    WorkingDir = "/workdir";
  };
}
