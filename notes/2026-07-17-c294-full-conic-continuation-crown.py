#!/usr/bin/env python3
"""Replay the finite checks for the C294 full-PGL mirror family.

The proof in the companion report is uniform.  This checker independently verifies
all coordinate identities and enumerates the generated projective matrix group for
the eligible primes at most 110.
"""

from __future__ import annotations

import argparse
import json
from collections import deque
from itertools import combinations
from pathlib import Path


STEM = "2026-07-17-c294-full-conic-continuation-crown"
CENTRES = ((0, 1), (-1, 0), (1, 3), (-3, -1))
TAU = (0, -1, 1, 0)  # t |-> -1/t


def is_prime(n: int) -> bool:
    if n < 2:
        return False
    d = 2
    while d * d <= n:
        if n % d == 0:
            return n == d
        d += 1
    return True


def legendre(a: int, p: int) -> int:
    z = pow(a % p, (p - 1) // 2, p)
    return -1 if z == p - 1 else z


def mat_mul(x: tuple[int, ...], y: tuple[int, ...], p: int) -> tuple[int, ...]:
    a, b, c, d = x
    e, f, g, h = y
    return ((a * e + b * g) % p, (a * f + b * h) % p,
            (c * e + d * g) % p, (c * f + d * h) % p)


def mat_normalize(x: tuple[int, ...], p: int) -> tuple[int, ...]:
    for entry in x:
        if entry % p:
            scale = pow(entry % p, p - 2, p)
            return tuple((scale * y) % p for y in x)
    raise AssertionError("zero matrix")


def projective_group_order(gens: list[tuple[int, ...]], p: int) -> int:
    gens = [mat_normalize(g, p) for g in gens]
    identity = (1, 0, 0, 1)
    seen = {identity}
    todo = deque([identity])
    while todo:
        h = todo.popleft()
        for g in gens:
            z = mat_normalize(mat_mul(g, h, p), p)
            if z not in seen:
                seen.add(z)
                todo.append(z)
    return len(seen)


def act(m: tuple[int, ...], t: int, p: int) -> int:
    """Act on P^1(F_p), representing infinity by p."""
    a, b, c, d = (x % p for x in m)
    if t == p:
        return p if c == 0 else a * pow(c, p - 2, p) % p
    den = (c * t + d) % p
    return p if den == 0 else (a * t + b) * pow(den, p - 2, p) % p


def conic_point(t: int, p: int) -> tuple[int, int, int]:
    if t == p:
        return (1, 0, 0)
    if t == 0:
        return (0, 1, 0)
    return (t, pow(t, p - 2, p), 1)


def det3(points: tuple[tuple[int, int, int], ...], p: int) -> int:
    a, b, c = points
    return (a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])) % p


def sigma_matrix(r: int, c: int, p: int) -> tuple[int, ...]:
    return (1, -r % p, c % p, -1 % p)


def check_case(p: int) -> dict[str, object]:
    assert p > 5 and p % 40 in (3, 27)
    assert [legendre(x, p) for x in (-1, 5, 8)] == [-1, -1, -1]

    centres = tuple((r % p, c % p, 1) for r, c in CENTRES)
    opening = ((1, 0, 0), (0, 1, 0))
    cap_dets = [det3(triple, p) for triple in combinations(opening + centres, 3)]
    assert all(cap_dets)

    gens = [sigma_matrix(r, c, p) for r, c in CENTRES]
    conjugate_indices = []
    tau_perm = tuple(act(TAU, t, p) for t in range(p + 1))
    assert all(tau_perm[tau_perm[t]] == t for t in range(p + 1))
    assert all(tau_perm[t] != t for t in range(p + 1))
    for g in gens:
        conjugate = tuple(tau_perm[act(g, tau_perm[t], p)] for t in range(p + 1))
        conjugate_indices.append(next(i for i, h in enumerate(gens)
                                      if conjugate == tuple(act(h, t, p) for t in range(p + 1))))

    dead: set[int] = set()
    for u, v in combinations(centres, 2):
        for t in range(p + 1):
            if det3((u, v, conic_point(t, p)), p) == 0:
                dead.add(t)
    live = set(range(p + 1)) - dead
    assert {tau_perm[t] for t in dead} == dead
    adjacency = {t: {act(g, t, p) for g in gens} - {t} for t in live}
    adjacency = {t: (neighbors & live) for t, neighbors in adjacency.items()}
    assert all(tau_perm[t] in live and tau_perm[t] not in adjacency[t] for t in live)
    assert all({tau_perm[u] for u in adjacency[t]} == adjacency[tau_perm[t]] for t in live)

    word = [2, 0, 2, 0, 1, 0]
    unipotent = (1, 0, 0, 1)
    for i in word:
        unipotent = mat_mul(unipotent, gens[i], p)
    assert unipotent == tuple(x % p for x in (3, -1, 1, 1))
    a, b, c, d = unipotent
    assert (a + d) ** 2 % p == 4 * (a * d - b * c) % p
    assert mat_normalize(unipotent, p) != (1, 0, 0, 1)

    order = projective_group_order(gens, p)
    expected = p * (p * p - 1)
    assert order == expected
    return {
        "p": p,
        "cap_triples_checked": len(cap_dets),
        "conjugation_on_generators": conjugate_indices,
        "dead_conic_vertices": len(dead),
        "generated_group_order": order,
        "live_conic_vertices": len(live),
        "mirror_pairs": len(live) // 2,
        "nonsquare_tests": {"-1": -1, "5": -1, "8": -1},
        "pgl2_order": expected,
        "unipotent_word": word,
    }


def generate() -> dict[str, object]:
    primes = [p for p in range(7, 111) if is_prime(p) and p % 40 in (3, 27)]
    return {
        "cases": [check_case(p) for p in primes],
        "family": {
            "centres": [list(x) for x in CENTRES],
            "prime_condition": "p > 5 and p mod 40 in {3,27}",
            "residual_outcome": "P by fixed-point-free nonadjacent tau pairing",
            "tau": "t -> -1/t",
        },
        "schema": "c294-full-pgl-mirror-family-v1",
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = generate()
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check:
        tracked = json.loads(Path(__file__).with_suffix(".json").read_text())
        if tracked != result:
            raise SystemExit("tracked JSON content differs from deterministic regeneration")
        print(f"OK: {len(result['cases'])} prime cases; tracked JSON content matches")
    else:
        print(rendered, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
