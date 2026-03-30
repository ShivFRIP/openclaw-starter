#!/bin/bash
set -e

# OpenClaw Starter Kit — Automated Setup
# Run: bash setup.sh

OPENCLAW_HOME="$HOME/.openclaw"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║     OpenClaw Starter Kit — Setup         ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# --- Step 1: Check/Install OpenClaw ---
if command -v openclaw &>/dev/null; then
    echo "✓ OpenClaw already installed: $(openclaw --version 2>/dev/null || echo 'unknown version')"
else
    echo "→ Installing OpenClaw via npm..."
    npm install -g openclaw
    echo "✓ OpenClaw installed"
fi

# --- Step 2: Create directory structure ---
echo "→ Creating directory structure..."

mkdir -p "$OPENCLAW_HOME"/{agents/main/agent,credentials,cron,scripts,sandbox,subagents,logs,memory}
mkdir -p "$OPENCLAW_HOME/workspace"/{memory,projects,skills/research,skills/coding,skills/analytics,learnings/daily,scripts,data,tmp,onboarding/templates}

echo "✓ Directories created"

# --- Step 3: Copy template configs ---
echo "→ Deploying configuration templates..."

# Only copy if not already present (don't overwrite existing config)
copy_if_missing() {
    local src="$1"
    local dest="$2"
    if [ ! -f "$dest" ]; then
        cp "$src" "$dest"
        echo "  + $(basename "$dest")"
    else
        echo "  ~ $(basename "$dest") (already exists, skipping)"
    fi
}

copy_if_missing "$SCRIPT_DIR/templates/openclaw.json" "$OPENCLAW_HOME/openclaw.json"
copy_if_missing "$SCRIPT_DIR/templates/auth-profiles.json" "$OPENCLAW_HOME/agents/main/agent/auth-profiles.json"
copy_if_missing "$SCRIPT_DIR/templates/models.json" "$OPENCLAW_HOME/agents/main/agent/models.json"
copy_if_missing "$SCRIPT_DIR/templates/telegram-default-allowFrom.json" "$OPENCLAW_HOME/credentials/telegram-default-allowFrom.json"

# --- Step 4: Deploy workspace files ---
echo "→ Deploying workspace files..."

copy_if_missing "$SCRIPT_DIR/workspace/AGENTS.md" "$OPENCLAW_HOME/workspace/AGENTS.md"
copy_if_missing "$SCRIPT_DIR/workspace/SOUL.md" "$OPENCLAW_HOME/workspace/SOUL.md"
copy_if_missing "$SCRIPT_DIR/workspace/USER.md" "$OPENCLAW_HOME/workspace/USER.md"
copy_if_missing "$SCRIPT_DIR/workspace/TOOLS.md" "$OPENCLAW_HOME/workspace/TOOLS.md"
copy_if_missing "$SCRIPT_DIR/workspace/MEMORY.md" "$OPENCLAW_HOME/workspace/MEMORY.md"
copy_if_missing "$SCRIPT_DIR/workspace/HEARTBEAT.md" "$OPENCLAW_HOME/workspace/HEARTBEAT.md"

# --- Step 5: Install admin scripts ---
echo "→ Installing admin scripts..."

cp "$SCRIPT_DIR/scripts/onboard-member.sh" "$OPENCLAW_HOME/scripts/onboard-member.sh"
cp "$SCRIPT_DIR/scripts/offboard-member.sh" "$OPENCLAW_HOME/scripts/offboard-member.sh"
chmod +x "$OPENCLAW_HOME/scripts/onboard-member.sh"
chmod +x "$OPENCLAW_HOME/scripts/offboard-member.sh"
echo "  + onboard-member.sh"
echo "  + offboard-member.sh"

# --- Step 6: Set permissions ---
echo "→ Setting permissions..."
chmod 600 "$OPENCLAW_HOME/openclaw.json"
chmod 600 "$OPENCLAW_HOME/agents/main/agent/auth-profiles.json"
chmod 600 "$OPENCLAW_HOME/agents/main/agent/models.json"
echo "✓ Permissions set (config files readable only by you)"

# --- Done ---
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║          Setup Complete!                 ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo ""
echo "  1. Edit your config with real credentials:"
echo "     nano $OPENCLAW_HOME/openclaw.json"
echo "     → Add your Telegram bot token"
echo "     → Configure model providers"
echo ""
echo "  2. Add LLM auth (pick one or more):"
echo "     openclaw auth login anthropic    # Claude (OAuth)"
echo "     openclaw auth login openai-codex # GPT (OAuth)"
echo "     # Or edit auth-profiles.json with API keys"
echo ""
echo "  3. Add yourself as first user:"
echo "     bash $OPENCLAW_HOME/scripts/onboard-member.sh YOUR_TELEGRAM_ID \"Your Name\" \"Admin\" \"all\""
echo ""
echo "  4. Start the gateway:"
echo "     openclaw gateway"
echo ""
echo "  5. Message your bot on Telegram!"
echo ""
