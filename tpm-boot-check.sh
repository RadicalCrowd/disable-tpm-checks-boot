#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"

usage() {
  cat <<EOF
Usage:
  $SCRIPT_NAME disable   # Mask tpm2.target (disable TPM boot check wait)
  $SCRIPT_NAME enable    # Unmask tpm2.target (re-enable)
  $SCRIPT_NAME status    # Show current unit state
  $SCRIPT_NAME reboot    # Reboot now
EOF
}

if ! command -v systemctl >/dev/null 2>&1; then
  echo "Error: systemctl not found. This script requires systemd." >&2
  exit 1
fi

action="${1:-disable}"

case "$action" in
  disable)
    echo "Masking tpm2.target..."
    sudo systemctl mask tpm2.target
    echo "TPM boot-check wait disabled."
    echo "Run '$SCRIPT_NAME status' to verify and reboot when ready."
    ;;
  enable)
    echo "Unmasking tpm2.target..."
    sudo systemctl unmask tpm2.target
    echo "TPM boot-check wait re-enabled."
    ;;
  status)
    systemctl show tpm2.target -p UnitFileState
    ;;
  reboot)
    sudo reboot
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    echo "Unknown action: $action" >&2
    usage
    exit 1
    ;;
esac
