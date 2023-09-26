{

  containers.minecraft-owoche = {
    autoStart = true;
    forwardPorts = [ 
      {
        containerPort = 25565;
        hostPort = 25565;
        protocol = "tcp";
      }
    ];
    config = { config, pkgs, nixpkgs, ... }: {

      nixpkgs.config.allowUnfree = true; # needed for factorio (is not free software)
      services.minecraft-server = {
        package = pkgs.minecraftServers.vanilla-1-8;
        enable = true;
        openFirewall = true;
        eula = true;
        jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
      };
      
      system.stateVersion = "23.05"; # did you read the comment?
    };
  };
}
