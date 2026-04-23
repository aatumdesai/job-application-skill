# Resume Generation

Generates a tailored one-page resume and ATS document for a specific job application. Use this skill when the user pastes a job description and wants a resume built from their Airtable work logs — including selecting and ordering the most relevant bullets, writing a role-specific summary, and producing both a formatted .docx and a keyword-highlighted ATS version. Also invoke when the user says "tailor my resume," "build a resume for this role," or "run the resume optimizer."

## Setup

Before starting, read:
- `references/template-strings.md` — exact find/replace strings for document.xml substitution
- `references/ats-reference.md` — ATS highlight colors, page 2 XML structure, config JSON schema

Load from `.env`:
- `AIRTABLE_BASE_ID` — Airtable base
- `WORKLOGS_TABLE_ID` — Work Logs table (READ-ONLY)
- `PYTHON_PATH` — Python interpreter path

---

## Workflow

### 1. Get JD
User pastes full job description. If user has not pasted it, request from user. 

### 2. Analyze JD
Extract two distinct outputs and label them clearly for the rest of the workflow:

- **JD Keywords** (8–12): exact phrases lifted verbatim from the JD text. If you cannot quote the source line, the phrase is not a valid keyword.
- **Experience Themes** (3–5): broader areas of expertise the role requires (e.g., "cross-functional stakeholder management"), synthesized from the JD, not copied word-for-word.

### 3. Pull Airtable (two-pass)
**Pass 1 — lightweight:** Query Work Logs (`WORKLOGS_TABLE_ID`) where `Resume Worthy = true`. Fields: Project Name, Skills Used, Smaller Summary only. Using the **JD Keywords** and **Experience Themes** from Step 2, select the 7–9 most relevant record IDs.

**Pass 2 — targeted:** Re-query Airtable for only those selected record IDs. Fields: Project Name, Description, Result, Skills Used, Tools Used, Collaborators. Map each record to the correct job section.

### 4. Draft all content
Write summary and all bullets before touching any files. Apply all rules below.

### 5. Build resume
```bash
rm -rf unpacked_resume/ && cp -r unpacked_template/ unpacked_resume/
```
Edit `unpacked_resume/word/document.xml` using the exact template strings from `references/template-strings.md` — do not read the file first. Substitute only the strings listed; leave all other XML unchanged.

```bash
PYTHONIOENCODING=utf-8 $PYTHON_PATH scripts/pack.py unpacked_resume/ "Resumes/[Company] - [Job Title] - [YYYY-MM-DD].docx" --original resume_template.docx
```

Confirm output shows `Paragraphs: 33 → 33 (0)` and `All validations PASSED!`. If paragraph count does not match, stop and report the mismatch to the user before proceeding.

### 6. Build ATS document
Generate `ats_config.json` (schema in `references/ats-reference.md`) with:
- `highlights` — phrases to shade on page 1 (verbatim text from resume, not JD)
- `key_reqs` — covered/gap status for each key requirement
- `ats_keywords` — found/not-found for each JD keyword
- `role_overview`, alignment and ATS scores

```bash
PYTHONIOENCODING=utf-8 $PYTHON_PATH scripts/build_ats.py \
  --input "Resumes/[Company] - [Job Title] - [YYYY-MM-DD].docx" \
  --output "Resumes/[Company] - [Job Title] - [YYYY-MM-DD] - ATS.docx" \
  --config ats_config.json
```

### 7. Deliver
List both output file paths:
- `Resumes/[Company] - [Job Title] - [YYYY-MM-DD].docx`
- `Resumes/[Company] - [Job Title] - [YYYY-MM-DD] - ATS.docx`

---

## Hard Rules

- **One page only** — adding a bullet requires removing a weaker one in the same section; total paragraph count must stay at 33
- **No em dashes** — use comma, semicolon, or restructure; em dashes signal LLM-written copy to a trained eye
- **Never modify `resume_template.docx`** — it is the master baseline; always copy to `unpacked_resume/` first so the original is never touched
- **Draft all content before touching files** — avoids partial-edit XML corruption; write every bullet and the summary in full before opening `document.xml`
- **Work Logs is READ-ONLY** — never create, update, or delete records
- **Never invent metrics** — if a result is unquantified in Airtable, write the bullet without a number

---

## Summary Rules

- Always open with: `"UCLA Anderson MBA and Business Strategy & Insights Manager at Productboard,"` — add `"(Series D B2B SaaS)"` after Productboard for startup roles
- Remaining sentences are **directly shaped by the Experience Themes from Step 2** — each sentence should address one or more themes, describing what is brought to the role in general terms; no specific projects, metrics, tools, or bullet-level results in the summary
- Hard cap: 275 characters total (3 physical lines at 10pt Times New Roman) — verify with `echo -n "your summary text" | wc -c` before finalizing; rewrite to fit rather than cutting words arbitrarily
- The summary is the best place to make the case that you are the obvious choice for this role — use it to address the Experience Themes directly and weave in JD Keywords naturally where they fit
- No vague jargon: no "passionate about," "leverages," "dynamic," "results-driven"
- Actual title is **Business Strategy & Insights Manager** — never invent a different title in title case; lowercase substitutions (e.g., "strategy and operations professional") are allowed

---

## Bullet Rules

**Style anchors:** The template bullets in `references/template-strings.md` are examples of well-written bullets — match their specificity, sentence structure, and tone when drafting new ones.

**Format:** Action Verb → Context → Quantified Result

**Verbs to avoid:** helped, assisted, worked on, was responsible for, participated in, contributed to, supported, collaborated on

**Power verbs:** Architected, Built, Designed, Drove, Engineered, Identified, Launched, Led, Modeled, Operationalized, Scaled, Structured, Defined, Developed, Executed, Synthesized, Converted, Reduced, Spearheaded, Deployed

- Never repeat a starting verb across bullets
- No articles (a, an, the) and no "that"
- **Use JD Keywords verbatim** — where natural, use the exact **JD Keywords** from Step 2 so the ATS bold pass finds them (e.g., if the JD says "financial modeling," use that exact phrase, not "financial models")
- Write for a recruiter audience — focus on universal understanding, not technical methodology
- Distinguish between work that *used* AI and work that was *about* AI — do not conflate
- Do not mix project description with result — describe what was done, then what it drove. Distinguish execution from outcome: if 3,000 customers received a product informed by a study, that is a result, not a description of who was studied
- Never use unexpanded unpopular acronyms — every bullet must be readable by a generalist recruiter (e.g., "healthcare provider" not "HCP"; exception: AI, MBA, B2B, SaaS)
- Quantify wherever possible — numbers, percentages, dollar values, timeframes, scale
- Order bullets strongest-first within each section (most quantified + most relevant to this role)
- Max ~190 characters per bullet (2 rendered lines at 10pt Times New Roman)

---

## Section Rules

- Place bullets under the role where the work happened: Productboard → PRODUCTBOARD, Abbott → ABBOTT, PINN → PINN INVESTMENTS
- **Productboard:** no hard cap
- **PINN:** max 4 bullets (up to 6 for real estate or legal roles)
- **Abbott:** max 1 bullet unless the role is healthcare-related and a second bullet adds clear value (max 2)
- Use `<w:numId w:val="39"/>` for all bullet paragraphs — match existing XML structure

---

## Skills Rules

- Reorder to front-load skills most relevant to the target role
- Hard/technical skills before soft/general skills
- Keep pipe-delimited format and "Skills:" / "Technical & Analytics:" labels unchanged
- Technical & Analytics line stays unchanged unless the role specifically rewards different tools

