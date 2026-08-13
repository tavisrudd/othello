#!/usr/bin/env python3
"""Exact base-initial nonvanishing replay for the C907 tripod refinement.

This checks the flat-base portion of a proposed full-initial attachment.  It
does not construct a regular modification or compute exceptional orders.
"""
from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
INPUT = HERE / "2026-08-12-c907-tripod-hyperplane-refinement.json"
OUT = HERE / "2026-08-12-c907-pair-of-pants-initial-nonvanishing.json"
SUM = HERE / "2026-08-12-c907-pair-of-pants-initial-nonvanishing.sha256"
VARS = ("L", "x1", "x2", "x3", "b", "c", "Q")
INDEX = {name: i for i, name in enumerate(VARS)}
ZERO = tuple(0 for _ in VARS)
Poly = dict[tuple[int, ...], int]


def clean(poly: Poly) -> Poly:
    return {e: n for e, n in poly.items() if n}


def add(*polys: Poly) -> Poly:
    out: Poly = {}
    for poly in polys:
        for e, n in poly.items():
            out[e] = out.get(e, 0) + n
    return clean(out)


def scale(poly: Poly, n: int) -> Poly:
    return clean({e: n * a for e, a in poly.items()})


def mul(*polys: Poly) -> Poly:
    out: Poly = {ZERO: 1}
    for poly in polys:
        nxt: Poly = {}
        for e, a in out.items():
            for f, b in poly.items():
                g = tuple(x + y for x, y in zip(e, f))
                nxt[g] = nxt.get(g, 0) + a * b
        out = clean(nxt)
    return out


def one() -> Poly:
    return {ZERO: 1}


def variable(name: str) -> Poly:
    exponent = list(ZERO)
    exponent[INDEX[name]] = 1
    return {tuple(exponent): 1}


def state_forms(state: str, coordinate: str) -> tuple[Poly, Poly, str]:
    """Return leading B,U (or C,V) forms after eliminating its linear initial."""
    v = variable(coordinate)
    left, marked = ("B", "U") if coordinate == "b" else ("C", "V")
    if state == "g":
        return v, add(one(), scale(v, -1)), f"{left}={coordinate}, {marked}=1-{coordinate} ({left}+{marked}-1=0)"
    if state == "0":
        return v, one(), f"{left}={coordinate}, {marked}=1 ({marked}-1=0)"
    if state == "1":
        return one(), v, f"{left}=1, {marked}={coordinate} ({left}-1=0)"
    if state == "infinity":
        return v, scale(v, -1), f"{left}={coordinate}, {marked}=-{coordinate} ({left}+{marked}=0)"
    raise ValueError(state)


def max_mask(signs: str) -> str:
    pairs = list(itertools.combinations(range(6), 2))
    maxima: list[str] = []
    for weight in range(6):
        maximum = True
        for index, (left, right) in enumerate(pairs):
            if weight == left and signs[index] == "-":
                maximum = False
            if weight == right and signs[index] == "+":
                maximum = False
        if maximum:
            maxima.append(str(weight))
    if not maxima:
        raise RuntimeError("a refinement sign vector has no upper-envelope term")
    return "".join(maxima)


def graph_normal_form(a: str, b: str, mask: str) -> Poly:
    """Clear X*B*C in L-sum(x_i)-Q/(XBC)-UV, then restrict to the base initial."""
    B, U, _ = state_forms(a, "b")
    C, V, _ = state_forms(b, "c")
    X = mul(variable("x1"), variable("x2"), variable("x3"))
    D = mul(X, B, C)
    terms = {
        "0": mul(D, variable("L")),
        "1": scale(mul(D, variable("x1")), -1),
        "2": scale(mul(D, variable("x2")), -1),
        "3": scale(mul(D, variable("x3")), -1),
        "4": scale(variable("Q"), -1),
        "5": scale(mul(D, U, V), -1),
    }
    return add(*(terms[index] for index in mask))


def render(poly: Poly) -> str:
    if not poly:
        return "0"
    pieces: list[str] = []
    ordered = sorted(poly, key=lambda e: (sum(e), e), reverse=True)
    for position, exponent in enumerate(ordered):
        coefficient = poly[exponent]
        monomial = "*".join(
            name if power == 1 else f"{name}^{power}"
            for name, power in zip(VARS, exponent) if power
        ) or "1"
        if monomial == "1":
            body = str(abs(coefficient))
        elif abs(coefficient) == 1:
            body = monomial
        else:
            body = f"{abs(coefficient)}*{monomial}"
        if position == 0:
            pieces.append(("-" if coefficient < 0 else "") + body)
        else:
            pieces.append((" - " if coefficient < 0 else " + ") + body)
    return "".join(pieces)


def encode() -> dict:
    data = json.loads(INPUT.read_text())
    records = []
    total_cells = 0
    total_masks = 0
    generic_generic_masks: set[str] = set()
    l_masks_by_type: dict[tuple[str, str], set[str]] = {}
    for cone in data["cones"]:
        a, b = cone["ordered_type"]
        observed: dict[str, int] = {}
        for cells in cone["slice_faces"].values():
            for cell in cells:
                mask = max_mask(cell["signs"])
                observed[mask] = observed.get(mask, 0) + 1
        stated = cone["upper_envelope"]["maximal_weight_tie_masks"]
        if observed != stated:
            raise RuntimeError(f"upper-envelope drift at {a},{b}")
        if (a, b) == ("g", "g"):
            generic_generic_masks = set(observed)
        l_masks_by_type[(a, b)] = {mask for mask in observed if "0" in mask}
        checked = []
        for mask in sorted(observed, key=lambda value: (len(value), value)):
            normal = graph_normal_form(a, b, mask)
            if not normal:
                raise RuntimeError(f"base initial cancellation at {a},{b}, mask {mask}")
            q_terms = [e for e in normal if e[INDEX["Q"]]]
            if ("4" in mask) != bool(q_terms) or any(e[INDEX["Q"]] != 1 for e in q_terms):
                raise RuntimeError(f"Q-specialization ambiguity at {a},{b}, mask {mask}")
            if len(q_terms) > 1:
                raise RuntimeError(f"unexpected Q cancellation at {a},{b}, mask {mask}")
            checked.append({"mask": mask, "cleared_normal_form": render(normal)})
        B, U, relB = state_forms(a, "b")
        C, V, relC = state_forms(b, "c")
        assert B and U and C and V
        count = sum(observed.values())
        records.append({
            "ordered_type": [a, b],
            "base_initials_after_elimination": [relB, relC],
            "cell_count": count,
            "mask_count": len(checked),
            "checked_masks": checked,
        })
        total_cells += count
        total_masks += len(checked)
    if total_cells != 81367 or total_masks != 552:
        raise RuntimeError(f"unexpected refinement totals: cells={total_cells}, masks={total_masks}")
    if any(set("12345") <= set(mask) and "0" not in mask for mask in generic_generic_masks):
        raise RuntimeError("generic/generic five-term mask occurs without the L term")
    full_pair = {"01234", "012345"}
    full_power = {"0" + "".join(str(i) for i in range(1, 6) if bits & (1 << (i - 1)))
                  for bits in range(32)}
    expected_l_masks = {
        ("g", "1"): full_pair, ("1", "g"): full_pair,
        ("0", "1"): full_pair, ("1", "0"): full_pair,
        ("1", "1"): full_pair,
        ("1", "infinity"): full_power, ("infinity", "1"): full_power,
    }
    if {key: value for key, value in l_masks_by_type.items() if value} != expected_l_masks:
        raise RuntimeError("order-zero/L-mask classification drift")
    return {
        "schema_version": 1,
        "input": {"file": INPUT.name, "sha256": hashlib.sha256(INPUT.read_bytes()).hexdigest()},
        "ring": "Z[Q,L,x1,x2,x3,b,c]; Q is an indeterminate and the residue coordinates are subsequently localized",
        "graph_convention": "clear X*B*C in L-(x1+x2+x3)-Q/(XBC)-UV",
        "base_convention": "g uses B+U-1; 0 uses U-1; 1 uses B-1; infinity uses B+U, followed by the displayed elimination",
        "checks": {
            "all_81367_serialized_cells_recompute_their_stored_upper_envelope_mask": True,
            "all_552_realized_type_mask_pairs_have_nonzero_cleared_base_initial": True,
            "every_Q_term_is_the_unique_linear_term_-Q_so_nonvanishing_survives_Q_in_k_star": True,
            "base_initial_fibres_are_linear_integral_domains_before_residue_localization": True,
            "generic_generic_five_term_mask_without_L_is_infeasible": True,
            "all_L_masks_have_the_seven_certified_order_zero_types": True,
        },
        "records": records,
    }


def canonical(data: dict) -> bytes:
    return (json.dumps(data, sort_keys=True, separators=(",", ":")) + "\n").encode()


def sums(data: bytes) -> bytes:
    return (
        f"{hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}  {Path(__file__).name}\n"
        f"{hashlib.sha256(data).hexdigest()}  {OUT.name}\n"
    ).encode()


def main() -> int:
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--write", action="store_true")
    group.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = canonical(encode())
    if args.write:
        OUT.write_bytes(result)
        SUM.write_bytes(sums(result))
        print(f"wrote {OUT.name}: {len(result)} bytes")
        return 0
    if not OUT.exists() or not SUM.exists() or OUT.read_bytes() != result or SUM.read_bytes() != sums(result):
        print("initial-nonvanishing certificate drift", file=sys.stderr)
        return 1
    print(f"ok {OUT.name}: {len(result)} bytes sha256={hashlib.sha256(result).hexdigest()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
