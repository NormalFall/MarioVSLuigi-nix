{ stdenvNoCC, fetchzip, zlib, libgcc, makeDesktopItem, copyDesktopItems
, buildFHSEnv, libGL, libXrandr, alsa-lib, udev }:
let
  pname = "nsmb-mvl";
  version = "1.7.1.0-beta";

  nsmb-mvl = stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchzip {
      url = "https://github.com/ipodtouch0218/NSMB-MarioVsLuigi/releases/download/v${version}/MarioVsLuigi-Linux-v${version}.zip";
      hash = "sha256-UrpUjE0MD0ayIU69wm+f1e72WStUQD14+CysdkDefrA=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r $src $out/.nsmb-mvl

      mkdir -p $out/share/icons
      cp $src/linux_Data/Resources/UnityPlayer.png $out/share/icons/nsmb-mvl.png

      mkdir -p $out/bin
      ln -s $out/.nsmb-mvl/linux.x86_64 $out/bin/nsmb-mvl
      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "NSMB-MvL";
        exec = "nsmb-mvl";
        icon = "nsmb-mvl";
        desktopName = "Mario VS Luigi";
        comment = "A unity-standalone 2-10 player remake of the Mario vs. Luigi gamemode from the New Super Mario Bros DS download game.";
        type = "Application";
        categories = [ "Game" ];
        keywords = [ "NSMB" "mario" ];
      })
    ];

    nativeBuildInputs = [ copyDesktopItems ];
  };
in buildFHSEnv {
  inherit pname version;

  targetPkgs = pkgs: ([ udev alsa-lib libgcc zlib libGL libXcursor libXrandr ]);
  multiPkgs = pkgs: ([ nsmb-mvl alsa-lib ]);

  runScript = "nsmb-mvl";

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -sf ${nsmb-mvl}/share/applications $out/share
    ln -sf ${nsmb-mvl}/share/icons $out/share
  '';
}

