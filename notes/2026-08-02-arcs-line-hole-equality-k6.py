"""Zero-defect line-hole (complete affine) k-arcs.

Corollary "Complete affine arcs" of the arcs manuscript says: for even k>=6,
equality in the line-hole defect bound forces q in {k-2, binom(k-1,2)+1}.
For k=6 that is q in {4, 11}.  This script searches both orders exhaustively
up to affine equivalence (normalize three arc points to an affine frame).

Zero defect at a line hole is equivalent to:
  * A is a k-arc in AG(2,q),
  * every affine point off A lies on a secant (affine completeness),
  * the 15 secants fall into exactly k-1 parallel classes (each of size m=k/2),
    i.e. A is hyperfocused on the line at infinity.
"""

from itertools import combinations


def run(q, k=6):
    pts = [(x, y) for x in range(q) for y in range(q)]
    idx = {p: i for i, p in enumerate(pts)}

    def col(a, b, c):
        return ((b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0])) % q == 0

    def direction(a, b):
        dx = (b[0] - a[0]) % q
        dy = (b[1] - a[1]) % q
        if dx == 0:
            return ('v',)
        inv = pow(dx, q - 2, q)
        return ('s', (dy * inv) % q)

    frame = [(0, 0), (1, 0), (0, 1)]
    rest = [p for p in pts if p not in frame]
    m = k // 2
    found = []
    hyperfocused_only = 0
    complete_only = 0

    for extra in combinations(rest, k - 3):
        A = frame + list(extra)
        ok = True
        for a, b, c in combinations(A, 3):
            if col(a, b, c):
                ok = False
                break
        if not ok:
            continue

        dirs = {}
        for a, b in combinations(A, 2):
            dirs.setdefault(direction(a, b), []).append((a, b))
        hyper = len(dirs) == k - 1 and all(len(v) == m for v in dirs.values())

        covered = set(idx[p] for p in A)
        for a, b in combinations(A, 2):
            dx = (b[0] - a[0]) % q
            dy = (b[1] - a[1]) % q
            for t in range(q):
                covered.add(idx[((a[0] + t * dx) % q, (a[1] + t * dy) % q)])
        complete = len(covered) == q * q

        if hyper and complete:
            found.append(A)
        elif hyper:
            hyperfocused_only += 1
        elif complete:
            complete_only += 1

    print(f"q={q} k={k}: zero-defect line-hole arcs found: {len(found)}")
    print(f"  hyperfocused but not affinely complete: {hyperfocused_only}")
    print(f"  affinely complete but not hyperfocused: {complete_only}")
    if found:
        print(f"  example: {found[0]}")


# q = 4 is the hyperoval branch k = q + 2 and needs GF(4) rather than Z/q;
# it is realized by any hyperoval of PG(2,4) with an external line at infinity.
run(11)
