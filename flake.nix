{
  description = "A template that shows all standard flake outputs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {

    # Used with `nixos-rebuild --flake .#fsmi-buzzer`
    # Or: `nix build .#nixosConfigurations."fsmi-buzzer".config.system.build.toplevel`
    # Or build the iso: `nix build .#nixosConfigurations."fsmi-buzzer".config.system.build.isoImage`
    # nixosConfigurations."fsmi-buzzer".config.system.build.toplevel must be a derivation
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
