#!/usr/bin/env python3
"""Exact certificate for the Fricke/Hecke structure in the A5 cubic pencil.

Replay under Nix:
  nix-shell -p 'python3.withPackages (ps: [ ps.sympy ])' --run \
    'python -u notes/2026-08-10-c904-fricke-hecke-certificate.py'

The script checks the universal 3-isogeny, the X_0(3) passport, the Fricke
involution and twist, the Winger-pencil parameter bridge, and the exceptional
characteristic-11 collision.  All characteristic-zero calculations are exact.
Finite-field point counts are independent checks of the twist law.
"""

import sympy as sp


def invariants(a1, a2, a3, a4, a6):
    """Return b2,b4,b6,b8,c4,c6,Delta,j for a general Weierstrass model."""
    b2 = a1**2 + 4 * a2
    b4 = 2 * a4 + a1 * a3
    b6 = a3**2 + 4 * a6
    b8 = (
        a1**2 * a6
        + 4 * a2 * a6
        - a1 * a3 * a4
        + a2 * a3**2
        - a4**2
    )
    c4 = sp.factor(b2**2 - 24 * b4)
    c6 = sp.factor(-b2**3 + 36 * b2 * b4 - 216 * b6)
    discriminant = sp.factor(
        -b2**2 * b8 - 8 * b4**3 - 27 * b6**2 + 9 * b2 * b4 * b6
    )
    j = sp.factor(c4**3 / discriminant)
    return tuple(map(sp.factor, (b2, b4, b6, b8, c4, c6, discriminant, j)))


def reduce_on_source_curve(expression, x, y, A, B):
    """Reduce a rational expression modulo y^2+Axy+By=x^3."""
    numerator, denominator = sp.fraction(sp.cancel(expression))
    source_equation = y**2 + A * x * y + B * y - x**3
    remainder = sp.rem(sp.Poly(numerator, y), sp.Poly(source_equation, y)).as_expr()
    return sp.factor(remainder / denominator)


def legendre(a, p):
    value = pow(a % p, (p - 1) // 2, p)
    return 0 if value == 0 else (1 if value == 1 else -1)


def elliptic_trace(a1, a2, a3, a4, a6, p):
    """Brute-force trace for a general Weierstrass equation over F_p."""
    points = 1  # the point at infinity
    for x in range(p):
        for y in range(p):
            if (
                y * y
                + a1 * x * y
                + a3 * y
                - x**3
                - a2 * x * x
                - a4 * x
                - a6
            ) % p == 0:
                points += 1
    return p + 1 - points


def rational_mod(expression, symbol, value, p):
    numerator, denominator = sp.fraction(sp.cancel(expression))
    numerator_value = int(numerator.subs(symbol, value)) % p
    denominator_value = int(denominator.subs(symbol, value)) % p
    if denominator_value == 0:
        raise ZeroDivisionError
    return numerator_value * pow(denominator_value, -1, p) % p


def matrix_mod_group(level):
    return {
        (a, b, c, d)
        for a in range(level)
        for b in range(level)
        for c in range(level)
        for d in range(level)
        if (a * d - b * c) % level == 1
    }


def main():
    T, x, y = sp.symbols("T x y")
    A = T + 27
    B = A**2

    # Tate normal form with P=(0,0) of exact order three generically.
    source = invariants(A, 0, B, 0, 0)
    _, _, _, _, c4, _, delta, j = source
    J = sp.factor((T + 27) * (T + 3) ** 3 / T)
    assert delta == T * (T + 27) ** 8
    assert sp.factor(j - J) == 0

    # The quotient by <P>, in the same a1,a3 coordinates.
    quotient_coefficients = (A, 0, B, -5 * A * B, -B * (A**3 + 7 * B))
    quotient = invariants(*quotient_coefficients)
    _, _, _, _, c4_q, c6_q, delta_q, j_q = quotient
    J_prime = sp.factor((T + 27) * (T + 243) ** 3 / T**3)
    assert sp.factor(j_q - J_prime) == 0

    # Vélu's degree-three map.  The two nonzero kernel points are (0,0)
    # and (0,-B), so the only poles occur along the kernel divisor x=0.
    x_prime = x + A * B / x + B**2 / x**2
    y_prime = (
        y
        - A * B * (y + A * x) / x**2
        - B**2 * (2 * y + 2 * A * x + B) / x**3
    )
    target_equation = (
        y_prime**2
        + A * x_prime * y_prime
        + B * y_prime
        - x_prime**3
        + 5 * A * B * x_prime
        + B * (A**3 + 7 * B)
    )
    assert reduce_on_source_curve(target_equation, x, y, A, B) == 0

    # The Belyi passport of the degree-four map X_0(3)->X(1).
    passport_1728 = sp.factor(sp.together(J - 1728))
    assert passport_1728 == (T**2 + 18 * T - 27) ** 2 / T

    # The projective period equation is the hypergeometric triangle system
    # 2F1(1/3,2/3;1;z), with z=T/(T+27).  In T it becomes especially simple.
    z = T / (T + 27)
    z_prime = sp.diff(z, T)
    universal_pf_P = sp.factor(
        (1 - 2 * z) * z_prime / (z * (1 - z)) - sp.diff(z_prime, T) / z_prime
    )
    universal_pf_Q = sp.factor(-sp.Rational(2, 9) * z_prime**2 / (z * (1 - z)))
    assert universal_pf_P == 1 / T
    assert universal_pf_Q == -6 / (T * (T + 27) ** 2)

    # Gauge by D(T)^(-1/2), the quadratic twist appearing below.  This inserts
    # the chordal point as a scalar-monodromy singularity while leaving the
    # projective hypergeometric local system unchanged.
    D0 = (T + 27) * (5 * T - 729)
    logarithmic_derivative = sp.diff(D0, T) / (2 * D0)
    prym_pf_P = sp.factor(universal_pf_P + 2 * logarithmic_derivative)
    prym_pf_Q = sp.factor(
        universal_pf_Q
        + universal_pf_P * logarithmic_derivative
        + sp.diff(logarithmic_derivative, T)
        + logarithmic_derivative**2
    )
    assert sp.factor(
        prym_pf_P
        - 3 * (5 * T**2 - 396 * T - 6561) / (T * (T + 27) * (5 * T - 729))
    ) == 0
    assert sp.factor(
        prym_pf_Q
        - (25 * T**3 - 4605 * T**2 - 64881 * T + 2657205)
        / (T * (T + 27) ** 2 * (5 * T - 729) ** 2)
    ) == 0
    sl2_mod_3 = matrix_mod_group(3)
    gamma1_mod_3 = {
        matrix for matrix in sl2_mod_3 if matrix[0] == matrix[3] == 1 and matrix[2] == 0
    }
    gamma0_mod_3 = {matrix for matrix in sl2_mod_3 if matrix[2] == 0}
    plus_minus_gamma1_mod_3 = gamma1_mod_3 | {
        tuple((-entry) % 3 for entry in matrix) for matrix in gamma1_mod_3
    }
    assert len(gamma1_mod_3) == 3
    assert len(gamma0_mod_3) == 6
    assert plus_minus_gamma1_mod_3 == gamma0_mod_3

    # Fricke and its CM/self-isogeny factorization.
    fricke_T = 729 / T
    assert sp.factor(J.subs(T, fricke_T) - J_prime) == 0
    fricke_difference = sp.factor(sp.together(J - J.subs(T, fricke_T)))
    expected_difference = (
        (T - 27)
        * (T + 27)
        * (T**2 - 10 * T + 729)
        * (T**2 + 46 * T + 729)
        / T**3
    )
    assert fricke_difference == expected_difference

    # Pull back the full classical level-three modular polynomial to the
    # cubic-moduli coordinate.  The linear factor TU-729 is the distinguished
    # Fricke branch; the residual correspondence records the other three
    # cyclic order-three quotients of the elliptic shadow.
    U, X, Y = sp.symbols("U X Y")
    phi_3 = (
        X**4
        + (-Y**3 + 2232 * Y**2 - 1069956 * Y + 36864000) * X**3
        + (
            2232 * Y**3
            + 2587918086 * Y**2
            + 8900222976000 * Y
            + 452984832000000
        )
        * X**2
        + (
            -1069956 * Y**3
            + 8900222976000 * Y**2
            - 770845966336000000 * Y
            + 1855425871872000000000
        )
        * X
        + Y**4
        + 36864000 * Y**3
        + 452984832000000 * Y**2
        + 1855425871872000000000 * Y
    )
    J_U = (U + 27) * (U + 3) ** 3 / U
    hecke_numerator = sp.together(phi_3.subs({X: J, Y: J_U})).as_numer_denom()[0]
    assert sp.rem(sp.Poly(hecke_numerator, U), sp.Poly(T * U - 729, U)) == 0
    hecke_factors = sp.factor_list(hecke_numerator)[1]
    hecke_bidegrees = sorted(
        (sp.degree(factor, T), sp.degree(factor, U))
        for factor, multiplicity in hecke_factors
        for _ in range(multiplicity)
    )
    assert hecke_bidegrees == [(1, 1), (3, 3), (3, 3), (9, 9)]
    cubic_hecke_factors = [
        factor
        for factor, multiplicity in hecke_factors
        if multiplicity == 1 and sp.degree(factor, T) == sp.degree(factor, U) == 3
    ]
    assert len(cubic_hecke_factors) == 2
    assert any(
        sp.factor(left.subs({T: U, U: T}, simultaneous=True) + right) == 0
        for left in cubic_hecke_factors
        for right in cubic_hecke_factors
    )

    fixed_values = {
        "T=27": sp.factor(J.subs(T, 27)),
        "T=-27": sp.factor(J.subs(T, -27)),
    }
    q1_remainder = sp.rem(
        sp.Poly(sp.together(J + 32768).as_numer_denom()[0], T),
        sp.Poly(T**2 - 10 * T + 729, T),
    ).as_expr()
    q2_remainder = sp.rem(
        sp.Poly(sp.together(J - 8000).as_numer_denom()[0], T),
        sp.Poly(T**2 + 46 * T + 729, T),
    ).as_expr()
    assert sp.factor(q1_remainder) == 0
    assert sp.factor(q2_remainder) == 0
    assert fixed_values == {"T=27": 54000, "T=-27": 0}

    # The two nontrivial CM self-isogeny pairs are sixth powers of norm-three
    # generators.  For discriminant -11 this is exactly the pair of primes
    # above 3 that appeared independently in the finite orientation work.
    alpha = sp.symbols("alpha")
    alpha_polynomial = alpha**2 + alpha + 3
    alpha_sixth = sp.rem(
        sp.Poly(alpha**6, alpha), sp.Poly(alpha_polynomial, alpha)
    ).as_expr()
    alpha_bar_sixth = sp.rem(
        sp.Poly((-1 - alpha) ** 6, alpha), sp.Poly(alpha_polynomial, alpha)
    ).as_expr()
    assert alpha_sixth == -16 * alpha - 3
    assert alpha_bar_sixth == 16 * alpha + 13
    assert sp.rem(
        sp.Poly((T**2 - 10 * T + 729).subs(T, alpha_sixth), alpha),
        sp.Poly(alpha_polynomial, alpha),
    ).as_expr() == 0
    assert sp.rem(
        sp.Poly(alpha_sixth * alpha_bar_sixth - 729, alpha),
        sp.Poly(alpha_polynomial, alpha),
    ).as_expr() == 0

    beta = sp.symbols("beta")
    beta_polynomial = beta**2 - 2 * beta + 3
    beta_sixth = sp.rem(
        sp.Poly(beta**6, beta), sp.Poly(beta_polynomial, beta)
    ).as_expr()
    beta_bar_sixth = sp.rem(
        sp.Poly((2 - beta) ** 6, beta), sp.Poly(beta_polynomial, beta)
    ).as_expr()
    assert sp.rem(
        sp.Poly((T**2 + 46 * T + 729).subs(T, -beta_sixth), beta),
        sp.Poly(beta_polynomial, beta),
    ).as_expr() == 0
    assert sp.rem(
        sp.Poly(beta_sixth * beta_bar_sixth - 729, beta),
        sp.Poly(beta_polynomial, beta),
    ).as_expr() == 0
    assert J.subs(T, -3) == 0
    assert J.subs(T, -243) == -12288000

    # Arithmetic descent of the explicit van Geemen--Yamauchi Prym curve.
    # Their A5 specialization is written over Q(u), with u^2=5t^2 and
    # T=81t^2=81u^2/5.  Comparing c4 and c6 identifies the precise quadratic
    # twist between their Weierstrass model and the universal Tate model.
    u = sp.symbols("u")
    a_gy = -32 * (u - 3) ** 4 / (9 * (u + 1) ** 3 * (u + 3) ** 2)
    b_gy = -8 * (u - 3) ** 2 * (u - 1) / ((u + 1) * (u + 3) ** 2)
    gy_a1 = b_gy**2 / 4 + b_gy - 4
    gy_a3 = (a_gy + b_gy) ** 2 / 2 + 4 * a_gy + 6 * b_gy - 8
    gy_a2 = (
        2
        - a_gy
        - a_gy * b_gy / 2
        - b_gy**4 / 64
        - b_gy**3 / 8
        - b_gy**2 / 4
        - b_gy
    )
    gy_a4 = 4 * (a_gy + b_gy - 1)
    gy_a6 = (a_gy + b_gy - 1) * (
        8
        - 4 * a_gy
        - 2 * a_gy * b_gy
        - b_gy**4 / 16
        - b_gy**3 / 2
        - b_gy**2
        - 4 * b_gy
    )
    cancel_factor = lambda expression: sp.factor(sp.cancel(expression))
    gy_standard_discriminant = cancel_factor(
        512 * a_gy**2
        + 27 * a_gy**3
        + 48 * a_gy**2 * b_gy
        + 128 * a_gy * b_gy**2
        + 6 * a_gy**2 * b_gy**2
        + 30 * a_gy * b_gy**3
        + a_gy**2 * b_gy**3
        + 8 * b_gy**4
        + 2 * a_gy * b_gy**4
        + b_gy**5
    )
    gy_discriminant_formula = cancel_factor(
        -sp.Rational(1, 16) * a_gy**5 * gy_standard_discriminant
    )
    gy_a1, gy_a2, gy_a3, gy_a4, gy_a6 = map(
        cancel_factor, (gy_a1, gy_a2, gy_a3, gy_a4, gy_a6)
    )
    gy_b2 = cancel_factor(gy_a1**2 + 4 * gy_a2)
    gy_b4 = cancel_factor(2 * gy_a4 + gy_a1 * gy_a3)
    gy_b6 = cancel_factor(gy_a3**2 + 4 * gy_a6)
    gy_c4 = cancel_factor(gy_b2**2 - 24 * gy_b4)
    gy_c6 = cancel_factor(-gy_b2**3 + 36 * gy_b2 * gy_b4 - 216 * gy_b6)
    T_u = 81 * u**2 / 5
    universal_u_c4 = cancel_factor((T_u + 27) ** 3 * (T_u + 3))
    universal_u_c6 = cancel_factor(
        -(T_u + 27) ** 4 * (T_u**2 + 18 * T_u - 27)
    )
    twist_multiplier = cancel_factor(
        (gy_c6 / universal_u_c6) / (gy_c4 / universal_u_c4)
    )
    assert cancel_factor(gy_c4 / universal_u_c4 - twist_multiplier**2) == 0
    assert cancel_factor(gy_c6 / universal_u_c6 - twist_multiplier**3) == 0
    prym_twist_class = (T_u + 27) * (T_u - sp.Rational(729, 5))
    square_witness = (
        200
        * (u - 3) ** 2
        / (2187 * (u + 1) ** 2 * (u + 3) ** 2 * (3 * u**2 + 5))
    )
    assert cancel_factor(twist_multiplier / prym_twist_class - square_witness**2) == 0

    # A global descended Prym model over Q(T), avoiding both sqrt(5) and the
    # poles of the u-chart.  D_integral differs from D(T) by the square 25.
    D_integral = 5 * (T + 27) * (5 * T - 729)
    universal_c4 = (T + 27) ** 3 * (T + 3)
    universal_c6 = -(T + 27) ** 4 * (T**2 + 18 * T - 27)
    descended_a4 = -27 * D_integral**2 * universal_c4
    descended_a6 = -54 * D_integral**3 * universal_c6
    descended_prym = invariants(0, 0, 0, descended_a4, descended_a6)
    descended_c4, descended_c6, descended_delta, descended_j = descended_prym[4:8]
    assert sp.factor(descended_c4 - 6**4 * D_integral**2 * universal_c4) == 0
    assert sp.factor(descended_c6 - 6**6 * D_integral**3 * universal_c6) == 0
    assert sp.factor(descended_delta - 6**12 * D_integral**6 * delta) == 0
    assert sp.factor(descended_j - J) == 0
    minimal_a4 = sp.factor(descended_a4 / (T + 27) ** 4)
    minimal_a6 = sp.factor(descended_a6 / (T + 27) ** 6)
    minimal_prym = invariants(0, 0, 0, minimal_a4, minimal_a6)
    minimal_c4, minimal_c6, minimal_delta, minimal_j = minimal_prym[4:8]
    assert sp.factor(minimal_delta - descended_delta / (T + 27) ** 12) == 0
    assert sp.factor(minimal_j - J) == 0
    assert sp.degree(minimal_a4, T) == 4
    assert sp.degree(minimal_a6, T) == 6
    assert sp.degree(minimal_delta, T) == 9  # remaining order 3 lies at infinity
    assert sp.factor(minimal_delta) == (
        34012224000000 * T * (T + 27) ** 2 * (5 * T - 729) ** 6
    )

    prym_fricke_twist = sp.factor(
        -3
        * ((fricke_T + 27) * (fricke_T - sp.Rational(729, 5)))
        / ((T + 27) * (T - sp.Rational(729, 5)))
    )
    prym_fricke_square_class = (T - 5) * (5 * T - 729)
    # Avoid trusting symbolic square-root simplification: the quotient is the
    # displayed rational square 3^10/[T^2(5T-729)^2].
    assert sp.factor(
        prym_fricke_twist / prym_fricke_square_class
        - (3**5 / (T * (5 * T - 729))) ** 2
    ) == 0

    # The invariant ratios determine the twist only up to sign.  Direct
    # comparison (and the independent point counts below) identifies the
    # standard Tate model E_{729/T} with the -3 twist of E'_T, after scaling
    # by 9/T.  Ratios c4=d^2 u^4 and Delta=d^6 u^12 cannot see that sign.
    A_f = sp.factor(fricke_T + 27)
    B_f = sp.factor(A_f**2)
    fricke_curve = invariants(A_f, 0, B_f, 0, 0)
    c4_f, c6_f, delta_f = fricke_curve[4], fricke_curve[5], fricke_curve[6]
    scale = 9 / T
    assert sp.factor(c4_f / c4_q - 3**2 * scale**4) == 0
    assert sp.factor(c6_f / c6_q - (-3) ** 3 * scale**6) == 0
    assert sp.factor(delta_f / delta_q - 3**6 * scale**12) == 0

    # Independent finite-field checks: a_p(E_{w_3(T)})=(-3/p)a_p(E_T).
    trace_checks = []
    for p in (5, 7, 11, 13, 17, 19, 23, 29):
        for parameter in range(1, p):
            if (parameter + 27) % p == 0:
                continue
            partner = (729 * pow(parameter, -1, p)) % p
            if (partner + 27) % p == 0:
                continue
            a = (parameter + 27) % p
            b = a * a % p
            af = (partner + 27) % p
            bf = af * af % p
            trace = elliptic_trace(a, 0, b, 0, 0, p)
            partner_trace = elliptic_trace(af, 0, bf, 0, 0, p)
            if partner_trace != legendre(-3, p) * trace:
                print(
                    "TRACE MISMATCH",
                    p,
                    parameter,
                    partner,
                    trace,
                    partner_trace,
                    legendre(-3, p),
                )
            assert partner_trace == legendre(-3, p) * trace
        trace_checks.append((p, legendre(-3, p)))

    # Directly evaluate the published Prym Weierstrass model on the eight
    # smooth F_11 pencil members.  Either square root u^2=5t^2 may be used;
    # choose one for which this affine chart is defined.
    p = 11
    smooth_r = (1, 2, 4, 5, 6, 8, 9, 10)
    prym_traces_f11 = {}
    prym_twist_checks_f11 = {}
    for r_value in smooth_r:
        t_value = 2 * (r_value - 3) * pow(r_value, -1, p) % p
        chart_traces = []
        for sqrt_five in (4, 7):
            u_value = sqrt_five * t_value % p
            try:
                gy_coefficients = tuple(
                    rational_mod(coefficient, u, u_value, p)
                    for coefficient in (gy_a1, gy_a2, gy_a3, gy_a4, gy_a6)
                )
            except ZeroDivisionError:
                continue
            gy_trace = elliptic_trace(*gy_coefficients, p)
            T_value = 81 * t_value**2 % p
            universal_a = (T_value + 27) % p
            universal_b = universal_a**2 % p
            universal_trace = elliptic_trace(universal_a, 0, universal_b, 0, 0, p)
            D_value = (T_value + 27) * (T_value - 729 * pow(5, -1, p)) % p
            assert gy_trace == legendre(D_value, p) * universal_trace
            chart_traces.append(gy_trace)
            prym_twist_checks_f11[r_value] = (T_value, D_value, universal_trace)
        if not chart_traces:
            raise AssertionError(f"no valid Prym chart for r={r_value}")
        assert set(chart_traces) == {-3}
        prym_traces_f11[r_value] = chart_traces[0]
    assert set(prym_traces_f11.values()) == {-3}
    f11_T_by_r = {r_value: data[0] for r_value, data in prym_twist_checks_f11.items()}
    f11_j_by_r = {
        r_value: rational_mod(J, T, T_value, p)
        for r_value, T_value in f11_T_by_r.items()
    }
    assert set(f11_T_by_r.values()) == {1, 3, 4, 9}
    assert set(f11_j_by_r.values()) == {4, 10}
    descended_traces_f11 = {
        r_value: elliptic_trace(
            0,
            0,
            0,
            int(descended_a4.subs(T, T_value)) % p,
            int(descended_a6.subs(T, T_value)) % p,
            p,
        )
        for r_value, T_value in f11_T_by_r.items()
    }
    assert descended_traces_f11 == prym_traces_f11

    # The Fricke trace multiplier specializes to a square identically in
    # characteristic 11: (T-5)(5T-729)=5(T-5)^2.
    for T_value in range(p):
        left = (T_value - 5) * (5 * T_value - 729) % p
        right = 5 * (T_value - 5) ** 2 % p
        assert left == right

    # Independent direct checks of the parameter-dependent Prym Fricke law.
    prym_fricke_direct_checks = []
    for p in (11, 19, 29, 31):
        checks = 0
        for u_value in range(1, p):
            partner_u = 5 * pow(3 * u_value, -1, p) % p
            try:
                coefficients = tuple(
                    rational_mod(coefficient, u, u_value, p)
                    for coefficient in (gy_a1, gy_a2, gy_a3, gy_a4, gy_a6)
                )
                partner_coefficients = tuple(
                    rational_mod(coefficient, u, partner_u, p)
                    for coefficient in (gy_a1, gy_a2, gy_a3, gy_a4, gy_a6)
                )
            except ZeroDivisionError:
                continue
            T_value = 81 * u_value**2 * pow(5, -1, p) % p
            trace_character_value = (T_value - 5) * (5 * T_value - 729) % p
            if trace_character_value == 0:
                continue
            trace = elliptic_trace(*coefficients, p)
            partner_trace = elliptic_trace(*partner_coefficients, p)
            assert partner_trace == legendre(trace_character_value, p) * trace
            checks += 1
        assert checks > 0
        prym_fricke_direct_checks.append((p, checks))

    descended_fricke_checks = []
    for p in (7, 11, 13, 17, 19, 23, 29, 31):
        checks = 0
        for T_value in range(1, p):
            partner_T = 729 * pow(T_value, -1, p) % p
            R_value = (T_value - 5) * (5 * T_value - 729) % p
            D_value = 5 * (T_value + 27) * (5 * T_value - 729) % p
            partner_D = 5 * (partner_T + 27) * (5 * partner_T - 729) % p
            if R_value == 0 or D_value == 0 or partner_D == 0:
                continue
            coefficients = (
                int(descended_a4.subs(T, T_value)) % p,
                int(descended_a6.subs(T, T_value)) % p,
            )
            partner_coefficients = (
                int(descended_a4.subs(T, partner_T)) % p,
                int(descended_a6.subs(T, partner_T)) % p,
            )
            trace = elliptic_trace(0, 0, 0, *coefficients, p)
            partner_trace = elliptic_trace(0, 0, 0, *partner_coefficients, p)
            assert partner_trace == legendre(R_value, p) * trace
            checks += 1
        assert checks > 0
        descended_fricke_checks.append((p, checks))

    # Looijenga--Zi's Winger coordinate w has special values
    # 0, infinity, 27/5, -1.  Matching the orbifold point and the two cusp
    # widths gives the unique affine bridge T=5w-27.
    w = sp.symbols("w")
    winger_T = 5 * w - 27
    winger_j = sp.factor(J.subs(T, winger_T))
    winger_fricke = sp.factor((fricke_T.subs(T, winger_T) + 27) / 5)
    assert winger_j == 5 * w * (5 * w - 24) ** 3 / (5 * w - 27)
    assert winger_fricke == 27 * w / (5 * w - 27)
    assert winger_T.subs(w, 0) == -27       # triple conic / order-3 orbifold
    assert winger_T.subs(w, sp.Rational(27, 5)) == 0  # ten-node / width-1 cusp
    assert winger_T.subs(w, -1) == -32      # six-node Bring normalization
    assert sp.factor(J.subs(T, -32)) == -sp.Rational(121945, 32)
    assert sp.factor((sp.Rational(729, 5) + 27) / 5) == sp.Rational(864, 25)
    assert sp.Rational(5 + 27, 5) == sp.Rational(32, 5)

    # Paper-V affine coordinate r and the exceptional characteristic 11.
    r, r_prime = sp.symbols("r r_prime")
    cubic_t = 2 * (r - 3) / r
    lifted_partner_t = 1 / (3 * cubic_t)
    solved_r_prime = sp.factor(6 / (2 - lifted_partner_t))
    assert sp.factor(solved_r_prime - 36 * (r - 3) / (11 * r - 36)) == 0
    assert sp.rem(sp.Poly(729 - 25, T), sp.Poly(11, T)).as_expr() == 0
    assert sp.factorint(729 - 25) == {2: 6, 11: 1}

    print("Universal 3-isogeny")
    print(f"  E_T:  y^2+(T+27)xy+(T+27)^2 y=x^3")
    print(f"  Delta(E_T)={delta}")
    print(f"  j(E_T)={j}")
    print(f"  j(E_T/<(0,0)>)={j_q}")
    print(f"  Velu x-map: {sp.factor(x_prime)}")
    print("X_0(3) passport")
    print("  J zeros: T=-27 (order 1), T=-3 (order 3)")
    print("  J poles: T=0 (order 1), T=infinity (order 3)")
    print(f"  J-1728={passport_1728}")
    print("Picard--Fuchs reduction")
    print(f"  universal: f'' + ({universal_pf_P}) f' + ({universal_pf_Q}) f = 0")
    print(f"  Prym twist coefficient P(T)={prym_pf_P}")
    print(f"  Prym twist coefficient Q(T)={prym_pf_Q}")
    print("  chordal T=729/5 is scalar -I monodromy, invisible projectively")
    print("  <Gamma_1(3),-I>=Gamma_0(3): same coarse curve, different stack lift")
    print("Fricke/CM factorization")
    print(f"  J(T)-J(729/T)={fricke_difference}")
    print("  T^2-10T+729: j=-32768 (CM discriminant -11)")
    print("  T^2+46T+729: j=8000 (CM discriminant -8)")
    print("  T=27: j=54000 (CM discriminant -12)")
    print("  T=-27: j=0 (CM discriminant -3 boundary)")
    print("  for alpha^2+alpha+3=0, the D=-11 roots are alpha^6 and alpha_bar^6")
    print("  T=-3 <-> -243 has j=0 <-> -12288000 (the D=-3 conductor step)")
    print("Full degree-three Hecke pullback")
    print(f"  irreducible component bidegrees={hecke_bidegrees}")
    print("  Fricke component: T*U-729")
    print(f"  one cubic component: {cubic_hecke_factors[0]}")
    print("  the other cubic is its transpose; the last component has bidegree (9,9)")
    print("Arithmetic Fricke twist")
    print("  E_{729/T} is the quadratic twist by -3 of E_T/<(0,0)>")
    print(f"  finite-field checks (p,(-3/p)): {trace_checks}")
    print("Explicit Prym/Tate comparison")
    print(f"  twist multiplier modulo squares: {twist_multiplier}")
    print("  square class D(T)=(T+27)(T-729/5)")
    print("  global Q(T) model: y^2=x^3+a4(T)x+a6(T)")
    print(f"    a4(T)={minimal_a4}")
    print(f"    a6(T)={minimal_a6}")
    print(f"    Delta={sp.factor(minimal_delta)} (plus order 3 at infinity)")
    print("    Kodaira fibers: I1 at 0, II at -27, I0* at 729/5, I3 at infinity")
    fibre_euler_numbers = (1, 2, 6, 3)
    reducible_root_ranks = (4, 2)  # D4 from I0*, A2 from I3.
    assert sum(fibre_euler_numbers) == 12
    geometric_mordell_weil_rank = 10 - 2 - sum(reducible_root_ranks)
    assert geometric_mordell_weil_rank == 2
    print("    Shioda--Tate: root lattice D4+A2, geometric Mordell--Weil rank 2")
    print(f"  explicit Prym discriminant={gy_discriminant_formula}")
    print("  Tate degeneration plus D(T) detects the full cubic boundary support")
    print("  (the displayed u-chart has removable coordinate poles at u=-1,-3)")
    print("  Prym Fricke trace character: ((T-5)(5T-729)/q)")
    print(f"  direct Prym Fricke checks (p,count): {prym_fricke_direct_checks}")
    print(f"  descended-model Fricke checks (p,count): {descended_fricke_checks}")
    print(f"  direct F_11 Prym traces by r: {prym_traces_f11}")
    print(f"  F_11 T-values by r: {f11_T_by_r}")
    print(f"  F_11 j-values by r: {f11_j_by_r}")
    print("Winger bridge")
    print("  T=5w-27")
    print(f"  j_W(w)={winger_j}")
    print(f"  Winger-coordinate Fricke involution: w'={winger_fricke}")
    print("  the two pencils share T=infinity,0,-27 as three marked singular fibres")
    print("  Winger Bring fibre w=-1 maps to smooth cubic T=-32")
    print("  cubic chordal T=729/5 maps to smooth Winger w=864/25")
    print("Paper-V F_11 anomaly")
    print(f"  formal rational lift of the r-map: r'={solved_r_prime}")
    print("  modulo 11: r'=3-r")
    print("  chordal T=729/5 meets its Fricke partner T=5 only at p=11")
    print("PASS")


if __name__ == "__main__":
    main()
