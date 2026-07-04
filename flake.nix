{
  description = "Personal wiki built with Org mode";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        emacs = pkgs.emacsPackages.emacsWithPackages (epkgs: with epkgs; [
          htmlize  # syntax highlighting in exported HTML code blocks
        ]);
        python = pkgs.python3.withPackages (ps: with ps; [
          pandas
          numpy
          matplotlib
          scipy
        ]);
        R = pkgs.rWrapper.override {
          packages = with pkgs.rPackages; [
            ggplot2
            dplyr
            tidyr
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            emacs
            python
            R
            pkgs.just
            pkgs.xdg-utils
          ];
        };
      }
    );
}
