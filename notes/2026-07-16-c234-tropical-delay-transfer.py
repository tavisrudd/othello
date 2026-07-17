#!/usr/bin/env python3
"""Independent checks for C234's delay-profile algebra and branching relay."""

from __future__ import annotations

import itertools
import json
from functools import lru_cache
from pathlib import Path

INF = 10**9


def add(f: tuple[int, ...], g: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(min(a, b) for a, b in zip(f, g))


def convolve(f: tuple[int, ...], g: tuple[int, ...]) -> tuple[int, ...]:
    """Budgeted bottleneck convolution for at-most-budget profiles."""
    r = len(f) - 1
    return tuple(
        min(max(f[i], g[j]) for i in range(k + 1) for j in range(k + 1 - i))
        for k in range(r + 1)
    )


def delay(f: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(INF if x == INF else x + 1 for x in f)


def monotone_profiles(r: int, values: tuple[int, ...]) -> list[tuple[int, ...]]:
    return [
        x
        for x in itertools.product(values, repeat=r + 1)
        if all(x[i] >= x[i + 1] for i in range(r))
    ]


def check_algebra() -> dict[str, int]:
    r = 3
    profiles = monotone_profiles(r, (0, 1, 2, INF))
    zero = (INF,) * (r + 1)
    one = (0,) * (r + 1)
    pairs = triples = 0
    for f in profiles:
        assert add(f, zero) == f
        assert convolve(f, one) == f
        assert convolve(one, f) == f
        assert add(f, f) == f
        assert delay(f) == tuple(INF if x == INF else x + 1 for x in f)
        for g in profiles:
            pairs += 1
            assert add(f, g) == add(g, f)
            assert convolve(f, g) == convolve(g, f)
            for h in profiles:
                triples += 1
                assert convolve(convolve(f, g), h) == convolve(f, convolve(g, h))
                assert convolve(f, add(g, h)) == add(convolve(f, g), convolve(f, h))
    return {"profiles": len(profiles), "pairs": pairs, "triples": triples}


Circuit = frozenset[str]


def binary_circuits(columns: dict[str, int]) -> set[Circuit]:
    """Enumerate every minimal zero-sum support of nonzero GF(2) columns."""
    names = tuple(columns)
    circuits: set[Circuit] = set()
    for size in range(1, len(names) + 1):
        for support in itertools.combinations(names, size):
            total = 0
            for name in support:
                total ^= columns[name]
            candidate = frozenset(support)
            if total == 0 and not any(c < candidate for c in circuits):
                circuits.add(candidate)
    return circuits


def glue(
    left: set[Circuit], left_port: str, right: set[Circuit], right_port: str
) -> set[Circuit]:
    """Circuit theorem for a matroid 2-sum, with distinct port labels."""
    assert all(left_port not in c or len(c) > 1 for c in left)
    assert all(right_port not in c or len(c) > 1 for c in right)
    out = {c for c in left if left_port not in c}
    out |= {c for c in right if right_port not in c}
    for c in left:
        if left_port not in c:
            continue
        for d in right:
            if right_port in d:
                out.add(frozenset((c - {left_port}) | (d - {right_port})))
    # The 2-sum theorem already produces circuits.  This assertion catches an
    # accidental label collision or malformed component in the test fixture.
    for c in out:
        assert not any(d < c for d in out)
    return out


@lru_cache(maxsize=None)
def relay_patterns(n: int) -> tuple[tuple[int, ...], ...]:
    # Names are left,right,x1,...,x(n-1),s1,...,sn.  Every circuit is one
    # interval: its two endpoint basis columns and all path-edge columns between.
    x_index = [0] + list(range(2, n + 1)) + [1]
    s_index = [n + 1 + i for i in range(n)]
    patterns = []
    for i in range(n):
        for j in range(i + 1, n + 1):
            patterns.append(tuple(sorted((x_index[i], x_index[j], *s_index[i:j]))))
    return tuple(patterns)


def check_relay_inventory() -> int:
    checked = 0
    for n in range(1, 7):
        names = ["left", "right"]
        columns = {"left": 1, "right": 1 << n}
        for i in range(1, n):
            names.append(f"x{i}")
            columns[f"x{i}"] = 1 << i
        for i in range(1, n + 1):
            names.append(f"s{i}")
            columns[f"s{i}"] = (1 << (i - 1)) ^ (1 << i)
        expected = {frozenset(names[i] for i in pattern) for pattern in relay_patterns(n)}
        assert binary_circuits(columns) == expected
        checked += len(expected)
    return checked


def relay(prefix: str, n: int) -> tuple[set[Circuit], str, str, set[str]]:
    left, right = f"{prefix}.left", f"{prefix}.right"
    names = [left, right]
    names += [f"{prefix}.x{i}" for i in range(1, n)]
    names += [f"{prefix}.s{i}" for i in range(1, n + 1)]
    circuits = {frozenset(names[i] for i in pattern) for pattern in relay_patterns(n)}
    seeds = {f"{prefix}.s{i}" for i in range(1, n + 1)}
    return circuits, left, right, seeds


def source(prefix: str) -> tuple[set[Circuit], str, set[str]]:
    port, seed = f"{prefix}.port", f"{prefix}.z"
    return {frozenset((port, seed))}, port, {seed}


def branch(prefix: str, n: int) -> tuple[set[Circuit], str, set[str]]:
    rc, left, right, seeds = relay(prefix, n)
    sc, sport, source_seeds = source(prefix)
    return glue(sc, sport, rc, left), right, seeds | source_seeds


def branching_tree(n: int, m: int, ell: int) -> tuple[set[Circuit], set[str], str]:
    # Binary center representation with two circuits sharing only the output s.
    p, q, u, s = "center.p", "center.q", "center.u", "center.s"
    a, c1, c2, c3 = "center.a", "center.c1", "center.c2", "center.c3"
    expected_center = {
        frozenset((s, p, q, a)),
        frozenset((s, u, c1, c2, c3)),
        frozenset((p, q, a, u, c1, c2, c3)),
    }
    matroid = binary_circuits(
        {
            p: 0b000001,
            q: 0b000010,
            a: 0b000100,
            u: 0b001000,
            c1: 0b010000,
            c2: 0b100000,
            s: 0b000111,
            c3: 0b111111,
        }
    )
    assert matroid == expected_center
    seeds = {a, c1, c2, c3}
    for prefix, length, center_port in (("P", n, p), ("Q", m, q), ("U", ell, u)):
        bc, bport, bseeds = branch(prefix, length)
        matroid = glue(matroid, center_port, bc, bport)
        seeds |= bseeds
    y = "consumer.y"
    matroid = glue(matroid, s, {frozenset(("consumer.port", y))}, "consumer.port")
    return matroid, seeds, y


def horn_arrivals(circuits: set[Circuit], seeds: set[str], radius: int) -> dict[str, int]:
    active = set(seeds)
    arrival = {e: 0 for e in seeds}
    ground = set().union(*circuits)
    for round_no in range(1, len(ground) + 1):
        new = {
            e
            for circuit in circuits
            if len(circuit) - 1 <= radius
            for e in circuit
            if e not in active and circuit - {e} <= active
        }
        if not new:
            break
        for e in new:
            arrival[e] = round_no
        active |= new
    return arrival


def check_branching() -> dict[str, int]:
    relay_circuits_checked = check_relay_inventory()
    cases = 0
    max_circuits = max_ground = 0
    for n, m, ell in itertools.product(range(1, 4), repeat=3):
        # At radius five, F_L's cost-two message delay is ceil((L-1)/4).
        # L=4d-3 therefore realizes message delay d-1.
        lengths = (4 * n - 3, 4 * m - 3, 4 * ell - 3)
        circuits, seeds, target = branching_tree(*lengths)
        arrivals = horn_arrivals(circuits, seeds, radius=5)
        expected = min(max(n, m), ell)
        assert arrivals[target] == expected, (n, m, ell, arrivals[target], expected)
        cases += 1
        max_circuits = max(max_circuits, len(circuits))
        max_ground = max(max_ground, len(set().union(*circuits)))
    return {
        "cases": cases,
        "relay_circuits_independently_checked": relay_circuits_checked,
        "max_circuits": max_circuits,
        "max_ground": max_ground,
    }


def main() -> None:
    result = {
        "status": "pass",
        "algebra": check_algebra(),
        "branching_binary_2sum_tree": check_branching(),
        "branching_formula": "tau(y) = min(max(n,m),ell)",
        "radius": 5,
    }
    output = Path(__file__).with_suffix(".json")
    output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
