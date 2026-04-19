# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Skill Does

Generates a tailored, one-page resume for a specific job application. When the user pastes a job description, this skill pulls real accomplishments from Airtable, selects the most relevant ones, writes bullets, and produces a customized `.docx` resume.

## Key References

| Item | Value |
|------|-------|
| Resume template | `resume_template.docx` — never modify directly |
| Pre-unpacked template | `unpacked_template/` — committed, use this instead of unpacking each time |
| Generated resumes | `Resumes/` |
| Python | `/c/Users/aatum/AppData/Local/Programs/Python/Python312/python.exe` |
| Pack script | `scripts/pack.py` |
| Refresh script | `refresh_template.sh` — run this if `resume_template.docx` ever changes |
| Airtable base ID | `appFHhhJ6VkwkdpPQ` |
| Work Logs table | `tblH7q7PgoGbBukXN` (READ-ONLY) |

## Workflow

1. **Get JD** — User pastes full job description directly into chat. Do not fetch from URLs.
2. **Pull Airtable data** — Query Work Logs (`tblH7q7PgoGbBukXN`) for records where `Resume Worthy = true`. Collect: Project Name, Description, Result, Skills Used, Tools Used, Collaborators.
3. **Analyze & select** — Extract 8–12 ATS keywords, identify 3–5 themes, select 7–9 most relevant Work Log records, map to job sections. Mirror JD's exact terminology.
4. **Draft bullets** — Write all bullets before touching any files (see Bullet Rules below).
5. **Edit resume**:
   - `cp -r unpacked_template/ unpacked_resume/`
   - Edit `unpacked_resume/word/document.xml` using the exact find/replace strings in **Template Strings** below — do not read the file
   - `PYTHONIOENCODING=utf-8 /c/Users/aatum/AppData/Local/Programs/Python/Python312/python.exe scripts/pack.py unpacked_resume/ "Resumes/[filename].docx" --original resume_template.docx`
   - Confirm output says `Paragraphs: 33 → 33 (0)` and `All validations PASSED!`
6. **Deliver** — Show the bullets for review.

## Template Strings

Exact text to find/replace in `unpacked_resume/word/document.xml`. Do not read the file — use these strings directly.

**Summary** (replace the entire sentence block):
```
UCLA Anderson MBA and Business Strategy &amp; Insights Manager at Productboard (B2B SaaS), leading cross-functional strategy across Product, GTM, and monetization. Translate complex analysis into clear prioritization, growth, and expansion decisions, partnering with senior stakeholders to drive alignment and execution.
```

**Productboard bullet 1:**
```
Led tradeoff-based prioritization study (MaxDiff) across 65 AI use cases for product managers, informing AI roadmap focus and GTM positioning around highest-impact adoption drivers
```

**Productboard bullet 2:**
```
Designed and drove a revenue capture strategy for customers exceeding contracted seat limits, converting product usage analytics into actionable expansion motions for Sales
```

**Productboard bullet 3:**
```
Identified account fragmentation between self-serve and enterprise customers and designed consolidation motion, improving account-level adoption within existing enterprise contracts
```

**Productboard bullet 4:**
```
Act as internal strategy consultant across Product, Marketing, Sales, and Finance, aligning stakeholders to execute high-priority initiatives and establish scalable operating frameworks
```

**Abbott bullet:**
```
Conducted primary research with healthcare providers to identify adoption drivers for medical device product, informing segmented product positioning aligned to provider priorities
```

**PINN bullet 1:**
```
Spearheaded 0-to-1 product concept development for Marriott hotel, synthesizing market, competitive, and customer inputs to define product offering in partnership with design, driving 14% uplift in projected IRR
```

**PINN bullet 2:**
```
Drove $65M divestiture of a flagship asset, leading due diligence, financial modeling, and positioning strategy to achieve a record-setting valuation and 120% return on equity
```

**PINN bullet 3:**
```
Directed 20+ person cross-functional task force on $34M construction dispute, delivering forensic analysis to inform legal strategy and reduce exposure by $11M
```

**PINN bullet 4:**
```
Enabled $12M in capital-deployment decisions by evaluating acquisition and ground-up development opportunities, modeling ROI, strategic fit, and long-term growth alignment
```

**Skills line** (note the leading space and trailing spaces — preserve them):
```
 Corporate and Growth Strategy | Product Growth and Analytics | Business Operations (BizOps) | Go-to-Market Strategy | Pricing and Monetization | Financial Modeling and Capital Allocation | Market and Customer Research
```

**Technical & Analytics line** (unchanged across all resumes unless role specifically rewards different tools):
```
: SQL | Conjoint / MaxDiff (Sawtooth) | Tableau | Excel (Advanced) | Python | R
```

## Hard Rules

### Resume Format
- **One page only** — adding a bullet requires removing a weaker one in the same section; total paragraph count must stay identical
- **No em dashes** — use a comma, semicolon, or restructure
- **Never modify `resume_template.docx`** — always copy first

### Summary Rules
- Open with: `"UCLA Anderson MBA and Business Strategy & Insights Manager at Productboard,"` — for startup roles add `"(Series D B2B SaaS)"` after Productboard
- Remaining sentences connect real experience to the specific JD; do not repeat sentence 1
- Max 3 physical lines at 10pt Times New Roman (~300 characters total); trim aggressively
- No vague jargon: no "passionate about," "leverages," "dynamic," "results-driven"
- Actual title is **Business Strategy & Insights Manager** — never invent a different title in title case; lowercase substitutions (e.g., "strategy and operations professional") are allowed
- Match run formatting: 20pt Times New Roman, italic via `iCs` tag

### Bullet Rules
**Format:** Action Verb → Context → Quantified Result

**Verbs to avoid:** helped, assisted, worked on, was responsible for, participated in, contributed to, supported, collaborated on

**Power verbs to use:** Architected, Built, Designed, Drove, Engineered, Identified, Launched, Led, Modeled, Operationalized, Scaled, Structured, Defined, Developed, Executed, Synthesized, Converted, Reduced, Spearheaded, Deployed

- Never repeat a starting verb across bullets
- No articles (a, an, the)
- Quantify wherever possible — numbers, percentages, dollar values, timeframes, scale
- Signal 0-to-1 work explicitly: "built from scratch," "designed and launched," "stood up"
- Order bullets strongest-first (most quantified + most relevant to the role)
- Max ~190 characters per bullet (2 rendered lines at 10pt Times New Roman)

### Section Rules
- Bullets go under the role where the work happened: Productboard → PRODUCTBOARD, Abbott → ABBOTT, PINN → PINN INVESTMENTS
- Use `<w:numId w:val="39"/>` for all bullet paragraphs — match existing XML structure exactly
- **Productboard:** no hard cap
- **PINN:** max 4 bullets (up to 6 for real estate or legal roles)
- **Abbott:** max 2 bullets (keep at 1 unless healthcare-related and the second adds clear value)

### Skills Rules
- Reorder to front-load skills most relevant to the target role
- Hard/technical skills before soft/general skills
- Keep pipe-delimited format and "Skills:" / "Technical & Analytics:" labels unchanged
- Technical & Analytics line stays unchanged unless the role specifically rewards different tools

### Data Integrity
- Every bullet must trace to real Airtable data (Description, Result, or Collaborators fields)
- Never invent metrics, outcomes, or stakeholders not present in the data
- If a result is unquantified in Airtable, write the bullet without a number rather than fabricating one
- **Work Logs table is READ-ONLY** — never create, update, or delete records

---

## ATS Document (Page 2)

### ATS Doc Workflow
1. Copy final resume to `Resumes/[Company] - [Job Title] - [YYYY-MM-DD] - ATS.docx`
2. Unpack: `python scripts/unpack.py "[ATS filename]" unpacked_ats/`
3. Edit `unpacked_ats/word/document.xml` — apply highlights to page 1, then append page 2 content before `<w:sectPr>`
4. Pack: `PYTHONIOENCODING=utf-8 python scripts/pack.py unpacked_ats/ "[ATS filename]" --validate false`

### Highlight Color System (use `<w:shd>` not `<w:highlight>` — allows custom hex)

| Color | Hex fill | Meaning |
|-------|----------|---------|
| Pale yellow | `CCCCA3` | ATS keyword — exact text match to JD |
| Pale cyan | `A3CCCC` | Key req: GTM strategy, analytics, expansion |
| Pale green | `A3CCA3` | Key req: Market & competitive intelligence |
| Pale pink | `CCA3CC` | Key req: Executive reporting & operating cadences |
| Pale red | `CCA3A3` | Key req: Cross-functional leadership |
| Pale amber | `CCB780` | Key req: SQL / Python proficiency |

**Shading syntax** (goes inside `<w:rPr>`):
```xml
<w:shd w:val="clear" w:color="auto" w:fill="FFFFCC"/>
```

**ATS keyword rule — verbatim JD text only:** Yellow shading applies only when a word or phrase from the JD appears in the resume in the same or near-identical form. Assume the dumbest possible matcher — traditional ATS systems do literal string matching. The test: can you point to the exact line in the JD where this phrase appears? If not, it does not get yellow. Resume-specific language (technique names, internal jargon, outcome phrases) never gets yellow regardless of how relevant it seems.

### Page 1 Highlight Targets
- **Summary:** highlight exact JD phrases that appear verbatim or near-verbatim
- **Bullets:** highlight the specific phrase (action, metric, or keyword) that maps to the JD — not the whole bullet
- **Skills lines:** highlight exact terms listed in the JD

### Page 2 XML Structure
Use `unpacked_ats_review/` as the canonical formatting reference for page 2.

**Section headers** (JD ANALYSIS, ROLE OVERVIEW, KEY REQUIREMENTS, ATS KEYWORDS, RESUME ALIGNMENT):
```xml
<w:pStyle w:val="BodyText"/>
<w:pBdr><w:bottom w:val="single" w:sz="4" w:space="1" w:color="auto"/></w:pBdr>
<w:spacing w:before="160" w:after="0"/>
```
Run: `<w:b/><w:bCs/>` — no explicit `<w:sz>` on the header run itself.

**Alignment stats line** (immediately after JD ANALYSIS header):
- `<w:spacing w:after="100"/>`, 22pt (`<w:sz w:val="22"/><w:szCs w:val="22"/>`)
- Pattern: **bold** "Alignment: " + regular score + **bold** "Key Req" + regular ": X/Y   |   " + **bold** "ATS" + regular ": X/Y"

**Role overview items** — actual Word numbered list:
- `<w:pStyle w:val="ListParagraph"/>` + `<w:numId w:val="54"/>` (copy numId from reference file's numbering.xml)
- `<w:spacing w:after="20"/>` (last item: `w:after="100"`)
- `<w:ind w:left="720"/>`, 22pt text

**Key requirement bullets** — actual Word bullet list:
- `<w:numId w:val="35"/>` (copy numId from reference file's numbering.xml)
- `<w:tabs><w:tab w:val="right" w:pos="10800"/></w:tabs>`
- 22pt, whole run shaded in theme color (covered) or no shading (gap)

**Empty spacing paragraphs** between sections: `<w:spacing w:after="20"/>` or `w:after="40"` depending on gap needed.

**ATS keywords paragraph:**
- `<w:spacing w:after="100"/>`, `<w:ind w:left="360"/>`, 22pt
- Individual shaded/unshaded runs separated by plain `  |  ` runs

**Resume Alignment score lines:**
- `<w:ind w:left="360"/>`, `<w:spacing w:after="20"/>`, 22pt
- Bold label ("Score", "Key requirements", "ATS keywords") + regular ": value"
