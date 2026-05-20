#!/bin/bash
source /custom-cont-init.d/common.sh || exit 1

SRC="/custom-cont-init.d/Hermes.desktop"

chown abc:abc -R /usr/local/lib/hermes-agent/web
chown abc:abc -R /usr/local/lib/hermes-agent &

sync_desktop_file "$SRC" "/config/.config/autostart/Hermes.desktop"
sync_desktop_file "$SRC" "/config/Desktop/Hermes.desktop"

if [ -d "$HOME/.hermes/sessions" ] && [ -z "$(ls -A "$HOME/.hermes/sessions")" ]; then
  echo "[start-1-hermes.sh] No sessions found in $HOME/.hermes/sessions, setting up default configuration for custom provider"
  hermes config set model.provider custom
  hermes config set model.base_url http://localhost:7352/v1
  hermes config set model.default auto-fastest
  # Turn off approval alert and live dangerously since u are in a self-contained container.
  hermes config set approvals.mode off
  # Turn on memory by default
  hermes config set memory.memory_enabled true
  hermes config set memory.user_profile_enabled true
fi

chown abc:abc -R  ~/.hermes
