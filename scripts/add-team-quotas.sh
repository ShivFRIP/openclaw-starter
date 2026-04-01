#!/bin/bash
# =============================================================================
# Add Team Member Quota Profiles to OpenClaw
#
# This script adds a team member's personal ChatGPT or Gemini credentials
# to OpenClaw's auth pool. When one account hits rate limits, OpenClaw
# automatically rotates to the next available account.
#
# Usage:
#   ./add-team-quotas.sh gemini <name> <api_key>
#   ./add-team-quotas.sh chatgpt <name>
#   ./add-team-quotas.sh list
#   ./add-team-quotas.sh status
# =============================================================================

DOCKER_CMD="/usr/local/bin/docker exec"
CONTAINER="openclaw-openclaw-gateway-1"
AUTH_FILE="/home/node/.openclaw/agents/main/agent/auth-profiles.json"

case "$1" in
  gemini)
    if [ -z "$2" ] || [ -z "$3" ]; then
      echo "Usage: $0 gemini <name> <api_key>"
      echo "Example: $0 gemini sahithi AIzaSyB..."
      exit 1
    fi
    NAME="$2"
    KEY="$3"
    PROFILE_ID="google:${NAME}"

    echo "Adding Gemini profile: ${PROFILE_ID}"
    $DOCKER_CMD $CONTAINER openclaw models auth paste-token \
      --provider google \
      --profile-id "${PROFILE_ID}" <<< "${KEY}"

    echo ""
    echo "✅ Done! Profile ${PROFILE_ID} added."
    echo "OpenClaw will now rotate to ${NAME}'s Gemini quota when others are exhausted."
    ;;

  chatgpt)
    if [ -z "$2" ]; then
      echo "Usage: $0 chatgpt <name>"
      echo "Example: $0 chatgpt sahithi"
      exit 1
    fi
    NAME="$2"

    echo "Starting ChatGPT OAuth login for: ${NAME}"
    echo ""
    echo "IMPORTANT: A browser window will open."
    echo "The team member should log in with THEIR ChatGPT account."
    echo ""
    echo "After login, the profile will be saved as: openai-codex:${NAME}"
    echo ""

    # Run OAuth flow
    $DOCKER_CMD -it $CONTAINER openclaw models auth login \
      --provider openai-codex

    # After OAuth completes, the profile is saved as openai-codex:default or
    # openai-codex:<email>. We may need to rename it.
    echo ""
    echo "OAuth complete. Checking profile name..."
    echo "If the profile was saved with the wrong name, manually rename in auth-profiles.json"
    ;;

  list)
    echo "=== Current Auth Profiles ==="
    $DOCKER_CMD $CONTAINER cat /home/node/.openclaw/agents/main/agent/auth-profiles.json 2>/dev/null | \
      python3 -c "
import sys, json
d = json.load(sys.stdin)
profiles = d.get('profiles', {})
by_provider = {}
for pid, p in profiles.items():
    prov = p.get('provider', '?')
    by_provider.setdefault(prov, []).append(pid)

for prov, pids in sorted(by_provider.items()):
    print(f'\n{prov} ({len(pids)} profiles):')
    for pid in pids:
        ptype = profiles[pid].get('type', '?')
        print(f'  - {pid} ({ptype})')

print(f'\nTotal: {len(profiles)} profiles across {len(by_provider)} providers')
print(f'Quota multiplier: {max(len(v) for v in by_provider.values())}x for best-covered provider')
"
    ;;

  status)
    echo "=== Profile Health Status ==="
    $DOCKER_CMD $CONTAINER cat /home/node/.openclaw/agents/main/agent/auth-profiles.json 2>/dev/null | \
      python3 -c "
import sys, json, time, datetime
d = json.load(sys.stdin)
profiles = d.get('profiles', {})
stats = d.get('usageStats', {})

for pid in sorted(profiles.keys()):
    s = stats.get(pid, {})
    errors = s.get('errorCount', 0)
    rl = s.get('failureCounts', {}).get('rate_limit', 0)
    cooldown = s.get('cooldownUntil', 0)
    last_used = s.get('lastUsed', 0)

    now_ms = time.time() * 1000
    icon = '🔴' if (cooldown > now_ms) else ('🟡' if rl > 0 else '🟢')

    lu_str = datetime.datetime.fromtimestamp(last_used/1000).strftime('%b %d %H:%M') if last_used else 'never'

    print(f'{icon} {pid:<35} errors={errors} rate_limits={rl} last_used={lu_str}')
"
    ;;

  *)
    echo "OpenClaw Team Quota Pooling"
    echo ""
    echo "Usage:"
    echo "  $0 gemini <name> <api_key>  — Add a Gemini API key for a team member"
    echo "  $0 chatgpt <name>           — Start ChatGPT OAuth for a team member"
    echo "  $0 list                     — List all auth profiles"
    echo "  $0 status                   — Show profile health/quota status"
    echo ""
    echo "Team members:"
    echo "  shiv, sahithi, gaurav, sai, akshay"
    ;;
esac
