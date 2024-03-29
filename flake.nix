{
  description = "A template that shows all standard flake outputs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ self, nixpkgs, agenix, ... }:
  let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  in {
    nixosConfigurations =
      let
        hosts = builtins.attrNames (nixpkgs.lib.filterAttrs (hostname: type: type == "directory") (builtins.readDir ./hosts));
        
      in
      nixpkgs.lib.genAttrs hosts
        (hostname: nixpkgs.lib.nixosSystem {
          modules = [ 
            ./hosts/${hostname}/configuration.nix
          ];
          specialArgs.inputs = inputs;
        }
        );

    devShell = forAllSystems (system: let pkgs = nixpkgs.legacyPackages.${system}; in pkgs.mkShell {
      packages = [ pkgs.hello ];
    });
  };
}
