{
  description = "Pinned manuscript toolchain for Frobenius-equivariant pair extension";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          base = with pkgs; [ tectonic gnumake git coreutils ];
        in {
          default = pkgs.mkShell { packages = base; };
          manuscript = pkgs.mkShell { packages = base; };
        });
    };
}
