#!/bin/bash
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

GHIDRA_VERSION="12.1.4"
GHIDRA_ZIP="ghidra_${GHIDRA_VERSION}_PUBLIC_20260921.zip"
GHIDRA_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRA_VERSION}_build/${GHIDRA_ZIP}"
GHIDRA_DIR="/opt/ghidra/ghidra_${GHIDRA_VERSION}_PUBLIC"
JADX_JAR="/opt/jadx/jadx-headless-mcp-0.7.1-all.jar"
JADX_URL="https://github.com/1013503897/jadx-headless-mcp/releases/download/v0.7.1/jadx-headless-mcp-0.7.1-all.jar"

CURL=(curl -fsSL --retry 3)
[ -f /root/.ccr/ca-bundle.crt ] && CURL+=(--cacert /root/.ccr/ca-bundle.crt)

if ! command -v rea >/dev/null 2>&1; then
  npm install --global rea-agents
fi

if [ ! -x "$GHIDRA_DIR/support/analyzeHeadless" ]; then
  tmp="$(mktemp -d)"
  "${CURL[@]}" -o "$tmp/ghidra.zip" "$GHIDRA_URL"
  mkdir -p /opt/ghidra
  unzip -q -o "$tmp/ghidra.zip" -d /opt/ghidra
  rm -rf "$tmp"
fi

if [ ! -s "$JADX_JAR" ]; then
  mkdir -p "$(dirname "$JADX_JAR")"
  "${CURL[@]}" -o "$JADX_JAR" "$JADX_URL"
fi

export GHIDRA_INSTALL_DIR="$GHIDRA_DIR"
export REA_JADX_MCP_JAR="$JADX_JAR"

rea setup --yes --all-detected >/dev/null

if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  {
    echo "export GHIDRA_INSTALL_DIR=\"$GHIDRA_DIR\""
    echo "export REA_JADX_MCP_JAR=\"$JADX_JAR\""
  } >> "$CLAUDE_ENV_FILE"
fi
