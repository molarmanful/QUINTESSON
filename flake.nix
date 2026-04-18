{
  description = "A tall, many-faced bitmap megafont to conquer the galaxy with.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    bited-utils = {
      url = "github:molarmanful/bited-utils";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.bited-utils.flakeModule ];
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          bited-utils = {
            name = "QUINTESSON";
            version = builtins.readFile ./VERSION;
            src = ./.;
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              config.bited-utils.bited-clr
              taplo
              # lsps
              nil
              marksman
              # formatters
              nixfmt
              mdformat
              yamlfmt
              python3Packages.mdformat-gfm
              python3Packages.mdformat-gfm-alerts
              # linters
              statix
              deadnix
              actionlint
            ];
          };
        };
    };
}
