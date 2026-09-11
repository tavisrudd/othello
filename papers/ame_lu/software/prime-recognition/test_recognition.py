#!/usr/bin/env python3
"""Exact finite-domain tests and independent exhaustive reference oracles."""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import itertools as it
import json
from pathlib import Path
import random
import subprocess
import sys
import unittest

import recognition as fast

SEED = 1139
ROOT = Path(__file__).resolve().parent


def subspaces(p):
    # Canonical RREF enumeration; no production elimination is used.
    for d in range(5):
        for pivots in it.combinations(range(4), d):
            free = [(i, j) for i in range(d) for j in range(pivots[i]+1, 4)
                    if j not in pivots]
            for coefficients in it.product(range(p), repeat=len(free)):
                rows = [[int(j == pivot) for j in range(4)] for pivot in pivots]
                for (i, j), c in zip(free, coefficients):
                    rows[i][j] = c
                yield tuple(map(tuple, rows))


def oracle_vectors(basis, p):
    return {tuple(sum(c*v[j] for c, v in zip(coeff, basis)) % p for j in range(4))
            for coeff in it.product(range(p), repeat=len(basis))}


def oracle_det(a, p):
    return (a[0]*a[3]-a[1]*a[2]) % p


def oracle_product(a, b, p):
    aa, bb = (a[:2], a[2:]), (b[:2], b[2:])
    return tuple(sum(aa[i][k]*bb[k][j] for k in range(2)) % p
                 for i in range(2) for j in range(2))


def sl2(p):
    return [a for a in it.product(range(p), repeat=4) if oracle_det(a, p) == 1]


def oracle_intertwiner(g, h, group, p):
    return next((a for a in group if all(oracle_product(a, x, p) == oracle_product(y, a, p)
                                       for x, y in zip(g, h))), None)


def oracle_systematic(g, h, p):
    # Exhaustively choose the first row frame. Recover others by table search,
    # not by the production cycle equations or matrix inverse routine.
    group = sl2(p)
    for a in group:
        columns = []
        for j in range(len(g)):
            target = oracle_product(a, g[0][j], p)
            d = next((d for d in group if oracle_product(h[0][j], d, p) == target), None)
            if d is None:
                break
            columns.append(d)
        if len(columns) != len(g):
            continue
        rows = []
        for i in range(len(g)):
            target = oracle_product(h[i][0], columns[0], p)
            b = next((b for b in group if oracle_product(b, g[i][0], p) == target), None)
            if b is None:
                break
            rows.append(b)
        if len(rows) == len(g) and all(oracle_product(rows[i], g[i][j], p) ==
                                       oracle_product(h[i][j], columns[j], p)
                                       for i in range(len(g)) for j in range(len(g))):
            return True
    return False


def classical_check(m, p):
    # CSS state of the systematic classical MDS code [I | Cauchy].
    if 2*m > p:
        raise ValueError('Cauchy parameters require 2m<=p')
    c = [[pow(i-(m+j), -1, p) for j in range(m)] for i in range(m)]
    check = []
    for i in range(m):
        x = [int(i == j) for j in range(m)] + c[i]
        check.append([z for a in x for z in (a, 0)])
    for i in range(m):
        z = [-c[j][i] % p for j in range(m)] + [int(i == j) for j in range(m)]
        check.append([a for b in z for a in (0, b)])
    return check


def random_sl(p, rng):
    a = rng.randrange(1, p)
    b, c = rng.randrange(p), rng.randrange(p)
    return (a, b, c, (1+b*c)*pow(a, -1, p) % p)


def transform_check(check, frames, p):
    result = []
    for row in check:
        out = []
        for i, a in enumerate(frames):
            x, z = row[2*i:2*i+2]
            out.extend(((a[0]*x+a[1]*z) % p, (a[2]*x+a[3]*z) % p))
        result.append(out)
    return result


def evaluate():
    rng = random.Random(SEED)
    output = {'schema': 1, 'seed': SEED, 'subspaces': [], 'tuples': [], 'systematic': []}
    for p in (2, 3, 5, 7):
        count = positive = 0
        ranks = Counter()
        witness_digest = hashlib.sha256()
        for basis in subspaces(p):
            members = oracle_vectors(basis, p)
            expected = any(oracle_det(v, p) == 1 for v in members)
            decision, absent = fast.determinant_one(basis, p, witness=False)
            stats = {}
            answer, matrix = fast.determinant_one(basis, p, rng=rng, stats=stats)
            assert absent is None and decision == answer == expected, (p, basis)
            if expected:
                assert matrix in members and oracle_det(matrix, p) == 1
                positive += 1
            elif matrix is not None:
                raise AssertionError('negative result carried a witness')
            ranks[str(stats.get('quadratic_rank', 'binary'))] += 1
            witness_digest.update(json.dumps([basis, answer, matrix], separators=(',', ':')).encode())
            count += 1
        output['subspaces'].append({'prime': p, 'count': count, 'positive': positive,
                                    'ranks': dict(sorted(ranks.items())),
                                    'witness_sha256': witness_digest.hexdigest()})
    for p in (2, 3):
        matrices = list(it.product(range(p), repeat=4))
        group = sl2(p)
        count = positive = 0
        for a, b in it.product(matrices, repeat=2):
            basis = fast.intertwiner_space([a], [b], p)
            yes, w = fast.determinant_one(basis, p, rng=rng)
            expected = oracle_intertwiner([a], [b], group, p) is not None
            assert yes == expected
            if w is not None:
                assert oracle_product(w, a, p) == oracle_product(b, w, p)
            count += 1
            positive += yes
        output['tuples'].append({'prime': p, 'all_single_matrix_pairs': count, 'positive': positive})
    # Simultaneous constraints, including spaces of dimensions zero and one.
    random_tuples = 0
    for p in (2, 3, 5, 7, 11):
        group = sl2(p)
        for length in (2, 3, 5):
            for _ in range(24):
                g = [tuple(rng.randrange(p) for _ in range(4)) for _ in range(length)]
                h = [tuple(rng.randrange(p) for _ in range(4)) for _ in range(length)]
                expected = oracle_intertwiner(g, h, group, p) is not None
                basis = fast.intertwiner_space(g, h, p)
                yes, w = fast.determinant_one(basis, p, rng=rng)
                assert yes == expected
                if yes:
                    assert all(oracle_product(w, x, p) == oracle_product(y, w, p) for x, y in zip(g, h))
                random_tuples += 1
    output['random_tuple_cases'] = random_tuples
    for p in (2, 3, 5):
        group = sl2(p)
        gl = [a for a in it.product(range(p), repeat=4) if oracle_det(a, p)]
        count = positive = 0
        for m in (2, 3):
            for trial in range(32):
                g = [[rng.choice(gl) for _ in range(m)] for _ in range(m)]
                if trial % 2:
                    rows = [rng.choice(group) for _ in range(m)]
                    columns = [rng.choice(group) for _ in range(m)]
                    h = [[fast.mul(fast.mul(rows[i], g[i][j], p), fast.inv(columns[j], p), p)
                          for j in range(m)] for i in range(m)]
                else:
                    h = [[rng.choice(gl) for _ in range(m)] for _ in range(m)]
                expected = oracle_systematic(g, h, p)
                answer = fast.recognize(g, h, p, rng=rng)
                assert answer['equivalent'] == expected
                assert fast.recognize(g, h, p, witness=False)['equivalent'] == expected
                if expected:
                    assert fast.verify_frames(g, h, answer['row_frames'], answer['column_frames'], p)
                count += 1
                positive += expected
        output['systematic'].append({'prime': p, 'cases': count, 'positive': positive})
    # Genuine stabilizer-AME check matrices, varied row bases and balanced cuts.
    ame_cases = 0
    for p in (5, 7, 11, 17):
        for m in range(2, min(5, p//2)+1):
            check = classical_check(m, p)
            for _ in range(8):
                frames = [random_sl(p, rng) for _ in range(2*m)]
                target = transform_check(check, frames, p)
                # Invertible elementary generator-row changes must not affect the graph.
                target[0] = [(a+3*b) % p for a, b in zip(target[0], target[-1])]
                half = rng.sample(range(2*m), m)
                g = fast.systematic_from_check(check, half, p)
                h = fast.systematic_from_check(target, half, p)
                result = fast.recognize(g, h, p, rng=rng)
                assert result['equivalent']
                assert fast.verify_frames(g, h, result['row_frames'], result['column_frames'], p)
                ame_cases += 1
    output['ame_positive_cases'] = ame_cases
    # Positive and negative fixed-party comparisons of genuine four-party AME states.
    four_party = []
    for a in (2, 3, 4):
        c = [[1, 1], [1, a]]
        check = [[z for x in ([int(i == j) for j in range(2)]+c[i]) for z in (x, 0)]
                 for i in range(2)]
        check += [[x for z in ([-c[j][i] % 5 for j in range(2)]+[int(i == j) for j in range(2)])
                   for x in (0, z)] for i in range(2)]
        four_party.append(fast.systematic_from_check(check, [0, 1], 5))
    outcomes = Counter()
    for g, h in it.product(four_party, repeat=2):
        expected = oracle_systematic(g, h, 5)
        assert fast.recognize(g, h, 5, rng=rng)['equivalent'] == expected
        outcomes[str(expected)] += 1
    output['ame_four_party_pairs'] = dict(sorted(outcomes.items()))
    # Known primes with long encodings; no enumeration of the field or SL2.
    output['large_prime_cases'] = []
    for p in (65537, 2147483647, 2**61-1, 2**127-1, 2**255-19):
        stats = {}
        for _ in range(16):
            a = rng.randrange(p)
            root = fast.square_root(a*a % p, p, rng, stats)
            assert root*root % p == a*a % p
        check = classical_check(4, p)
        target = transform_check(check, [random_sl(p, rng) for _ in range(8)], p)
        g = fast.systematic_from_check(check, [0, 2, 4, 6], p)
        h = fast.systematic_from_check(target, [0, 2, 4, 6], p)
        answer = fast.recognize(g, h, p, rng=rng)
        assert answer['equivalent'] and fast.verify_frames(g, h, answer['row_frames'], answer['column_frames'], p)
        output['large_prime_cases'].append({'prime': str(p), 'bits': p.bit_length(), 'square_roots': 16,
                                            'witness_verified': True})
    return output


class RegressionTests(unittest.TestCase):
    def test_roots_exhaustive(self):
        rng = random.Random(SEED)
        for p in (2, 3, 5, 7, 11, 13, 17, 19, 29, 97, 257):
            squares = {x*x % p for x in range(p)}
            for a in range(p):
                x = fast.square_root(a, p, rng)
                self.assertEqual(x is not None, a in squares)
                if x is not None:
                    self.assertEqual(x*x % p, a)

    def test_decision_uses_no_randomness(self):
        class RejectRandom:
            def randrange(self, *_):
                raise AssertionError('decision requested randomness')
        yes, _ = fast.determinant_one([(1, 0, 0, 0), (0, 0, 0, 1)], 17,
                                     witness=False, rng=RejectRandom())
        self.assertTrue(yes)

    def test_redundant_basis_and_zero_form(self):
        self.assertFalse(fast.determinant_one([(1, 0, 0, 0), (0, 1, 0, 0)], 5)[0])
        self.assertTrue(fast.determinant_one([fast.I2, fast.I2, (0, 0, 0, 0)], 5)[0])
        self.assertFalse(fast.determinant_one([(1, 0, 0, 2)], 5)[0])
        self.assertEqual(len(fast.diagonalize([(1, 0, 0, 0), (0, 0, 0, 1)], 5)), 2)

    def test_cli_and_invalid_shapes(self):
        check = classical_check(2, 5)
        request = {'prime': 5, 'check_G': check, 'check_H': check, 'half': [0, 1]}
        data = subprocess.check_output([sys.executable, str(ROOT/'recognition.py'), '--seed', '1139'],
                                       input=json.dumps(request), text=True)
        self.assertTrue(json.loads(data)['equivalent'])
        with self.assertRaises(ValueError):
            fast.recognize([[(0, 0, 0, 0)]], [[fast.I2]], 5)
        with self.assertRaises(ValueError):
            fast.systematic_from_check([[0]*8 for _ in range(4)], [0, 1], 5)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--write', action='store_true')
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    result = unittest.TextTestRunner(verbosity=1).run(unittest.defaultTestLoader.loadTestsFromTestCase(RegressionTests))
    if not result.wasSuccessful():
        raise SystemExit(1)
    if args.write or args.check:
        result = evaluate()
        text = json.dumps(result, indent=2, sort_keys=True)+'\n'
        path = ROOT/'test-results.json'
        if args.write:
            path.write_text(text)
        else:
            assert path.read_text() == text, 'canonical test output differs'
        print(json.dumps({'subspaces': sum(x['count'] for x in result['subspaces']),
                          'single_matrix_pairs': sum(x['all_single_matrix_pairs'] for x in result['tuples']),
                          'random_tuples': result['random_tuple_cases'],
                          'systematic_cases': sum(x['cases'] for x in result['systematic']),
                          'ame_cases': result['ame_positive_cases'],
                          'large_primes': len(result['large_prime_cases'])}, sort_keys=True))


if __name__ == '__main__':
    main()
