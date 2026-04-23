# Setup Guide

This repo generates tailored one-page resumes and ATS documents from an Airtable work log, driven by Claude Code slash commands. Here's how to set it up for your own use.

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed and signed in
- Python 3.8+ installed
- An Airtable base with a Work Logs table (see field requirements below)

---

## Step 1: Configure your identity

Edit `references/user_config.md` and replace all personal values:

- **Identity** — your current title, employer, degree
- **Summary Opener** — the fixed first clause of every resume summary
- **Sections** — your roles, their display labels, and bullet caps
- **Template Layout** — update paragraph count if your template has a different number of paragraphs
- **Airtable Field Names** — update if your table uses different field names

This is the only file that is specific to you. Everything else in the workflow is generic.

---

## Step 2: Bring your own resume template

1. Replace `resume_template.docx` with your own one-page resume template
2. Run the unpack script to regenerate the template directory:
   ```bash
   python scripts/unpack.py resume_template.docx unpacked_template/
   ```
3. Run the refresh script to verify:
   ```bash
   bash refresh_template.sh
   ```
4. Update **paragraph count** in `references/user_config.md` to match your template

---

## Step 3: Add your baseline bullets

Edit `references/template-strings.md` — replace all example bullets with your own career history. These are the baseline strings Claude will find-and-replace in `document.xml` during the first run.

---

## Step 4: Set up Airtable

Create (or reuse) an Airtable base with a Work Logs table. Required fields:

| Field | Type | Notes |
|-------|------|-------|
| `Resume Worthy` | Checkbox | Filters which records are pulled |
| `Project Name` | Text | |
| `Skills Used` | Text or multi-select | |
| `Smaller Summary` | Text | Short blurb used in Pass 1 |
| `Description` | Long text | Full project description |
| `Result` | Long text | Quantified outcomes |
| `Tools Used` | Text or multi-select | |
| `Collaborators` | Text | |

If you use different field names, update them in `references/user_config.md`.

---

## Step 5: Create your `.env` file

Create a `.env` file at the repo root (it is gitignored):

```
AIRTABLE_BASE_ID=appXXXXXXXXXXXXXX
WORKLOGS_TABLE_ID=tblXXXXXXXXXXXXXX
PYTHON_PATH=/path/to/python3
```

Find your base and table IDs in the Airtable API docs for your base.

---

## Step 6: Run it

Open Claude Code in this directory and run:

```
/resume-optimizer
```

Paste a job description when prompted. Claude will pull from your Airtable, draft content, and output two files:
- `Resumes/[Company] - [Job Title] - [YYYY-MM-DD].docx` — formatted resume
- `Resumes/[Company] - [Job Title] - [YYYY-MM-DD] - ATS.docx` — keyword-highlighted ATS version

---

## What is and isn't personalized

| Generic (no changes needed) | Personal (you configure) |
|-----------------------------|--------------------------|
| Full resume-optimizer workflow | `references/user_config.md` |
| ATS document logic | `references/template-strings.md` |
| All scripts (`pack.py`, `build_ats.py`, `unpack.py`) | `resume_template.docx` + `unpacked_template/` |
| Bullet writing rules | `.env` |
| JD analysis and keyword extraction | |
