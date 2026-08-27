#!/usr/bin/env python3
"""Orbit-reduced bounded-field calibration for REDUNDANCY_SEVEN_CALIBRATION (redundancy seven).

A sextic f=(a0,...,a6) can only be deep when its infinity contraction
(a0,...,a5) is pointed-bad for REDUNDANCY_SIX.  We enumerate that five-dimensional
pointed locus, append a6, and test all q+1 contractions.  Thus the program
never scans PG(6,q).

For q < 16 the pointed locus is independently built as the complement of
the four-finite-secant union.  For q >= 16 it fixes the marked point at
infinity, enumerates PG(5,q) modulo its affine PGL2 stabilizer, tests one
representative per orbit, and expands only the pointed-bad orbits.  The
optional verification compares this orbit reduction with the full pointed
complement at q=16,17.
"""

import argparse
import concurrent.futures
import importlib.util
import itertools
import json
import math
import os
import time
from pathlib import Path


HERE = Path(__file__).resolve().parent
REDUNDANCY_SIX_PATH = HERE / "2026-07-22-redundancy-six-deep-hole-replay.py"
SPEC = importlib.util.spec_from_file_location("redundancy_six_replay", REDUNDANCY_SIX_PATH)
REDUNDANCY_SIX = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(REDUNDANCY_SIX)
REDUNDANCY_SIX.MODULI.setdefault(4, (2, [1, 1]))
REDUNDANCY_SIX.MODULI.setdefault(32, (2, [1, 0, 1, 0, 0]))  # x^5=x^2+1


def curve(F, degree):
    out = []
    for t in range(F.q):
        row = [1]
        for _ in range(degree):
            row.append(F.mul(row[-1], t))
        out.append(tuple(row))
    out.append(tuple([0] * degree + [1]))
    return out


def lincomb(F, coefficients, rows):
    out = [0] * len(rows[0])
    for coefficient, row in zip(coefficients, rows):
        if coefficient:
            for j, value in enumerate(row):
                out[j] = F.add(out[j], F.mul(coefficient, value))
    return tuple(out)


def sym_matrix(F, g, degree):
    alpha, beta, gamma, delta = g
    out = [[0] * (degree + 1) for _ in range(degree + 1)]
    for i in range(degree + 1):
        left = [1]
        right = [1]
        for _ in range(i):
            left = REDUNDANCY_SIX.poly_mul(F, left, [beta, alpha])
        for _ in range(degree - i):
            right = REDUNDANCY_SIX.poly_mul(F, right, [delta, gamma])
        for j, value in enumerate(REDUNDANCY_SIX.poly_mul(F, left, right)):
            out[i][j] = value
    return out


def decode(F, code, length):
    out = [0] * length
    for i in range(length - 1, -1, -1):
        out[i] = code % F.q
        code //= F.q
    return tuple(out)


def catalecticant_rank5(F, v):
    return REDUNDANCY_SIX.matrix_rank(F, [v[0:4], v[1:5], v[2:6]])


def persistent5(F):
    """REDUNDANCY_SIX tangent and conjugate-sigma points via their quadratic recurrence."""
    quadratics = []
    # Repeated finite roots and the repeated root at infinity.
    for r in range(F.q):
        quadratics.append(
            (
                F.mul(r, r),
                F.neg(F.add(r, r)),
                1,
            )
        )
    quadratics.append((1, 0, 0))
    # Monic irreducible finite quadratics.
    for b in range(F.q):
        for c in range(F.q):
            if all(F.add(F.add(F.mul(x, x), F.mul(b, x)), c) != 0 for x in range(F.q)):
                quadratics.append((c, b, 1))

    out = set()
    for q0, q1, q2 in quadratics:
        rows = []
        for shift in range(4):
            row = [0] * 6
            row[shift : shift + 3] = [q0, q1, q2]
            rows.append(row)
        basis = REDUNDANCY_SIX.nullspace(F, rows, 6)
        assert len(basis) == 2
        for coefficients in REDUNDANCY_SIX.pg_points(F.q, 2):
            v = REDUNDANCY_SIX.canon(F, lincomb(F, coefficients, basis))
            if catalecticant_rank5(F, v) == 2:
                out.add(REDUNDANCY_SIX.encode(F, v))
    assert len(out) == F.q * (F.q + 1) ** 2 // 2
    return out


def marked_secant_star(F):
    points = curve(F, 5)
    infinity = points[-1]
    out = {REDUNDANCY_SIX.encode(F, infinity)}
    for finite in points[:-1]:
        for coefficient in range(1, F.q):
            v = tuple(
                F.add(x, F.mul(coefficient, y))
                for x, y in zip(infinity, finite)
            )
            out.add(REDUNDANCY_SIX.encode(F, REDUNDANCY_SIX.canon(F, v)))
    assert len(out) == F.q * F.q - F.q + 1
    return out


def nucleus5(F):
    if F.p != 2 or F.m % 2 == 0:
        return set()
    return {
        REDUNDANCY_SIX.encode(F, v)
        for v in REDUNDANCY_SIX.pg_points(F.q, 6)
        if all(v[j] == 0 for j in (0, 1, 4, 5))
        and any(v[j] != 0 for j in (2, 3))
    }


def pointed_bad_formula(F):
    return persistent5(F) | marked_secant_star(F) | nucleus5(F)


def pointed_bad_by_net(F, v, net_coefficients):
    basis = REDUNDANCY_SIX.hankel_net(F, v)
    for coefficients in net_coefficients[len(basis)]:
        member = lincomb(F, coefficients, basis)
        # Avoiding infinity means a genuine degree-four affine polynomial.
        if member[0] != 0 and REDUNDANCY_SIX.split_squarefree(F, member):
            return False
    return True


def affine_orbit_representatives(F):
    """Canonical PG(5,q) representatives under t -> a*t+b."""
    powers = {
        a: tuple(F.pow(a, exponent) for exponent in range(6))
        for a in range(F.q)
    }
    binomial = [
        [math.comb(i, j) % F.p for j in range(i + 1)]
        for i in range(6)
    ]

    def scale(v, first_index, a):
        ap = powers[a]
        return v[:first_index] + tuple(
            F.mul(v[i], ap[i - first_index])
            for i in range(first_index, 6)
        )

    def translate(v, first_index, b):
        bp = powers[b]
        out = [0] * first_index
        for i in range(first_index, 6):
            value = 0
            for j in range(first_index, i + 1):
                coefficient = binomial[i][j]
                if coefficient and v[j]:
                    term = F.mul(coefficient, F.mul(bp[i - j], v[j]))
                    value = F.add(value, term)
            out.append(value)
        return tuple(out)

    def translate_min(v, first_index):
        return min(
            REDUNDANCY_SIX.encode(F, translate(v, first_index, b))
            for b in range(F.q)
        )

    def affine_min(v, first_index):
        if first_index == 0:
            # The unique translation slice v1=0 is preserved by scaling.
            return min(
                REDUNDANCY_SIX.encode(F, scale(v, first_index, a))
                for a in range(1, F.q)
            )
        return min(
            translate_min(scale(v, first_index, a), first_index)
            for a in range(1, F.q)
        )

    representatives = []
    # When v0 != 0, translation uniquely produces the slice v=(1,0,*,*,*,*).
    for tail in itertools.product(range(F.q), repeat=4):
        v = (1, 0) + tail
        code = REDUNDANCY_SIX.encode(F, v)
        if code == affine_min(v, 0):
            representatives.append(v)
    # Lower triangular strata.  When k+1 is invertible, translation uniquely
    # kills v_(k+1), giving a direct slice.  The only large modular case is
    # k=1 in characteristic two; there v3 changes by b^2+v2*b, so two additive
    # coset representatives suffice.
    for first_index in range(1, 6):
        prefix = (0,) * first_index + (1,)
        if first_index < 5 and (first_index + 1) % F.p != 0:
            sliced_prefix = prefix + (0,)
            for tail in itertools.product(range(F.q), repeat=4 - first_index):
                v = sliced_prefix + tail
                code = REDUNDANCY_SIX.encode(F, v)
                scale_min = min(
                    REDUNDANCY_SIX.encode(F, scale(v, first_index, a))
                    for a in range(1, F.q)
                )
                if code == scale_min:
                    representatives.append(v)
            continue
        if first_index == 1 and F.p == 2:
            for v2 in range(F.q):
                image = {
                    F.add(F.mul(b, b), F.mul(v2, b))
                    for b in range(F.q)
                }
                unseen = set(range(F.q))
                coset_representatives = []
                while unseen:
                    representative = min(unseen)
                    coset = {F.add(representative, x) for x in image}
                    coset_representatives.append(representative)
                    unseen -= coset
                for v3 in coset_representatives:
                    for tail in itertools.product(range(F.q), repeat=2):
                        v = prefix + (v2, v3) + tail
                        code = REDUNDANCY_SIX.encode(F, v)
                        if code != translate_min(v, first_index):
                            continue
                        if code == affine_min(v, first_index):
                            representatives.append(v)
            continue
        for tail in itertools.product(range(F.q), repeat=5 - first_index):
            v = prefix + tail
            code = REDUNDANCY_SIX.encode(F, v)
            if code != translate_min(v, first_index):
                continue
            if code == affine_min(v, first_index):
                representatives.append(v)
    return representatives


def pointed_bad_affine_orbits(F):
    profile = os.environ.get("REDUNDANCY_SEVEN_CALIBRATION_PROF")
    started = time.monotonic()
    representatives = affine_orbit_representatives(F)
    if profile:
        print(
            f"q={F.q} affine representatives={len(representatives)} "
            f"time={time.monotonic()-started:.2f}s",
            flush=True,
        )
    powers = {
        a: tuple(F.pow(a, exponent) for exponent in range(6))
        for a in range(F.q)
    }
    binomial = [
        [math.comb(i, j) % F.p for j in range(i + 1)]
        for i in range(6)
    ]

    def scale(v, first_index, a):
        ap = powers[a]
        return v[:first_index] + tuple(
            F.mul(v[i], ap[i - first_index])
            for i in range(first_index, 6)
        )

    def translate(v, first_index, b):
        bp = powers[b]
        out = [0] * first_index
        for i in range(first_index, 6):
            value = 0
            for j in range(first_index, i + 1):
                coefficient = binomial[i][j]
                if coefficient and v[j]:
                    value = F.add(
                        value,
                        F.mul(coefficient, F.mul(bp[i - j], v[j])),
                    )
            out.append(value)
        return tuple(out)

    def canonical_affine_code(v):
        v = REDUNDANCY_SIX.canon(F, v)
        first_index = next(i for i, x in enumerate(v) if x)
        if first_index == 0:
            # Translation has the unique slice v1=0.
            v = translate(v, 0, F.neg(v[1]))
            return min(
                REDUNDANCY_SIX.encode(F, scale(v, 0, a))
                for a in range(1, F.q)
            )
        return min(
            REDUNDANCY_SIX.encode(F, translate(scale(v, first_index, a), first_index, b))
            for a in range(1, F.q)
            for b in range(F.q)
        )

    # Four finite roots modulo the affine stabilizer of infinity.
    root_orbits = set()
    for roots in itertools.combinations(range(F.q), 4):
        normal_forms = []
        for x in roots:
            for y in roots:
                if x == y:
                    continue
                inverse = F.inv(F.sub(y, x))
                normal_forms.append(
                    tuple(
                        sorted(F.mul(F.sub(z, x), inverse) for z in roots)
                    )
                )
        root_orbits.add(min(normal_forms))
    if profile:
        print(
            f"q={F.q} root orbits={len(root_orbits)} "
            f"time={time.monotonic()-started:.2f}s",
            flush=True,
        )

    finite_curve = curve(F, 5)[:-1]
    shallow_representatives = set()
    coefficients = list(REDUNDANCY_SIX.pg_points(F.q, 4))
    for roots in sorted(root_orbits):
        rows = [finite_curve[root] for root in roots]
        for cs in coefficients:
            shallow_representatives.add(
                canonical_affine_code(lincomb(F, cs, rows))
            )
    if profile:
        print(
            f"q={F.q} shallow affine orbits={len(shallow_representatives)} "
            f"time={time.monotonic()-started:.2f}s",
            flush=True,
        )
    bad_representatives = [
        v
        for v in representatives
        if REDUNDANCY_SIX.encode(F, v) not in shallow_representatives
    ]
    matrices = [
        sym_matrix(F, (a, b, 0, 1), 5)
        for a in range(1, F.q)
        for b in range(F.q)
    ]
    out = set()
    for v in bad_representatives:
        for matrix in matrices:
            image = REDUNDANCY_SIX.canon(F, REDUNDANCY_SIX.matvec(F, matrix, v))
            out.add(REDUNDANCY_SIX.encode(F, image))
    if profile:
        print(
            f"q={F.q} pointed-bad affine orbits={len(bad_representatives)} "
            f"time={time.monotonic()-started:.2f}s",
            flush=True,
        )
    return (
        out,
        len(representatives),
        len(bad_representatives),
        sorted(REDUNDANCY_SIX.encode(F, v) for v in bad_representatives),
    )


def pointed_bad_exhaustive(F):
    """No split squarefree quartic supported on the q finite marked points."""
    finite = curve(F, 5)[:-1]
    coefficients = list(REDUNDANCY_SIX.pg_points(F.q, 4))
    marked = set()
    for indices in itertools.combinations(range(F.q), 4):
        rows = [finite[i] for i in indices]
        for cs in coefficients:
            marked.add(REDUNDANCY_SIX.encode(F, REDUNDANCY_SIX.canon(F, lincomb(F, cs, rows))))
    return {
        REDUNDANCY_SIX.encode(F, v)
        for v in REDUNDANCY_SIX.pg_points(F.q, 6)
        if REDUNDANCY_SIX.encode(F, v) not in marked
    }


def pointed_sets(F, base):
    """Transport the infinity-pointed locus to every marked point."""
    sets = []
    for r in range(F.q):
        matrix = sym_matrix(F, (r, 1, 1, 0), 5)
        sets.append(
            {
                REDUNDANCY_SIX.encode(F, REDUNDANCY_SIX.canon(F, REDUNDANCY_SIX.matvec(F, matrix, decode(F, x, 6))))
                for x in base
            }
        )
    sets.append(base)
    return sets


def contraction(F, sextic, r):
    if r == F.q:
        return sextic[:6]
    return tuple(
        F.sub(sextic[j + 1], F.mul(r, sextic[j]))
        for j in range(6)
    )


def orbit6(F, start):
    generators = [
        sym_matrix(F, (0, 1, 1, 0), 6),
        sym_matrix(F, (1, 1, 0, 1), 6),
        sym_matrix(F, (F.gen, 0, 0, 1), 6),
    ]
    seen = {REDUNDANCY_SIX.encode(F, REDUNDANCY_SIX.canon(F, start))}
    todo = [REDUNDANCY_SIX.canon(F, start)]
    while todo:
        v = todo.pop()
        for matrix in generators:
            w = REDUNDANCY_SIX.canon(F, REDUNDANCY_SIX.matvec(F, matrix, v))
            iw = REDUNDANCY_SIX.encode(F, w)
            if iw not in seen:
                seen.add(iw)
                todo.append(w)
    return seen


def persistent6(F, v):
    rank = REDUNDANCY_SIX.matrix_rank(F, [v[0:5], v[1:6], v[2:7]])
    if rank != 2:
        return False
    # Rank-two rational split secants and rank-one points are shallow.
    points = curve(F, 6)
    for i in range(len(points)):
        for j in range(i + 1, len(points)):
            if REDUNDANCY_SIX.matrix_rank(F, [points[i], points[j], v]) <= 2:
                return False
    return True


def deep_by_quintic_web(F, v):
    basis_low = REDUNDANCY_SIX.nullspace(F, [v[:6], v[1:]], 6)
    basis = [tuple(reversed(row)) for row in basis_low]
    for coefficients in REDUNDANCY_SIX.pg_points(F.q, len(basis)):
        member = lincomb(F, coefficients, basis)
        leading_zeros = next((i for i, x in enumerate(member) if x), 6)
        if leading_zeros >= 2:
            continue
        degree = 5 - leading_zeros
        roots = 0
        for x in range(F.q):
            value = 0
            for coefficient in member[leading_zeros:]:
                value = F.add(F.mul(value, x), coefficient)
            roots += value == 0
        if roots == degree:
            return False
    return True


def census_field(q, verify_pointed):
    F = REDUNDANCY_SIX.GF(q)
    if q < 16:
        base = pointed_bad_exhaustive(F)
        method = "full pointed complement"
        affine_orbit_count = None
        pointed_bad_affine_orbit_count = None
        pointed_bad_affine_representatives = None
    else:
        (
            base,
            affine_orbit_count,
            pointed_bad_affine_orbit_count,
            pointed_bad_affine_representatives,
        ) = pointed_bad_affine_orbits(F)
        method = "exact affine-stabilizer orbit reduction"
        if q in verify_pointed:
            exact = pointed_bad_exhaustive(F)
            assert base == exact, (q, len(base), len(exact), len(base ^ exact))

    bad = pointed_sets(F, base)
    deep = set()
    for xcode in sorted(base):
        x = decode(F, xcode, 6)
        for last in range(q):
            sextic = tuple(x) + (last,)
            if all(
                REDUNDANCY_SIX.encode(F, REDUNDANCY_SIX.canon(F, contraction(F, sextic, r))) in bad[r]
                for r in range(q + 1)
            ):
                deep.add(REDUNDANCY_SIX.encode(F, REDUNDANCY_SIX.canon(F, sextic)))
    # The one point whose infinity contraction vanishes.
    e6 = tuple([0] * 6 + [1])
    if all(
        REDUNDANCY_SIX.encode(F, REDUNDANCY_SIX.canon(F, contraction(F, e6, r))) in bad[r]
        for r in range(q)
    ):
        deep.add(REDUNDANCY_SIX.encode(F, e6))

    unseen = set(deep)
    records = []
    point_to_rep = {}
    while unseen:
        representative = min(unseen)
        component = orbit6(F, decode(F, representative, 7))
        assert component <= deep
        unseen -= component
        for point in component:
            point_to_rep[point] = representative
        v = decode(F, representative, 7)
        direct = deep_by_quintic_web(F, v)
        assert direct
        central = v == tuple([0, 0, 0, 1, 0, 0, 0])
        records.append(
            {
                "representative": list(v),
                "representative_index": representative,
                "size": len(component),
                "stabilizer_order": (q ** 3 - q) // len(component),
                "persistent": persistent6(F, v),
                "central_nucleus": central,
            }
        )
    for row in records:
        v = decode(F, row["representative_index"], 7)
        fv = tuple(F.pow(x, F.p) for x in v)
        row["frobenius_to_representative_index"] = point_to_rep[
            REDUNDANCY_SIX.encode(F, REDUNDANCY_SIX.canon(F, fv))
        ]
    records.sort(key=lambda row: (row["size"], row["representative_index"]))
    frobenius = {
        row["representative_index"]: row["frobenius_to_representative_index"]
        for row in records
    }
    unseen_representatives = set(frobenius)
    pgammal_orbit_count = 0
    while unseen_representatives:
        pgammal_orbit_count += 1
        current = unseen_representatives.pop()
        while frobenius[current] in unseen_representatives:
            current = frobenius[current]
            unseen_representatives.remove(current)
    persistent_count = q * (q + 1) ** 2 // 2
    expected_central = F.p == 2 and F.m % 2 == 1
    exceptional_count = sum(
        row["size"]
        for row in records
        if not row["persistent"] and not row["central_nucleus"]
    )
    return {
        "q": q,
        "p": F.p,
        "m": F.m,
        "pointed_method": method,
        "pointed_bad_count": len(base),
        "affine_orbit_count": affine_orbit_count,
        "pointed_bad_affine_orbit_count": pointed_bad_affine_orbit_count,
        "pointed_bad_affine_representatives": pointed_bad_affine_representatives,
        "candidate_count": len(base) * q + 1,
        "deep_count": len(deep),
        "persistent_count": persistent_count,
        "central_nucleus_expected": expected_central,
        "exceptional_count": exceptional_count,
        "pgl_orbit_count": len(records),
        "pgammal_orbit_count": pgammal_orbit_count,
        "orbits": records,
    }


def census_field_star(arguments):
    return census_field(*arguments)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--fields",
        default="7,8,9,11,13,16,17,19,23,25,27,29,31,32",
    )
    parser.add_argument("--verify-pointed", default="16,17")
    parser.add_argument("--output")
    parser.add_argument("--jobs", type=int, default=1)
    parser.add_argument(
        "--check",
        action="store_true",
        help="compare regenerated output with --output instead of writing it",
    )
    args = parser.parse_args()
    verify = {int(q) for q in args.verify_pointed.split(",") if q}
    fields = list(map(int, args.fields.split(",")))
    work = [(q, verify) for q in fields]
    if args.jobs == 1:
        records = [census_field_star(item) for item in work]
    else:
        with concurrent.futures.ProcessPoolExecutor(max_workers=args.jobs) as executor:
            records = list(executor.map(census_field_star, work))
    for q, record in zip(fields, records):
        print(
            f"q={q}: pointed={record['pointed_bad_count']} "
            f"candidates={record['candidate_count']} deep={record['deep_count']} "
            f"PGL_orbits={record['pgl_orbit_count']} "
            f"PGammaL_orbits={record['pgammal_orbit_count']} "
            f"exceptional={record['exceptional_count']}",
            flush=True,
        )
    payload = {
        "schema": "redundancy_seven_calibration-prs-redundancy-seven-calibration-v1",
        "fields": records,
    }
    text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.output:
        output_path = Path(args.output)
        if args.check:
            assert output_path.read_text() == text
            print(f"{output_path}: content check PASS")
        else:
            output_path.write_text(text)
    else:
        assert not args.check, "--check requires --output"
        print(text)


if __name__ == "__main__":
    main()
