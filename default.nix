{ stdenvNoCC, hugo }:

stdenvNoCC.mkDerivation {
  name = "waddles-sysadmin-web";
  src = ./.;

  nativeBuildInputs = [
    hugo
  ];

  buildPhase = ''
    hugo --baseURL https://www.ocf.berkeley.edu/~erdaifuu/
  '';

  installPhase = ''
    mv public $out
  '';
}
