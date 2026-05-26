#!/bin/bash

(
    
runuser -l abc -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended '

ZSHRC="$HOME/.zshrc"
TARGET_LINE='export PATH="$HOME/.local/bin:$PATH"'

# 1. Check if ~/.zshrc exists
if [ -f "$ZSHRC" ]; then
    echo "[start-5-ohmyzsh.sh] ~/.zshrc found. Checking PATH configuration..."
    cat "$ZSHRC"
    # 2. Check if the specific PATH line is already set in the file
    if grep -Fxq "$TARGET_LINE" "$ZSHRC"; then
        echo "[start-5-ohmyzsh.sh] PATH is already correctly configured in ~/.zshrc."
    else
        # 3. If not set, append it
        runuser -l abc -c 'echo "$TARGET_LINE" >> "$ZSHRC"'
        echo "[start-5-ohmyzsh.sh] Successfully added ~/.local/bin to your PATH in ~/.zshrc."
        echo "[start-5-ohmyzsh.sh] Please run 'source ~/.zshrc' to apply changes to your current session."
        cat "$ZSHRC"
    fi
else
    echo "[start-5-ohmyzsh.sh] Error: ~/.zshrc does not exist. Skipping configuration."
fi

) &