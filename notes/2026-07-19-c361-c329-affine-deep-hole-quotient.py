#!/usr/bin/env python3
"""Independent quotient-coordinate replay for the C361 affine-hole reduction."""

from __future__ import annotations

import argparse
import hashlib
import json
from dataclasses import dataclass
from itertools import combinations_with_replacement
from pathlib import Path


HERE = Path(__file__).resolve().parent
STEM = "2026-07-19-c361-c329-affine-deep-hole-quotient"
OUTPUT = HERE / f"{STEM}.json"
C348_OUTPUT = HERE / "2026-07-18-c348-c329-coset-leader-enumerator.json"
C348_SHA256 = "ecc8881e02de212ed89479f8b0fa564f6db652d74a10ff65a3bf206f6a5d3eee"


@dataclass(frozen=True)
class GF2m:
    degree: int
    modulus: int

    @property
    def size(self) -> int:
        return 1 << self.degree

    def mul(self, a: int, b: int) -> int:
        out = 0
        while b:
            if b & 1:
                out ^= a
            b >>= 1
            a <<= 1
            if a & self.size:
                a ^= self.modulus
        return out

    def square(self, a: int) -> int:
        return self.mul(a, a)

    def pow(self, a: int, exponent: int) -> int:
        out = 1
        while exponent:
            if exponent & 1:
                out = self.mul(out, a)
            a = self.square(a)
            exponent >>= 1
        return out

    def trace(self, a: int) -> int:
        out = 0
        for _ in range(self.degree):
            out ^= a
            a = self.square(a)
        return out


class QuadraticTower:
    """E=F(omega), omega^2+omega+1=0, with [F:F_2] odd."""

    def __init__(self, base: GF2m):
        if base.degree % 2 != 1:
            raise ValueError("quadratic tower requires odd base degree")
        self.base = base
        self.q = base.size
        self.size = self.q * self.q
        self._inverses = [0] + [self.pow(x, self.size - 2) for x in range(1, self.size)]

    def pair(self, x: int) -> tuple[int, int]:
        return x % self.q, x // self.q

    def elt(self, a: int, b: int = 0) -> int:
        return a + self.q * b

    def mul(self, x: int, y: int) -> int:
        a, b = self.pair(x)
        c, d = self.pair(y)
        ac = self.base.mul(a, c)
        bd = self.base.mul(b, d)
        return self.elt(ac ^ bd, self.base.mul(a, d) ^ self.base.mul(b, c) ^ bd)

    def square(self, x: int) -> int:
        return self.mul(x, x)

    def pow(self, x: int, exponent: int) -> int:
        out = 1
        while exponent:
            if exponent & 1:
                out = self.mul(out, x)
            x = self.square(x)
            exponent >>= 1
        return out

    def div(self, x: int, y: int) -> int:
        if not y:
            raise ZeroDivisionError
        return self.mul(x, self._inverses[y])


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def same_layer_criterion(
    e: QuadraticTower, xi: int, eta: int, carrier: int, height: int
) -> bool:
    """Closed trace test for coverage by a secant within one layer."""
    eta0, eta1 = e.pair(eta)
    k0, k1 = e.pair(height)
    tau = xi ^ carrier
    if not tau:
        return eta1 == k1
    p = e.base.mul(eta1 ^ k1 ^ e.base.square(tau), e.base.pow(tau, e.q - 2))
    if not p:
        return False
    numerator = eta0 ^ k0 ^ e.base.square(tau)
    denominator = e.base.square(p)
    value = e.base.mul(numerator, e.base.pow(denominator, e.q - 2))
    return e.base.trace(value) == 0


def pair_image(
    e: QuadraticTower,
    first: tuple[int, int],
    second: tuple[int, int],
) -> set[tuple[int, int]]:
    """Image of one quotient secant correspondence (xi,x,r)->(xi,eta)."""
    c, k = first
    cc, ll = second
    d = c ^ cc
    delta = k ^ ll
    image: set[tuple[int, int]] = set()
    if first != second and not d:
        # Equal-parameter cross-layer secants are vertical and cover xi=c.
        image.update((c, eta) for eta in range(e.size))
    for xi in range(e.q):
        tau = xi ^ c
        for x in range(e.q):
            z = e.elt(x, tau)
            for r in range(e.q):
                if not r and not d:
                    continue
                p = e.elt(r, d)
                slope = p ^ (e.div(delta, p) if delta else 0)
                eta = e.square(z) ^ e.mul(slope, z) ^ k
                image.add((xi, eta))
    return image


def quotient_fixture(e: QuadraticTower, fixture: dict[str, object]) -> dict[str, object]:
    rho = int(fixture["rho"])
    a_pair = tuple(int(x) for x in fixture["a"])
    b_pair = tuple(int(x) for x in fixture["b"])
    a = e.elt(*a_pair)
    b = e.elt(*b_pair)
    layers = ((0, a), (0, b), (1, 0), (rho, 0))

    covered: set[tuple[int, int]] = set()
    same_layer_checks = 0
    for i, j in combinations_with_replacement(range(4), 2):
        image = pair_image(e, layers[i], layers[j])
        covered.update(image)
        if i == j:
            c, k = layers[i]
            for xi in range(e.q):
                for eta in range(e.size):
                    expected = same_layer_criterion(e, xi, eta, c, k)
                    if expected != ((xi, eta) in image):
                        raise AssertionError("same-layer trace criterion mismatch")
                    same_layer_checks += 1

    holes = [
        [xi, list(e.pair(eta))]
        for xi in range(e.q)
        for eta in range(e.size)
        if (xi, eta) not in covered
    ]
    expected_orbits = int(fixture["affine_deep_holes"]) // e.q
    if len(holes) != expected_orbits:
        raise AssertionError("quotient count disagrees with independent C348 incidence census")
    return {
        "rho": rho,
        "a": list(a_pair),
        "b": list(b_pair),
        "affine_orbit_count": len(holes),
        "affine_point_count": e.q * len(holes),
        "hole_orbits": holes,
        "same_layer_trace_checks": same_layer_checks,
    }


def generate() -> dict[str, object]:
    if file_sha256(C348_OUTPUT) != C348_SHA256:
        raise AssertionError("pinned C348 canonical output hash changed")
    c348 = json.loads(C348_OUTPUT.read_text())
    e = QuadraticTower(GF2m(5, 0b100101))
    fixtures = [quotient_fixture(e, fixture) for fixture in c348["fixtures"]]
    return {
        "schema": "c361-affine-quotient-v1",
        "field": {
            "F": "GF(2^5), modulus x^5+x^2+1",
            "E": "F[omega]/(omega^2+omega+1)",
            "basis": "a+b*omega encoded as [a,b]",
        },
        "pinned_independent_input": {
            "path": C348_OUTPUT.name,
            "sha256": C348_SHA256,
            "method": "direct projective secant-line incidence census",
        },
        "symbolic_fiber_ledger": [
            {"types": 4, "name": "within-layer", "gate": "one absolute-trace test"},
            {"types": 1, "name": "seed-seed", "generic_elimination_degree": 5},
            {"types": 1, "name": "repair-repair", "generic_elimination_degree": 2},
            {"types": 4, "name": "seed-repair", "generic_elimination_degree": 8},
        ],
        "fixtures": fixtures,
        "totals": {
            "fixture_count": len(fixtures),
            "quotient_representatives_checked": len(fixtures) * e.q * e.size,
            "same_layer_trace_checks": sum(int(f["same_layer_trace_checks"]) for f in fixtures),
        },
    }


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.output and args.check:
        parser.error("choose --output or --check")
    payload = canonical_bytes(generate())
    if args.check:
        if OUTPUT.read_bytes() != payload:
            raise SystemExit("tracked C361 JSON does not match regeneration")
        print("C361 quotient replay: OK")
    else:
        output = args.output or OUTPUT
        output.write_bytes(payload)
        print(output)


if __name__ == "__main__":
    main()
