from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations
from math import comb, isqrt
from typing import Callable, Iterable


@dataclass(frozen=True)
class Witness:
    support: frozenset[int]
    cost: int


@dataclass(frozen=True)
class Dependency:
    discarded: int
    coefficients: tuple[tuple[int, int], ...]


@dataclass(frozen=True)
class Certificate:
    universe_size: int
    radius: int
    failures: int
    prime: int
    retained: tuple[int, ...]
    dependencies: tuple[Dependency, ...]


def _is_prime(n: int) -> bool:
    return n >= 2 and all(n % d for d in range(2, isqrt(n) + 1))


def _prime_above(n: int) -> int:
    p = max(2, n + 1)
    while not _is_prime(p):
        p += 1
    return p


def _validate(family: tuple[Witness, ...], n: int, r: int, f: int) -> None:
    if min(n, r, f) < 0:
        raise ValueError("Universe size, radius, and failure budget must be nonnegative")
    for witness in family:
        if not isinstance(witness.cost, int):
            raise TypeError("The reference implementation uses exact integer costs")
        if len(witness.support) > r or any(not 0 <= h < n for h in witness.support):
            raise ValueError("Witness support lies outside the declared interface")


def _determinant(matrix: list[list[int]], p: int) -> int:
    a = [row[:] for row in matrix]
    result = 1
    for col in range(len(a)):
        pivot = next((i for i in range(col, len(a)) if a[i][col] % p), None)
        if pivot is None:
            return 0
        if pivot != col:
            a[col], a[pivot] = a[pivot], a[col]
            result = -result
        value = a[col][col] % p
        result = result * value % p
        inverse = pow(value, -1, p)
        for i in range(col + 1, len(a)):
            scale = a[i][col] * inverse % p
            a[i] = [(x - scale * y) % p for x, y in zip(a[i], a[col])]
    return result % p


def _minor_feature(w: Witness, n: int, r: int, f: int, p: int) -> tuple[int, ...]:
    padded = sorted(w.support) + list(range(n, n + r - len(w.support)))
    return tuple(
        _determinant([[pow(h + 1, row, p) for h in padded] for row in rows], p)
        for rows in combinations(range(r + f), r)
    )


def _wedge_feature(w: Witness, n: int, r: int, f: int, p: int) -> tuple[int, ...]:
    padded = sorted(w.support) + list(range(n, n + r - len(w.support)))
    coefficients = {(): 1}
    for h in padded:
        updated: dict[tuple[int, ...], int] = {}
        for rows, value in coefficients.items():
            for row in range(r + f):
                if row in rows:
                    continue
                sign = -1 if sum(i > row for i in rows) % 2 else 1
                index = tuple(sorted((*rows, row)))
                updated[index] = (updated.get(index, 0) + sign * value * pow(h + 1, row, p)) % p
        coefficients = updated
    return tuple(coefficients.get(rows, 0) for rows in combinations(range(r + f), r))


def compile_core(family: Iterable[Witness], n: int, r: int, f: int) -> Certificate:
    witnesses = tuple(family)
    _validate(witnesses, n, r, f)
    p = _prime_above(n + r)
    retained: list[int] = []
    dependencies: list[Dependency] = []
    basis: dict[int, tuple[list[int], dict[int, int]]] = {}
    order = sorted(range(len(witnesses)), key=lambda i: (witnesses[i].cost, sorted(witnesses[i].support), i))
    for index in order:
        remainder = list(_minor_feature(witnesses[index], n, r, f, p))
        expansion: dict[int, int] = {}
        for pivot in sorted(basis):
            vector, representation = basis[pivot]
            scale = remainder[pivot]
            if not scale:
                continue
            remainder = [(a - scale * b) % p for a, b in zip(remainder, vector)]
            for source, coefficient in representation.items():
                expansion[source] = (expansion.get(source, 0) + scale * coefficient) % p
        pivot = next((i for i, value in enumerate(remainder) if value), None)
        if pivot is None:
            dependencies.append(Dependency(index, tuple(sorted((i, a) for i, a in expansion.items() if a))))
        else:
            inverse = pow(remainder[pivot], -1, p)
            representation = {i: -a * inverse % p for i, a in expansion.items() if a}
            representation[index] = inverse
            basis[pivot] = ([a * inverse % p for a in remainder], representation)
            retained.append(index)
    return Certificate(n, r, f, p, tuple(retained), tuple(dependencies))


def verify_core(family: Iterable[Witness], certificate: Certificate) -> bool:
    witnesses = tuple(family)
    n, r, f, p = certificate.universe_size, certificate.radius, certificate.failures, certificate.prime
    try:
        _validate(witnesses, n, r, f)
    except (TypeError, ValueError):
        return False
    if not _is_prime(p) or p <= n + r:
        return False
    kept = set(certificate.retained)
    dropped = [d.discarded for d in certificate.dependencies]
    if len(kept) != len(certificate.retained) or len(kept) > comb(r + f, r):
        return False
    if len(set(dropped)) != len(dropped) or kept.intersection(dropped):
        return False
    if kept.union(dropped) != set(range(len(witnesses))):
        return False
    features = {i: _wedge_feature(witnesses[i], n, r, f, p) for i in range(len(witnesses))}
    for dependency in certificate.dependencies:
        indices = [i for i, _ in dependency.coefficients]
        if len(indices) != len(set(indices)) or any(i not in kept for i in indices):
            return False
        if any(witnesses[i].cost > witnesses[dependency.discarded].cost for i in indices):
            return False
        if any(not 0 < a < p for _, a in dependency.coefficients):
            return False
        reconstructed = tuple(
            sum(a * features[i][coordinate] for i, a in dependency.coefficients) % p
            for coordinate in range(comb(r + f, r))
        )
        if reconstructed != features[dependency.discarded]:
            return False
    return True


def retained_witnesses(family: Iterable[Witness], certificate: Certificate) -> tuple[Witness, ...]:
    witnesses = tuple(family)
    if not verify_core(witnesses, certificate):
        raise ValueError("Invalid representative-family certificate")
    return tuple(witnesses[i] for i in certificate.retained)


def failure_optimum(family: Iterable[Witness], failed: frozenset[int]) -> int | None:
    return min((w.cost for w in family if not w.support.intersection(failed)), default=None)


def oracle_portfolio(
    oracle: Callable[[frozenset[int]], Witness | None], r: int, f: int
) -> tuple[tuple[Witness, ...], int]:
    if min(r, f) < 0:
        raise ValueError("Radius and failure budget must be nonnegative")
    pending = [frozenset()]
    seen: set[frozenset[int]] = set()
    witnesses: set[Witness] = set()
    while pending:
        failed = pending.pop()
        if failed in seen:
            continue
        seen.add(failed)
        witness = oracle(failed)
        if witness is None:
            continue
        if len(witness.support) > r or witness.support.intersection(failed):
            raise ValueError("Oracle returned an inadmissible witness")
        witnesses.add(witness)
        if len(failed) < f:
            pending.extend(failed | {h} for h in sorted(witness.support))
    return tuple(sorted(witnesses, key=lambda w: (w.cost, sorted(w.support)))), len(seen)
