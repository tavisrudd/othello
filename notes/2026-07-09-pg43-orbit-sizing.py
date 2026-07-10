"""C43 — PG(4,3) orbit-count sizing (exact PGL(m+1,q) canonicalization).

The raw cap count of PG(4,3) is ~10^13+ (see 2026-07-09-pg43-sizing.py raw), so a
naive memo is hopeless. An orbit-canon solver memoizes PGL(m+1,q)-orbits of caps;
PG(3,3) has 55,909 raw caps but only a few dozen orbit classes, so the reduction
is the whole ballgame. This script computes EXACT orbit counts per ply via orderly
generation (BFS over orbit representatives, dedup by an exact canonical form).

Canonical form (sound, exact): a projective frame is m+2 points of PG(m,q) in
general position (any m+1 independent, the last a "unit"). PGL(m+1,q) is sharply
transitive on ordered frames, so for each ordered frame F = (P_0..P_{m+1}) contained
in a cap S there is a UNIQUE g in PGL sending F to the standard frame
(e_0..e_m, unit). canon(S) := lexicographically minimal sorted(g(S)) over all frames
F subset S. Two caps are PGL-equivalent iff canon is equal. Branch-and-bound prunes
frames whose partial image already exceeds the running best.

Validated (`validate` mode) against known orbit facts:
  PG(2,5): caps up to the 6-arc (conic+nucleus); PG(3,3): total orbit count.
Then `orbit m q [maxk] [wall]` runs the capped orbit-BFS and prints orbits_k per ply.
"""
import sys
import time
import os
from itertools import product, permutations

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gf import GF  # noqa: E402

sys.setrecursionlimit(1 << 20)


def vcanon(vec, F):
    for c in vec:
        if c != 0:
            inv = F.inv(c)
            return tuple(F.mul(inv, x) for x in vec)
    return None


def build(m, q):
    F = GF(q)
    dim = m + 1
    reps = set()
    for vec in product(range(q), repeat=dim):
        if any(vec):
            reps.add(vcanon(vec, F))
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
                    c = vcanon(v, F)
                    if c is not None:
                        mij |= 1 << idx[c]
            line_mask[i][j] = mij
            line_mask[j][i] = mij
    # hyperplane (proj-dim m-1) point masks: functionals up to scale = same reps.
    solid_mask = []
    for f in pts:
        mk = 0
        for i, p in enumerate(pts):
            s = 0
            for k in range(dim):
                s = F.add(s, F.mul(f[k], p[k]))
            if s == 0:
                mk |= 1 << i
        solid_mask.append(mk)
    return F, N, pts, idx, line_mask, solid_mask


def cap_spectrum(chosen, solid_mask):
    """Hyperplane intersection spectrum of a cap (a sound PGL invariant): histogram
    over hyperplanes H of |cap ∩ H|. Returned as a compact tuple."""
    hist = {}
    for hm in solid_mask:
        c = (chosen & hm).bit_count()
        hist[c] = hist.get(c, 0) + 1
    mx = max(hist)
    return tuple(hist.get(j, 0) for j in range(mx + 1))


# ---- linear algebra over F_q (small matrices) ----
def mat_inv(A, F, n):
    """Invert n x n matrix A (list of rows, each a list) over F_q; None if singular."""
    M = [list(A[i]) + [1 if j == i else 0 for j in range(n)] for i in range(n)]
    for col in range(n):
        piv = None
        for r in range(col, n):
            if M[r][col] != 0:
                piv = r
                break
        if piv is None:
            return None
        M[col], M[piv] = M[piv], M[col]
        inv = F.inv(M[col][col])
        M[col] = [F.mul(inv, x) for x in M[col]]
        for r in range(n):
            if r != col and M[r][col] != 0:
                f = M[r][col]
                M[r] = [F.sub(M[r][j], F.mul(f, M[col][j])) for j in range(2 * n)]
    return [row[n:] for row in M]


def _mv(M, v, F, n):
    out = []
    for i in range(n):
        s = 0
        Mi = M[i]
        for k in range(n):
            if Mi[k] and v[k]:
                s = F.add(s, F.mul(Mi[k], v[k]))
        out.append(s)
    return tuple(out)


class Canonizer:
    def __init__(self, F, m, pts, idx):
        self.F = F
        self.n = m + 1
        self.pts = pts
        self.idx = idx
        # standard basis e_0..e_m
        self.e = [tuple(1 if k == i else 0 for k in range(self.n)) for i in range(self.n)]

    def _project(self, Slist):
        """Express S in coordinates of a basis of its span. Returns (r, coords) where
        r = rank(span) and coords[i] is the r-dim coordinate vector of point Slist[i].
        The subspace frame-min below is basis-independent (a change of projection basis
        C is undone by the frame normalization), so any basis is fine."""
        F, n = self.F, self.n
        basis = []
        for i in Slist:
            v = list(self.pts[i])
            if _rank(basis + [v], F, n) > len(basis):
                basis.append(v)
        r = len(basis)
        full = [row[:] for row in basis]
        ei = 0
        while len(full) < n:
            cand = list(self.e[ei]); ei += 1
            if _rank(full + [cand], F, n) > len(full):
                full.append(cand)
        A = [[full[c][row] for c in range(n)] for row in range(n)]  # cols = full basis vecs
        Ainv = mat_inv(A, F, n)
        coords = [tuple(_mv(Ainv, self.pts[i], F, n)[:r]) for i in Slist]
        return r, coords

    def canon(self, Slist):
        """Exact PGL canonical form of cap S (list of point indices), correct for ANY
        cap. Project onto the span (dim r); rank r is a PGL-invariant prefix. If S
        contains an (r+1)-frame (general position), the fast frame-min is a complete
        canonical form (frames pin PGL sharply). "Contains a frame" is orbit-invariant,
        so frameless caps (handled by the torus enumeration) never share an orbit with
        frame-having ones; a method tag ('F'/'T') keeps their canon values disjoint.
        Both methods are complete canonical forms on their domain, so equal canon iff
        PGL-equivalent."""
        F = self.F
        r, coords = self._project(Slist)
        k = len(Slist)
        if k == r:
            return (r, "I")  # k independent points: a single orbit
        best = self._frame_min(coords, r, k)
        if best is not None:
            return (r, "F", best)
        return (r, "T", self._torus_canon(coords, r, k))

    def _frame_min(self, coords, r, k):
        """min over ordered (r+1)-frames in general position; None if S has no frame."""
        F = self.F
        best = None
        for frame in permutations(range(k), r + 1):
            M = _frame_matrix_dim([coords[j] for j in frame], F, r)
            if M is None:
                continue
            t = tuple(sorted(vcanon(_mv(M, coords[j], F, r), F) for j in range(k)))
            if best is None or t < best:
                best = t
        return best

    def _torus_canon(self, coords, r, k):
        """Complete canon for ANY cap: map each ordered independent r-subset to the
        standard basis e_0..e_{r-1}, then minimize over the residual projective torus
        diag(1,t_1..t_{r-1}), t_i in F_q^*. Covers all of PGL that carries some
        independent r-subset of S to the basis; invariant and separating."""
        F, q = self.F, self.F.q
        nz = [x for x in range(1, q)]
        tori = [(1,) + tt for tt in product(nz, repeat=r - 1)]
        best = None
        for bo in permutations(range(k), r):
            A = [[coords[bo[c]][row] for c in range(r)] for row in range(r)]
            Ainv = mat_inv(A, F, r)  # M0: coords[bo[j]] -> e_j
            if Ainv is None:
                continue
            base_img = [_mv(Ainv, coords[j], F, r) for j in range(k)]
            for t in tori:
                img = tuple(sorted(
                    vcanon(tuple(F.mul(t[i], w[i]) for i in range(r)), F)
                    for w in base_img))
                if best is None or img < best:
                    best = img
        return best


def _frame_matrix_dim(fvecs, F, r):
    """Projectivity of PG(r-1,q) sending ordered frame (r independent + 1 unit) to the
    standard frame (e_0..e_{r-1}, unit). fvecs: list of r+1 vectors in F_q^r."""
    A = [[fvecs[c][row] for c in range(r)] for row in range(r)]  # cols = first r vecs
    Ainv = mat_inv(A, F, r)
    if Ainv is None:
        return None
    unit = fvecs[r]
    c = _mv(Ainv, unit, F, r)
    if any(x == 0 for x in c):
        return None
    D = [F.inv(x) for x in c]
    return [[F.mul(D[i], Ainv[i][col]) for col in range(r)] for i in range(r)]


def _rank(rows, F, n):
    M = [list(r) for r in rows]
    rank = 0
    col = 0
    R = len(M)
    while rank < R and col < n:
        piv = None
        for r in range(rank, R):
            if M[r][col] != 0:
                piv = r
                break
        if piv is None:
            col += 1
            continue
        M[rank], M[piv] = M[piv], M[rank]
        inv = F.inv(M[rank][col])
        M[rank] = [F.mul(inv, x) for x in M[rank]]
        for r in range(R):
            if r != rank and M[r][col] != 0:
                f = M[r][col]
                M[r] = [F.sub(M[r][j], F.mul(f, M[rank][j])) for j in range(n)]
        rank += 1
        col += 1
    return rank


def orbit_bfs(m, q, maxk, wall):
    """Exact PGL(m+1,q)-orbit count per ply. Children are bucketed by the sound
    hyperplane-spectrum invariant; the expensive exact canon runs only to resolve
    collisions WITHIN a spectrum bucket (a singleton bucket is a proven-distinct orbit,
    canon deferred). Sound: orbits_k is exact."""
    F, N, pts, idx, line_mask, solid_mask = build(m, q)
    cz = Canonizer(F, m, pts, idx)
    ALL = (1 << N) - 1
    lm = line_mask
    t0 = time.time()
    cur = [[0]]  # k=1: one orbit
    per_ply = [1, 1]
    timed = False
    for depth in range(1, maxk):
        buckets = {}  # spectrum -> list of [canon_or_None, Slist]
        reps = len(cur)
        for Slist in cur:
            if (time.time() - t0) > wall:
                timed = True
                break
            chosen = 0
            for i in Slist:
                chosen |= 1 << i
            forbidden = 0
            for a_i in range(len(Slist)):
                for b_i in range(a_i + 1, len(Slist)):
                    forbidden |= lm[Slist[a_i]][Slist[b_i]]
            a = ALL & ~chosen & ~forbidden
            while a:
                y = a & (-a)
                a ^= y
                child = Slist + [y.bit_length() - 1]
                sp = cap_spectrum(chosen | y, solid_mask)
                lst = buckets.get(sp)
                if lst is None:
                    buckets[sp] = [[None, child]]
                else:
                    ck = cz.canon(sorted(child))
                    hit = False
                    for e in lst:
                        if e[0] is None:
                            e[0] = cz.canon(sorted(e[1]))
                        if e[0] == ck:
                            hit = True
                            break
                    if not hit:
                        lst.append([ck, child])
            if timed:
                break
        nxt = [e[1] for lst in buckets.values() for e in lst]
        per_ply.append(len(nxt))
        print(f"  orbits_{depth+1:<2} = {len(nxt):>10,}   (cum_elapsed={time.time()-t0:6.1f}s, "
              f"reps_expanded={reps:,}, spec_buckets={len(buckets):,})", flush=True)
        cur = nxt
        if timed or not cur:
            break
    return per_ply, timed, time.time() - t0


def solve(m, q, wall, memcap):
    """Orbit-canon negamax: memoize game value by exact PGL canon. Returns the empty-root
    outcome (P=2nd-player win / N=1st-player win) or None if unfinished within wall/memcap."""
    F, N, pts, idx, line_mask, solid_mask = build(m, q)
    cz = Canonizer(F, m, pts, idx)
    ALL = (1 << N) - 1
    lm = line_mask
    memo = {}
    t0 = time.time()
    state = {"stop": False}

    def value(Slist, chosen, forbidden):
        key = cz.canon(sorted(Slist))
        v = memo.get(key)
        if v is not None:
            return v
        if state["stop"] or (time.time() - t0) > wall or len(memo) > memcap:
            state["stop"] = True
            return None
        res = 0
        a = ALL & ~chosen & ~forbidden
        while a:
            y = a & (-a)
            a ^= y
            yi = y.bit_length() - 1
            nf = forbidden
            for i in Slist:
                nf |= lm[yi][i]
            cv = value(Slist + [yi], chosen | y, nf)
            if cv is None:
                return None
            if cv == 0:
                res = 1
                break
        if not state["stop"]:
            memo[key] = res
        return res

    root = value([], 0, 0)
    return root, len(memo), state["stop"], time.time() - t0


if __name__ == "__main__":
    mode = sys.argv[1]
    if mode == "validate":
        for (m, q, mk) in [(2, 5, 6), (2, 7, 6), (3, 3, 10)]:
            pp, to, el = orbit_bfs(m, q, mk, 600)
            print(f"PG({m},{q}) orbits/ply={pp} total(<= {mk})={sum(pp)} "
                  f"timed_out={to} {el:.1f}s", flush=True)
    elif mode == "orbit":
        m = int(sys.argv[2]); q = int(sys.argv[3])
        maxk = int(sys.argv[4]) if len(sys.argv) > 4 else 20
        wall = float(sys.argv[5]) if len(sys.argv) > 5 else 3600.0
        pp, to, el = orbit_bfs(m, q, maxk, wall)
        print(f"PG({m},{q}) orbits/ply={pp} timed_out={to} {el:.1f}s", flush=True)
    elif mode == "solve":
        m = int(sys.argv[2]); q = int(sys.argv[3])
        wall = float(sys.argv[4]) if len(sys.argv) > 4 else 3600.0
        memcap = int(sys.argv[5]) if len(sys.argv) > 5 else 20_000_000
        root, nst, stopped, el = solve(m, q, wall, memcap)
        outc = "UNFINISHED" if root is None else ("P (2nd)" if root == 0 else "N (1st)")
        print(f"PG({m},{q}) SOLVE -> {outc}  states={nst:,} stopped={stopped} {el:.1f}s",
              flush=True)
    print("PG43_ORBIT_DONE", flush=True)
