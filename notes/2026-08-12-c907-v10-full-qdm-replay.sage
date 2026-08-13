#!/usr/bin/env sage
"""Exact V_10 ordinary small-even QDM / formal-support replay.

Inputs are Przyjalkowski arXiv:math/0410327, Theorem 6.1.1, and Golyshev
arXiv:math/0510287, §§2.4--2.6.  Normal form is t^a*p(D), D=t*d/dt.
"""

import hashlib
import json
import sys

R.<D> = PolynomialRing(QQ)

def add(left, right):
    answer = dict(left)
    for power, coefficient in right.items():
        answer[power] = answer.get(power, R(0)) + coefficient
    return {power: coefficient for power, coefficient in answer.items() if coefficient}

def negate(operator):
    return {power: -coefficient for power, coefficient in operator.items()}

def scale(operator, scalar):
    return {power: scalar * coefficient for power, coefficient in operator.items() if coefficient}

def multiply(left, right):
    answer = {}
    for left_power, left_polynomial in left.items():
        for right_power, right_polynomial in right.items():
            power = left_power + right_power
            term = left_polynomial(D=D + right_power) * right_polynomial
            answer[power] = answer.get(power, R(0)) + term
    return {power: coefficient for power, coefficient in answer.items() if coefficient}

def right_determinant(matrix):
    size = len(matrix)
    if size == 1:
        return matrix[0][0]
    answer = {}
    for row in range(size):
        minor = [[matrix[i][j] for j in range(size - 1)]
                 for i in range(size) if i != row]
        answer = add(answer, scale(
            multiply(right_determinant(minor), matrix[row][size - 1]),
            (-1) ** (row + size - 1)))
    return answer

def monomial(power, coefficient):
    return {power: R(coefficient)}

zero = {}
one = monomial(0, 1)
differentiation = monomial(0, D)

# Theorem 6.1.1 of arXiv:math/0410327.
counting_matrix = [
    [monomial(1, 0), monomial(2, 156), monomial(3, 3600), monomial(4, 33120)],
    [one, monomial(1, 10), monomial(2, 380), monomial(3, 3600)],
    [zero, one, monomial(1, 10), monomial(2, 156)],
    [zero, zero, one, monomial(1, 0)],
]
system = [[add(differentiation, negate(counting_matrix[i][j])) if i == j
           else negate(counting_matrix[i][j]) for j in range(4)]
          for i in range(4)]
operator = right_determinant(system)
expected = {
    0: D ** 4,
    1: -10 * D * (D + 1) * (2 * D + 1),
    2: -16 * (37 * D ** 2 + 74 * D + 39),
    3: -2040 * (2 * D + 3),
    4: -8784,
}
assert operator == expected

S.<lam, alpha, t> = PolynomialRing(QQ)
theta_on = [S(1)]
for unused in range(4):
    theta_on.append(t * theta_on[-1].derivative(t) + (lam * t + alpha) * theta_on[-1])
formal_expression = (theta_on[4]
    - 10 * t * (2 * theta_on[3] + 3 * theta_on[2] + theta_on[1])
    - 16 * t ** 2 * (37 * theta_on[2] + 74 * theta_on[1] + 39 * theta_on[0])
    - 2040 * t ** 3 * (2 * theta_on[1] + 3 * theta_on[0]) - 8784 * t ** 4)
leading = formal_expression.coefficient({t: 4})
assert leading == (lam + 6) ** 2 * (lam ** 2 - 32 * lam - 244)
coefficient_t3 = formal_expression.coefficient({t: 3})
K.<sqrt5> = QuadraticField(5)
for root in (16 + 10 * sqrt5, 16 - 10 * sqrt5):
    exponent = -coefficient_t3.subs({lam: root, alpha: 0}) / leading.derivative(lam).subs({lam: root})
    assert exponent == -QQ(3) / 2
assert coefficient_t3.subs({lam: -6}) == 0
assert formal_expression.coefficient({t: 2}).subs({lam: -6}) == -4 * (2 * alpha + 1) * (2 * alpha + 3)

payload = {
    "schema": "c907-v10-full-small-even-qdm-v1",
    "counting_matrix": [["0", "156", "3600", "33120"], ["1", "10", "380", "3600"], ["0", "1", "10", "156"], ["0", "0", "1", "0"]],
    "unregularized_scalar_operator": {str(power): str(operator[power]) for power in sorted(operator)},
    "formal_exponential_polynomial": str(leading),
    "formal_data": {"simple_exponentials": ["16+10*sqrt(5)", "16-10*sqrt(5)"], "simple_power_exponents": ["-3/2", "-3/2"], "double_exponential": "-6", "double_indicial_polynomial": "-4*(2*alpha+1)*(2*alpha+3)", "double_power_exponents": ["-1/2", "-3/2"], "resonance_warning": "difference one; logarithms are not excluded"},
    "scope": "ordinary small-even QDM only; no big or odd-QDM claim",
}
rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
payload["sha256_without_self_hash"] = hashlib.sha256(rendered.encode()).hexdigest()
if len(sys.argv) != 2:
    raise SystemExit("usage: sage v10-full-qdm-replay.sage OUTPUT.json")
with open(sys.argv[1], "w") as output:
    json.dump(payload, output, indent=2, sort_keys=True)
    output.write("\n")
print("V10 full ordinary small-even QDM replay: PASS")
