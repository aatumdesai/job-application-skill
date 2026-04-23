# CLAUDE.md

Generates tailored, one-page resumes and ATS documents from Airtable work logs. Entry point: `/resume-optimizer` (`.claude/commands/resume-optimizer.md`).

## Critical Rules

- **Never modify `resume_template.docx`** — always copy first
- **Work Logs table is READ-ONLY** — never create, update, or delete records
- **One page only** — total paragraph count must stay at 33

## Folder Map

| Path | Purpose |
|------|---------|
| `.claude/commands/resume-optimizer.md` | `/resume-optimizer` slash command — start here |
| `references/user_config.md` | Identity, section names, bullet caps, paragraph count, Airtable fields — update when role/employer changes |
| `references/template-strings.md` | Exact find/replace strings for document.xml substitution |
| `references/ats-reference.md` | ATS highlight colors, page 2 XML structure, config JSON schema |
| `references/cover-letter-examples.md` | Cover letter style reference (stub) |
| `references/linkedin-examples.md` | LinkedIn outreach style reference (stub) |
| `resume_template.docx` | Master template — never edit directly |
| `unpacked_template/` | Pre-unpacked template — copy this instead of unpacking each time |
| `unpacked_resume/` | Working dir for resume edits (gitignored) |
| `scripts/pack.py` | Packs unpacked dir → .docx |
| `scripts/unpack.py` | Unpacks .docx → directory |
| `scripts/build_ats.py` | Standalone ATS document builder |
| `refresh_template.sh` | Run if `resume_template.docx` ever changes |
| `Resumes/` | All generated output |
| `.env` | Secrets: AIRTABLE_BASE_ID, WORKLOGS_TABLE_ID, PYTHON_PATH |
