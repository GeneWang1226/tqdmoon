#!/bin/sh
set -e

REPO="GeneWang1226/tqdmoon"
INSTALL_DIR="${INSTALL_DIR:-/usr/local}"
VERSION="${VERSION:-latest}"

detect_os() {
  case "$(uname -s)" in
    Linux*) echo "ubuntu-latest" ;;
    Darwin*) echo "macos-latest" ;;
    CYGWIN*|MINGW*|MSYS*) echo "windows-latest" ;;
    *) echo "unknown" ;;
  esac
}

OS=$(detect_os)
if [ "$OS" = "unknown" ]; then
  echo "Unsupported OS: $(uname -s)"
  exit 1
fi

if [ "$OS" = "windows-latest" ]; then
  echo "Windows is not supported by this shell installer."
  echo "Please download tqdmoon-windows-latest.tar.gz from the release manually."
  exit 1
fi

if [ "$VERSION" = "latest" ]; then
  URL="https://github.com/$REPO/releases/latest/download/tqdmoon-$OS.tar.gz"
else
  URL="https://github.com/$REPO/releases/download/$VERSION/tqdmoon-$OS.tar.gz"
fi

echo "Downloading tqdmoon for $OS (version: $VERSION) from $URL..."

if [ -w "$INSTALL_DIR" ]; then
  curl -fsSL "$URL" | tar -xzC "$INSTALL_DIR" --strip-components=1
else
  echo "Need sudo to install to $INSTALL_DIR"
  curl -fsSL "$URL" | sudo tar -xzC "$INSTALL_DIR" --strip-components=1
fi

echo "tqdmoon installed successfully to $INSTALL_DIR/bin/tqdmoon"
