"""Shared data transcribed from the Clebsch->quantum memo (4 Sept 2026)."""

E7_TXT = """
 3  5  0  0  3  2
 0  0  0  0  0  0
 6  4  6  5  3  6
 2  4  0  0  2  3
 1  0  6  5  2  5
 5  5  6  5  0  1
 4  3  3  6  4  4
 3  5  0  5  0  0
 0  0  0  5  2  3
 6  4  6  3  2  5
 2  4  0  5  3  2
 1  0  6  3  0  1
 5  5  6  3  3  6
 4  3  3  4  4  4
"""

E11_TXT = """
 0  0  0  0  0  0  0  0  0  0
 6  8  3  4  9  6 10  6  6  5
 8  5  4  1  0  0  4  2  1  9
 9 10  2  7  0  0 10  4  6  8
 3  1  1  2  0  0  7  7  3  7
10  1  9  2  9  6  0 10  0  2
 4 10  8  7  9  6  4  8  1  4
 5  5  6  1  9  6  7  3  3  6
 7  8  7  4  0  0  9  1 10  3
 2  0 10  0  9  6  9  9 10 10
 1  7  5  5 10  3  6  5  4  1
 0  0  0  0  0  1  9  1 10  3
 6  8  3  4  9  7  9  9 10 10
 8  5  4  1  0  1  7  7  3  7
 9 10  2  7  0  1  4  2  1  9
 3  1  1  2  0  1  0  0  0  0
10  1  9  2  9  7  7  3  3  6
 4 10  8  7  9  7 10  6  6  5
 5  5  6  1  9  7  4  8  1  4
 7  8  7  4  0  1 10  4  6  8
 2  0 10  0  9  7  0 10  0  2
 1  7  5  5 10  4  6  5  4  1
"""


def parse(txt):
    return [[int(t) for t in line.split()] for line in txt.strip().splitlines()]


E7 = parse(E7_TXT)
E11 = parse(E11_TXT)

MON7 = ["X^2", "XY", "XZ", "Y^2", "YZ", "Z^2"]
MON11 = ["X^4", "X^3Y", "X^3Z", "X^2YZ", "X^2Z^2", "XY^2Z", "XYZ^2", "XZ^3",
         "YZ^3", "Z^4"]

# exponent tuples (eX, eY, eZ) matching the monomial orders above
EXP7 = [(2, 0, 0), (1, 1, 0), (1, 0, 1), (0, 2, 0), (0, 1, 1), (0, 0, 2)]
EXP11 = [(4, 0, 0), (3, 1, 0), (3, 0, 1), (2, 1, 1), (2, 0, 2), (1, 2, 1),
         (1, 1, 2), (1, 0, 3), (0, 1, 3), (0, 0, 4)]

B1 = "6*u0*u2*u5 + 4*u0*u3*u5 + 4*u0*u4**2 + 4*u1**2*u5 + 3*u1*u2*u4 " \
     "+ 3*u1*u3*u4 + 2*u2**2*u3 + u2*u3**2 + u3**3"

B2 = ("4*u0*u4*u9 + 7*u0*u5*u9 + 3*u0*u6*u8 + 5*u0*u7**2 "
      "+ 3*u1*u3*u9 + 9*u1*u4*u8 + 8*u1*u5*u8 + 4*u1*u6*u7 "
      "+ 5*u2**2*u9 + 4*u2*u3*u8 + 3*u2*u4*u7 + 5*u2*u5*u7 + 9*u2*u6**2 "
      "+ 9*u3**2*u7 + 5*u3*u4*u6 + 8*u3*u5*u6 + 3*u4**2*u5 + 4*u4*u5**2 "
      "+ 5*u5**3")

A7_CLAIM = {0: 1, 6: 378, 7: 516, 8: 6468, 9: 25284, 10: 74382, 11: 154644,
            12: 247842, 13: 218064, 14: 95964}

A11_CLAIM = {0: 1, 8: 1100, 9: 0, 10: 41800, 11: 157320, 12: 2436940,
             13: 17133600, 14: 112941400, 15: 595194160, 16: 2622117190,
             17: 9214830020, 18: 25660748300, 19: 53955314600,
             20: 80976004780, 21: 77104831760, 22: 35049917640}


def data(p):
    if p == 7:
        return E7, EXP7, MON7
    return E11, EXP11, MON11


def eps(p):
    return [1] * p + [p - 1] * p  # (-1) mod p


def gmat(p):
    """G = (1^T ; E^T), p x 2p over F_p."""
    E, _, _ = data(p)
    n = 2 * p
    k = p - 1
    rows = [[1] * n]
    for j in range(k):
        rows.append([E[i][j] % p for i in range(n)])
    return rows


def rank_mod(rows, p):
    m = [r[:] for r in rows]
    nr = len(m)
    nc = len(m[0]) if nr else 0
    r = 0
    for c in range(nc):
        piv = None
        for i in range(r, nr):
            if m[i][c] % p:
                piv = i
                break
        if piv is None:
            continue
        m[r], m[piv] = m[piv], m[r]
        inv = pow(m[r][c], p - 2, p)
        m[r] = [(x * inv) % p for x in m[r]]
        for i in range(nr):
            if i != r and m[i][c] % p:
                f = m[i][c]
                m[i] = [(m[i][j] - f * m[r][j]) % p for j in range(nc)]
        r += 1
        if r == nr:
            break
    return r
