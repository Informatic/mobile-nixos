{ stdenv
, fetchFromGitHub
, dtc
, gcc-arm-embedded
, python3
, src ? null
, buildTarget ? "lk1st-msm8916"
, outputFile ? "emmc_appsboot.mbn"
}:

# TODO: 
# this isn't generic enough to be useful :/

let
  python = (python3.withPackages (p: [
    p.libfdt
  ]));
  
  _src = (if src != null then src else
    fetchFromGitHub {
      owner = "msm8916-mainline";
      repo = "lk2nd";
      rev = "b3153b1580702bf7510cb0846a0dc6b7ff3ec428";
      sha256 = "0xl7k5paf66p57sphm4nfa4k86yf93lhdzzr0cv0l4divq12gxxx";
    }
  );
in
stdenv.mkDerivation {
  pname = "lk2nd";
  version = "unset";
  
  src = _src;
  postPatch = ''
    patchShebangs --build scripts/{dtbTool,mkbootimg}
  '';
  
  nativeBuildInputs = [
    gcc-arm-embedded
    dtc
    python
  ];
  buildInputs = [];
  
  makeFlags = [
    buildTarget
    "TOOLCHAIN_PREFIX=arm-none-eabi-"
    "LD=arm-none-eabi-ld"
  ];
  
  # doCheck = false; # lord, I'm lazy and they're slow
  # they passed once, so... meh
  
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -prv "build-${buildTarget}/${outputFile}" $out/
    runHook postInstall
  '';
  
  meta = {
    # TODO: https://github.com/msm8916-mainline/lk2nd  
  };
}
