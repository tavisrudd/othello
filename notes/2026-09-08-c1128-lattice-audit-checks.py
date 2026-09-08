#!/usr/bin/env python3
"""Exact local identities for C1128; not a verification of geometric inputs."""
import argparse
import hashlib
import json
from fractions import Fraction
from pathlib import Path

import sympy as s


def comm(a, b):
    return a * b - b * a


def clean(a):
    return a.applyfunc(s.cancel) if isinstance(a, s.MatrixBase) else s.cancel(a)


def zero(a):
    a = clean(a)
    assert a == (s.zeros(*a.shape) if isinstance(a, s.MatrixBase) else 0), a


def delta(a):
    return s.expand(s.trace(a) ** 2 - 4 * a.det())


def residue(a, z):
    return clean(a).applyfunc(lambda x: s.limit(x, z, 0))


def independent_det(rows):
    """Fraction Gaussian elimination, independent of SymPy determinant code."""
    a = [[Fraction(x) for x in row] for row in rows]
    out = Fraction(1)
    for j in range(len(a)):
        pivot = next(i for i in range(j, len(a)) if a[i][j])
        if pivot != j:
            a[j], a[pivot] = a[pivot], a[j]
            out = -out
        p = a[j][j]
        out *= p
        for i in range(j + 1, len(a)):
            c = a[i][j] / p
            a[i] = [x - c * y for x, y in zip(a[i], a[j])]
    return out


def calculate():
    z = s.symbols('z', nonzero=True)
    nu, p, alpha, epsilon = s.symbols('nu p alpha epsilon', nonzero=True)
    a, b, c, d, f, g, h, w, c0 = s.symbols('a b c d f g h w c0')
    n = s.Matrix([[0, nu], [0, 0]])
    a0 = s.Matrix([[a, b], [0, d]])
    a1 = s.Matrix([[f, g], [c, h]])
    az = n / z + a0 + z * a1
    modification = s.diag(1, z)
    sharp = modification.inv() * az * modification - s.diag(0, 1)
    r = residue(sharp, z)
    zero(r - s.Matrix([[a, nu], [c, d - 1]]))

    p0 = s.Matrix([[0, p], [p, h]])
    p1 = s.Matrix([[0, w], [-w, 0]])
    zero(n.T * p0 - p0 * n)
    raw_a0 = s.Matrix([[a, b], [c0, d]])
    pair0 = raw_a0.T * p0 + p0 * raw_a0 + n.T * p1 - p1 * n
    zero(pair0[0, 0] - 2 * p * c0)
    zero(pair0[0, 1].subs(c0, 0) - p * (a + d))

    beta, a11, a12, a21, a22 = s.symbols('beta a11 a12 a21 a22')
    gauge = s.Matrix([[alpha, beta], [0, epsilon]]) + z * s.Matrix(
        [[a11, a12], [a21, a22]])
    modified_gauge = clean(modification.inv() * gauge * modification)
    h0 = residue(modified_gauge, z)
    zero(h0 - s.Matrix([[alpha, 0], [a21, epsilon]]))
    transported = clean(gauge.inv() * az * gauge - gauge.inv() * z * gauge.diff(z))
    transported_sharp = clean(modification.inv() * transported * modification - s.diag(0, 1))
    transported_r = residue(transported_sharp, z)
    zero(transported_r - h0.inv() * r * h0)
    zero(delta(transported_r) - delta(r))

    x, y, v, q = s.symbols('x y v q')
    b00, b01, b10, b11 = s.symbols('b00 b01 b10 b11')
    general_n = s.Matrix([[x, y], [v, -x]])
    base = s.Matrix([[b00, b01], [b10, b11]])
    dn = -q * general_n + comm(general_n, base)
    zero(dn * general_n + general_n * dn + 2 * q * general_n**2 - comm(general_n**2, base))
    c11, c12, c21, u = s.symbols('c11 c12 c21 u')
    cyclic = s.Matrix([[0, u], [1, 0]])
    centralizer = s.Matrix([[c11, c12], [c21, -c11]])
    solutions = s.solve(list(comm(cyclic, centralizer)), [c11, c12], dict=True)
    assert solutions == [{c11: 0, c12: c21 * u}], solutions

    k = s.symbols('k')
    e21 = s.Matrix([[0, 0], [1, 0]])
    pole = k * e21 + comm(r, k * e21)
    zero(pole[0, 0] - nu * k)
    zero(pole[1, 1] + nu * k)
    dr = comm(base, r)
    zero(s.trace(dr))
    zero(2 * (r[0, 0] - r[1, 1]) * (dr[0, 0] - dr[1, 1])
         + 4 * (dr[0, 1] * r[1, 0] + r[0, 1] * dr[1, 0]))

    curve_a = s.symbols('curve_a', nonzero=True)
    curve = curve_a * e21 / z + s.diag(s.Rational(1, 2), -s.Rational(1, 2))
    curve_s = s.diag(z, 1)
    curve_r = residue(curve_s.inv() * curve * curve_s - s.diag(1, 0), z)
    zero(curve_r - (curve_a * e21 - s.eye(2) / 2))
    assert delta(curve_r) == 0
    wrong_sign = curve_a * e21 / z - s.diag(s.Rational(1, 2), -s.Rational(1, 2))
    wrong_r = residue(curve_s.inv() * wrong_sign * curve_s - s.diag(1, 0), z)
    assert delta(wrong_r) == 4

    def fundamental(exponent):
        return s.Matrix([[z**exponent, -z**(-exponent - 1) / s.Integer(2 * exponent + 1)],
                         [0, z**(-exponent)]])

    def system(exponent):
        return s.Matrix([[exponent, 1 / z], [0, -exponent]])

    hyperbolic_pairing = s.Matrix([[0, 1], [1, 0]])
    for exponent in (0, 2):
        ff = fundamental(exponent)
        zero(z * ff.diff(z) - system(exponent) * ff)
        zero(ff.subs(z, -z).T * hyperbolic_pairing * ff - hyperbolic_pairing)
    meromorphic = clean(fundamental(0) * fundamental(2).inv())
    zero(meromorphic.inv() * system(0) * meromorphic
         - meromorphic.inv() * z * meromorphic.diff(z) - system(2))
    residues = [residue(modification.inv() * system(e) * modification - s.diag(0, 1), z)
                for e in (0, 2)]
    assert [delta(rr) for rr in residues] == [1, 25]
    # A regular matrix without regular inverse is not a lattice isomorphism.
    assert modification.inv()[1, 1] == 1 / z

    chars = [0, 1, 3, 7]
    vandermonde = [[x**i for x in chars] for i in range(4)]
    determinant = int(s.Matrix(vandermonde).det())
    assert determinant == independent_det(vandermonde) == 1008
    return {
        'schema': 'c1128-local-lattice-audit-v1',
        'sympy_version': s.__version__,
        'status': 'pass',
        'canonical_residue': [[str(x) for x in row] for row in r.tolist()],
        'modified_gauge_at_zero': [[str(x) for x in row] for row in h0.tolist()],
        'regular_gauge_naturality': 'symbolic residue conjugacy and discriminant equality',
        'cyclic_centralizer': {'c11': '0', 'c12': 'c21*u'},
        'nilpotence_transport_identity': 'pass for a general trace-zero 2x2 matrix',
        'base_pole_diagonal': [str(pole[0, 0]), str(pole[1, 1])],
        'lax_trace_and_discriminant': 'pass',
        'pairing': {'line_preservation_coefficient': '2*c0*p',
                    'trace_coefficient_after_line_preservation': 'p*(a+d)'},
        'curve_discriminant': 0,
        'wrong_grading_sign_discriminant': 4,
        'paired_meromorphic_negative_control': {
            'gauge': [[str(x) for x in row] for row in meromorphic.tolist()],
            'discriminants': [1, 25],
            'exponent_classes': 'both pairs are [0],[0] modulo Z',
            'same_leading_nilpotent': True},
        'vandermonde': {'characters': chars, 'determinant': determinant,
                        'independent_fraction_elimination': 'pass'},
        'boundary': 'Local algebra only; no geometric comparison, completion, formal recursion existence, GW input, surface classification, or Lean verification.'
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--write', action='store_true')
    args = parser.parse_args()
    path = Path(__file__).with_suffix('.json')
    payload = (json.dumps(calculate(), indent=2, sort_keys=True) + '\n').encode()
    if args.write:
        path.write_bytes(payload)
    else:
        assert path.read_bytes() == payload, 'certificate drift'
    print('PASS local lattice identities; certificate SHA-256 ' + hashlib.sha256(payload).hexdigest())


if __name__ == '__main__':
    main()
