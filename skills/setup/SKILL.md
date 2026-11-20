---
name: setup
description: >
  Install the Claude usage tracker status line (5h and weekly plan usage vs. target).
  Use for /claude-usage-tracker:setup, "set up usage status line", "show my plan usage in the status line".
---

# Set up the usage status line

A plugin cannot set `statusLine` itself, so run the installer once:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/install.sh"
```

It copies the script to `~/.claude/usage-statusline.sh` and sets `statusLine` in `~/.claude/settings.json`
(the old file is kept as `settings.json.bak-usage-tracker`). Then tell the user to restart Claude Code.

If `${CLAUDE_PLUGIN_ROOT}` is empty, find `install.sh` under `~/.claude/plugins` and run that path.
Do nothing else: no other settings, no extra files.
