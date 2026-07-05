"""Fast solver for the impartial sum-free achievement game on a finite abelian group G.

Game: players alternately grow A subset G from empty; a legal move adds x notin A keeping
A cup {x} sum-free (no a+b=c with a,b,c in A cup {x}; a=b allowed so 2a=c forbidden).
Normal play, last to move wins.  OUTCOME "N" = first player wins (win(empty)=True),
"P" = second player wins.

Key levers (pure CPython):
  * bitmask subsets over |G| elements (Python big ints)
  * incremental "sum set" S = { a+b : a,b in A } maintained as a bitmask -> O(1)-ish legality
  * alpha-beta short circuit: a node returns win=True on the FIRST losing child
  * move ordering: most-constraining move first (child creates the fewest future options),
    and an instant win (child is terminal / opponent has no move) ends the node immediately
  * SYMMETRY: memoize win() on a canonical form of A under Aut(G).  Aut(G) preserves
    a+b=c (group autos), so equivalent positions share a value.  For the F3^n / Z2xF3^n
    targets Aut = GL(n,3).  Canonicalization is SOUND as long as the key is always an
    image g.A of some g in the group (it can never merge two inequivalent sets); a weaker
    (subgroup / partial) canon just merges fewer, still correct.

Author: research agent, 2026-07-05.
"""
import sys, time
from itertools import product

sys.setrecursionlimit(1 << 22)


# --------------------------------------------------------------------------- #
# Group construction
# --------------------------------------------------------------------------- #
class Group:
    def __init__(self, mods, f3_positions=None):
        """mods: moduli of the cyclic factors, e.g. (3,3,3,3) or (2,3,3,3).
        f3_positions: which coordinate indices form an F3 vector space acted on by
        GL (the rest are fixed by the automorphisms we use).  If None, inferred:
        all coords equal to 3 -> pure GL; a leading 2 then 3s -> GL on the 3-part."""
        self.mods = tuple(mods)
        self.elems = list(product(*[range(m) for m in mods]))
        self.idx = {e: i for i, e in enumerate(self.elems)}
        self.N = len(self.elems)
        self.zero = self.idx[tuple(0 for _ in mods)]
        # addition table
        self.add = [[self.idx[tuple((a + b) % m for a, b, m in zip(self.elems[i], self.elems[j], mods))]
                     for j in range(self.N)] for i in range(self.N)]
        self.f3_positions = f3_positions

    # ---- automorphism generators as index permutations ------------------- #
    def gl_matrix_to_perm(self, M, f3_pos):
        """M: n x n matrix over F3 (list of rows), acting on the f3_pos coordinates."""
        n = len(f3_pos)
        perm = [0] * self.N
        for i, e in enumerate(self.elems):
            v = [e[p] for p in f3_pos]
            w = [sum(M[r][c] * v[c] for c in range(n)) % 3 for r in range(n)]
            out = list(e)
            for k, p in enumerate(f3_pos):
                out[p] = w[k]
            perm[i] = self.idx[tuple(out)]
        return tuple(perm)

    def gl_generators(self, f3_pos):
        n = len(f3_pos)
        gens = []
        I = [[1 if r == c else 0 for c in range(n)] for r in range(n)]
        # transvections E_{ij}(1): add col j to col i  (generate SL(n,3))
        for i in range(n):
            for j in range(n):
                if i == j:
                    continue
                M = [row[:] for row in I]
                M[i][j] = 1
                gens.append(self.gl_matrix_to_perm(M, f3_pos))
        # diag(2,1,...,1): det 2 -> lifts SL to GL
        D = [row[:] for row in I]
        D[0][0] = 2
        gens.append(self.gl_matrix_to_perm(D, f3_pos))
        return gens

    def monomial_generators(self, f3_pos):
        """Monomial subgroup of GL(n,3): coordinate permutations x sign flips.
        Order n! * 2^n (=384 for n=4).  A cheap EXACT subgroup for canonicalization."""
        n = len(f3_pos)
        I = [[1 if r == c else 0 for c in range(n)] for r in range(n)]
        gens = []
        # coordinate transpositions (adjacent suffice, but include all for a short diameter)
        for i in range(n):
            for j in range(i + 1, n):
                M = [row[:] for row in I]
                M[i][i] = M[j][j] = 0
                M[i][j] = M[j][i] = 1
                gens.append(self.gl_matrix_to_perm(M, f3_pos))
        # sign flip on coord 0 (multiply by 2 = -1 in F3)
        D = [row[:] for row in I]
        D[0][0] = 2
        gens.append(self.gl_matrix_to_perm(D, f3_pos))
        return gens

    def monomial_auto(self):
        mods = self.mods
        if all(m == 3 for m in mods):
            return self.monomial_generators(list(range(len(mods))))
        if mods[0] == 2 and all(m == 3 for m in mods[1:]):
            return self.monomial_generators(list(range(1, len(mods))))
        raise ValueError(f"no monomial generators wired for mods={mods}")

    def units_generators(self):
        """Cyclic Zm: automorphisms are x -> u x for u a unit mod m."""
        (m,) = self.mods
        gens = []
        for u in range(2, m):
            from math import gcd
            if gcd(u, m) == 1:
                perm = tuple(self.idx[((u * self.elems[i][0]) % m,)] for i in range(self.N))
                gens.append(perm)
        return gens

    def auto_generators(self):
        mods = self.mods
        if all(m == 3 for m in mods):
            return self.gl_generators(list(range(len(mods))))
        if mods[0] == 2 and all(m == 3 for m in mods[1:]):
            return self.gl_generators(list(range(1, len(mods))))
        if len(mods) == 1:
            return self.units_generators()
        raise ValueError(f"no automorphism generators wired for mods={mods}")


# --------------------------------------------------------------------------- #
# Permutation group: BFS closure (small groups) -> full element list
# --------------------------------------------------------------------------- #
def close_group(gens, N, cap=None):
    """Return the full list of group elements (as permutation tuples) by BFS closure
    of the generators.  cap: stop and return None if the group exceeds cap (too big)."""
    identity = tuple(range(N))
    seen = {identity}
    frontier = [identity]
    elems = [identity]
    while frontier:
        nf = []
        for g in frontier:
            for h in gens:
                # compose: (h after g)?  we want the set closed, direction irrelevant
                comp = tuple(h[g[i]] for i in range(N))
                if comp not in seen:
                    seen.add(comp)
                    elems.append(comp)
                    nf.append(comp)
                    if cap is not None and len(elems) > cap:
                        return None
        frontier = nf
    return elems


# --------------------------------------------------------------------------- #
# Solver
# --------------------------------------------------------------------------- #
class Solver:
    def __init__(self, group, canon_group=None, restrict=None, use_root_sym=True,
                 verbose=False, root_transitive=False):
        self.g = group
        self.add = group.add
        self.N = group.N
        self.zero = group.zero
        self.pow2 = [1 << i for i in range(self.N)]
        # ground = playable elements (nonzero, optionally restricted to a subset)
        self.ground = [i for i in range(self.N)
                       if i != self.zero and (restrict is None or i in restrict)]
        self.ground_mask = 0
        for i in self.ground:
            self.ground_mask |= self.pow2[i]
        # doubling map: dbl[x] = 2x.  Forbidden-by-doubling candidates for a set A are
        # { z : 2z in A } (NOT 2A -- these differ when 2-torsion exists).  dblpre[y] =
        # mask of z with 2z = y, so adding y to A extends the forbidden set by dblpre[y].
        self.dbl = [self.add[i][i] for i in range(self.N)]
        self.dblpre = [0] * self.N
        for z in range(self.N):
            self.dblpre[self.dbl[z]] |= (1 << z)
        # negation map: neg[x] = -x
        self.neg = [0] * self.N
        for i in range(self.N):
            for j in range(self.N):
                if self.add[i][j] == self.zero:
                    self.neg[i] = j
                    break
        self.canon_group = canon_group      # list of perm tuples, or None
        self.use_root_sym = use_root_sym
        # root_transitive: caller asserts Aut(G) is transitive on the ground set
        # (true for GL on F3^n and Z2xF3^n) -> all singleton first moves are equivalent,
        # so only ONE representative root move need be tried even if canon_group is a
        # non-transitive subgroup (e.g. the monomial group).
        self.root_transitive = root_transitive
        self.verbose = verbose
        self.tt = {}                        # canon(A) -> bool win
        self.nodes = 0
        self.t0 = None
        self.progress_every = 0             # >0 -> print progress every N nodes
        self._last = 0
        self.canon_max_size = 0             # >0 -> skip group-canon when |A| exceeds it

    # ---- incremental state -----------------------------------------------
    # A position is carried as (Amask, members, S, D, T) where, for the current set A:
    #   S = SumSet(A)  = { a+b : a,b in A }         (includes 2a)
    #   D = Diff(A)    = { a-b : a,b in A }         (ordered differences)
    #   T = { z : 2z in A }                         (doubling preimage of A)
    # LEGALITY (O(1) big-int test): x may be added to sum-free A iff
    #   x in ground, and x not in A | S | D | T.
    # The four forbidden masks are exactly: A (already present), S (x = a+b for a,b in A),
    # D (a+x = a' in A  <=>  x = a'-a), T (2x in A).  See report for the derivation.
    def _legal(self, Amask, S, D, T):
        return self.ground_mask & ~(Amask | S | D | T)

    def child_state(self, Amask, members, S, D, T, x):
        pw = self.pow2
        add = self.add
        neg = self.neg
        rx = add[x]                     # rx[a] = a + x
        negx = neg[x]
        rnx = add[negx]                 # rnx[a] = a - x
        camask = Amask | pw[x]
        cS = S | pw[self.dbl[x]]        # add 2x = x+x to the sum set
        cT = T | self.dblpre[x]         # z with 2z = x are now doubling-forbidden
        cD = D
        for a in members:
            cS |= pw[rx[a]]            # a + x
            d1 = rnx[a]                # a - x
            cD |= pw[d1] | pw[neg[d1]] # a-x and x-a
        return camask, cS, cD, cT

    # ---- canonical key --------------------------------------------------- #
    def canon(self, Amask, members):
        if self.canon_group is None:
            return Amask
        # Hybrid: only group-canonicalize while |A| is small (large sets have tiny
        # stabilizers -> little symmetry merging survives, so raw bitmask keys are cheap
        # and nearly as effective).  Sound: raw Amask is itself a valid canonical image.
        if self.canon_max_size and len(members) > self.canon_max_size:
            return Amask
        pw = self.pow2
        best = Amask
        for g in self.canon_group:
            img = 0
            for a in members:
                img |= pw[g[a]]
            if img < best:
                best = img
        return best

    # ---- win() : True iff player to move at A wins ----------------------- #
    def win(self, Amask, members, S, D, T, moves, depth):
        # `moves` = precomputed legal-move mask for this node (nonzero).
        self.nodes += 1
        if self.progress_every and self.nodes - self._last >= self.progress_every:
            self._last = self.nodes
            import resource
            rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024
            print(f"  ..nodes={self.nodes:>11}  tt={len(self.tt):>10}  depth={depth:>3}  "
                  f"rss={rss}MB  {time.time()-self.t0:7.1f}s", flush=True)
        key = self.canon(Amask, members)
        cached = self.tt.get(key)
        if cached is not None:
            return cached

        # Expand children: compute each child's state + legal mask (O(k) each).
        # Instant win: a child with no legal moves is terminal -> we win now.
        mlist = []
        m = moves
        while m:
            x = (m & -m).bit_length() - 1
            m &= m - 1
            camask, cS, cD, cT = self.child_state(Amask, members, S, D, T, x)
            cmoves = self._legal(camask, cS, cD, cT)
            if cmoves == 0:
                self.tt[key] = True
                return True
            mlist.append((cmoves.bit_count(), x, camask, cS, cD, cT, cmoves))
        mlist.sort(key=lambda t: t[0])      # most-constraining (fewest child-moves) first

        result = False
        for _, x, camask, cS, cD, cT, cmoves in mlist:
            if not self.win(camask, members + [x], cS, cD, cT, cmoves, depth + 1):
                result = True
                break
        self.tt[key] = result
        return result

    def solve(self):
        self.t0 = time.time()
        # root symmetry: if Aut(G) is transitive on the ground set (true for GL on F3^n
        # and Z2xF3^n), all singleton first moves are equivalent, so win(empty)=True iff
        # win({e})=False for one representative e.
        transitive = self.root_transitive
        if self.use_root_sym and not transitive and self.canon_group is not None:
            e = self.ground[0]
            orbit = {g[e] for g in self.canon_group}
            transitive = all((i in orbit) for i in self.ground)
        if self.use_root_sym and transitive:
            x = self.ground[0]
            camask, cS, cD, cT = self.child_state(0, [], 0, 0, 0, x)
            cmoves = self._legal(camask, cS, cD, cT)
            if cmoves == 0:
                return "N", x               # opponent has no reply -> we already won
            child_win = self.win(camask, [x], cS, cD, cT, cmoves, 1)
            return ("N" if not child_win else "P"), x
        # generic root
        moves0 = self._legal(0, 0, 0, 0)
        if moves0 == 0:
            return "P", None
        w = self.win(0, [], 0, 0, 0, moves0, 0)
        return ("N" if w else "P"), None


# --------------------------------------------------------------------------- #
# CLI:  python3 sumfree-fast.py <mods csv> [canon: full|monomial|none] [max_size]
#   mods e.g. 3,3,3,3 (=F3^4)   or   2,3,3,3 (=Z2 x (Z3)^3)   or   5 (=Z5)
#   canon  full     : canonicalize under the whole automorphism group (enumerable only)
#          monomial : canonicalize under the monomial subgroup of GL (order n!*2^n)
#          none     : raw-bitmask TT, no symmetry
#   max_size : (optional) skip group-canon once |A| exceeds it (hybrid speed lever)
# --------------------------------------------------------------------------- #
def _build_canon(g, mode):
    if mode == "none":
        return None, False
    if mode == "full":
        return close_group(g.auto_generators(), g.N, cap=2_000_000), True
    if mode == "monomial":
        return close_group(g.monomial_auto(), g.N), True
    raise SystemExit(f"unknown canon mode {mode!r}")


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser(description="Sum-free achievement game solver")
    ap.add_argument("mods", help="cyclic factor moduli, e.g. 3,3,3,3 or 2,3,3,3 or 5")
    ap.add_argument("canon", nargs="?", default="full", choices=["full", "monomial", "none"])
    ap.add_argument("max_size", nargs="?", type=int, default=0,
                    help="skip group-canon when |A| exceeds this (0 = never skip)")
    ap.add_argument("--progress", type=int, default=0, help="print progress every N nodes")
    args = ap.parse_args()
    mods = tuple(int(x) for x in args.mods.split(","))
    lbl = "x".join(f"Z{m}" for m in mods)
    t0 = time.time()
    grp = Group(mods)
    cg, root_trans = _build_canon(grp, args.canon)
    sv = Solver(grp, canon_group=cg, root_transitive=root_trans)
    sv.canon_max_size = args.max_size
    sv.progress_every = args.progress
    outcome, first = sv.solve()
    dt = time.time() - t0
    who = "FIRST player wins" if outcome == "N" else "SECOND player wins"
    print(f"[{lbl}] |G|={grp.N}  canon={args.canon}  |canon group|="
          f"{None if cg is None else len(cg)}")
    print(f"  OUTCOME = {outcome}  ({who})")
    if outcome == "N" and first is not None:
        print(f"  a winning first move = {grp.elems[first]}  (all are equivalent under Aut)")
    print(f"  nodes={sv.nodes}  tt={len(sv.tt)}  time={dt:.2f}s")
