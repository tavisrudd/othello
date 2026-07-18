#!/usr/bin/env python3
"""C151: allowed-mask cardinality spectrum of the 1,189 canonical Q25 residual classes.

The tracked `Q25RowCompositionData` tree stores, per canonical class, an `OrbitMask` of
orbit codes proved legal by that class's `RowCompositionCertificate`.  The certificate's
`card_le` field currently asserts only `32 <= (maskOrbitSet allowed).card`, so the mask's
actual cardinality is not visible to any Lean statement.

This script reads that cardinality straight out of the tracked Lean sources and reports the
spectrum, and in particular which classes attain 32.  Because the mask is a *subset* of the
legal orbit set, a mask cardinality of `n` certifies `n <= legalOrbitSet.card`; it does not
certify equality except where equality is separately checked (the five minimizer rows).

That asymmetry is exactly what the exhaustion step needs: a class whose mask already has at
least 33 elements cannot attain the minimum 32, and the mask proving it is already tracked.

Independent cross-check: the canonical residual-cover CSV produced by the C151 generator
carries a `legal` count per canonical class, derived without reference to the Lean sources.
The CSV lives in a local cache and is not tracked; when it is absent the cross-check is
skipped and the JSON records that explicitly.

Usage, from /home/tavis/src/othello:

    python3 notes/2026-07-18-c151-minimum-mask-spectrum.py \
      --write notes/2026-07-18-c151-minimum-mask-spectrum.json
    python3 notes/2026-07-18-c151-minimum-mask-spectrum.py \
      --check notes/2026-07-18-c151-minimum-mask-spectrum.json
"""

from __future__ import annotations

import argparse
import collections
import csv
import hashlib
import json
import pathlib
import re
import sys

SCHEMA_VERSION = 3

COMPOSITION_DIR = pathlib.Path("lean/RelativeConicArcs/Q25RowCompositionData")
DEFAULT_CSV = pathlib.Path("/home/tavis/.cache/c151-residual-cover.csv")

EXPECTED_CLASSES = 1189
EXPECTED_MASK_WORDS = 5
MINIMUM_CARD = 32

MASK_RE = re.compile(r"def class(\d+)Allowed[^!]*!\[([0-9,\s]+)\]", re.S)


def fail(message: str) -> None:
    raise SystemExit(f"schema drift: {message}")


def parse_masks(root: pathlib.Path) -> dict[int, list[int]]:
    """Read every `classNNNNAllowed` bitmask out of the tracked composition leaves."""
    masks: dict[int, list[int]] = {}
    files = sorted(root.glob("C_*.lean"))
    if not files:
        fail(f"no composition leaves under {root}")
    for path in files:
        for match in MASK_RE.finditer(path.read_text()):
            index = int(match.group(1))
            words = [int(w) for w in match.group(2).split(",") if w.strip()]
            if len(words) != EXPECTED_MASK_WORDS:
                fail(f"class {index} has {len(words)} mask words")
            if index in masks:
                fail(f"class {index} defined twice")
            masks[index] = words
    if len(masks) != EXPECTED_CLASSES:
        fail(f"parsed {len(masks)} classes, expected {EXPECTED_CLASSES}")
    if sorted(masks) != list(range(EXPECTED_CLASSES)):
        fail("class indices are not exactly 0..1188")
    return masks


def popcount(words: list[int]) -> int:
    return sum(bin(w).count("1") for w in words)


def mask_stream_digest(masks: dict[int, list[int]]) -> str:
    """Canonical digest over the parsed mask stream, independent of file layout."""
    digest = hashlib.sha256()
    for index in sorted(masks):
        digest.update(f"{index}:{','.join(map(str, masks[index]))}\n".encode())
    return digest.hexdigest()


def csv_legal_counts(path: pathlib.Path) -> dict[int, int]:
    """Legal counts per canonical class from the generator CSV, checked for consistency."""
    counts: dict[int, int] = {}
    with path.open(newline="") as handle:
        for row in csv.DictReader(handle):
            index = int(row["class_index"])
            if index < 0:
                continue
            legal = int(row["legal"])
            if legal < 0:
                continue
            if index in counts and counts[index] != legal:
                fail(f"CSV class {index} carries legal counts {counts[index]} and {legal}")
            counts[index] = legal
    return counts


def sha256_file(path: pathlib.Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build_record(root: pathlib.Path, csv_path: pathlib.Path) -> dict:
    masks = parse_masks(root)
    cards = {index: popcount(words) for index, words in masks.items()}

    spectrum = collections.Counter(cards.values())
    minimum_classes = sorted(i for i, c in cards.items() if c == MINIMUM_CARD)
    below = sorted(i for i, c in cards.items() if c < MINIMUM_CARD)
    if below:
        fail(f"classes below the certified bound {MINIMUM_CARD}: {below}")

    record = {
        "schema_version": SCHEMA_VERSION,
        "source_tree": str(root),
        "class_count": len(cards),
        "mask_words_per_class": EXPECTED_MASK_WORDS,
        "mask_stream_sha256": mask_stream_digest(masks),
        "minimum_card": MINIMUM_CARD,
        "spectrum": {str(k): spectrum[k] for k in sorted(spectrum)},
        "minimum_classes": minimum_classes,
        "cardinality_by_class": [cards[i] for i in sorted(cards)],
    }

    if csv_path.exists():
        counts = csv_legal_counts(csv_path)
        missing = sorted(set(cards) - set(counts))
        mismatched = sorted(i for i in set(cards) & set(counts) if counts[i] != cards[i])
        record["cross_check"] = {
            "status": "agree" if not missing and not mismatched else "disagree",
            "source": str(csv_path),
            "sha256": sha256_file(csv_path),
            "classes_compared": len(set(cards) & set(counts)),
            "missing_classes": missing,
            "mismatched_classes": mismatched,
        }
    else:
        record["cross_check"] = {
            "status": "skipped-csv-absent",
            "source": str(csv_path),
        }
    return record


def dump(record: dict) -> str:
    return json.dumps(record, indent=2, sort_keys=True) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=pathlib.Path, default=COMPOSITION_DIR)
    parser.add_argument("--csv", type=pathlib.Path, default=DEFAULT_CSV)
    parser.add_argument("--write", type=pathlib.Path)
    parser.add_argument("--check", type=pathlib.Path)
    args = parser.parse_args()

    record = build_record(args.root, args.csv)

    if args.check:
        tracked = json.loads(args.check.read_text())
        # The CSV is an untracked cache; compare only the tracked-source-derived fields.
        volatile = {"cross_check"}
        left = {k: v for k, v in record.items() if k not in volatile}
        right = {k: v for k, v in tracked.items() if k not in volatile}
        if left != right:
            differing = sorted(k for k in set(left) | set(right) if left.get(k) != right.get(k))
            print(f"MISMATCH against {args.check}: fields {differing}", file=sys.stderr)
            return 1
        print(f"OK {args.check} matches {args.root}")
        print(f"cross-check: {record['cross_check']['status']}")
        return 0

    if args.write:
        args.write.write_text(dump(record))
        print(f"wrote {args.write}")

    spectrum = record["spectrum"]
    print(f"classes: {record['class_count']}")
    print(f"spectrum: {spectrum}")
    print(f"attaining {MINIMUM_CARD}: {record['minimum_classes']}")
    print(f"cross-check: {record['cross_check']['status']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
