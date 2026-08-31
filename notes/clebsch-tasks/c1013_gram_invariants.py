#!/usr/bin/env python3
"""Exact checks for the first four-point Gram–discriminant invariants."""

from fractions import Fraction as Q


def add(a, b):
    n = max(len(a), len(b))
    return [
        (a[i] if i < len(a) else Q(0))
        + (b[i] if i < len(b) else Q(0))
        for i in range(n)
    ]


def scale(a, c):
    return [c * x for x in a]


def mul(a, b):
    out = [Q(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return trim(out)


def power(a, n):
    out = [Q(1)]
    while n:
        if n & 1:
            out = mul(out, a)
        a = mul(a, a)
        n //= 2
    return out


def trim(a):
    while len(a) > 1 and a[-1] == 0:
        a.pop()
    return a


def exact_division(a, b):
    a = a[:]
    out = [Q(0)] * (len(a) - len(b) + 1)
    while len(a) >= len(b):
        shift = len(a) - len(b)
        coefficient = a[-1] / b[-1]
        out[shift] = coefficient
        for j, value in enumerate(b):
            a[shift + j] -= coefficient * value
        trim(a)
    assert a == [Q(0)]
    return trim(out)


def gram_quotient(d):
    x = [Q(0), Q(1)]
    xm1 = [Q(-1), Q(1)]
    a = power(x, d)
    b = power(xm1, d)
    determinant = add(
        add(add([Q(1)], power(a, 2)), power(b, 2)),
        add(scale(a, Q(-2)), add(scale(b, Q(-2)), scale(mul(a, b), Q(-2)))),
    )
    discriminant = mul(power(x, 2), power(xm1, 2))
    return exact_division(trim(determinant), discriminant)


def main():
    i = [Q(1), Q(-1), Q(1)]
    j = mul(mul([Q(1), Q(1)], [Q(-2), Q(1)]), [Q(-1), Q(2)])
    expected = {
        4: scale(i, Q(16)),
        6: scale(add(scale(power(i, 3), Q(320)), power(j, 2)), Q(1, 9)),
        8: scale(
            add(scale(power(i, 5), Q(1792)), scale(mul(power(i, 2), power(j, 2)), Q(-16))),
            Q(1, 27),
        ),
        10: scale(
            add(
                scale(power(i, 7), Q(87040)),
                add(
                    scale(mul(power(i, 4), power(j, 2)), Q(-3695)),
                    scale(mul(i, power(j, 4)), Q(40)),
                ),
            ),
            Q(1, 729),
        ),
    }
    for degree, target in expected.items():
        assert gram_quotient(degree) == trim(target), degree
    print("C1013 Gram invariant identities: PASS")


if __name__ == "__main__":
    main()
