#!/bin/bash
source /custom-cont-init.d/common.sh || exit 1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SRC="/custom-cont-init.d/CodeServer.desktop"

sync_desktop_file "$SRC" "/config/.config/autostart/CodeServer.desktop"
sync_desktop_file "$SRC" "/config/Desktop/CodeServer.desktop"

chown abc:abc /usr/local/lib/node_modules
chown abc:abc /usr/local/bin

# Add VSCode Extension vscode's config as soon as it appears
(
  for i in {0..999}; do
      if [ -d "/config/.local/share/code-server/User" ]; then
        echo "[start-codeserver] code-server configuration found in ~/.local/share/code-server, setting permissions and installing extensions"
        break
      else
        echo "[start-codeserver] Force code-server to initialize by calling URI"
        curl -s http://localhost:8888 > /dev/null 2>&1
      fi
      sleep 5
  done

  chown -R abc:abc /config/.local/share/code-server

  EXTENSION=saoudrizwan.claude-dev
  if code --list-extensions | grep -q "${EXTENSION}"; then
    echo "[start-codeserver] Extension ${EXTENSION} already installed, skip"
  else
    echo "[start-codeserver] Installing Extension ${EXTENSION}..."
    mkdir -p "$HOME/.cline/data"
    cp "${SCRIPT_DIR}/globalState.json" "$HOME/.cline/data/globalState.json"
    cp "${SCRIPT_DIR}/secrets.json" "$HOME/.cline/data/secrets.json"
    runuser -l abc -c "code --install-extension ${EXTENSION}"
    chown -R abc:abc $HOME/.cline/data
  fi

  EXTENSION=anthropic.claude-code
  if code --list-extensions | grep -q "${EXTENSION}"; then
    echo "[start-codeserver] Extension ${EXTENSION} already installed, skip"
  else
    echo "[start-codeserver] Installing Extension ${EXTENSION} + claude-cli..."
    runuser -l abc -c "mkdir -p $HOME/.claude"
    runuser -l abc -c "cp ${SCRIPT_DIR}/claude-term-settings.json $HOME/.claude/settings.json"
    runuser -l abc -c "curl -fsSL https://claude.ai/install.sh | bash"
    runuser -l abc -c "mkdir -p $HOME/.local/share/code-server/User"
    runuser -l abc -c "cp ${SCRIPT_DIR}/claude-vscode-settings.json $HOME/.local/share/code-server/User/settings.json"
    runuser -l abc -c "cp ${SCRIPT_DIR}/CLAUDE.md $HOME/.claude/CLAUDE.md"
    runuser -l abc -c "code --install-extension ${EXTENSION}"
    chown -R abc:abc $HOME/.claude
    # integrate mnemon into claude-code
    runuser -l abc -c "mnemon setup --yes --global  --target claude-code"
  fi

  EXTENSION=hermes-code-agent
  VERSION=3.0.2
  if code --list-extensions | grep -q "${EXTENSION}"; then
    echo "[start-codeserver] Extension ${EXTENSION} already installed, skip"
  else
    echo "[start-codeserver] Installing Extension ${EXTENSION}..."
    runuser -l abc -c "curl -sL https://github.com/gitricko/hermes-vscode/releases/download/v${VERSION}/${EXTENSION}-${VERSION}.vsix -o /tmp/${EXTENSION}.vsix && code --install-extension /tmp/${EXTENSION}.vsix --force && rm /tmp/${EXTENSION}.vsix"
  fi

) &
