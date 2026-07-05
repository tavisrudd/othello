"""Minimal GF(q) for q = p^k, elements 0..q-1 as base-p digit vectors (coeffs of a
degree-<k polynomial). add = digitwise mod p; mul = poly mult mod an irreducible
poly. Supports the q we need for the cap-game probe."""

# monic irreducible poly coeffs (constant..degree) over F_p for each prime power.
# represented as the list of coefficients [c0, c1, ..., c_{k-1}, 1] (c_k=1).
IRRED = {
    4:  (2, [1, 1, 1]),        # x^2 + x + 1 over F_2
    8:  (2, [1, 1, 0, 1]),     # x^3 + x + 1 over F_2
    9:  (3, [1, 0, 1]),        # x^2 + 1 over F_3
    16: (2, [1, 1, 0, 0, 1]),  # x^4 + x + 1 over F_2
    25: (5, [3, 0, 1]),        # x^2 + 3  (3 nonsquare mod5) over F_5
    27: (3, [1, 2, 0, 1]),     # x^3 + 2x + 1 over F_3 (no roots -> irreducible)
}


def is_prime(m):
    if m < 2:
        return False
    d = 2
    while d * d <= m:
        if m % d == 0:
            return False
        d += 1
    return True


class GF:
    def __init__(self, q):
        self.q = q
        if is_prime(q):
            self.p, self.k = q, 1
            self._prime = True
        else:
            assert q in IRRED, f"unsupported q={q}"
            self.p, poly = IRRED[q]
            self.k = len(poly) - 1
            self._prime = False
            self.mod = poly  # length k+1
        # precompute add/mul tables
        self.addt = [[self.padd(a, b) for b in range(q)] for a in range(q)]
        self.mult = [[self.pmul(a, b) for b in range(q)] for a in range(q)]
        # inverses
        self.invt = [None] * q
        for a in range(1, q):
            for b in range(1, q):
                if self.mult[a][b] == 1:
                    self.invt[a] = b
                    break

    def digits(self, x):
        d = []
        for _ in range(self.k):
            d.append(x % self.p)
            x //= self.p
        return d

    def undig(self, d):
        x = 0
        for c in reversed(d):
            x = x * self.p + (c % self.p)
        return x

    def padd(self, a, b):
        if self._prime:
            return (a + b) % self.p
        da, db = self.digits(a), self.digits(b)
        return self.undig([(x + y) % self.p for x, y in zip(da, db)])

    def pmul(self, a, b):
        if self._prime:
            return (a * b) % self.p
        da, db = self.digits(a), self.digits(b)
        p, k = self.p, self.k
        # full product poly (degree up to 2k-2)
        prod = [0] * (2 * k)
        for i in range(k):
            for j in range(k):
                prod[i + j] = (prod[i + j] + da[i] * db[j]) % p
        # reduce mod self.mod (monic, degree k): x^k = -(mod[0..k-1])
        for deg in range(2 * k - 1, k - 1, -1):
            c = prod[deg]
            if c:
                prod[deg] = 0
                for i in range(k):
                    prod[deg - k + i] = (prod[deg - k + i] - c * self.mod[i]) % p
        return self.undig(prod[:k])

    def add(self, a, b):
        return self.addt[a][b]

    def sub(self, a, b):
        # -b: additive inverse = digitwise (p-x)%p
        if self._prime:
            return (a - b) % self.p
        db = self.digits(b)
        nb = self.undig([(-x) % self.p for x in db])
        return self.addt[a][nb]

    def mul(self, a, b):
        return self.mult[a][b]

    def inv(self, a):
        return self.invt[a]


def self_test():
    for q in [2, 3, 4, 5, 7, 8, 9, 25, 27]:
        F = GF(q)
        # every nonzero invertible
        assert all(F.invt[a] is not None for a in range(1, q)), q
        # a * a^{-1} = 1
        assert all(F.mul(a, F.inv(a)) == 1 for a in range(1, q)), q
        # distributivity spot check
        import itertools
        for a, b, c in itertools.islice(
                itertools.product(range(q), repeat=3), 200):
            assert F.mul(a, F.add(b, c)) == F.add(F.mul(a, b), F.mul(a, c)), (q, a, b, c)
    print("GF self-test OK")


if __name__ == "__main__":
    self_test()
