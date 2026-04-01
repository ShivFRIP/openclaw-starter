# Learnings System

## Structure
- `coding.md` — code generation, debugging, tool usage
- `research.md` — source reliability, methodology, fact-checking
- `analysis.md` — data interpretation, logical reasoning
- `communication.md` — presentation, tone, formatting
- `operations.md` — tools, workflows, infrastructure
- `general.md` — cross-cutting lessons
- `daily/` — raw nightly retro outputs (archived)

## Rules
1. **Principles sections are NEVER compacted** — they are append-only
2. **Log sections can be compacted** when they exceed ~3000 words
3. **Promotion path:** Daily learning -> Project principle -> Skill principle -> Binding protocol rule
4. **Applies to: Everyone** tag means it surfaces to team members
5. **Nightly retro cron** runs daily, before daily digest
6. **Weekly protocol promotion cron** runs weekly after log compaction — promotes qualifying learnings into binding protocol rules

## Entry Format
```markdown
### [YYYY-MM-DD] Short title
- **What happened:** Brief description
- **Root cause:** Why it went wrong
- **Principle:** The rule going forward
- **Applies to:** Me / Everyone / Admin only
- **Severity:** Low / Medium / High
```

## Promotion Criteria (Daily Learning -> Binding Protocol Rule)
A learning qualifies for protocol promotion if ANY of:
- Severity is HIGH
- Same type of mistake has occurred 2+ times
- Principle has "Applies to: Everyone"
- It involves a factual error that reached the user

## Compaction Rule
When a Log section exceeds ~3000 words:
1. Extract any new principles from events -> add to Principles section
2. Summarize older log entries
3. Archive raw version to shared drive
