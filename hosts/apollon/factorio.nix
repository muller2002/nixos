{

  containers.factorio-main = {
    autoStart = true;
    forwardPorts = [ 
      {
        containerPort = 34197;
        hostPort = 34197;
        protocol = "udp";
      }
    ];
    
    config = { config, pkgs, nixpkgs, ... }: 
    let
      # add unstable channel declaratively
      unstableTarball =
        fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
          sha256 = "28d3cba45864177edd25d0231e57c486ab9d9b5e83d650536692d35020739e59";
        }; 
    in
    {
      nixpkgs.config = {
        packageOverrides = pkgs: {
          unstable = import unstableTarball {
            config = config.nixpkgs.config;
          };
        };
      };

      nixpkgs.config.allowUnfree = true; # needed for factorio (is not free software)

      services.factorio = {
        enable = true;
        openFirewall = true;
        game-name = "GI Hochschulgruppe Paderborn";
        description = "Factorio server der GI Hochschulgruppe Paderborn, du möchtest mitspielen? melde dich bei uns (https://hg-paderborn.gi.de/kontakt/)";
        game-password = builtins.readFile ./factorio-main-password;
        package = pkgs.unstable.factorio-headless;
      };
      system.stateVersion = "23.05"; # did you read the comment?
    };
  };
}
