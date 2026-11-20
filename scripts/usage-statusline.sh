#!/usr/bin/env bash
# Claude Code status line: plan usage vs. target (the even-spread share for the time already passed),
# for the 5h and weekly windows. Reads the statusLine JSON on stdin; `rate_limits` exists only for
# subscription (Pro/Max) logins and only after the first API reply of a session.
# Needs: bash, jq, awk, date (macOS/BSD or GNU).
input=$(cat)
[ -n "$USAGE_STATUSLINE_DEBUG" ] && printf '%s\n' "$input" >> "$USAGE_STATUSLINE_DEBUG"
now=$(date +%s)

# fmt EPOCH FORMAT: BSD date takes -r EPOCH, GNU date takes -d @EPOCH.
if date -r 0 +%s >/dev/null 2>&1; then fmt() { date -r "$1" "+$2"; }; else fmt() { date -d "@$1" "+$2"; }; fi
today=$(fmt "$now" %Y%m%d)
tomorrow=$(fmt $((now + 86400)) %Y%m%d)

part() { # label key window_seconds window_label
  local used reset day when
  used=$(jq -r ".rate_limits.$2.used_percentage // empty" <<<"$input")
  # resets_at: epoch seconds, or ISO-8601 as a fallback
  reset=$(jq -r "(.rate_limits.$2.resets_at // empty) | if type==\"string\" then fromdateiso8601 else . end" <<<"$input" 2>/dev/null)
  [ -z "$used" ] || [ -z "$reset" ] && return
  day=$(fmt "$reset" %Y%m%d)
  if [ "$day" = "$today" ]; then when="today"; elif [ "$day" = "$tomorrow" ]; then when="tomorrow"; else when=$(fmt "$reset" "%a %d %b"); fi
  when="$when $(fmt "$reset" %H:%M)"
  awk -v l="$1" -v u="$used" -v r="$reset" -v n="$now" -v w="$3" -v wl="$4" -v when="$when" 'BEGIN {
    left = r - n; if (left < 0) left = 0; if (left > w) left = w
    el = w - left
    target = el / w * 100
    d = u - target
    c = (d > 10) ? 196 : (d > 0) ? 214 : 108
    h = int(el / 3600); m = int((el % 3600) / 60)
    passed = (h >= 24) ? sprintf("%dd%dh", h / 24, h % 24) : sprintf("%dh%02dm", h, m)
    verdict = (d > 0) ? sprintf("OVER target by %.0f%% - slow down", d) : sprintf("%.0f%% under target - OK", -d)
    printf "\033[38;5;%dm%-6s Usage %.0f%% | Target %.0f%% (%s of %s passed) | %s | Resets %s\033[0m", c, l, u, target, passed, wl, verdict, when
  }'
}

five=$(part "5h" five_hour 18000 5h)
week=$(part "Weekly" seven_day 604800 7d)
if [ -z "$five$week" ]; then
  printf 'Claude usage: no plan-limit data yet (subscription login only; appears after the first reply)'
else
  printf '\033[1;38;5;111m◆ CLAUDE USAGE TRACKER\033[0m  \033[38;5;245m· now %s\033[0m\n' "$(fmt "$now" '%a %d %b %H:%M')"
  printf '%s' "$five"; [ -n "$five" ] && [ -n "$week" ] && printf '\n'; printf '%s' "$week"
fi
