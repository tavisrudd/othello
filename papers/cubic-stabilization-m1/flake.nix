{
  description = "Pinned toolchain for the cubic-stabilization epilogue";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    blueprint-nixpkgs.url =
      "github:NixOS/nixpkgs/e73de5be04e0eff4190a1432b946d469c794e7b4";
  };

  outputs = { nixpkgs, blueprint-nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          blueprintPkgs = blueprint-nixpkgs.legacyPackages.${system};
          base = with pkgs; [ python3 texlive.combined.scheme-full git coreutils ];
          blueprintPython =
            blueprintPkgs.python3.withPackages (ps: [ ps.leanblueprint ]);
        in {
          default = pkgs.mkShell { packages = base; };
          manuscript = pkgs.mkShell { packages = base; };
          blueprint = pkgs.mkShell {
            packages = [
              blueprintPython
              blueprintPkgs.graphviz
              blueprintPkgs.ghostscript
              blueprintPkgs.texlive.combined.scheme-full
            ];
            PYTHONPATH =
              "${blueprintPython}/${blueprintPython.sitePackages}";
          };
        });
      apps = forAllSystems (system:
        let
          pkgs = blueprint-nixpkgs.legacyPackages.${system};
          blueprintPython =
            pkgs.python3.withPackages (ps: [ ps.leanblueprint ]);
          blueprintWeb = pkgs.writeShellApplication {
            name = "cubic-stabilization-blueprint-web";
            runtimeInputs = [
              blueprintPython
              pkgs.coreutils
              pkgs.graphviz
              pkgs.ghostscript
              pkgs.texlive.combined.scheme-full
            ];
            text = ''
              if [[ ! -f blueprint/src/web.tex ]]; then
                echo "run this target from the paper repository root" >&2
                exit 2
              fi
              export PYTHONPATH="${blueprintPython}/${blueprintPython.sitePackages}"
              python blueprint/extract_bibliography.py \
                cubic_stabilization_m1.tex \
                blueprint/src/generated-references.tex
              if [[ -d blueprint/web ]]; then
                chmod -R u+w blueprint/web
              fi
              if [[ -f blueprint/src/web.paux ]]; then
                chmod u+w blueprint/src/web.paux
              fi
              cd blueprint/src
              exec plastex -c plastex.cfg web.tex
            '';
          };
        in {
          blueprint-web = {
            type = "app";
            program = "${blueprintWeb}/bin/cubic-stabilization-blueprint-web";
          };
        });
    };
}
