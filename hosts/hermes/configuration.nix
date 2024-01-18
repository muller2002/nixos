{ pkgs, nixpkgs, ... }:
let
  ssh-keys = builtins.readFile ./../../macbookkey.pub;
in
{
  imports = [
    ./hardware-configuration.nix
    # (import "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.05"; # Did you read the comment?

  # Deactivate EFI variables
  boot.loader.efi.canTouchEfiVariables = false;

  # Use the GRUB2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda3";

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services = {
    openssh.enable = true;
    tailscale.enable = true;
  };

  users.users.root.openssh.authorizedKeys.keyFiles = [
    (pkgs.writeText "root-ssh-key" ssh-keys)
  ];

  time.timeZone = "Europe/Berlin";


  networking.hostName = "hermes";
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
}
