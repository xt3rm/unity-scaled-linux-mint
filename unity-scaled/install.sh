#!/usr/bin/env bash
#
# install.sh — install the unity-scaled launcher and the Nemo right-click action.
#
# Re-run any time to update. Uninstall with ./install.sh --uninstall

set -euo pipefail

BIN="$HOME/.local/bin/unity-scaled"
ACTION="$HOME/.local/share/nemo/actions/unity-scaled.nemo_action"

if [ "${1:-}" = "--uninstall" ]; then
  rm -fv "$BIN" "$ACTION"
  echo "uninstalled."
  exit 0
fi

here="$(cd "$(dirname "$0")" && pwd)"

install -Dm755 "$here/unity-scaled"            "$BIN"
install -Dm644 "$here/unity-scaled.nemo_action" "$ACTION"

echo "installed:"
echo "  $BIN"
echo "  $ACTION"
echo

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) echo "note: ~/.local/bin is not on your PATH — add it so 'unity-scaled' is found."
     echo "      e.g. add this to ~/.bashrc:  export PATH=\"\$HOME/.local/bin:\$PATH\"" ;;
esac
