{
  description = "Reproducible manuscript and finite reconstruction checks";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }:
    let systems = [ "x86_64-linux" "aarch64-linux" ];
        forAll = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in { devShells = forAll (pkgs: { default = pkgs.mkShell {
      packages = [ pkgs.python3 pkgs.nauty pkgs.poppler-utils
        (pkgs.texlive.combine { inherit (pkgs.texlive) scheme-small latexmk enumitem lm microtype booktabs; }) ];
    }; }); };
}
