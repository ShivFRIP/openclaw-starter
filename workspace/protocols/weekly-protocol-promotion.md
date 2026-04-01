# Weekly Protocol Promotion — Cron Instructions

You are running the weekly protocol promotion job. Your task is to close the learning feedback loop: take mistakes/learnings from the past week and promote qualifying ones into binding protocol rules.

## STEP 1: Gather This Week's Learnings

Read all learnings files:
- `/workspace/learnings/research.md`
- `/workspace/learnings/coding.md`
- `/workspace/learnings/analysis.md`
- `/workspace/learnings/operations.md`
- `/workspace/learnings/communication.md`
- `/workspace/learnings/general.md`

Also read the daily files from the past 7 days:
- `/workspace/learnings/daily/YYYY-MM-DD.md` (for each day this week)

Extract all entries from this week (check dates in `### [YYYY-MM-DD]` headers).

## STEP 2: Filter for Promotion Candidates

A learning qualifies for protocol promotion if ANY of:
- Severity is HIGH
- The same type of mistake has occurred 2+ times (check Log sections for patterns)
- The principle has "Applies to: Everyone"
- It involves a factual error that reached the user (not caught in self-audit)

## STEP 3: Check Against Existing Protocol Rules

Read the current protocol files:
- `/workspace/protocols/research-protocol.md` (25+ rules for research)
- `/workspace/CODING_GUIDELINES.md` (34+ rules for coding)
- `/workspace/protocols/research-review-checklist.md` (reviewer checklist)

For each promotion candidate, check:
1. Is this error already covered by an existing rule? (If yes, skip — but note if the existing rule needs strengthening)
2. Which protocol file should it go in? (research, coding, or new category)
3. What rule number should it get? (next sequential in its category)

## STEP 4: Draft New Rules

For each new rule, draft in the established format:

**For research-protocol.md:**
```markdown
### [LETTER][NUMBER]: [Rule Title]
[Rule description — clear, specific, actionable]

> *Error that created this rule:* [What happened, when, what country/context]
```

**For CODING_GUIDELINES.md:**
```markdown
**RULE: [One-line rule statement]**
[Code example if applicable]
**Why:** [Explanation tied to the specific error]
```

## STEP 5: Apply Updates

1. Append new rules to the appropriate protocol file at the end of the relevant section
2. If `research-protocol.md` gets new rules, also add matching entries to `research-review-checklist.md` in the "KNOWN ERROR PATTERNS TO WATCH FOR" section
3. Update the rule count in the protocol file header if applicable

## STEP 6: Update the Error Catalogue

If `research-protocol.md` was updated, add new entries to Section F (Reference: Complete Error Catalogue) at the bottom of the file:
```markdown
| [next #] | [error type] | [description] | [country/context] | [rule] |
```

## STEP 7: Verify Size Constraints

After all updates:
- Check that `research-protocol.md` is still under 15KB (protocols should be comprehensive but not bloated)
- Check that `CODING_GUIDELINES.md` is still under 20KB
- If a file is getting too large, flag it for manual review rather than auto-compacting rules

## STEP 8: Report

Write a promotion report to `/workspace/learnings/promotion-log.md` (append):
```markdown
### [YYYY-MM-DD] Weekly Protocol Promotion

**Learnings reviewed:** [count from this week]
**Promotion candidates:** [count]
**New rules added:** [count]
- [Rule ID]: [title] -> [which protocol file]
**Rules strengthened:** [count]
- [Rule ID]: [what was updated]
**Skipped (already covered):** [count]
**Next review:** [date]
```

Your Telegram summary (under 150 words):
- How many learnings from this week
- How many promoted to binding rules (with rule IDs)
- Any patterns (same type of error recurring)
- If no promotions needed, say so

## IMPORTANT RULES

- NEVER delete or modify existing rules — only ADD new ones or STRENGTHEN existing ones
- NEVER promote vague platitudes ("be more careful") — only specific, actionable rules
- When in doubt whether something deserves a rule, DON'T promote it. Low/Medium severity learnings stay in learnings files unless they recur.
- A recurring Medium learning (2+ occurrences) is stronger evidence than a single High learning
- Always preserve the "What triggered this" / "Why" attribution — traceability is critical
