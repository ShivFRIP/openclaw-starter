#!/bin/bash
# =============================================================================
# Add a team member's ChatGPT OAuth to OpenClaw with a NAMED profile
#
# The problem: `openclaw models auth login` always saves as openai-codex:default,
# overwriting the previous person. This script renames it after login.
#
# Usage: ./add-chatgpt-user.sh <name>
# Example: ./add-chatgpt-user.sh sahithi
# =============================================================================

if [ -z "$1" ]; then
  echo "Usage: $0 <name>"
  echo "Example: $0 sahithi"
  exit 1
fi

NAME="$1"
DOCKER="/usr/local/bin/docker"
CONTAINER="openclaw-openclaw-gateway-1"
AUTH_FILE="/home/node/.openclaw/agents/main/agent/auth-profiles.json"

echo "=== Step 1: OAuth login for ${NAME} ==="
echo "A browser URL will appear. Send it to ${NAME} — they log in with THEIR ChatGPT account."
echo ""

# Run the OAuth login (interactive — opens browser URL)
$DOCKER exec -it $CONTAINER openclaw models auth login --provider openai-codex

echo ""
echo "=== Step 2: Renaming profile to openai-codex:${NAME} ==="

# Rename the profile from openai-codex:default to openai-codex:<name>
$DOCKER exec $CONTAINER python3 -c "
import json

with open('${AUTH_FILE}') as f:
    data = json.load(f)

old_id = 'openai-codex:default'
new_id = 'openai-codex:${NAME}'

if old_id not in data['profiles']:
    print('ERROR: openai-codex:default not found. Login may have failed.')
    exit(1)

# Copy the profile with new name
data['profiles'][new_id] = data['profiles'].pop(old_id)

# Also move usageStats if exists
if old_id in data.get('usageStats', {}):
    data['usageStats'][new_id] = data['usageStats'].pop(old_id)

with open('${AUTH_FILE}', 'w') as f:
    json.dump(data, f, indent=2)

# Decode the token to confirm whose account it is
import base64
try:
    token = data['profiles'][new_id].get('access', '')
    payload = token.split('.')[1] + '=='
    decoded = json.loads(base64.urlsafe_b64decode(payload))
    email = decoded.get('https://api.openai.com/profile', {}).get('email', '?')
    plan = decoded.get('https://api.openai.com/auth', {}).get('chatgpt_plan_type', '?')
    print(f'✅ Profile saved: {new_id}')
    print(f'   Account: {email} (plan: {plan})')
except:
    print(f'✅ Profile saved: {new_id} (could not decode token details)')
"

echo ""
echo "=== Done ==="
echo "Run all team members in sequence, then restart the gateway once:"
echo "  docker compose restart openclaw-gateway"
