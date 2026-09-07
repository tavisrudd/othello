"""Exact p=7, same-target comparison with separate cubic-primitive distillation.

python3 notes/2026-09-07-c1102-factory-benchmark/benchmark.py --write
python3 notes/2026-09-07-c1102-factory-benchmark/benchmark.py --check
Standard library only. Uniform independent nonzero Z noise; ideal Clifford operations.
"""
import argparse
from fractions import Fraction as Q
from itertools import combinations_with_replacement, product
import hashlib
import json
from math import comb
from pathlib import Path
import runpy

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parent.parent
INPUT = REPO / 'notes/2026-09-06-clebsch-quantum-replay/common.py'
P = 7

def rref(rows):
    a = [list(row) for row in rows]
    pivots = []
    for col in range(len(a[0])):
        pivot = next((i for i in range(len(pivots), len(a)) if a[i][col] % P), None)
        if pivot is None:
            continue
        k = len(pivots)
        a[k], a[pivot] = a[pivot], a[k]
        inv = pow(a[k][col] % P, -1, P)
        a[k] = [x * inv % P for x in a[k]]
        for i in range(len(a)):
            if i != k:
                c = a[i][col]
                a[i] = [(x - c*y) % P for x, y in zip(a[i], a[k])]
        pivots.append(col)
    return a[:len(pivots)], pivots

def perp(rows):
    a, pivots = rref(rows)
    out = []
    for j in range(len(rows[0])):
        if j not in pivots:
            row = [0] * len(rows[0]); row[j] = 1
            for i, col in enumerate(pivots):
                row[col] = -a[i][j] % P
            out.append(row)
    return out

def weight_enumerator(rows):
    rows, _ = rref(rows)
    n = len(rows[0]); counts = [0]*(n+1)
    def visit(i, word):
        if i == len(rows):
            counts[sum(x != 0 for x in word)] += 1
            return
        for _ in range(P):
            visit(i+1, word)
            word = [(x+y) % P for x, y in zip(word, rows[i])]
    visit(0, [0]*n)
    assert sum(counts) == P**len(rows)
    return counts

def macwilliams(a):
    n = len(a)-1; size = sum(a); out = []
    for j in range(n+1):
        numerator = sum(count * sum((-1)**t * (P-1)**(j-t) * comb(w, t) * comb(n-w, j-t)
            for t in range(max(0, j-(n-w)), min(w, j)+1)) for w, count in enumerate(a))
        assert numerator % size == 0
        out.append(numerator // size)
    assert all(x >= 0 for x in out)
    return out

def probability(a, delta):
    n = len(a)-1
    return sum(count*(1-delta)**(n-w)*(delta/(P-1))**w for w, count in enumerate(a))

def support_enumerator(rows):
    counts = [0]*(2**len(rows[0]))
    for coefficients in product(range(P), repeat=len(rows)):
        word = [sum(c*row[j] for c,row in zip(coefficients,rows)) % P for j in range(len(rows[0]))]
        counts[sum(1<<j for j,x in enumerate(word) if x)] += 1
    return counts

def heterogeneous_probability(counts, errors):
    value = Q(0)
    for mask,count in enumerate(counts):
        term = Q(count)
        for j,error in enumerate(errors):
            term *= error/6 if mask & (1<<j) else 1-error
        value += term
    return value

def module(name, s, logical, weights):
    l = s + [logical]; n = len(logical)
    assert len(rref(l)[0]) == len(s)+1
    for a in s:
        for b in l:
            for c in l:
                assert sum(w*x*y*z for w, x, y, z in zip(weights, a, b, c)) % P == 0
    coefficient = sum(w*x**3 for w, x in zip(weights, logical)) % P
    assert coefficient == 6  # Coordinate negation supplies the positive cubic.
    good = weight_enumerator(perp(l))
    accepted = weight_enumerator(perp(s))
    assert good == macwilliams(weight_enumerator(l))
    assert accepted == macwilliams(weight_enumerator(s))
    bad = [a-b for a, b in zip(accepted, good)]
    distance_z = next(w for w, count in enumerate(bad) if count)
    # Enumerate logical cosets independently to determine X distance.
    distance_x = n
    for coefficients in product(range(P), repeat=len(l)):
        if coefficients[-1]:
            word = [sum(c*row[j] for c, row in zip(coefficients, l)) % P for j in range(n)]
            distance_x = min(distance_x, sum(x != 0 for x in word))
    return dict(name=name, n=n, S=s, logical=logical, weights=weights,
                phase_coefficient=coefficient, d_X=distance_x, d_Z=distance_z,
                good=good, accepted=accepted, leading_error=Q(bad[distance_z], 6**distance_z))

def rational(value):
    return str(value.numerator) + '/' + str(value.denominator)

def serialize(obj):
    if isinstance(obj, Q):
        return {'exact': rational(obj), 'decimal': float(obj)}
    if isinstance(obj, dict):
        return {k: serialize(v) for k, v in obj.items()}
    if isinstance(obj, (list, tuple)):
        return [serialize(v) for v in obj]
    return obj

def generate():
    data = runpy.run_path(str(INPUT)); e = data['E7']; signs = [1]*7+[6]*7
    g = [[1]*14] + [list(col) for col in zip(*e)]
    assert len(rref(g)[0]) == 7
    assert all(sum(s*x*y for s, x, y in zip(signs, a, b)) % P == 0 for a in g for b in g)
    native_good = weight_enumerator(perp(g))
    native_l = weight_enumerator(g)
    assert native_good == macwilliams(native_l) == native_l
    assert {i:a for i,a in enumerate(native_good) if a} == data['A7_CLAIM']
    native_accepted = macwilliams(weight_enumerator([[1]*14]))
    assert native_accepted[1] == 0 and native_accepted[2] == 546 and native_good[2] == 0

    forms = [row for row in e if any(row)]
    assert len(forms) == 13
    exponents = list(combinations_with_replacement(range(6), 3))
    cubics = [[row[i]*row[j]*row[k] % P for i, j, k in exponents] for row in forms]
    assert len(rref(cubics)[0]) == 13
    derivative_flattening = [[sum(sign*row[a]*row[b]*row[c] for sign,row in zip(signs,e)) % P
        for b,c in combinations_with_replacement(range(6),2)] for a in range(6)]
    assert len(rref(derivative_flattening)[0]) == 6
    synthesis_rows = [list(col) for col in zip(*forms)]
    synthesis_enum = weight_enumerator(synthesis_rows)
    synthesis_kernel = weight_enumerator(perp(synthesis_rows))
    assert synthesis_kernel == macwilliams(synthesis_enum)
    assert sum(synthesis_enum) == P**6

    four = module('weighted RS 4-to-1', [[1]*4], [0,1,2,3], [6,3,4,1])
    six = module('QRM7(1) 6-to-1', [[1,2,3,4,5,6]], [1]*6, [1]*6)
    seven = module('RS 7-to-1', [[1]*7, list(range(7))], [x*x % P for x in range(7)], [1]*7)
    modules = [four, six, seven]
    four_good_support = support_enumerator(perp(four['S']+[four['logical']]))
    four_acc_support = support_enumerator(perp(four['S']))
    assert [(m['d_X'],m['d_Z']) for m in modules] == [(3,2),(5,2),(5,3)]
    assert [m['leading_error'] for m in modules] == [Q(1),Q(5,2),Q(35,36)]

    table = []
    for delta in [Q(1,10000), Q(1,1000), Q(1,100)]:
        acceptance = probability(native_accepted, delta)
        assert acceptance == (1+6*(1-Q(7,6)*delta)**14)/7
        error = 1-probability(native_good, delta)/acceptance
        cost = 14/acceptance
        comparisons = []
        for m in modules:
            a = probability(m['accepted'], delta)
            q = 1-probability(m['good'], delta)/a
            t = 1-Q(7,6)*q
            # Fourier evaluation includes every cancellation among synthesis errors.
            final_error = 1-sum(count*t**w for w,count in enumerate(synthesis_enum))/P**6
            assert final_error == 1-probability(synthesis_kernel,q)
            assert q <= final_error <= 13*q
            comparisons.append(dict(module=m['name'], acceptance=a, primitive_error=q,
                synthesis_block_error=final_error, expected_raw=13*m['n']/a,
                meets_native_target=final_error <= error,
                cost_ratio_vs_native=(13*m['n']/a)/cost))
        # Same sign-only raw source as the native factory: M_3 and M_-3 use
        # three injected M_1 or M_-1 gates each, with convolved error labels.
        composed_error = Q(6,7)*(1-(1-Q(7,6)*delta)**3)
        physical_errors = [delta,composed_error,composed_error,delta]
        a4sign = heterogeneous_probability(four_acc_support,physical_errors)
        q4sign = 1-heterogeneous_probability(four_good_support,physical_errors)/a4sign
        t4sign = 1-Q(7,6)*q4sign
        final4sign = 1-sum(count*t4sign**w for w,count in enumerate(synthesis_enum))/P**6
        assert final4sign == 1-probability(synthesis_kernel,q4sign)
        comparisons.append(dict(module='4-to-1 compiled from sign-only raw resources (8 inputs)',
            acceptance=a4sign,primitive_error=q4sign,synthesis_block_error=final4sign,
            expected_raw=13*8/a4sign,meets_native_target=final4sign<=error,
            cost_ratio_vs_native=(13*8/a4sign)/cost))
        assert comparisons[0]['meets_native_target'] and comparisons[2]['meets_native_target']
        assert not comparisons[1]['meets_native_target']
        table.append(dict(input_error=delta, native_acceptance=acceptance,
            native_block_error=error, native_expected_raw=cost,
            all_separate_architectures_cost_lower_bound=36,
            guaranteed_cost_factor=36/cost,
            sign_only_menu_cost_lower_bound=54,sign_only_guaranteed_cost_factor=54/cost,
            explicit_13_term_comparisons=comparisons))

    # Constants used in the interval proof, valid for 0 < delta <= 1/100.
    b = Q(99,100)
    constants = dict(native_cost_upper_bound=14/b**14,
        separate_cost_lower_bound=36, guaranteed_cost_factor=36*b**14/14,
        synthesis_four_error_coefficient_upper_bound=13/b**4,
        native_error_coefficient_lower_bound=Q(91,6),
        native_error_over_delta_upper_bound=Q(91,600)/b**14,
        native_lower_bound_auxiliary=2-Q(182,100))
    constants['catalecticant_only_separate_cost_lower_bound'] = 24
    constants['catalecticant_only_cost_factor'] = 24*b**14/14
    constants['sign_only_menu_cost_lower_bound'] = 54
    constants['sign_only_menu_cost_factor'] = 54*b**14/14
    constants['synthesis_seven_error_coefficient_upper_bound'] = Q(455,100)/b**7
    assert constants['sign_only_menu_cost_factor'] > Q(335,100)
    assert constants['synthesis_seven_error_coefficient_upper_bound'] < Q(91,6)
    assert constants['guaranteed_cost_factor'] > Q(223,100)
    assert constants['synthesis_four_error_coefficient_upper_bound'] < Q(91,6)
    assert constants['native_error_over_delta_upper_bound'] < 1
    assert constants['native_lower_bound_auxiliary'] > 0
    return serialize(dict(field=7, input_error_interval='0 < delta <= 1/100',
        baseline='Independent primitive distillation with 4/6/7-to-1 modules and any concatenation, then weighted Waring synthesis; all nonzero cubic coefficients have equal raw cost.',
        rank_bound={'lower':9,'upper':13,'source':'notes/2026-09-07-c1090-resource-classification/REPORT.md section 4.1','lower_bound_reproved_here':False},
        native_good=native_good, native_accepted=native_accepted,
        synthesis_word_enumerator=synthesis_enum, synthesis_kernel_enumerator=synthesis_kernel,
        four_good_support=four_good_support,four_accepted_support=four_acc_support,
        derivative_flattening_rank=6, modules=modules, interval_constants=constants, table=table))

def hashes():
    paths = [ROOT/'benchmark.py', ROOT/'certificate.json', INPUT,
        REPO/'notes/2026-09-07-c1090-resource-classification/REPORT.md',
        REPO/'notes/2026-09-06-clebsch-quantum-replay/astra-bundle/clebsch_quantum_research_memo.md']
    return '\n'.join(f'{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.relative_to(REPO)}  {p.stat().st_size}' for p in paths)+'\n'

if __name__ == '__main__':
    parser = argparse.ArgumentParser(); group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--write', action='store_true'); group.add_argument('--check', action='store_true')
    args = parser.parse_args(); cert = json.dumps(generate(),indent=2,sort_keys=True)+'\n'
    if args.write:
        (ROOT/'certificate.json').write_text(cert)
        (ROOT/'SHA256SUMS').write_text(hashes())
    else:
        assert cert == (ROOT/'certificate.json').read_text()
        assert hashes() == (ROOT/'SHA256SUMS').read_text()
    print('PASS: exact native and 4/6/7-to-1 enumerators, independent MacWilliams checks, synthesis cancellations, and interval constants.')
    print('Native raw-resource cost improves by a factor >2.23 over every baseline in the specified separate-distillation model for 0 < delta <= 0.01.')
