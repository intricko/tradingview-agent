#!/bin/bash
echo "[start-3-ollama] Starting Ollama..."
runuser -l abc -c 'ollama serve > /tmp/ollama.log 2>&1 &'
runuser -l abc -c '( sleep 60 && ollama pull nomic-embed-text > /tmp/ollama-pull.log 2>&1 ) &'
echo "[start-3-ollama] Pulling nomic-embed-text for mnemon..."
