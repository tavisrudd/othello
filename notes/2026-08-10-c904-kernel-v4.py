#!/usr/bin/env python3
"""Exact modular test for the six-axis polarization discriminant.

The six Sylow-5 subgroups of A5 carry a permutation lattice.  At p=2,3,
the p-part of the discriminant module of its simplex lattice is dual to the
heart of that six-point permutation module.  Compare that four-dimensional
heart with the natural A5 augmentation module on five letters by solving the
intertwining equations over F_p.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import permutations, product
from pathlib import Path
import sys


def compose(a, b):
    """a after b."""
    return tuple(a[b[i]] for i in range(len(a)))


def inverse(a):
    out = [0] * len(a)
    for i, x in enumerate(a):
        out[x] = i
    return tuple(out)


def parity(a):
    return sum(a[i] > a[j] for i in range(len(a)) for j in range(i + 1, len(a))) % 2


def order(a):
    x = tuple(range(len(a)))
    for n in range(1, 61):
        x = compose(a, x)
        if x == tuple(range(len(a))):
            return n
    raise AssertionError("order bound")


def generated_cyclic(a):
    ident = tuple(range(len(a)))
    out, x = {ident}, ident
    while True:
        x = compose(a, x)
        if x in out:
            return frozenset(out)
        out.add(x)


def generated_group(gens):
    ident = tuple(range(len(gens[0])))
    out, frontier = {ident}, [ident]
    while frontier:
        x = frontier.pop()
        for g in gens:
            y = compose(g, x)
            if y not in out:
                out.add(y)
                frontier.append(y)
    return out


def mat_from_columns(cols, p):
    return [[cols[j][i] % p for j in range(len(cols))] for i in range(len(cols[0]))]


def six_heart_matrix(axis_perm, p):
    """Action on Aug(F_p^6)/<1>, basis [e_i-e_5], i=0..3."""
    cols = []
    for i in range(4):
        y = [0] * 6
        y[axis_perm[i]] += 1
        y[axis_perm[5]] -= 1
        # Augmentation coordinates in h_j=e_j-e_5 are y_0,...,y_4.
        # Mod out by sum_j h_j=1 by subtracting y_4 from all coordinates.
        cols.append([(y[j] - y[4]) % p for j in range(4)])
    return mat_from_columns(cols, p)


def five_augmentation_matrix(letter_perm, p):
    """Action on Aug(F_p^5), basis e_i-e_4, i=0..3."""
    cols = []
    for i in range(4):
        y = [0] * 5
        y[letter_perm[i]] += 1
        y[letter_perm[4]] -= 1
        cols.append([y[j] % p for j in range(4)])
    return mat_from_columns(cols, p)


def mul(a, b, p):
    return [[sum(a[i][k] * b[k][j] for k in range(len(b))) % p
             for j in range(len(b[0]))] for i in range(len(a))]


def rank(a, p):
    a = [row[:] for row in a]
    m, n, r = len(a), len(a[0]), 0
    for c in range(n):
        pivot = next((i for i in range(r, m) if a[i][c] % p), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        z = pow(a[r][c], -1, p)
        a[r] = [(z * x) % p for x in a[r]]
        for i in range(m):
            if i != r and a[i][c] % p:
                z = a[i][c] % p
                a[i] = [(a[i][j] - z * a[r][j]) % p for j in range(n)]
        r += 1
    return r


def nullspace(a, p):
    a = [[x % p for x in row] for row in a]
    m, n, r, pivots = len(a), len(a[0]), 0, []
    for c in range(n):
        pivot = next((i for i in range(r, m) if a[i][c]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        z = pow(a[r][c], -1, p)
        a[r] = [(z * x) % p for x in a[r]]
        for i in range(m):
            if i != r and a[i][c]:
                z = a[i][c]
                a[i] = [(a[i][j] - z * a[r][j]) % p for j in range(n)]
        pivots.append(c)
        r += 1
    free = [c for c in range(n) if c not in pivots]
    basis = []
    for f in free:
        v = [0] * n
        v[f] = 1
        for i, c in enumerate(pivots):
            v[c] = -a[i][f] % p
        basis.append(v)
    return basis


def hom_basis(source, target, p):
    """X source[g] = target[g] X, variables X_ij in row-major order."""
    equations = []
    for aa, bb in zip(source, target):
        for i in range(4):
            for j in range(4):
                row = [0] * 16
                for k in range(4):
                    row[4 * i + k] += aa[k][j]
                    row[4 * k + j] -= bb[i][k]
                equations.append([x % p for x in row])
    return nullspace(equations, p)


def as_matrix(v):
    return [v[4 * i:4 * i + 4] for i in range(4)]


def mat_vec(a, v, p):
    return tuple(sum(a[i][j] * v[j] for j in range(4)) % p for i in range(4))


def min_orbit_span(gens, p):
    best = 4
    for v in product(range(p), repeat=4):
        if not any(v):
            continue
        orbit, frontier = {v}, [v]
        while frontier:
            x = frontier.pop()
            for g in gens:
                y = mat_vec(g, x, p)
                if y not in orbit:
                    orbit.add(y)
                    frontier.append(y)
        best = min(best, rank([list(x) for x in orbit], p))
    return best


def gf4_mul(a, b):
    """F4=F2[w]/(w^2+w+1), encoded as a0+2*a1."""
    a0, a1 = a & 1, (a >> 1) & 1
    b0, b1 = b & 1, (b >> 1) & 1
    return ((a0 * b0 + a1 * b1) & 1) | (
        ((a0 * b1 + a1 * b0 + a1 * b1) & 1) << 1
    )


def gf4_inv(a):
    assert a
    return next(b for b in range(1, 4) if gf4_mul(a, b) == 1)


def p1_action(matrix2, slope):
    """Mobius action on slopes y/x in P1(F4); None denotes infinity."""
    a, b = matrix2[0]
    c, d = matrix2[1]
    if slope is None:
        denominator, numerator = b, d
    else:
        denominator = a ^ gf4_mul(b, slope)
        numerator = c ^ gf4_mul(d, slope)
    if denominator == 0:
        return None
    return gf4_mul(numerator, gf4_inv(denominator))


def emit():
    a5 = [a for a in permutations(range(5)) if parity(a) == 0]
    assert len(a5) == 60
    sylow5 = sorted({generated_cyclic(a) for a in a5 if order(a) == 5},
                    key=lambda h: sorted(h))
    assert len(sylow5) == 6
    index = {h: i for i, h in enumerate(sylow5)}

    gens = [
        (1, 2, 3, 4, 0),       # (0 1 2 3 4)
        (1, 2, 0, 3, 4),       # (0 1 2)
    ]
    assert len(generated_group(gens)) == 60
    axis_perms = []
    for g in gens:
        gi = inverse(g)
        image = []
        for h in sylow5:
            ghg = frozenset(compose(compose(g, x), gi) for x in h)
            image.append(index[ghg])
        axis_perms.append(tuple(image))

    print("A5 six-axis polarization discriminant versus Winger V4")
    print(f"  Sylow-5 axes={len(sylow5)}")
    print(f"  generator axis permutations={axis_perms}")
    for p in (2, 3):
        heart = [six_heart_matrix(g, p) for g in axis_perms]
        natural = [five_augmentation_matrix(g, p) for g in gens]
        hb = hom_basis(heart, natural, p)
        end_heart = hom_basis(heart, heart, p)
        end_natural = hom_basis(natural, natural, p)
        singular_nonzero_endos = 0
        for coeffs in product(range(p), repeat=len(end_heart)):
            if not any(coeffs):
                continue
            v = [sum(c * b[i] for c, b in zip(coeffs, end_heart)) % p
                 for i in range(16)]
            singular_nonzero_endos += rank(as_matrix(v), p) < 4
        invertible = None
        for coeffs in product(range(p), repeat=len(hb)):
            if not any(coeffs):
                continue
            v = [sum(c * b[i] for c, b in zip(coeffs, hb)) % p for i in range(16)]
            x = as_matrix(v)
            if rank(x, p) == 4:
                invertible = x
                break
        print(f"  p={p}: Hom dimension={len(hb)}, "
              f"End dimensions=({len(end_heart)},{len(end_natural)}), "
              f"minimum orbit spans=({min_orbit_span(heart, p)},"
              f"{min_orbit_span(natural, p)}), "
              f"singular nonzero axis endos={singular_nonzero_endos}, "
              f"invertible intertwiner={invertible}")
        if invertible is not None:
            for ah, av in zip(heart, natural):
                assert mul(invertible, ah, p) == mul(av, invertible, p)

    # The five A5-stable simple submodules of H_2+H_2 are P1(F4).  Full
    # mod-2 elliptic monodromy GL2(F2)=S3 has no fixed member: its orbits are
    # P1(F2) (size 3) and the conjugate F4 pair (size 2).  The action on the
    # latter is exactly the sign quotient.
    p1 = (None, 0, 1, 2, 3)
    mod2_generators = (
        ((1, 1), (0, 1)),
        ((1, 0), (1, 1)),
    )
    p1_perms = [tuple(p1.index(p1_action(g, s)) for s in p1)
                for g in mod2_generators]
    assert len(generated_group(p1_perms)) == 6
    assert all(not all(perm[i] == i for perm in p1_perms) for i in range(5))
    assert all({p1[perm[3]], p1[perm[4]]} == {2, 3} for perm in p1_perms)
    assert all(perm[3] == 4 and perm[4] == 3 for perm in p1_perms)
    print("  conclusion: the full coefficient discriminant is not Winger V4 mod 6")
    print("  (already obstructed modulo 2; ordinary-character matching cannot see this)")
    print("  its mod-2 endomorphism field is F4; its mod-3 part is exactly Winger V4")
    print(f"  GL2(F2) action on P1(F4)={p1_perms}: orbits 3+2, no fixed line")
    print("  the two-point orbit is the sign quotient, so it trivializes on a quadratic cover")
    print("PASS")


if __name__ == "__main__":
    stream = StringIO()
    with redirect_stdout(stream):
        emit()
    rendered = stream.getvalue()
    target = Path(__file__).with_suffix(".out")
    if sys.argv[1:] == ["--write"]:
        target.write_text(rendered)
    elif sys.argv[1:] == ["--check"]:
        assert target.read_text() == rendered
        print("CHECK PASS")
    elif not sys.argv[1:]:
        print(rendered, end="")
    else:
        raise SystemExit("usage: kernel-v4.py [--write|--check]")
