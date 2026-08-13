# Independent exact formal-at-infinity replay for the candidate V_10 operator.
# This accepts the operator as input; it does not certify its period recurrence
# or its identification with the full small-even QDM.

R.<lam, alpha, t> = PolynomialRing(QQ)

theta_on = [R(1)]
for unused in range(4):
    theta_on.append(
        t * theta_on[-1].derivative(t) + (lam * t + alpha) * theta_on[-1]
    )

expression = (
    theta_on[4]
    - 10 * t * (2 * theta_on[3] + 3 * theta_on[2] + theta_on[1])
    - 16 * t^2 * (37 * theta_on[2] + 74 * theta_on[1] + 39 * theta_on[0])
    - 2040 * t^3 * (2 * theta_on[1] + 3 * theta_on[0])
    - 8784 * t^4
)

leading = expression.coefficient({t: 4})
assert leading == (lam + 6)^2 * (lam^2 - 32 * lam - 244)

t3 = expression.coefficient({t: 3})
for root in (16 + 10 * QuadraticField(5, 's').gen(),
             16 - 10 * QuadraticField(5, 's').gen()):
    denominator = leading.derivative(lam).subs({lam: root})
    assert denominator != 0
    assert -t3.subs({alpha: 0, lam: root}) / denominator == -QQ(3) / 2

assert expression.coefficient({t: 3}).subs({lam: -6}) == 0
assert expression.coefficient({t: 2}).subs({lam: -6}) == -4 * (2 * alpha + 1) * (2 * alpha + 3)

print("V10 candidate formal replay: PASS (conditional on the scalar operator)")
