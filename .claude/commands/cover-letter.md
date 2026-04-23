---
name: cover-letter
description: Generate a tailored cover letter .docx for a specific job application. Use this skill when the user pastes a job description and wants a cover letter — including a memorable opening, 3 JD-aligned competency sections grounded in real work history, and a formatted .docx saved to Resumes/. Also invoke when the user says "write me a cover letter," "generate a cover letter," or "cover letter for this role."
---

# Cover Letter Generator

Generates a tailored one-page cover letter and saves it as a formatted `.docx` to `Resumes/`.

## Setup

Before starting, read:
- `references/user_config.md` — identity and contact info

Load from `.env`:
- `AIRTABLE_BASE_ID`
- `WORKLOGS_TABLE_ID` (READ-ONLY — never create, update, or delete records)
- `PYTHON_PATH`

---

## Workflow

### 1. Get JD

User pastes full job description. If not provided, request it.

### 2. Ask for any personal angle

Ask once: "Is there anything specific you want in the opening — a personal connection to the company, something from your background, a reason you're excited about this role?" If they say no or nothing comes to mind, proceed without it.

### 3. Analyze JD

Extract:
- **Company name** and **role title**
- **3 competency themes** — specific capabilities this role requires, named in a way that can become a bold section label (e.g., "Financial Modeling", "Cross-functional Leadership", "Process Improvement & Automation"). These should map directly to the JD and differentiate this letter from a generic one.
- **Opening angle** — what makes this company/role genuinely interesting or specific. Look for: mission, product approach, growth stage, market position, a notable initiative mentioned in the JD. Avoid generic enthusiasm ("innovative", "dynamic"). Find one real, specific thing worth noting.

### 4. Pull Airtable (single pass)

Query Work Logs (`WORKLOGS_TABLE_ID`) where `Resume Worthy = true`.
Fields: `Project Name`, `Skills Used`, `Smaller Summary`.

Select the **3 most relevant records** — one per competency theme. These are the raw material for the body sections.

### 5. Draft the letter

Write all content before building the file. Structure:

**Opening paragraph** (~100 words)
- Lead with something specific about this company or role — not generic enthusiasm. If the JD mentions a concrete mission, product bet, or market position, name it. If the user gave you a personal angle, weave it in here.
- Transition to why your background is a fit, framed at the level of what you bring, not a career summary.
- End by introducing the 3 competencies you'll cover: "I believe the following core competencies will allow me to drive value at [Company]:" (or equivalent).

**3 competency sections** (~100–130 words each)
- Each starts with a bold label matching the theme (e.g., "Financial Modeling:")
- Tell one specific story from the selected Airtable record: what the situation was, what you did, and what it drove. Include a metric where one exists in the record.
- Write in a way that feels specific to this role — same story, different angle: what the hiring manager for *this* role cares about is what leads.

**Closing paragraph** (~50 words)
- Summarize what you bring at a high level — STEM/analytical background, unique work experiences, ability to operate in ambiguous environments.
- Express genuine interest without filler phrases.

**Sign-off**
```
Sincerely,
Aatum Desai
MBA Class of 2025
UCLA Anderson School of Management
```

### 6. Build the .docx

Assemble a `cover_letter_content.json` with this structure:

```json
{
  "name": "Aatum Desai",
  "contact_line": "(714) 350-8481 | aatumdesai@outlook.com | linkedin.com/in/aatumdesai",
  "date": "April 22, 2025",
  "recipient": "[Company Name] Hiring Team",
  "salutation": "Dear [Hiring Manager Name / Hiring Team],",
  "opening": "...",
  "competencies": [
    { "label": "Financial Modeling", "body": "..." },
    { "label": "Cross-functional Leadership", "body": "..." },
    { "label": "Process Improvement & Automation", "body": "..." }
  ],
  "closing": "...",
  "signoff": ["Sincerely,", "Aatum Desai", "MBA Class of 2025", "UCLA Anderson School of Management"]
}
```

Then run:

```bash
$PYTHON_PATH scripts/build_cover_letter.py cover_letter_content.json "Resumes/[Company] - Cover Letter - [YYYY-MM-DD].docx"
```

### 7. Deliver

Output the full letter text in the conversation so the user can read it, then confirm the saved path.

---

## Hard Rules

- **Never invent metrics** — only use numbers that come from Airtable records
- **Work Logs is READ-ONLY** — never create, update, or delete records
- **No em dashes** — use commas or semicolons
- **No filler phrases** — no "passionate about", "leverages", "dynamic", "results-driven", "I hope this finds you well"
- **One story per competency section** — don't list multiple projects; go deep on one
