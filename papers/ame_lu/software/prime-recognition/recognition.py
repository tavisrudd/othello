#!/usr/bin/env python3
"""Exact recognition from promised prime-field systematic AME matrices.

No primality or AME-promise test is performed. Randomness affects witness
runtime, never the answer. Matrices of order two use row-major four-tuples.
"""
from __future__ import annotations

import argparse
import itertools
import json
import random
import sys

I2 = (1, 0, 0, 1)


def det(a, p):
    return (a[0] * a[3] - a[1] * a[2]) % p


def mul(a, b, p):
    return ((a[0]*b[0]+a[1]*b[2]) % p, (a[0]*b[1]+a[1]*b[3]) % p,
            (a[2]*b[0]+a[3]*b[2]) % p, (a[2]*b[1]+a[3]*b[3]) % p)


def inv(a, p):
    z = pow(det(a, p), -1, p)
    return tuple(z*x % p for x in (a[3], -a[1], -a[2], a[0]))


def combine(coefficients, rows, p, width=4):
    return tuple(sum(c*r[j] for c, r in zip(coefficients, rows)) % p
                 for j in range(width))


def rref(rows, width, p):
    """Return nonzero reduced rows and pivot columns; no input mutation."""
    a = [[int(x) % p for x in row] for row in rows]
    if any(len(row) != width for row in a):
        raise ValueError('inconsistent row width')
    pivots = []
    for col in range(width):
        k = len(pivots)
        j = next((j for j in range(k, len(a)) if a[j][col]), None)
        if j is None:
            continue
        a[k], a[j] = a[j], a[k]
        z = pow(a[k][col], -1, p)
        a[k] = [x*z % p for x in a[k]]
        for j in range(len(a)):
            if j != k and a[j][col]:
                z = a[j][col]
                a[j] = [(x-z*y) % p for x, y in zip(a[j], a[k])]
        pivots.append(col)
    return [tuple(row) for row in a[:len(pivots)]], pivots


def nullspace(rows, width, p):
    a, pivots = rref(rows, width, p)
    result = []
    for free in range(width):
        if free not in pivots:
            v = [0]*width
            v[free] = 1
            for row, pivot in zip(a, pivots):
                v[pivot] = -row[free] % p
            result.append(tuple(v))
    return result


def legendre(a, p):
    x = pow(a % p, (p-1)//2, p)
    return -1 if x == p-1 else x


def square_root(a, p, rng, stats=None):
    """Cipolla's exact Las Vegas algorithm; return None for a nonsquare."""
    a %= p
    if p == 2 or not a:
        return a
    if legendre(a, p) != 1:
        return None
    if p % 4 == 3:
        return pow(a, (p+1)//4, p)
    while True:
        t = rng.randrange(p)
        if stats is not None:
            stats['root_trials'] = stats.get('root_trials', 0) + 1
        d = (t*t-a) % p
        if legendre(d, p) == -1:
            break
    def product(u, v):
        return ((u[0]*v[0]+d*u[1]*v[1]) % p,
                (u[0]*v[1]+u[1]*v[0]) % p)
    y, x, exponent = (1, 0), (t, 1), (p+1)//2
    while exponent:
        if exponent & 1:
            y = product(y, x)
        x = product(x, x)
        exponent >>= 1
    if y[1] or y[0]*y[0] % p != a:
        raise ArithmeticError('invalid square-root witness: check prime promise')
    return y[0]


def diagonalize(basis, p):
    """Orthogonalize det restricted to span(basis), for odd prime p.

    Returns [(nonzero diagonal coefficient, matrix vector), ...]. The
    discarded radical has identically zero determinant restriction.
    """
    remaining = list(basis)
    result = []
    half = pow(2, -1, p)
    def pairing(u, v):
        return (u[0]*v[3]+u[3]*v[0]-u[1]*v[2]-u[2]*v[1])*half % p
    while remaining:
        pivot = next((i for i, u in enumerate(remaining) if det(u, p)), None)
        if pivot is None:
            pair = next(((i, j) for i in range(len(remaining))
                         for j in range(i+1, len(remaining))
                         if pairing(remaining[i], remaining[j])), None)
            if pair is None:
                break
            i, j = pair
            remaining[i] = tuple((a+b) % p for a, b in zip(remaining[i], remaining[j]))
            pivot = i
        v = remaining.pop(pivot)
        coefficient = det(v, p)
        result.append((coefficient, v))
        z = pow(coefficient, -1, p)
        remaining = [tuple((x-pairing(u, v)*z*y) % p for x, y in zip(u, v))
                     for u in remaining]
    return result


def determinant_one(basis, p, *, witness=True, rng=None, stats=None):
    """Decide/find det=1 in an arbitrary supplied linear span in M_2(F_p).

    Returns (exists, matrix_or_None). Decision-only mode never samples.
    """
    if p < 2:
        raise ValueError('prime must be at least two')
    basis, _ = rref(basis, 4, p)
    if p == 2:
        for c in itertools.product(range(2), repeat=len(basis)):
            a = combine(c, basis, p)
            if det(a, p) == 1:
                return True, a if witness else None
        return False, None
    diagonal = diagonalize(basis, p)
    rank = len(diagonal)
    if stats is not None:
        stats['quadratic_rank'] = rank
    exists = rank >= 2 or (rank == 1 and legendre(diagonal[0][0], p) == 1)
    if not exists or not witness:
        return exists, None
    rng = rng or random.SystemRandom()
    a, u = diagonal[0]
    if rank == 1:
        x = square_root(pow(a, -1, p), p, rng, stats)
        answer = tuple(x*z % p for z in u)
    else:
        b, v = diagonal[1]
        b_inverse = pow(b, -1, p)
        while True:
            x = rng.randrange(p)
            if stats is not None:
                stats['binary_trials'] = stats.get('binary_trials', 0) + 1
            y_squared = (1-a*x*x)*b_inverse % p
            y = square_root(y_squared, p, rng, stats)
            if y is not None:
                answer = tuple((x*s+y*t) % p for s, t in zip(u, v))
                break
    if det(answer, p) != 1:
        raise ArithmeticError('invalid determinant witness')
    return True, answer


def intertwiner_space(left, right, p):
    if len(left) != len(right):
        raise ValueError('tuple lengths differ')
    equations = []
    units = [tuple(int(i == j) for j in range(4)) for i in range(4)]
    for g, h in zip(left, right):
        images = [tuple((x-y) % p for x, y in zip(mul(u, g, p), mul(h, u, p)))
                  for u in units]
        equations.extend(zip(*images))
    return nullspace(equations, 4, p)


def normalize_blocks(g, p):
    m = len(g)
    if m < 2 or any(len(row) != m for row in g):
        raise ValueError('expected a square block array with m>=2')
    out = [[tuple(int(x) % p for x in block) for block in row] for row in g]
    if any(len(b) != 4 or not det(b, p) for row in out for b in row):
        raise ValueError('all party blocks must be invertible 2 by 2 matrices')
    return out


def cycles(g, p):
    return [mul(mul(mul(g[0][j], inv(g[i][j], p), p), g[i][0], p), inv(g[0][0], p), p)
            for i in range(1, len(g)) for j in range(1, len(g))]


def verify_frames(g, h, rows, columns, p):
    m = len(g)
    return (len(rows) == len(columns) == m
            and all(det(a, p) == 1 for a in rows+columns)
            and all(mul(rows[i], g[i][j], p) == mul(h[i][j], columns[j], p)
                    for i in range(m) for j in range(m)))


def recognize(g, h, p, *, witness=True, rng=None):
    """Solve F_B G = H F_C. AME and primality are input promises."""
    g, h = normalize_blocks(g, p), normalize_blocks(h, p)
    if len(g) != len(h):
        raise ValueError('block array sizes differ')
    if any(det(g[i][j], p) != det(h[i][j], p)
           for i in range(len(g)) for j in range(len(g))):
        return {'equivalent': False, 'reason': 'block_determinants'}
    basis = intertwiner_space(cycles(g, p), cycles(h, p), p)
    exists, a = determinant_one(basis, p, witness=witness, rng=rng)
    out = {'equivalent': exists, 'intertwiner_dimension': len(basis)}
    if exists and witness:
        columns = [mul(mul(inv(h[0][j], p), a, p), g[0][j], p) for j in range(len(g))]
        rows = [mul(mul(h[i][0], columns[0], p), inv(g[i][0], p), p) for i in range(len(g))]
        if not verify_frames(g, h, rows, columns, p):
            raise ArithmeticError('propagated frame verification failed')
        out.update(row_frames=rows, column_frames=columns)
    return out


def systematic_from_check(check, half, p):
    """Convert a promised full-rank AME check matrix to ordered half-set blocks.

    Rows are stabilizer labels; columns are (x_0,z_0,x_1,z_1,...).
    half lists the output parties; complementary input parties are increasing.
    """
    n = len(check)
    if n < 4 or n % 2 or any(len(row) != 2*n for row in check):
        raise ValueError('expected 2m rows and 4m columns, m>=2')
    if len(half) != n//2 or len(set(half)) != len(half) or any(i < 0 or i >= n for i in half):
        raise ValueError('invalid ordered half-set')
    other = [i for i in range(n) if i not in half]
    b = [[check[k][2*i+j] % p for k in range(n)] for i in half for j in range(2)]
    c = [[check[k][2*i+j] % p for k in range(n)] for i in other for j in range(2)]
    augmented, pivots = rref([row+[int(i == j) for j in range(n)]
                              for i, row in enumerate(c)], 2*n, p)
    if pivots != list(range(n)):
        raise ValueError('input half projection is singular: AME promise fails')
    ci = [row[n:] for row in augmented]
    g = [[sum(b[i][k]*ci[k][j] for k in range(n)) % p for j in range(n)] for i in range(n)]
    return [[(g[2*i][2*j], g[2*i][2*j+1], g[2*i+1][2*j], g[2*i+1][2*j+1])
             for j in range(n//2)] for i in range(n//2)]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', help='JSON file; default stdin')
    parser.add_argument('--decision-only', action='store_true')
    parser.add_argument('--seed', type=int, help='reproducible test seed, not cryptographic randomness')
    args = parser.parse_args()
    if args.input:
        with open(args.input, encoding='utf-8') as stream:
            request = json.load(stream)
    else:
        request = json.load(sys.stdin)
    p = request['prime']
    g, h = request.get('G'), request.get('H')
    if g is None:
        g = systematic_from_check(request['check_G'], request['half'], p)
        h = systematic_from_check(request['check_H'], request['half'], p)
    rng = random.Random(args.seed) if args.seed is not None else random.SystemRandom()
    print(json.dumps(recognize(g, h, p, witness=not args.decision_only, rng=rng), sort_keys=True))


if __name__ == '__main__':
    main()
