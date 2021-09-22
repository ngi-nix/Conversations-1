{
  description = "Conversations is an open source XMPP/Jabber client for Android ";

  inputs.android2nix.url = "github:Mazurel/android2nix";

  outputs = { self, android2nix }:
    android2nix.lib.mkAndroid2nixEnv (
      { stdenv, callPackage, gradle, jdk11, ... }: {
      pname = "Conversations";

      src =
        let
          # Currently webrtc is fetched form maven repo,
          # it should be compiled manually in the future.
          # It may be impossible right now with Nix.
          webrtc = callPackage ./nix/webrtc.nix { };
        in stdenv.mkDerivation {
        pname = "Conversations";
        version = "dev";
        src = ./.;
        dontBuild = true;
        dontConfigure = true;

        installPhase = ''
          mkdir -p $out
          cp -rf ./* $out/
        '';

        fixupPhase = ''
          cd $out

          mkdir libs
          cp ${webrtc} libs/libwebrtc-m92.aar
          cp ${webrtc} libs/libwebrtc.aar
        '';
      };

      gradlePkg = gradle;
      jdk = jdk11;
      devshell = ./nix/devshell.toml;
      deps = ./nix/deps.json;
      buildType = "assembleConversationsFreeSystemDebug";
    });
}
