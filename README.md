# OpenClaw Starter Kit

A production-tested OpenClaw setup with intelligent model routing, cost optimization, and team collaboration — ready to deploy on a Mac Mini.

Built from real-world experience running an AI assistant for a 7-person research organization.

## What You Get

- **Smart Triage System** — Opus classifies tasks, cheaper models handle routine work (saves 50-100x on costs)
- **Process Trail** — Every response shows which model triaged, classified, and handled the task
- **Multi-Model Routing** — Claude Opus, GPT-4o, Gemini, Grok, Ollama (local) — use what fits
- **Quality Gates** — Auto-escalation when output quality is insufficient
- **Opus Verification** — Grok cross-checks Opus deliverables (9-point checklist)
- **Team Management** — Add/remove Telegram users with one command
- **Cost Awareness** — Free models first, expensive models only when needed
- **Memory System** — Daily notes + long-term memory for session continuity
- **File Organization** — Structured naming conventions and project folders

## Prerequisites

- **Mac Mini** (Apple Silicon recommended) or any macOS/Linux machine
- **Node.js 22+** — `brew install node`
- **Tailscale** (optional) — for remote access
- One or more LLM API keys (see Model Setup below)

## Quick Start (5 minutes)

```bash
# 1. Clone this repo
git clone https://github.com/YOUR_USERNAME/openclaw-starter.git
cd openclaw-starter

# 2. Run the setup script
bash setup.sh

# 3. Edit your config with real credentials
nano ~/.openclaw/openclaw.json          # Add your bot token, model keys
nano ~/.openclaw/agents/main/agent/auth-profiles.json  # Add auth profiles

# 4. Start the gateway
openclaw gateway
```

## Setup Script

The `setup.sh` script:
1. Installs OpenClaw via npm (if not already installed)
2. Copies all template configs to `~/.openclaw/`
3. Deploys workspace files (AGENTS.md, SOUL.md, USER.md, TOOLS.md)
4. Creates directory structure (memory, scripts, projects, skills, etc.)
5. Installs admin scripts (onboard/offboard team members)

After running, you only need to fill in your credentials.

## Model Setup

### Minimum (1 model)
Any single LLM works. The triage system gracefully degrades — if Opus isn't available, the primary model handles everything.

### Recommended (2-3 models)
| Model | Role | Cost | Setup |
|-------|------|------|-------|
| **Claude Opus** | Triage + complex tasks | ~$15/M input | `openclaw auth login anthropic` (OAuth) or API key |
| **GPT-4o** | Primary / routine tasks | ~$2.5/M input | `openclaw auth login openai` (OAuth) or API key |
| **Ollama (local)** | Cron jobs, simple tasks | Free | Install Ollama, pull a model |

### Full Setup (5 models)
Add Gemini (free, web search), Grok (cheap verification), and more Ollama models.

Edit `~/.openclaw/openclaw.json` → `models.providers` section and `~/.openclaw/agents/main/agent/auth-profiles.json`.

## Telegram Bot Setup

1. Message **@BotFather** on Telegram
2. Send `/newbot`, follow prompts to create your bot
3. Copy the bot token
4. Paste it in `~/.openclaw/openclaw.json` → `channels.telegram.botToken`
5. Restart the gateway

### Adding Team Members

```bash
# Get the user's Telegram ID (they message your bot, check gateway logs)
# Then run:
bash ~/.openclaw/scripts/onboard-member.sh <TELEGRAM_ID> "<Full Name>" "<Role>" "<Projects>"

# Example:
bash ~/.openclaw/scripts/onboard-member.sh 1234567890 "Jane Smith" "Analyst" "research"

# Remove a member:
bash ~/.openclaw/scripts/offboard-member.sh 1234567890
```

## Architecture

```
~/.openclaw/
├── openclaw.json                    # Main config (models, telegram, gateway)
├── agents/main/agent/
│   ├── auth-profiles.json           # LLM credentials
│   └── models.json                  # Custom model providers
├── credentials/
│   └── telegram-default-allowFrom.json  # Telegram allowlist
├── workspace/                       # Agent's working directory
│   ├── AGENTS.md                    # Operational rules + triage system
│   ├── SOUL.md                      # Agent identity + personality
│   ├── USER.md                      # User profiles + team roster
│   ├── TOOLS.md                     # Environment-specific tool notes
│   ├── MEMORY.md                    # Long-term curated memory
│   ├── memory/                      # Daily notes (YYYY-MM-DD.md)
│   ├── projects/                    # Project folders
│   ├── skills/                      # Skill definitions
│   ├── learnings/                   # Retrospective logs
│   └── scripts/                     # Task scripts
└── scripts/
    ├── onboard-member.sh            # Add team member
    └── offboard-member.sh           # Remove team member
```

## How the Triage System Works

```
User sends message on Telegram
        │
        ▼
  ┌─────────────┐
  │ Skip triage? │──yes──▶ Handle directly (greetings, follow-ups, commands)
  └──────┬──────┘
         │ no
         ▼
  ┌─────────────┐
  │ Opus classifies │──▶ Returns: complexity, scope, type, route_to
  └──────┬──────┘
         │
         ▼
  ┌─────────────────────────────────────────┐
  │ route_to = ?                             │
  │                                          │
  │  "self"      → Primary model handles     │
  │  "gpt54"     → GPT-4o handles            │
  │  "gpt54+gem" → GPT-4o + Gemini research  │
  │  "opus"      → Opus handles              │
  │  "opus+grok" → Opus + Grok verification  │
  └──────┬──────┘
         │
         ▼
  Process trail shown at top of response
  Provenance footer at bottom of deliverables
```

### Process Trail (shown on every response)
```
Process:
- Triage by: Opus (sub-agent)
- Classification: moderate/medium/research -> gpt54
- Task handled by: GPT-4o
- Reason: Standard research, no multi-source synthesis needed
```

### Provenance Footer (on deliverables)
```
---
Pipeline: Opus (triage) -> GPT-4o (task) -> Grok (9/9 passed)
Cost tier: high
```

## Customization

### Change the agent's name
Edit `workspace/SOUL.md` — change the identity section.

### Add projects
Create a folder under `workspace/projects/<project-name>/` with subfolders: `research/`, `insights/`, `data/`, `code/`, `outputs/`.

### Add skills
Create `workspace/skills/<skill-name>/SKILL.md` with instructions for specific task types.

### Adjust cost thresholds
Edit the triage routing rules in `workspace/AGENTS.md` to match your budget.

## Tips from Production

1. **Start with 1-2 models** — add more as needed
2. **Opus for triage is worth it** — ~Rs.0.70 per classification saves expensive mis-routes
3. **Don't use Ollama as primary for Telegram** — most local models have small context windows (32K) that overflow with workspace files
4. **Clean up stale sandbox containers** — they accumulate over days: `docker ps | grep sbx | awk '{print $1}' | xargs docker rm -f`
5. **Check AGENTS.md stays under 20K chars** — larger files cause context truncation
6. **Gateway logs are your friend** — `docker logs openclaw-openclaw-gateway-1 --tail 50` or check `/tmp/openclaw/openclaw-*.log`

## License

MIT — use it however you want.
