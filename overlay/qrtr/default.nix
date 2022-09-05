{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  version = "2020-12-07";
  name = "qrtr";

  src = fetchFromGitHub {
    owner = "andersson";
    repo = name;
    rev = "9dc7a88548c27983e06465d3fbba2ba27d4bc050";
    sha256 = "076k28py3cvjsczhm0dfqnnigr2crgc3x33xflkzw8p9yanq973q";
  };

  makeFlags = [ "prefix=$(out)" ];
}
