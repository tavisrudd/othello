#!/usr/bin/env python3
"""Independent entry replay for C509's persistent sextic-syndrome stratum."""

import argparse
import importlib.util
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
C498_PATH = HERE / "2026-07-22-c498-prs-deep-hole-replay.py"
SPEC = importlib.util.spec_from_file_location("c498_replay", C498_PATH)
C498 = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(C498)
C498.MODULI.setdefault(4, (2, [1, 1]))  # x^2 = x + 1


def sym_matrix(F, g, degree):
    alpha, beta, gamma, delta = g
    out = [[0] * (degree + 1) for _ in range(degree + 1)]
    for i in range(degree + 1):
        left = [1]
        right = [1]
        for _ in range(i):
            left = C498.poly_mul(F, left, [beta, alpha])
        for _ in range(degree - i):
            right = C498.poly_mul(F, right, [delta, gamma])
        for j, x in enumerate(C498.poly_mul(F, left, right)):
            out[i][j] = x
    return out


def decode(F, code, length):
    out = [0] * length
    for i in range(length - 1, -1, -1):
        out[i] = code % F.q
        code //= F.q
    return tuple(out)


def poly_eval(F, coefficients, x):
    value = 0
    for coefficient in reversed(coefficients):
        value = F.add(F.mul(value, x), coefficient)
    return value


def orbit6(F, start):
    generators = [
        sym_matrix(F, (0, 1, 1, 0), 6),
        sym_matrix(F, (1, 1, 0, 1), 6),
        sym_matrix(F, (F.gen, 0, 0, 1), 6),
    ]
    seen = {C498.encode(F, start)}
    todo = [C498.canon(F, start)]
    while todo:
        v = todo.pop()
        for matrix in generators:
            w = C498.canon(F, C498.matvec(F, matrix, v))
            iw = C498.encode(F, w)
            if iw not in seen:
                seen.add(iw)
                todo.append(w)
    return seen


def catalecticant_rank(F, v):
    return C498.matrix_rank(
        F,
        [
            v[0:5],
            v[1:6],
            v[2:7],
        ],
    )


def curve6(F):
    points = []
    for t in range(F.q):
        row = [1]
        for _ in range(6):
            row.append(F.mul(row[-1], t))
        points.append(tuple(row))
    points.append((0, 0, 0, 0, 0, 0, 1))
    return points


def rational_secant_points(F):
    curve = curve6(F)
    out = set()
    for i in range(len(curve)):
        for j in range(i + 1, len(curve)):
            for c in range(F.q):
                v = tuple(
                    F.add(x, F.mul(c, y))
                    for x, y in zip(curve[i], curve[j])
                )
                out.add(C498.encode(F, C498.canon(F, v)))
            out.add(C498.encode(F, curve[j]))
    return out


def central_nucleus_has_split_member(F):
    basis_indices = (0, 1, 4, 5)
    for coefficients in C498.pg_points(F.q, 4):
        form = [0] * 6
        for coefficient, index in zip(coefficients, basis_indices):
            form[index] = coefficient
        affine_roots = sum(
            poly_eval(F, form, x) == 0 for x in range(F.q)
        )
        infinity_root = form[5] == 0
        if affine_roots + infinity_root == 5:
            return True
    return False


def expected_orbits(F):
    q = F.q
    tangent = (
        [(q + 1, q * (q - 1)), (q * q - 1, q)]
        if 6 % F.p == 0
        else [(q * (q + 1), q - 1)]
    )

    d = gcd(6, q + 1)
    sigma = []
    unseen = set(range(d))
    while unseen:
        x = min(unseen)
        inversion_class = {x, (-x) % d}
        unseen -= inversion_class
        if len(inversion_class) == 1:
            sigma.append((q * (q * q - 1) // (2 * d), 2 * d))
        else:
            sigma.append((q * (q * q - 1) // d, d))
    return sorted(tangent + sigma)


def expected_semilinear_count(F):
    tangent_count = 2 if 6 % F.p == 0 else 1
    d = gcd(6, F.q + 1)
    unseen = set(range(d))
    sigma_count = 0
    while unseen:
        sigma_count += 1
        todo = [unseen.pop()]
        while todo:
            x = todo.pop()
            for y in ((-x) % d, (F.p * x) % d):
                if y in unseen:
                    unseen.remove(y)
                    todo.append(y)
    return tangent_count + sigma_count


def replay_field(q):
    F = C498.GF(q)
    if F.p == 2:
        assert central_nucleus_has_split_member(F) == (F.m % 2 == 0)
    rank_two = {
        C498.encode(F, v)
        for v in C498.pg_points(q, 7)
        if catalecticant_rank(F, v) == 2
    }
    persistent = rank_two - rational_secant_points(F)
    assert len(persistent) == q * (q + 1) ** 2 // 2

    unseen = set(persistent)
    rows = []
    while unseen:
        start_index = min(unseen)
        start = decode(F, start_index, 7)
        component = orbit6(F, start)
        assert component <= persistent
        unseen -= component
        representative = min(component)
        fv = tuple(F.pow(x, F.p) for x in decode(F, representative, 7))
        rows.append(
            {
                "rep": representative,
                "size": len(component),
                "stab": (q ** 3 - q) // len(component),
                "frobenius": min(orbit6(F, fv)),
            }
        )

    observed = sorted((row["size"], row["stab"]) for row in rows)
    assert observed == expected_orbits(F), (q, observed, expected_orbits(F))

    targets = {row["rep"]: row["frobenius"] for row in rows}
    unseen_reps = set(targets)
    cycles = 0
    while unseen_reps:
        cycles += 1
        current = unseen_reps.pop()
        while targets[current] in unseen_reps:
            current = targets[current]
            unseen_reps.remove(current)
    assert cycles == expected_semilinear_count(F)
    print(
        f"q={q}: points={len(persistent)}, PGL2_orbits={len(rows)}, "
        f"PGammaL2_orbits={cycles}: PASS",
        flush=True,
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--fields", default="4,5,7,8,9")
    args = parser.parse_args()
    for q in map(int, args.fields.split(",")):
        replay_field(q)
    print("C509 persistent-stratum replay: ALL CHECKS PASS")


if __name__ == "__main__":
    main()
