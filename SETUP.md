# Setup Guide

This repo generates tailored one-page resumes and ATS documents from an Airtable work log, driven by Claude Code slash commands.

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed and signed in
- Python 3.8+ installed
- An Airtable base with a Work Logs table (see field requirements below)

---

## Airtable: required fields

Your Work Logs table needs these fields (names can be customized during setup):

| Field | Type |
|-------|------|
| `Resume Worthy` | Checkbox |
| `Project Name` | Text |
| `Skills Used` | Text or multi-select |
| `Smaller Summary` | Short text — one-line blurb used for relevance ranking |
| `Description` | Long text |
| `Result` | Long text |
| `Tools Used` | Text or multi-select |
| `Collaborators` | Text |

---

## Run setup

1. Clone this repo and open it in Claude Code
2. Run `/setup`

Claude will ask you to drop your resume `.docx` into the repo root, extract everything it can from it (name, title, employer, sections, bullets, template structure), confirm the findings with you, and collect your Airtable credentials. That's it.

When setup completes, run `/resume-optimizer` and paste a job description.

---

## What transfers without any changes

| Generic — no setup needed | Personal — configured by `/setup` |
|---|---|
| Full resume-optimizer workflow | `references/user_config.md` |
| ATS document logic and scoring | `references/template-strings.md` |
| All scripts (`pack.py`, `build_ats.py`, `unpack.py`) | `resume_template.docx` + `unpacked_template/` |
| Bullet writing rules (action verbs, format, character limits) | `.env` |
| JD analysis and keyword extraction | |
