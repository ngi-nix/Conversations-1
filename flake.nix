# This file allows building Conversations with Nix build system.
# To learn more about nix, see: https://nixos.org/
# To enable flakes (required for building this project), see:
# https://nixos.wiki/wiki/Flakes
# To update dependencies (if this build fails), please run:
# > nix develop .
# > generate --root-dir ../. --jobs <Num of your cores>
# > exit
# Profit ! (aka it should build)
{
  description = "Conversations is an open source XMPP/Jabber client for Android ";

  inputs.android2nix.url = "github:Mazurel/android2nix";

  inputs.conversations = {
    url = "github:iNPUTmice/Conversations";
    flake = false;
  };

  outputs = { self, android2nix, conversations }:
    android2nix.lib.mkAndroid2nixEnv (
      { stdenv, callPackage, gradle, jdk11, ... }: rec {
        pname = "Conversations";
        src =
          let
            # Currently webrtc is fetched form maven repo,
            # it should be compiled manually in the future.
            # It is really complicated right now with Nix (due to gsync).
            webrtc = callPackage ./nix/webrtc.nix {};
          in
            stdenv.mkDerivation {
              inherit pname;
              version = "dev";
              src = conversations;
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
      }
    );
}
