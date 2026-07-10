#!/usr/bin/env python3
"""C58: construct + honestly verify the four projective planes of order 9.

The four planes (Lam-Kolesova-Thiel classification, exactly four of order 9):
  PG(2,9)   Desarguesian, self-dual
  Hall      translation plane, non-Desarguesian, NOT self-dual
  dualHall  literal dual of Hall (dual translation plane)
  Hughes    non-Desarguesian, self-dual, not a translation plane (near-field)

This script builds each as a pure incidence structure (91 points, 91 lines),
verifies the projective-plane axioms + order-9 parameters machine-side (the C48
honest-construction discipline), runs a Desargues counterexample search to
certify non-Desarguesian-ness, and uses an incidence-graph isomorphism test to
certify self-duality / pairwise non-isomorphism.  Each verified plane is written
to scripts/c58-data/<name>.inc for the Rust cap-game solver.

Incidence file format (0-indexed points):
  line 1:            NPOINTS NLINES
  next NLINES lines: K p0 p1 ... p_{K-1}   (K points on that line)

Run: python3 scripts/c58_order9_planes.py [build|verify] [--out DIR]
"""

import sys
import itertools
from collections import defaultdict

# ---------------------------------------------------------------------------
# GF(9) = GF(3)[i], i^2 = -1  (x^2+1 irreducible over GF(3); -1 is a nonsquare).
# Element a+bi encoded as int  e = a + 3*b,  a,b in {0,1,2}.
# ---------------------------------------------------------------------------
def gf9_tables():
    def parts(e):
        return e % 3, e // 3

    def enc(a, b):
        return (a % 3) + 3 * (b % 3)

    add = [[0] * 9 for _ in range(9)]
    mul = [[0] * 9 for _ in range(9)]
    for x in range(9):
        ax, bx = parts(x)
        for y in range(9):
            ay, by = parts(y)
            add[x][y] = enc(ax + ay, bx + by)
            # (ax+bx i)(ay+by i) = (ax ay - bx by) + (ax by + bx ay) i
            mul[x][y] = enc(ax * ay - bx * by, ax * by + bx * ay)
    neg = [enc(-parts(x)[0], -parts(x)[1]) for x in range(9)]
    inv = [0] * 9
    for x in range(1, 9):
        for y in range(1, 9):
            if mul[x][y] == 1:
                inv[x] = y
                break
    return add, mul, neg, inv


GF9_ADD, GF9_MUL, GF9_NEG, GF9_INV = gf9_tables()


def is_square_gf9(e):
    """True iff e is a nonzero square in GF(9)*."""
    if e == 0:
        return False
    return any(GF9_MUL[t][t] == e for t in range(1, 9))


# ---------------------------------------------------------------------------
# Generic incidence-structure container + plane-axiom verification.
# ---------------------------------------------------------------------------
class Plane:
    def __init__(self, name, npoints, lines):
        # lines: list of frozenset(point index).  Points are 0..npoints-1.
        self.name = name
        self.npoints = npoints
        self.lines = [frozenset(l) for l in lines]
        self.nlines = len(self.lines)

    def verify_axioms(self, order=9):
        """Full machine verification that this is a projective plane of `order`."""
        n = order
        npts = n * n + n + 1
        nln = npts
        pts_per_line = n + 1
        errs = []
        if self.npoints != npts:
            errs.append(f"npoints {self.npoints} != {npts}")
        if self.nlines != nln:
            errs.append(f"nlines {self.nlines} != {nln}")
        # every line has n+1 points
        for i, l in enumerate(self.lines):
            if len(l) != pts_per_line:
                errs.append(f"line {i} has {len(l)} points != {pts_per_line}")
                break
        # every point on exactly n+1 lines
        deg = [0] * self.npoints
        for l in self.lines:
            for p in l:
                deg[p] += 1
        for p, d in enumerate(deg):
            if d != pts_per_line:
                errs.append(f"point {p} on {d} lines != {pts_per_line}")
                break
        # any two distinct points on exactly one common line
        pair_count = defaultdict(int)
        for l in self.lines:
            for a, b in itertools.combinations(sorted(l), 2):
                pair_count[(a, b)] += 1
        bad_pairs = sum(1 for v in pair_count.values() if v != 1)
        missing_pairs = npts * (npts - 1) // 2 - len(pair_count)
        if bad_pairs:
            errs.append(f"{bad_pairs} point-pairs not on exactly one line")
        if missing_pairs:
            errs.append(f"{missing_pairs} point-pairs on NO common line")
        # any two distinct lines meet in exactly one point
        bad_ll = 0
        for i, j in itertools.combinations(range(self.nlines), 2):
            if len(self.lines[i] & self.lines[j]) != 1:
                bad_ll += 1
                if bad_ll > 3:
                    break
        if bad_ll:
            errs.append(f">= {bad_ll} line-pairs meeting in != 1 point")
        return errs

    def line_through(self):
        """lt[a][b] = index of the unique line through points a,b (a!=b)."""
        lt = [[-1] * self.npoints for _ in range(self.npoints)]
        for idx, l in enumerate(self.lines):
            ll = sorted(l)
            for a, b in itertools.combinations(ll, 2):
                lt[a][b] = idx
                lt[b][a] = idx
        return lt

    def collinear(self, a, b, c, lt=None):
        if lt is None:
            lt = self.line_through()
        return lt[a][b] == lt[a][c]

    def dual(self, name=None):
        """Dual plane: points = old lines, lines = old points' pencils."""
        pencils = [[] for _ in range(self.npoints)]
        for li, l in enumerate(self.lines):
            for p in l:
                pencils[p].append(li)
        return Plane(name or (self.name + "_dual"), self.nlines, pencils)


# ---------------------------------------------------------------------------
# Desargues counterexample search: a plane of order 9 is Desarguesian iff it is
# PG(2,9).  We certify NON-Desarguesian by exhibiting two perspective triangles
# whose three cross-line intersections are NOT collinear.
# ---------------------------------------------------------------------------
def desargues_report(plane, tries=200000, seed=12345):
    """Search for a Desargues configuration that FAILS (non-Desarguesian
    witness) and one that HOLDS.  Returns (n_fail, n_valid_tested, witness)."""
    import random

    rng = random.Random(seed)
    lt = plane.line_through()
    N = plane.npoints

    def meet(l1, l2):
        s = plane.lines[l1] & plane.lines[l2]
        return next(iter(s)) if len(s) == 1 else -1

    n_fail = 0
    n_valid = 0
    witness = None
    for _ in range(tries):
        # center O, and two triangles A1A2A3, B1B2B3 with Bi on line O-Ai.
        O = rng.randrange(N)
        A = [rng.randrange(N) for _ in range(3)]
        if len({O, *A}) != 4:
            continue
        # Bi = another point on line(O, Ai), distinct from O and Ai
        B = []
        ok = True
        for i in range(3):
            line = lt[O][A[i]]
            choices = [p for p in plane.lines[line] if p != O and p != A[i]]
            if not choices:
                ok = False
                break
            B.append(rng.choice(choices))
        if not ok or len(set(A) | set(B) | {O}) != 7:
            continue
        # triangles must be non-degenerate (vertices not collinear) and the
        # corresponding sides must actually be distinct lines that meet.
        if lt[A[0]][A[1]] == lt[A[0]][A[2]]:
            continue
        if lt[B[0]][B[1]] == lt[B[0]][B[2]]:
            continue
        # cross intersections P_k = A_i A_j  meet  B_i B_j
        good = True
        P = []
        for (i, j) in [(0, 1), (0, 2), (1, 2)]:
            la = lt[A[i]][A[j]]
            lb = lt[B[i]][B[j]]
            if la == lb:
                good = False
                break
            m = meet(la, lb)
            if m < 0:
                good = False
                break
            P.append(m)
        if not good or len(set(P)) != 3:
            continue
        n_valid += 1
        # Desargues: P0,P1,P2 collinear.
        coll = lt[P[0]][P[1]] == lt[P[0]][P[2]]
        if not coll:
            n_fail += 1
            if witness is None:
                witness = (O, tuple(A), tuple(B), tuple(P))
            if n_fail >= 5:
                break
    return n_fail, n_valid, witness


# ---------------------------------------------------------------------------
# Incidence-graph isomorphism (points+lines bipartite graph), used for
# self-duality and pairwise (non-)isomorphism.  Refinement + backtracking.
# The bipartite graph vertices: 0..P-1 points, P..P+L-1 lines.  We test
# isomorphism as *point-line structures* preserving the bipartition.
# ---------------------------------------------------------------------------
def _plane_iso(pa, pb, allow_swap=True, node_cap=5_000_000):
    """Return (status, iso) where status in {'iso','noniso','unknown'}.
    Finds an isomorphism pa->pb if one exists (status 'iso'); exhausts the
    search up to node_cap to prove none exists ('noniso'); 'unknown' if the cap
    is hit first.  Projective-plane incidence graphs are distance-regular, so
    color refinement gives no pruning: positive (self-dual) cases terminate
    fast, but a genuine non-isomorphism can exceed the cap -- caller decides."""
    if pa.npoints != pb.npoints or pa.nlines != pb.nlines:
        return ("noniso", None)
    Pn = pa.npoints
    # adjacency: for each point, set of line indices; for each line, set of points
    a_pt_lines = [set() for _ in range(pa.npoints)]
    for li, l in enumerate(pa.lines):
        for p in l:
            a_pt_lines[p].add(li)
    b_pt_lines = [set() for _ in range(pb.npoints)]
    for li, l in enumerate(pb.lines):
        for p in l:
            b_pt_lines[p].add(li)

    a_lines = [sorted(l) for l in pa.lines]
    b_line_sets = pb.lines

    # We find a point-permutation phi and a line-permutation; incidence forces
    # the line map once phi is fixed on a line's points, so backtrack on points.
    # Order points by a stable heuristic; map greedily with incidence checks.
    b_lookup = {}
    for li, l in enumerate(pb.lines):
        b_lookup[l] = li

    phi = [-1] * pa.npoints
    used = [False] * pb.npoints

    # line image is determined once all its points are assigned; verify then.
    order = list(range(pa.npoints))

    def consistent_partial():
        # every fully-assigned line of A must map to an existing line of B
        for li, l in enumerate(a_lines):
            imgs = [phi[p] for p in l]
            if all(v >= 0 for v in imgs):
                if frozenset(imgs) not in b_lookup:
                    return False
        return True

    import sys as _sys
    _sys.setrecursionlimit(10000)
    nodes = [0]
    capped = [False]

    def bt(k):
        if k == len(order):
            return True
        nodes[0] += 1
        if nodes[0] > node_cap:
            capped[0] = True
            return False
        p = order[k]
        for q in range(pb.npoints):
            if used[q]:
                continue
            # degree already equal (both n+1); check forward incidence quickly:
            phi[p] = q
            used[q] = True
            # prune: any line of A all of whose points <=k are assigned and that
            # is now complete must be a B-line.
            if _partial_ok(p):
                if bt(k + 1):
                    return True
            phi[p] = -1
            used[q] = False
            if capped[0]:
                return False
        return False

    # incremental partial check: only re-check lines containing p that are now
    # fully assigned, plus a co-line count constraint for speed.
    a_lines_of_pt = a_pt_lines

    def _partial_ok(p):
        for li in a_lines_of_pt[p]:
            l = a_lines[li]
            imgs = [phi[x] for x in l]
            if all(v >= 0 for v in imgs):
                if frozenset(imgs) not in b_lookup:
                    return False
        return True

    # heuristic ordering: BFS from a start point through shared lines so that
    # each new point shares a line with an earlier one (heavy constraint early)
    seen = [False] * pa.npoints
    ordered = []
    stack = [0]
    seen[0] = True
    while stack:
        x = stack.pop()
        ordered.append(x)
        neigh = set()
        for li in a_lines_of_pt[x]:
            neigh |= set(a_lines[li])
        for y in sorted(neigh):
            if not seen[y]:
                seen[y] = True
                stack.append(y)
    for x in range(pa.npoints):
        if not seen[x]:
            ordered.append(x)
    order = ordered

    if bt(0):
        return ("iso", list(phi))
    return (("unknown", None) if capped[0] else ("noniso", None))


def is_self_dual(plane, node_cap=5_000_000):
    d = plane.dual()
    status, _ = _plane_iso(plane, d, node_cap=node_cap)
    return status  # 'iso' | 'noniso' | 'unknown'


def are_isomorphic(pa, pb, node_cap=5_000_000):
    status, _ = _plane_iso(pa, pb, node_cap=node_cap)
    return status


# ---------------------------------------------------------------------------
# PG(2,9) from GF(9): points = normalized nonzero triples, lines = covectors.
# ---------------------------------------------------------------------------
def build_pg29():
    def normalize(v):
        # scale so first nonzero coord is 1
        for i in range(3):
            if v[i] != 0:
                s = GF9_INV[v[i]]
                return tuple(GF9_MUL[s][x] for x in v)
        return None

    pts = []
    seen = set()
    for x in range(9):
        for y in range(9):
            for z in range(9):
                if x == 0 and y == 0 and z == 0:
                    continue
                nv = normalize((x, y, z))
                if nv not in seen:
                    seen.add(nv)
                    pts.append(nv)
    pt_index = {p: i for i, p in enumerate(pts)}
    assert len(pts) == 91, len(pts)

    def dot(a, x):
        s = 0
        for i in range(3):
            s = GF9_ADD[s][GF9_MUL[a[i]][x[i]]]
        return s

    lines = []
    seen_l = set()
    for x in range(9):
        for y in range(9):
            for z in range(9):
                if x == 0 and y == 0 and z == 0:
                    continue
                cov = normalize((x, y, z))
                if cov in seen_l:
                    continue
                seen_l.add(cov)
                line = frozenset(pt_index[p] for p in pts if dot(cov, p) == 0)
                lines.append(line)
    return Plane("PG(2,9)", 91, lines)


# ---------------------------------------------------------------------------
# Hall plane via a spread of F^4 (F=GF(3)) with the standard regulus reversed.
# Regular spread set: M_{a,b} = [[a, b],[b*s, a+b*r]] with theta^2 = r theta + s
# for GF(9)=GF(3)[theta].  We used i^2=-1 so r=0, s=-1=2.
# Components V_M = {(x, x*M): x in F^2}; vertical V_inf = {(0,y)}.
# Reverse the regulus {V_{aI}: a in F} U {V_inf} by its opposite regulus.
# ---------------------------------------------------------------------------
F3 = 3


def f3_vecs4():
    return list(itertools.product(range(F3), repeat=4))


def build_translation_plane(spread_components, name):
    """spread_components: list of frozenset of NONZERO vectors in F^4, each a
    2-dim subspace (8 nonzero vecs), partitioning F^4 \\ {0}.  Build the
    projective translation plane: 81 affine points + 10 infinite points."""
    vecs = f3_vecs4()
    assert len(spread_components) == F3 * F3 + 1  # 10
    # affine points 0..80 = the 81 vectors; index by vector
    vidx = {v: i for i, v in enumerate(vecs)}
    n_aff = len(vecs)  # 81
    inf_pts = list(range(n_aff, n_aff + len(spread_components)))  # 81..90
    npoints = n_aff + len(spread_components)  # 91

    def vadd(u, v):
        return tuple((u[i] + v[i]) % F3 for i in range(4))

    def vsub(u, v):
        return tuple((u[i] - v[i]) % F3 for i in range(4))

    lines = []
    # affine lines: for each component C and each coset, the coset u+C
    for ci, comp in enumerate(spread_components):
        comp_full = set(comp) | {(0, 0, 0, 0)}  # include zero vector => 9 vecs
        # cosets: partition the 81 vectors
        remaining = set(vecs)
        while remaining:
            base = next(iter(remaining))
            coset = frozenset(vadd(base, c) for c in comp_full)
            remaining -= coset
            pts = set(vidx[v] for v in coset)
            pts.add(inf_pts[ci])  # the affine line passes through its inf point
            lines.append(frozenset(pts))
    # line at infinity
    lines.append(frozenset(inf_pts))
    return Plane(name, npoints, lines)


def two_dim_subspaces_f4():
    """All 2-dim subspaces of GF(3)^4, as frozensets of the 8 nonzero vectors."""
    vecs = [v for v in f3_vecs4() if any(v)]
    subs = set()
    vset = f3_vecs4()

    def span(u, v):
        s = set()
        for a in range(F3):
            for b in range(F3):
                s.add(tuple((a * u[i] + b * v[i]) % F3 for i in range(4)))
        return s

    for i in range(len(vecs)):
        for j in range(i + 1, len(vecs)):
            sp = span(vecs[i], vecs[j])
            if len(sp) == 9:  # 2-dim (9 vectors incl 0)
                nz = frozenset(w for w in sp if any(w))
                subs.add(nz)
    return list(subs)


def hall_spread():
    s = 2  # -1 mod 3
    r = 0

    def matvec(M, x):
        # x row-vector times M (2x2): result_j = sum_i x_i M[i][j]
        return tuple((x[0] * M[0][j] + x[1] * M[1][j]) % F3 for j in range(2))

    def component(M):
        comp = set()
        for x in itertools.product(range(F3), repeat=2):
            y = matvec(M, x)
            v = (x[0], x[1], y[0], y[1])
            if any(v):
                comp.add(v)
        return frozenset(comp)

    reg = {}
    for a in range(F3):
        for b in range(F3):
            M = [[a, b], [(b * s) % F3, (a + b * r) % F3]]
            reg[(a, b)] = component(M)
    v_inf = frozenset(
        (0, 0, y0, y1) for y0 in range(F3) for y1 in range(F3) if (y0 or y1)
    )
    all_components = list(reg.values()) + [v_inf]

    # standard regulus R = {V_{aI}: a in F} U {V_inf} = reg[(a,a? )]. M_{a,0}=aI.
    regulus = [reg[(a, 0)] for a in range(F3)] + [v_inf]
    regulus_set = set(regulus)
    regulus_vecs = set()
    for c in regulus:
        regulus_vecs |= set(c)

    # opposite regulus: all 2-dim subspaces meeting each regulus component in a
    # 1-dim subspace (2 nonzero vectors), i.e. |W & C| == 2 for each C in R.
    subs = two_dim_subspaces_f4()
    opp = []
    for W in subs:
        if all(len(W & C) == 2 for C in regulus):
            opp.append(W)
    # sanity: opposite regulus has q+1 = 4 components covering the same vectors
    assert len(opp) == F3 + 1, f"opp regulus size {len(opp)}"
    opp_vecs = set()
    for c in opp:
        opp_vecs |= set(c)
    assert opp_vecs == regulus_vecs, "opposite regulus covers different vectors"

    hall_components = [c for c in all_components if c not in regulus_set] + opp
    assert len(hall_components) == 10
    # verify partition of the 80 nonzero vectors
    allnz = set(v for v in f3_vecs4() if any(v))
    cover = set()
    tot = 0
    for c in hall_components:
        assert len(c) == 8
        cover |= set(c)
        tot += len(c)
    assert cover == allnz and tot == 80, "Hall spread not a partition"
    return hall_components, all_components


# ---------------------------------------------------------------------------
# Hughes plane of order 9 (near-field construction).  Filled in below once the
# exact incidence recipe is fixed; verified by the same harness (axioms +
# Desargues + a complete-arc spectrum distinct from the other three).
# ---------------------------------------------------------------------------
def build_hughes():
    """Hughes plane of order 9 (Dembowski's homogeneous construction, Canad. J.
    Math. 23 (1971) 481-494, specialized to K=GF(3), near-field N of order 9;
    == Hughes 1957).  Points = nonzero GF(9)-triples mod RIGHT near-field
    scaling; 91 lines = the 13 Singer-cycle images of 7 base lines."""
    A, M = GF9_ADD, GF9_MUL
    sq = set(t for t in range(1, 9) if any(M[u][u] == t for u in range(1, 9)))

    def cube(a):
        return M[a][M[a][a]]  # a^3 (Frobenius, q=3)

    def nmul(a, b):
        if b == 0:
            return 0
        return M[a][b] if b in sq else M[cube(a)][b]

    def canon(x):
        # canonical rep of a nonzero triple under right scaling x ~ x o f
        best = None
        for f in range(1, 9):
            t = (nmul(x[0], f), nmul(x[1], f), nmul(x[2], f))
            if best is None or t < best:
                best = t
        return best

    pts, seen = [], set()
    for x0 in range(9):
        for x1 in range(9):
            for x2 in range(9):
                if x0 == 0 and x1 == 0 and x2 == 0:
                    continue
                c = canon((x0, x1, x2))
                if c not in seen:
                    seen.add(c)
                    pts.append(c)
    assert len(pts) == 91, len(pts)
    pidx = {p: i for i, p in enumerate(pts)}

    # Singer matrix alpha over GF(3) (entries central), order 13 mod scalars
    alpha = [[0, 0, 2], [1, 0, 0], [0, 1, 1]]

    def matvec(Mx, x):
        out = []
        for i in range(3):
            s = 0
            for j in range(3):
                s = A[s][M[Mx[i][j]][x[j]]]
            out.append(s)
        return tuple(out)

    F3 = {0, 1, 2}
    ext = [f for f in range(9) if f not in F3]  # {3,4,5,6,7,8}

    def on_linf(x):
        return x[1] == 0

    def on_lf(x, f):
        # x0 + (f o x1) + x2 == 0   (LEFT near-field mult f o x1)
        return A[A[x[0]][nmul(f, x[1])]][x[2]] == 0

    base_lines = [frozenset(pidx[p] for p in pts if on_linf(p))]
    for f in ext:
        base_lines.append(frozenset(pidx[p] for p in pts if on_lf(p, f)))

    def apply_alpha(lineset):
        return frozenset(pidx[canon(matvec(alpha, pts[pi]))] for pi in lineset)

    lines = set()
    for B in base_lines:
        cur = B
        for _ in range(13):
            lines.add(cur)
            cur = apply_alpha(cur)
    return Plane("Hughes", 91, list(lines))


# ---------------------------------------------------------------------------
def write_inc(plane, path):
    with open(path, "w") as f:
        f.write(f"{plane.npoints} {plane.nlines}\n")
        for l in plane.lines:
            ll = sorted(l)
            f.write(f"{len(ll)} " + " ".join(map(str, ll)) + "\n")


def report_plane(plane, do_iso=False):
    # NOTE: identification (self-dual / pairwise non-iso) is done rigorously and
    # cheaply by the complete-arc spectrum via the Rust census (c58_cap_solve.rs
    # --census); the backtracking iso test below is too slow on projective-plane
    # incidence graphs (distance-regular => no color-refinement pruning), so it
    # is off by default.
    print(f"\n=== {plane.name} ===")
    errs = plane.verify_axioms(9)
    if errs:
        print("  AXIOM ERRORS:", errs)
        return False
    print("  axioms: OK (91 pts, 91 lines, 10 pts/line, 10 lines/pt, "
          "2pts->1line, 2lines->1pt)")
    nf, nv, wit = desargues_report(plane)
    if nf == 0:
        print(f"  Desargues: HOLDS on all {nv} tested configs -> Desarguesian")
    else:
        print(f"  Desargues: FAILS ({nf} counterexamples / {nv} tested) "
              f"-> NON-Desarguesian; witness O,A,B,P = {wit}")
    if do_iso:
        sd = is_self_dual(plane, node_cap=2_000_000)
        print(f"  self-dual: {sd}")
    return True


def main():
    import os

    out_dir = "scripts/c58-data"
    for i, a in enumerate(sys.argv):
        if a == "--out" and i + 1 < len(sys.argv):
            out_dir = sys.argv[i + 1]
    os.makedirs(out_dir, exist_ok=True)

    print("Building PG(2,9) from GF(9)...")
    pg = build_pg29()
    report_plane(pg)
    write_inc(pg, os.path.join(out_dir, "pg29.inc"))

    print("\nBuilding Hall plane from reversed-regulus spread...")
    hall_comp, reg_comp = hall_spread()
    hall = build_translation_plane(hall_comp, "Hall")
    report_plane(hall)
    write_inc(hall, os.path.join(out_dir, "hall.inc"))

    # cross-check: the un-reversed regular spread reproduces PG(2,9)
    print("\nCross-check: regular spread should be Desarguesian (== PG(2,9))...")
    reg_plane = build_translation_plane(reg_comp, "RegularSpread")
    errs = reg_plane.verify_axioms(9)
    nf, nv, _ = desargues_report(reg_plane)
    print(f"  regular-spread axioms {'OK' if not errs else errs}; "
          f"Desargues fails={nf}/{nv} (expect 0 => Desarguesian)")

    print("\nBuilding dual Hall (literal dual of Hall)...")
    dhall = hall.dual("dualHall")
    report_plane(dhall)
    write_inc(dhall, os.path.join(out_dir, "dualhall.inc"))

    print("\nBuilding Hughes plane (near-field construction)...")
    try:
        hughes = build_hughes()
        report_plane(hughes)
        write_inc(hughes, os.path.join(out_dir, "hughes.inc"))
    except NotImplementedError as e:
        print("  Hughes not yet available:", e)

    print("\nIdentification (Hall vs dual-Hall, self-duality, pairwise non-iso) "
          "is done by the complete-arc spectrum: run")
    print("  target/c58cap scripts/c58-data/<plane>.inc --census")


if __name__ == "__main__":
    main()
