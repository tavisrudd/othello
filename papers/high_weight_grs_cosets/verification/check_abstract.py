#!/usr/bin/env python3
"""Enforce the submission abstract's public word ceiling."""

from __future__ import annotations

import re
from pathlib import Path


ABSTRACT = Path(__file__).resolve().parents[1] / "frontmatter" / "abstract.tex"
MAX_WORDS = 200


def main() -> None:
    text = ABSTRACT.read_text(encoding="utf-8")
    words = re.findall(r"\b[\w]+(?:[-'][\w]+)*\b", text)
    if len(words) > MAX_WORDS:
        raise SystemExit(f"abstract has {len(words)} words; maximum is {MAX_WORDS}")
    print(f"abstract length: {len(words)} / {MAX_WORDS} words")


if __name__ == "__main__":
    main()
