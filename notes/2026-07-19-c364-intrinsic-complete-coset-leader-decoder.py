#!/usr/bin/env python3
"""Exact reconstruction replay for the C364 intrinsic complete decoder."""

from __future__ import annotations

import argparse
import hashlib
import json
from array import array
from dataclasses import dataclass
from itertools import combinations, combinations_with_replacement
from pathlib import Path


HERE = Path(__file__).resolve().parent
STEM = "2026-07-19-c364-intrinsic-complete-coset-leader-decoder"
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

    def inv(self, a: int) -> int:
        if not a:
            raise ZeroDivisionError
        return self.pow(a, self.size - 2)


class QuadraticTower:
    def __init__(self, base: GF2m):
        self.base = base
        self.q = base.size
        self.size = self.q * self.q
        self._inverses = {1: 1}

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

    def inv(self, x: int) -> int:
        if not x:
            raise ZeroDivisionError
        if x not in self._inverses:
            self._inverses[x] = self.pow(x, self.size - 2)
        return self._inverses[x]

    def div(self, x: int, y: int) -> int:
        return self.mul(x, self.inv(y))


Poly = list[int]
Point = tuple[int, int, int]
Leader = tuple[tuple[int, int], ...]  # (column index, nonzero coefficient)


def trim(f: Poly) -> Poly:
    while len(f) > 1 and not f[-1]:
        f.pop()
    return f


def padd(f: Poly, g: Poly) -> Poly:
    out = [0] * max(len(f), len(g))
    for i, x in enumerate(f):
        out[i] ^= x
    for i, x in enumerate(g):
        out[i] ^= x
    return trim(out)


def pmul(field: GF2m, f: Poly, g: Poly) -> Poly:
    out = [0] * (len(f) + len(g) - 1)
    for i, x in enumerate(f):
        for j, y in enumerate(g):
            out[i + j] ^= field.mul(x, y)
    return trim(out)


def pscale(field: GF2m, f: Poly, a: int) -> Poly:
    return trim([field.mul(a, x) for x in f])


def pdivmod(field: GF2m, f: Poly, g: Poly) -> tuple[Poly, Poly]:
    f = trim(f[:])
    g = trim(g[:])
    if g == [0]:
        raise ZeroDivisionError
    q = [0] * max(1, len(f) - len(g) + 1)
    inv = field.inv(g[-1])
    while f != [0] and len(f) >= len(g):
        shift = len(f) - len(g)
        a = field.mul(f[-1], inv)
        q[shift] = a
        for i, x in enumerate(g):
            f[i + shift] ^= field.mul(a, x)
        trim(f)
    return trim(q), trim(f)


def pmod(field: GF2m, f: Poly, g: Poly) -> Poly:
    return pdivmod(field, f, g)[1]


def pgcd(field: GF2m, f: Poly, g: Poly) -> Poly:
    f = trim(f[:])
    g = trim(g[:])
    while g != [0]:
        f, g = g, pmod(field, f, g)
    if f == [0]:
        return f
    return pscale(field, f, field.inv(f[-1]))


def psquare_mod(field: GF2m, f: Poly, modulus: Poly) -> Poly:
    out = [0] * (2 * len(f) - 1)
    for i, x in enumerate(f):
        out[2 * i] = field.square(x)
    return pmod(field, trim(out), modulus)


def peval(field: GF2m, f: Poly, x: int) -> int:
    out = 0
    for a in reversed(f):
        out = field.mul(out, x) ^ a
    return out


def roots(field: GF2m, f: Poly) -> list[int]:
    """All F-roots without an O(|F|) scan, by Frobenius gcd and trace splitting."""
    f = trim(f[:])
    if len(f) <= 1:
        return []
    xq = [0, 1]
    for _ in range(field.degree):
        xq = psquare_mod(field, xq, f)
    linear_part = pgcd(field, f, padd(xq, [0, 1]))
    if len(linear_part) <= 1:
        return []
    factors = [linear_part]
    for beta in (1 << j for j in range(field.degree)):
        refined: list[Poly] = []
        for h in factors:
            if len(h) <= 2:
                refined.append(h)
                continue
            cur = pmod(field, [0, beta], h)
            trace_poly = [0]
            for _ in range(field.degree):
                trace_poly = padd(trace_poly, cur)
                cur = psquare_mod(field, cur, h)
            left = pgcd(field, h, trace_poly)
            if len(left) == 1 or len(left) == len(h):
                refined.append(h)
            else:
                right, rem = pdivmod(field, h, left)
                if rem != [0]:
                    raise AssertionError("trace split was not exact")
                refined.extend((left, right))
        factors = refined
    if any(len(h) != 2 for h in factors):
        raise AssertionError("trace basis did not split all rational roots")
    return sorted(h[0] for h in factors)


def conic_point(e: QuadraticTower, x: int, height: int) -> Point:
    return (1, x, e.square(x) ^ height)


def layered_columns(e: QuadraticTower, rho: int, a: int, b: int) -> tuple[Point, ...]:
    omega = e.elt(0, 1)
    layers = ((0, a), (0, b), (1, 0), (rho, 0))
    return tuple(conic_point(e, e.elt(t) ^ e.mul(e.elt(c), omega), k)
                 for c, k in layers for t in range(e.q))


def point_add_scaled(e: QuadraticTower, terms: Leader, columns: tuple[Point, ...]) -> Point:
    out = [0, 0, 0]
    for i, coefficient in terms:
        for j in range(3):
            out[j] ^= e.mul(coefficient, columns[i][j])
    return tuple(out)  # type: ignore[return-value]


def solve3(e: QuadraticTower, matrix: list[list[int]], rhs: list[int]) -> list[int]:
    aug = [row[:] + [value] for row, value in zip(matrix, rhs)]
    for col in range(3):
        pivot = next(i for i in range(col, 3) if aug[i][col])
        aug[col], aug[pivot] = aug[pivot], aug[col]
        inv = e.inv(aug[col][col])
        aug[col] = [e.mul(inv, x) for x in aug[col]]
        for i in range(3):
            if i != col and aug[i][col]:
                a = aug[i][col]
                aug[i] = [x ^ e.mul(a, y) for x, y in zip(aug[i], aug[col])]
    return [aug[i][3] for i in range(3)]


class Decoder:
    def __init__(self, e: QuadraticTower, rho: int, a: int, b: int):
        self.e = e
        self.layers = ((0, a), (0, b), (1, 0), (rho, 0))
        self.columns = layered_columns(e, rho, a, b)
        self.column_index = {p: i for i, p in enumerate(self.columns)}
        self.quotient: dict[tuple[int, int], tuple[int, Leader | None]] = {}

    def index_for(self, layer: int, x: int) -> int:
        c, k = self.layers[layer]
        point = conic_point(self.e, x, k)
        index = self.column_index.get(point)
        if index is None:
            raise AssertionError(f"reconstructed point is not on layer {layer}, carrier {c}")
        return index

    def leader_from_source(self, i: int, j: int, xi: int, eta: int, r: int, x: int) -> Leader | None:
        e = self.e
        c, k = self.layers[i]
        cc, ll = self.layers[j]
        d = c ^ cc
        tau = xi ^ c
        u = e.elt(0, xi)
        z = e.elt(x, tau)
        p = e.elt(r, d)
        if not p:
            return None
        slope = p ^ (e.div(k ^ ll, p) if k != ll else 0)
        if e.square(z) ^ e.mul(slope, z) ^ k != eta:
            return None
        first_x = u ^ z
        second_x = first_x ^ p
        mu = e.div(z, p)
        lam = 1 ^ mu
        if not lam or not mu:
            return None
        return tuple(sorted(((self.index_for(i, first_x), lam), (self.index_for(j, second_x), mu))))

    def same_layer(self, i: int, xi: int, eta: int) -> list[Leader]:
        e = self.e
        c, k = self.layers[i]
        eta0, eta1 = e.pair(eta)
        k0, k1 = e.pair(k)
        tau = xi ^ c
        dval = eta0 ^ k0 ^ e.base.square(tau)
        answers: list[Leader] = []
        if tau:
            r = e.base.mul(eta1 ^ k1 ^ e.base.square(tau), e.base.inv(tau))
            if not r:
                return []
            for x in roots(e.base, [dval, r, 1]):
                leader = self.leader_from_source(i, i, xi, eta, r, x)
                if leader:
                    answers.append(leader)
        elif eta1 == k1:
            if not dval:
                return []  # the corresponding syndrome is the layer point itself
            root_d = e.base.pow(dval, 1 << (e.base.degree - 1))
            for x in (1, 2, 4):
                if x and x != root_d:
                    r = x ^ e.base.mul(dval, e.base.inv(x))
                    leader = self.leader_from_source(i, i, xi, eta, r, x)
                    if leader:
                        answers.append(leader)
                        break
        return answers

    def seed_vertical(self, xi: int, eta: int) -> list[Leader]:
        if xi:
            return []
        e = self.e
        a, b = self.layers[0][1], self.layers[1][1]
        mu = e.div(eta ^ a, a ^ b)
        lam = 1 ^ mu
        if not lam or not mu:
            return []
        x = e.elt(0, xi)
        return [tuple(sorted(((self.index_for(0, x), lam), (self.index_for(1, x), mu))))]

    def cross_roots(self, i: int, j: int, xi: int, eta: int) -> list[tuple[int, int]]:
        e = self.e
        f = e.base
        c, k = self.layers[i]
        cc, ll = self.layers[j]
        d = c ^ cc
        delta = k ^ ll
        k0, k1 = e.pair(delta)
        eta0, eta1 = e.pair(eta)
        h0, h1 = e.pair(k)
        tau = xi ^ c
        cval = eta1 ^ f.square(tau) ^ h1
        dval = eta0 ^ f.square(tau) ^ h0
        R: Poly = [0, 1]
        if not d:  # the nonvertical seed--seed component
            xpoly = padd(pscale(f, R, cval), [f.mul(tau, k0 ^ k1)])
            xpoly = padd(xpoly, [0, 0, tau])
            polynomial = padd(
                padd(pscale(f, R, f.mul(dval, f.square(k1))),
                     pmul(f, R, pmul(f, xpoly, xpoly))),
                padd(pmul(f, padd([k0], [0, 0, 1]), pscale(f, xpoly, k1)),
                     [f.mul(tau, f.mul(k1, f.square(k1)))])
            )
            candidate_r = roots(f, polynomial) if polynomial != [0] else [1]
            return [(r, f.mul(peval(f, xpoly, r), f.inv(k1))) for r in candidate_r if r]
        if not delta:  # repair--repair: the exact quadratic fiber
            invd = f.inv(d)
            xpoly = [f.mul(cval ^ f.mul(tau, d), invd), f.mul(tau, invd)]
            polynomial = padd(pmul(f, xpoly, xpoly), pmul(f, R, xpoly))
            polynomial = padd(polynomial, [dval ^ f.mul(d, tau)])
            candidate_r = roots(f, polynomial) if polynomial != [0] else [0]
            return [(r, peval(f, xpoly, r)) for r in candidate_r]

        n = [f.square(d), d, 1]
        m0 = padd(pmul(f, R, n), [f.mul(k0, d) ^ f.mul(k1, d), k0])
        m1 = padd(pscale(f, n, d), [f.mul(k0, d), k1])
        xpoly = padd(pscale(f, n, cval), pscale(f, padd(m0, m1), tau))
        polynomial = padd(pscale(f, pmul(f, n, pmul(f, m1, m1)), dval),
                          pmul(f, n, pmul(f, xpoly, xpoly)))
        polynomial = padd(polynomial, pmul(f, m0, pmul(f, xpoly, m1)))
        polynomial = padd(polynomial, pscale(f, pmul(f, m1, pmul(f, m1, m1)), tau))
        # If every eliminated coefficient cancels, all r are main-polynomial roots.
        # Three fixed values suffice: the exceptional divisor M_1 has degree at most two.
        main_roots = roots(f, polynomial) if polynomial != [0] else [0, 1, 2]
        candidate_r = set(main_roots) | set(roots(f, m1))
        answers: list[tuple[int, int]] = []
        for r in sorted(candidate_r):
            nr = peval(f, n, r)
            m0r = peval(f, m0, r)
            m1r = peval(f, m1, r)
            xr = peval(f, xpoly, r)
            if m1r:
                answers.append((r, f.mul(xr, f.inv(m1r))))
            elif not xr:
                slope = f.mul(m0r, f.inv(nr))
                for x in roots(f, [dval, slope, 1]):
                    answers.append((r, x))
        return answers

    def affine_secant(self, xi: int, eta: int) -> Leader | None:
        candidates: list[Leader] = []
        for i in range(4):
            candidates.extend(self.same_layer(i, xi, eta))
        candidates.extend(self.seed_vertical(xi, eta))
        for i, j in combinations(range(4), 2):
            if i == 0 and j == 1 and not xi:
                pass
            for r, x in self.cross_roots(i, j, xi, eta):
                leader = self.leader_from_source(i, j, xi, eta, r, x)
                if leader:
                    candidates.append(leader)
        return min(candidates, default=None)

    def infinity_secant(self, m: int | None) -> Leader | None:
        e = self.e
        f = e.base
        if m is None:  # [0:0:1], the vertical seed--seed direction
            coefficient = e.inv(self.layers[0][1] ^ self.layers[1][1])
            return ((self.index_for(0, 0), coefficient), (self.index_for(1, 0), coefficient))
        m0, m1 = e.pair(m)
        candidates: list[Leader] = []
        for i, j in combinations_with_replacement(range(4), 2):
            c, k = self.layers[i]
            cc, ll = self.layers[j]
            d = c ^ cc
            delta = k ^ ll
            k0, k1 = e.pair(delta)
            if i == j:
                rs = [m0] if not m1 and m0 else []
            elif not d:
                p0 = [k0, m0, 1]
                p1 = [k1, m1]
                common = pgcd(f, p0, p1) if p1 != [0] else p0
                rs = [r for r in roots(f, common) if r]
            else:
                n = [f.square(d), d, 1]
                mzero = padd(pmul(f, [0, 1], n), [f.mul(k0, d) ^ f.mul(k1, d), k0])
                mone = padd(pscale(f, n, d), [f.mul(k0, d), k1])
                common = pgcd(f, padd(mzero, pscale(f, n, m0)),
                              padd(mone, pscale(f, n, m1)))
                rs = roots(f, common)
            for r in rs:
                p = e.elt(r, d)
                if not p:
                    continue
                slope = p ^ (e.div(delta, p) if delta else 0)
                if slope != m:
                    continue
                coefficient = e.inv(p)
                first_x = e.elt(0, c)
                second_x = first_x ^ p
                candidates.append(tuple(sorted(((self.index_for(i, first_x), coefficient),
                                                (self.index_for(j, second_x), coefficient)))))
        return min(candidates, default=None)

    def decode(self, syndrome: Point) -> tuple[int, Leader]:
        e = self.e
        if syndrome == (0, 0, 0):
            return 0, ()
        if syndrome[0]:
            scale = e.inv(syndrome[0])
            u = e.mul(scale, syndrome[1])
            v = e.mul(scale, syndrome[2])
            normalized = (1, u, v)
            if normalized in self.column_index:
                return 1, ((self.column_index[normalized], syndrome[0]),)
            u0, xi = e.pair(u)
            eta = v ^ e.square(u)
            key = (xi, eta)
            if key not in self.quotient:
                leader = self.affine_secant(xi, eta)
                self.quotient[key] = (2 if leader else 3, leader)
            weight, representative = self.quotient[key]
            if weight == 2 and representative is not None:
                lifted: list[tuple[int, int]] = []
                for index, coefficient in representative:
                    _, x, _ = self.columns[index]
                    layer = index // e.q
                    lifted.append((self.index_for(layer, x ^ e.elt(u0)), e.mul(syndrome[0], coefficient)))
                return 2, tuple(sorted(lifted))
        else:
            if syndrome[1]:
                scale = e.inv(syndrome[1])
                leader = self.infinity_secant(e.mul(scale, syndrome[2]))
                if leader:
                    return 2, tuple((i, e.mul(syndrome[1], a)) for i, a in leader)
            else:
                leader = self.infinity_secant(None)
                if leader:
                    return 2, tuple((i, e.mul(syndrome[2], a)) for i, a in leader)
        chosen = (0, 1, 2)
        matrix = [[self.columns[j][i] for j in chosen] for i in range(3)]
        coefficients = solve3(e, matrix, list(syndrome))
        if any(not x for x in coefficients):
            raise AssertionError("a declared deep hole had a zero three-column coefficient")
        return 3, tuple(zip(chosen, coefficients))


def direct_weights(e: QuadraticTower, columns: tuple[Point, ...]) -> array:
    q = e.size
    total = q * q + q + 1
    weights = array("B", [3]) * total
    for _, x, z in columns:
        weights[x * q + z] = 1
    for i, j in combinations(range(len(columns)), 2):
        p, qpoint = columns[i], columns[j]
        dx = p[1] ^ qpoint[1]
        if not dx:
            for z in range(q):
                weights[p[1] * q + z] = min(weights[p[1] * q + z], 2)
            weights[e.size * e.size + e.size] = 2
        else:
            slope = e.div(p[2] ^ qpoint[2], dx)
            intercept = p[2] ^ e.mul(slope, p[1])
            for x in range(q):
                weights[x * q + (e.mul(slope, x) ^ intercept)] = min(
                    weights[x * q + (e.mul(slope, x) ^ intercept)], 2)
            weights[e.size * e.size + slope] = 2
    return weights


def fixture_check(e: QuadraticTower, fixture: dict[str, object]) -> dict[str, object]:
    rho = int(fixture["rho"])
    a = e.elt(*(int(x) for x in fixture["a"]))
    b = e.elt(*(int(x) for x in fixture["b"]))
    decoder = Decoder(e, rho, a, b)
    direct = direct_weights(e, decoder.columns)
    counts = [0, 0, 0, 0]
    reconstructed = 0
    q = e.size
    for point_id in range(len(direct)):
        if point_id < q * q:
            syndrome = (1, point_id // q, point_id % q)
        elif point_id < q * q + q:
            syndrome = (0, 1, point_id - q * q)
        else:
            syndrome = (0, 0, 1)
        weight, leader = decoder.decode(syndrome)
        if weight != direct[point_id] or len(leader) != weight:
            raise AssertionError(f"direct-incidence disagreement at {syndrome}")
        if point_add_scaled(e, leader, decoder.columns) != syndrome:
            raise AssertionError(f"leader reconstruction disagreement at {syndrome}")
        if any(not coefficient for _, coefficient in leader):
            raise AssertionError("zero coefficient in claimed support")
        counts[weight] += 1
        reconstructed += 1
    return {
        "rho": rho,
        "a": list(e.pair(a)),
        "b": list(e.pair(b)),
        "projective_syndromes_checked": reconstructed,
        "weights": {str(i): counts[i] for i in range(1, 4)},
        "quotient_fibers_solved": e.q * e.size,
    }


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def generate() -> dict[str, object]:
    if file_sha256(C348_OUTPUT) != C348_SHA256:
        raise AssertionError("pinned independent C348 output changed")
    c348 = json.loads(C348_OUTPUT.read_text())
    e = QuadraticTower(GF2m(5, 0b100101))
    fixtures = [fixture_check(e, fixture) for fixture in c348["fixtures"]]
    return {
        "schema": "c364-intrinsic-complete-decoder-v1",
        "field": {
            "F": "GF(2^5), modulus x^5+x^2+1",
            "E": "F[omega]/(omega^2+omega+1)",
            "basis": "a+b*omega encoded as [a,b]",
        },
        "root_finding": {
            "method": "gcd(f,X^Q-X), then deterministic trace-pairing splits over an F2 basis",
            "maximum_input_degree": 8,
            "base_field_scan": False,
        },
        "independent_reference": {
            "method": "direct affine-line incidence union, without quotient coordinates",
            "pinned_c348_sha256": C348_SHA256,
        },
        "fixtures": fixtures,
        "totals": {
            "fixtures": len(fixtures),
            "projective_syndromes_checked": sum(int(x["projective_syndromes_checked"]) for x in fixtures),
            "quotient_fibers_solved": sum(int(x["quotient_fibers_solved"]) for x in fixtures),
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
            raise SystemExit("tracked C364 JSON does not match regeneration")
        print("C364 complete decoder replay: OK")
    else:
        output = args.output or OUTPUT
        output.write_bytes(payload)
        print(output)


if __name__ == "__main__":
    main()
