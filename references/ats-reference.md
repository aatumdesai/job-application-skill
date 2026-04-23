# ATS Color Guide

Reference for ATS document highlighting and page 2 structure.

## Highlight Color System

Use `<w:shd>` not `<w:highlight>` — allows custom hex fills.

| Color | Hex fill | Meaning |
|-------|----------|---------|
| Pale cyan | `A3CCCC` | Key req theme 1 — assigned per run |
| Pale green | `A3CCA3` | Key req theme 2 — assigned per run |
| Pale pink | `CCA3CC` | Key req theme 3 — assigned per run |
| Pale red | `CCA3A3` | Key req theme 4 — assigned per run |
| Pale amber | `CCB780` | Key req theme 5 — assigned per run |

**Color assignment:** In Step 3, identify 3–5 experience themes from the JD. Assign each theme one color from the palette above (cyan → green → pink → red → amber, in order). Record the mapping in `ats_config.json` under `key_reqs`. Every `highlights` entry and `key_reqs` entry for the same theme must use the same hex.

**Shading syntax** (goes inside `<w:rPr>`):
```xml
<w:shd w:val="clear" w:color="auto" w:fill="A3CCCC"/>
```

## ATS Keyword Rule — Bold, Not Yellow

ATS keywords from the JD are bolded (not highlighted) on page 1. The script automatically bolds found `ats_keywords` using word-boundary matching — Claude does not add them to the `highlights` array. Theme colors are applied first; ATS bold is applied on top of any theme-colored run.

**The test:** Can you point to the exact phrase in the JD? If not, mark `found: false`. Partial word matches are excluded (word-boundary matching prevents e.g. "AI" bolding inside "Desai").

## Page 1 Highlight Targets

- **Summary:** highlight exact JD phrases that appear verbatim or near-verbatim
- **Bullets:** highlight the specific phrase (action, metric, or keyword) that maps to the JD — not the whole bullet
- **Skills lines:** highlight exact terms listed in the JD

## build_ats.py Config JSON Schema

Claude generates this file, then calls `scripts/build_ats.py --input [resume] --output [ats] --config [config.json]`.

```json
{
  "company": "Stripe",
  "role": "Link Strategy Operations Manager",
  "date": "2026-03-25",
  "key_reqs": [
    {"text": "GTM strategy", "covered": true, "color": "A3CCCC"},
    {"text": "SQL proficiency", "covered": false}
  ],
  "ats_keywords": [
    {"text": "go-to-market", "found": true},
    {"text": "strategy operations", "found": false}
  ],
  "highlights": [
    {"phrase": "Drove $65M divestiture", "color": "A3CCCC"},
    {"phrase": "SQL", "color": "CCB780"}
  ],
  "role_overview": [
    "Reports to VP Strategy",
    "Cross-functional with Product, Sales, Finance"
  ],
  "alignment_score": 8,
  "key_reqs_met": 4,
  "key_reqs_total": 5,
  "ats_found": 7,
  "ats_total": 10
}
```

**Highlights rule:** Each `phrase` must appear verbatim in the resume text. The script finds the phrase in document.xml and wraps it with the given fill color.

## Page 2 XML Structure

Use `unpacked_ats_review/` as the canonical formatting reference.

### Section Headers (JD ANALYSIS, ROLE OVERVIEW, KEY REQUIREMENTS, ATS KEYWORDS, RESUME ALIGNMENT)

```xml
<w:pStyle w:val="BodyText"/>
<w:pBdr><w:bottom w:val="single" w:sz="4" w:space="1" w:color="auto"/></w:pBdr>
<w:spacing w:before="160" w:after="0"/>
```
Run: `<w:b/><w:bCs/>` — no explicit `<w:sz>` on the header run itself.

### Alignment Stats Line (immediately after JD ANALYSIS header)

- `<w:spacing w:after="100"/>`, 22pt (`<w:sz w:val="22"/><w:szCs w:val="22"/>`)
- Pattern: **bold** "Alignment: " + regular score + **bold** "Key Req" + regular ": X/Y   |   " + **bold** "ATS" + regular ": X/Y"

### Role Overview Items — numbered list

- `<w:pStyle w:val="ListParagraph"/>` + `<w:numId w:val="52"/>`
- `<w:spacing w:after="20"/>` (last item: `w:after="100"`)
- `<w:ind w:left="720"/>`, 22pt text

### Key Requirement Bullets — bullet list

- `<w:numId w:val="35"/>`
- `<w:tabs><w:tab w:val="right" w:pos="10800"/></w:tabs>`
- 22pt, whole run shaded in theme color (covered) or no shading (gap)

### Empty Spacing Paragraphs

Between sections: `<w:spacing w:after="20"/>` or `w:after="40"` depending on gap needed.

### ATS Keywords Paragraph

- `<w:spacing w:after="100"/>`, `<w:ind w:left="360"/>`, 22pt
- Individual shaded/unshaded runs separated by plain `  |  ` runs

### Resume Alignment Score Lines

- `<w:ind w:left="360"/>`, `<w:spacing w:after="20"/>`, 22pt
- Bold label ("Score", "Key requirements", "ATS keywords") + regular ": value"

### Page Break

Insert before page 2 content:
```xml
<w:p><w:r><w:br w:type="page"/></w:r></w:p>
```

All page 2 content goes before `<w:sectPr>` in `word/document.xml`.
