#!/usr/bin/env python3
"""Exact L-mask polar-witness replay for the C907 pair-of-pants support.

This is the symbolic reduction layer only.  It recomputes all L-containing
support masks from the exact tripod refinement and gives, for every exterior
ordered type, a tangent derivative that is a residue unit (or the excluded
value L=0).  The (1,1) residue torus is recorded separately: its closure is
the protected bounded residual Rees star and is never discharged as exterior.
"""
from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import sys
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
INPUT = HERE / "2026-08-12-c907-tripod-hyperplane-refinement.json"
OUT = HERE / "2026-08-12-c907-l-mask-coarse-polar.json"
SUM = HERE / "2026-08-12-c907-l-mask-coarse-polar.sha256"

# The six graph terms in their fixed support order are
# L, x1, x2, x3, P=Q/(x1*x2*x3*B*C), and R=U*V.
X = frozenset("123")
FULL_XP = frozenset("1234")
FULL_POWER = {
    "0" + "".join(str(i) for i in range(1, 6) if bits & (1 << (i - 1)))
    for bits in range(32)
}
FULL_FOUR = {"01234", "012345"}
EXPECTED = {
    ("g", "1"): FULL_FOUR,
    ("0", "1"): FULL_FOUR,
    ("1", "g"): FULL_FOUR,
    ("1", "0"): FULL_FOUR,
    ("1", "1"): FULL_FOUR,
    ("1", "infinity"): FULL_POWER,
    ("infinity", "1"): FULL_POWER,
}


def max_mask(signs: str) -> str:
    """Recompute the upper-envelope mask from the 15 pairwise signs."""
    pairs = list(itertools.combinations(range(6), 2))
    maximum: list[str] = []
    for weight in range(6):
        is_maximum = True
        for position, (left, right) in enumerate(pairs):
            if weight == left and signs[position] == "-":
                is_maximum = False
            if weight == right and signs[position] == "+":
                is_maximum = False
        if is_maximum:
            maximum.append(str(weight))
    if not maximum:
        raise RuntimeError("cell has no upper-envelope term")
    return "".join(maximum)


def support_l_masks(data: dict) -> tuple[dict[tuple[str, str], set[str]], int]:
    masks: dict[tuple[str, str], set[str]] = defaultdict(set)
    cells = 0
    for cone in data["cones"]:
        kind = tuple(cone["ordered_type"])
        for faces in cone["slice_faces"].values():
            for cell in faces:
                mask = max_mask(cell["signs"])
                if "0" in mask:
                    masks[kind].add(mask)
                cells += 1
    return dict(masks), cells


def witness(kind: tuple[str, str], mask: str) -> dict:
    """Return an exact polar witness in the stated localized normal model.

    The type `1` is an *auxiliary* pair-of-pants face.  Witnesses are chosen
    tangent to the genuine coarse boundary; in particular the infinity
    residue, not a nonregular derivative normal to B=1 or C=1, handles the
    full reciprocal-linear mask.
    """
    terms = frozenset(mask)
    if kind == ("g", "1"):
        if terms == frozenset("01234"):
            return {"outcome": "unit", "pivot": "dlog_b H=-P", "unit": "P"}
        if terms == frozenset("012345"):
            return {"outcome": "unit", "pivot": "partial_c H=U", "unit": "U=1-b"}
    if kind == ("0", "1"):
        if terms == frozenset("01234"):
            return {"outcome": "unit", "pivot": "dlog_b H=-P", "unit": "P"}
        if terms == frozenset("012345"):
            return {"outcome": "unit", "pivot": "partial_c H=1", "unit": "1"}
    if kind == ("1", "g"):
        if terms == frozenset("01234"):
            return {"outcome": "unit", "pivot": "dlog_c H=-P", "unit": "P"}
        if terms == frozenset("012345"):
            return {"outcome": "unit", "pivot": "partial_b H=V", "unit": "V=1-c"}
    if kind == ("1", "0"):
        if terms == frozenset("01234"):
            return {"outcome": "unit", "pivot": "dlog_c H=-P", "unit": "P"}
        if terms == frozenset("012345"):
            return {"outcome": "unit", "pivot": "partial_b H=1", "unit": "1"}
    if kind in {("1", "infinity"), ("infinity", "1")}:
        marked = "b" if kind == ("1", "infinity") else "c"
        other = "c" if marked == "b" else "b"
        if terms == frozenset("0"):
            return {"outcome": "L=0", "pivot": "H=0", "unit": "excluded in S=G_m,L"}
        if "5" in terms:
            return {
                "outcome": "unit",
                "pivot": f"partial_{marked} H=-{other}",
                "unit": other,
            }
        if "4" not in terms:
            # Some x_i occurs because the L-only case was separated above.
            index = min(terms & X)
            return {"outcome": "unit", "pivot": f"dlog_x{index} H=x{index}", "unit": f"x{index}"}
        missing = sorted(X - terms)
        if missing:
            index = missing[0]
            return {"outcome": "unit", "pivot": f"dlog_x{index} H=-P", "unit": "P"}
        if terms == frozenset("01234"):
            infinity_residue = other
            return {
                "outcome": "unit",
                "pivot": f"dlog_{infinity_residue} H=-P",
                "unit": "P",
            }
    if kind == ("1", "1"):
        if terms == frozenset("01234"):
            return {
                "outcome": "protected_open_unit",
                "pivot": "coarse_unmark d_B H=-P",
                "unit": "P",
            }
        if terms == frozenset("012345"):
            return {
                "outcome": "protected_open_unit",
                "pivot": "partial_b H=c",
                "unit": "c",
            }
    raise RuntimeError(f"no polar witness for {kind}, mask {mask}")


def encode() -> dict:
    data = json.loads(INPUT.read_text())
    l_masks, cells = support_l_masks(data)
    observed = {kind: values for kind, values in l_masks.items() if values}
    if cells != 81367:
        raise RuntimeError(f"unexpected cell count: {cells}")
    if observed != EXPECTED:
        raise RuntimeError("L-mask classification drift")
    records = []
    exterior = 0
    protected = 0
    for kind in sorted(observed):
        for mask in sorted(observed[kind], key=lambda value: (len(value), value)):
            item = {"ordered_type": list(kind), "mask": mask, **witness(kind, mask)}
            records.append(item)
            if kind == ("1", "1"):
                protected += 1
            else:
                exterior += 1
    if len(records) != 74 or exterior != 72 or protected != 2:
        raise RuntimeError(f"unexpected L-mask totals: {len(records)}, {exterior}, {protected}")
    if any(record["outcome"] not in {"unit", "L=0"} for record in records if record["ordered_type"] != ["1", "1"]):
        raise RuntimeError("an exterior L mask was not discharged")
    return {
        "schema_version": 1,
        "input": {"file": INPUT.name, "sha256": hashlib.sha256(INPUT.read_bytes()).hexdigest()},
        "support_convention": "0=L, 1..3=x_i, 4=P=Q/(x1*x2*x3*B*C), 5=R=U*V",
        "coarse_convention": "the type-1 pair-of-pants equation is auxiliary; exterior witnesses use only derivations tangent to the genuine coarse boundary",
        "localization": "all displayed x_i, P, and residue factors named unit are inverted in the relevant partial initial",
        "checks": {
            "all_81367_cells_recompute_upper_envelope_masks": True,
            "seven_order_zero_L_types_and_exact_masks": True,
            "72_exterior_L_mask_records_have_unit_or_L_zero_witness": True,
            "two_11_records_are_protected_not_exterior": True,
            "no_claim_about_11_residue_closure_or_bounded_residual_Rees_star": True,
        },
        "records": records,
    }


def canonical(data: dict) -> bytes:
    return (json.dumps(data, sort_keys=True, separators=(",", ":")) + "\n").encode()


def checksums(data: bytes) -> bytes:
    return (
        f"{hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}  {Path(__file__).name}\n"
        f"{hashlib.sha256(data).hexdigest()}  {OUT.name}\n"
    ).encode()


def main() -> int:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = canonical(encode())
    if args.write:
        OUT.write_bytes(result)
        SUM.write_bytes(checksums(result))
        print(f"wrote {OUT.name}: {len(result)} bytes")
        return 0
    if not OUT.exists() or not SUM.exists() or OUT.read_bytes() != result or SUM.read_bytes() != checksums(result):
        print("L-mask coarse-polar certificate drift", file=sys.stderr)
        return 1
    print(f"ok {OUT.name}: {len(result)} bytes sha256={hashlib.sha256(result).hexdigest()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
