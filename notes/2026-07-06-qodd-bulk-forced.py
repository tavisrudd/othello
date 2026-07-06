r"""q-odd planar kernel — the localizing experiment.

The residual grid game (2026-07-05-grid-game.py): q x q grid, legal position = partial
permutation matrix (<=1 per row, <=1 per col) that is also an affine cap (no 3 collinear).
P1 moves first; PG(2,q)=P  <=>  this is a first-player LOSS.

Prior work (2026-07-05-qodd-central-symmetry-findings.md) killed the single-involution
mirror: sigma_c (central symmetry about the opening-midpoint center c) is a fpf involution
automorphism EXCEPT on c's row and c's column (the "cross"), where sigma_c(x) shares x's
row/col => illegal reply. Patches that force a specific cross reply (transpose / adaptive
row<->col) break sigma_c-symmetry and fail for q>=9.

THIS experiment is strictly more permissive than any prior patch, to localize the problem:
P2 commits to the FORCED sigma_c mirror on the BULK only, but is allowed to reply with ANY
legal cell to a cross move (fully free, not just the opposite special line), and to CHOOSE
the center c (via its first reply x2). Key structural fact: the cross (c's row U c's col)
can ever hold at most 2 chosen cells (<=1 per row, <=1 per col) => P1 can trigger a free
reply at most twice. So if P2 wins under this policy, the ENTIRE open q-odd problem reduces
to a bounded (<=2-move) cross sub-game layered on a clean bulk mirror.

Question: is "bulk-forced sigma_c + free cross replies + best center" a P2 win for all odd q?
  YES for all q  => strong structured strategy; open problem localized to the cross.
  NO             => even this permissive structured strategy is insufficient (P2 must play
                    unstructured); consistent with the prior negatives, sharper.

WLOG P1's first move is (0,0) (translations act transitively on cells).
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def analyze(q, verbose=False):
    F = GF(q)
    cells = list(product(range(q), repeat=2))       # (row, col)
    idx = {c: i for i, c in enumerate(cells)}
    N = len(cells)
    half = F.inv(2 % q)

    def cross_cell(p, a, b):
        u0, u1 = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        w0, w1 = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(u0, w1), F.mul(u1, w0)) == 0

    # forbidden-on-add masks
    row_mask = [0] * N
    col_mask = [0] * N
    for i, (r, c) in enumerate(cells):
        for j, (r2, c2) in enumerate(cells):
            if i == j:
                continue
            if r2 == r:
                row_mask[i] |= 1 << j
            if c2 == c:
                col_mask[i] |= 1 << j
    rc_mask = [row_mask[i] | col_mask[i] for i in range(N)]
    line_third = [[0] * N for _ in range(N)]
    for i in range(N):
        for j in range(N):
            if i == j:
                continue
            m = 0
            for k in range(N):
                if k != i and k != j and cross_cell(cells[i], cells[j], cells[k]):
                    m |= 1 << k
            line_third[i][j] = m

    ALL = (1 << N) - 1

    def forbid_after_add(forbidden, chosen, yi):
        nf = forbidden | rc_mask[yi]
        c = chosen
        while c:
            b = c & (-c); c ^= b
            nf |= line_third[yi][b.bit_length() - 1]
        return nf

    # ---- strategy search for a fixed center c ----
    def search_center(x1i, x2i, cr, cc):
        """Return True if 'bulk-forced sigma_c + free cross' wins from S={x1,x2}, P1 to move.
        cr,cc = center coords. sigma_c(r,c) = (2cr-r, 2cc-c)."""
        two = F.add  # helper
        def sigma(i):
            r, c = cells[i]
            return idx[(F.sub(F.add(cr, cr), r), F.sub(F.add(cc, cc), c))]

        memo_p1 = {}   # S -> bool (P2 wins with P1 to move)

        def p1_to_move(chosen, forbidden):
            v = memo_p1.get(chosen)
            if v is not None:
                return v
            avail = ALL & ~chosen & ~forbidden
            # P2 wins iff EVERY legal P1 move is answerable
            res = True
            a = avail
            while a and res:
                y = a & (-a); a ^= y
                yi = y.bit_length() - 1
                r, c = cells[yi]
                nf = forbid_after_add(forbidden, chosen, yi)
                nchosen = chosen | y
                is_cross = (r == cr) or (c == cc)
                if not is_cross:
                    # forced sigma_c reply
                    ri = sigma(yi)
                    rbit = 1 << ri
                    if (nchosen & rbit) or (nf & rbit):
                        res = False          # forced reply illegal => policy fails vs this P1 move
                    else:
                        nf2 = forbid_after_add(nf, nchosen, ri)
                        if not p1_to_move(nchosen | rbit, nf2):
                            res = False
                else:
                    # free reply: P2 needs SOME legal reply that wins
                    avail2 = ALL & ~nchosen & ~nf
                    ok = False
                    if avail2 == 0:
                        ok = False           # P1 played cross, P2 cannot move => P2 loses
                    else:
                        b = avail2
                        while b:
                            ybit = b & (-b); b ^= ybit
                            zi = ybit.bit_length() - 1
                            nf2 = forbid_after_add(nf, nchosen, zi)
                            if p1_to_move(nchosen | ybit, nf2):
                                ok = True
                                break
                    if not ok:
                        res = False
            memo_p1[chosen] = res
            return res

        # build S={x1,x2} forbidden
        f1 = forbid_after_add(0, 0, x1i)
        chosen1 = 1 << x1i
        f2 = forbid_after_add(f1, chosen1, x2i)
        chosen2 = chosen1 | (1 << x2i)
        return p1_to_move(chosen2, f2)

    # WLOG x1 = (0,0). P2 chooses x2 (=> center c = (x1+x2)/2). P2 wins if SOME x2 works.
    x1 = (0, 0); x1i = idx[x1]
    winning_x2 = []
    f1 = forbid_after_add(0, 0, x1i)
    chosen1 = 1 << x1i
    for x2 in cells:
        x2i = idx[x2]
        if (x2i == x1i) or (f1 >> x2i) & 1:
            continue                              # x2 must be a legal 2nd move
        cr = F.mul(F.add(x1[0], x2[0]), half)
        cc = F.mul(F.add(x1[1], x2[1]), half)
        if search_center(x1i, x2i, cr, cc):
            winning_x2.append((x2, (cr, cc)))

    wins = len(winning_x2) > 0
    print(f"q={q:>2}  N={N:>3}  winning_center_choices={len(winning_x2):>3}  "
          f"-> P2 {'WINS (bulk-forced sigma_c + free cross)' if wins else 'FAILS'}",
          flush=True)
    if verbose and winning_x2:
        for x2, c in winning_x2[:5]:
            print(f"      x2={x2}  center={c}")
    return wins


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7]
    allok = True
    for q in qs:
        allok &= analyze(q, verbose=True)
    print("QODD_BULK_FORCED_DONE" + ("" if allok else "  (SOME FAIL)"))
