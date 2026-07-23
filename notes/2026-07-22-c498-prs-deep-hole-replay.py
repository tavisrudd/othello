#!/usr/bin/env python3
"""Independent replay for the C498 PRS(q-5) census.

The Rust generator uses both four-secant marking and the Hankel-net criterion.
This stdlib-only replay rebuilds the finite fields independently and checks:

  * the deep-hole count by direct marking of every span of four distinct
    points of the quintic normal rational curve;
  * every recorded representative by an independently implemented
    Hankel-net split-quartic test;
  * every recorded PGL(2,q) orbit size and canonical representative;
  * stabilizer orders, Frobenius orbit links, net gcd degrees, the rank-three
    symmetric-cube cone, and rho=5 by finding a five-secant span through every
    representative; and
  * the odd-field split/non-split law of the trinomial net on the calibrated
    fields, including its isolated q=11 failure.

It intentionally does not reproduce the generator's quartic factorization or
member histograms.  Those are descriptive orbit labels, not the exhaustive
deep-set certificate.

Run from the repository root:

  python3 notes/2026-07-22-c498-prs-deep-hole-replay.py

Deterministic; no third-party dependencies, randomness, or timestamps.
"""

import argparse
import json
from itertools import combinations


MODULI = {
    8: (2, [1, 1, 0]),       # x^3 = x + 1
    9: (3, [2, 0]),          # x^2 = -1
    16: (2, [1, 1, 0, 0]),   # x^4 = x + 1
    25: (5, [2, 0]),          # x^2 = 2
    27: (3, [2, 1, 0]),       # x^3 = x - 1
}


class GF:
    """GF(q), with elements encoded by base-p polynomial coefficients."""

    def __init__(self, q):
        self.q = q
        if q in MODULI:
            self.p, red = MODULI[q]
            self.m = len(red)
        else:
            self.p, self.m, red = q, 1, None
        assert self.p ** self.m == q

        def digits(a):
            out = []
            for _ in range(self.m):
                out.append(a % self.p)
                a //= self.p
            return out

        def undigits(ds):
            a = 0
            for d in reversed(ds):
                a = a * self.p + d
            return a

        if self.m == 1:
            self.add_t = [[(a + b) % q for b in range(q)] for a in range(q)]
            self.mul_t = [[(a * b) % q for b in range(q)] for a in range(q)]
        else:
            self.add_t = [
                [
                    undigits(
                        [(x + y) % self.p for x, y in zip(digits(a), digits(b))]
                    )
                    for b in range(q)
                ]
                for a in range(q)
            ]
            self.mul_t = []
            for a in range(q):
                da = digits(a)
                row = []
                for b in range(q):
                    db = digits(b)
                    prod = [0] * (2 * self.m - 1)
                    for i, x in enumerate(da):
                        for j, y in enumerate(db):
                            prod[i + j] = (prod[i + j] + x * y) % self.p
                    for k in range(2 * self.m - 2, self.m - 1, -1):
                        c = prod[k]
                        for j, r in enumerate(red):
                            prod[k - self.m + j] = (
                                prod[k - self.m + j] + c * r
                            ) % self.p
                    row.append(undigits(prod[: self.m]))
                self.mul_t.append(row)

        self.neg_t = [next(b for b in range(q) if self.add_t[a][b] == 0)
                      for a in range(q)]
        self.inv_t = [0] + [
            next(b for b in range(1, q) if self.mul_t[a][b] == 1)
            for a in range(1, q)
        ]
        self.gen = next(
            g for g in range(2, q)
            if self._multiplicative_order(g) == q - 1
        )

    def _multiplicative_order(self, a):
        x = 1
        for n in range(1, self.q):
            x = self.mul_t[x][a]
            if x == 1:
                return n
        raise AssertionError("nonzero element has no multiplicative order")

    def add(self, a, b):
        return self.add_t[a][b]

    def mul(self, a, b):
        return self.mul_t[a][b]

    def neg(self, a):
        return self.neg_t[a]

    def sub(self, a, b):
        return self.add_t[a][self.neg_t[b]]

    def inv(self, a):
        return self.inv_t[a]

    def pow(self, a, n):
        out = 1
        while n:
            if n & 1:
                out = self.mul(out, a)
            a = self.mul(a, a)
            n >>= 1
        return out


def canon(F, vec):
    for x in vec:
        if x:
            ix = F.inv(x)
            return tuple(F.mul(ix, y) for y in vec)
    raise ValueError("zero vector has no projective class")


def encode(F, vec):
    out = 0
    for x in canon(F, vec):
        out = out * F.q + x
    return out


def trinomial_has_split_member(F):
    """Whether <1,t,t^4> has four distinct affine roots."""
    for roots in combinations(range(F.q), 4):
        e1 = 0
        e2 = 0
        for i, x in enumerate(roots):
            e1 = F.add(e1, x)
            for y in roots[i + 1:]:
                e2 = F.add(e2, F.mul(x, y))
        if e1 == 0 and e2 == 0:
            return roots
    return None


def q11_involution_factor_candidates(F):
    """Split quadratic pairs for W=<u,tu,u^2+5>, u=t^2-2."""
    assert F.q == 11
    a, c = 2, 5
    candidates = []
    for p in range(F.q):
        for q in range(F.q):
            for r in range(F.q):
                R = F.add(r, a)
                for s in range(F.q):
                    S = F.add(s, a)
                    first = F.add(F.mul(p, S), F.mul(q, R))
                    second = F.add(F.mul(R, S), F.mul(a, F.mul(p, q)))
                    if first != 0 or second != c:
                        continue
                    roots_1 = {
                        x for x in range(F.q)
                        if F.add(F.add(F.mul(x, x), F.mul(p, x)), r) == 0
                    }
                    roots_2 = {
                        x for x in range(F.q)
                        if F.add(F.add(F.mul(x, x), F.mul(q, x)), s) == 0
                    }
                    if len(roots_1) == len(roots_2) == 2:
                        candidates.append((p, q, r, s, roots_1, roots_2))
    assert len(candidates) == 15
    assert all(roots_1 & roots_2 for *_, roots_1, roots_2 in candidates)


def pg_points(q, dim):
    for lead in range(dim):
        tail_len = dim - lead - 1
        for code in range(q ** tail_len):
            tail = []
            for _ in range(tail_len):
                tail.append(code % q)
                code //= q
            yield tuple([0] * lead + [1] + tail)


def curve(F):
    out = []
    for t in range(F.q):
        row = [1]
        for _ in range(5):
            row.append(F.mul(row[-1], t))
        out.append(tuple(row))
    out.append((0, 0, 0, 0, 0, 1))
    return out


def matrix_rank(F, rows):
    a = [list(row) for row in rows]
    if not a:
        return 0
    r = 0
    for col in range(len(a[0])):
        pivot = next((i for i in range(r, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        iv = F.inv(a[r][col])
        a[r] = [F.mul(iv, x) for x in a[r]]
        for i in range(len(a)):
            if i != r and a[i][col]:
                c = a[i][col]
                a[i] = [F.sub(x, F.mul(c, y)) for x, y in zip(a[i], a[r])]
        r += 1
        if r == len(a):
            break
    return r


def nullspace(F, rows, ncols):
    a = [list(row) for row in rows]
    pivots = []
    r = 0
    for col in range(ncols):
        pivot = next((i for i in range(r, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        iv = F.inv(a[r][col])
        a[r] = [F.mul(iv, x) for x in a[r]]
        for i in range(len(a)):
            if i != r and a[i][col]:
                c = a[i][col]
                a[i] = [F.sub(x, F.mul(c, y)) for x, y in zip(a[i], a[r])]
        pivots.append(col)
        r += 1
        if r == len(a):
            break
    basis = []
    for free in (c for c in range(ncols) if c not in pivots):
        v = [0] * ncols
        v[free] = 1
        for i, pivot in enumerate(pivots):
            v[pivot] = F.neg(a[i][free])
        basis.append(tuple(v))
    return basis


def hankel_net(F, v):
    low = nullspace(F, [v[:5], v[1:]], 5)
    return [tuple(reversed(row)) for row in low]


def split_squarefree(F, high):
    leading_zeros = 0
    while leading_zeros < 5 and high[leading_zeros] == 0:
        leading_zeros += 1
    if leading_zeros >= 2:
        return False
    degree = 4 - leading_zeros
    roots = 0
    for x in range(F.q):
        y = 0
        for c in high[leading_zeros:]:
            y = F.add(F.mul(y, x), c)
        roots += y == 0
    return roots == degree


def deep_by_net(F, v):
    basis = hankel_net(F, v)
    for coeffs in pg_points(F.q, len(basis)):
        member = []
        for j in range(5):
            x = 0
            for c, b in zip(coeffs, basis):
                x = F.add(x, F.mul(c, b[j]))
            member.append(x)
        if split_squarefree(F, member):
            return False
    return True


def poly_trim(a):
    while len(a) > 1 and a[-1] == 0:
        a.pop()
    return a


def poly_mod(F, a, b):
    a, b = poly_trim(list(a)), poly_trim(list(b))
    ib = F.inv(b[-1])
    while len(a) >= len(b) and any(a):
        c = F.mul(a[-1], ib)
        shift = len(a) - len(b)
        for i, x in enumerate(b):
            a[i + shift] = F.sub(a[i + shift], F.mul(c, x))
        poly_trim(a)
    return a


def poly_gcd(F, a, b):
    a, b = poly_trim(list(a)), poly_trim(list(b))
    while any(b):
        a, b = b, poly_mod(F, a, b)
    if not any(a):
        return [0]
    ia = F.inv(a[-1])
    return [F.mul(ia, x) for x in a]


def net_gcd_degree(F, basis):
    infinity = min(next((i for i, x in enumerate(b) if x), 5) for b in basis)
    gcd = None
    for b in basis:
        i = next((i for i, x in enumerate(b) if x), 5)
        if i == 5:
            continue
        finite = list(reversed(b[i:]))
        gcd = finite if gcd is None else poly_gcd(F, gcd, finite)
    return infinity + (len(poly_trim(gcd)) - 1 if gcd else 0)


def poly_mul(F, a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] = F.add(out[i + j], F.mul(x, y))
    return out


def sym5_matrix(F, g):
    alpha, beta, gamma, delta = g
    out = [[0] * 6 for _ in range(6)]
    for i in range(6):
        a = [1]
        b = [1]
        for _ in range(i):
            a = poly_mul(F, a, [beta, alpha])
        for _ in range(5 - i):
            b = poly_mul(F, b, [delta, gamma])
        for j, x in enumerate(poly_mul(F, a, b)):
            out[i][j] = x
    return out


def matvec(F, matrix, v):
    return tuple(
        sum_field(F, (F.mul(x, y) for x, y in zip(row, v)))
        for row in matrix
    )


def sum_field(F, xs):
    out = 0
    for x in xs:
        out = F.add(out, x)
    return out


def orbit(F, start):
    generators = [
        sym5_matrix(F, (0, 1, 1, 0)),
        sym5_matrix(F, (1, 1, 0, 1)),
        sym5_matrix(F, (F.gen, 0, 0, 1)),
    ]
    seen = {encode(F, start)}
    todo = [canon(F, start)]
    while todo:
        v = todo.pop()
        for matrix in generators:
            w = canon(F, matvec(F, matrix, v))
            iw = encode(F, w)
            if iw not in seen:
                seen.add(iw)
                todo.append(w)
    return seen


def direct_deep_count(F):
    """Definition: complement of the union of all four-point NRC spans."""
    c = curve(F)
    coeffs = list(pg_points(F.q, 4))
    marked = bytearray(F.q ** 6)
    for ids in combinations(range(F.q + 1), 4):
        rows = [c[i] for i in ids]
        for co in coeffs:
            v = [
                sum_field(F, (F.mul(a, row[j]) for a, row in zip(co, rows)))
                for j in range(6)
            ]
            marked[encode(F, v)] = 1
    return sum(not marked[encode(F, v)] for v in pg_points(F.q, 6))


def in_five_span(F, v):
    c = curve(F)
    for ids in combinations(range(F.q + 1), 5):
        rows = [c[i] for i in ids]
        if matrix_rank(F, rows + [v]) == 5:
            return True
    return False


def replay_field(q, rec, direct_scan):
    F = GF(q)
    if F.p != 2:
        split_roots = trinomial_has_split_member(F)
        assert (split_roots is not None) == (q != 11), (
            q, split_roots, "unexpected odd-field trinomial splitting law"
        )
        if q == 9:
            assert split_roots == (1, 2, 3, 6)
    if q == 11:
        q11_involution_factor_candidates(F)
    if direct_scan:
        direct = direct_deep_count(F)
        assert direct == rec["deep_hole_count"], (q, direct, rec["deep_hole_count"])
    else:
        direct = "skipped"

    gcd_two_rows = [
        row for row in rec["pgl2_orbits"] if row["net_gcd_deg"] == 2
    ]
    tangent_orbits = (
        [(q + 1, q * (q - 1)), (q * q - 1, q)]
        if F.p == 5
        else [(q * (q + 1), q - 1)]
    )
    sigma_orbits = (
        [
            (q * (q * q - 1) // 10, 10),
            (q * (q * q - 1) // 5, 5),
            (q * (q * q - 1) // 5, 5),
        ]
        if (q + 1) % 5 == 0
        else [(q * (q * q - 1) // 2, 2)]
    )
    observed_gcd_two = sorted(
        (row["size"], row["stab_order"]) for row in gcd_two_rows
    )
    assert observed_gcd_two == sorted(tangent_orbits + sigma_orbits), (
        q, observed_gcd_two, tangent_orbits, sigma_orbits,
    )

    gcd_two_targets = {
        row["rep_index"]: row["frobenius_maps_to_rep_index"]
        for row in gcd_two_rows
    }
    gcd_two_cycles = 0
    unseen = set(gcd_two_targets)
    while unseen:
        gcd_two_cycles += 1
        current = unseen.pop()
        while gcd_two_targets[current] in unseen:
            current = gcd_two_targets[current]
            unseen.remove(current)
    expected_sigma_cycles = (
        3 if (q + 1) % 5 == 0 and F.p % 5 in (1, 4)
        else 2 if (q + 1) % 5 == 0
        else 1
    )
    expected_tangent_cycles = 2 if F.p == 5 else 1
    assert gcd_two_cycles == expected_tangent_cycles + expected_sigma_cycles, (
        q, gcd_two_cycles, expected_tangent_cycles, expected_sigma_cycles,
    )

    union = set()
    reps = {row["rep_index"] for row in rec["pgl2_orbits"]}
    for row in rec["pgl2_orbits"]:
        v = tuple(row["rep"])
        assert encode(F, v) == row["rep_index"]
        assert deep_by_net(F, v), (q, row["rep_index"], "representative not deep")
        component = orbit(F, v)
        assert len(component) == row["size"]
        assert min(component) == row["rep_index"]
        assert not (union & component), (q, row["rep_index"], "overlapping orbits")
        union |= component
        order = q ** 3 - q
        assert order // len(component) == row["stab_order"]
        gcd_degree = net_gcd_degree(F, hankel_net(F, v))
        assert gcd_degree == row["net_gcd_deg"]
        quotient_forms = [[v[i + j] for i in range(4)] for j in range(3)]
        if gcd_degree == 0:
            assert matrix_rank(F, quotient_forms) == 3, (
                q, row["rep_index"], "symmetric-cube quotient is not a rank-three cone"
            )
        elif gcd_degree == 2:
            assert matrix_rank(F, quotient_forms) == 2, (
                q, row["rep_index"], "quadratic-gcd catalecticant has wrong rank"
            )
        assert in_five_span(F, v), (q, row["rep_index"], "not in a five-span")
        fv = tuple(F.pow(x, F.p) for x in v)
        target = min(orbit(F, fv))
        assert target == row["frobenius_maps_to_rep_index"]
        assert target in reps

    assert len(union) == rec["deep_hole_count"]
    assert rec["covering_radius"] == 5
    print(
        f"q={q}: direct={direct}, PGL2_orbits={len(rec['pgl2_orbits'])}, "
        f"orbit_union={len(union)}, rho=5: PASS",
        flush=True,
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--json",
        default="notes/2026-07-22-c498-prs-deep-hole-census.json",
    )
    parser.add_argument("--fields", default="7,8,9,11,13,16")
    parser.add_argument(
        "--skip-direct",
        action="store_true",
        help="skip exhaustive four-secant marking; structural checks still run",
    )
    args = parser.parse_args()
    with open(args.json, encoding="utf-8") as src:
        cert = json.load(src)
    assert cert["schema"] == "c498-prs-deep-hole-census-v1"
    for q in map(int, args.fields.split(",")):
        replay_field(q, cert["fields"][str(q)], not args.skip_direct)
    print("C498 independent replay: ALL CHECKS PASS")


if __name__ == "__main__":
    main()
