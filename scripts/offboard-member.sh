#!/bin/bash
# Team Offboarding — Remove a team member
# Usage: ./offboard-member.sh <telegram_user_id>

set -euo pipefail

# ─── Auto-detect environment (host vs sandbox) ───────────────────────────
OPENCLAW_HOME=""

if [ -d "/openclaw/credentials" ]; then
    OPENCLAW_HOME="/openclaw"
elif [ -d "$HOME/.openclaw/credentials" ]; then
    OPENCLAW_HOME="$HOME/.openclaw"
else
    echo "ERROR: Cannot find OpenClaw home directory."
    echo "Expected: $HOME/.openclaw/credentials/"
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "Usage: $0 <telegram_user_id>"
    echo ""
    echo "Removes a team member from the Telegram allowlist."
    echo "Note: Does NOT delete their conversation history or USER.md entry."
    echo ""
    echo "To see current members:"
    echo "  cat ${OPENCLAW_HOME}/credentials/telegram-default-allowFrom.json"
    exit 1
fi

TELEGRAM_ID="$1"
ALLOWLIST_FILE="${OPENCLAW_HOME}/credentials/telegram-default-allowFrom.json"

# Check if ID exists in allowlist
EXISTING=$(python3 -c "
import json
with open('${ALLOWLIST_FILE}') as f:
    data = json.load(f)
print('yes' if '${TELEGRAM_ID}' in data.get('allowFrom', []) else 'no')
" 2>/dev/null)

if [ "$EXISTING" != "yes" ]; then
    echo "ERROR: Telegram ID $TELEGRAM_ID is not in the allowlist."
    exit 1
fi

# Remove from allowlist
python3 << PYEOF
import json, os
allowlist_file = "${ALLOWLIST_FILE}"
telegram_id = "${TELEGRAM_ID}"
with open(allowlist_file) as f:
    data = json.load(f)
data["allowFrom"] = [uid for uid in data["allowFrom"] if uid != telegram_id]
tmp_file = allowlist_file + ".tmp"
with open(tmp_file, "w") as f:
    json.dump(data, f, indent=2)
os.replace(tmp_file, allowlist_file)
count = len(data["allowFrom"])
print(f"Removed {telegram_id} from allowlist ({count} members remaining)")
PYEOF

echo ""
echo "Note: Their USER.md entry and conversation history are preserved."
echo "To fully remove, also edit USER.md and delete their session files."
