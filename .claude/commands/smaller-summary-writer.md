# Smaller Summary Writer

Finds Work Log records missing a `Smaller Summary` and backfills them. Run this whenever new records are added to the table.

## Setup

Load from `.env`:
- `AIRTABLE_BASE_ID` — Airtable base
- `WORKLOGS_TABLE_ID` — Work Logs table

## Workflow

### 1. Find incomplete records
Query Work Logs (`WORKLOGS_TABLE_ID`) where `Resume Worthy = true` AND `Smaller Summary` is empty. Fields: Project Name, Description, Result, Skills Used.

If no records are missing a summary, report that all records are up to date and stop.

### 2. Generate summaries
For each incomplete record, write a 2-sentence `Smaller Summary`:
- Sentence 1: What the work was and the measurable outcome (if any). Be specific — include company context, method, and result.
- Sentence 2: "Best for [role types] roles." — list 3–4 role archetypes this experience is most relevant to.

**Rules:**
- Never invent metrics not present in Description or Result
- Keep each summary under 400 characters total
- Write in third-person present tense ("Analyzed...", "Built...", "Led...")

### 3. Write back
Update each record's `Smaller Summary` field via Airtable. Process in batches of 10.

### 4. Confirm
Report how many records were updated and list their Project Names.
