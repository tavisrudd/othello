#!/usr/bin/env python3
"""Exact golden maximal-order to exotic F4-heart bridge.

The input is the signed conference matrix B printed in Paper I.  We enlarge
L=Z^6 to the minimal lattice stable under phi=(I+B)/2, reduce modulo 2, find
the canonical invariant F4-line, and compare the four-dimensional quotient
with the six-point A5 heart used by the exotic principal gluing.

No external packages are used.  Run with --write to regenerate the adjacent
.out file and with --check to compare a fresh computation against it.
"""

from fractions import Fraction
from itertools import permutations, product
from pathlib import Path
import sys


B = (
    (0, 1, 1, 1, 1, 1),
    (1, 0, 1, 1, -1, -1),
    (1, 1, 0, -1, 1, -1),
    (1, 1, -1, 0, -1, 1),
    (1, -1, 1, -1, 0, 1),
    (1, -1, -1, 1, 1, 0),
)


def matmul(a, b):
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(len(b)))
                       for j in range(len(b[0])))
                 for i in range(len(a)))


def transpose(a):
    return tuple(zip(*a))


def identity(n):
    return tuple(tuple(int(i == j) for j in range(n)) for i in range(n))


def matadd(a, b):
    return tuple(tuple(a[i][j] + b[i][j] for j in range(len(a[0])))
                 for i in range(len(a)))


def matscale(c, a):
    return tuple(tuple(c * x for x in row) for row in a)


def perm_matrix(p):
    n = len(p)
    out = [[0] * n for _ in range(n)]
    for i, pi in enumerate(p):
        out[pi][i] = 1
    return tuple(tuple(row) for row in out)


def signed_matrix(p, signs):
    pp = perm_matrix(p)
    return tuple(tuple(signs[i] * pp[i][j] for j in range(6))
                 for i in range(6))


def oriented_stabilizer():
    """Return the 60 axis permutations and compatible signed lifts modulo ±I."""
    out = []
    for p in permutations(range(6)):
        pp = perm_matrix(p)
        c = matmul(matmul(pp, B), transpose(pp))
        signs = [1]
        for j in range(1, 6):
            signs.append(B[0][j] * c[0][j])
        m = signed_matrix(p, tuple(signs))
        if matmul(matmul(m, B), transpose(m)) == B:
            out.append((p, m))
    assert len(out) == 60
    return tuple(out)


def compose_perm(a, b):
    return tuple(a[b[i]] for i in range(6))


def inverse_perm(a):
    out = [0] * 6
    for i, ai in enumerate(a):
        out[ai] = i
    return tuple(out)


def generated_group(gens):
    one = tuple(range(6))
    seen = {one}
    frontier = [one]
    while frontier:
        x = frontier.pop()
        for g in gens:
            y = compose_perm(g, x)
            if y not in seen:
                seen.add(y)
                frontier.append(y)
    return frozenset(seen)


def canonical_generators(perms):
    nontrivial = sorted(p for p in perms if p != tuple(range(6)))
    for a in nontrivial:
        for b in nontrivial:
            if len(generated_group((a, b))) == 60:
                return a, b
    raise AssertionError("no two generators")


# Lmax basis: h=(1/2,...,1/2), e1,...,e5.  For v in Lmax the coordinates
# are a0=2v0 and aj=vj-v0.
def lattice_basis():
    cols = [tuple(Fraction(1, 2) for _ in range(6))]
    for j in range(1, 6):
        cols.append(tuple(Fraction(int(i == j)) for i in range(6)))
    return tuple(tuple(cols[j][i] for j in range(6)) for i in range(6))


P = lattice_basis()


def lattice_coordinates(v):
    a0 = 2 * v[0]
    out = [a0]
    out.extend(v[j] - v[0] for j in range(1, 6))
    assert all(x.denominator == 1 for x in out)
    return tuple(int(x) for x in out)


def lattice_matrix(m):
    cols = []
    for j in range(6):
        v = tuple(sum(Fraction(m[i][k]) * P[k][j] for k in range(6))
                  for i in range(6))
        cols.append(lattice_coordinates(v))
    return tuple(tuple(cols[j][i] for j in range(6)) for i in range(6))


def mod2(a):
    return tuple(tuple(int(x) & 1 for x in row) for row in a)


def bits_to_vec(x, n):
    return tuple((x >> i) & 1 for i in range(n))


def vec_to_bits(v):
    return sum((int(x) & 1) << i for i, x in enumerate(v))


def matvec2(a, x):
    v = bits_to_vec(x, len(a))
    return vec_to_bits(tuple(sum(a[i][j] * v[j] for j in range(len(v))) & 1
                             for i in range(len(a))))


def rank2(columns, n):
    pivots = []
    for x in columns:
        y = x
        for p in pivots:
            y = min(y, y ^ p)
        if y:
            pivots.append(y)
            pivots.sort(reverse=True)
    return len(pivots)


def invert2(a):
    n = len(a)
    rows = []
    for i in range(n):
        left = sum((a[i][j] & 1) << j for j in range(n))
        rows.append(left | (1 << (n + i)))
    for c in range(n):
        pivot = next(i for i in range(c, n) if (rows[i] >> c) & 1)
        rows[c], rows[pivot] = rows[pivot], rows[c]
        for i in range(n):
            if i != c and ((rows[i] >> c) & 1):
                rows[i] ^= rows[c]
    assert all((rows[i] & ((1 << n) - 1)) == (1 << i) for i in range(n))
    return tuple(tuple((rows[i] >> (n + j)) & 1 for j in range(n))
                 for i in range(n))


def change_basis_matrix(columns, n):
    return tuple(tuple((columns[j] >> i) & 1 for j in range(n))
                 for i in range(n))


def six_heart_matrix(p):
    """Action on Aug(F2^6)/<1>, basis e_i-e_5, i=0,...,3."""
    cols = []
    for i in range(4):
        y = [0] * 6
        y[p[i]] ^= 1
        y[p[5]] ^= 1
        cols.append(tuple(y[j] ^ y[4] for j in range(4)))
    return tuple(tuple(cols[j][i] for j in range(4)) for i in range(4))


def nullspace2(rows, n):
    a = [sum((x & 1) << j for j, x in enumerate(row)) for row in rows]
    pivots = []
    r = 0
    for c in range(n):
        pivot = next((i for i in range(r, len(a)) if (a[i] >> c) & 1), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        for i in range(len(a)):
            if i != r and ((a[i] >> c) & 1):
                a[i] ^= a[r]
        pivots.append(c)
        r += 1
    free = [c for c in range(n) if c not in pivots]
    basis = []
    for f in free:
        v = 1 << f
        for i, c in enumerate(pivots):
            if (a[i] >> f) & 1:
                v |= 1 << c
        basis.append(v)
    return basis


def hom_basis(source, target):
    """X source[g] = target[g] X, row-major variables."""
    rows = []
    for aa, bb in zip(source, target):
        for i in range(4):
            for j in range(4):
                row = [0] * 16
                for k in range(4):
                    row[4 * i + k] ^= aa[k][j]
                    row[4 * k + j] ^= bb[i][k]
                rows.append(row)
    return nullspace2(rows, 16)


def vector_as_matrix(v, n=4):
    return tuple(tuple((v >> (n * i + j)) & 1 for j in range(n))
                 for i in range(n))


def matrix_rank2(a):
    cols = [sum((a[i][j] & 1) << i for i in range(len(a)))
            for j in range(len(a[0]))]
    return rank2(cols, len(a))


def permutation_order(p):
    one = tuple(range(6))
    x = one
    for n in range(1, 61):
        x = compose_perm(p, x)
        if x == one:
            return n
    raise AssertionError("order")


def compute():
    i6 = identity(6)
    assert matmul(B, B) == matscale(5, i6)
    phi_q = matscale(Fraction(1, 2), matadd(i6, B))
    phi = lattice_matrix(phi_q)
    assert matadd(matmul(phi, phi), matscale(-1, phi)) == i6

    # Lmax/L has order two: every phi(e_i) has the same half-vector class.
    half_classes = []
    for j in range(6):
        half_classes.append(tuple(phi_q[i][j] % 1 for i in range(6)))
    assert all(c == half_classes[0] for c in half_classes)
    assert half_classes[0] == tuple(Fraction(1, 2) for _ in range(6))

    stabilizer = oriented_stabilizer()
    perms = tuple(p for p, _ in stabilizer)
    gen_perms = canonical_generators(perms)
    lift_by_perm = {p: m for p, m in stabilizer}
    gen_actions = tuple(mod2(lattice_matrix(lift_by_perm[p])) for p in gen_perms)
    phi2 = mod2(phi)
    assert all(mod2(matmul(g, phi2)) == mod2(matmul(phi2, g))
               for g in gen_actions)
    assert mod2(matadd(matmul(phi2, phi2), matadd(phi2, i6))) == tuple(
        tuple(0 for _ in range(6)) for _ in range(6)
    )

    # Enumerate F4-lines in the F4^3 module Lmax/2Lmax.
    lines = set()
    for v in range(1, 64):
        w = matvec2(phi2, v)
        line = frozenset((0, v, w, v ^ w))
        assert len(line) == 4
        lines.add(line)
    assert len(lines) == 21
    invariant_lines = sorted(
        line for line in lines
        if all(frozenset(matvec2(g, v) for v in line) == line
               for g in gen_actions)
    )
    assert len(invariant_lines) == 0

    # The characteristic-two reduction of the golden 3-space is not simple:
    # it has a unique invariant F4-plane (not a line).  This plane is the
    # four-dimensional six-point heart.
    planes = set()
    for v in range(1, 64):
        vline = frozenset((0, v, matvec2(phi2, v), v ^ matvec2(phi2, v)))
        for w in range(1, 64):
            if w in vline:
                continue
            generators = (v, matvec2(phi2, v), w, matvec2(phi2, w))
            if rank2(list(generators), 6) != 4:
                continue
            plane = frozenset(
                a for a in range(64)
                if rank2(list(generators) + [a], 6) == 4
            )
            assert len(plane) == 16
            planes.add(plane)
    assert len(planes) == 21
    invariant_planes = sorted(
        plane for plane in planes
        if all(frozenset(matvec2(g, v) for v in plane) == plane
               for g in gen_actions)
    )
    assert len(invariant_planes) == 1, len(invariant_planes)
    plane = invariant_planes[0]
    v = min(plane - {0})
    plane_basis = [v, matvec2(phi2, v)]
    w = min(a for a in plane if rank2(plane_basis + [a], 6) > 2)
    plane_basis.extend((w, matvec2(phi2, w)))
    assert rank2(plane_basis, 6) == 4

    commutators = []
    for g in gen_actions:
        for j in range(6):
            commutators.append(matvec2(g, 1 << j) ^ (1 << j))
    assert rank2(commutators, 6) == 4
    commutator_space = frozenset(
        a for a in range(64) if rank2(commutators + [a], 6) == 4
    )
    assert commutator_space == plane

    basis = plane_basis[:]
    for j in range(6):
        e = 1 << j
        if rank2(basis + [e], 6) > len(basis):
            basis.append(e)
    assert len(basis) == 6
    cb = change_basis_matrix(basis, 6)
    cb_inv = invert2(cb)

    heart_sub_actions = []
    for g in gen_actions:
        gg = mod2(matmul(matmul(cb_inv, g), cb))
        assert all(gg[i][j] == 0 for i in range(4, 6) for j in range(4))
        assert tuple(tuple(gg[i][j] for j in range(4, 6))
                     for i in range(4, 6)) == identity(2)
        heart_sub_actions.append(tuple(tuple(gg[i][j] for j in range(4))
                                       for i in range(4)))
    phic = mod2(matmul(matmul(cb_inv, phi2), cb))
    assert all(phic[i][j] == 0 for i in range(4, 6) for j in range(4))
    heart_sub_phi = tuple(tuple(phic[i][j] for j in range(4))
                          for i in range(4))

    heart_actions = tuple(six_heart_matrix(p) for p in gen_perms)
    hb = hom_basis(tuple(heart_sub_actions), heart_actions)
    intertwiners = [vector_as_matrix(vv) for vv in hb]
    assert all(matrix_rank2(xx) in (0, 4) for xx in intertwiners)
    x = next(xx for xx in intertwiners if matrix_rank2(xx) == 4)
    x_inv = invert2(x)
    omega = mod2(matmul(matmul(x, heart_sub_phi), x_inv))
    transported = {
        mod2(matmul(matmul(xx, heart_sub_phi), invert2(xx)))
        for xx in intertwiners if matrix_rank2(xx) == 4
    }
    assert transported == {omega}
    i4 = identity(4)
    assert mod2(matadd(matmul(omega, omega), matadd(omega, i4))) == tuple(
        tuple(0 for _ in range(4)) for _ in range(4)
    )
    omega2 = mod2(matadd(omega, i4))
    assert omega2 == mod2(matmul(omega, omega))

    # The normalizer's outer coset acts as Frobenius on the transported heart.
    a5 = frozenset(perms)
    normalizer = []
    for p in permutations(range(6)):
        pinv = inverse_perm(p)
        if all(compose_perm(compose_perm(p, g), pinv) in a5 for g in a5):
            normalizer.append(p)
    assert len(normalizer) == 120
    outer = next(p for p in normalizer if p not in a5)
    n = six_heart_matrix(outer)
    n_inv = invert2(n)
    assert mod2(matmul(matmul(n, omega), n_inv)) == omega2

    # Reversing the golden orientation sends phi to 1-phi, hence omega to omega^2.
    phi_conjugate = mod2(matadd(i6, phi2))
    phicc = mod2(matmul(matmul(cb_inv, phi_conjugate), cb))
    heart_sub_phi_conjugate = tuple(
        tuple(phicc[i][j] for j in range(4)) for i in range(4)
    )
    transported_conjugate = mod2(
        matmul(matmul(x, heart_sub_phi_conjugate), x_inv)
    )
    assert transported_conjugate == omega2

    rows = [
        "C904 golden maximal-order to F4-heart bridge",
        "  conference: B^2=5I",
        "  maximal-order saturation: Lmax=Z^6+Z*(1/2,...,1/2), index=2",
        "  phi=(I+B)/2 preserves Lmax and satisfies phi^2-phi-1=0",
        "  reduction: Lmax/2Lmax has F4-dimension=3",
        f"  oriented stabilizer order={len(a5)}, generators orders="
        f"{tuple(permutation_order(p) for p in gen_perms)}",
        f"  generator permutations={gen_perms}",
        f"  invariant F4-lines={len(invariant_lines)}",
        f"  invariant F4-planes={len(invariant_planes)} (unique)",
        "  canonical submodule=[A5,Lmax/2], F4-dimension=2, F2-dimension=4",
        f"  canonical submodule basis={tuple(bits_to_vec(a, 6) for a in plane_basis)}",
        "  quotient is the trivial F4-line",
        f"  submodule-to-six-heart Hom dimension={len(hb)}, invertible=True",
        f"  intertwiner={x}",
        f"  transported omega={omega}",
        f"  transported omega^2={omega2}",
        "  golden conjugation phi->1-phi transports omega->omega^2",
        "  outer normalizer conjugation transports omega->omega^2",
        "PASS",
    ]
    return "\n".join(rows) + "\n"


def main():
    output = compute()
    out_path = Path(__file__).with_suffix(".out")
    if len(sys.argv) == 2 and sys.argv[1] == "--write":
        out_path.write_text(output)
        print(f"wrote {out_path.name}")
    elif len(sys.argv) == 2 and sys.argv[1] == "--check":
        assert out_path.read_text() == output
        print(f"PASS {out_path.name}")
    elif len(sys.argv) == 1:
        print(output, end="")
    else:
        raise SystemExit("usage: script.py [--write|--check]")


if __name__ == "__main__":
    main()
