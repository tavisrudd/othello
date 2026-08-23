{
  description = "Lean companion for cubic stabilization irrationality";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      verifyRankSixRecurrence = pkgs.writeShellApplication {
        name = "verify-rank-six-recurrence";
        runtimeInputs = with pkgs; [ coreutils diffutils rustc ];
        text = ''
          certificate_dir=$(mktemp -d -p /var/tmp rank-six-recurrence.XXXXXX)
          trap 'rm -rf "$certificate_dir"' EXIT
          cd ${./.}
          sha256sum -c ${./certificates/rank-six-recurrence.sha256}
          rustc ${./scripts/rank_six_recurrence_cert.rs} -O -D warnings \
            -o "$certificate_dir/solver"
          "$certificate_dir/solver" --lean | diff -u \
            ${./TavisRuddFiniteGeom/Papers/CubicStabilizationIrrationality/Comparison/Generated/RankSixRecurrenceData.lean} -
          "$certificate_dir/solver" --json | diff -u \
            ${./certificates/rank-six-recurrence.json} -
        '';
      };
      verifyMarkedReesShadow = pkgs.writeShellApplication {
        name = "verify-marked-rees-shadow";
        runtimeInputs = with pkgs; [ coreutils diffutils rustc ];
        text = ''
          certificate_dir=$(mktemp -d -p /var/tmp marked-rees-shadow.XXXXXX)
          trap 'rm -rf "$certificate_dir"' EXIT
          cd ${./.}
          sha256sum -c ${./certificates/marked-rees-shadow.sha256}
          rustc ${./scripts/marked_rees_shadow_cert.rs} -O -D warnings \
            -o "$certificate_dir/solver"
          "$certificate_dir/solver" --lean | diff -u \
            ${./TavisRuddFiniteGeom/Papers/CubicStabilizationIrrationality/Comparison/Generated/MarkedReesShadowData.lean} -
          "$certificate_dir/solver" --json | diff -u \
            ${./certificates/marked-rees-shadow.json} -
        '';
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ elan git curl cacert gmp zlib coreutils ];
        NIX_LD = "${pkgs.glibc}/lib/ld-linux-x86-64.so.2";
        NIX_LD_LIBRARY_PATH =
          pkgs.lib.makeLibraryPath (with pkgs; [ stdenv.cc.cc.lib gmp zlib glibc ]);
        shellHook = ''
          export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
          export CURL_CA_BUNDLE="$SSL_CERT_FILE"
          export GIT_SSL_CAINFO="$SSL_CERT_FILE"
        '';
      };
      apps.${system} = {
        verify-rank-six-recurrence = {
          type = "app";
          program = "${verifyRankSixRecurrence}/bin/verify-rank-six-recurrence";
        };
        verify-marked-rees-shadow = {
          type = "app";
          program = "${verifyMarkedReesShadow}/bin/verify-marked-rees-shadow";
        };
      };
    };
}
