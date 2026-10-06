{ stdenvNoCC, hugo, fetchFromGitHub }:

let
  archie = fetchFromGitHub {
    owner = "athul";
    repo = "archie";
    rev = "cbc1c3aaa2615fa348b85ef39eb4570cd3ac6414";
    hash = "sha256-hhr5WpoIbDsnzqaYIxTcLH5C3fslMFGVYUDWI5uCl1w=";
  };
in
stdenvNoCC.mkDerivation {
  name = "waddles-sysadmin-web";
  src = ./.;

  nativeBuildInputs = [
    hugo
  ];

  postPatch = ''
    mkdir -p themes
    cp -r ${archie} themes/archie
    chmod -R u+w themes/archie
  '';

  buildPhase = ''
    hugo --baseURL https://www.ocf.berkeley.edu/~erdaifuu/
  '';

  installPhase = ''
    mv public $out
  '';
}
