{
  description = "ket-containers nix part";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    formatter.x86_64-linux = pkgs.alejandra;

    packages.x86_64-linux = {
      postgres-backup = pkgs.callPackage ./postgres-backup.nix {};
    };
  };
}
