{ pkgs, nixpkgs, ... }:
let
  ssh-keys = builtins.readFile ./../../macbookkey.pub;
in
{
  imports = [
    ./hardware-configuration.nix
    ./uptime-kuma.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "22.11"; # Did you read the comment?

  # Deactivate EFI variables
  boot.loader.efi.canTouchEfiVariables = false;

  # Use the GRUB2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keyFiles = [
    (pkgs.writeText "root-ssh-key" ssh-keys)
  ];

  time.timeZone = "Europe/Berlin";


  networking.hostName = "aphrodite";
  networking.domain = "marlenawan.de";

  # install git
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    nano
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  security.acme.acceptTerms = true;
}
