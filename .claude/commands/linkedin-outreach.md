---
name: linkedin-outreach
description: Generate a personalized LinkedIn outreach message (InMail, connection request, or regular message) for a job application. Use this skill whenever the user wants to write a LinkedIn message, InMail, or connection note for a job or role they're interested in — even if they just say "write me a LinkedIn message" or "I want to reach out to this recruiter."
---

# LinkedIn Outreach

Generates a tailored LinkedIn message for a specific role and hiring manager, grounded in real work history from Airtable.

## Setup

Load from `.env`:
- `AIRTABLE_BASE_ID`
- `WORKLOGS_TABLE_ID` (READ-ONLY — never create, update, or delete records)

Read style reference: `references/linkedin-examples.md`

---

## Workflow

### 1. Gather Inputs

Collect the following — request anything missing:

- **JD** — required. Ask the user to paste it if not provided.
- **Hiring manager first name** — required. Ask if not provided.
- **Message type** — ask: InMail, connection request, or regular message (to an existing connection)?
- **Resume** — optional. If the user just ran `/resume-optimizer` or has a resume ready, ask if they want to use it as the source of work history instead of pulling fresh from Airtable. If yes, skip Step 2.

### 2. Pull Airtable (single pass)

Query Work Logs (`WORKLOGS_TABLE_ID`) where `Resume Worthy = true`.  
Fields to retrieve: `Project Name`, `Skills Used`, `Smaller Summary`.

From the results, select the **2–3 most relevant entries** based on the JD themes. These become the raw material for the body of the message — specific, grounded claims rather than generic assertions.

### 3. Analyze JD

Identify:
- The **1–2 core things the role is actually about** (what problem does this team/person solve?)
- The **most surprising or non-obvious credential** Aatum has that maps to it — this is what should lead the body

### 4. Draft the message

Write the full message. Then count characters before delivering.

---

## Message Types & Constraints

### InMail
- Include a **subject line** (≤200 characters) — specific and role-relevant, not generic ("Interested in [Role]" is fine as a fallback but try to be more specific)
- **Target length: ~700–900 characters** — this is Aatum's historical style; it's more substantive than generic advice suggests, because the message itself explains fit
- LinkedIn suggests ≤500 characters; if the draft is over 900, note it and offer a trimmed version
- Always end with name, email (aatumdesai@outlook.com), and phone (provided by user or omit)

### Connection Request
- **Hard limit: 200 characters** — LinkedIn enforces this technically
- No subject line
- Lead with the single most compelling hook; no room for detail
- Do not include contact info — the connection itself is the ask

### Regular Message (to existing connection)
- No hard limit
- Match the example length (~700–900 characters)
- Same sign-off style as InMail

---

## Style Rules

Read `references/linkedin-examples.md` for full examples. The core principles:

- **Open with what specifically caught your eye** about this role — name something from the JD, not generic excitement
- **Lead the body with the most relevant or surprising credential** — not a chronological career summary
- **One concrete achievement or data point per paragraph** — no lists of claims without grounding
- **End with a low-ask CTA** — "would love to connect", "happy to chat briefly", not "please consider my application"
- **Tone**: warm and direct — no "I hope this finds you well", no "passionate about", no "leverages"
- **No em dashes** — use commas or semicolons instead
- Always sign off: name, email, phone (if appropriate for message type)

---

## Hard Rules

- **Never invent metrics** — only use numbers that come from Airtable records or the resume
- **Work Logs is READ-ONLY** — never create, update, or delete records
- **Connection requests are hard-capped at 200 characters** — do not exceed under any circumstances
- Never use unexpanded acronyms a non-industry reader wouldn't know

---

## Deliver

Output:
1. The message (with subject line if InMail)
2. Character count
3. If InMail and over 900 chars: flag it and offer a trimmed version
