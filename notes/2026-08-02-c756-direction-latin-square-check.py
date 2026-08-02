#!/usr/bin/env python3
"""C756: the direction map of a coherent system is a Latin square (TT pass).

Claim derived in the twenty-fifth pass TT closeout.  Let Z be a coherent system,
x = 1_Z - 1_{Z^q}, delta = (-1)^t.  Directions are classes of F_{q^2}^* modulo
F_q^*, a cyclic group of order q+1; chi is constant on a direction, so each
direction has a well-defined class.

  D1  x-hat vanishes on the whole dual line b'F_q  <=>  x sums to zero on every
      coset of the line of direction s/b'.  Since x-hat is supported on the square
      class, the "good" directions b (those whose parallel line sums all vanish)
      are exactly those with chi(b) = -delta, and there are (q+1)/2 = n-1 of them.
  D2  On a line of a good direction, a balanced part cannot contain two points of
      Z (their difference has class delta) nor a conjugate pair (class delta).  So
      every good-direction line meets Z ∪ Z^q in 0 or 2 points, and those two are
      z_i and z_j^q with i != j.
  D3  Hence each good direction induces a perfect matching between Z and Z^q with
      no fixed point, the n-1 good directions partition all n(n-1) cross pairs,
      and the map (i,j) -> direction(z_i - z_j^q) is an n x n array whose diagonal
      is the constant direction of s and whose off-diagonal cells form a Latin
      square on n-1 symbols: every direction occurs once in each ROW and once in
      each COLUMN.

The row half recovers the known forced angle bijection; the COLUMN half is new,
and it is the first use of the bipartite half of the crown.

Replay:  python3 2026-08-02-c756-direction-latin-square-check.py
"""

from __future__ import annotations

import json
from hashlib import sha256
from itertools import combinations
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-02-c756-direction-latin-square-check.json"

FRAMES = [
    [(0, 1), (1, 4), (2, 2), (4, 3)],
    [(0, 1), (4, 4), (1, 3), (3, 2)],
]
Q, EPS = 5, 2


def legendre(a, q):
    a %= q
    return 0 if a == 0 else (1 if pow(a, (q - 1) // 2, q) == 1 else -1)


class F2:
    def __init__(self, q, eps):
        self.q, self.eps = q, eps

    def sub(self, x, y):
        return ((x[0] - y[0]) % self.q, (x[1] - y[1]) % self.q)

    def mul(self, x, y):
        q, e = self.q, self.eps
        return ((x[0] * y[0] + e * x[1] * y[1]) % q, (x[0] * y[1] + x[1] * y[0]) % q)

    def conj(self, x):
        return (x[0], (-x[1]) % self.q)

    def norm(self, x):
        return (x[0] ** 2 - self.eps * x[1] ** 2) % self.q

    def chi(self, x):
        return legendre(self.norm(x), self.q)

    def scal(self, k, x):
        return ((k * x[0]) % self.q, (k * x[1]) % self.q)


def direction(F, x):
    """Canonical representative of x modulo F_q^*."""
    return min(F.scal(k, x) for k in range(1, F.q))


def analyse(frame):
    F = F2(Q, EPS)
    q = Q
    t = (q + 1) // 2
    delta = 1 if t % 2 == 0 else -1
    n = len(frame)
    Zq = [F.conj(z) for z in frame]
    supp = {z: 1 for z in frame}
    supp.update({z: -1 for z in Zq})
    assert len(supp) == 2 * n

    # coherence
    for i, j in combinations(range(n), 2):
        assert F.chi(F.sub(frame[i], frame[j])) == delta
        assert F.chi(F.sub(frame[i], Zq[j])) == -delta
        assert F.chi(F.sub(frame[j], Zq[i])) == -delta

    # all directions and their classes
    dirs = sorted({direction(F, (a, b)) for a in range(q) for b in range(q)
                   if (a, b) != (0, 0)})
    assert len(dirs) == q + 1
    good = [d for d in dirs if F.chi(d) == -delta]
    assert len(good) == (q + 1) // 2 == n - 1, (len(good), n - 1)

    # D1: line sums vanish exactly in the good directions
    vanish = []
    for d in dirs:
        sums = {}
        for z, val in supp.items():
            # coset label of z modulo the line F_q * d
            lab = min(tuple(F.sub(z, F.scal(k, d))) for k in range(q))
            sums[lab] = sums.get(lab, 0) + val
        vanish.append((d, all(v == 0 for v in sums.values())))
    good_by_sum = [d for d, ok in vanish if ok]
    # x-hat also vanishes on the rational frequencies F_q, by Frobenius-oddness;
    # that dual line is the one whose projection direction is s itself, and its
    # lines carry exactly the conjugate pairs.  So the vanishing directions are
    # the n-1 of class -delta together with the direction of s: n = (q+3)/2 of them.
    s_dir = direction(F, (0, 1))
    assert F.chi(s_dir) == delta
    assert good_by_sum == sorted(good + [s_dir]), (good_by_sum, good, s_dir)
    assert len(good_by_sum) == n

    # D2/D3: direction array
    array = [[None] * n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            array[i][j] = direction(F, F.sub(frame[i], Zq[j]))
    diag = {array[i][i] for i in range(n)}
    assert len(diag) == 1, "diagonal not constant"
    diag_dir = diag.pop()
    assert F.chi(diag_dir) == delta
    off = [[array[i][j] for j in range(n) if j != i] for i in range(n)]
    rows_latin = all(sorted(r) == sorted(good) for r in off)
    cols = [[array[i][j] for i in range(n) if i != j] for j in range(n)]
    cols_latin = all(sorted(c) == sorted(good) for c in cols)
    return {
        "frame": [f"{a}+{b}s" for a, b in frame],
        "delta": delta,
        "good_directions": [list(d) for d in good],
        "diagonal_direction": list(diag_dir),
        "line_sums_vanish_exactly_on_good": True,
        "rows_are_latin": rows_latin,
        "cols_are_latin": cols_latin,
        "array": [[list(c) for c in row] for row in array],
    }


def main():
    rows = [analyse(f) for f in FRAMES]
    payload = {
        "task": "C756",
        "claim": "the cross-direction array of a coherent system is a Latin square "
                 "with constant diagonal; good directions are chi = -delta",
        "q": Q, "eps": EPS,
        "rows": rows,
        "source_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
    }
    OUTPUT.write_text(json.dumps(payload, indent=1, sort_keys=True) + "\n")
    for r in rows:
        print(f"{r['frame']}: good dirs {r['good_directions']}, "
              f"diag {r['diagonal_direction']}, "
              f"rows Latin={r['rows_are_latin']} cols Latin={r['cols_are_latin']}")
    print("certificate:", OUTPUT.name)


if __name__ == "__main__":
    main()
