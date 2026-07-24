{
  description = "Clebsch rigidity paper and reproducibility checks";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python3
          texlive.combined.scheme-full
          nix
          git
          coreutils
        ];
      };
    };
}
