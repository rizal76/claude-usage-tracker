#!/usr/bin/env bash
# Copies the status line script to ~/.claude and points settings.json's statusLine at it.
set -euo pipefail
command -v jq >/dev/null || { echo "jq is required (brew install jq / apt install jq)"; exit 1; }
dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/usage-statusline.sh"
mkdir -p "$dir"
cp "$src" "$dir/usage-statusline.sh" && chmod +x "$dir/usage-statusline.sh"
settings="$dir/settings.json"
[ -f "$settings" ] || echo '{}' > "$settings"
cp "$settings" "$settings.bak-usage-tracker"
jq --arg cmd "$dir/usage-statusline.sh" '.statusLine = {type: "command", command: $cmd}' "$settings.bak-usage-tracker" > "$settings"
echo "Installed. statusLine -> $dir/usage-statusline.sh (backup: $settings.bak-usage-tracker). Restart Claude Code."
