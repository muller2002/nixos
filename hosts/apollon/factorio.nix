{ inputs, ... }:
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
    nixpkgs = inputs.nixpkgs-unstable.outPath;
    config = { config, pkgs, nixpkgs, ... }: 
    {
    

      nixpkgs.config.allowUnfree = true; # needed for factorio (is not free software)

      services.factorio = {
        enable = true;
        openFirewall = true;
        game-name = "GI Hochschulgruppe Paderborn";
        description = "Factorio server der GI Hochschulgruppe Paderborn, du möchtest mitspielen? melde dich bei uns (https://hg-paderborn.gi.de/kontakt/)";
        game-password = builtins.readFile ./factorio-main-password;
      };
      system.stateVersion = "23.05"; # did you read the comment?
    };
  };
}
