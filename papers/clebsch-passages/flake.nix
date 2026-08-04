{
  description = "Arithmetic and harmonic realizations of the Clebsch cubic";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    finitegeom.url =
      "github:tavisrudd/finitegeom?rev=d8ea8326f09da54ffd50b77a3bf54f91a7fbb5ed";
  };

  outputs = { nixpkgs, finitegeom, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      checks = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          formal-companion-pin = pkgs.runCommand "clebsch-passages-formal-companion-pin" {} ''
            test -f ${finitegeom}/trust/manifests/clebsch_passages.json
            test -f ${finitegeom}/trust/ClebschPassagesAxiomAudit.lean
            test -f ${finitegeom}/RelativeConicArcs/Gates/ClebschOrientationMechanisms.lean
            touch "$out"
          '';
        });

      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              python3
              texlive.combined.scheme-full
              git
              coreutils
            ];
          };
        });
    };
}
