"""Independent rational-arithmetic replay of the Fano indicial polynomials.

Uses Gaussian elimination and three exact polynomial evaluations, no SymPy,
no basis change, and no Sylvester/residue computation from the main generator.
"""
import json
from fractions import Fraction as F
from pathlib import Path


def solve(rows, rhs):
    matrix = [[F(x) for x in row]+[F(y)] for row,y in zip(rows,rhs)]
    n = len(rows[0])
    pivot = 0
    for column in range(n):
        k = next(k for k in range(pivot,len(matrix)) if matrix[k][column])
        matrix[pivot],matrix[k] = matrix[k],matrix[pivot]
        divisor = matrix[pivot][column]
        matrix[pivot] = [x/divisor for x in matrix[pivot]]
        for k in range(len(matrix)):
            if k != pivot:
                multiplier = matrix[k][column]
                matrix[k] = [x-multiplier*y for x,y in zip(matrix[k],matrix[pivot])]
        pivot += 1
    assert all(not any(row) for row in matrix[n:])
    return [matrix[k][-1] for k in range(n)]


def dot(xs,ys):
    return sum(x*y for x,y in zip(xs,ys))


def main():
    certificate = json.loads(Path(__file__).with_name("derive.json").read_text())
    results = {}
    q_values = [F(1),F(2),F(3,7),F(-5,2)]
    for name,case in certificate["cases"].items():
        a,b = F(case["a"]),F(case["b"])
        polynomials = []
        for q in q_values:
            U = [[0,a*q,0,a*a*q*q],[1,0,b*q,0],[0,1,0,a*q],[0,0,1,0]]
            D = [F(3,2),F(1,2),F(-1,2),F(-3,2)]
            y0 = [0,-a*q,0,1]
            assert all(dot(row,y0)==0 for row in U)
            left = solve(list(map(list,zip(*U)))+[[1,0,0,0]],[0,0,0,0,1])
            values = []
            for rho in range(3):
                y1 = solve(U+[[0,0,0,1]],[(rho-d)*x for d,x in zip(D,y0)]+[0])
                obstruction = dot(left,[(rho+1-d)*x for d,x in zip(D,y1)])
                values.append(-obstruction/(q*(2*a+b)))
            constant = values[0]
            quadratic = (values[2]-2*values[1]+values[0])/2
            linear = values[1]-constant-quadratic
            coeffs = [quadratic,linear,constant]
            assert coeffs == list(map(F,case["polynomial_coefficients"]))
            assert linear*linear-4*quadratic*constant == F(case["discriminant"])
            for root in map(F,case["eigenvalues"]):
                assert (quadratic*root+linear)*root+constant == 0
            polynomials.append([str(x) for x in coeffs])
        assert all(p == polynomials[0] for p in polynomials)
        results[name] = polynomials[0]
    print(json.dumps({"status":"pass","engine":"stdlib fractions.Fraction",
                      "method":"original-basis Gaussian elimination and exact quadratic interpolation",
                      "scope":"four parameter pairs at four nonzero q values; not a universal symbolic proof",
                      "q_values":[str(x) for x in q_values],
                      "polynomial_coefficients":results},indent=2))


if __name__ == "__main__":
    main()
