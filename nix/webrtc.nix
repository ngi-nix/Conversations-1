# This file just fetches webrtc' aar file
# https://mvnrepository.com/artifact/org.webrtc/google-webrtc?repo=bt-google-webrtc
{ fetchurl, ... }:
fetchurl {
  url = "https://plugins.gradle.org/m2//org/webrtc/google-webrtc/1.0.32006/google-webrtc-1.0.32006.aar";
  sha256 = "11vpjffw8n9kpcfr8kl1fhxn5n7blyjm3dw98g9khxwjfkmkralc";
}
