{
  description = "NodeKayles — Lean 4 + mathlib verification of the queens getK leaf evaluator (2-lite)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system} = {
        # elan downloads prebuilt, dynamically-linked Lean binaries that expect a standard
        # ELF loader. This box has nix-ld (/lib64/ld-linux → nix-ld), so we just point it at
        # a real glibc loader + the libs Lean/lake link against (libstdc++, gmp, zlib). This
        # composes cleanly with `direnv use flake` / `nix develop` (no FHS chroot needed).
        default = pkgs.mkShell {
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

        # Fallback for a box WITHOUT nix-ld: an FHS env supplies the loader instead. Enter
        # it with `nix develop .#fhs` (the FHS chroot composes with direnv less transparently
        # than the nix-ld shell above).
        fhs = (pkgs.buildFHSEnv {
          name = "nodekayles-lean-fhs";
          targetPkgs = p: with p; [ elan git curl cacert gmp zlib gcc coreutils ];
          profile = ''export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"'';
          runScript = "bash";
        }).env;
      };
    };
}
