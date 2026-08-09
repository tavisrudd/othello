{
  description = "finitegeom — Lean 4 formalization library";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      apps = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          verify = pkgs.writeShellApplication {
            name = "verify-finitegeom";
            runtimeInputs = with pkgs; [ elan git curl cacert gmp zlib coreutils ];
            text = ''
              test -f lakefile.toml
              export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
              export CURL_CA_BUNDLE="$SSL_CERT_FILE"
              export GIT_SSL_CAINFO="$SSL_CERT_FILE"
              lake exe cache get
              lake build
            '';
          };
        in { default = verify; verify = verify; });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [ elan git curl cacert gmp zlib coreutils ];
            shellHook = ''
              export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
              export CURL_CA_BUNDLE="$SSL_CERT_FILE"
              export GIT_SSL_CAINFO="$SSL_CERT_FILE"
            '';
          };
        });
    };
}
