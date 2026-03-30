# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics -- the stuff that's unique to your setup.

## Environment

- **OS:** macOS (Mac Mini, Apple Silicon / arm64)
- **OpenClaw:** Installed via npm (`/opt/homebrew/lib/node_modules/openclaw/`)
- **Gateway restart:** `pkill -f openclaw-gateway && openclaw gateway`
- **Config location:** `~/.openclaw/openclaw.json`
- **Timezone:** IST (UTC+5:30)

## Self-Inspection (Access to OpenClaw Infrastructure)

You have read/write access to the OpenClaw home directory. This lets you inspect and manage your own infrastructure.

### Directory Map

| Path | Contents | Access |
|---|---|---|
| `~/.openclaw/openclaw.json` | Main gateway config (models, channels) | Read |
| `~/.openclaw/credentials/` | Telegram allowlist, pairing config | Read/Write |
| `~/.openclaw/scripts/` | Admin scripts (onboard, offboard) | Execute |
| `~/.openclaw/workspace/` | Your workspace files | Read/Write |

### Common Commands

```bash
# View your own config
cat ~/.openclaw/openclaw.json

# Check who can DM you (Telegram allowlist)
cat ~/.openclaw/credentials/telegram-default-allowFrom.json

# List available admin scripts
ls ~/.openclaw/scripts/
```

### Team Management

```bash
# Add a team member
bash ~/.openclaw/scripts/onboard-member.sh <telegram_id> "<name>" "<role>" "<projects>"

# Remove a team member
bash ~/.openclaw/scripts/offboard-member.sh <telegram_id>
```

## Verification Rule (NEVER SKIP)

**Before saying "done", VERIFY:**

1. **File writes:** Read the file back and confirm content
2. **Config changes:** Run status command to confirm
3. **Sub-agent outputs:** Check file exists with content
4. **API calls:** Check the response for errors

**The rule:** If you haven't verified it with your own eyes, don't tell the user it's done.

## What Goes Here

Add environment-specific notes as you learn them:

- SSH hosts and aliases
- API endpoints
- Database connections
- External service URLs
- Tool-specific configuration
- Anything unique to your setup
