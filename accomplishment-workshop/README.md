# Accomplishment Workshop

A standalone working space for sharpening the raw stories in the Airtable Work Logs
into resume-grade bullet points. **This folder does not touch the `/resume-optimizer`
pipeline** — it's upstream of it. The goal: turn vague, unquantified, or "still in
design" stories into tight, proof-carrying bullets, grounded against the real jobs
that rejected us.

## Why this exists

Fast rejections usually mean the resume isn't surviving the 6-second screen or the ATS
keyword pass. Looking at the Work Logs, the likely culprit:

- The **most quantified, outcome-proven stories are PINN (finance/RE) and Abbott
  (healthcare)** — the wrong industry signal for product-strategy / RevOps / analytics roles.
- The **Productboard stories** — the *relevant* ones — are disproportionately missing a
  filled-in `Result`, or describe work still at the design/spec stage. They read as
  *proposed*, not *delivered*.

So the work here is two-fold:
1. **Extract a real, defensible outcome** for the relevant Productboard stories (even if
   the project is mid-flight — leading indicators, scope, decisions-driven count).
2. **Rewrite** each into a ~190-char, metric-led, no-em-dash bullet tuned to a target role.

## Files

| File | Purpose |
|------|---------|
| `inventory.md` | Every Work Log story rated by strength + the specific gap holding it back |
| `target-roles.md` | The role archetypes we're aiming at + the rejected JDs that ground them |
| `bullets/` | Refined bullet drafts, one file per story, with role-tuned variants |

## Workflow

1. Pick a target-role archetype (see `target-roles.md`).
2. From `inventory.md`, pull the stories that matter for it.
3. For each: identify the missing proof, dig the real number out of the user, draft 2-3
   bullet variants, pressure-test against the rejected JD's language.
