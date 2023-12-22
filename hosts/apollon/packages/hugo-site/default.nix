{ lib
, stdenv
, pkgs
, baseURL ? "http://localhost"
}:

let
  hugoTheme = builtins.fetchTarball {
    name = "hugo-theme-gallery";
    url = "https://github.com/nicokaiser/hugo-theme-gallery/archive/22d9481d99ff773c6ca0977d9c1be85e752c059f.tar.gz";
    sha256 = "c2b2cb42bd9c8adeb6a663f9f41474f590802d28fd08dbb5d61562b90575028c";
  };
in
stdenv.mkDerivation rec {
  pname = "hugo-site";
  version = "0.1";

  src = builtins.fetchGit {
    url = "https://github.com/muller2002/kuscheltiere-website";
    ref = "main";
  };

  nativeBuildInputs = [ pkgs.hugo ];
  
  themePath = "gallery";
  installPhase = ''
    mkdir -p theme/${themePath};
    cp -r ${hugoTheme}/* theme/${themePath}/;
    hugo -b ${baseURL} -t ${themePath} -d $out;
  '';

  meta = {
    description = "Hugo project for ${pname}";
    homepage = "kuscheltiere.app";
  };
}
