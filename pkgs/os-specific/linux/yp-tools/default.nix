{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  libxcrypt,
  libnsl,
  libtirpc,
  pkg-config,
}:

let
  version = "4.2.3";
in
stdenv.mkDerivation {
  pname = "yp-tools";
  inherit version;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libxcrypt
    libnsl
    libtirpc
  ];

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "yp-tools";
    rev = "v${version}";
    hash = "sha256-e9Q9bNr5ZpLJQ6QqIBxVbv/ShXC4pOdwgrCA6/QAcL0=";
  };

  outputs = [ "out" ];

  configurePhase = ''
    runHook preConfigure

    ./autogen.sh
    ./configure --prefix=/

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    DESTDIR="$out" make install

    runHook postInstall
  '';

  meta = with lib; {
    description = "Network information service (YP) client utilities";
    homepage = "https://www.linux-nis.org/nis/yp-tools/";
    changelog = "https://github.com/thkukuk/yp-tools/blob/master/NEWS";
    license = licenses.gpl2;
    maintainers = with maintainers; [ BarrOff ];
    platforms = platforms.linux;
  };
}
