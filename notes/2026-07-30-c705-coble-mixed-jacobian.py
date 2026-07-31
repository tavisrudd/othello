#!/usr/bin/env python3
"""Exact finite-field probe of the Coble cubic/sextic dual pair.

The coordinate convention is Nguyen, equation (5), multiplied by 3:

    F = a0 sum X_b^3 + 6 sum_direction a_direction prod_{b in line} X_b.

In Nguyen's coefficient normalization the five parameters lie on the
Burkhardt quartic

    a0^4 + 8 a0 sum_i ai^3 + 48 a1 a2 a3 a4 = 0.

For the fixed smooth rational Burkhardt point (6,17,1,-7,-19), this script reconstructs
the dual Coble sextic over F_101 in the 43-dimensional Heisenberg-invariant
degree-six space.  It then checks a full-rank Hessian witness on the dual
sextic, the tau-plus Hessian compression, and the tau-minus Weddle
ramification determinant.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path

P = 101
ALPHA = (6, 17, 1, -7, -19)
STEM = Path(__file__).with_suffix("")
JSON_PATH = STEM.with_suffix(".json")


def add_term(poly, exp, coeff):
    coeff %= P
    if coeff:
        poly[exp] = (poly.get(exp, 0) + coeff) % P
        if not poly[exp]:
            del poly[exp]


def monomial(indices):
    exp = [0] * 9
    for i in indices:
        exp[i] += 1
    return tuple(exp)


def coble_cubic():
    poly = {}
    for i in range(9):
        exp = [0] * 9
        exp[i] = 3
        add_term(poly, tuple(exp), ALPHA[0])
    line_families = [
        [(3 * r, 3 * r + 1, 3 * r + 2) for r in range(3)],
        [(c, 3 + c, 6 + c) for c in range(3)],
        [(0, 4, 8), (1, 5, 6), (2, 3, 7)],
        [(0, 5, 7), (1, 3, 8), (2, 4, 6)],
    ]
    for a, lines in zip(ALPHA[1:], line_families):
        for line in lines:
            add_term(poly, monomial(line), 6 * a)
    return poly


def eval_poly(poly, x):
    total = 0
    for exp, coeff in poly.items():
        term = coeff
        for xi, ei in zip(x, exp):
            if ei:
                term = term * pow(xi, ei, P) % P
        total = (total + term) % P
    return total


def derivative(poly, i):
    out = {}
    for exp, coeff in poly.items():
        if exp[i]:
            ee = list(exp)
            c = coeff * ee[i]
            ee[i] -= 1
            add_term(out, tuple(ee), c)
    return out


def gradient(poly, x):
    return tuple(eval_poly(derivative(poly, i), x) for i in range(9))


def hessian(poly, x):
    ds = [derivative(poly, i) for i in range(9)]
    return [
        [eval_poly(derivative(ds[i], j), x) for j in range(9)]
        for i in range(9)
    ]


def mat_det(a):
    a = [row[:] for row in a]
    det = 1
    for c in range(len(a)):
        pivot = next((r for r in range(c, len(a)) if a[r][c] % P), None)
        if pivot is None:
            return 0
        if pivot != c:
            a[c], a[pivot] = a[pivot], a[c]
            det = -det
        det = det * a[c][c] % P
        inv = pow(a[c][c], P - 2, P)
        for r in range(c + 1, len(a)):
            q = a[r][c] * inv % P
            if q:
                for j in range(c, len(a)):
                    a[r][j] = (a[r][j] - q * a[c][j]) % P
    return det % P


def mat_rank(a):
    a = [row[:] for row in a]
    rank = 0
    for c in range(len(a[0]) if a else 0):
        pivot = next((r for r in range(rank, len(a)) if a[r][c] % P), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        inv = pow(a[rank][c], P - 2, P)
        a[rank] = [v * inv % P for v in a[rank]]
        for r in range(len(a)):
            if r != rank and a[r][c]:
                q = a[r][c]
                a[r] = [(u - q * v) % P for u, v in zip(a[r], a[rank])]
        rank += 1
        if rank == len(a):
            break
    return rank


def minor(a, row, col):
    return [[x for j, x in enumerate(r) if j != col] for i, r in enumerate(a) if i != row]


def adjugate(a):
    n = len(a)
    return [
        [((-1) ** (i + j) * mat_det(minor(a, j, i))) % P for j in range(n)]
        for i in range(n)
    ]


def nullvector(a):
    a = [row[:] for row in a]
    rows, cols = len(a), len(a[0])
    pivots = []
    r = 0
    for c in range(cols):
        pivot = next((i for i in range(r, rows) if a[i][c] % P), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        inv = pow(a[r][c], P - 2, P)
        a[r] = [v * inv % P for v in a[r]]
        for i in range(rows):
            if i != r and a[i][c]:
                q = a[i][c]
                a[i] = [(u - q * v) % P for u, v in zip(a[i], a[r])]
        pivots.append(c)
        r += 1
        if r == rows:
            break
    free = [c for c in range(cols) if c not in pivots]
    if len(free) != 1:
        raise AssertionError(f"expected nullity one, got {len(free)}")
    v = [0] * cols
    v[free[0]] = 1
    for i in range(len(pivots) - 1, -1, -1):
        c = pivots[i]
        v[c] = -sum(a[i][j] * v[j] for j in free) % P
    first = next(x for x in v if x)
    inv = pow(first, P - 2, P)
    return [x * inv % P for x in v], len(pivots)


def weak_compositions(total, slots, prefix=()):
    if slots == 1:
        yield prefix + (total,)
        return
    for a in range(total + 1):
        yield from weak_compositions(total - a, slots - 1, prefix + (a,))


def translate_exp(exp, u, v):
    out = [0] * 9
    for i, e in enumerate(exp):
        r, c = divmod(i, 3)
        out[((r + u) % 3) * 3 + (c + v) % 3] = e
    return tuple(out)


def invariant_orbits():
    admissible = []
    for exp in weak_compositions(6, 9):
        if sum(exp[i] * (i // 3) for i in range(9)) % 3:
            continue
        if sum(exp[i] * (i % 3) for i in range(9)) % 3:
            continue
        admissible.append(exp)
    reps = sorted(
        {
            min(translate_exp(exp, u, v) for u in range(3) for v in range(3))
            for exp in admissible
        }
    )
    return [
        sorted({translate_exp(rep, u, v) for u in range(3) for v in range(3)})
        for rep in reps
    ]


def orbit_eval(orbit, x):
    return sum(eval_poly({exp: 1}, x) for exp in orbit) % P


def dual_samples(f, count):
    samples = []
    counter = 0
    seen = set()
    while len(samples) < count:
        digest = hashlib.sha256(f"c705-coble-{counter}".encode()).digest()
        counter += 1
        xs = [int.from_bytes(digest[2 * i : 2 * i + 2], "big") % P for i in range(8)]
        for last in range(P):
            x = tuple(xs + [last])
            if eval_poly(f, x) == 0 and x not in seen:
                y = gradient(f, x)
                if any(y):
                    seen.add(x)
                    samples.append((x, y))
                break
    return samples


def expand_orbit_polynomial(orbits, coeffs):
    poly = {}
    for orbit, coeff in zip(orbits, coeffs):
        for exp in orbit:
            add_term(poly, exp, coeff)
    return poly


def matmul(a, b):
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) % P for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def transpose(a):
    return [list(row) for row in zip(*a)]


def mat_vec(a, v):
    return [sum(row[j] * v[j] for j in range(len(v))) % P for row in a]


def kernel_basis_of_row(row):
    pivot = next(i for i, value in enumerate(row) if value)
    inv = pow(row[pivot], P - 2, P)
    basis = []
    for j in range(len(row)):
        if j == pivot:
            continue
        v = [0] * len(row)
        v[j] = 1
        v[pivot] = -row[j] * inv % P
        basis.append(v)
    return basis


def tau_plus_compression_check(f):
    # columns encode (u0,u1,u2,u3,u4) -> (X00,X01,...,X22)
    gamma = [
        [1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0],
        [0, 1, 0, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 0, 1, 0],
        [0, 0, 0, 0, 1],
        [0, 0, 1, 0, 0],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 1, 0],
    ]
    # Compare at enough deterministic points; both sides are linear in u.
    for u in itertools.product(range(3), repeat=5):
        x = tuple(sum(gamma[i][j] * u[j] for j in range(5)) % P for i in range(9))
        compressed = matmul(matmul(transpose(gamma), hessian(f, x)), gamma)
        # Build S=F(gamma*u) explicitly by substitution.
        s = {}
        for exp, coeff in f.items():
            choices = []
            for i, e in enumerate(exp):
                if not e:
                    continue
                j = next(j for j in range(5) if gamma[i][j])
                choices.extend([j] * e)
            ee = [0] * 5
            for j in choices:
                ee[j] += 1
            add_term(s, tuple(ee) + (0,) * 4, coeff)
        # s uses its first five exponent slots inside the common 9-slot evaluator.
        hs = [
            [eval_poly(derivative(derivative(s, i), j), u + (0,) * 4) for j in range(5)]
            for i in range(5)
        ]
        if compressed != hs:
            return False
    return True


def tau_minus_map(f, v):
    x = (0, v[0], -v[0], v[1], v[2], v[3], -v[1], -v[3], -v[2])
    q = gradient(f, tuple(z % P for z in x))
    # Coordinates X01, X10, X11, X12 on the image hyperplane in P^4_+.
    return (q[1], q[3], q[4], q[5])


def tau_minus_jacobian(f, v):
    # Quadratic map: polarization by evaluating first differences symbolically
    # via the global Hessian and the source/target inclusions.
    x = (0, v[0], -v[0], v[1], v[2], v[3], -v[1], -v[3], -v[2])
    h = hessian(f, tuple(z % P for z in x))
    source = [
        (0, 1, -1, 0, 0, 0, 0, 0, 0),
        (0, 0, 0, 1, 0, 0, -1, 0, 0),
        (0, 0, 0, 0, 1, 0, 0, 0, -1),
        (0, 0, 0, 0, 0, 1, 0, -1, 0),
    ]
    targets = (1, 3, 4, 5)
    return [
        [sum(h[i][k] * source[j][k] for k in range(9)) % P for j in range(4)]
        for i in targets
    ]


def compute():
    # Smooth Burkhardt parameter.
    a0, a1, a2, a3, a4 = ALPHA
    burkhardt = (
        a0**4
        + 8 * a0 * (a1**3 + a2**3 + a3**3 + a4**3)
        + 48 * a1 * a2 * a3 * a4
    )
    burkhardt_grad = (
        4 * a0**3 + 8 * (a1**3 + a2**3 + a3**3 + a4**3),
        24 * a0 * a1**2 + 48 * a2 * a3 * a4,
        24 * a0 * a2**2 + 48 * a1 * a3 * a4,
        24 * a0 * a3**2 + 48 * a1 * a2 * a4,
        24 * a0 * a4**2 + 48 * a1 * a2 * a3,
    )
    assert burkhardt == 0 and any(burkhardt_grad)

    f = coble_cubic()
    cubic_x = (2, -2, -2, -4, 2, 2, -3, -1, -3)
    cubic_det_normalized = -309382232474386432
    cubic_x_mod = tuple(z % P for z in cubic_x)
    assert eval_poly(f, cubic_x_mod) == 0
    cubic_det_scaled_mod = mat_det(hessian(f, cubic_x_mod))
    assert cubic_det_scaled_mod == cubic_det_normalized * pow(3, 9, P) % P
    orbits = invariant_orbits()
    assert len(orbits) == 43
    samples = dual_samples(f, 100)
    interpolation_samples = samples[:60]
    validation_samples = samples[60:]
    matrix = [[orbit_eval(orbit, y) for orbit in orbits] for _, y in interpolation_samples]
    coeffs, interpolation_rank = nullvector(matrix)
    g = expand_orbit_polynomial(orbits, coeffs)
    assert all(eval_poly(g, y) == 0 for _, y in validation_samples)

    hessian_witness = None
    for index, (x, y) in enumerate(samples):
        det = mat_det(hessian(g, y))
        if det:
            hessian_witness = {"sample_index": index, "x": x, "y": y, "det": det}
            break
    assert hessian_witness is not None
    mixed_x = tuple(hessian_witness["x"])
    mixed_y = tuple(hessian_witness["y"])
    source_hessian_det = mat_det(hessian(f, mixed_x))
    target_hessian_det = hessian_witness["det"]
    mixed_hessian_product_det = source_hessian_det * target_hessian_det % P
    assert mixed_hessian_product_det

    paired_lambdas = []
    lambda_hessian_ratios = []
    for x, y in samples:
        polar_back = gradient(g, y)
        pivot = next(i for i, value in enumerate(x) if value)
        lam = polar_back[pivot] * pow(x[pivot], P - 2, P) % P
        assert all(polar_back[i] == lam * x[i] % P for i in range(9))
        paired_lambdas.append(lam)
        det_source = mat_det(hessian(f, x))
        if det_source:
            lambda_hessian_ratios.append(lam * pow(det_source, P - 2, P) % P)
    assert len(lambda_hessian_ratios) == 97
    assert set(lambda_hessian_ratios) == {45}

    a = hessian(f, mixed_x)
    b = hessian(g, mixed_y)
    ba = matmul(b, a)
    lam = paired_lambdas[hessian_witness["sample_index"]]
    deviation = [
        [(ba[i][j] - (lam if i == j else 0)) % P for j in range(9)]
        for i in range(9)
    ]
    tangent_images = [mat_vec(deviation, v) for v in kernel_basis_of_row(mixed_y)]
    tangent_image_matrix = transpose(tangent_images)
    assert mat_rank(tangent_image_matrix) == 1
    assert mat_rank([list(mixed_x)] + transpose(tangent_image_matrix)) == 1

    off_cubic_ratios = []
    counter = 0
    while len(off_cubic_ratios) < 5:
        digest = hashlib.sha256(f"c705-coble-off-{counter}".encode()).digest()
        counter += 1
        x = tuple(int.from_bytes(digest[2 * i : 2 * i + 2], "big") % P for i in range(9))
        fx = eval_poly(f, x)
        det_source = mat_det(hessian(f, x))
        if not fx or not det_source:
            continue
        value = eval_poly(g, gradient(f, x))
        ratio = value * pow(fx * det_source % P, P - 2, P) % P
        off_cubic_ratios.append(ratio)
    assert len(set(off_cubic_ratios)) > 1

    assert tau_plus_compression_check(f)

    weddle_off = None
    weddle_on = None
    for v in itertools.product(range(12), repeat=4):
        j = tau_minus_jacobian(f, v)
        det = mat_det(j)
        if det and weddle_off is None:
            weddle_off = {"v": v, "image": tau_minus_map(f, v), "det": det}
        if not det and any(v) and mat_rank(j) == 3 and weddle_on is None:
            adj = adjugate(j)
            assert mat_rank(adj) == 1
            weddle_on = {
                "v": v,
                "image": tau_minus_map(f, v),
                "rank": 3,
                "adjugate": adj,
            }
        if weddle_off and weddle_on:
            break
    assert weddle_off and weddle_on

    return {
        "schema": "c705-coble-mixed-jacobian-v1",
        "field": P,
        "alpha": ALPHA,
        "burkhardt_value_over_Z": burkhardt,
        "burkhardt_gradient_over_Z": burkhardt_grad,
        "coble_cubic_term_count": len(f),
        "coble_cubic_hessian_witness": {
            "x": cubic_x,
            "normalized_hessian_det_over_Z": cubic_det_normalized,
            "scaled_hessian_det_mod_101": cubic_det_scaled_mod,
        },
        "heisenberg_invariant_sextic_basis_dimension": len(orbits),
        "interpolation_samples": len(interpolation_samples),
        "held_out_validation_samples": len(validation_samples),
        "interpolation_rank": interpolation_rank,
        "dual_sextic_term_count": len(g),
        "dual_sextic_orbit_coefficients": coeffs,
        "dual_sextic_sha256": hashlib.sha256(
            json.dumps(sorted((list(e), c) for e, c in g.items()), separators=(",", ":")).encode()
        ).hexdigest(),
        "hessian_witness": hessian_witness,
        "mixed_hessian_product_witness": {
            "source_hessian_det": source_hessian_det,
            "target_hessian_det": target_hessian_det,
            "product_det": mixed_hessian_product_det,
            "rank": 9,
        },
        "paired_polar_composition": {
            "checked_samples": len(samples),
            "nonzero_source_hessian_samples": len(lambda_hessian_ratios),
            "lambda_over_source_hessian_det": 45,
            "tangent_rank_one_sample_index": hessian_witness["sample_index"],
            "tangent_deviation_rank": 1,
            "tangent_deviation_image": "span(x)",
        },
        "off_cubic_composition_ratios": off_cubic_ratios,
        "tau_plus_compressed_hessian_equals_hessian_of_restriction": True,
        "tau_minus_generic_witness": weddle_off,
        "tau_minus_weddle_corank_one_witness": weddle_on,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = compute()
    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        JSON_PATH.write_text(text)
    elif args.check:
        if not JSON_PATH.exists() or JSON_PATH.read_text() != text:
            raise SystemExit(f"certificate mismatch: regenerate with {Path(__file__).name} --write")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
