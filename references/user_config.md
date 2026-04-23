# User Config

Personal identity and layout settings for the resume optimizer. Update this file when your role, employer, or template changes — nowhere else needs to change.

---

## Identity

```
Current title:     Business Strategy & Insights Manager
Current employer:  Productboard (Series D B2B SaaS)
Degree:            UCLA Anderson MBA
```

## Summary Opener

Fixed first clause that begins every summary. Must not change between applications.

```
UCLA Anderson MBA and Business Strategy & Insights Manager at Productboard,
```

For startup roles, append `(Series D B2B SaaS)` after Productboard:
```
UCLA Anderson MBA and Business Strategy & Insights Manager at Productboard (Series D B2B SaaS),
```

## Summary Constraints

- Hard cap: **275 characters total** (3 physical lines at 10pt Times New Roman)
- Verify with: `echo -n "your summary text" | wc -c`
- Remaining sentences shaped by Experience Themes from the JD — no specific projects, metrics, or tools

## Sections

| Display Label | XML Section | Bullet Cap | Notes |
|---------------|-------------|------------|-------|
| PRODUCTBOARD  | Productboard | No hard cap | Primary role |
| ABBOTT        | Abbott | 1 (max 2 for healthcare roles) | Add second bullet only if role is healthcare-related and it adds clear value |
| PINN INVESTMENTS | PINN | 4 (max 6 for real estate or legal roles) | |

Place each bullet under the role where the work happened.

## Template Layout

- **Paragraph count:** 33 — total must stay at 33 after edits; adding a bullet requires removing a weaker one in the same section
- **Bullet XML:** `<w:numId w:val="39"/>` for all bullet paragraphs
- **Bullet character limit:** ~190 characters (2 rendered lines at 10pt Times New Roman)

## Airtable Field Names

Fields pulled from the Work Logs table. Update if the Airtable schema changes.

| Field | Used in |
|-------|---------|
| `Resume Worthy` | Pass 1 filter |
| `Project Name` | Pass 1 + Pass 2 |
| `Skills Used` | Pass 1 + Pass 2 |
| `Smaller Summary` | Pass 1 |
| `Description` | Pass 2 |
| `Result` | Pass 2 |
| `Tools Used` | Pass 2 |
| `Collaborators` | Pass 2 |
