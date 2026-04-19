#!/usr/bin/env bash
# Run this script whenever resume_template.docx changes.
# It re-unpacks the template and updates unpacked_template/ in the repo.
# After running, commit the updated unpacked_template/ and update
# the find/replace strings in CLAUDE.md if any bullet text changed.

set -e

PYTHON="/c/Users/aatum/AppData/Local/Programs/Python/Python312/python.exe"

echo "Refreshing unpacked_template/ from resume_template.docx..."
rm -rf unpacked_template/
PYTHONIOENCODING=utf-8 "$PYTHON" scripts/unpack.py resume_template.docx unpacked_template/
echo "Done. Commit unpacked_template/ and update CLAUDE.md if bullet text changed."
