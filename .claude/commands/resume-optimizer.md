# Resume Generation

Generates a tailored one-page resume for a specific job application by pulling real accomplishments from Airtable and editing the base template.

## Workflow

1. **Pull Airtable data** — Query Work Logs (`tblH7q7PgoGbBukXN`) where `Resume Worthy = true`. Collect: Project Name, Description, Result, Skills Used, Tools Used, Collaborators.
2. **Analyze JD** — Extract 8–12 ATS keywords, identify 3–5 themes, select 7–9 most relevant Work Log records, map each to the correct job section. Mirror JD's exact terminology throughout.
3. **Draft all content** — Write summary and all bullets before touching any files. Get approval if uncertain about selections.
4. **Edit resume** — Follow the file editing workflow in CLAUDE.md.
5. **Deliver** — Show the bullets for review.

---

## Summary Rules

- Always open with: `"UCLA Anderson MBA and Business Strategy & Insights Manager at Productboard,"` — add `"(Series D B2B SaaS)"` after Productboard for startup roles
- Remaining sentences describe what Aatum brings in general terms mapped to JD themes — no specific projects, metrics, tools, or bullet-level results in the summary
- Hard cap: 275 characters total (3 physical lines at 10pt Times New Roman) — count before writing, trim aggressively
- No vague jargon: no "passionate about," "leverages," "dynamic," "results-driven"
- Actual title is **Business Strategy & Insights Manager** — never invent a different title in title case; lowercase substitutions (e.g., "strategy and operations professional") are allowed

---

## Bullet Rules

**Format:** Action Verb → Context → Quantified Result

**Verbs to avoid:** helped, assisted, worked on, was responsible for, participated in, contributed to, supported, collaborated on

**Power verbs:** Architected, Built, Designed, Drove, Engineered, Identified, Launched, Led, Modeled, Operationalized, Scaled, Structured, Defined, Developed, Executed, Synthesized, Converted, Reduced, Spearheaded, Deployed

- Never repeat a starting verb across bullets
- No articles (a, an, the)
- Write for a recruiter audience — lead with business impact, not methodology
- Distinguish between work that *used* AI and work that was *about* AI — do not conflate
- Do not mix project description with result — describe what was done, then what it drove
- Never use unexpanded acronyms — every bullet must be readable by a generalist recruiter (e.g., "healthcare provider" not "HCP"; exception: AI, MBA, B2B, SaaS)
- Quantify wherever possible — numbers, percentages, dollar values, timeframes, scale
- Signal 0-to-1 work explicitly: "built from scratch," "designed and launched," "stood up"
- Order bullets strongest-first within each section (most quantified + most relevant to this role)
- Max ~190 characters per bullet (2 rendered lines at 10pt Times New Roman)

---

## Section Rules

- Place bullets under the role where the work happened: Productboard → PRODUCTBOARD, Abbott → ABBOTT, PINN → PINN INVESTMENTS
- **Productboard:** no hard cap
- **PINN:** max 4 bullets (up to 6 for real estate or legal roles)
- **Abbott:** max 1 bullet unless the role is healthcare-related and a second bullet adds clear value (max 2)

---

## Skills Rules

- Reorder to front-load skills most relevant to the target role
- Hard/technical skills before soft/general skills
- Keep pipe-delimited format and "Skills:" / "Technical & Analytics:" labels unchanged
- Technical & Analytics line stays unchanged unless the role specifically rewards different tools

---

## Data Integrity

- Every bullet must trace to real Airtable data (Description, Result, or Collaborators fields)
- Never invent metrics, outcomes, or stakeholders not present in the data
- If a result is unquantified in Airtable, write the bullet without a number
- Work Logs table is READ-ONLY — never create, update, or delete records
