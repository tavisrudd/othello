#!/usr/bin/env python3
"""C416: exact twisted-Fourier pole-delta lemma and power-sum intertwiner.

Certified statements:

1. Pole-delta lemma.  Over q=11 (standard Veronese frame, polar Gram of
   XZ-Y^2) and q=7 (Coxeter frame, dot polarity), the projective twisted
   kernel (F_r f)(y) = sum_{<x,y> != 0} f(x) chi(<x,y>)^{-r} sends the
   line section (chi o ell)^r to q^2 times the canonically weighted twisted
   delta at the pole of ell, for every projective line (tangents included)
   and every tested nonzero weight.
2. Power-sum intertwiner.  For every matching M, F_r maps the secant
   power-sum section sum_k (chi o ell_k)^r exactly to q^2 times the
   dual-matching pole-delta measure.
3. Sharp multiplicative negative.  The product/quotient sections
   chi o G_M and chi o F_M (G_M = P_M - P_{JM}, F_M = G_M / Q) do NOT
   satisfy the proportional functional equation in either direction, and
   their A4/seam-symmetrized J-odd parts vanish identically.
4. Odd-plane structure and Fourier-line isolation.  The symmetrized J-odd
   power-sum family spans a rank-2 plane, its pole-delta image spans a
   rank-2 plane, and the linear system T p_M = lambda_M d_M over the
   cyclotomic field has nullity exactly 1 + #{M : the odd section
   vanishes}; with no vanishing (q=11) the moving-matching family isolates
   the Fourier line up to one scalar.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
C341_PATH = HERE / "2026-07-18-c341-a5-subgroup-decoder.py"
C341_SHA256 = "4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be"
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
C406_SHA256 = "a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51"
SCOUT_PATH = HERE / "2026-07-20-c406-matching-orbit-scout.json"
SCOUT_SHA256 = "fec533bb91f864100ebf5875952244d9d9e03ed69a0abda767360907a55bb246"
C378_CERT_PATH = HERE / "2026-07-19-c378-clebsch-common-duality.json"
C378_CERT_SHA256 = "3b311e5ee8ba5d09510fe18e4c5f3e30223c804d49b7c5b206e125ce1ad879dc"


def load_module(name, path, expected):
    assert hashlib.sha256(path.read_bytes()).hexdigest() == expected
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def load_json(path, expected):
    assert hashlib.sha256(path.read_bytes()).hexdigest() == expected
    return json.loads(path.read_text())


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def sha256_of(value):
    return hashlib.sha256(
        json.dumps(value, separators=(",", ":"), sort_keys=True).encode()
    ).hexdigest()


class Cyclotomic:
    """Exact arithmetic in Z[x]/Phi_n and Q(zeta_n) for n = q-1."""

    def __init__(self, order, phi_low_to_high, generator, prime):
        self.order = order
        self.phi = phi_low_to_high
        self.deg = len(phi_low_to_high) - 1
        self.prime = prime
        self.zero = (0,) * self.deg
        self.one = (1,) + (0,) * (self.deg - 1)
        self.fzero = tuple(Fraction(0) for _ in range(self.deg))
        self.log = {pow(generator, e, prime): e for e in range(order)}
        assert len(self.log) == order
        self.roots = tuple(
            self.reduce([0] * e + [1]) for e in range(order)
        )

    def reduce(self, cs):
        w = list(cs) + [0] * max(0, self.deg + 1 - len(cs))
        for cur in range(len(w) - 1, self.deg - 1, -1):
            lead = w[cur]
            if not lead:
                continue
            off = cur - self.deg
            for i, c in enumerate(self.phi):
                w[off + i] -= lead * c
        return tuple(w[: self.deg])

    def add(self, a, b):
        return tuple(x + y for x, y in zip(a, b))

    def sub(self, a, b):
        return tuple(x - y for x, y in zip(a, b))

    def mul(self, a, b):
        raw = [0] * (2 * self.deg - 1)
        for i, x in enumerate(a):
            if x:
                for j, y in enumerate(b):
                    raw[i + j] += x * y
        return self.reduce(raw)

    def scale(self, k, a):
        return tuple(k * x for x in a)

    # exact field layer (Fraction coefficients)
    def ffrom(self, c):
        return tuple(Fraction(x) for x in c)

    def fmul(self, a, b):
        raw = [Fraction(0)] * (2 * self.deg - 1)
        for i, x in enumerate(a):
            if x:
                for j, y in enumerate(b):
                    raw[i + j] += x * y
        w = list(raw)
        for cur in range(len(w) - 1, self.deg - 1, -1):
            lead = w[cur]
            if not lead:
                continue
            off = cur - self.deg
            for i, c in enumerate(self.phi):
                w[off + i] -= lead * c
        return tuple(w[: self.deg])

    def fsub(self, a, b):
        return tuple(x - y for x, y in zip(a, b))

    def finv(self, a):
        deg = self.deg
        cols = [
            self.fmul(a, tuple(Fraction(int(k == j)) for k in range(deg)))
            for j in range(deg)
        ]
        m = [
            [cols[j][i] for j in range(deg)] + [Fraction(int(i == 0))]
            for i in range(deg)
        ]
        for col in range(deg):
            piv = next(r for r in range(col, deg) if m[r][col] != 0)
            m[col], m[piv] = m[piv], m[col]
            s = m[col][col]
            m[col] = [v / s for v in m[col]]
            for r in range(deg):
                if r != col and m[r][col]:
                    f = m[r][col]
                    m[r] = [v - f * w for v, w in zip(m[r], m[col])]
        return tuple(m[i][deg] for i in range(deg))

    def rref(self, rows):
        rows = [list(r) for r in rows]
        nrows = len(rows)
        ncols = len(rows[0]) if nrows else 0
        pr = 0
        pivots = []
        for c in range(ncols):
            cand = next(
                (r for r in range(pr, nrows) if rows[r][c] != self.fzero), None
            )
            if cand is None:
                continue
            rows[pr], rows[cand] = rows[cand], rows[pr]
            inv = self.finv(rows[pr][c])
            rows[pr] = [self.fmul(inv, v) for v in rows[pr]]
            for r in range(nrows):
                if r != pr and rows[r][c] != self.fzero:
                    f = rows[r][c]
                    rows[r] = [
                        self.fsub(v, self.fmul(f, w))
                        for v, w in zip(rows[r], rows[pr])
                    ]
            pivots.append(c)
            pr += 1
            if pr == nrows:
                break
        return rows, pivots

    def dim_span(self, vecs):
        return len(self.rref([[self.ffrom(v) for v in vec] for vec in vecs])[1])


def norm3(v, prime):
    piv = next(x for x in v if x % prime)
    s = pow(piv, -1, prime)
    return tuple(x * s % prime for x in v)


def pivot_of(v, prime):
    return next(x for x in v if x % prime)


def matvec(m, v, prime):
    return tuple(
        sum(m[r][c] * v[c] for c in range(3)) % prime for r in range(3)
    )


def det3(m, prime):
    return (
        m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1])
        - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0])
        + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0])
    ) % prime


def mat3inv(m, prime):
    iv = pow(det3(m, prime), -1, prime)
    out = [[0] * 3 for _ in range(3)]
    for i in range(3):
        for j in range(3):
            sub = [
                [m[r][c] for c in range(3) if c != j]
                for r in range(3)
                if r != i
            ]
            out[j][i] = (
                ((-1) ** (i + j))
                * (sub[0][0] * sub[1][1] - sub[0][1] * sub[1][0])
                * iv
                % prime
            )
    return tuple(tuple(r) for r in out)


def secant_standard(endpoints, mp, prime):
    i, j = mp
    (s_i, t_i), (s_j, t_j) = endpoints[i], endpoints[j]
    return (
        t_i * t_j % prime,
        -(s_i * t_j + t_i * s_j) % prime,
        s_i * s_j % prime,
    )


class Frame:
    """Twisted-transform machinery over one frame with a fixed pairing."""

    def __init__(self, cyc, prime, points, pairing, pole_map):
        self.cyc = cyc
        self.prime = prime
        self.points = points
        self.pidx = {pt: i for i, pt in enumerate(points)}
        self.pairing = pairing
        self.pole_map = pole_map

    def line_section(self, functional, r):
        cyc, prime = self.cyc, self.prime
        out = []
        for pt in self.points:
            v = sum(a * b for a, b in zip(functional, pt)) % prime
            out.append(
                cyc.zero if v == 0 else cyc.roots[(r * cyc.log[v]) % cyc.order]
            )
        return out

    def kernel_apply(self, weight, section):
        cyc, prime = self.cyc, self.prime
        out = []
        for y in self.points:
            acc = cyc.zero
            for x, val in zip(self.points, section):
                if val == cyc.zero:
                    continue
                p = self.pairing(x, y)
                if p == 0:
                    continue
                acc = cyc.add(
                    acc,
                    cyc.mul(val, cyc.roots[(-weight * cyc.log[p]) % cyc.order]),
                )
            out.append(acc)
        return out

    def canonical_delta(self, functional, r):
        cyc, prime = self.cyc, self.prime
        raw = self.pole_map(functional)
        piv = pivot_of(raw, prime)
        out = [cyc.zero] * len(self.points)
        out[self.pidx[norm3(raw, prime)]] = cyc.roots[
            (r * cyc.log[piv]) % cyc.order
        ]
        return out

    def check_lemma(self, functional, r):
        cyc = self.cyc
        transform = self.kernel_apply(r, self.line_section(functional, r))
        expected = [
            cyc.scale(self.prime * self.prime, v)
            for v in self.canonical_delta(functional, r)
        ]
        assert transform == expected, (functional, r)

    def power_sum(self, lines, r):
        cyc, prime = self.cyc, self.prime
        out = [cyc.zero] * len(self.points)
        for functional in lines:
            for i, pt in enumerate(self.points):
                v = sum(a * b for a, b in zip(functional, pt)) % prime
                if v:
                    out[i] = cyc.add(
                        out[i], cyc.roots[(r * cyc.log[v]) % cyc.order]
                    )
        return out

    def pole_delta(self, lines, r):
        cyc = self.cyc
        out = [cyc.zero] * len(self.points)
        for functional in lines:
            delta = self.canonical_delta(functional, r)
            out = [cyc.add(u, v) for u, v in zip(out, delta)]
        return out

    def act(self, lift, section, r):
        cyc, prime = self.cyc, self.prime
        linv = mat3inv(lift, prime)
        out = [cyc.zero] * len(self.points)
        for i, x in enumerate(self.points):
            pre = matvec(linv, x, prime)
            piv = pivot_of(pre, prime)
            v = section[self.pidx[norm3(pre, prime)]]
            if v != cyc.zero:
                out[i] = cyc.mul(v, cyc.roots[(r * cyc.log[piv]) % cyc.order])
        return out

    def symmetrize(self, lifts, section, r):
        cyc = self.cyc
        total = [cyc.zero] * len(self.points)
        for lift in lifts:
            moved = self.act(lift, section, r)
            total = [cyc.add(u, v) for u, v in zip(total, moved)]
        return total

    def odd_part(self, exchange_lift, section, r):
        moved = self.act(exchange_lift, section, r)
        return [self.cyc.sub(u, v) for u, v in zip(section, moved)]

    def proportionality_record(self, transform, target):
        """Frame-invariant failure record for t ~ gamma * s."""
        cyc = self.cyc
        support_t = sum(v != cyc.zero for v in transform)
        support_s = sum(v != cyc.zero for v in target)
        t_only = sum(
            transform[i] != cyc.zero and target[i] == cyc.zero
            for i in range(len(self.points))
        )
        s_only = sum(
            transform[i] == cyc.zero and target[i] != cyc.zero
            for i in range(len(self.points))
        )
        ref = next(
            i
            for i in range(len(self.points))
            if target[i] != cyc.zero and transform[i] != cyc.zero
        )
        proportional = t_only == 0 and s_only == 0 and all(
            cyc.mul(transform[i], target[ref])
            == cyc.mul(transform[ref], target[i])
            for i in range(len(self.points))
        )
        return {
            "proportional": proportional,
            "transform_support": support_t,
            "target_support": support_s,
            "transform_nonzero_where_target_zero": t_only,
            "target_nonzero_where_transform_zero": s_only,
        }


def distinct_directions(cyc, sections):
    """Pairwise non-proportional nonzero sections (projective directions)."""
    nonzero = [s for s in sections if any(v != cyc.zero for v in s)]
    directions = []
    for s in nonzero:
        is_new = True
        for t in directions:
            ref = next(
                i for i in range(len(s)) if s[i] != cyc.zero or t[i] != cyc.zero
            )
            if all(
                cyc.mul(s[i], t[ref]) == cyc.mul(s[ref], t[i])
                for i in range(len(s))
            ):
                is_new = False
                break
        if is_new:
            directions.append(s)
    return len(directions)


def isolation_nullity(cyc, odd_sections, delta_sections):
    """Nullity of {T p_M = lambda_M d_M}; returns (nullity, vanishing)."""
    vanishing = sum(
        all(v == cyc.zero for v in sec) for sec in odd_sections
    )

    def pick_basis(vectors):
        basis = []
        for vec in vectors:
            trial = basis + [vec]
            if cyc.dim_span(trial) == len(trial):
                basis.append(vec)
        return basis

    def coords(vectors, basis):
        rows, piv = cyc.rref([[cyc.ffrom(v) for v in vec] for vec in basis])
        cols = piv
        out = []
        nb = len(basis)
        for vec in vectors:
            system = [
                [cyc.ffrom(basis[k][c]) for k in range(nb)]
                + [cyc.ffrom(vec[c])]
                for c in cols
            ]
            reduced, pivots = cyc.rref(system)
            assert pivots == list(range(nb))
            out.append([reduced[r][nb] for r in range(nb)])
        return out

    source_basis = pick_basis(odd_sections)
    target_basis = pick_basis(delta_sections)
    source_coords = coords(odd_sections, source_basis)
    target_coords = coords(delta_sections, target_basis)
    nb, nbd = len(source_basis), len(target_basis)
    count = len(odd_sections)
    unknowns = nbd * nb + count
    rows = []
    for mi in range(count):
        for i in range(nbd):
            row = [cyc.fzero] * unknowns
            for j in range(nb):
                row[i * nb + j] = source_coords[mi][j]
            row[nbd * nb + mi] = tuple(-x for x in target_coords[mi][i])
            rows.append(row)
    _, pivots = cyc.rref(rows)
    return unknowns - len(pivots), vanishing, nb, nbd


def evalpoly(poly, pt, prime):
    x, y, z = pt
    total = 0
    for (a, b, c), coef in poly.items():
        total += coef * pow(x, a, prime) * pow(y, b, prime) * pow(z, c, prime)
    return total % prime


def sub_polys(left, right, prime):
    exps = set(left) | set(right)
    return {
        e: v
        for e in exps
        for v in [(left.get(e, 0) - right.get(e, 0)) % prime]
        if v
    }


def homography(params, perm, prime):
    def frame(p0, p1, p2):
        det = (p0[0] * p1[1] - p0[1] * p1[0]) % prime
        inv = pow(det, -1, prime)
        al = (p2[0] * p1[1] - p2[1] * p1[0]) * inv % prime
        be = (p0[0] * p2[1] - p0[1] * p2[0]) * inv % prime
        assert al and be
        return (
            (al * p0[0] % prime, be * p1[0] % prime),
            (al * p0[1] % prime, be * p1[1] % prime),
        )

    def inv2(m):
        det = (m[0][0] * m[1][1] - m[0][1] * m[1][0]) % prime
        iv = pow(det, -1, prime)
        return (
            (m[1][1] * iv % prime, -m[0][1] * iv % prime),
            (-m[1][0] * iv % prime, m[0][0] * iv % prime),
        )

    def mul2(a, b):
        return tuple(
            tuple(
                sum(a[i][k] * b[k][j] for k in range(2)) % prime
                for j in range(2)
            )
            for i in range(2)
        )

    src = frame(params[0], params[1], params[2])
    tgt = frame(params[perm[0]], params[perm[1]], params[perm[2]])
    matrix = mul2(tgt, inv2(src))
    for index, (s, t) in enumerate(params):
        image = (
            (matrix[0][0] * s + matrix[0][1] * t) % prime,
            (matrix[1][0] * s + matrix[1][1] * t) % prime,
        )
        expected = params[perm[index]]
        assert (image[0] * expected[1] - image[1] * expected[0]) % prime == 0
        assert image != (0, 0)
    return matrix


def sym2(m, prime):
    (a, b), (c, d) = m
    return (
        (a * a % prime, 2 * a * b % prime, b * b % prime),
        (a * c % prime, (a * d + b * c) % prime, b * d % prime),
        (c * c % prime, 2 * c * d % prime, d * d % prime),
    )


def det_one(m, prime, cube_root_exponent):
    lam = pow(pow(det3(m, prime), -1, prime), cube_root_exponent, prime)
    out = tuple(tuple(lam * x % prime for x in row) for row in m)
    assert det3(out, prime) == 1
    return out


def h3_certificate(c406):
    prime = 11
    cyc = Cyclotomic(10, (1, -1, 1, -1, 1), 2, prime)
    scout = load_json(SCOUT_PATH, SCOUT_SHA256)
    record = next(r for r in scout["types"] if r["type"] == "H3")
    c378 = load_json(C378_CERT_PATH, C378_CERT_SHA256)
    conic, params = c406.C399.conic_parameterization(prime)
    endpoints = tuple(params)
    full_group, psl_group = c406.full_pgl(prime, endpoints)
    base = tuple(tuple(p) for p in record["coxeter_invariant_matching"])
    matchings = sorted(
        {c406.matching_image(g, base) for g in full_group}
    )
    plus = sorted({c406.matching_image(g, base) for g in psl_group})
    conic_index = {pt: i for i, pt in enumerate(conic)}
    j_action = tuple(
        conic_index[norm3(matvec(c378["golden_map_J"], tuple(pt), prime), prime)]
        for pt in conic
    )
    mate = c406.matching_image(j_action, base)

    points = sorted(
        {
            norm3(v, prime)
            for v in itertools.product(range(prime), repeat=3)
            if v != (0, 0, 0)
        }
    )
    gram = ((0, 0, 1), (0, (-2) % prime, 0), (1, 0, 0))
    gram_inv = ((0, 0, 1), (0, pow((-2) % prime, -1, prime), 0), (1, 0, 0))
    frame = Frame(
        cyc,
        prime,
        points,
        lambda x, y: sum(
            gram[i][j] * x[i] * y[j] for i in range(3) for j in range(3)
        )
        % prime,
        lambda functional: matvec(gram_inv, functional, prime),
    )

    secants = [
        secant_standard(endpoints, mp, prime)
        for mp in itertools.combinations(range(prime + 1), 2)
    ]
    assert len(secants) == 66

    # 1. Pole-delta lemma: every projective line at the factorization weights,
    # and every secant at weight one.
    for functional in points:
        for r in (4, 6):
            frame.check_lemma(functional, r)
    for functional in secants:
        frame.check_lemma(functional, 1)

    # 2. Power-sum intertwiner for every matching at both weights.
    for matching in matchings:
        lines = [secant_standard(endpoints, mp, prime) for mp in matching]
        for r in (4, 6):
            transform = frame.kernel_apply(r, frame.power_sum(lines, r))
            expected = [
                cyc.scale(prime * prime, v) for v in frame.pole_delta(lines, r)
            ]
            assert transform == expected

    # Group data: determinant-one Sym^2 lifts of the golden A4 and J.
    stab = lambda m: frozenset(
        g for g in full_group if c406.matching_image(g, m) == m
    )
    common = stab(base) & stab(mate)
    assert len(common) == 12
    lifts = [
        det_one(sym2(homography(endpoints, g, prime), prime), prime, 7)
        for g in sorted(common)
    ]
    j_lift = det_one(sym2(homography(endpoints, j_action, prime), prime), prime, 7)
    products = {
        tuple(
            tuple(
                sum(a[i][k] * b[k][j] for k in range(3)) % prime
                for j in range(3)
            )
            for i in range(3)
        )
        for a in lifts
        for b in lifts
    }
    assert products == set(lifts)

    # 3. Sharp multiplicative negative and odd-quotient vanishing.
    basis4 = c406.homogeneous_basis(4)
    prodpoly = {
        m: c406.matching_product(m, endpoints, prime) for m in matchings
    }
    pair_records = []
    odd_power, odd_delta = [], []
    for matching in plus:
        jm = c406.matching_image(j_action, matching)
        difference = sub_polys(prodpoly[matching], prodpoly[jm], prime)
        quotient_vec = c406.quotient_by_conic(difference, 4, prime)
        quotient_poly = {
            e: c for e, c in zip(basis4, quotient_vec) if c
        }
        section_f = [
            cyc.zero
            if evalpoly(quotient_poly, pt, prime) == 0
            else cyc.roots[cyc.log[evalpoly(quotient_poly, pt, prime)]]
            for pt in points
        ]
        section_g = [
            cyc.zero
            if evalpoly(difference, pt, prime) == 0
            else cyc.roots[cyc.log[evalpoly(difference, pt, prime)]]
            for pt in points
        ]
        forward = frame.proportionality_record(
            frame.kernel_apply(4, section_f), section_g
        )
        backward = frame.proportionality_record(
            frame.kernel_apply(6, section_g), section_f
        )
        assert not forward["proportional"] and not backward["proportional"]
        odd_quotient = frame.odd_part(
            j_lift, frame.symmetrize(lifts, section_f, 4), 4
        )
        assert all(v == cyc.zero for v in odd_quotient)
        pair_records.append(
            {
                "matching": [list(p) for p in matching],
                "forward": forward,
                "backward": backward,
            }
        )
        lines = [secant_standard(endpoints, mp, prime) for mp in matching]
        odd_power.append(
            frame.odd_part(
                j_lift, frame.symmetrize(lifts, frame.power_sum(lines, 4), 4), 4
            )
        )
        odd_delta.append(
            frame.odd_part(
                j_lift, frame.symmetrize(lifts, frame.pole_delta(lines, 4), 6), 6
            )
        )

    dim_power = cyc.dim_span(odd_power)
    dim_delta = cyc.dim_span(odd_delta)
    assert dim_power == 2 and dim_delta == 2
    nullity, vanishing, nb, nbd = isolation_nullity(cyc, odd_power, odd_delta)
    directions = distinct_directions(cyc, odd_power)
    assert vanishing == 0 and directions >= 3 and nullity == 1

    return {
        "field": prime,
        "frame": "standard Veronese, conic XZ-Y^2, polar Gram pairing",
        "character": {"order": 10, "generator": 2},
        "lemma": {
            "all_projective_lines_checked": len(points),
            "weights": [4, 6],
            "secants_checked_at_weight_one": len(secants),
            "value": "q^2 times canonical twisted delta at the pole",
            "tangent_lines_included": True,
        },
        "intertwiner": {
            "matchings": len(matchings),
            "weights": [4, 6],
            "statement": "F_r(power-sum section) = q^2 * dual pole-delta measure",
        },
        "golden_pairs": pair_records,
        "odd_quotient_family_vanishes": True,
        "odd_power_sum_span_dimension": dim_power,
        "odd_pole_delta_span_dimension": dim_delta,
        "isolation": {
            "unknowns": nbd * nb + len(plus),
            "nullity": nullity,
            "vanishing_sections": vanishing,
            "distinct_directions": directions,
            "statement": (
                "moving-matching equivariance cuts the Hom space to the "
                "Fourier line on the power-sum plane"
            ),
        },
        "odd_family_sha256": sha256_of(odd_power + odd_delta),
    }


def b3_certificate(c341, c406):
    prime = 7
    cyc = Cyclotomic(6, (1, -1, 1), 3, prime)
    conic, params = c406.C399.conic_parameterization(prime)
    endpoints = tuple(params)
    full_group, psl_group = c406.full_pgl(prime, endpoints)
    identity = tuple(range(prime + 1))
    points = sorted(
        {
            norm3(v, prime)
            for v in itertools.product(range(prime), repeat=3)
            if v != (0, 0, 0)
        }
    )
    frame = Frame(
        cyc,
        prime,
        points,
        lambda x, y: sum(a * b for a, b in zip(x, y)) % prime,
        lambda functional: functional,
    )

    std_conic = [
        (l * l % prime, l * r % prime, r * r % prime) for l, r in endpoints
    ]
    s2c = c341.frame_map(std_conic[:4], conic[:4], prime)
    c2s = c406.matrix_inverse(s2c, prime)

    def secant_cox(mp):
        line = secant_standard(endpoints, mp, prime)
        return tuple(
            sum(c2s[r][c] * line[r] for r in range(3)) % prime
            for c in range(3)
        )

    def so3_lift(perm):
        matrix = c341.frame_map(
            conic[:4], [conic[perm[i]] for i in range(4)], prime
        )
        gram = c341.mat_mul(tuple(zip(*matrix)), matrix, prime)
        mult = gram[0][0]
        scalar = mult * pow(det3(matrix, prime), -1, prime) % prime
        lift = tuple(
            tuple(scalar * e % prime for e in row) for row in matrix
        )
        assert det3(lift, prime) == 1
        return lift

    def perfect_matchings(vertices):
        if not vertices:
            return [()]
        first = vertices[0]
        out = []
        for i in range(1, len(vertices)):
            second = vertices[i]
            rest = vertices[1:i] + vertices[i + 1 :]
            for tail in perfect_matchings(rest):
                out.append(tuple(sorted(((first, second),) + tail)))
        return out

    parent = c406.coxeter_group("B3", prime, conic)
    fixed = [
        m
        for m in perfect_matchings(tuple(range(prime + 1)))
        if all(c406.matching_image(g, m) == m for g in parent)
    ]
    assert len(fixed) == 1
    base = fixed[0]
    matchings = sorted(
        {c406.matching_image(g, base) for g in full_group}
    )
    plus = sorted({c406.matching_image(g, base) for g in psl_group})
    base_stab = frozenset(
        g for g in full_group if c406.matching_image(g, base) == base
    )

    # 1-2. Lemma on every line and intertwiner on every matching.
    for functional in points:
        for r in (2, 4):
            frame.check_lemma(functional, r)
    for matching in matchings:
        lines = [secant_cox(mp) for mp in matching]
        for r in (2, 4):
            transform = frame.kernel_apply(r, frame.power_sum(lines, r))
            expected = [
                cyc.scale(prime * prime, v) for v in frame.pole_delta(lines, r)
            ]
            assert transform == expected

    def conjugate(element, group):
        inv = c406.inverse(element)
        return frozenset(
            c406.compose(c406.compose(element, member), inv)
            for member in group
        )

    opposite = sorted(
        {conjugate(e, base_stab) for e in full_group - psl_group},
        key=lambda g: sorted(g),
    )
    assert len(opposite) == 7

    basis2 = c406.homogeneous_basis(2)
    prodpoly = {
        m: c406.matching_product(m, endpoints, prime) for m in matchings
    }

    seam_records = []
    for other in opposite:
        common = set(base_stab) & set(other)
        seam_type = {6: "S3", 8: "D8"}[len(common)]
        swaps = sorted(
            e
            for e in full_group - psl_group
            if conjugate(e, frozenset(base_stab)) == other
            and conjugate(e, other) == frozenset(base_stab)
            and c406.compose(e, e) == identity
        )
        assert len(swaps) == 4
        lifts = [so3_lift(g) for g in sorted(common)]
        exchange_rows = []
        for exchange in swaps:
            exchange_lift = so3_lift(exchange)
            odd_power, odd_delta = [], []
            quotient_vanishes = True
            forward_defects = []
            for matching in plus:
                tm = c406.matching_image(exchange, matching)
                lines = [secant_cox(mp) for mp in matching]
                odd_power.append(
                    frame.odd_part(
                        exchange_lift,
                        frame.symmetrize(lifts, frame.power_sum(lines, 2), 2),
                        2,
                    )
                )
                odd_delta.append(
                    frame.odd_part(
                        exchange_lift,
                        frame.symmetrize(lifts, frame.pole_delta(lines, 2), 4),
                        4,
                    )
                )
                difference = sub_polys(prodpoly[matching], prodpoly[tm], prime)
                quotient_vec = c406.quotient_by_conic(difference, 2, prime)
                quotient_poly = {
                    e: c for e, c in zip(basis2, quotient_vec) if c
                }

                def std_pt(pt):
                    return tuple(
                        sum(c2s[r][c] * pt[c] for c in range(3)) % prime
                        for r in range(3)
                    )

                section_f = [
                    cyc.zero
                    if evalpoly(quotient_poly, std_pt(pt), prime) == 0
                    else cyc.roots[
                        cyc.log[evalpoly(quotient_poly, std_pt(pt), prime)]
                    ]
                    for pt in points
                ]
                section_g = [
                    cyc.zero
                    if evalpoly(difference, std_pt(pt), prime) == 0
                    else cyc.roots[
                        cyc.log[evalpoly(difference, std_pt(pt), prime)]
                    ]
                    for pt in points
                ]
                forward_defects.append(
                    frame.proportionality_record(
                        frame.kernel_apply(2, section_f), section_g
                    )
                )
                odd_quotient = frame.odd_part(
                    exchange_lift,
                    frame.symmetrize(lifts, section_f, 2),
                    2,
                )
                if any(v != cyc.zero for v in odd_quotient):
                    quotient_vanishes = False
            assert all(not d["proportional"] for d in forward_defects)
            assert quotient_vanishes
            dim_power = cyc.dim_span(odd_power)
            dim_delta = cyc.dim_span(odd_delta)
            assert dim_power == 2 and dim_delta == 2
            nullity, vanishing, nb, nbd = isolation_nullity(
                cyc, odd_power, odd_delta
            )
            directions = distinct_directions(cyc, odd_power)
            # Exact degeneracy law: one Fourier line, plus one free scalar per
            # vanishing section, plus one diagonal freedom when the nonzero
            # sections span only two projective directions.
            assert directions >= 2
            assert nullity == 1 + vanishing + (1 if directions == 2 else 0)
            exchange_rows.append(
                {
                    "exchange_permutation": list(exchange),
                    "odd_power_sum_span_dimension": dim_power,
                    "odd_pole_delta_span_dimension": dim_delta,
                    "vanishing_odd_sections": vanishing,
                    "distinct_directions": directions,
                    "isolation_nullity": nullity,
                    "forward_proportionality": forward_defects,
                    "odd_family_sha256": sha256_of(odd_power + odd_delta),
                }
            )
        seam_records.append(
            {
                "seam_type": seam_type,
                "common_group_order": len(common),
                "exchanges": exchange_rows,
            }
        )

    from collections import Counter

    assert Counter(r["seam_type"] for r in seam_records) == {"S3": 4, "D8": 3}
    return {
        "field": prime,
        "frame": "Coxeter frame, invariant conic X^2+Y^2+Z^2, dot polarity",
        "character": {"order": 6, "generator": 3},
        "lemma": {
            "all_projective_lines_checked": len(points),
            "weights": [2, 4],
            "value": "q^2 times canonical twisted delta at the self-pole [a]",
            "tangent_lines_included": True,
        },
        "intertwiner": {
            "matchings": len(matchings),
            "weights": [2, 4],
        },
        "seams": seam_records,
    }


def build():
    c341 = load_module("c341_for_c416", C341_PATH, C341_SHA256)
    c406 = load_module("c406_for_c416", C406_PATH, C406_SHA256)
    h3 = h3_certificate(c406)
    b3 = b3_certificate(c341, c406)
    return {
        "schema": "c416-twisted-power-sum-duality-v1",
        "theorem": (
            "The projective twisted Fourier kernel sends every line section "
            "(chi o ell)^r to q^2 times the canonical twisted delta at the "
            "pole of ell, hence maps every matching's secant power-sum "
            "section exactly to q^2 times the dual-matching pole-delta "
            "measure; the multiplicative product/quotient sections fail the "
            "proportional functional equation in both directions and their "
            "symmetrized odd parts vanish identically; the odd power-sum and "
            "pole-delta families span rank-2 planes and the moving-matching "
            "system T p_M = lambda_M d_M has nullity exactly 1 plus one per "
            "vanishing section plus one when the nonzero sections span only "
            "two projective directions."
        ),
        "H3": h3,
        "B3": b3,
        "A3_control": {
            "field": 5,
            "reason": (
                "no determinant-sheet exchange exists, so the odd families "
                "are empty and only the ambient lemma/intertwiner content "
                "survives; A3 remains the nonsplitting control"
            ),
        },
        "trusted_inputs": {
            C341_PATH.name: C341_SHA256,
            C406_PATH.name: C406_SHA256,
            SCOUT_PATH.name: SCOUT_SHA256,
            C378_CERT_PATH.name: C378_CERT_SHA256,
        },
        "verdict": (
            "THEOREM; TWISTED FOURIER DIAGONALIZES LINE SECTIONS INTO "
            "GAUSS-FREE q^2 POLE DELTAS; THE MATCHING POWER-SUM SECTION MAPS "
            "TO THE DUAL-MATCHING POLE-DELTA MEASURE; THE MULTIPLICATIVE "
            "SECTION IDENTITY FAILS SHARPLY AND ITS ODD SYMMETRIZATION IS "
            "ZERO; MOVING-MATCHING EQUIVARIANCE ISOLATES THE FOURIER LINE "
            "ON THE RANK-2 POWER-SUM PLANE"
        ),
        "boundary": (
            "No claim about the full four-dimensional odd block being "
            "spanned by matching families (they span rank-2 planes), no "
            "modular lattice comparison (C417), no seam selector, and no "
            "novelty claim; the lemma's orthogonality core is classical "
            "Gauss-sum territory."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build())
    if args.write:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT.name} ({len(payload)} bytes)")
        return
    assert OUTPUT.read_bytes() == payload, "stale certificate: rerun with --write"
    print("C416 twisted power-sum duality certificate OK")


if __name__ == "__main__":
    main()
