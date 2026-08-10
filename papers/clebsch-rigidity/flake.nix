{
  description = "Pinned toolchain for building and verifying the Clebsch rigidity paper";

  # One nixpkgs revision for every paper. A manuscript build is byte-reproducible only
  # when both the clock and the toolchain are fixed: pinning SOURCE_DATE_EPOCH alone
  # leaves the TeX engine version free, and that version determines the producer string
  # and the font subset tags. A paper resolving TeX from the mutable flake registry
  # rebuilds to different bytes whenever the registry moves, which turns a byte-equality
  # staleness check into a false alarm against a correct tracked PDF.
  #
  # The standalone distribution uses this same pin. Change the revision deliberately:
  # every tracked PDF must then be rebuilt.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      apps = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          verify = pkgs.writeShellApplication {
            name = "verify-clebsch-rigidity-release";
            runtimeInputs = with pkgs;
              [ python3 texlive.combined.scheme-full git coreutils stdenv.cc nix ];
            text = ''
              exec python3 verification/verify_release.py "$@"
            '';
          };
          regenerate = pkgs.writeShellApplication {
            name = "regenerate-clebsch-rigidity-release";
            runtimeInputs = with pkgs;
              [ python3 texlive.combined.scheme-full git coreutils stdenv.cc ];
            text = ''
              python3 verification/check_manuscript_build.py --update
              python3 verification/extract_statement_identity.py \
                --output verification/statement_identity.json
              exec python3 verification/build_trust_manifest.py "$@"
            '';
          };
        in {
          default = { type = "app"; program = "${verify}/bin/verify-clebsch-rigidity-release"; };
          verify = { type = "app"; program = "${verify}/bin/verify-clebsch-rigidity-release"; };
          regenerate = {
            type = "app";
            program = "${regenerate}/bin/regenerate-clebsch-rigidity-release";
          };
        });

      # A shell per capability set rather than one union shell: Singular and Macaulay2
      # are large closures, and a reader rebuilding a manuscript should not realise a
      # computer algebra system that paper never invokes. Nix builds only the shell
      # entered, so naming the right one keeps each paper's dependency honest.
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          base = with pkgs; [ python3 texlive.combined.scheme-full git coreutils ];
        in {
          # Manuscript build and stdlib-only verification.
          default = pkgs.mkShell { packages = base; };
          manuscript = pkgs.mkShell { packages = base; };

          # Adds Singular, for papers whose verification runs ideal computations.
          manuscript-cas = pkgs.mkShell {
            packages = base ++ [ pkgs.singular ];
          };

          # Adds Macaulay2 alongside Singular.
          manuscript-cas-full = pkgs.mkShell {
            packages = base ++ [ pkgs.singular pkgs.macaulay2 ];
          };

          # Adds poppler-utils, for papers whose checks read the rendered PDF.
          manuscript-pdf = pkgs.mkShell {
            packages = base ++ [ pkgs.poppler-utils ];
          };

          # Adds sympy to the Python environment.
          manuscript-sympy = pkgs.mkShell {
            packages = with pkgs;
              [ (python3.withPackages (ps: [ ps.sympy ]))
                texlive.combined.scheme-full git coreutils ];
          };
        });
    };
}
