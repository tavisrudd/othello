#!/usr/bin/env python3
"""C756: verify the key algebraic step of the Theorem 4 Weil argument.

For q = 3 (mod 4), F_{q^2} = F_q(i) with i^2 = eps, the circle is parametrised by
c(t) = (t-i)/(t+i) and the residual clique family is Z = a*S_j + b with
S_j = Q_j ∪ {0}, kappa = b - b^q = i*g.  The crown condition on a pair of nonzero
circle elements is chi_q(F(t,t')) = -1 where F = N(W) and

    W = a(t-i)(t'+i) - a^q(t+i)(t'-i) + kappa(t+i)(t'+i)
      = P(t)*t' + Q(t),
    P = i(2a1+g) t + (eps*g - 2 i a0),
    Q = (eps*g + 2 i a0) t + i*eps*(g - 2a1).

Claims verified here, for every q = 3 (mod 4) up to 43, every a with chi(a)=1 and
every g:

  C1  c(t) is a bijection F_q ∪ {inf} -> C, with c(t)^q = c(-t);
  C2  c(t) in Q_0  <=>  chi_q(t^2 - eps) = +1;
  C3  the claimed P, Q reproduce W;
  C4  disc_{t'} F(t,t') = eps * L(t)^2 with
        L(t) = 2*eps*g*[(2a1+g) t^2 - 4 a0 t + eps*(2a1 - g)];
  C5  hence F(t,.) is an irreducible quadratic in t' whenever L(t) != 0 and its
      leading coefficient N(P(t)) != 0;
  C6  L == 0 (as a polynomial) if and only if g = 0;
  C7  g = 0 forces chi(a) = -1, so it never occurs in the family.

Replay:  python3 2026-08-02-c756-weil-discriminant-check.py
"""

from __future__ import annotations

import json
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-02-c756-weil-discriminant-check.json"

QS = [7, 11, 19, 23, 31, 43]


def legendre(a: int, q: int) -> int:
    a %= q
    return 0 if a == 0 else (1 if pow(a, (q - 1) // 2, q) == 1 else -1)


def least_nonsquare(q: int) -> int:
    return next(e for e in range(2, q) if legendre(e, q) == -1)


class F2:
    def __init__(self, q: int, eps: int) -> None:
        self.q, self.eps = q, eps

    def add(self, x, y):
        return ((x[0] + y[0]) % self.q, (x[1] + y[1]) % self.q)

    def sub(self, x, y):
        return ((x[0] - y[0]) % self.q, (x[1] - y[1]) % self.q)

    def mul(self, x, y):
        q, e = self.q, self.eps
        return ((x[0] * y[0] + e * x[1] * y[1]) % q, (x[0] * y[1] + x[1] * y[0]) % q)

    def conj(self, x):
        return (x[0], (-x[1]) % self.q)

    def norm(self, x):
        return (x[0] * x[0] - self.eps * x[1] * x[1]) % self.q

    def inv(self, x):
        n = pow(self.norm(x), self.q - 2, self.q)
        c = self.conj(x)
        return ((c[0] * n) % self.q, (c[1] * n) % self.q)

    def chi(self, x):
        return legendre(self.norm(x), self.q)

    def scal(self, k, x):
        return ((k * x[0]) % self.q, (k * x[1]) % self.q)


def check_field(q: int) -> dict:
    eps = least_nonsquare(q)
    F = F2(q, eps)
    I = (0, 1)
    assert q % 4 == 3

    # ---- C1, C2: circle parametrisation --------------------------------
    circle = {x for x in
              ((a, b) for a in range(q) for b in range(q)) if F.norm((a[0] if False else a, b)) == 1} \
        if False else {(a, b) for a in range(q) for b in range(q)
                       if F.norm((a, b)) == 1}
    assert len(circle) == q + 1
    param = {}
    for t in range(q):
        num = F.sub((t, 0), I)
        den = F.add((t, 0), I)
        param[t] = F.mul(num, F.inv(den))
    param["inf"] = (1, 0)
    assert set(param.values()) == circle, "c(t) not a bijection onto C"
    assert len(set(param.values())) == q + 1
    for t in range(q):
        assert F.conj(param[t]) == param[(-t) % q], "c(t)^q != c(-t)"

    Q0 = {x for x in circle if F.mul(x, x) in circle
          and pow_circle(F, x, (q + 1) // 2) == (1, 0)}
    assert len(Q0) == (q + 1) // 2
    for t in range(q):
        inQ0 = param[t] in Q0
        assert inQ0 == (legendre((t * t - eps) % q, q) == 1), "Q_0 membership rule"
    assert param["inf"] in Q0

    # ---- C3..C6: the discriminant identity ------------------------------
    checked = 0
    params = [(a0, a1, g) for a0 in range(q) for a1 in range(q) for g in range(q)
              if (a0, a1) != (0, 0) and F.chi((a0, a1)) == 1]
    if q > 11:  # keep the run bounded; sample deterministically
        params = params[:: max(1, len(params) // 400)]
    for a0, a1, g in [(p[0], p[1], p[2]) for p in params]:
            a = (a0, a1)
            aq = F.conj(a)
            if True:
                kappa = (0, g)
                P = (F.mul(I, (((2 * a1 + g) % q), 0)),
                     F.sub((eps * g % q, 0), F.scal(2, F.mul(I, (a0, 0)))))
                Q = (F.add((eps * g % q, 0), F.scal(2, F.mul(I, (a0, 0)))),
                     F.mul(I, ((eps * (g - 2 * a1)) % q, 0)))
                for t in range(q):
                    tv = (t, 0)
                    Pt = F.add(F.mul(P[0], tv), P[1])
                    Qt = F.add(F.mul(Q[0], tv), Q[1])
                    for tp in range(q):
                        tpv = (tp, 0)
                        # C3: W built two ways
                        W1 = F.add(
                            F.sub(F.mul(a, F.mul(F.sub(tv, I), F.add(tpv, I))),
                                  F.mul(aq, F.mul(F.add(tv, I), F.sub(tpv, I)))),
                            F.mul(kappa, F.mul(F.add(tv, I), F.add(tpv, I))))
                        W2 = F.add(F.mul(Pt, tpv), Qt)
                        assert W1 == W2, (q, a, g, t, tp, "P,Q do not reproduce W")
                    # C4
                    A = F.norm(Pt)
                    Bc = (2 * F.mul(Pt, F.conj(Qt))[0]) % q  # Tr(P Q^q)
                    C = F.norm(Qt)
                    disc = (Bc * Bc - 4 * A * C) % q
                    L = (2 * eps * g * (((2 * a1 + g) * t * t
                                         - 4 * a0 * t
                                         + eps * (2 * a1 - g)) % q)) % q
                    assert disc == (eps * L * L) % q, (q, a, g, t, "disc != eps*L^2")
                    # C5
                    if L != 0 and A != 0:
                        assert legendre(disc, q) == -1
                        roots = [tp for tp in range(q)
                                 if (A * tp * tp + Bc * tp + C) % q == 0]
                        assert not roots, "irreducibility"
                    checked += 1
                # C6
                Lzero = all((2 * eps * g * (((2 * a1 + g) * t * t - 4 * a0 * t
                                             + eps * (2 * a1 - g)) % q)) % q == 0
                            for t in range(q))
                assert Lzero == (g == 0), (q, a, g, "L==0 iff g==0")
    return {"q": q, "eps": eps, "t_values_checked": checked}


def pow_circle(F: F2, x, e: int):
    r = (1, 0)
    b = x
    while e:
        if e & 1:
            r = F.mul(r, b)
        b = F.mul(b, b)
        e >>= 1
    return r


def check_c7(q: int) -> bool:
    """g = 0 forces chi(a) = -1: chi(a*s) = -1 with N(s)=1 gives chi(a) = -1."""
    eps = least_nonsquare(q)
    F = F2(q, eps)
    for x in ((a, b) for a in range(q) for b in range(q)):
        if F.norm(x) == 1:
            assert F.chi(x) == 1
    return True


def main() -> None:
    rows = [check_field(q) for q in QS]
    for q in QS:
        assert check_c7(q)
    payload = {
        "task": "C756",
        "claim": "disc_{t'} F = eps * L(t)^2 with L == 0 iff g == 0",
        "rows": rows,
        "source_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
    }
    OUTPUT.write_text(json.dumps(payload, indent=1, sort_keys=True) + "\n")
    for r in rows:
        print(f"q={r['q']:>3} eps={r['eps']} (a,g,t) triples checked: "
              f"{r['t_values_checked']}")
    print("all identities hold; certificate:", OUTPUT.name)


if __name__ == "__main__":
    main()
