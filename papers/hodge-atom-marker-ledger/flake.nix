{
  description = "Pinned toolchain for the Hodge-atom marker-ledger note";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          basePackages = with pkgs; [ python3 texliveFull git coreutils ];
        in {
          manuscript = pkgs.mkShell { packages = basePackages; };
          default = pkgs.mkShell { packages = basePackages; };
        });
    };
}
