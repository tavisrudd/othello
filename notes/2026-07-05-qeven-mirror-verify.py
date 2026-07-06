r"""Verify the q-even planar theorem's STRATEGY (not just outcome): the translation
mirror really is a winning P2 strategy on PG(2,q), q even.

P2 fixes an affine model: opening a,b on the line at infinity L; residual = affine
plane AG(2,q) = PG(2,q)\L with two burned directions a,b. P2 picks translation vector
v with direction(v) not in {a,b}, and replies x+v to every P1 affine move x.

This script exhaustively checks, by DFS over ALL P1 play sequences, that:
  (1) P2's reply x+v is ALWAYS legal (never creates a collinear triple / burned pair);
  (2) the game always ends on P2's move (P1 is the one who runs out) -> P2 wins.
If both hold for every P1 line, the mirror is a verified winning strategy.

Affine model of PG(2,q): points (x,y) in F_q^2 are the affine points; the line at
infinity L carries the q+1 directions. A P1/P2 move is an affine point. Constraints in
the residual game (from handoff R2), for a chosen set S of affine points:
  - no 3 of S collinear (affine),                                  [cap]
  - no 2 of S on a common line of direction a,                     [burned dir a]
  - no 2 of S on a common line of direction b.                     [burned dir b]
Directions are slopes in F_q u {inf}. We choose a=inf (vertical), b=0 (horizontal) WLOG
(PGL is transitive on pairs of directions), and v with slope not in {inf,0}, e.g. v=(1,1).
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def slope(F, dx, dy):
    # direction of vector (dx,dy) in F_q^2, as 'inf' or field element dy/dx
    if dx == 0:
        return 'inf'
    return F.mul(dy, F.inv(dx))


def collinear(F, p, q_, r):
    # affine collinearity: (q-p) parallel to (r-p)
    ux, uy = F.sub(q_[0], p[0]), F.sub(q_[1], p[1])
    wx, wy = F.sub(r[0], p[0]), F.sub(r[1], p[1])
    # cross product ux*wy - uy*wx == 0
    return F.sub(F.mul(ux, wy), F.mul(uy, wx)) == 0


def verify(q):
    F = GF(q)
    pts = list(product(range(q), repeat=2))       # affine points
    A_dir, B_dir = 'inf', 0                        # two burned directions
    v = (1 % q, 1 % q)                             # translation vector, slope 1 (not inf/0)
    assert slope(F, v[0], v[1]) not in (A_dir, B_dir)

    def legal_to_add(S, p):
        # is S ∪ {p} a legal residual position?  (p not already in S)
        if p in S:
            return False
        for s in S:
            # burned-direction pair check
            d = slope(F, F.sub(p[0], s[0]), F.sub(p[1], s[1]))
            if d == A_dir or d == B_dir:
                return False
        # collinear-triple check: any two existing s,t with p
        Sl = list(S)
        for i in range(len(Sl)):
            for j in range(i + 1, len(Sl)):
                if collinear(F, p, Sl[i], Sl[j]):
                    return False
        return True

    def mirror(p):
        return (F.add(p[0], v[0]), F.add(p[1], v[1]))

    # DFS over all P1 sequences; P2 always mirrors. Verify invariants.
    bad = {'illegal_reply': 0, 'p2_stuck': 0}
    seen = set()

    def dfs(S):
        key = frozenset(S)
        if key in seen:
            return
        seen.add(key)
        # P1 to move (S is P2-symmetric). Try every legal P1 move.
        moved = False
        for p in pts:
            if not legal_to_add(S, p):
                continue
            moved = True
            r = mirror(p)
            S1 = S | {p}
            # (1) reply must be legal
            if not legal_to_add(S1, r):
                bad['illegal_reply'] += 1
                continue
            S2 = S1 | {r}
            dfs(S2)
        # if P1 has no move, game ended on a P2 move (or empty): P2 made last move -> P2 wins.
        # nothing to check here; the win follows from every reply being legal (P2 always answers).

    dfs(frozenset())
    ok = (bad['illegal_reply'] == 0)
    print(f"q={q:>2}  positions={len(seen):>7}  illegal_replies={bad['illegal_reply']:>3}  "
          f"-> {'MIRROR WINS (verified)' if ok else 'MIRROR FAILS'}", flush=True)
    return ok


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [2, 4, 8]
    allok = True
    for q in qs:
        allok &= verify(q)
    print("QEVEN_MIRROR_VERIFY_DONE" + ("" if allok else "  (FAILURE)"))
