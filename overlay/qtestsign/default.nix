{ stdenv
, fetchFromGitHub
, python
, python3Packages
, buildPackages
}:

let
  inherit (buildPackages) dtc;
in
stdenv.mkDerivation {
  pname = "qtestsign";
  version = "unset";
  
  src = fetchFromGitHub {
    owner = "msm8916-mainline";
    repo = "qtestsign";
    rev = "931247f65c0a0e581c96d3528a655bf6646d6936";
    sha256 = "sha256-OobXD1TonNOIkxDjLpVU0eZmJRJu/2alHr2RJqZ8aso=";
  };

  # missing python packages of course:
  # cryptography... maybe others
  
  postPatch = ''
    patchShebangs *.py
  '';
  
  buildInputs = with python3Packages; [
    python
    cryptography
  ];

  nativeBuildInputs = [
    python3Packages.wrapPython
  ];
  propagatedNativeBuildInputs = [
    python3Packages.cffi
  ];
  
  # src is 4 python files next to each other
  # don't want to just drop them all in /bin/ plus how does python even work really?

  installPhase = ''
    patchShebangs ./
    mkdir -p $out/bin
    cp -v $src/* $out/
    mkdir -p $out/bin
    
    ln -s $out/qtestsign.py $out/bin/qtestsign
    wrapProgram $out/bin/qtestsign --prefix PYTHONPATH : "$PYTHONPATH"
  '';
  
  # TODO meta url : https://github.com/msm8916-mainline/qtestsign
}
