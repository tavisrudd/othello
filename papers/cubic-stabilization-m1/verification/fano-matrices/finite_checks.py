from __future__ import annotations

import json
import sys
from pathlib import Path

import sympy as sp

def matrix_polynomial(poly: sp.Poly, matrix: sp.Matrix) -> sp.Matrix:
    result = sp.zeros(matrix.rows)
    for coefficient in poly.all_coeffs():
        result = result * matrix + coefficient * sp.eye(matrix.rows)
    return result.applyfunc(sp.cancel)

def rank_two_discriminant(
    leading: sp.Matrix,
    regular: sp.Matrix,
    eigenvalue: sp.Expr,
    next_coefficient: sp.Matrix | None = None,
) -> dict:
    n = leading.rows
    if leading.cols != n or regular.shape != (n, n):
        raise ValueError("The connection coefficients must be square of equal size.")
    correction = sp.zeros(n) if next_coefficient is None else next_coefficient
    t = sp.Symbol("t")
    centered = leading - eigenvalue * sp.eye(n)
    characteristic = sp.Poly(centered.charpoly(t).as_expr(), t)
    quotient, remainder = sp.div(characteristic, sp.Poly(t**2, t))
    if not remainder.is_zero or quotient.eval(0) == 0:
        raise ValueError("The chosen eigenvalue must have algebraic multiplicity exactly two.")
    inverse = sp.invert(quotient, sp.Poly(t**2, t))
    projector = matrix_polynomial(quotient * inverse, centered)
    complement = sp.eye(n) - projector
    nilpotent = (centered * projector).applyfunc(sp.cancel)
    assert projector**2 == projector
    assert projector.rank() == 2
    assert nilpotent.rank() == 1 and nilpotent**2 == sp.zeros(n)
    reduced_inverse = ((centered + projector).inv() * complement).applyfunc(sp.cancel)
    assert (centered * reduced_inverse - complement).applyfunc(sp.cancel) == sp.zeros(n)
    assert (reduced_inverse * projector).applyfunc(sp.cancel) == sp.zeros(n)
    block_regular = projector * regular * projector
    commutator = block_regular * nilpotent - nilpotent * block_regular
    i, j = next((i, j) for i in range(n) for j in range(n) if nilpotent[i, j] != 0)
    kappa = sp.cancel(commutator[i, j] / nilpotent[i, j])
    assert (commutator - kappa * nilpotent).applyfunc(sp.cancel) == sp.zeros(n)
    off_diagonal_trace = sp.cancel(sp.trace(nilpotent * regular * reduced_inverse * regular))
    correction_trace = sp.cancel(sp.trace(nilpotent * correction))
    delta = sp.factor((kappa + 1)**2 + 4 * correction_trace - 4 * off_diagonal_trace)
    return {
        "characteristic": sp.factor(leading.charpoly(t).as_expr()),
        "kappa": kappa,
        "off_diagonal_trace": off_diagonal_trace,
        "correction_trace": correction_trace,
        "delta": delta,
    }

DATA = {
    'g2': (120, 744, 137520, 650016, 119681280, 21690374400),
    'g3': (24, 104, 3888, 13600, 504576, 18323712),
    'g4': (12, 42, 792, 2340, 43632, 793152),
    'g5': (8, 24, 304, 800, 9984, 121088),
    'g6': (6, 16, 156, 380, 3600, 33120),
    'g7': (5, 12, 96, 216, 1692, 12816),
    'g8': (4, 9, 64, 140, 924, 5936),
    'g9': (4, 8, 48, 96, 576, 3328),
    'g10': (3, 6, 36, 72, 378, 1944),
    'g12': (sp.Rational(12, 5), sp.Rational(22, 5), 24, 44, 198, 880),
    'd1': (0, 0, 240, 1248, 0, 57600),
    'd2': (0, 0, 48, 160, 0, 2304),
    'd3': (0, 0, 24, 60, 0, 576),
    'd4': (0, 0, 16, 32, 0, 256),
    'd5': (0, 0, 12, 20, 0, 160),
    'quadric': (0, 0, 0, 0, 54, 0),
    'projective_space': (0, 0, 0, 0, 0, 256),
}
H21 = {'g2': 52, 'g3': 30, 'g4': 20, 'g5': 14, 'g6': 10,
       'g7': 7, 'g8': 5, 'g9': 3, 'g10': 2, 'g12': 0,
       'd1': 21, 'd2': 10, 'd3': 5, 'd4': 2, 'd5': 0,
       'quadric': 0, 'projective_space': 0}
EXPECTED_DELTA = {'g6': 1, 'g7': 0, 'g8': sp.Rational(4, 9),
                  'g9': 0, 'g10': 0, 'd1': sp.Rational(16, 9),
                  'd2': 1, 'd3': sp.Rational(4, 9), 'd4': 0}


def quantum_matrix(values: tuple) -> sp.Matrix:
    a, b, c, d, e, f = values
    return sp.Matrix([[a, c, e, f], [1, b, d, e],
                      [0, 1, b, c], [0, 0, 1, a]])


def cross_gauge(leading: sp.Matrix, source: sp.Matrix, split: int) -> sp.Matrix:
    locations = [(i, j) for i in range(leading.rows) for j in range(leading.cols)
                 if (i < split) != (j < split)]
    unknowns = sp.symbols(f'x:{len(locations)}')
    gauge = sp.zeros(leading.rows)
    for location, unknown in zip(locations, unknowns):
        gauge[location] = unknown
    equation = leading * gauge - gauge * leading + source
    solutions = sp.solve([equation[location] for location in locations], unknowns, dict=True)
    assert len(solutions) == 1
    return gauge.subs(solutions[0])


def rank_three_jets(leading: sp.Matrix, regular: sp.Matrix) -> list[sp.Matrix]:
    kernel = (leading**3).nullspace()
    vector = next(v for v in kernel if leading**2 * v != sp.zeros(4, 1))
    change = sp.Matrix.hstack(leading**2 * vector, leading * vector, vector,
                             *(leading**3).columnspace())
    u, d = change.inv() * leading * change, change.inv() * regular * change
    assert u[:3, :3] == sp.Matrix([[0, 1, 0], [0, 0, 1], [0, 0, 0]])
    b0 = sp.diag(d[:3, :3], d[3:, 3:])
    g1 = cross_gauge(u, d, 3)
    assert u * g1 - g1 * u + d == b0
    w1 = d * g1 - g1 * b0 - g1
    g2 = cross_gauge(u, w1, 3)
    b1 = u * g2 - g2 * u + w1
    assert b1[:3, 3:] == sp.zeros(3, 1) and b1[3:, :3] == sp.zeros(1, 3)
    b2 = d * g2 - 2 * g2 - g2 * b0 - g1 * b1
    return [u[:3, :3], b0[:3, :3], b1[:3, :3], b2[:3, :3]]


def corrected_rank_three_residue(jets: list[sp.Matrix]) -> tuple[sp.Expr, sp.Matrix]:
    n, a0, a1, a2 = jets
    assert n == sp.Matrix([[0, 1, 0], [0, 0, 1], [0, 0, 0]])
    assert sp.trace(n * a0) == 0 and sp.trace(n**2 * a0) == 0
    h = sp.zeros(3)
    h[2, 0] = -a0[1, 0]
    assert h**2 == sp.zeros(3) and h * n * h == sp.zeros(3)
    a0p = a0 + n * h - h * n
    a1p = a1 + a0 * h - h * a0 - h
    a2p = a2 + a1 * h - h * a1 - h * a0 * h
    assert all(a0p[i, j] == 0 for i in range(3) for j in range(i))
    residue = sp.Matrix([[a0p[0, 0], 1, 0],
                         [a1p[1, 0], a0p[1, 1] - 1, 1],
                         [a2p[2, 0], a1p[2, 1], a0p[2, 2] - 2]])
    return sp.factor(a1p[2, 0]), residue.applyfunc(sp.cancel)


def gauge_jets(jets: list[sp.Matrix], gauge: list[sp.Matrix]) -> list[sp.Matrix]:
    degree, n = len(jets) - 1, jets[0].rows
    inverse = [gauge[0].inv()]
    for k in range(1, degree + 1):
        inverse.append(-inverse[0] * sum((gauge[j] * inverse[k-j]
                                         for j in range(1, k+1)), sp.zeros(n)))
    result = []
    for k in range(degree + 1):
        coefficient = sum((inverse[i] * jets[j] * gauge[k-i-j]
                           for i in range(k+1) for j in range(k-i+1)), sp.zeros(n))
        coefficient -= sum((inverse[i] * (k-1-i) * gauge[k-1-i]
                            for i in range(max(0, k-1))), sp.zeros(n))
        result.append(coefficient.applyfunc(sp.cancel))
    return result


def check_rank_three_flatness() -> dict:
    a, b, c, d, e, f, pole = sp.symbols('a b c d e f pole')
    r = sp.Matrix([[a, 1, 0], [b, c, 1], [d, e, f]])
    bmat = sp.Matrix(3, 3, sp.symbols('b0:9'))
    e31 = sp.zeros(3)
    e31[2, 0] = 1
    k21 = pole * bmat[0, 2]
    k32 = k21
    k31 = pole * ((a-c-1) * bmat[0, 2] + bmat[1, 2])
    k = sp.Matrix([[0, 0, 0], [k21, 0, 0], [k31, k32, 0]])
    equation = -k + k * r - r * k + pole * (bmat * e31 - e31 * bmat)
    assert all(sp.expand(equation[i, i]) == 0 for i in range(3))
    assert sp.expand(equation[1, 0]) == 0
    multiplier = ((a-f-1) * ((a-c-1)*bmat[0, 2] + bmat[1, 2])
                  + (b-e)*bmat[0, 2] + bmat[2, 2] - bmat[0, 0])
    assert sp.expand(equation[2, 0] - pole * multiplier) == 0
    assert k.subs(pole, 0) == sp.zeros(3)
    n = sp.Matrix([[0, 1, 0], [0, 0, 1], [0, 0, 0]])
    g = sp.Matrix(3, 3, sp.symbols('g0:9'))
    commutator = n * g - g * n
    assert commutator[1, 0] == g[2, 0]
    assert commutator[2, 1] == -g[2, 0]
    return {'pole_evolution_multiplier': multiplier,
            'normalized_gauge_constraint': 'G1[3,1] = 0',
            'base_pole_vanishes_when_connection_pole_vanishes': True}


def run() -> dict:
    t = sp.Symbol('t')
    grading = sp.diag(sp.Rational(3, 2), sp.Rational(1, 2),
                      sp.Rational(-1, 2), sp.Rational(-3, 2))
    table = {}
    detected = []
    rank_three = {}
    centered_parameter = {'g2': sp.Rational(1, 9), 'g3': sp.Rational(1, 16),
                          'g4': sp.Rational(1, 36), 'g5': 0}
    for name, values in DATA.items():
        u = quantum_matrix(values)
        unit = sp.eye(4)[:, 0]
        cyclic = sp.Matrix.hstack(unit, u*unit, u**2*unit, u**3*unit)
        assert cyclic.det() == 1
        characteristic = sp.factor(u.charpoly(t).as_expr())
        factors = sp.factor_list(characteristic, t)[1]
        dimensions = sorted((multiplicity for factor, multiplicity in factors
                             for _ in range(sp.degree(factor, t))), reverse=True)
        row = {'shifted_counting_matrix': u, 'characteristic': characteristic,
               'primary_even_dimensions': dimensions, 'h21': H21[name]}
        rank_two = []
        for factor, multiplicity in factors:
            if multiplicity == 2:
                for root in sp.solve(factor, t):
                    certificate = rank_two_discriminant(u, grading, root)
                    assert certificate['delta'] == EXPECTED_DELTA[name]
                    rank_two.append(certificate)
        row['rank_two_certificates'] = rank_two
        row['lattice_count'] = sum(int(certificate['delta'] != 0) for certificate in rank_two)
        row['O3'] = H21[name] if dimensions == [3, 1] else 0
        row['detected_after_one_stabilization'] = bool(row['lattice_count'] or row['O3'])
        if row['detected_after_one_stabilization']:
            detected.append(name)
        if dimensions == [3, 1]:
            jets = rank_three_jets(u, grading)
            obstruction, residue = corrected_rank_three_residue(jets)
            assert obstruction == 0 and sp.trace(residue) == -3
            centered = sp.factor((residue + sp.eye(3)).charpoly(t).as_expr())
            assert sp.expand(centered - t*(t**2-centered_parameter[name])) == 0
            n = jets[0]
            gauge = [sp.eye(3)+2*n+3*n**2,
                     sp.Matrix([[1, 2, -1], [3, -2, 4], [2, 1, 3]]),
                     sp.Matrix([[0, 1, 2], [-2, 3, 1], [1, -1, 0]]),
                     sp.Matrix([[1, 0, 3], [2, 1, -1], [-1, 2, 0]])]
            changed_obstruction, changed_residue = corrected_rank_three_residue(gauge_jets(jets, gauge))
            assert changed_obstruction == 0
            assert sp.expand(changed_residue.charpoly(t).as_expr()-residue.charpoly(t).as_expr()) == 0
            rank_three[name] = {'separated_jets': jets, 'pole_obstruction': obstruction,
                                'residue': residue, 'centered_characteristic': centered,
                                'eigenvalues': list(residue.eigenvals()),
                                'nonconstant_gauge_test': True}
        table[name] = row
    assert set(detected) == {'g2', 'g3', 'g4', 'g5', 'g6', 'g8', 'd1', 'd2', 'd3'}
    rational = sorted(set(DATA)-set(detected))
    assert rational == sorted(['g7', 'g9', 'g10', 'g12', 'd4', 'd5', 'quadric', 'projective_space'])
    return {'status': 'all assertions passed',
            'scope': 'Exact finite algebra only; geometric comparison, surface vanishing, and deformation arguments are written proofs.',
            'families': table, 'rank_three': rank_three,
            'rank_three_formal_flatness': check_rank_three_flatness(),
            'nine_detected_families': detected, 'eight_rational_families': rational}


def serializable(value):
    if isinstance(value, sp.MatrixBase):
        return [[str(value[i, j]) for j in range(value.cols)] for i in range(value.rows)]
    if isinstance(value, sp.Basic):
        return str(value)
    if isinstance(value, dict):
        return {str(k): serializable(v) for k, v in value.items()}
    if isinstance(value, (list, tuple)):
        return [serializable(v) for v in value]
    return value


if __name__ == '__main__':
    results = run()
    destination = Path(__file__).with_suffix('.json')
    rendered = json.dumps(serializable(results), indent=2) + '\n'
    if '--check' in sys.argv:
        assert destination.read_text() == rendered, 'finite certificate is stale'
    else:
        destination.write_text(rendered)
    print(f"{results['status']}; checked {destination.name}")
