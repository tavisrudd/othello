from __future__ import annotations

import itertools
import json
from typing import Any

import sympy as sp


def quantum_checks() -> dict[str, Any]:
    a, b, q, T = sp.symbols('a b q T')
    U = sp.Matrix([
        [0, a*q, 0, a*a*q*q],
        [1, 0, b*q, 0],
        [0, 1, 0, a*q],
        [0, 0, 1, 0],
    ])
    D = sp.diag(sp.Rational(3, 2), sp.Rational(1, 2),
                -sp.Rational(1, 2), -sp.Rational(3, 2))
    C = sp.Matrix([
        [a*q, 0, 0, -(a+b)*q],
        [0, (a+b)*q, -a*q, 0],
        [1, 0, 0, 1],
        [0, 1, 1, 0],
    ])
    J = sp.simplify(C.inv()*U*C)
    B = sp.simplify(C.inv()*D*C)
    expected_J = sp.diag(sp.Matrix([[0, (2*a+b)*q], [1, 0]]),
                        sp.Matrix([[0, 1], [0, 0]]))
    if J != expected_J:
        raise ArithmeticError('Leading block decomposition failed')
    variables = sp.symbols('x0:4')
    X = sp.Matrix(2, 2, variables)
    equations = list(J[:2, :2]*X-X*J[2:, 2:]+B[:2, 2:])
    solutions = sp.solve(equations, variables, dict=True)
    if len(solutions) != 1:
        raise ArithmeticError('The Sylvester solution is not unique')
    X = sp.simplify(X.subs(solutions[0]))
    A0 = B[2:, 2:]
    A1 = sp.simplify(B[2:, :2]*X)
    R = sp.Matrix([[A0[0, 0], 1], [A1[1, 0], A0[1, 1]-1]])
    delta = sp.factor(sp.trace(R)**2-4*R.det())
    expected_delta = 4*(b-2*a)/(b+2*a)
    if sp.factor(delta-expected_delta) != 0:
        raise ArithmeticError('Discriminant formula failed')
    if sp.factor(U.charpoly(T).as_expr()-T*T*(T*T-(2*a+b)*q)) != 0:
        raise ArithmeticError('Characteristic polynomial failed')
    cases = {}
    for name, aa, bb, expected in (
        ('degree_one_del_Pezzo_threefold', 240, 1248, sp.Rational(16, 9)),
        ('quartic_double_solid', 48, 160, sp.Integer(1)),
        ('cubic_threefold', 24, 60, sp.Rational(4, 9)),
        ('two_quadrics_control', 16, 32, sp.Integer(0)),
    ):
        residue = sp.simplify(R.subs({a: aa, b: bb}))
        value = sp.simplify(delta.subs({a: aa, b: bb}))
        if value != expected:
            raise ArithmeticError(f'Unexpected discriminant for {name}')
        cases[name] = {
            'a': aa, 'b': bb,
            'residue': [[str(v) for v in row] for row in residue.tolist()],
            'indicial_polynomial': str(sp.factor(residue.charpoly(T).as_expr())),
            'discriminant': str(value),
        }
    return {
        'domain': 'q*(2*a+b) != 0',
        'det_C': str(sp.factor(C.det())),
        'sylvester_solution': [[str(v) for v in row] for row in X.tolist()],
        'residue': [[str(sp.factor(v)) for v in row] for row in R.tolist()],
        'discriminant': str(delta),
        'cases': cases,
    }


def torus_checks() -> dict[str, Any]:
    generators = (
        sp.Matrix([[-1, 0, 0, -1, -1], [1, 1, 1, 0, 2],
                   [0, 0, -1, -1, -1], [0, 0, 0, 0, 1], [0, 0, 0, 1, 0]]),
        sp.Matrix([[0, 1, 1, 1, 2], [-1, -1, 0, 0, -1],
                   [0, 0, 1, 0, 0], [0, 0, 0, 1, 0], [0, 0, -1, -1, -1]]),
    )
    N = sp.eye(5)[:, 2:5]
    weights = tuple(map(sp.Matrix, ((0, 1, 1), (1, 0, 1),
                                   (1, 1, 0), (1, 1, 1))))
    differences = sp.Matrix.hstack(*(w-weights[0] for w in weights[1:]))
    if abs(differences.det()) != 1:
        raise ArithmeticError('The selected simplex is not unimodular')
    permutations = []
    residual_actions = []
    for g in generators:
        cocharacters = g.inv().T
        restriction = N.T*cocharacters*N
        if cocharacters*N != N*restriction:
            raise ArithmeticError('Rank-three lattice is not stable')
        character_action = restriction.inv().T
        candidates = [p for p in itertools.permutations(range(4))
                      if all(character_action*(weights[j]-weights[0]) ==
                             weights[p[j]]-weights[p[0]] for j in range(4))]
        if len(candidates) != 1:
            raise ArithmeticError('The affine permutation is not unique')
        p = candidates[0]
        augmentation_action = sp.Matrix.hstack(*(
            (sp.eye(4)[:, p[j]]-sp.eye(4)[:, p[0]])[1:4, :]
            for j in range(1, 4)))
        if differences*augmentation_action != character_action*differences:
            raise ArithmeticError('Augmentation-lattice identification failed')
        permutations.append(list(p))
        residual_actions.append(g[:2, :2].tolist())
    k0, k1, k2, k3 = sp.symbols('k0 k1 k2 k3', nonzero=True)
    correction = (k3/k0, k3/k1, k3/k2)
    characters = (correction[0]/correction[1],
                  correction[0]/correction[2], correction[0])
    if any(sp.factor(x-y) != 0 for x, y in zip(characters, (k1/k0, k2/k0, k3/k0))):
        raise ArithmeticError('Cofactor correction failed')
    return {
        'difference_matrix': differences.tolist(),
        'determinant': int(differences.det()),
        'affine_weight_permutations': permutations,
        'residual_character_actions': residual_actions,
        'orbit_correction': [str(x) for x in correction],
    }


def main() -> None:
    result = {
        'scope': 'Exact finite algebra only; does not certify QDM comparisons or geometry.',
        'quantum': quantum_checks(),
        'torus': torus_checks(),
    }
    print(json.dumps(result, indent=2, default=str))


if __name__ == '__main__':
    main()
