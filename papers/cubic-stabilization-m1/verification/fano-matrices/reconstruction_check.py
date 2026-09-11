"""Check the finite hypotheses of Przyjalkowski, Proposition 6.2.2.

Python standard library only. Inputs are the four printed index-one matrices
and the already transcribed CCGK regularized periods. This checks arithmetic,
not the geometric period formulas or the imported reconstruction theorem.
"""
import argparse
import ast
from fractions import Fraction as F
import hashlib
import json
from math import factorial
from pathlib import Path

HERE = Path(__file__).resolve().parent


def literal_assignment(path, name, keys=None):
    for node in ast.parse(path.read_text()).body:
        if isinstance(node, ast.Assign) and any(
            isinstance(t, ast.Name) and t.id == name for t in node.targets
        ):
            if keys is not None:
                assert isinstance(node.value, ast.Dict)
                return {ast.literal_eval(k): ast.literal_eval(v)
                        for k, v in zip(node.value.keys, node.value.values)
                        if ast.literal_eval(k) in keys}
            return ast.literal_eval(node.value)
    raise ValueError(name)


def period(matrix, order):
    """Solve D y=M(q)y, y(0)=e_3, M_ij(q)=M_ij(1)q^(j-i+1).

The constant subdiagonal N is nilpotent. At each positive degree n,
(n I-N)^(-1)=sum_{k=0}^3 N^k/n^(k+1). The scalar period is y_3.
"""
    coeffs = [[F(0), F(0), F(0), F(1)]]
    for n in range(1, order + 1):
        rhs = [sum((F(matrix[i][j]) * coeffs[n - (j - i + 1)][j]
                    for j in range(i, 4) if j - i + 1 <= n), F(0))
               for i in range(4)]
        coeffs.append([sum((rhs[i-k] / n**(k+1) for k in range(i+1)), F(0))
                       for i in range(4)])
    return [v[3] for v in coeffs]


def generate():
    data = literal_assignment(HERE / 'finite_checks.py', 'DATA', {'g2','g3','g4','g5'})
    regularized = literal_assignment(HERE / 'source_check.py', 'REGULARIZED')
    rows = []
    for genus in (2, 3, 4, 5):
        a, b, c, d, e, f = data[f'g{genus}']
        h = b-a
        matrix = [[0,c,e,f], [1,h,d,e], [0,1,h,c], [0,0,1,0]]
        expected = [F(v, factorial(n)) for n, v in
                    enumerate([1,0] + regularized[2*genus-2])]
        actual = period(matrix, 8)
        assert actual == expected, (genus, actual, expected)
        # Independent low-order formulas: source Example 5.4.
        first = [F(c,4), F(h*c,18)+F(e,27),
                 F(c*c,64)+F(h*h*c,96)+F(7*h*e,576)+F(c*d,128)+F(f,256)]
        assert first == actual[2:5]
        d2,d3,d4,d5 = expected[2:6]
        delta = -495*d3*d5 + 261*d2*d3*d3 - 312*d4*d2*d2 + 432*d2**4 + 56*d4*d4
        # Separately clear factorial denominators: 144*delta in regularized coefficients.
        r2,r3,r4,r5 = regularized[2*genus-2][:4]
        numerator = -99*r3*r5 + 522*r2*r3*r3 - 468*r4*r2*r2 + 3888*r2**4 + 14*r4*r4
        assert numerator == 144*delta
        assert delta != 0
        rows.append({'genus': genus, 'unshifted_counting_matrix': matrix,
                     'period_0_through_8': [str(x) for x in actual],
                     'source_example_5_4_matches': True,
                     'reconstruction_discriminant': str(delta),
                     'independent_cleared_numerator': numerator})
    # Printed V2-prime entry in arXiv:math/0507232v3, Theorem 2.6.6.
    # It is not imported: the normalized cubic coefficient detects the discrepancy.
    g2 = rows[0]['unshifted_counting_matrix']
    printed_d3 = F(g2[1][1]*g2[0][1],18) + F(119681240,27)
    discrepancy = F(rows[0]['period_0_through_8'][3]) - printed_d3
    assert discrepancy == F(40,27)
    return {'printed_g2_entry_comparison': {'printed': 119681240, 'reconstructed': 119681280,
            'period_degree_three_difference': str(discrepancy)}, 'status': 'PASS', 'source': 'arXiv:math/0410327v4, Proposition 6.2.2 and Example 5.4',
            'scope': 'Four index-one families g=2,3,4,5; finite uniqueness hypotheses and period agreement only',
            'inputs': {name: hashlib.sha256((HERE/name).read_bytes()).hexdigest()
                       for name in ('finite_checks.py','source_check.py')}, 'rows': rows}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    text = json.dumps(generate(), indent=2, sort_keys=True) + '\n'
    output = Path(__file__).with_suffix('.json')
    if args.check:
        if output.read_text() != text:
            raise SystemExit('FAIL: reconstruction certificate is stale')
    else:
        output.write_text(text)
    print('PASS: four period recursions and nonzero reconstruction discriminants; independent low-order and denominator checks.')


if __name__ == '__main__':
    main()
