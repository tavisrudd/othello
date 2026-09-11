#!/usr/bin/env python3
"""Compare inspected, hash-pinned Zenodo reconstructions with Fano counting matrices.

Replay with SymPy 1.14.0. Obtain the two source scripts from DOI 10.5281/zenodo.20625923;
--source-dir can point to another directory containing the same two files.
This checks provenance compatibility, not GW reconstruction or deformation.
"""
import argparse
import ast
import contextlib
import hashlib
import io
import json
from math import factorial
from fractions import Fraction
from pathlib import Path
import runpy
import sympy as sp

HERE = Path(__file__).resolve().parent
SOURCES = {
    1: ('fano_threefolds_rk1index1.py',
        'a8e94d07b549657cfc69ae3f7cd2236cef083d3d327c9b34b24e785ac2b91b0e'),
    2: ('fano_threefolds_rk1index2.py',
        'd4b4db2f194913049e57fbf389fd6cdb68d15e2431b315eee845aa9d7c4a4a22'),
}

# Regularized coefficients t^2,...,t^8, transcribed from CCGK v3,
# sections 8--17 (cached PDF SHA a01ad889...782d9686).
REGULARIZED = {
    2: [68760,55200000,61054781400,71591389125120,88808827978814400,
        114426010259814758400,151686694219076253783000],
    4: [1944,215808,35295192,5977566720,1073491139520,
        199954313717760,38302652395770840],
    6: [396,17616,1217052,85220640,6349812480,490029523200,38883641777820],
    8: [152,3840,157656,6428160,280064960,12618762240,584579486680],
    10: [78,1320,37746,1051920,31464780,971757360,30859805970],
    12: [48,600,13176,276480,6259800,146064240,3505282200],
    14: [32,312,5520,91680,1651640,30604560,583436560],
    16: [24,192,2904,40320,611520,9515520,152412120],
    18: [18,120,1566,18360,237060,3129840,42576030],
    22: [12,60,636,5760,58620,604800,6447420],
}


def index_two_period(degree, n):
    """CCGK sections 3--7; q=t^2. Compute published closed formulas."""
    f = factorial
    if degree == 1:
        return Fraction(f(6*n), f(n)**3*f(2*n)*f(3*n))
    if degree == 2:
        return Fraction(f(4*n), f(n)**4*f(2*n))
    if degree == 3:
        return Fraction(f(3*n), f(n)**5)
    if degree == 4:
        return Fraction(f(2*n)**2, f(n)**6)
    return (-1)**n * sum(
        (Fraction(f(n)**3, f(n-m)**5*f(m)**5)
         * (1-5*(2*m-n)*sum((Fraction(1,j) for j in range(1,m+1)), Fraction())))
        for m in range(n+1))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-dir', type=Path, required=True)
    args = parser.parse_args()
    assert sp.__version__ == '1.14.0'
    table = runpy.run_path(str(HERE / 'finite_checks.py'))
    rows = []
    for index, (filename, digest) in SOURCES.items():
        source = args.source_dir / filename
        raw = source.read_bytes()
        assert hashlib.sha256(raw).hexdigest() == digest
        # The complete scripts were inspected. Omit only their final display
        # loops; execute their original imports, assignments and definitions.
        tree = ast.parse(raw, filename=str(source))
        assert isinstance(tree.body[-1], ast.For)
        assert all(isinstance(n, (ast.Import, ast.Assign, ast.FunctionDef))
                   for n in tree.body[:-1])
        tree.body.pop()
        namespace = {}
        exec(compile(tree, str(source), 'exec'), namespace)
        for degree in namespace['PERIODS']:
            coeffs = namespace['PERIODS'][degree]
            for n in range(9):
                if index == 2:
                    expected_period = index_two_period(degree, n)
                else:
                    regularized = [1,0] + REGULARIZED[degree]
                    expected_period = Fraction(regularized[n], factorial(n))
                assert coeffs[n] == expected_period, (index,degree,n)
            with contextlib.redirect_stdout(io.StringIO()):
                result = namespace['Return'](degree)
            family = f'g{degree // 2 + 1}' if index == 1 else f'd{degree}'
            source_matrix = result['M'].subs(namespace['q'], 1).T
            diagonal = ([1, 1, degree, degree] if index == 1 else
                        [1, 2, 4 * degree, 8 * degree])
            basis = sp.diag(*diagonal)
            shift = table['DATA'][family][0]
            normalized = basis.inv() * source_matrix * basis + shift * sp.eye(4)
            expected = table['quantum_matrix'](table['DATA'][family])
            assert normalized == expected, family
            rows.append({'family': family, 'source_file': filename,
                         'degree': degree, 'basis_diagonal': diagonal,
                         'scalar_shift': str(shift),
                         'period_coefficients_0_through_8_match': True,
                         'exact_matrix_equality': True})
    assert len(rows) == 15
    output = {'status': 'PASS', 'sympy': sp.__version__,
              'source_record': 'https://doi.org/10.5281/zenodo.20625923',
              'source_hashes': {v[0]: v[1] for v in SOURCES.values()},
              'scope': '15 index-one/two matrices and period inputs; no GW or deformation proof',
              'rows': rows}
    target = Path(__file__).with_suffix('.json')
    target.write_text(json.dumps(output, indent=2) + '\n')
    print('PASS: all 15 source matrices match after explicit normalization.')


if __name__ == '__main__':
    main()
