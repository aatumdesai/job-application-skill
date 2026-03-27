# Resume Generation Skill — Aatum Desai

## What This Skill Does
Generates a tailored, one-page resume for a specific job by pulling real accomplishments from Airtable and editing the base template to match the role. Triggered when the user pastes a job description and asks for a resume.

---

## Key References

| Item | Value |
|------|-------|
| Skill root (Windows) | `C:\Users\aatum\GitHub\job-application-skill\` |
| Resume template | `resume_template.docx` — never modify directly |
| Generated resumes | `output/resumes/` |
| Unpack script | `python /path/to/skills/docx/scripts/office/unpack.py` |
| Pack script | `python /path/to/skills/docx/scripts/office/pack.py` |
| Validate script | `python /path/to/skills/docx/scripts/office/validate.py` |
| Airtable base ID | `appFHhhJ6VkwkdpPQ` |
| Work Logs table | `tblH7q7PgoGbBukXN` (READ-ONLY) |

---

## Workflow

### Step 1 — Get the Job Description
The user pastes the full JD directly into chat. Do not attempt to fetch it from a URL.

### Step 2 — Pull Accomplishments from Airtable
Pull all records from Work Logs (`tblH7q7PgoGbBukXN`) where `Resume Worthy = true`. For each record collect: Project Name, Description, Result, Skills Used, Tools Used, Collaborators.

### Step 3 — Analyze the JD and Select Accomplishments
- Extract the 8–12 most important ATS keywords from the JD (skills, tools, methodologies, role-specific terminology)
- Identify the 3–5 themes those keywords cluster into
- Mirror the JD's exact terminology throughout — do not assume the ATS resolves synonyms
- Select the 7–9 Work Log records most relevant to those themes
- Map each selected accomplishment to the correct job section (Productboard, Abbott, or PINN)

### Step 4 — Write the Bullets
Follow all Bullet Rules in Hard Rules. Draft bullets before opening the template.

### Step 5 — Edit the Resume

1. Copy `resume_template.docx` → `output/resumes/[Company] - [Job Title] - [YYYY-MM-DD].docx`
2. Unpack: `python unpack.py [copied_file] unpacked_resume/`
3. Edit `unpacked_resume/word/document.xml`:
   - **Summary** — rewrite following Summary Rules in Hard Rules
   - **Bullets** — replace bullet text in each section; follow Section Rules and Bullet Rules in Hard Rules
   - **Skills** — reorder to front-load what's most relevant; follow Skills Rules in Hard Rules
4. Repack: `python pack.py unpacked_resume/ output/resumes/[filename].docx --original resume_template.docx`
5. Validate: `python validate.py output/resumes/[filename].docx` — confirm paragraph count is unchanged

### Step 6 — Deliver
Share the file with the user via a `computer://` link. Show the bullets written so the user can review before sending.

---

## Hard Rules

### Resume Format
- **One page only** — never add net paragraphs. Adding a bullet requires removing a weaker one in the same section to keep the total paragraph count identical
- **No em dashes anywhere** — use a comma, semicolon, or restructure instead
- **Never modify `resume_template.docx`** — always copy it first

### Summary Rules
1. Always open with: "UCLA Anderson MBA and Business Strategy & Insights Manager at Productboard," then state the core of what he does — one sentence a recruiter can use to make a go/no-go decision. If the role is a startup, put "(Series D B2B SaaS)" right after Productboard in the first sentence.
2. Remaining sentences bridge to the specific JD — connect real experience to what the role is explicitly asking for; do not repeat information contained in sentence 1
3. Never exceed 3 physical lines on the page — rendered at 10pt Times New Roman. Target ~300 characters total. Trim aggressively
4. No vague jargon — nothing like "passionate about," "leverages," "dynamic," "results-driven"
5. Never misrepresent his title — actual title is Business Strategy & Insights Manager at Productboard. Do not invent a different title. If the target role is similar you can replace "Business Strategy & Insights Manager" with something but do not use title case. For example, you can replace with "strategy and operations professional" but do not invent experience I do not have. 
6. Match existing run formatting exactly: 20pt Times New Roman, italic via iCs tag

### Bullet Rules
**Format:** Action Verb → Context → Quantified Result

**Verb discipline:**
- Never use: helped, assisted, worked on, was responsible for, participated in, contributed to, supported, collaborated on
- Use power verbs: Architected, Built, Designed, Drove, Engineered, Identified, Launched, Led, Modeled, Operationalized, Scaled, Structured, Defined, Developed, Executed, Synthesized, Converted, Reduced, Spearheaded, Deployed
- Never repeat a starting verb across bullets

**Content:**
- No articles: no "a," "an," or "the"
- Quantify wherever possible — numbers, percentages, dollar values, timeframes, scale
- Aim for 1–2 bullets that naturally surface cross-functional collaboration or team leadership where the data supports it — don't force it into every bullet
- Signal 0-to-1 work explicitly — use "built from scratch," "designed and launched," or "stood up"
- If a project resulted in expanded scope or a follow-on mandate, include that as proof of impact
- Order bullets strongest-first within each section — strongest means most quantified and most relevant to this specific role
- Keep each bullet under ~190 characters — safe limit for 2 rendered lines at 10pt Times New Roman

**Example:**
- Strong: "Designed revenue capture strategy for 120+ customers exceeding contracted seat limits, converting usage analytics into expansion motions"
- Weak: "Helped develop a strategy to address seat limit overages"

### Section Rules
- Bullets must go under the role where the work happened — Productboard → PRODUCTBOARD, Abbott → ABBOTT, PINN → PINN INVESTMENTS
- Use `<w:numId w:val="39"/>` for all bullet paragraphs — match existing XML structure exactly
- **Productboard:** no hard cap on bullets
- **PINN:** max 4 bullets — up to 6 for real estate or legal roles
- **Abbott:** max 2 bullets — keep it at 1 unless it is a healthcare related role and another bullet is a value add and justified

### Skills Rules
- Reorder to front-load skills most relevant to the target role
- Hard/technical skills always come before soft or general skills
- Keep the same pipe-delimited format — do not add or remove the "Skills:" or "Technical & Analytics:" labels
- Technical & Analytics line stays unchanged unless the role specifically rewards different tools

### Data Integrity
- Every bullet must trace back to real Airtable data — Description, Result, or Collaborators fields
- Never invent metrics, outcomes, or stakeholders not present in the data
- If a result is not quantified in Airtable, write the bullet without a number rather than fabricating one
- If data is sparse for a section, write fewer bullets rather than padding with weak ones
- **Work Logs table (`tblH7q7PgoGbBukXN`) is READ-ONLY** — never create, update, or delete records under any circumstances
