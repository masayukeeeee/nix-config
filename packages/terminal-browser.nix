{ lib, stdenvNoCC, fetchurl, makeWrapper }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "terminal-browser";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/zenbu-labs/terminal-browser/releases/download/v${finalAttrs.version}/terminal-browser-darwin-arm64.tar.gz";
    hash = "sha256-0tGgYLYgjxyMUEoa+CXu0PsFv629iyPx4AZWGcV350k=";
  };

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = "terminal-browser";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/libexec/terminal-browser"
    cp -R . "$out/libexec/terminal-browser"

    makeWrapper \
      "$out/libexec/terminal-browser/bin/terminal-browser" \
      "$out/bin/terminal-browser"

    runHook postInstall
  '';

  meta = {
    description = "Browser that runs directly inside your terminal";
    homepage = "https://github.com/zenbu-labs/terminal-browser";
    license = lib.licenses.asl20;
    mainProgram = "terminal-browser";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
