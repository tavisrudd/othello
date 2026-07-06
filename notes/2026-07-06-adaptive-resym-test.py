r"""Necessary-condition test for the ADAPTIVE-MIRROR route (mirror-obstruction note, route 1).

The single-involution mirror fails because P1 can force a move on the mirror's problem set,
after which the position S is no longer symmetric under the base involution.  The adaptive
route hopes P2 can RE-SYMMETRIZE: reply y so that S U {x,y} is symmetric under some OTHER
monomial-affine involution phi' (with dead fixed locus), then bulk-force phi'.

This script tests the NECESSARY first step: enumerate ALL monomial-affine grid involutions
(the sigma_c family + the antidiagonal/swap family), and after a forced problem-move break of
the sigma_c mirror from the frame {(0,0),(1,1)}, check whether ANY involution phi' preserves
the resulting position S setwise with all phi'-fixed points DEAD (off the live set).  If none
does even at the first break, the adaptive-mirror route is structurally impossible.

We take P2's re-symmetrizing reply as FREE (any legal y), and ask: does there EXIST (y, phi')
with S={frame, x, y} legal and phi'(S)=S and phi' fixed points dead?  If for some P1 break x
NO (y, phi') exists, adaptive is dead at depth 1.
"""
import sys
from itertools import product
from gf import GF
sys.setrecursionlimit(1 << 20)


def build(q):
    F = GF(q)
    cells = list(product(range(q), repeat=2))
    idx = {c: i for i, c in enumerate(cells)}
    return F, cells, idx


def all_involutions(q, F, cells, idx):
    """All monomial-affine involutions of the grid hypergraph as index-permutations, with a
    label and the linear type. Families:
      * central sigma_c(r,c)=(2a-r,2b-c)   [diag(-1,-1)+shift]  a,b in F
      * antidiagonal phi(r,c)=(m*c+s, m^{-1}(r-s))  [swap-type, involution for all m,s]
    (Pure reflections diag(1,-1)/(−1,1) share a row/col with every cell -> never a mirror; skip.)
    """
    invs = []
    add = F.add; sub = F.sub; mul = F.mul
    # central symmetries
    for a in range(q):
        for b in range(q):
            f = lambda r, c, a=a, b=b: (sub(add(a, a), r), sub(add(b, b), c))
            phi = [idx[f(*cells[i])] for i in range(len(cells))]
            if all(phi[phi[i]] == i for i in range(len(cells))):
                invs.append((f"sc({a},{b})", phi))
    # antidiagonals
    for m in range(1, q):
        minv = F.inv(m)
        for s in range(q):
            f = lambda r, c, m=m, minv=minv, s=s: (add(mul(m, c), s), mul(minv, sub(r, s)))
            phi = [idx[f(*cells[i])] for i in range(len(cells))]
            if all(phi[phi[i]] == i for i in range(len(cells))):
                invs.append((f"anti(m={m},s={s})", phi))
    return invs


def live_set(q, F, cells, idx, chosen_cells):
    """Cells still legally playable given chosen_cells (partial-perm + affine cap)."""
    def cl(p, a, b):
        u0, u1 = sub(a[0], p[0]), sub(a[1], p[1])
        w0, w1 = sub(b[0], p[0]), sub(b[1], p[1])
        return sub(mul(u0, w1), mul(u1, w0)) == 0
    sub = F.sub; mul = F.mul
    chosen = set(chosen_cells)
    rows = {r for (r, c) in chosen}; cols = {c for (r, c) in chosen}
    live = []
    for cell in cells:
        (r, c) = cell
        if cell in chosen or r in rows or c in cols:
            continue
        bad = False
        cl2 = list(chosen)
        for i in range(len(cl2)):
            for j in range(i + 1, len(cl2)):
                if cl(cl2[i], cl2[j], cell):
                    bad = True; break
            if bad:
                break
        if not bad:
            live.append(cell)
    return set(live)


def legal_add(q, F, cells, chosen_cells, cell):
    return cell in live_set(q, F, cells, None, chosen_cells)


def main(q):
    F, cells, idx = build(q)
    sub = F.sub; mul = F.mul
    invs = all_involutions(q, F, cells, idx)

    half = F.inv(2)  # 1/2 : the sigma_c center for the frame is (1/2,1/2)
    frame = [(0, 0), (1, 1)]
    fidx = {idx[c] for c in frame}

    # sigma_c center for the frame:
    center = (half, half)
    # cross cells = center row (r=1/2) or center col (c=1/2), live
    live0 = live_set(q, F, cells, idx, frame)
    cross = [cell for cell in live0 if cell[0] == half or cell[1] == half]

    # For each forced break: P1 plays a cross cell x.  P2 free reply y (any legal).  Does some
    # involution phi' preserve S={frame,x,y} with dead fixed locus?
    def dead_fixed(phi, chosen_cells):
        live = live_set(q, F, cells, idx, chosen_cells)
        for i in range(len(cells)):
            if phi[i] == i and cells[i] in live:
                return False
        return True

    def preserves(phi, cellset):
        s = {idx[c] for c in cellset}
        return {phi[i] for i in s} == s

    n_break = 0
    n_resym = 0
    worst = []
    for x in cross:
        n_break += 1
        S3 = frame + [x]
        liveS3 = live_set(q, F, cells, idx, S3)
        found_any = False
        for y in liveS3:
            S4 = frame + [x, y]
            # RELAXED: any legal reply y that lands S4 in a mirror-symmetric position, i.e.
            # SOME involution phi' preserves S4 setwise with all fixed points dead.  (No
            # phi'(x)=y requirement -- maximally generous to the adaptive route.)
            for label, phi in invs:
                if preserves(phi, S4) and dead_fixed(phi, S4):
                    found_any = True
                    break
            if found_any:
                break
        if found_any:
            n_resym += 1
        else:
            worst.append(x)
    print(f"q={q:>2}  cross-breaks tested={n_break}  re-symmetrizable={n_resym}  "
          f"NOT-resym={len(worst)}  -> {'adaptive step-1 OK' if not worst else 'ADAPTIVE DEAD at depth 1'}",
          flush=True)
    if worst:
        print("      unrecoverable breaks (x):", worst[:8])
    return len(worst) == 0


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [9, 11, 13]
    for q in qs:
        main(q)
    print("ADAPTIVE_RESYM_TEST_DONE")
