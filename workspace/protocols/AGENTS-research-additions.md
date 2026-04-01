# AGENTS.md — Research Protocol Additions
# ADD these sections to your AGENTS.md file

## ---- ADD TO TRIAGE / ROUTING SECTION ----

### Research Task Detection
A task is classified as "research" if it involves ANY of:
- Finding facts, laws, regulations, statistics, or data from external sources
- Country-specific legal/regulatory analysis
- Policy research or comparative analysis
- Verifying claims or checking existing data against sources
- Literature review or evidence gathering

When a task is classified as research:
1. The handling agent MUST load `protocols/research-protocol.md` before starting
2. The agent MUST confirm: "Research Protocol loaded. All 25 rules active."
3. Every output MUST include the Research Compliance Footer
4. If the task is routed to verification (opus+grok, or any +grok route), the reviewer MUST load `protocols/research-review-checklist.md`


## ---- ADD TO ROUTING TABLE ----

# Add this row to the routing rules:
# | research + any complexity | Route to research-capable model + mandatory grok review |

# Update routing rules:
# - research + simple + lookup -> "gpt54" (but protocol still applies)
# - research + moderate -> "sonnet" (protocol applies, grok review recommended)
# - research + complex/critical -> "opus+grok" (protocol applies, grok review mandatory)
# - research + any + external_deliverable=true -> "opus+grok" (protocol + review mandatory)


## ---- ADD AS NEW SECTION ----

## Research Protocol (MANDATORY)

### Binding rules for all research outputs
All research tasks are governed by `protocols/research-protocol.md` (25 rules, 5 categories).
This protocol is NON-NEGOTIABLE. It overrides default behaviour.

### Key non-negotiables (summary — full rules in protocol file):
1. **Source-first:** Every claim must trace to a retrieved source. No inference as fact.
2. **Primary over secondary:** Official gazettes, court sites, statute DBs first. Law firm articles are secondary.
3. **No fabricated URLs:** Only link what you actually fetched and confirmed.
4. **Native-language search:** Always search in the country's language. Language barrier is not an excuse.
5. **Current law only:** Verify the statute is the operative version, not repealed/amended.
6. **Cross-verify:** Key data points need 2+ independent sources.
7. **Compliance footer:** Every output ends with confidence level, source list, gaps, and verification notes.

### Research review process
When a research output is sent to a reviewer (Grok or any verification agent):
1. Reviewer loads `protocols/research-review-checklist.md`
2. Runs 5-phase audit: Structural → Source Quality → Content Depth → Data Integrity → Delivery
3. Produces a Research Review Report with grade (PASS / CONDITIONAL PASS / FAIL)
4. If FAIL or CONDITIONAL PASS: sends back to research agent with specific violations listed
5. Research agent must fix ALL violations before resubmission
6. Maximum 2 revision cycles — if still failing after 2 revisions, escalate to Shiv

### Automatic review triggers
Research review by a second agent is MANDATORY when:
- The output will be shared externally (reports, briefs, deliverables)
- The research involves legal citations (article numbers, penalties, procedures)
- The confidence level is MEDIUM or LOW
- The research covers a non-English jurisdiction

Research review is RECOMMENDED (but not mandatory) when:
- Simple fact-finding for internal use only
- The research is a quick lookup with HIGH confidence
