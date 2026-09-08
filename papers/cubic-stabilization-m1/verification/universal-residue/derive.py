"""Exact universal residue and original-basis recurrence.
Checks finite algebra, not geometric comparisons. Uses SymPy 1.14.0.
Stdout is the canonical derive.json certificate.
"""
from __future__ import annotations

import json

import sympy as sp


def zero(value):
    entries = list(value) if isinstance(value, sp.MatrixBase) else [value]
    assert all(sp.cancel(entry) == 0 for entry in entries), value


def strings(matrix):
    return [[str(sp.factor(x)) for x in row] for row in matrix.tolist()]


def main():
    a, b, q, T, rho = sp.symbols("a b q T rho")
    s = 2*a+b
    U = sp.Matrix([[0,a*q,0,a*a*q*q], [1,0,b*q,0],
                   [0,1,0,a*q], [0,0,1,0]])
    D = sp.diag(3,1,-1,-3)/2
    C = sp.Matrix.hstack(U**2*sp.eye(4)[:,0], U**2*sp.eye(4)[:,1],
                        sp.Matrix([0,-a*q,0,1]),
                        sp.Matrix([-(a+b)*q,0,1,0]))
    J = sp.diag(sp.Matrix([[0,s*q],[1,0]]), sp.Matrix([[0,1],[0,0]]))
    zero(U*C-C*J)
    zero(C.det()+s*s*q*q)
    zero(U.charpoly(T).as_expr()-T*T*(T*T-s*q))
    B = sp.simplify(C.inv()*D*C)
    # Solve both off-diagonal first-jet equations, retaining zero diagonal gauge.
    X = sp.zeros(4)
    for i,j in ((0,2),(2,0)):
        variables = sp.symbols(f"x{i}{j}_0:4")
        unknown = sp.Matrix(2,2,variables)
        solutions = sp.solve(list(J[i:i+2,i:i+2]*unknown
                                 -unknown*J[j:j+2,j:j+2]+B[i:i+2,j:j+2]),
                             variables, dict=True)
        assert len(solutions) == 1
        X[i:i+2,j:j+2] = unknown.subs(solutions[0])
    B1 = sp.simplify(B+J*X-X*J)
    zero(B1[:2,2:]); zero(B1[2:,:2])
    # z^2 G' = (J+zB+z^2 F)G-G(J+zB1+z^2 B2).
    # The -X term below is the derivative contribution at order z^2.
    F = sp.Matrix(4,4,sp.symbols("f0:16"))
    second_without_commutator = F+B*X-X*B1-X
    for i in (0,2):
        j = 2-i
        zero(second_without_commutator[i:i+2,i:i+2]
             -F[i:i+2,i:i+2]-B[i:i+2,j:j+2]*X[j:j+2,i:i+2])
    A1 = sp.simplify((B*X-X*B1-X)[2:,2:])
    R = sp.Matrix([[B[2,2],1],[A1[1,0],B[3,3]-1]])
    expected = sp.Matrix([[-(2*a+3*b)/(2*s),1],
                          [-4*a*a/s**2,(b-2*a)/(2*s)]])
    zero(R-expected)
    polynomial = T*T+T+(10*a-3*b)/(4*s)
    zero(R.charpoly(T).as_expr()-polynomial)
    delta = sp.factor(sp.trace(R)**2-4*R.det())
    zero(delta-4*(b-2*a)/s)

    # Independent approach: direct Frobenius recurrence in the ORIGINAL basis.
    y0 = sp.Matrix([0,-a*q,0,1])
    y1 = sp.Matrix([-q*((a+b)*rho+(-a+3*b)/2),0,rho+sp.Rational(3,2),0])
    left = sp.Matrix([[1,0,-a*q,0]])
    zero(U*y0); zero(left*U)
    zero(U*y1-(rho*sp.eye(4)-D)*y0)
    compatibility = (left*((rho+1)*sp.eye(4)-D)*y1)[0]
    zero(compatibility+q*s*polynomial.subs(T,rho))

    # Match the current manuscript's H-basis, c1=2H convention exactly.
    U_cubic_H = 2*U.subs({a:6,b:15})
    S = sp.diag(1,2,4,8)
    zero(S.inv()*U_cubic_H*S-U.subs({a:24,b:60}))
    zero(S.inv()*D*S-D)
    cubic_rescaling = sp.diag(2,1)
    zero(cubic_rescaling*R.subs({a:24,b:60})*cubic_rescaling.inv()
         -sp.Matrix([[-sp.Rational(19,18),2],[-sp.Rational(8,81),sp.Rational(1,18)]]))

    cases = {}
    for name,aa,bb,eigenvalues in (
        ("degree_one_del_Pezzo_threefold",240,1248,[sp.Rational(1,6),-sp.Rational(7,6)]),
        ("quartic_double_solid",48,160,[sp.Integer(0),sp.Integer(-1)]),
        ("cubic_threefold",24,60,[-sp.Rational(1,6),-sp.Rational(5,6)]),
        ("two_quadrics_control",16,32,[-sp.Rational(1,2),-sp.Rational(1,2)]),
    ):
        p = sp.factor(polynomial.subs({a:aa,b:bb}))
        zero(p-sp.prod(T-e for e in eigenvalues))
        gap = abs(eigenvalues[0]-eigenvalues[1])
        cases[name] = {"a":aa,"b":bb,"residue":strings(R.subs({a:aa,b:bb})),
                       "polynomial_coefficients":[str(x) for x in sp.Poly(p,T).all_coeffs()],
                       "eigenvalues":[str(x) for x in eigenvalues],
                       "discriminant":str(gap**2),"I_exp":int(not gap.is_integer),
                       "I_lat":int(gap != 0)}

    result = {"status":"pass","sympy_version":sp.__version__,
              "scope":"Finite algebra; geometric transport and source theorems require prose audit.",
              "domain":"q*(2*a+b) != 0; a,b,q constant under z differentiation",
              "det_C":str(sp.factor(C.det())),"first_gauge":strings(X),
              "residue":strings(R),"indicial_polynomial":str(sp.factor(polynomial)),
              "discriminant":str(delta),
              "checks":["rational primary splitting","both Sylvester equations",
                        "general F correction and derivative term","direct Frobenius recurrence",
                        "cubic anticanonical basis and residue bridges"],
              "cases":cases}
    print(json.dumps(result,indent=2))


if __name__ == "__main__":
    main()
