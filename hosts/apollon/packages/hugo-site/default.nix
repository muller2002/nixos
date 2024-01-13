{ lib
, stdenv
, pkgs
, baseURL ? "http://localhost"
}:

let
  hugoTheme = builtins.fetchTarball {
    name = "hugo-theme-gallery";
    url = "https://github.com/nicokaiser/hugo-theme-gallery/archive/22d9481d99ff773c6ca0977d9c1be85e752c059f.tar.gz";
    sha256 = "1kw14ar6a8z34m0xxvzbiy8rp1hb6kgsj10ixsxrijfwlcka92bg";
  };
in
stdenv.mkDerivation rec {
  pname = "hugo-site";
  version = "0.1";

  src = builtins.fetchGit {
    url = "git@github.com:muller2002/kuscheltiere-website.git";
    ref = "main";
    rev = "93979d1bbf5163f0c5337a1c93a26fcce62f88ad";
    submodules = true;
  };

  nativeBuildInputs = [ pkgs.hugo ];
  
  themePath = "gallery";
  installPhase = ''
    mkdir -p theme/${themePath};
#    cp -r ${hugoTheme}/* theme/${themePath}/;
    hugo --gc --minify -d $out;
  '';

  meta = {
    description = "Hugo project for ${pname}";
    homepage = "kuscheltiere.app";
  };
}