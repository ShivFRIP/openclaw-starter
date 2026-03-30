#!/bin/bash
# Team Onboarding — Add a new team member
# Usage: ./onboard-member.sh <telegram_user_id> "<full_name>" "<role>" "<projects>"
# Example: ./onboard-member.sh 1234567890 "Jane Smith" "Analyst" "research"

set -euo pipefail

# ─── Auto-detect environment (host vs sandbox) ───────────────────────────
OPENCLAW_HOME=""
WORKSPACE=""

if [ -d "/openclaw/credentials" ]; then
    OPENCLAW_HOME="/openclaw"
    WORKSPACE="/workspace"
elif [ -d "$HOME/.openclaw/credentials" ]; then
    OPENCLAW_HOME="$HOME/.openclaw"
    WORKSPACE="$HOME/.openclaw/workspace"
else
    echo "ERROR: Cannot find OpenClaw home directory."
    echo "Expected: $HOME/.openclaw/credentials/"
    exit 1
fi

# ─── Validate arguments ──────────────────────────────────────────────────
if [ $# -lt 3 ]; then
    echo "Usage: $0 <telegram_user_id> \"<full_name>\" \"<role>\" [\"<projects>\"]"
    echo ""
    echo "Arguments:"
    echo "  telegram_user_id  Numeric Telegram user ID"
    echo "  full_name         Full name in quotes"
    echo "  role              Role/title in quotes"
    echo "  projects          Comma-separated project names (optional, default: none)"
    echo ""
    echo "Example:"
    echo "  $0 1234567890 \"Jane Smith\" \"Analyst\" \"research\""
    exit 1
fi

TELEGRAM_ID="$1"
FULL_NAME="$2"
ROLE="$3"
PROJECTS="${4:-none}"
TODAY=$(date +%Y-%m-%d)

ALLOWLIST_FILE="${OPENCLAW_HOME}/credentials/telegram-default-allowFrom.json"
USER_MD="${WORKSPACE}/USER.md"

# ─── Validate Telegram ID is numeric ─────────────────────────────────────
if ! [[ "$TELEGRAM_ID" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Telegram ID must be numeric. Got: $TELEGRAM_ID"
    exit 1
fi

# ─── Check for duplicates ────────────────────────────────────────────────
EXISTING=$(python3 -c "
import json
with open('${ALLOWLIST_FILE}') as f:
    data = json.load(f)
print('yes' if '${TELEGRAM_ID}' in data.get('allowFrom', []) else 'no')
" 2>/dev/null)

if [ "$EXISTING" = "yes" ]; then
    echo "ERROR: Telegram ID $TELEGRAM_ID is already in the allowlist."
    exit 1
fi

# ─── Add to Telegram allowlist ────────────────────────────────────────────
echo "Adding $FULL_NAME ($TELEGRAM_ID) to Telegram allowlist..."

python3 << PYEOF
import json, os
allowlist_file = "${ALLOWLIST_FILE}"
telegram_id = "${TELEGRAM_ID}"
with open(allowlist_file) as f:
    data = json.load(f)
data["allowFrom"].append(telegram_id)
tmp_file = allowlist_file + ".tmp"
with open(tmp_file, "w") as f:
    json.dump(data, f, indent=2)
os.replace(tmp_file, allowlist_file)
count = len(data["allowFrom"])
print(f"  Added {telegram_id} to allowlist ({count} total members)")
PYEOF

# ─── Add to USER.md team registry ────────────────────────────────────────
echo "Adding to USER.md team registry..."

if grep -q "## Team Members" "$USER_MD" 2>/dev/null; then
    echo "| $TELEGRAM_ID | $FULL_NAME | $ROLE | $PROJECTS | $TODAY |" >> "$USER_MD"
    echo "  Appended to team registry"
else
    echo "  WARNING: Team Members section not found in USER.md."
fi

# ─── Summary ──────────────────────────────────────────────────────────────
echo ""
echo "========================================"
echo "  ONBOARDING COMPLETE: $FULL_NAME"
echo "========================================"
echo ""
echo "  Telegram ID:  $TELEGRAM_ID"
echo "  Role:         $ROLE"
echo "  Projects:     $PROJECTS"
echo "  Added:        $TODAY"
echo ""
echo "  Next steps:"
echo "  1. Ask $FULL_NAME to message your bot on Telegram"
echo "  2. The bot will send them a personalized welcome message"
echo ""
echo "  To remove this member later:"
echo "    bash ${OPENCLAW_HOME}/scripts/offboard-member.sh $TELEGRAM_ID"
echo ""
