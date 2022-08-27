{
  mobile-nixos
, runCommandNoCC
, fetchFromGitHub
, ...
}:

let

  appendDtb = device: rawkernel: dtb: 
    (runCommandNoCC "${device}-kernel-dtb"
    {
      version = rawkernel.version;
      passthru =
        let
          rwp = rawkernel.passthru;
          p = (rwp // {
            file = "Image.${rawkernel.isCompressed}-dtb";
          });
        in p;
    }
    ''
      echo ':: Appending DTB'
      (PS4=" $ "; set -x
      cp -r ${rawkernel} $out
      chmod +w $out
      cat \
        ${rawkernel}/Image.${rawkernel.isCompressed} \
        ${dtb} \
        > $out/Image.${rawkernel.isCompressed}-dtb
      )
    '');

vk = mobile-nixos.kernel-builder-gcc6 rec {
  configfile = ./config.aarch64;

  version = "5.15.0-msm8916";
  src = fetchFromGitHub {
    owner = "OpenStick";
    repo = "linux";
    rev = "3b1d3bfb978fb2be6707d033f26205104d60c92f";
    sha256 = "sha256-Ui1eAWIE4ogyXGyVWX4IbtkZb+0MSvSXLmjoX+DlPDQ=";
  };

  patches = [
    # ./0001-Revert-four-tty-related-commits.patch
    ./0003-arch-arm64-Add-config-option-to-fix-bootloader-cmdli.patch
    # ./99_framebuffer.patch
  ];
  hasDTB = true;

  enableRemovingWerror = true;
  isCompressed = "gz";
  kernelFile = "Image.${isCompressed}-dtb";
  isModular = false; #???
};

in
 (appendDtb "openstick" vk "${vk}/dtbs/qcom/msm8916-handsome-openstick.dtb")
