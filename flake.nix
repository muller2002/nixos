{
  description = "A template that shows all standard flake outputs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
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
  };
}
