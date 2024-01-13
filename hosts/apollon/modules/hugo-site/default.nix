{ config, pkgs, ... }:

let
  webDomain = "kuscheltiere.app";
in
{
  services.nginx = {
    enable = true;

    virtualHosts."${webDomain}" = {
      serverAliases = [ "www.${webDomain}" ];
      enableACME = true;
      addSSL = true;
      locations = {
        "/" = {
#           alias = "${pkgs.hugo-site}/";
          alias = "${pkgs.hugo-site.override { baseURL = "https://${webDomain}"; }}/";
        };
      };
    };
  };
}
