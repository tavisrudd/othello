#!/usr/bin/env python3
"""Cross-check C624 party images against the C889 code/dual criterion."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


HERE = Path(__file__).parent
SOURCE = HERE / "2026-07-25-c624-ame-lu-party-extension-examples.json"
OUT = Path(__file__).with_suffix(".json")


def rref(rows: list[list[int]], p: int) -> tuple[list[list[int]], list[int]]:
    a = [[x % p for x in row] for row in rows]
    pivots: list[int] = []
    r = 0
    for c in range(len(a[0]) if a else 0):
        pivot = next((i for i in range(r, len(a)) if a[i][c]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        inv = pow(a[r][c], -1, p)
        a[r] = [(inv * x) % p for x in a[r]]
        for i in range(len(a)):
            if i != r and a[i][c]:
                scale = a[i][c]
                a[i] = [(x - scale * y) % p for x, y in zip(a[i], a[r])]
        pivots.append(c)
        r += 1
        if r == len(a):
            break
    return a, pivots


def nullspace(rows: list[list[int]], p: int, n: int = 6) -> list[list[int]]:
    a, pivots = rref(rows, p)
    free = [c for c in range(n) if c not in pivots]
    basis = []
    for f in free:
        v = [0] * n
        v[f] = 1
        for i, c in enumerate(pivots):
            v[c] = -a[i][f] % p
        basis.append(v)
    return basis


def rank(rows: list[list[int]], p: int) -> int:
    return len(rref(rows, p)[1])


def pencil_code(p: int, t: int) -> list[list[int]]:
    columns = (
        (0, 1, 1 - t), (0, 1, t - 1), (1, 1 - t, 0),
        (1, t - 1, 0), (1, 0, -t), (1, 0, t),
    )
    parity = [[columns[j][i] % p for j in range(6)] for i in range(3)]
    return nullspace(parity, p)


def grs_code(p: int, points: list[int]) -> list[list[int]]:
    return [[pow(x, degree, p) for x in points] for degree in range(3)]


def permute(code: list[list[int]], pi: tuple[int, ...]) -> list[list[int]]:
    return [[next(row[i] for i in range(6) if pi[i] == j) for j in range(6)] for row in code]


def multiplier_nullity(e: list[list[int]], f: list[list[int]], p: int) -> int:
    f_dual = nullspace(f, p)
    equations = [[x * y % p for x, y in zip(erow, hrow)] for erow in e for hrow in f_dual]
    return 6 - rank(equations, p)


def code_for(case: dict[str, object]) -> list[list[int]]:
    p = int(case["field_order"])
    provenance = case["provenance"]
    family = provenance["family"]
    if family == "GRS":
        return grs_code(p, provenance["evaluation_set"])
    parameter = provenance.get("parameter", provenance.get("tau"))
    return pencil_code(p, int(parameter) % p)


def generate() -> bytes:
    source_bytes = SOURCE.read_bytes()
    source = json.loads(source_bytes)
    results = []
    for case in source["cases"]:
        p = int(case["field_order"])
        code = code_for(case)
        dual = nullspace(code, p)
        predicted = []
        orientation_counts = {"code_only": 0, "dual_only": 0, "both": 0}
        for pi in itertools.permutations(range(6)):
            target = permute(code, pi)
            direct = multiplier_nullity(code, target, p) > 0
            duality = multiplier_nullity(dual, target, p) > 0
            if direct or duality:
                predicted.append(list(pi))
                orientation_counts[
                    "both" if direct and duality else "code_only" if direct else "dual_only"
                ] += 1
        actual = sorted(case["pi"]["elements"])
        if sorted(predicted) != actual:
            raise AssertionError(f"party-image mismatch in {case['name']}")
        results.append({
            "name": case["name"],
            "field_order": p,
            "party_image_order": len(actual),
            "orientation_counts": orientation_counts,
            "matches_c624": True,
        })
    payload = {
        "schema": "c889-party-image-crosscheck-v1",
        "c624_certificate_sha256": hashlib.sha256(source_bytes).hexdigest(),
        "criterion": "pi(C) is diagonally equivalent to C or C^perp",
        "permutations_checked_per_case": 720,
        "cases": results,
    }
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = generate()
    if args.check:
        if OUT.read_bytes() != data:
            raise SystemExit("tracked certificate is stale")
        print(f"ok {OUT.name} {hashlib.sha256(data).hexdigest()}")
    else:
        OUT.write_bytes(data)
        print(f"wrote {OUT.name} {hashlib.sha256(data).hexdigest()}")


if __name__ == "__main__":
    main()
