{stdenv, fetchFromGitHub, qrtr, udev}:

stdenv.mkDerivation rec {
  version = "2022-07-18";
  name = "rmtfs";

  src = fetchFromGitHub {
    owner = "andersson";
    repo = name;
    rev = "695d0668ffa6e2a4bf6e676f3c58a444a5d67690";
    sha256 = "187hi10pfhvc66yja3qv04847rgclpj9arddvc8h2w1hv66qwhnk";
  };

  buildInputs = [ qrtr udev ];

  makeFlags = [ "prefix=$(out)" ];

  # NOTE: Makefile references qmic, however it is not needed due to the target
  # already existing
}
