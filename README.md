# claude-usage-tracker

A Claude Code status line that shows your plan usage against an even-spread target:

```
◆ CLAUDE USAGE TRACKER  · now Fri 20 Nov 09:32
5h     Usage 55% | Target 27% (1h21m of 5h passed) | OVER target by 28% - slow down | Resets today 13:11
Weekly Usage 14% | Target 29% (2d0h of 7d passed) | 15% under target - OK | Resets Wed 25 Nov 09:32
```

- **Usage**: the plan-limit percentage Claude Code reports.
- **Target**: where usage would be if you spread it evenly over the window (share of the window already passed).
- Green = under target, amber = over, red = more than 10 points over.

## Install

```
/plugin marketplace add rizal76/claude-usage-tracker
/plugin install claude-usage-tracker@claude-usage-tracker
/claude-usage-tracker:setup
```

Or without the plugin system: `git clone` this repo, run `bash scripts/install.sh`, restart Claude Code.
The installer copies the script to `~/.claude/usage-statusline.sh` and sets `statusLine` in `settings.json` (backup kept).

## Limits

- Needs `jq`, `awk`, `date` (macOS or GNU). Not tested on Windows.
- Plan limits are only sent for Claude.ai subscription logins (Pro/Max), after the first reply of a session. Otherwise you see a "no plan-limit data" line.
- A custom `ANTHROPIC_BASE_URL` proxy may strip the rate-limit data.
- The target is a linear pace, not an official cap; Anthropic publishes only the percentage and reset time.
- Debug: set `USAGE_STATUSLINE_DEBUG=/tmp/usage.log` to log the JSON Claude Code sends.
