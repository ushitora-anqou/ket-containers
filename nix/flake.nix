{
  description = "ket-containers nix part";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Adding an image = one line here. Adding a platform under an already
    # listed system = expose it there; CI derives platforms from
    # `nix flake show`. A NEW system also needs the platform map in
    # .github/workflows/build-nix.yaml (CI fails loudly until it is mapped).
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        pvc-backup = pkgs.callPackage ./pvc-backup.nix {};
        pg-tool = pkgs.callPackage ./pg-tool.nix {};
      }
    );
  };
}
