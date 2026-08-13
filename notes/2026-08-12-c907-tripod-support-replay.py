#!/usr/bin/env python3
"""Exact, dependency-free replay for the C907 product-of-tripods support data.

Run from the repository root:
  nix shell nixpkgs#python3 --command python3 \
    notes/2026-08-12-c907-tripod-support-replay.py --write
  nix shell nixpkgs#python3 --command python3 \
    notes/2026-08-12-c907-tripod-support-replay.py --check

The calculation is deliberately support-level only.  It does not model the
nonmonomial pair-of-pants overlap ideals or any collar topology.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-12-c907-tripod-support-replay.json"
CHECKSUM = HERE / "2026-08-12-c907-tripod-support-replay.sha256"
SCHEMA_VERSION = 1
VERTICES = ("g", "0", "1", "infinity")
RAY_PARAMETERS = {"0": "beta", "1": "beta", "infinity": "beta"}


@dataclass(frozen=True)
class Form:
    """An integral affine form in p_1,p_2,p_3,beta,gamma."""

    constant: int = 0
    p1: int = 0
    p2: int = 0
    p3: int = 0
    beta: int = 0
    gamma: int = 0

    def __add__(self, other: "Form") -> "Form":
        return Form(*(a + b for a, b in zip(self.coefficients(), other.coefficients())))

    def coefficients(self) -> tuple[int, int, int, int, int, int]:
        return (self.constant, self.p1, self.p2, self.p3, self.beta, self.gamma)

    def render(self) -> str:
        names = ("p1", "p2", "p3", "beta", "gamma")
        pieces: list[str] = []
        if self.constant:
            pieces.append(str(self.constant))
        for coefficient, name in zip(self.coefficients()[1:], names):
            if coefficient == 1:
                pieces.append(name)
            elif coefficient == -1:
                pieces.append("-" + name)
            elif coefficient:
                pieces.append(f"{coefficient}{name}")
        if not pieces:
            return "0"
        result = pieces[0]
        for piece in pieces[1:]:
            result += piece if piece.startswith("-") else "+" + piece
        return result


ZERO = Form()
P1 = Form(p1=1)
P2 = Form(p2=1)
P3 = Form(p3=1)
NEG_P = Form(p1=-1, p2=-1, p3=-1)

# The six weights in (6) of 2026-08-12-c907-tripod-common-prefan.md.
UNIVERSAL = {
    "zero": ZERO,
    "p1": P1,
    "p2": P2,
    "p3": P3,
    "polar": NEG_P,
    "constant": Form(constant=2),
}


def tripod_valuation(vertex: str, parameter: str) -> tuple[int, int]:
    """Coefficients of (v(B), v(U)) or (v(C), v(V)) on a tripod stratum."""

    if vertex == "g":
        return (0, 0)
    if vertex == "0":
        return (1, 0)
    if vertex == "1":
        return (0, 1)
    if vertex == "infinity":
        return (-1, -1)
    raise ValueError(f"unknown tripod vertex {vertex!r}")


def restriction(left: str, right: str) -> dict[str, Form]:
    rb, sb = tripod_valuation(left, "beta")
    rc, sc = tripod_valuation(right, "gamma")
    return {
        "zero": UNIVERSAL["zero"],
        "p1": UNIVERSAL["p1"],
        "p2": UNIVERSAL["p2"],
        "p3": UNIVERSAL["p3"],
        "polar": UNIVERSAL["polar"] + Form(beta=rb, gamma=rc),
        "constant": UNIVERSAL["constant"] + Form(beta=-sb, gamma=-sc),
    }


def canonical_pair(left: str, right: str) -> tuple[str, str]:
    return min((left, right), (right, left), key=lambda pair: tuple(VERTICES.index(x) for x in pair))


# These are the literal local max lists (up to the explicitly recorded
# redundant universal zero form) from the named reports.  The keys use the
# canonical B <-> C representative.
LOCAL_REPORTS = {
    ("g", "g"): ("2026-08-12-c907-bunit-cunit-generic-star.md", ("constant", "p1", "p2", "p3", "polar"), "constant_positive"),
    ("g", "0"): ("2026-08-12-c907-b0-cunit-star-fan.md", ("constant", "p1", "p2", "p3", "polar"), "constant_positive"),
    ("g", "1"): ("2026-08-12-c907-b1-cunit-star-fan.md", ("p1", "p2", "p3", "polar", "constant"), "max_pi_or_minus_p"),
    ("g", "infinity"): ("2026-08-12-c907-binf-cunit-star-fan.md", ("constant", "p1", "p2", "p3", "polar"), "constant_positive"),
    ("0", "0"): ("2026-08-12-c907-bc00-star-fan.md", ("constant", "p1", "p2", "p3", "polar"), "constant_positive"),
    ("0", "1"): ("2026-08-12-c907-b1-c0-seam-star-fan.md", ("p1", "p2", "p3", "polar", "constant"), "translated_polar_positive"),
    ("0", "infinity"): ("2026-08-12-c907-b0-cinf-seam-star-fan.md", ("constant", "p1", "p2", "p3", "polar"), "constant_positive"),
    ("1", "1"): ("2026-08-12-c907-joint-y-rees-infinity-fan.md", ("zero", "p1", "p2", "p3", "polar", "constant"), "none"),
    ("1", "infinity"): ("2026-08-12-c907-b1-cinf-seam-star-fan.md", ("zero", "p1", "p2", "p3", "polar", "constant"), "none"),
    ("infinity", "infinity"): ("2026-08-12-c907-binf-cinf-star-fan.md", ("constant", "p1", "p2", "p3", "polar"), "constant_positive"),
}


def prove_zero_redundant(rule: str, forms: dict[str, Form]) -> str:
    """Return an exact elementary certificate for omitting the zero weight."""

    if rule == "none":
        return "zero is retained in the reported max list"
    if rule == "constant_positive":
        constant = forms["constant"]
        # Here its beta/gamma coefficients are nonnegative and its constant is 2.
        if constant.constant != 2 or constant.beta < 0 or constant.gamma < 0:
            raise AssertionError("claimed positive constant form is not positive on its ray cone")
        return "constant >= 2 because beta,gamma > 0 on their selected rays"
    if rule == "max_pi_or_minus_p":
        if forms["polar"] != NEG_P:
            raise AssertionError("wrong polar form for max(p_i,-p) certificate")
        return "max(p1,p2,p3,-p1-p2-p3) >= 0"
    if rule == "translated_polar_positive":
        polar = forms["polar"]
        if (polar.beta, polar.gamma) not in {(1, 0), (0, 1)}:
            raise AssertionError("wrong translated polar form")
        return "if all p_i < 0 then the positive translated ray parameter minus p is > 0; otherwise some p_i >= 0"
    raise AssertionError(f"unknown redundancy rule {rule}")


def forms_as_strings(forms: dict[str, Form], labels: Iterable[str]) -> list[str]:
    return [forms[label].render() for label in labels]


def ordered_record(left: str, right: str) -> dict[str, object]:
    key = canonical_pair(left, right)
    report, local_labels, redundancy_rule = LOCAL_REPORTS[key]
    forms = restriction(left, right)
    # For a swapped ordered representative, beta and gamma exchange; this is
    # precisely the literal B <-> C involution in the local atlas.
    if (left, right) != key:
        swapped = restriction(right, left)
        if {name: form.coefficients() for name, form in forms.items()} != {
            name: Form(form.constant, form.p1, form.p2, form.p3, form.gamma, form.beta).coefficients()
            for name, form in swapped.items()
        }:
            raise AssertionError("B <-> C did not exchange beta and gamma")
    local_set = set(local_labels)
    if not local_set.issubset(forms):
        raise AssertionError("local list contains a non-universal form")
    omitted = set(forms) - local_set
    expected_omitted = set() if redundancy_rule == "none" else {"zero"}
    if omitted != expected_omitted:
        raise AssertionError(f"unexpected omitted weights on {(left, right)}: {omitted}")
    certificate = prove_zero_redundant(redundancy_rule, forms)
    return {
        "ordered_type": [left, right],
        "unordered_orbit": list(key),
        "local_report": report,
        "restricted_universal_weights": {label: forms[label].render() for label in UNIVERSAL},
        "local_max_forms": forms_as_strings(forms, local_labels),
        "omitted_redundant_weights": sorted(omitted),
        "redundancy_certificate": certificate,
    }


def quotient_edges() -> list[dict[str, list[str]]]:
    raw_edges: set[tuple[tuple[str, str], tuple[str, str]]] = set()
    for other in VERTICES:
        for ray in VERTICES[1:]:
            raw_edges.add((canonical_pair("g", other), canonical_pair(ray, other)))
            raw_edges.add((canonical_pair(other, "g"), canonical_pair(other, ray)))
    # The two constructions above deliberately overlap; quotient and sort them.
    result = sorted(raw_edges, key=lambda edge: (tuple(VERTICES.index(x) for x in edge[0]), tuple(VERTICES.index(x) for x in edge[1])))
    return [{"from": list(source), "to": list(target)} for source, target in result]


EXPECTED_HASSE = {
    (("g", "g"), ("g", "0")), (("g", "g"), ("g", "1")), (("g", "g"), ("g", "infinity")),
    (("g", "0"), ("0", "0")), (("g", "0"), ("0", "1")), (("g", "0"), ("0", "infinity")),
    (("g", "1"), ("0", "1")), (("g", "1"), ("1", "1")), (("g", "1"), ("1", "infinity")),
    (("g", "infinity"), ("0", "infinity")), (("g", "infinity"), ("1", "infinity")), (("g", "infinity"), ("infinity", "infinity")),
}


def build_certificate() -> dict[str, object]:
    ordered = [ordered_record(left, right) for left, right in itertools.product(VERTICES, repeat=2)]
    unordered = sorted({tuple(record["unordered_orbit"]) for record in ordered}, key=lambda pair: tuple(VERTICES.index(x) for x in pair))
    edges = quotient_edges()
    edge_set = {(tuple(edge["from"]), tuple(edge["to"])) for edge in edges}
    if edge_set != EXPECTED_HASSE:
        raise AssertionError("quotient Hasse edges differ from equation (9)")
    if len(ordered) != 16 or len(unordered) != 10 or len(edges) != 12:
        raise AssertionError("tripod orbit or Hasse count failed")
    return {
        "schema_version": SCHEMA_VERSION,
        "scope": "finite support subdivision only; normalized graph/Fitting overlaps and collars are excluded",
        "universal_support_weights": {label: form.render() for label, form in UNIVERSAL.items()},
        "tripod": {
            "vertices": list(VERTICES),
            "rays": {"0": [1, 0], "1": [0, 1], "infinity": [-1, -1]},
            "ordered_strata": ordered,
            "unordered_orbit_types": [list(pair) for pair in unordered],
            "unordered_hasse_edges": edges,
        },
        "checks": {
            "ordered_type_count": len(ordered),
            "unordered_orbit_type_count": len(unordered),
            "unordered_hasse_edge_count": len(edges),
            "all_six_weights_restricted_on_every_ordered_type": True,
            "all_local_max_lists_match_up_to_recorded_dominated_forms": True,
        },
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode("utf-8")


def checksum_bytes(certificate_bytes: bytes) -> bytes:
    script_digest = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    output_digest = hashlib.sha256(certificate_bytes).hexdigest()
    return (
        f"{script_digest}  {Path(__file__).name}\n"
        f"{output_digest}  {OUTPUT.name}\n"
    ).encode("ascii")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true", help="regenerate the tracked JSON certificate")
    mode.add_argument("--check", action="store_true", help="compare a fresh certificate with the tracked JSON")
    args = parser.parse_args()
    data = canonical_bytes(build_certificate())
    digest = hashlib.sha256(data).hexdigest()
    if args.write:
        OUTPUT.write_bytes(data)
        CHECKSUM.write_bytes(checksum_bytes(data))
        print(f"wrote {OUTPUT.name}: {len(data)} bytes sha256={digest}; refreshed {CHECKSUM.name}")
        return 0
    if not OUTPUT.is_file() or not CHECKSUM.is_file():
        print("missing tracked certificate or checksum manifest", file=sys.stderr)
        return 1
    if OUTPUT.read_bytes() != data:
        print("certificate drift: rerun with --write after reviewing the source change", file=sys.stderr)
        return 1
    if CHECKSUM.read_bytes() != checksum_bytes(data):
        print("checksum drift: rerun with --write after reviewing the source change", file=sys.stderr)
        return 1
    print(f"ok {OUTPUT.name}: {len(data)} bytes sha256={digest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
