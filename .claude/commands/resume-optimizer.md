# Resume Generation

Generates a tailored one-page resume and ATS document for a specific job application. Use this skill when the user pastes a job description and wants a resume built from their Airtable work logs — including selecting and ordering the most relevant bullets, writing a role-specific summary, and producing both a formatted .docx and a keyword-highlighted ATS version. Also invoke when the user says "tailor my resume," "build a resume for this role," or "run the resume optimizer."

## Setup

Before starting, read:
- `references/user_config.md` — identity, section names, bullet caps, paragraph count, Airtable field names
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

- **JD Keywords** (8–12): exact phrases lifted verbatim from the JD text — these are ATS keywords. The goal is to match the exact strings an automated screening system will look for so the resume clears AI filtering before a human ever sees it. If you cannot quote the source line, the phrase is not a valid keyword.
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

### 6. Quality review

Spawn a general-purpose subagent to review and fix all resume text. Pass it the path to `unpacked_resume/word/document.xml`, the rules below, and the pack command. The subagent should:
1. Read `unpacked_resume/word/document.xml` and extract all human-readable text
2. Check every bullet and the summary against the rules
3. Fix any violations directly in `unpacked_resume/word/document.xml`
4. Repack using: `PYTHONIOENCODING=utf-8 $PYTHON_PATH scripts/pack.py unpacked_resume/ "Resumes/[filename].docx" --original resume_template.docx`
5. Report back: what violations were found, what was fixed, and confirmation the pack succeeded

Rules to pass to the subagent:
- No em dashes anywhere
- No "that" in any bullet
- No articles (a, an, the) at the start of a bullet
- No forbidden opening verbs: helped, assisted, worked on, was responsible for, participated in, contributed to, supported, collaborated on
- No repeated starting verb across any two bullets (check all sections together)
- Max ~190 characters per bullet — count each and flag anything over 190
- No vague jargon: "passionate about," "leverages," "dynamic," "results-driven"
- No unexpanded unpopular acronyms (approved exceptions: AI, MBA, B2B, SaaS, GTM, ROI, IRR, ARR, DCF, AE, CS, PLG)
- Summary must open with the correct opener from `references/user_config.md`
- Summary must be under 275 characters

Do not proceed to step 7 until the subagent confirms the pack succeeded clean.

### 7. Build ATS document


Assemble all `ats_config.json` values in the main session first — do not delegate any analytical decisions to the subagent:
- `highlights` — exact phrases from the resume (not JD) to shade on page 1, with color hex
- `key_reqs` — covered/gap status and color for each Experience Theme
- `ats_keywords` — found/not-found for each JD keyword
- `role_overview`, alignment score, counts

**Highlights rules:**
- **Never highlight the Skills or Technical & Analytics lines** — no highlights on those lines under any circumstances
- **Employer sections** (Productboard, Abbott, PINN) may be left bare if nothing maps cleanly to a theme — do not force highlights where the fit is weak
- **Summary:** highlighting is allowed, but never shade the whole summary one color. Only highlight specific clauses within the summary that directly pertain to an Experience Theme — a clause is a distinct phrase or sub-sentence, not just a keyword embedded in a larger thought. Leave any part of the summary that doesn't cleanly map to a theme unhighlighted

Then spawn a subagent via the Agent tool. Pass it a self-contained prompt containing:
- Company, role, date, resume input path, ATS output path, Python path
- The complete assembled `ats_config.json` content (all fields, ready to write)
- The `ats_config.json` schema from `references/ats-reference.md` — inline it so the subagent does not need to read any files
- The build command to run

The subagent's only job is mechanical: write `ats_config.json`, run the command below, and report success or errors.

```bash
PYTHONIOENCODING=utf-8 $PYTHON_PATH scripts/build_ats.py \
  --input "Resumes/[Company] - [Job Title] - [YYYY-MM-DD].docx" \
  --output "Resumes/[Company] - [Job Title] - [YYYY-MM-DD] - ATS.docx" \
  --config ats_config.json
```

### 8. Deliver
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

---

## Summary Rules

- Always open with the **Summary Opener** from `references/user_config.md` — use the startup variant (with company stage in parentheses) for startup roles
- Remaining sentences are **directly shaped by the Experience Themes from Step 2** — each sentence should address one or more themes, describing what is brought to the role in general terms; no specific projects, metrics, tools, or bullet-level results in the summary
- Hard cap and character verification method are in `references/user_config.md` — verify before finalizing; rewrite to fit rather than cutting words arbitrarily
- The summary is the best place to make the case that you are the obvious choice for this role — use it to address the Experience Themes directly and weave in JD Keywords naturally where they fit
- No vague jargon: no "passionate about," "leverages," "dynamic," "results-driven"
- Use the **Current title** from `references/user_config.md` — never invent a different title in title case; lowercase substitutions (e.g., "strategy and operations professional") are allowed

---

## Bullet Rules

**Style anchors:** The template bullets in `references/template-strings.md` are examples of well-written bullets — match their specificity, sentence structure, and tone when drafting new ones.

**Format:** Action Verb → Context → Quantified Result

**Verbs to avoid:** helped, assisted, worked on, was responsible for, participated in, contributed to, supported, collaborated on

**Power verbs:** Architected, Built, Designed, Drove, Engineered, Identified, Launched, Led, Modeled, Operationalized, Scaled, Structured, Defined, Developed, Executed, Synthesized, Converted, Reduced, Spearheaded, Deployed

- Never repeat a starting verb across bullets
- No articles (a, an, the) and no "that"
- **Use JD Keywords verbatim** — ATS systems do exact string matching; "financial modeling" and "financial models" are not the same string. Embed exact JD Keywords from Step 2 wherever natural, matching the exact form the JD uses:
  - If the JD writes "go-to-market" use that, not "GTM"
  - If the JD writes "artificial intelligence" use that, not "AI" (and vice versa)
- Write for a recruiter audience — focus on universal understanding, not technical methodology
- **Angle each bullet toward its Experience Theme** — identify which Experience Theme from Step 2 each bullet most directly serves, then write so that angle is the first thing the reader registers; the same Airtable record might lead with financial impact for a strategy role or process efficiency for an ops role
- Distinguish between work that *used* AI and work that was *about* AI — do not conflate
- Do not mix project description with result — describe what was done, then what it drove; if 3,000 customers received a product informed by a study, that is a result, not a description of who was studied
- When work involved creating something new (system, process, team, product), frame as creation not leadership — "Built" not "Led initiative to build"
- Never use unexpanded unpopular acronyms — every bullet must be readable by a generalist recruiter (e.g., "healthcare provider" not "HCP"; exception: AI, MBA, B2B, SaaS)
- **Quantify wherever possible** — for each bullet, check each dimension:
  - Revenue or deal impact ($ or %)
  - Cost or efficiency reduction ($ saved or % faster)
  - Scale (users, records, transactions)
  - Team scope (headcount managed or cross-functional reach)
  - Growth (from → to numbers)
  - If none apply and Airtable has no number, write the bullet without one
- Order bullets strongest-first within each section (most quantified + most relevant to this role)
- Max ~190 characters per bullet (2 rendered lines at 10pt Times New Roman)

---

## Section Rules

- Place bullets under the role where the work happened — section names, display labels, bullet caps, and special conditions are all in `references/user_config.md`
- Use `<w:numId w:val="39"/>` for all bullet paragraphs — match existing XML structure

---

## Skills Rules

- Reorder to front-load skills most relevant to the target role
- Hard/technical skills before soft/general skills
- Keep pipe-delimited format and "Skills:" / "Technical & Analytics:" labels unchanged
- Technical & Analytics line stays unchanged unless the role specifically rewards different tools

## Capstone Line Rules

The PINN section contains a Capstone bullet (italic "Capstone:" label followed by normal text in a separate run). This line may be rewritten to improve ATS keyword placement or bullet quality, following the same bullet rules as all other bullets. The "Capstone:" label itself is in its own XML run and must not be touched — only edit the text run that follows it.

