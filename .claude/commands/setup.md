# Setup

Guides a new user through first-time configuration by extracting everything possible from their resume template, then confirming with the user and collecting only what can't be inferred. Writes `references/user_config.md`, `references/template-strings.md`, `resume_template.docx`, `unpacked_template/`, and `.env`.

---

## Step 1: Get the template file

Ask the user:

> "Drop your resume `.docx` into the repo root and tell me the filename."

Wait for their response before proceeding.

---

## Step 2: Unpack the template

```bash
rm -rf setup_temp/
$PYTHON_PATH scripts/unpack.py "[filename]" setup_temp/
```

If the unpack fails, report the error and stop.

---

## Step 3: Extract everything from document.xml

Read `setup_temp/word/document.xml`. Walk every `<w:p>` element in order and extract:

### Name
The first paragraph that is large, bold, and centered (look for `<w:b/>` and `<w:jc w:val="center"/>` and a font size of 28+ half-points). Strip `<w:t>` text content.

### Contact line
The second paragraph — strip all `<w:t>` text content, joining runs, ignoring hyperlink structure.

### Paragraph count
Count every `<w:p>` element in `<w:body>`. This is the number that must stay fixed after edits.

### Bullet numbering ID
Find the first paragraph that has `<w:numPr>`. Extract the value from `<w:numId w:val="X"/>`. All bullet paragraphs use this same value.

### Sections and bullets
Walk all paragraphs in order. Identify:

- **Section headers**: paragraphs that are ALL_CAPS, bold, and have no `<w:numPr>` — these are section labels (e.g. `PRODUCTBOARD`, `PINN INVESTMENTS`)
- **Bullet paragraphs**: paragraphs that have `<w:numPr>` — strip all `<w:t>` text content, joining runs into a single string
- **Summary paragraph**: the first substantial text paragraph (>50 characters) that has no `<w:numPr>` and comes after the header block (name + contact line + section dividers)

Group bullets under their nearest preceding section header.

### Identity inference
From the extracted text, infer:
- **Full name** — from the name paragraph
- **Current title** — look in the summary text or section headers for a title pattern
- **Current employer** — look for the first section header that resembles a company name (not a generic label like EDUCATION or SKILLS)
- **Degree** — look in an EDUCATION section or the summary text for degree language (MBA, BS, BA, MS, etc.)
- **Summary opener** — the first clause of the summary paragraph, up to the first comma

---

## Step 4: Present findings and confirm

Show the user everything extracted in a clean summary. Ask them to confirm or correct each item:

```
Here's what I found in your template — confirm or correct anything:

**Identity**
- Name: [extracted]
- Title: [extracted or "couldn't find — what is it?"]
- Employer: [extracted or "couldn't find — what is it?"]
- Degree: [extracted or "couldn't find — what is it?"]

**Summary opener** (fixed first clause, used in every resume):
  "[extracted first clause]"

**Template structure**
- Paragraph count: [N]
- Bullet numbering ID: [X]

**Sections found**
| Section | Display Label | Bullets found |
|---------|--------------|---------------|
| [name]  | [label]      | [N]           |
| ...     |              |               |

**Bullets extracted** (these become your baseline — used as find/replace anchors):
[SECTION NAME]
  1. [bullet text]
  2. [bullet text]
...

**Airtable field names** — I'll use these defaults unless you say otherwise:
  Resume Worthy, Project Name, Skills Used, Smaller Summary, Description, Result, Tools Used, Collaborators

Does everything look right? Correct anything above, then I'll ask for your Airtable credentials.
```

Wait for confirmation before proceeding. Apply any corrections the user gives.

---

## Step 5: Collect Airtable credentials

Ask:

> "What are your Airtable Base ID, Work Logs Table ID, and Python path? (Find Base/Table IDs in your Airtable API docs — they start with `app` and `tbl`.)"

Also ask for bullet caps per section if not obvious from context (e.g. if all sections have the same number of bullets, ask if any have special limits).

---

## Step 6: Ask for section bullet caps

For each section identified, ask the user to confirm the maximum number of bullets allowed. Suggest the count found in the template as the default, and note if any roles should have special conditions (e.g. "up to X for [role type] roles").

---

## Step 7: Write all files

### `resume_template.docx`
```bash
cp "[filename]" resume_template.docx
```

### `unpacked_template/`
```bash
rm -rf unpacked_template/
cp -r setup_temp/ unpacked_template/
```

### `references/user_config.md`
Write using the confirmed values. Use the structure of the existing `references/user_config.md` as the format — replace all values with the user's.

For the summary opener, include both the plain variant and the startup variant (with employer stage appended) if the user has one, or note it as a placeholder.

For the sections table, include one row per section with: display label, XML section name, bullet cap, and any special conditions noted.

### `references/template-strings.md`
Write using the extracted bullets, organized by section. Each bullet becomes a find/replace string. Use the same format as the existing file — section label, then the full bullet text in a code block.

Include the summary paragraph as the first entry.

### `.env`
```
AIRTABLE_BASE_ID=[value]
WORKLOGS_TABLE_ID=[value]
PYTHON_PATH=[value]
```

---

## Step 8: Clean up and confirm

```bash
rm -rf setup_temp/
```

Tell the user:

> "Setup complete. Your template, config, and baseline bullets are all saved. Run `/resume-optimizer` and paste a job description to generate your first resume."

---

## Notes

- Never modify `resume_template.docx` before copying — the copy is the working template
- If the user's template has no clear summary paragraph, note it and leave the summary entry in `template-strings.md` as a placeholder they should fill in
- If bullet numbering IDs vary across sections, note each one and record all values in `user_config.md`
- The only things that require user input are: corrections to extracted values, Airtable credentials, and bullet caps — everything else comes from the template
