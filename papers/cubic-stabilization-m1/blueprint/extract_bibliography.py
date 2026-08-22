#!/usr/bin/env python3
"""Extract the manuscript's manual bibliography for the web blueprint."""

from pathlib import Path
import sys


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: extract_bibliography.py MANUSCRIPT OUTPUT")

    manuscript = Path(sys.argv[1])
    output = Path(sys.argv[2])
    source = manuscript.read_text(encoding="utf-8")
    opening = r"\begin{thebibliography}"
    closing = r"\end{thebibliography}"

    if source.count(opening) != 1 or source.count(closing) != 1:
        raise SystemExit("expected exactly one manual bibliography block")

    start = source.index(opening)
    start = source.rfind("\n", 0, start) + 1
    end = source.index(closing, start) + len(closing)
    bibliography = source[start:end] + "\n"

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(bibliography, encoding="utf-8")


if __name__ == "__main__":
    main()
