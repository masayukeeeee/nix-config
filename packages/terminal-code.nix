{ lib, stdenvNoCC, fetchurl, makeWrapper }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "terminal-code";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/zenbu-labs/terminal-code/releases/download/v${finalAttrs.version}/tode-darwin-arm64.tar.gz";
    hash = "sha256-p9hov1gVpsHshoAYIN0+RqipN+EY5KShbH/pOqbC8b4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = "tode";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/libexec/tode"
    cp -R . "$out/libexec/tode"

    makeWrapper \
      "$out/libexec/tode/bin/tode" \
      "$out/bin/tode" \
      --set TODE_INSTALL_ROOT "$out/libexec/tode"

    runHook postInstall
  '';

  meta = {
    description = "VS Code inside your terminal";
    homepage = "https://github.com/zenbu-labs/terminal-code";
    license = lib.licenses.mit;
    mainProgram = "tode";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
