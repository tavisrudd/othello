"""Exact F1 specialization check, reconstructed from the quantum relations.

Replay: uv run --with sympy==1.14.0 python verification/framed_specialization.py --check
This checks finite algebra, not Hypotheses R/T or formal classification.
"""
import argparse
import hashlib
import json
from pathlib import Path

import sympy as s


def calculate():
    F, S, u, w, x, t, a, b = s.symbols('F S u w x t a b')
    gb = s.groebner([S*S+S*F-u, F*F-w*S], F, S, domain=s.QQ.frac_field(u,w))
    basis = [s.Integer(1), F, S, S*F+w*S]
    normal = [gb.reduce(v)[1] for v in basis]
    def coefficients(v):
        p = s.Poly(v, F, S)
        return s.Matrix([p.coeff_monomial(S**j) for j in range(4)])
    conversion = s.Matrix.hstack(*(coefficients(v) for v in normal))
    def multiplication(v):
        return s.simplify(conversion.inv()*s.Matrix.hstack(*(
            coefficients(gb.reduce(s.expand(v*q))[1]) for q in basis)))
    U = multiplication(3*F+2*S)
    D = s.diag(1,0,0,-1)
    eta = s.Matrix([[0,0,0,1],[0,0,1,0],[0,1,-1,0],[1,0,0,0]])
    assert U.T*eta == eta*U
    assert D.T*eta == -eta*D
    assert all(s.expand(s.trace(U**j*D)) == 0 for j in range(4))
    moving = [s.Integer(1), F, S, S*F]
    P = s.simplify(conversion.inv()*s.Matrix.hstack(*(
        coefficients(gb.reduce(v)[1]) for v in moving)))
    expected_P = s.eye(4); expected_P[2,3] = -w
    assert P == expected_P
    assert (P.inv()*D*P)[2,3] == -w
    f = U.charpoly(x).as_expr()
    disc = s.factor(s.discriminant(f,x))
    assert disc == -u**2*w**2*(256*u+27*w*w)**3
    U0 = U.subs({u:-27,w:16})
    assert s.factor(U0.charpoly(x).as_expr()) == (x+18)**2*(x*x-20*x+612)
    # Polynomial spectral projector: independent of the supplied block basis.
    E = (U0**2-20*U0+612*s.eye(4))/1296
    assert E**2 == E and E.rank() == 2
    assert (U0+18*s.eye(4))*E == s.zeros(4)
    B = s.Matrix([[3,72],[-s.Rational(1,2),-9],[1,0],[0,1]])
    assert E*B == B
    R = (E*D*B)[2:4,:]
    assert B*R == E*D*B
    assert R == s.Matrix([[-s.Rational(1,18),s.Rational(4,3)],
                          [s.Rational(1,54),s.Rational(1,18)]])
    assert s.trace(E*D) == 0 and s.trace(E*D*E*D) == s.Rational(1,18)
    assert R**2 == s.eye(2)/36
    scaling = s.diag(1,1/t,1/t,1/t**2)
    assert U.subs({u:-27*t*t,w:16*t}) == t*scaling*U0*scaling.inv()
    assert scaling*D*scaling.inv() == D
    wall = s.expand((256*u+27*w*w).subs({u:-27*t*t*a,w:16*t*b}))
    assert s.expand(wall - 6912*t*t*(b*b-a)) == 0
    encode = lambda M: [[str(v) for v in row] for row in M.tolist()]
    return {
        'sympy_version': s.__version__,
        'basis': ['1','F','S','p = S*F + w*S'],
        'U': encode(U), 'D': encode(D), 'moving_basis_change': encode(P),
        'moving_grading': encode(P.inv()*D*P),
        'characteristic_polynomial': str(f), 'discriminant': str(disc),
        'scalar_cluster_projector_at_t1': encode(E),
        'residue': encode(R), 'residue_polynomial': str(s.factor(R.charpoly(x).as_expr())),
        'tagged_collision_factor': str(wall),
        'scope': 'Exact rational algebra from the printed F1 quantum relations; formal monodromy and admissibility are proved in the companion.'
    }


if __name__ == '__main__':
    parser = argparse.ArgumentParser(); parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    path = Path(__file__).resolve()
    output = path.with_suffix('.json')
    value = json.dumps(calculate(), indent=2, sort_keys=True)+'\n'
    if args.check:
        assert output.read_text() == value, 'stale certificate'
    else:
        output.write_text(value)
    root = path.parent.parent
    files = [path, output]
    digest = ''.join(f'{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.relative_to(root)}\n' for p in files)
    manifest = path.with_suffix('.sha256')
    if args.check:
        assert manifest.read_text() == digest, 'stale checksums'
    else:
        manifest.write_text(digest)
    print('PASS: fixed-basis reconstruction, grading, spectral projector, residue and tagged collision factor')
