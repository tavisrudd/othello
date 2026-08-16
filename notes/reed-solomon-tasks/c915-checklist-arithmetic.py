#!/usr/bin/env python3
"""C915 post-edit checklist, sections D and E of the referee correction package.

Section D recomputes every characteristic-dependent maximal Lucas support
directly from the manuscript's definition

    M^max_{r,p} = P< e_j : C(r-2, j) = C(r-2, j-1) = 0 mod p >,   0 <= j <= r-1,

rather than trusting the prose labels, and compares it with the support each
proposition names.

Section E re-evaluates every point-count threshold and reports the first prime
power at which it holds.

Run:  python3 notes/reed-solomon-tasks/c915-checklist-arithmetic.py
"""

from math import comb, isqrt

EXPECTED_SUPPORTS = {
    # (redundancy r, characteristic p): expected basis indices
    (6, 2): [2, 3],
    (7, 2): [3],
    (8, 3): [2, 5],
    (8, 5): [3, 4],
    (9, 5): [4],
    (9, 7): [2, 3, 4, 5, 6],
    (10, 2): [2, 3, 4, 5, 6, 7],
    (10, 7): [3, 4, 5, 6],
}


def support(r, p):
    """Basis indices spanning the maximal Lucas carrier at redundancy r, char p."""
    row = r - 2

    def binom(n, k):
        return 0 if k < 0 or k > n else comb(n, k)

    return [j for j in range(r) if binom(row, j) % p == 0 and binom(row, j - 1) % p == 0]


def pascal_row(r, p):
    return [comb(r - 2, j) % p for j in range(r - 1)]


def is_prime_power(n):
    if n < 2:
        return False
    for base in range(2, n + 1):
        if base * base > n:
            break
        if n % base == 0:
            m = n
            while m % base == 0:
                m //= base
            return m == 1
    return True


def first_prime_power(bound, predicate):
    q = 2
    while q <= bound:
        if is_prime_power(q) and predicate(q):
            return q
        q += 1
    return None


def weil(q):
    """q + 1 - 2 sqrt q, exact when q is a square, else a float."""
    root = isqrt(q)
    return q + 1 - 2 * (root if root * root == q else q ** 0.5)


def main():
    print("D. Lucas-support arithmetic")
    ok = True
    for (r, p), expected in sorted(EXPECTED_SUPPORTS.items()):
        got = support(r, p)
        status = "PASS" if got == expected else "FAIL"
        ok &= got == expected
        print(
            f"  R{r} p={p}: row C({r-2},.) mod {p} = {pascal_row(r, p)}"
            f" -> P<{','.join('e' + str(j) for j in got) or 'empty'}>  {status}"
        )

    print("\nE. Threshold arithmetic")
    checks = [
        ("binary R5 bound at q=16", weil(16) > 6, f"{weil(16)} > 6"),
        ("R6 at q=29", weil(29) > 19, f"{weil(29):.3f} > 19"),
        ("R7 at q=37", weil(37) > 25, f"{weil(37):.3f} > 25"),
        ("R8 at q=43", weil(43) > 30, f"{weil(43):.3f} > 30"),
        ("R9 at q=53", weil(53) > 36, f"{weil(53):.3f} > 36"),
        ("R10 odd at q=59", weil(59) > 42, f"{weil(59):.3f} > 42"),
        ("D.10 complement at q=64", weil(64) > 48, f"{weil(64)} > 48"),
        ("D.12 binary slice at q=64", weil(64) > 2 * 23 + 2, f"{weil(64)} > 48"),
    ]
    for name, passed, detail in checks:
        ok &= passed
        print(f"  {name}: {detail}  {'PASS' if passed else 'FAIL'}")

    # The manuscript quotes an integer threshold at R5 and the first prime power
    # at every later level; both are reported so the comparison is unambiguous.
    firsts = [
        ("R5 general, deletion 12", 12, 20, "integer"),
        ("R6, deletion 19", 19, 29, "prime power"),
        ("R7, deletion 25", 25, 37, "prime power"),
        ("R8, deletion 30", 30, 43, "prime power"),
        ("R9, deletion 36", 36, 53, "prime power"),
        ("R10 odd, deletion 42", 42, 59, "prime power"),
    ]
    for name, deletion, claimed, kind in firsts:
        integer = next(q for q in range(2, 400) if weil(q) > deletion)
        power = first_prime_power(400, lambda q: weil(q) > deletion)
        got = integer if kind == "integer" else power
        status = "PASS" if got == claimed else "FAIL"
        ok &= got == claimed
        print(f"  {name}: integer threshold {integer}, first prime power {power};"
              f" manuscript quotes the {kind} threshold {claimed}  {status}")

    selector_60 = first_prime_power(200, lambda q: q >= 60 and q & (q - 1) == 0)
    ok &= selector_60 == 64
    print(f"  first binary field with at least 60 elements: {selector_60}"
          f"  {'PASS' if selector_60 == 64 else 'FAIL'}")
    char7 = next(7 ** m for m in range(1, 8) if 7 ** m > 102)
    ok &= char7 == 343
    print(f"  first power of seven above 102: {char7}"
          f"  {'PASS' if char7 == 343 else 'FAIL'}")
    # Three selector factors of individual root degree 4, 4 and 3 over five
    # roots: Schwartz-Zippel with the Vandermonde against block interpolation.
    m, indiv = 5, 4 + 4 + 3
    r10_selector = min(indiv * m + comb(m, 2) + 1, (indiv + 1) * m)
    ok &= r10_selector == 60
    print(f"  R10 binary selector min({indiv * m + comb(m, 2) + 1},"
          f" {(indiv + 1) * m}) = {r10_selector}"
          f"  {'PASS' if r10_selector == 60 else 'FAIL'}")

    print("\nALL PASS" if ok else "\nFAILURES PRESENT")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
