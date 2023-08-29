{ pkgs, nixpkgs, ... }:
let
  ssh-keys = builtins.readFile ./ssh-keys;
in
{
  imports = [
    ./hardware-configuration.nix
    # (import "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.05"; # Did you read the comment?

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keyFiles = [
    (pkgs.writeText "root-ssh-key" ssh-keys)
  ];

  time.timeZone = "Europe/Berlin";


  networking.hostName = "apollon";
  networking.damain = "marlenawan.de";

}
