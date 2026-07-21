#!/usr/bin/env python3
"""C416 independent replay.

Frame/method independence from the primary checker:
- q=11 runs in the H3 frame (dot polarity, pole of a functional is the
  functional itself), with the golden A4 built from the frozen C378
  reflection-group matrices instead of Sym^2 homographies, and secants
  transported through the frozen C406-certificate bridge;
- q=7 runs in the standard Veronese frame (polar Gram of XZ-Y^2) with
  native secant functionals, instead of the primary's Coxeter frame;
- span dimensions, direction counts, and isolation nullities are
  recomputed through modular embeddings of the cyclotomic ring at two
  primes each, instead of exact Fraction arithmetic; these are
  consistency replays of the primary's exact field computations;
- every semantic value (defect counts, dimensions, directions,
  nullities, vanishing counts) must equal the primary certificate.
"""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PRIMARY_JSON = HERE / "2026-07-20-c416-twisted-power-sum-duality.json"
C341_PATH = HERE / "2026-07-18-c341-a5-subgroup-decoder.py"
C341_SHA256 = "4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be"
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
C406_SHA256 = "a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51"
C406_CERT_PATH = HERE / "2026-07-20-c406-matching-module.json"
C406_CERT_SHA256 = "e39bf131f3d818dfbcbeb1f2d4dfa9a6ba7645c41cdd6fe9600957c0fe1dc4b2"
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


def norm3(v, prime):
    piv = next(x for x in v if x % prime)
    s = pow(piv, -1, prime)
    return tuple(x * s % prime for x in v)


def pivot_of(v, prime):
    return next(x for x in v if x % prime)


def matvec(m, v, prime):
    return tuple(sum(m[r][c] * v[c] for c in range(3)) % prime for r in range(3))


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


class ModularZeta:
    """Cyclotomic exponents realized in F_p with an order-n element."""

    def __init__(self, order, modulus):
        self.order = order
        self.modulus = modulus
        element = next(
            candidate
            for candidate in range(2, modulus)
            if pow(candidate, order, modulus) == 1
            and all(
                pow(candidate, order // d, modulus) != 1
                for d in (2, 3, 5)
                if order % d == 0
            )
        )
        self.zeta = element
        self.powers = [pow(element, e, modulus) for e in range(order)]

    def rank(self, rows):
        p = self.modulus
        rows = [list(r) for r in rows]
        nrows = len(rows)
        ncols = len(rows[0]) if nrows else 0
        pr = 0
        for c in range(ncols):
            cand = next((r for r in range(pr, nrows) if rows[r][c] % p), None)
            if cand is None:
                continue
            rows[pr], rows[cand] = rows[cand], rows[pr]
            iv = pow(rows[pr][c], -1, p)
            rows[pr] = [v * iv % p for v in rows[pr]]
            for r in range(nrows):
                if r != pr and rows[r][c] % p:
                    f = rows[r][c]
                    rows[r] = [
                        (v - f * w) % p for v, w in zip(rows[r], rows[pr])
                    ]
            pr += 1
            if pr == nrows:
                break
        return pr


class Sections:
    """Value-level twisted sections: entries are None (zero) or exponents...

    Values are stored as dicts exponent->integer coefficient sums realized
    directly in each modular embedding when linear algebra is needed; for
    exact equality checks the symbolic multiset representation is used.
    """


def build_field(prime, order, generator):
    log = {pow(generator, e, prime): e for e in range(order)}
    assert len(log) == order
    return log


class Machine:
    """Sections as integer coefficient vectors over exponent basis."""

    def __init__(self, prime, order, generator, points, pairing, pole_map):
        self.prime = prime
        self.order = order
        self.log = build_field(prime, order, generator)
        self.points = points
        self.pidx = {pt: i for i, pt in enumerate(points)}
        self.pairing = pairing
        self.pole_map = pole_map

    def zero(self):
        return [0] * self.order

    def root(self, e):
        out = [0] * self.order
        out[e % self.order] = 1
        return out

    def add(self, a, b):
        return [x + y for x, y in zip(a, b)]

    def sub(self, a, b):
        return [x - y for x, y in zip(a, b)]

    def rotate(self, a, e):
        n = self.order
        return [a[(i - e) % n] for i in range(n)]

    def is_zero_symbolic(self, a):
        """Zero as a cyclotomic integer: reduce mod Phi_n over Z."""
        # subtract using the relation sum of all n-th roots grouped by
        # primitive relation; use exact reduction via polynomial division
        # by Phi_n with integer arithmetic.
        return not any(self.reduce_phi(a))

    def reduce_phi(self, a):
        n = self.order
        # polynomial in zeta of degree < n; reduce modulo Phi_n(zeta)
        if n == 10:
            phi = (1, -1, 1, -1, 1)
            deg = 4
        elif n == 6:
            phi = (1, -1, 1)
            deg = 2
        else:
            raise AssertionError(n)
        w = list(a)
        # first reduce zeta^n = 1 representation to degree < n (already)
        for cur in range(n - 1, deg - 1, -1):
            lead = w[cur]
            if not lead:
                continue
            off = cur - deg
            for i, c in enumerate(phi):
                w[off + i] -= lead * c
        return tuple(w[:deg])

    def eq(self, a, b):
        return self.reduce_phi(a) == self.reduce_phi(b)

    def line_section(self, functional, r):
        out = []
        for pt in self.points:
            v = sum(x * y for x, y in zip(functional, pt)) % self.prime
            out.append(None if v == 0 else (r * self.log[v]) % self.order)
        return out

    def kernel_apply_exponents(self, weight, exponents):
        """Transform of a pure-exponent section; output coefficient vectors."""
        out = []
        for y in self.points:
            acc = self.zero()
            for x, e in zip(self.points, exponents):
                if e is None:
                    continue
                p = self.pairing(x, y)
                if p == 0:
                    continue
                acc[(e - weight * self.log[p]) % self.order] += 1
            out.append(acc)
        return out

    def kernel_apply(self, weight, section):
        out = []
        for y in self.points:
            acc = self.zero()
            for x, coeffs in zip(self.points, section):
                p = self.pairing(x, y)
                if p == 0:
                    continue
                shift = (-weight * self.log[p]) % self.order
                rotated = self.rotate(coeffs, shift)
                acc = self.add(acc, rotated)
            out.append(acc)
        return out

    def coeff_section_from_exponents(self, exponents):
        return [
            self.zero() if e is None else self.root(e) for e in exponents
        ]

    def canonical_delta(self, functional, r):
        raw = self.pole_map(functional)
        piv = pivot_of(raw, self.prime)
        out = [self.zero() for _ in self.points]
        out[self.pidx[norm3(raw, self.prime)]] = self.root(
            (r * self.log[piv]) % self.order
        )
        return out

    def scaled(self, k, section):
        return [[k * v for v in coeffs] for coeffs in section]

    def section_eq(self, a, b):
        return all(self.eq(x, y) for x, y in zip(a, b))

    def check_lemma(self, functional, r):
        transform = self.kernel_apply_exponents(r, self.line_section(functional, r))
        expected = self.scaled(
            self.prime * self.prime, self.canonical_delta(functional, r)
        )
        assert self.section_eq(transform, expected), (functional, r)

    def power_sum(self, lines, r):
        out = [self.zero() for _ in self.points]
        for functional in lines:
            for i, pt in enumerate(self.points):
                v = sum(x * y for x, y in zip(functional, pt)) % self.prime
                if v:
                    out[i][(r * self.log[v]) % self.order] += 1
        return out

    def pole_delta(self, lines, r):
        out = [self.zero() for _ in self.points]
        for functional in lines:
            delta = self.canonical_delta(functional, r)
            out = [self.add(u, v) for u, v in zip(out, delta)]
        return out

    def act(self, lift, section, r):
        linv = mat3inv(lift, self.prime)
        out = [self.zero() for _ in self.points]
        for i, x in enumerate(self.points):
            pre = matvec(linv, x, self.prime)
            piv = pivot_of(pre, self.prime)
            coeffs = section[self.pidx[norm3(pre, self.prime)]]
            out[i] = self.rotate(coeffs, (r * self.log[piv]) % self.order)
        return out

    def symmetrize(self, lifts, section, r):
        total = [self.zero() for _ in self.points]
        for lift in lifts:
            total = [
                self.add(u, v) for u, v in zip(total, self.act(lift, section, r))
            ]
        return total

    def odd_part(self, exchange_lift, section, r):
        moved = self.act(exchange_lift, section, r)
        return [self.sub(u, v) for u, v in zip(section, moved)]

    def section_is_zero(self, section):
        return all(not any(self.reduce_phi(c)) for c in section)

    def proportionality_record(self, transform, target):
        def mul(a, b):
            n = self.order
            out = [0] * n
            for i, x in enumerate(a):
                if x:
                    for j, y in enumerate(b):
                        if y:
                            out[(i + j) % n] += x * y
            return out

        def nz(coeffs):
            return any(self.reduce_phi(coeffs))

        count = len(self.points)
        support_t = sum(nz(transform[i]) for i in range(count))
        support_s = sum(nz(target[i]) for i in range(count))
        t_only = sum(
            nz(transform[i]) and not nz(target[i]) for i in range(count)
        )
        s_only = sum(
            not nz(transform[i]) and nz(target[i]) for i in range(count)
        )
        ref = next(
            i for i in range(count) if nz(target[i]) and nz(transform[i])
        )
        proportional = t_only == 0 and s_only == 0 and all(
            self.reduce_phi(mul(transform[i], target[ref]))
            == self.reduce_phi(mul(transform[ref], target[i]))
            for i in range(count)
        )
        return {
            "proportional": proportional,
            "transform_support": support_t,
            "target_support": support_s,
            "transform_nonzero_where_target_zero": t_only,
            "target_nonzero_where_transform_zero": s_only,
        }


def modular_analysis(machine, embeddings, odd_sections, delta_sections):
    """Dims, directions, and nullity via modular embeddings; must agree."""
    results = []
    for emb in embeddings:
        p = emb.modulus

        def realize(section):
            return [
                sum(c * emb.powers[i] for i, c in enumerate(coeffs)) % p
                for coeffs in section
            ]

        odd_rows = [realize(s) for s in odd_sections]
        delta_rows = [realize(s) for s in delta_sections]
        dim_odd = emb.rank(odd_rows)
        dim_delta = emb.rank(delta_rows)
        vanishing = sum(not any(row) for row in odd_rows)
        nonzero = [row for row in odd_rows if any(row)]
        directions = []
        for row in nonzero:
            is_new = True
            for other in directions:
                ref = next(
                    i for i in range(len(row)) if row[i] or other[i]
                )
                if all(
                    row[i] * other[ref] % p == row[ref] * other[i] % p
                    for i in range(len(row))
                ):
                    is_new = False
                    break
            if is_new:
                directions.append(row)
        # nullity of T p = lambda d in coordinates
        def coords(rows):
            basis = []
            for row in rows:
                if emb.rank(basis + [row]) == len(basis) + 1:
                    basis.append(row)
            piv_cols = []
            work = [list(r) for r in basis]
            # find pivot columns of basis
            tmp = [list(r) for r in basis]
            pr = 0
            for c in range(len(tmp[0]) if tmp else 0):
                cand = next((r for r in range(pr, len(tmp)) if tmp[r][c] % p), None)
                if cand is None:
                    continue
                tmp[pr], tmp[cand] = tmp[cand], tmp[pr]
                iv = pow(tmp[pr][c], -1, p)
                tmp[pr] = [v * iv % p for v in tmp[pr]]
                for r in range(len(tmp)):
                    if r != pr and tmp[r][c] % p:
                        f = tmp[r][c]
                        tmp[r] = [(v - f * w) % p for v, w in zip(tmp[r], tmp[pr])]
                piv_cols.append(c)
                pr += 1
            out = []
            for row in rows:
                nb = len(basis)
                system = [
                    [basis[k][c] for k in range(nb)] + [row[c]] for c in piv_cols
                ]
                pr = 0
                for cc in range(nb):
                    cand = next(
                        (r for r in range(pr, len(system)) if system[r][cc] % p),
                        None,
                    )
                    assert cand is not None
                    system[pr], system[cand] = system[cand], system[pr]
                    iv = pow(system[pr][cc], -1, p)
                    system[pr] = [v * iv % p for v in system[pr]]
                    for r in range(len(system)):
                        if r != pr and system[r][cc] % p:
                            f = system[r][cc]
                            system[r] = [
                                (v - f * w) % p
                                for v, w in zip(system[r], system[pr])
                            ]
                    pr += 1
                out.append([system[r][nb] for r in range(nb)])
            return out, len(basis)

        source_coords, nb = coords(odd_rows)
        target_coords, nbd = coords(delta_rows)
        count = len(odd_rows)
        unknowns = nbd * nb + count
        rows = []
        for mi in range(count):
            for i in range(nbd):
                row = [0] * unknowns
                for j in range(nb):
                    row[i * nb + j] = source_coords[mi][j]
                row[nbd * nb + mi] = (-target_coords[mi][i]) % p
                rows.append(row)
        nullity = unknowns - emb.rank(rows)
        results.append(
            (dim_odd, dim_delta, vanishing, len(directions), nullity)
        )
    assert len(set(results)) == 1, results
    return results[0]


def secant_standard(endpoints, mp, prime):
    i, j = mp
    (s_i, t_i), (s_j, t_j) = endpoints[i], endpoints[j]
    return (
        t_i * t_j % prime,
        -(s_i * t_j + t_i * s_j) % prime,
        s_i * s_j % prime,
    )


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


def det_one(m, prime, cube_root_exponent):
    lam = pow(pow(det3(m, prime), -1, prime), cube_root_exponent, prime)
    out = tuple(tuple(lam * x % prime for x in row) for row in m)
    assert det3(out, prime) == 1
    return out


def replay_h3(c341, c406, primary):
    prime = 11
    scout = load_json(SCOUT_PATH, SCOUT_SHA256)
    record = next(r for r in scout["types"] if r["type"] == "H3")
    c406_cert = load_json(C406_CERT_PATH, C406_CERT_SHA256)
    c378 = load_json(C378_CERT_PATH, C378_CERT_SHA256)
    bridge = next(t for t in c406_cert["types"] if t["type"] == "H3")[
        "outer_sheet_sign"
    ]["c378_depth_fourier_bridge"]
    standard_to_h3 = bridge["standard_to_h3_projectivity"]

    conic, params = c406.C399.conic_parameterization(prime)
    endpoints = tuple(params)
    full_group, psl_group = c406.full_pgl(prime, endpoints)
    base = tuple(tuple(p) for p in record["coxeter_invariant_matching"])
    matchings = sorted({c406.matching_image(g, base) for g in full_group})
    plus = sorted({c406.matching_image(g, base) for g in psl_group})
    conic_index = {pt: i for i, pt in enumerate(conic)}
    j_action = tuple(
        conic_index[
            norm3(matvec(c378["golden_map_J"], tuple(pt), prime), prime)
        ]
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
    machine = Machine(
        prime,
        10,
        2,
        points,
        lambda x, y: sum(a * b for a, b in zip(x, y)) % prime,
        lambda functional: functional,
    )

    def secant_h3(mp):
        line = secant_standard(endpoints, mp, prime)
        # functional in H3 frame: ell(std) = ell(h3_to_standard x) means the
        # H3 functional is standard_to_h3^T applied to ell... transport by
        # x_std = h3_to_standard x_h3, so functional_h3 = h3_to_standard^T l.
        h3_to_standard = c406.matrix_inverse(standard_to_h3, prime)
        return tuple(
            sum(h3_to_standard[r][c] * line[r] for r in range(3)) % prime
            for c in range(3)
        )

    # lemma on all secants at the factorization weights
    secants = [
        secant_h3(mp) for mp in itertools.combinations(range(prime + 1), 2)
    ]
    for functional in secants:
        for r in (4, 6):
            machine.check_lemma(functional, r)

    # intertwiner for every matching
    for matching in matchings:
        lines = [secant_h3(mp) for mp in matching]
        for r in (4, 6):
            transform = machine.kernel_apply(r, machine.power_sum(lines, r))
            expected = machine.scaled(
                prime * prime, machine.pole_delta(lines, r)
            )
            assert machine.section_eq(transform, expected)

    # golden A4 from the frozen C378 reflection groups (matrix route)
    plus_group, labels, _ = c406.C378.scheme(c341, 8)
    minus_group, minus_labels, _ = c406.C378.scheme(c341, 4)
    assert labels == minus_labels
    common = plus_group & minus_group
    assert len(common) == 12
    lifts = [det_one(matrix, prime, 7) for matrix in sorted(common)]
    j_lift = det_one(tuple(tuple(r) for r in c378["golden_map_J"]), prime, 7)

    # sections in the H3 frame: evaluate polynomials on transported points
    h3_to_standard = c406.matrix_inverse(standard_to_h3, prime)
    basis4 = c406.homogeneous_basis(4)
    prodpoly = {
        m: c406.matching_product(m, endpoints, prime) for m in matchings
    }
    odd_power, odd_delta = [], []
    defect_rows = []
    for matching in plus:
        jm = c406.matching_image(j_action, matching)
        difference = sub_polys(prodpoly[matching], prodpoly[jm], prime)
        quotient_vec = c406.quotient_by_conic(difference, 4, prime)
        quotient_poly = {e: c for e, c in zip(basis4, quotient_vec) if c}

        def std_pt(pt):
            return tuple(
                sum(h3_to_standard[r][c] * pt[c] for c in range(3)) % prime
                for r in range(3)
            )

        section_f = machine.coeff_section_from_exponents(
            [
                None
                if evalpoly(quotient_poly, std_pt(pt), prime) == 0
                else machine.log[evalpoly(quotient_poly, std_pt(pt), prime)]
                for pt in points
            ]
        )
        section_g = machine.coeff_section_from_exponents(
            [
                None
                if evalpoly(difference, std_pt(pt), prime) == 0
                else machine.log[evalpoly(difference, std_pt(pt), prime)]
                for pt in points
            ]
        )
        forward = machine.proportionality_record(
            machine.kernel_apply(4, section_f), section_g
        )
        backward = machine.proportionality_record(
            machine.kernel_apply(6, section_g), section_f
        )
        defect_rows.append((forward, backward))
        odd_quotient = machine.odd_part(
            j_lift, machine.symmetrize(lifts, section_f, 4), 4
        )
        assert machine.section_is_zero(odd_quotient)
        lines = [secant_h3(mp) for mp in matching]
        odd_power.append(
            machine.odd_part(
                j_lift,
                machine.symmetrize(lifts, machine.power_sum(lines, 4), 4),
                4,
            )
        )
        odd_delta.append(
            machine.odd_part(
                j_lift,
                machine.symmetrize(lifts, machine.pole_delta(lines, 4), 6),
                6,
            )
        )

    expected_pairs = primary["H3"]["golden_pairs"]
    assert [
        (row["forward"], row["backward"]) for row in expected_pairs
    ] == defect_rows

    embeddings = [ModularZeta(10, 31), ModularZeta(10, 41)]
    dim_odd, dim_delta, vanishing, directions, nullity = modular_analysis(
        machine, embeddings, odd_power, odd_delta
    )
    h3_summary = primary["H3"]
    assert dim_odd == h3_summary["odd_power_sum_span_dimension"]
    assert dim_delta == h3_summary["odd_pole_delta_span_dimension"]
    assert vanishing == h3_summary["isolation"]["vanishing_sections"]
    assert directions == h3_summary["isolation"]["distinct_directions"]
    assert nullity == h3_summary["isolation"]["nullity"]
    print("H3 replay OK (H3 frame, dot polarity, modular ranks at 31/41)")


def replay_b3(c341, c406, primary):
    prime = 7
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
    gram = ((0, 0, 1), (0, (-2) % prime, 0), (1, 0, 0))
    gram_inv = (
        (0, 0, 1),
        (0, pow((-2) % prime, -1, prime), 0),
        (1, 0, 0),
    )
    machine = Machine(
        prime,
        6,
        3,
        points,
        lambda x, y: sum(
            gram[i][j] * x[i] * y[j] for i in range(3) for j in range(3)
        )
        % prime,
        lambda functional: matvec(gram_inv, functional, prime),
    )

    # lemma on every line and intertwiner on every matching, native frame
    for functional in points:
        for r in (2, 4):
            machine.check_lemma(functional, r)

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
    matchings = sorted({c406.matching_image(g, base) for g in full_group})
    plus = sorted({c406.matching_image(g, base) for g in psl_group})
    for matching in matchings:
        lines = [
            secant_standard(endpoints, mp, prime) for mp in matching
        ]
        for r in (2, 4):
            transform = machine.kernel_apply(r, machine.power_sum(lines, r))
            expected = machine.scaled(
                prime * prime, machine.pole_delta(lines, r)
            )
            assert machine.section_eq(transform, expected)

    # seam families in the standard frame via conjugated SO3 lifts
    base_stab = frozenset(
        g for g in full_group if c406.matching_image(g, base) == base
    )

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
    std_conic = [
        (l * l % prime, l * r % prime, r * r % prime) for l, r in endpoints
    ]
    s2c = c341.frame_map(std_conic[:4], conic[:4], prime)
    c2s = c406.matrix_inverse(s2c, prime)

    def so3_std(perm):
        matrix = c341.frame_map(
            conic[:4], [conic[perm[i]] for i in range(4)], prime
        )
        gm = c341.mat_mul(tuple(zip(*matrix)), matrix, prime)
        mult = gm[0][0]
        scalar = mult * pow(det3(matrix, prime), -1, prime) % prime
        lift = tuple(tuple(scalar * e % prime for e in row) for row in matrix)
        assert det3(lift, prime) == 1
        # conjugate into the standard frame
        inner = tuple(
            tuple(
                sum(lift[i][k] * s2c[k][j] for k in range(3)) % prime
                for j in range(3)
            )
            for i in range(3)
        )
        conjugated = tuple(
            tuple(
                sum(c2s[i][k] * inner[k][j] for k in range(3)) % prime
                for j in range(3)
            )
            for i in range(3)
        )
        assert det3(conjugated, prime) == 1
        return conjugated

    embeddings = [ModularZeta(6, 13), ModularZeta(6, 31)]
    basis2 = c406.homogeneous_basis(2)
    prodpoly = {
        m: c406.matching_product(m, endpoints, prime) for m in matchings
    }
    for seam_index, other in enumerate(opposite):
        common = set(base_stab) & set(other)
        seam_record = primary["B3"]["seams"][seam_index]
        assert seam_record["common_group_order"] == len(common)
        swaps = sorted(
            e
            for e in full_group - psl_group
            if conjugate(e, frozenset(base_stab)) == other
            and conjugate(e, other) == frozenset(base_stab)
            and c406.compose(e, e) == identity
        )
        lifts = [so3_std(g) for g in sorted(common)]
        for exchange_index, exchange in enumerate(swaps):
            summary = seam_record["exchanges"][exchange_index]
            assert summary["exchange_permutation"] == list(exchange)
            exchange_lift = so3_std(exchange)
            odd_power, odd_delta = [], []
            defects = []
            quotient_zero = True
            for matching in plus:
                tm = c406.matching_image(exchange, matching)
                lines = [
                    secant_standard(endpoints, mp, prime) for mp in matching
                ]
                odd_power.append(
                    machine.odd_part(
                        exchange_lift,
                        machine.symmetrize(
                            lifts, machine.power_sum(lines, 2), 2
                        ),
                        2,
                    )
                )
                odd_delta.append(
                    machine.odd_part(
                        exchange_lift,
                        machine.symmetrize(
                            lifts, machine.pole_delta(lines, 2), 4
                        ),
                        4,
                    )
                )
                difference = sub_polys(
                    prodpoly[matching], prodpoly[tm], prime
                )
                quotient_vec = c406.quotient_by_conic(difference, 2, prime)
                quotient_poly = {
                    e: c for e, c in zip(basis2, quotient_vec) if c
                }
                section_f = machine.coeff_section_from_exponents(
                    [
                        None
                        if evalpoly(quotient_poly, pt, prime) == 0
                        else machine.log[evalpoly(quotient_poly, pt, prime)]
                        for pt in points
                    ]
                )
                section_g = machine.coeff_section_from_exponents(
                    [
                        None
                        if evalpoly(difference, pt, prime) == 0
                        else machine.log[evalpoly(difference, pt, prime)]
                        for pt in points
                    ]
                )
                defects.append(
                    machine.proportionality_record(
                        machine.kernel_apply(2, section_f), section_g
                    )
                )
                odd_quotient = machine.odd_part(
                    exchange_lift,
                    machine.symmetrize(lifts, section_f, 2),
                    2,
                )
                if not machine.section_is_zero(odd_quotient):
                    quotient_zero = False
            assert quotient_zero
            assert defects == summary["forward_proportionality"]
            dim_odd, dim_delta, vanishing, directions, nullity = (
                modular_analysis(machine, embeddings, odd_power, odd_delta)
            )
            assert dim_odd == summary["odd_power_sum_span_dimension"]
            assert dim_delta == summary["odd_pole_delta_span_dimension"]
            assert vanishing == summary["vanishing_odd_sections"]
            assert directions == summary["distinct_directions"]
            assert nullity == summary["isolation_nullity"]
    print("B3 replay OK (standard frame, polar Gram, modular ranks at 13/31)")


def main():
    primary = json.loads(PRIMARY_JSON.read_text())
    assert primary["schema"] == "c416-twisted-power-sum-duality-v1"
    c341 = load_module("c341_for_c416_replay", C341_PATH, C341_SHA256)
    c406 = load_module("c406_for_c416_replay", C406_PATH, C406_SHA256)
    replay_h3(c341, c406, primary)
    replay_b3(c341, c406, primary)
    print("C416 independent replay OK")


if __name__ == "__main__":
    main()
