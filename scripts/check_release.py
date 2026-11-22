#!/usr/bin/env python3
# SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
"""Check release-critical licensing and publication files."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
errors = []
license_path = ROOT / "LICENSE"
if not license_path.is_file():
    errors.append("Root LICENSE file is missing")
else:
    text = " ".join(license_path.read_text(encoding="utf-8").split())
    for phrase in (
        "COMMERCIAL PRODUCTION ARE EXPRESSLY PROHIBITED",
        "ABSOLUTE PROHIBITION ON COMMERCIAL USE AND PRODUCTION",
        "Commercial Production",
        "Commercial Purpose",
        "All rights not expressly granted in Section 2 are reserved",
    ):
        if phrase not in text:
            errors.append(f"LICENSE is missing required restriction text: {phrase}")

required = [
    "README.md", "LICENSE", "LICENSE-STATUS.md", "CONTRIBUTING.md",
    "THIRD_PARTY_NOTICES.md", "GITHUB_PUBLISHING.md", "CITATION.cff",
    "docs/VERIFICATION_STATUS.md", "docs/RELEASE_CHECKLIST.md",
    ".github/workflows/ci.yml",
]
for rel in required:
    if not (ROOT / rel).is_file():
        errors.append(f"Required release file missing: {rel}")

# Core authored sources must carry the repository's explicit custom-license identifier.
spdx = "SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0"
source_roots = ("rtl", "sim", "tests", "sw", "scripts", "kicad", "vivado")
source_suffixes = {".sv", ".py", ".c", ".h", ".tcl", ".xdc", ".sh"}
for root_name in source_roots:
    root = ROOT / root_name
    if not root.exists():
        continue
    for source in root.rglob("*"):
        if source.is_file() and source.suffix in source_suffixes:
            if spdx not in source.read_text(encoding="utf-8"):
                errors.append(f"Missing SPDX custom-license header: {source.relative_to(ROOT)}")

for p in ROOT.rglob("*.md"):
    if any(part in {".git", ".venv", "sim/build"} for part in p.parts):
        continue
    if p.name in {"README_TR.md", "RUN_KALI.md", "RELEASE_SUMMARY_TR.md", "README_TR.txt", "REV3_CHANGELOG_TR.md"}:
        errors.append(f"Non-English legacy documentation file remains: {p.relative_to(ROOT)}")

if errors:
    print("Release check: FAIL")
    for error in errors:
        print(f" - {error}")
    sys.exit(1)
print("Release check: PASS")
print("Custom non-commercial/no-production license and GitHub handoff files found.")
