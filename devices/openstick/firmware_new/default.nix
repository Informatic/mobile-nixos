{ lib
, runCommandNoCC
, fetchurl
, fetchgit
, unzip
, e2fsprogs
, simg2img
}:

let
  # TODO: no, we need to reassemble and upload a zip since it uses files from multiple partitions
  # and google drive and etc...
  upstreamImage = fetchurl {
    url = "https://drive.google.com/uc?export=download&id=1RFtFref2-v4JdpsbLs4G56MTMnQgQEdh";
    sha256 = "sha256-1Je703z+byctPirmcnFbcB2cV/Nc90fB/mDk5cdsegM=";
  };
in runCommandNoCC "uf896_v1_1_ogfw" {
  nativeBuildInputs = [ unzip e2fsprogs simg2img ];
  meta.license = [
    # We make no claims that it can be redistributed.
    lib.licenses.unfree
  ];
} ''
  unzip ${upstreamImage} debian/rootfs.img
  cd debian
  simg2img rootfs.img vendor-raw.img
  debugfs vendor-raw.img -R "rdump lib/firmware ."
  
  ls -al -R .

  mkdir -p $out/lib
  mv firmware $out/lib/firmware
  
  echo "--"
  ls -al $out/lib/firmware
  # exit -1
''
