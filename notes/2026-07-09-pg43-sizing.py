"""C43 — PG(4,3) exact-solve sizing probe.

Question (task C43): PG(2m,q), m>=2, odd q has ZERO direct outcome evidence.
PG(4,3) is the smallest instance: 121 points, 1210 lines (q+1=4 pts/line),
max cap 20 (known), |PGL(5,3)| ~ 2.4e11. Is an exact cap-game solve tractable?

The game state that must be memoized is `chosen` (a cap). Every subset of a cap
is a cap, so EVERY cap of PG(4,3) is a reachable state; the state space is the
set of all caps, sizes 0..20, and caps_k = #caps of size exactly k is the raw
growth curve (distinct states per ply). This probe measures:

  raw    : exact caps_k per ply via ordered-augmentation DFS counting (no storage),
           until a wall-clock cap. This is the true raw state count per ply.
  spec   : symmetry-reduced growth using a SOUND PGL(5,3)-invariant fingerprint
           (the hyperplane/solid intersection SPECTRUM, optionally + plane spectrum).
           #distinct fingerprints per ply is a LOWER BOUND on the #PGL-orbits per ply
           (distinct invariant => distinct orbit; collisions only undercount).
           => the reduction factor caps_k / distinct_spec_k lower-bounds how much a
           sound orbit-canon solver would collapse ply k.

Everything here is SIZING, not a proof: the spectrum fingerprint is not a complete
orbit invariant, so the reduced counts are lower bounds and the merged-value solve
would be UNSOUND for a verdict. See report notes/2026-07-09-codex-pg43-sizing.md.
"""
import sys
import time
import os
from itertools import product

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gf import GF  # noqa: E402

sys.setrecursionlimit(1 << 20)


def canon(vec, F):
    for c in vec:
        if c != 0:
            inv = F.inv(c)
            return tuple(F.mul(inv, x) for x in vec)
    return None


def build(m, q):
    """(N, pts, idx, line_mask, solid_mask, plane_mask) for PG(m,q).

    solid_mask[h] = bitmask of points on hyperplane (proj-dim m-1 flat) h.
    plane_mask[p] = bitmask of points on each proj-dim (m-2) flat (only built for m>=3).
    """
    F = GF(q)
    dim = m + 1
    reps = set()
    for vec in product(range(q), repeat=dim):
        if any(vec):
            reps.add(canon(vec, F))
    pts = sorted(reps)
    idx = {p: i for i, p in enumerate(pts)}
    N = len(pts)

    line_mask = [[0] * N for _ in range(N)]
    for i in range(N):
        P = pts[i]
        for j in range(i + 1, N):
            Q = pts[j]
            mij = 0
            for a in range(q):
                for b in range(q):
                    if a == 0 and b == 0:
                        continue
                    v = tuple(F.add(F.mul(a, P[k]), F.mul(b, Q[k])) for k in range(dim))
                    c = canon(v, F)
                    if c is not None:
                        mij |= 1 << idx[c]
            line_mask[i][j] = mij
            line_mask[j][i] = mij

    # Hyperplanes (proj-dim m-1): functionals up to scale = same rep set as points.
    # H_f = { p : f . p == 0 }.
    funcs = pts  # dual has the same canonical reps
    solid_mask = []
    for f in funcs:
        mk = 0
        for i, p in enumerate(pts):
            s = 0
            for k in range(dim):
                s = F.add(s, F.mul(f[k], p[k]))
            if s == 0:
                mk |= 1 << i
        solid_mask.append(mk)

    return N, pts, idx, line_mask, solid_mask


def validate(N, q, line_mask, solid_mask):
    lines = set()
    for i in range(N):
        for j in range(i + 1, N):
            lm = line_mask[i][j]
            assert (lm >> i) & 1 and (lm >> j) & 1
            assert bin(lm).count("1") == q + 1
            lines.add(lm)
    exp_lines = N * (N - 1) // (q * (q + 1))
    assert len(lines) == exp_lines, (len(lines), exp_lines)
    return len(lines)


def raw_growth(N, line_mask, maxk, wall):
    """Exact caps_k per ply by ordered augmentation (add only higher-index points).

    Visits each cap once, O(depth) memory. Returns (counts, reached_k, timed_out).
    """
    counts = [0] * (maxk + 1)
    counts[0] = 1
    lm = line_mask
    ALL = (1 << N) - 1
    t0 = time.time()
    state = {"timeout": False}

    # forbidden(S) carried incrementally; avail = higher-index, not chosen, not forbidden
    def rec(chosen, forbidden, hi, depth):
        if depth == maxk or state["timeout"]:
            return
        if (time.time() - t0) > wall:
            state["timeout"] = True
            return
        avail = ALL & ~chosen & ~forbidden
        # restrict to indices > hi
        avail &= ~((1 << (hi + 1)) - 1)
        a = avail
        while a:
            y = a & (-a)
            a ^= y
            yi = y.bit_length() - 1
            nf = forbidden
            c = chosen
            while c:
                b = c & (-c)
                c ^= b
                nf |= lm[yi][b.bit_length() - 1]
            counts[depth + 1] += 1
            rec(chosen | y, nf, yi, depth + 1)

    rec(0, 0, -1, 0)
    reached = maxk if not state["timeout"] else max(k for k in range(maxk + 1) if counts[k] or k == 0)
    return counts, reached, state["timeout"]


def spec_fp(chosen, solid_mask):
    """Hyperplane(solid) intersection spectrum: histogram over hyperplanes of
    |chosen & H|. Sound PGL-invariant. Returns a small tuple (hist[j] for j=0..)."""
    hist = {}
    for hm in solid_mask:
        c = (chosen & hm).bit_count()
        hist[c] = hist.get(c, 0) + 1
    mx = max(hist)
    return tuple(hist.get(j, 0) for j in range(mx + 1))


def spec_growth(N, line_mask, solid_mask, maxk, wall, memcap):
    """Symmetry-reduced growth by SOUND spectrum fingerprint (lower-bounds orbits).

    BFS by ply: keep one representative cap per distinct fingerprint, expand all of
    them, canonicalize children, dedupe. #distinct fp per ply is a lower bound on
    #orbits per ply (see module docstring). memcap bounds total reps held.
    """
    lm = line_mask
    ALL = (1 << N) - 1
    t0 = time.time()
    # level 0
    cur = {(): (0, 0)}  # fp -> (chosen, forbidden)  (empty cap fp = ())
    per_ply = [1]
    timed = False
    for depth in range(maxk):
        nxt = {}
        for fp, (chosen, forbidden) in cur.items():
            if (time.time() - t0) > wall:
                timed = True
                break
            avail = ALL & ~chosen & ~forbidden
            a = avail
            while a:
                y = a & (-a)
                a ^= y
                yi = y.bit_length() - 1
                nf = forbidden
                c = chosen
                while c:
                    b = c & (-c)
                    c ^= b
                    nf |= lm[yi][b.bit_length() - 1]
                nc = chosen | y
                f = spec_fp(nc, solid_mask)
                if f not in nxt:
                    nxt[f] = (nc, nf)
            if len(nxt) > memcap:
                timed = True
                break
        per_ply.append(len(nxt))
        cur = nxt
        if timed or not cur:
            break
    return per_ply, timed, (time.time() - t0)


if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "facts"
    m, q = 4, 3
    t0 = time.time()
    N, pts, idx, line_mask, solid_mask = build(m, q)
    nlines = validate(N, q, line_mask, solid_mask)
    print(f"[build] PG({m},{q}) N={N} lines={nlines} solids={len(solid_mask)} "
          f"build_s={time.time()-t0:.1f}", flush=True)

    if mode == "facts":
        # sanity: hyperplane point count = (q^m-1)/(q-1)
        hp_pts = (q ** m - 1) // (q - 1)
        sizes = sorted(set(bin(h).count('1') for h in solid_mask))
        print(f"[facts] hyperplane point counts seen = {sizes} (expect [{hp_pts}])")
    elif mode == "raw":
        maxk = int(sys.argv[2]) if len(sys.argv) > 2 else 6
        wall = float(sys.argv[3]) if len(sys.argv) > 3 else 300.0
        counts, reached, to = raw_growth(N, line_mask, maxk, wall)
        print(f"[raw] wall={wall}s timed_out={to}")
        cum = 0
        for k, c in enumerate(counts):
            cum += c
            print(f"  caps_{k:<2} = {c:>15,}   cum={cum:>15,}")
    elif mode == "spec":
        maxk = int(sys.argv[2]) if len(sys.argv) > 2 else 20
        wall = float(sys.argv[3]) if len(sys.argv) > 3 else 600.0
        memcap = int(sys.argv[4]) if len(sys.argv) > 4 else 3_000_000
        per_ply, to, el = spec_growth(N, line_mask, solid_mask, maxk, wall, memcap)
        print(f"[spec] wall={wall}s memcap={memcap:,} timed_out={to} elapsed={el:.1f}s")
        for k, c in enumerate(per_ply):
            print(f"  spec_orbits_lb_{k:<2} = {c:>12,}")
    print("PG43_SIZING_DONE", flush=True)
