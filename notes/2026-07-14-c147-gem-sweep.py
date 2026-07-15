#!/usr/bin/env python3
"""
Audit computations for the gem-mining strategy note (2026-07-14).

For odd prime q, fixed conic C: XZ = Y^2 in PG(2,q):
  * verifies pencil counts (external/internal points vs external lines through them);
  * builds E_q = graph on the q^2 off-conic points, adjacent iff joining line is
    external to C;
  * checks (bi)regularity of E_q and SRG-ness of the type-restricted subgraphs;
  * enumerates ALL arc-cliques of E_q containing a fixed representative point
    (one internal rep + one external rep; PGL2(q) = Stab(C) is transitive on each
    type, so every arc-clique class is met) -- an arc-clique = point set, no 3
    collinear, all joining lines external to C;
  * reports omega_arc(E_q) = max arc-clique size, and all "healthy" arcs:
    arc-cliques whose secants cover every off-conic point outside the arc
    (equivalently: deep-hole locus U = the full conic);
  * canonicalizes healthy arcs / size-6 arc-cliques under Stab(C) and reports
    class data (type profile, |U|, stabilizer order).

Usage: python3 gem_sweep.py q [q ...] [--collect6] [--limit N]
"""
import sys, time
from collections import Counter

sys.setrecursionlimit(100000)


def build(q):
    pts = []
    for y in range(q):
        for z in range(q):
            pts.append((1, y, z))
    for z in range(q):
        pts.append((0, 1, z))
    pts.append((0, 0, 1))
    idx = {p: i for i, p in enumerate(pts)}
    N = len(pts)
    assert N == q * q + q + 1

    def norm(x, y, z):
        x %= q; y %= q; z %= q
        if x:
            iv = pow(x, q - 2, q)
            return (1, y * iv % q, z * iv % q)
        if y:
            iv = pow(y, q - 2, q)
            return (0, 1, z * iv % q)
        return (0, 0, 1)

    def cross(a, b):
        return norm(a[1] * b[2] - a[2] * b[1],
                    a[2] * b[0] - a[0] * b[2],
                    a[0] * b[1] - a[1] * b[0])

    # incidence (lines share the rep list with points)
    line_pts = [[] for _ in range(N)]
    pt_lines = [[] for _ in range(N)]
    for L, l in enumerate(pts):
        for P, p in enumerate(pts):
            if (l[0] * p[0] + l[1] * p[1] + l[2] * p[2]) % q == 0:
                line_pts[L].append(P)
                pt_lines[P].append(L)
    for L in range(N):
        assert len(line_pts[L]) == q + 1

    conic = frozenset(P for P, p in enumerate(pts) if (p[0] * p[2] - p[1] * p[1]) % q == 0)
    assert len(conic) == q + 1
    ltype = [sum(1 for P in line_pts[L] if P in conic) for L in range(N)]  # 0 ext / 1 tan / 2 sec

    off = [P for P in range(N) if P not in conic]
    assert len(off) == q * q
    pos = {P: i for i, P in enumerate(off)}
    ptype = {}
    for P in off:
        t = sum(1 for L in pt_lines[P] if ltype[L] == 1)
        assert t in (0, 2)
        ptype[P] = 'ext' if t == 2 else 'int'
    n_int = sum(1 for P in off if ptype[P] == 'int')
    n_ext = len(off) - n_int
    assert n_int == q * (q - 1) // 2 and n_ext == q * (q + 1) // 2

    # pencil counts
    pencil = {}
    for P in off[:]:
        e = sum(1 for L in pt_lines[P] if ltype[L] == 0)
        pencil.setdefault(ptype[P], set()).add(e)

    # adjacency and pair->external-line masks (only external-line pairs are adjacent)
    noff = len(off)
    adj = [0] * noff
    lmask = {}
    pairline = {}
    for L in range(N):
        if ltype[L] != 0:
            continue
        ps = [pos[P] for P in line_pts[L]]  # all q+1 points are off-conic
        m = 0
        for i in ps:
            m |= 1 << i
        lmask[L] = m
        for a in range(len(ps)):
            for b in range(a + 1, len(ps)):
                i, j = ps[a], ps[b]
                if i > j:
                    i, j = j, i
                adj[i] |= 1 << j
                adj[j] |= 1 << i
                pairline[(i, j)] = L
    return dict(q=q, pts=pts, idx=idx, N=N, norm=norm, cross=cross,
                line_pts=line_pts, pt_lines=pt_lines, conic=conic, ltype=ltype,
                off=off, pos=pos, ptype=ptype, pencil=pencil, adj=adj,
                lmask=lmask, pairline=pairline, noff=noff)


def n_min(q):
    n = 3
    while n * (n - 1) * (q - 1) // 2 < q * q - n:
        n += 1
    return n


def conic_group_perms(B):
    """All of Stab(conic) = Sym^2 PGL2(q) as permutations of point indices."""
    q = B['q']; idx = B['idx']; pts = B['pts']; norm = B['norm']
    mats = []
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q == 0:
                        continue
                    v = (a, b, c, d)
                    fn = next(x for x in v if x)
                    if fn != 1:
                        continue
                    mats.append(v)
    assert len(mats) == q ** 3 - q, len(mats)
    perms = []
    conic = B['conic']
    for (a, b, c, d) in mats:
        S = ((a * a, 2 * a * b, b * b),
             (a * c, a * d + b * c, b * d),
             (c * c, 2 * c * d, d * d))
        perm = [0] * B['N']
        for P, p in enumerate(pts):
            x = S[0][0] * p[0] + S[0][1] * p[1] + S[0][2] * p[2]
            y = S[1][0] * p[0] + S[1][1] * p[1] + S[1][2] * p[2]
            z = S[2][0] * p[0] + S[2][1] * p[1] + S[2][2] * p[2]
            perm[P] = idx[norm(x, y, z)]
        perms.append(perm)
    # sanity: conic preserved by first few
    for perm in perms[:5]:
        assert frozenset(perm[P] for P in conic) == conic
    return perms


def canonical(setpts, perms):
    return min(tuple(sorted(perm[P] for P in setpts)) for perm in perms)


def stab_order(setpts, perms):
    s = frozenset(setpts)
    return sum(1 for perm in perms if frozenset(perm[P] for P in s) == s)


def sweep(q, node_limit=None, collect6=False):
    t0 = time.time()
    B = build(q)
    nm = n_min(q)
    noff = B['noff']; off = B['off']; adj = B['adj']
    pairline = B['pairline']; lmask = B['lmask']; ptype = B['ptype']
    ALL = (1 << noff) - 1
    print(f"q={q}: off-conic {noff} (int {q*(q-1)//2} / ext {q*(q+1)//2}), "
          f"pencil counts {dict((k, sorted(v)) for k, v in B['pencil'].items())}, "
          f"n_min={nm}, all-internal ceiling (q+3)/2={(q+3)//2}, "
          f"ext-point ceiling (q+1)/2={(q+1)//2}")

    # E_q degrees
    degs = {}
    for i, P in enumerate(off):
        degs.setdefault(ptype[P], set()).add(adj[i].bit_count())
    print(f"  E_q degrees by type: {dict((k, sorted(v)) for k, v in degs.items())}"
          f"  (predicted int q(q+1)/2={q*(q+1)//2}, ext q(q-1)/2={q*(q-1)//2})")

    reps = []
    for want in ('int', 'ext'):
        i = next(i for i, P in enumerate(off) if ptype[P] == want)
        reps.append(i)

    res = dict(nodes=0, omega=0, healthy=[], six=[], complete=True)
    gt = [~((1 << (v + 1)) - 1) for v in range(noff)]

    def dfs(chosen, cmask, cand, covered):
        res['nodes'] += 1
        if node_limit and res['nodes'] > node_limit:
            res['complete'] = False
            return
        n = len(chosen)
        if n > res['omega']:
            res['omega'] = n
        if n >= nm and (covered | cmask) == ALL:
            res['healthy'].append(tuple(chosen))
        if collect6 and n == 6:
            unc = (ALL & ~(covered | cmask)).bit_count()
            res['six'].append((tuple(chosen), unc))
        c = cand
        while c:
            b = c & -c
            v = b.bit_length() - 1
            c ^= b
            lm = 0
            for a in chosen:
                i, j = (a, v) if a < v else (v, a)
                lm |= lmask[pairline[(i, j)]]
            chosen.append(v)
            dfs(chosen, cmask | b, cand & adj[v] & gt[v] & ~lm, covered | lm)
            chosen.pop()
            if not res['complete']:
                return

    for r in reps:
        dfs([r], 1 << r, adj[r], 0)
    dt = time.time() - t0
    print(f"  omega_arc(E_{q}) = {res['omega']}   nodes={res['nodes']}  "
          f"complete={res['complete']}  ({dt:.1f}s)")

    perms = None
    if res['healthy'] or (collect6 and res['six']):
        perms = conic_group_perms(B)

    if res['healthy']:
        classes = {}
        for ch in res['healthy']:
            spts = [off[i] for i in ch]
            classes.setdefault(canonical(spts, perms), []).append(spts)
        print(f"  HEALTHY arcs (U = full conic): {len(res['healthy'])} found, "
              f"{len(classes)} classes up to Stab(C):")
        for canon, members in classes.items():
            spts = members[0]
            prof = Counter(ptype[P] for P in spts)
            so = stab_order(spts, perms)
            coords = [B['pts'][P] for P in spts]
            print(f"    n={len(spts)} types={dict(prof)} |stab|={so} example={coords}")
    else:
        print(f"  HEALTHY arcs: NONE (exhaustive up to Stab(C))" if res['complete']
              else "  HEALTHY: none found but search INCOMPLETE")

    if collect6 and res['six']:
        cls = {}
        for ch, unc in res['six']:
            spts = [off[i] for i in ch]
            cls[canonical(spts, perms)] = (unc, spts)
        hist = Counter(unc for unc, _ in cls.values())
        print(f"  size-6 arc-clique classes (all secants external): {len(cls)}; "
              f"uncovered-count (=|U|-(q+1)) histogram over classes: {dict(sorted(hist.items()))}")
        stabs = Counter()
        shown = 0
        for canon, (unc, spts) in sorted(cls.items(), key=lambda kv: kv[1][0]):
            prof = Counter(ptype[P] for P in spts)
            so = stab_order(spts, perms)
            stabs[so] += 1
            if unc == 0 or shown < 12:
                print(f"    class: unc={unc} types={dict(prof)} |stab|={so}")
                shown += 1
        print(f"  |stab| histogram over size-6 classes: {dict(sorted(stabs.items()))}")
    sys.stdout.flush()
    return res


def srg_check(q):
    B = build(q)
    off = B['off']; ptype = B['ptype']; pairline_all = {}
    # need line type for EVERY pair, not just external
    idx = B['idx']; pts = B['pts']; cross = B['cross']; ltype = B['ltype']
    def linetype(P, Q):
        return ltype[idx[cross(pts[P], pts[Q])]]
    for tsel in ('int', 'ext'):
        V = [P for P in off if ptype[P] == tsel]
        for lt, ltname in ((0, 'external'), (2, 'secant'), (1, 'tangent')):
            n = len(V)
            A = [[0] * n for _ in range(n)]
            for i in range(n):
                for j in range(i + 1, n):
                    if linetype(V[i], V[j]) == lt:
                        A[i][j] = A[j][i] = 1
            k = set(sum(r) for r in A)
            if len(k) != 1 or 0 in k:
                print(f"  q={q} [{tsel}]x[{ltname}]: not regular (degrees {sorted(k)[:5]}...)")
                continue
            lam, mu = set(), set()
            for i in range(n):
                for j in range(i + 1, n):
                    common = sum(1 for t in range(n) if A[i][t] and A[j][t])
                    (lam if A[i][j] else mu).add(common)
            tag = f"v={n} k={k.pop()} lambda={sorted(lam)} mu={sorted(mu)}"
            srg = len(lam) == 1 and len(mu) == 1
            print(f"  q={q} [{tsel}] joined-by-{ltname}: {'SRG' if srg else 'regular NOT SRG'} {tag}")


def omega_only(q, node_limit=None):
    """Branch-and-bound max arc-clique size (no healthy census)."""
    t0 = time.time()
    B = build(q)
    noff = B['noff']; off = B['off']; adj = B['adj']
    pairline = B['pairline']; lmask = B['lmask']; ptype = B['ptype']
    gt = [~((1 << (v + 1)) - 1) for v in range(noff)]
    best = [0, None, 0, True]  # size, witness, nodes, complete

    def dfs(chosen, cand):
        best[2] += 1
        if node_limit and best[2] > node_limit:
            best[3] = False
            return
        if len(chosen) > best[0]:
            best[0] = len(chosen)
            best[1] = list(chosen)
        if len(chosen) + cand.bit_count() <= best[0]:
            return
        c = cand
        while c:
            b = c & -c
            v = b.bit_length() - 1
            c ^= b
            if len(chosen) + 1 + (c | (cand & adj[v] & gt[v])).bit_count() <= best[0]:
                # even taking v and everything after cannot beat best
                pass
            lm = 0
            for a in chosen:
                i, j = (a, v) if a < v else (v, a)
                lm |= lmask[pairline[(i, j)]]
            chosen.append(v)
            dfs(chosen, cand & adj[v] & gt[v] & ~lm)
            chosen.pop()
            if not best[3]:
                return

    for i in range(noff):
        dfs([i], adj[i] & gt[i])
    types = Counter(ptype[off[i]] for i in best[1])
    nm = n_min(q)
    print(f"q={q}: omega_arc={best[0]} (witness types {dict(types)}), n_min={nm}, "
          f"healthy {'IMPOSSIBLE (omega<n_min)' if best[0] < nm else 'needs full census'}, "
          f"nodes={best[2]}, complete={best[3]}, {time.time()-t0:.1f}s")
    sys.stdout.flush()
    return best


if __name__ == '__main__':
    if '--omega' in sys.argv:
        for a in [a for a in sys.argv[1:] if not a.startswith('--')]:
            omega_only(int(a))
        sys.exit(0)
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    collect6 = '--collect6' in sys.argv
    limit = None
    for a in sys.argv[1:]:
        if a.startswith('--limit='):
            limit = int(a.split('=')[1])
    if '--srg' in sys.argv:
        for a in args:
            srg_check(int(a))
    else:
        for a in args:
            sweep(int(a), node_limit=limit, collect6=collect6)
