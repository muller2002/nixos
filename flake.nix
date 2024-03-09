{
  description = "A template that shows all standard flake outputs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, agenix, ... }:
   
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
          specialArgs = inputs;
        }
        );

    devShell = forAllSystems (system: let pkgs = nixpkgs.legacyPackages.${system}; in pkgs.mkShell {
      packages = [ pkgs.hello ];
    });
    
    overlays = {
      # Inject 'unstable' and 'trunk' into the overridden package set, so that
      # the following overlays may access them (along with any system configs
      # that wish to do so).
      pkg-sets = (
        final: prev: {
          unstable = import inputs.unstable { system = final.system; };
          trunk = import inputs.trunk { system = final.system; };
        }
      );
    # Remaining attributes elided.
    };
  };
}
