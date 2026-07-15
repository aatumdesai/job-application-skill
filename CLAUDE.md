# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Claude Code command/skill repo for job applications. It generates tailored, one-page resumes, ATS documents, cover letters, and LinkedIn outreach from an Airtable Work Logs table. **Most of the "logic" lives in markdown command/skill files, not Python** — the Python scripts only pack/unpack/validate Office XML. The commands are the program; treat them as the source of behavior.

## Entry points

| Invoke | File | Does |
|--------|------|------|
| `/setup` | `.claude/commands/setup.md` | First-time config — extracts identity/sections from an uploaded resume `.docx`, writes `user_config.md`, `template-strings.md`, `resume_template.docx`, `unpacked_template/`, `.env` |
| `/resume-optimizer` | `.claude/commands/resume-optimizer.md` | Full resume + ATS build from a pasted JD |
| `/cover-letter` | `.claude/commands/cover-letter.md` | Tailored one-page cover letter `.docx` |
| `/linkedin-outreach` | `.claude/commands/linkedin-outreach.md` | LinkedIn InMail / connection / message |
| `/smaller-summary-writer` | `.claude/commands/smaller-summary-writer.md` | Writes the `Smaller Summary` blurbs used for relevance ranking |

## Architecture

**1. DOCX-as-XML pipeline.** A `.docx` is a zip of XML. The workflow never edits the binary `.docx` directly:
- `scripts/unpack.py <file.docx> <dir>` → expands to a directory of XML (`word/document.xml` is the body).
- Edit `word/document.xml` by **exact find/replace** against the strings in `references/template-strings.md` — do *not* read the whole file and rewrite it; substitute only the listed strings, leave all other XML byte-for-byte unchanged.
- `scripts/pack.py <dir> <out.docx> --original resume_template.docx` → re-zips, condenses XML, and validates. Pass `--original` so author/redline metadata is inferred from the source.
- `scripts/validate.py` and the `scripts/validators/` package check the result against OOXML XSD schemas (`scripts/schemas/`) plus a redlining validator; pack.py auto-repairs `paraId`/`durableId` overflow and missing `xml:space="preserve"`.

**2. Config-driven personalization.** `references/user_config.md` is the single source of truth for identity, section names, bullet caps, the fixed paragraph count, and Airtable field names. `references/template-strings.md` holds the exact substitution strings tied to the current `resume_template.docx`. When the role, employer, or template changes, update these — not the command logic. This separation is what makes the repo shareable: generic logic in commands/scripts, personal data in `references/` + `.env`.

**3. Airtable as data source (READ-ONLY).** Work Logs records are pulled via the Airtable MCP tools, never written. The resume flow uses a two-pass query (lightweight rank → targeted detail); cover-letter and linkedin use a single pass. Field names come from `user_config.md`.

**4. Subagent delegation.** The resume-optimizer delegates the prose quality review (step 6) and the mechanical ATS build (step 7) to subagents with self-contained prompts. Analytical decisions (which bullets, ATS highlights, scores) stay in the main session.

## Commands

```bash
# Python path lives in .env as PYTHON_PATH (Windows-style interpreter path is common here).
# All invocations use PYTHONIOENCODING=utf-8.

# Unpack / pack
PYTHONIOENCODING=utf-8 $PYTHON_PATH scripts/unpack.py <file.docx> <dir>/
PYTHONIOENCODING=utf-8 $PYTHON_PATH scripts/pack.py <dir>/ "<out.docx>" --original resume_template.docx

# Validate a packed file or unpacked dir
PYTHONIOENCODING=utf-8 $PYTHON_PATH scripts/validate.py "<file-or-dir>" [--original resume_template.docx] [--auto-repair]

# Re-derive unpacked_template/ after resume_template.docx changes
./refresh_template.sh

# Build a cover letter from structured JSON
$PYTHON_PATH scripts/build_cover_letter.py cover_letter_content.json output.docx
```

Resume build never unpacks the template live — copy the pre-unpacked dir instead:
```bash
rm -rf unpacked_resume/ && cp -r unpacked_template/ unpacked_resume/
```

There are no automated tests; the validators are the correctness check. A successful resume build prints `Paragraphs: 33 → 33 (0)` and `All validations PASSED!`.

## Critical Rules

- **Never modify `resume_template.docx`** — it is the master baseline; always copy `unpacked_template/` → `unpacked_resume/` first.
- **Work Logs table is READ-ONLY** — never create, update, or delete records.
- **One page only** — total `<w:p>` paragraph count must stay at **33** (set in `user_config.md`). Adding a bullet requires removing a weaker one in the same section. If pack reports a different count, stop and report it.
- **No em dashes** in generated resume/letter copy — they read as LLM-written. (This rule is for output documents, not this file.)
- **Edit `document.xml` by exact substitution only** — never read-then-rewrite; that corrupts the XML.

## Folder Map

| Path | Purpose |
|------|---------|
| `.claude/commands/` | All slash-command definitions (the actual workflows) |
| `references/user_config.md` | Identity, sections, bullet caps, paragraph count, Airtable fields — update when role/employer/template changes |
| `references/template-strings.md` | Exact find/replace strings for `document.xml` |
| `references/ats-reference.md` | ATS highlight colors, page-2 XML structure, `ats_config.json` schema |
| `references/cover-letter-examples.md`, `cover-letter-samples/` | Cover letter style references |
| `references/linkedin-examples.md` | LinkedIn outreach style reference |
| `scripts/pack.py`, `unpack.py`, `validate.py` | DOCX/PPTX/XLSX XML pipeline |
| `scripts/build_cover_letter.py` | Cover letter `.docx` builder (uses `python-docx`) |
| `scripts/soffice.py` | LibreOffice (`soffice`) conversion helper |
| `scripts/validators/`, `scripts/schemas/` | OOXML XSD validators + bundled ECMA/ISO/Microsoft schemas |
| `scripts/helpers/` | `merge_runs.py`, `simplify_redlines.py` XML utilities |
| `resume_template.docx` | Master template — never edit directly |
| `unpacked_template/` | Pre-unpacked template — copy this, don't unpack each run |
| `unpacked_resume/`, `unpacked_ats/` | Working dirs (gitignored) |
| `refresh_template.sh` | Re-unpack template after it changes |
| `Resumes/` | All generated output |
| `.env` | `AIRTABLE_BASE_ID`, `WORKLOGS_TABLE_ID`, `PYTHON_PATH` (gitignored) |

> **Note:** `scripts/build_ats.py` is referenced by `resume-optimizer.md` (step 7) and `ats-reference.md` but is **gitignored and not committed** — it must exist locally for the ATS step to run. If it's missing, the ATS build will fail; restore it before running `/resume-optimizer` end-to-end.
