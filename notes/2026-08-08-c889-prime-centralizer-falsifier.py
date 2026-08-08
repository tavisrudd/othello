#!/usr/bin/env python3
"""Exact SL(2,p) common-centralizer falsifier for C889.

The direct path enumerates the centralizer of every ordered matrix pair.
The independent classifier uses one noncentral member, its discriminant,
and the test whether the second member commutes with it.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from pathlib import Path


PRIMES = (3, 5, 7)
OUT = Path(__file__).with_suffix(".json")


def mul(x: tuple[int, ...], y: tuple[int, ...], p: int) -> tuple[int, ...]:
    a, b, c, d = x
    e, f, g, h = y
    return (
        (a * e + b * g) % p,
        (a * f + b * h) % p,
        (c * e + d * g) % p,
        (c * f + d * h) % p,
    )


def sl2(p: int) -> list[tuple[int, ...]]:
    return [
        (a, b, c, d)
        for a in range(p)
        for b in range(p)
        for c in range(p)
        for d in range(p)
        if (a * d - b * c) % p == 1
    ]


def commute(x: tuple[int, ...], y: tuple[int, ...], p: int) -> bool:
    return mul(x, y, p) == mul(y, x, p)


def is_scalar(x: tuple[int, ...], p: int) -> bool:
    a, b, c, d = x
    return b == 0 and c == 0 and a == d and a * a % p == 1


def square_class(a: int, p: int) -> str:
    a %= p
    if a == 0:
        return "zero"
    return "square" if pow(a, (p - 1) // 2, p) == 1 else "nonsquare"


def predicted_type(x: tuple[int, ...], y: tuple[int, ...], p: int) -> str:
    noncentral = next((z for z in (x, y) if not is_scalar(z, p)), None)
    if noncentral is None:
        return "full"
    other = y if noncentral == x else x
    if not commute(noncentral, other, p):
        return "center"
    a, _, _, d = noncentral
    disc = ((a + d) ** 2 - 4) % p
    kind = square_class(disc, p)
    return {
        "square": "split_torus",
        "nonsquare": "nonsplit_torus",
        "zero": "signed_unipotent",
    }[kind]


def expected_order(kind: str, p: int) -> int:
    return {
        "full": p * (p * p - 1),
        "split_torus": p - 1,
        "nonsplit_torus": p + 1,
        "signed_unipotent": 2 * p,
        "center": 2,
    }[kind]


def certify_prime(p: int) -> dict[str, object]:
    group = sl2(p)
    assert len(group) == p * (p * p - 1)
    type_counts: Counter[str] = Counter()
    order_counts: Counter[int] = Counter()
    examples: dict[str, list[list[int]]] = {}
    for x in group:
        for y in group:
            kind = predicted_type(x, y, p)
            centralizer = [g for g in group if commute(g, x, p) and commute(g, y, p)]
            if len(centralizer) != expected_order(kind, p):
                raise AssertionError((p, x, y, kind, len(centralizer)))
            type_counts[kind] += 1
            order_counts[len(centralizer)] += 1
            examples.setdefault(kind, [list(x), list(y)])
    return {
        "group_order": len(group),
        "ordered_pairs_checked": len(group) ** 2,
        "centralizer_type_counts": dict(sorted(type_counts.items())),
        "centralizer_order_counts": {
            str(k): v for k, v in sorted(order_counts.items())
        },
        "lexicographically_first_examples": dict(sorted(examples.items())),
    }


def generate() -> bytes:
    payload = {
        "schema": "c889-prime-centralizer-falsifier-v1",
        "scope": {"groups": [f"SL(2,{p})" for p in PRIMES], "tuples": "all ordered pairs"},
        "claim": (
            "Every common centralizer is the full group, a split torus, "
            "a nonsplit torus, a signed unipotent group, or the center."
        ),
        "fields": {str(p): certify_prime(p) for p in PRIMES},
    }
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = generate()
    if args.check:
        tracked = OUT.read_bytes()
        if tracked != data:
            raise SystemExit("tracked certificate is stale")
        print(f"ok {OUT.name} {hashlib.sha256(data).hexdigest()}")
    else:
        OUT.write_bytes(data)
        print(f"wrote {OUT.name} {hashlib.sha256(data).hexdigest()}")


if __name__ == "__main__":
    main()
