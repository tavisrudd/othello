from __future__ import annotations

import argparse
import itertools
import json
import math
import shutil
import subprocess
import tempfile
from decimal import Decimal, localcontext
from collections import Counter
from pathlib import Path


def rref(matrix: list[list[int]], p: int) -> tuple[list[list[int]], list[int]]:
    if not matrix:
        return [], []
    a = [[x % p for x in row] for row in matrix]
    pivots = []
    row = 0
    for col in range(len(a[0])):
        pivot = next((i for i in range(row, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        inv = pow(a[row][col], -1, p)
        a[row] = [x * inv % p for x in a[row]]
        for i in range(len(a)):
            if i != row and a[i][col]:
                scale = a[i][col]
                a[i] = [(x - scale * y) % p for x, y in zip(a[i], a[row])]
        pivots.append(col)
        row += 1
        if row == len(a):
            break
    return a, pivots


def transpose(a: list[list[int]]) -> list[list[int]]:
    return [list(row) for row in zip(*a)]


def matmul(a: list[list[int]], b: list[list[int]], p: int) -> list[list[int]]:
    return [[sum(x*y for x, y in zip(row, col)) % p for col in zip(*b)] for row in a]


def nullspace(a: list[list[int]], p: int) -> list[list[int]]:
    rr, piv = rref(a, p)
    n = len(a[0])
    out = []
    for col in sorted(set(range(n)) - set(piv)):
        v = [0] * n
        v[col] = 1
        for i, j in enumerate(piv):
            v[j] = -rr[i][col] % p
        out.append(v)
    return out


def solve(a: list[list[int]], b: list[int], p: int) -> list[int]:
    rr, piv = rref([row + [y] for row, y in zip(a, b)], p)
    n = len(a[0])
    if n in piv:
        raise ValueError('Inconsistent linear system')
    x = [0] * n
    for i, j in enumerate(piv):
        x[j] = rr[i][-1]
    return x


def canonical_matching(edges: list[tuple[int, int]]) -> tuple[tuple[int, int], ...]:
    return tuple(sorted(tuple(sorted(edge)) for edge in edges))


def matching_orbit(p: int) -> tuple[list[tuple[tuple[int, int], ...]], list[int], tuple[tuple[int, int], ...]]:
    bases = {7: [(0, 2), (1, 4), (3, 7), (5, 6)],
             11: [(0, 1), (2, 5), (3, 7), (4, 9), (6, 8), (10, 11)]}
    base = canonical_matching(bases[p])
    found = {}
    for a, b, c, d in itertools.product(range(p), repeat=4):
        entries = (a, b, c, d)
        if next((x for x in entries if x), 0) != 1:
            continue
        determinant = (a*d - b*c) % p
        if not determinant:
            continue
        perm = []
        for x in range(p + 1):
            num, den = (a, c) if x == p else ((a*x+b) % p, (c*x+d) % p)
            perm.append(num * pow(den, -1, p) % p if den else p)
        m = canonical_matching([(perm[x], perm[y]) for x, y in base])
        sign = 1 if pow(determinant, (p-1)//2, p) == 1 else -1
        if m in found:
            assert found[m] == sign
        found[m] = sign
    orbit = sorted(found, key=lambda m: (-found[m], m))
    assert len(orbit) == 2*p
    return orbit, [found[m] for m in orbit], base


def polynomial_multiply(a: dict[tuple[int, int, int], int], b: dict[tuple[int, int, int], int], p: int) -> dict[tuple[int, int, int], int]:
    out = Counter()
    for u, x in a.items():
        for v, y in b.items():
            out[tuple(i+j for i, j in zip(u, v))] += x*y
    return {key: value % p for key, value in out.items() if value % p}


def matching_product(m: tuple[tuple[int, int], ...], p: int) -> dict[tuple[int, int, int], int]:
    poly = {(0, 0, 0): 1}
    for a, b in m:
        line = {(1, 0, 0): a, (0, 1, 0): -1} if b == p else {(1, 0, 0): a*b, (0, 1, 0): -a-b, (0, 0, 1): 1}
        poly = polynomial_multiply(poly, line, p)
    return poly


def divide_conic(a: dict[tuple[int, int, int], int], p: int) -> dict[tuple[int, int, int], int]:
    out = {}
    rem = {m: c % p for m, c in a.items() if c % p}
    while rem:
        m = max(rem)
        c = rem.pop(m)
        if not (m[0] and m[2]):
            raise ValueError(f'Nonzero conic remainder: {m}, {c}')
        q = (m[0]-1, m[1], m[2]-1)
        out[q] = c
        lower = (q[0], q[1]+2, q[2])
        rem[lower] = (rem.get(lower, 0) + c) % p
        if not rem[lower]:
            del rem[lower]
    return out


def cubic_coefficients(e: list[list[int]], signs: list[int], p: int) -> dict[str, int]:
    k = len(e[0])
    out = {}
    for triple in itertools.combinations_with_replacement(range(k), 3):
        multiplicity = 1 if len(set(triple)) == 1 else 3 if len(set(triple)) == 2 else 6
        value = multiplicity * sum(s * row[triple[0]] * row[triple[1]] * row[triple[2]] for s, row in zip(signs, e)) % p
        if value:
            out[','.join(map(str, triple))] = value
    return out


def construct(p: int) -> dict:
    orbit, signs, base = matching_orbit(p)
    base_poly = matching_product(base, p)
    degree = (p-3)//2
    monomials = sorted([(a, b, degree-a-b) for a in range(degree+1) for b in range(degree-a+1)], reverse=True)
    quotients = []
    for m in orbit:
        poly = matching_product(m, p)
        difference = {key: (poly.get(key, 0)-base_poly.get(key, 0)) % p for key in poly.keys() | base_poly.keys()}
        q = divide_conic(difference, p)
        quotients.append([q.get(mon, 0) for mon in monomials])
    _, columns = rref(quotients, p)
    e = [[row[j] for j in columns] for row in quotients]
    g = [[1] * (2*p)] + transpose(e)
    h = [[s*x % p for s, x in zip(signs, row)] for row in g]
    assert len(columns) == p-1
    assert len(rref(g, p)[1]) == p
    assert all(x == 0 for row in matmul(g, transpose(h), p) for x in row)
    square = [[x*y % p for x, y in zip(g[i], g[j])] for i in range(p) for j in range(i, p)]
    sqrank = len(rref(square, p)[1])
    assert sqrank == 2*p-1
    radical_constraints = [[sum(signs[i]*g[a][i]*g[b][i]*g[c][i] for i in range(2*p)) % p for c in range(p)] for a in range(p) for b in range(a, p)]
    radical = nullspace(radical_constraints, p)
    assert radical == [[1] + [0]*(p-1)]
    cubic = cubic_coefficients(e, signs, p)
    return {'p': p, 'n': 2*p, 'k': p-1, 'base_matching': base, 'matchings': orbit, 'signs': signs,
            'monomial_order': monomials, 'selected_monomials': [monomials[j] for j in columns],
            'E': e, 'G': g, 'H_Z': h, 'schur_square_rank': sqrank,
            'cubic_coefficients': cubic, 'cubic_radical_dimension': len(radical),
            'base_row': orbit.index(base)}



def analyze_tensor(entry: dict) -> dict:
    p, k, e, signs = entry['p'], entry['k'], entry['E'], entry['signs']
    t = [[[sum(s*row[a]*row[b]*row[c] for s, row in zip(signs, e)) % p
           for c in range(k)] for b in range(k)] for a in range(k)]
    equations = []
    for i, j, h in itertools.product(range(k), repeat=3):
        row = [0] * (k*k)
        for a in range(k):
            row[a*k+i] = (row[a*k+i] + t[a][j][h]) % p
            row[a*k+j] = (row[a*k+j] - t[i][a][h]) % p
        if any(row):
            equations.append(row)
    centroid_dimension = len(nullspace(equations, p))
    assert centroid_dimension == 1
    radial = solve(e, [int(s == -1) for s in signs], p)
    radial_hessian = [[sum(radial[a]*t[a][b][c] for a in range(k)) % p
                      for c in range(k)] for b in range(k)]
    assert len(rref(radial_hessian, p)[1]) == k-1
    constraints, zeros, stages = [], [], []
    basis = [[int(i == j) for j in range(k)] for i in range(k)]
    while basis:
        new = [i for i in range(k) if i not in zeros and
               all(sum(t[i][i][j]*v[j] for j in range(k)) % p == 0 for v in basis)]
        if not new:
            break
        zeros += new
        constraints += [t[i][j] for i in new for j in range(k)]
        basis = nullspace(constraints, p)
        stages.append({'zero_diagonal_indices': new, 'remaining_v_dimension': len(basis)})
    assert not basis
    if p == 7:
        change = [[0,1,0,0,0,0], [0,0,1,0,0,0], [1,0,0,1,0,0],
                  [3,0,0,1,0,0], [0,0,0,0,1,0], [0,0,0,0,0,1]]
        expected = {'0,1,5':4, '0,2,4':5, '0,3,3':5, '1,3,5':3,
                    '1,4,4':4, '2,2,5':4, '2,3,4':6, '3,3,3':4}
    else:
        change = [[0]*10 for _ in range(10)]
        for old, new, value in [(0,1,1), (1,2,1), (2,3,7), (3,4,6),
                                (4,0,3), (4,5,6), (5,0,1), (5,5,3),
                                (6,6,6), (7,7,7), (8,8,1), (9,9,1)]:
            change[old][new] = value
        expected = {'0,1,9':8, '0,2,8':2, '0,3,7':4, '0,4,6':3,
                    '0,5,5':5, '1,5,9':1, '1,6,8':7, '1,7,7':3,
                    '2,4,9':7, '2,5,8':1, '2,6,7':3, '3,3,9':3,
                    '3,4,8':3, '3,6,6':2, '4,4,7':2, '4,5,6':8,
                    '5,5,5':4}
    assert len(rref(change, p)[1]) == k
    canonical = cubic_coefficients(matmul(e, change, p), signs, p)
    assert canonical == expected
    entry.update(centroid_dimension=centroid_dimension, radial_vector=radial,
                 radial_hessian_rank=k-1, rank_one_exclusion=stages,
                 no_rank_one_hessian=True, canonical_coordinate_matrix=change,
                 canonical_cubic_coefficients=canonical)
    return entry


def complete_weight_enumerator(entry: dict, executable: Path) -> dict:
    p, n, g = entry['p'], entry['n'], entry['G']
    text = f'{p} {p} {n}\n' + '\n'.join(' '.join(map(str, row)) for row in g) + '\n'
    result = subprocess.run([str(executable)], input=text, text=True,
                            capture_output=True, check=True)
    weights = [int(line.split()[1]) for line in result.stdout.splitlines()]
    assert len(weights) == n+1 and sum(weights) == p**p
    for j in range(n+1):
        transform = sum(weights[w] * sum((-1)**a * (p-1)**(j-a) *
                                        math.comb(w, a) * math.comb(n-w, j-a)
                                        for a in range(max(0, j-n+w), min(j, w)+1))
                        for w in range(n+1))
        assert transform == p**p * weights[j]
    distance = next(w for w in range(1, n+1) if weights[w])
    assert distance == (6 if p == 7 else 8)
    witness = None
    for indices in itertools.combinations(range(n), distance):
        dependencies = nullspace([[row[i] for i in indices] for row in g], p)
        if dependencies:
            witness = {'support_zero_based': indices, 'kernel_G_values': dependencies[0]}
            break
    examples = []
    with localcontext() as context:
        context.prec = 45
        for delta in map(Decimal, ['0.0001', '0.001', '0.01', '0.02']):
            acceptance = (1 + (p-1)*(1-Decimal(p)*delta/(p-1))**n)/p
            benign = sum(Decimal(count)*(1-delta)**(n-w)*(delta/(p-1))**w
                         for w, count in enumerate(weights))
            examples.append({'input_error': str(delta), 'acceptance': str(acceptance),
                             'conditional_block_infidelity': str(1-benign/acceptance)})
    entry.update(weight_enumerator=weights, classical_distance=distance,
                 minimum_word_witness=witness, noise_examples=examples)
    return entry


def brute_force_seven(entry: dict) -> None:
    import numpy as np
    g = np.array(entry['G'], dtype=np.int64)
    hist = np.zeros(15, dtype=np.int64)
    powers = 7**np.arange(7, dtype=np.int64)
    for start in range(0, 7**7, 10000):
        words = (np.arange(start, min(start+10000, 7**7), dtype=np.int64)[:, None] // powers) % 7
        hist += np.bincount(np.count_nonzero(words @ g % 7, axis=1), minlength=15)
    assert hist.tolist() == entry['weight_enumerator']


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path, default=Path('clebsch_quantum_data.json'))
    parser.add_argument('--enumerators', action='store_true')
    parser.add_argument('--bruteforce-seven', action='store_true')
    args = parser.parse_args()
    if args.bruteforce_seven and not args.enumerators:
        parser.error('--bruteforce-seven requires --enumerators')
    data = [analyze_tensor(construct(p)) for p in (7, 11)]
    if args.enumerators:
        compiler = shutil.which('g++') or shutil.which('clang++')
        if compiler is None:
            parser.error('--enumerators requires g++ or clang++')
        source = Path(__file__).with_name('weight_enumerator.cpp')
        with tempfile.TemporaryDirectory() as directory:
            executable = Path(directory) / 'weight_enumerator'
            subprocess.run([compiler, '-O3', '-std=c++17', str(source), '-o', str(executable)], check=True)
            data = [complete_weight_enumerator(entry, executable) for entry in data]
    if args.bruteforce_seven:
        brute_force_seven(data[0])
    args.output.write_text(json.dumps(data, indent=2) + '\n')
    for entry in data:
        keys = ('p', 'n', 'k', 'schur_square_rank', 'centroid_dimension',
                'radial_hessian_rank', 'no_rank_one_hessian', 'classical_distance')
        print({key: entry[key] for key in keys if key in entry})
    print(f'All requested exact checks passed; output: {args.output}')


if __name__ == '__main__':
    main()
