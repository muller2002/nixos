{ pkgs, nixpkgs, ... }:
let
  ssh-keys = builtins.readFile ./../../macbookkey.pub;
in
{
  imports = [
    ./hardware-configuration.nix
    ./factorio.nix
    ./minecraft.nix
    ./modules/hugo-site/default.nix
    "${builtins.fetchTarball {
      url = "https://github.com/ryantm/agenix/archive/417caa847f9383e111d1397039c9d4337d024bf0.tar.gz";
      sha256 = "398b512ad85d539ad8a9af3854c846df4834af9da0f0415167b105003f5dc733";
    }}/modules/age.nix"
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
    allowedTCPPorts = [ 22 80 443 25565 ];
    allowedUDPPorts = [ 34197 ];
  };

  nixpkgs.overlays = [
    (self: super: rec {
      hugo-site = super.callPackage ./packages/hugo-site {};
    })
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme_letsencrypt@marlena.app";
  };
}
