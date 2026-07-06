"""Directly verify, in the PROJECTIVE solver, the single-orbit / equal-value facts underlying
the frame reduction:

  * all size-1 positions (points)          have equal game value,
  * all size-2 positions (pairs)           have equal game value,
  * all size-3 positions (triangles)       have equal game value,
  * all size-4 positions (frames/quadrangles, 4 pts in general position) have equal game value,

and the value chain  value(empty)=P <=> ... <=> value(frame)=P.

This is the PGL(3,q)-transitivity input to the reduction, checked exhaustively (not by group
theory) on small q by enumerating representative positions and comparing memoized values.
"""
import sys
from itertools import combinations
from gf import GF
sys.setrecursionlimit(1 << 20)

# reuse the projective builder/solver
import importlib.util
spec = importlib.util.spec_from_file_location("pcf", "2026-07-05-proj-cap-fast.py")
pcf = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pcf)


def check(m, q):
    N, pts, line_mask = pcf.build(m, q)
    pcf.validate_axioms(N, q, line_mask)
    ALL = (1 << N) - 1
    lm = line_mask
    memo = {}

    def g(chosen, forbidden):
        v = memo.get(chosen)
        if v is not None:
            return v
        avail = ALL & ~chosen & ~forbidden
        res = 0
        a = avail
        while a:
            y = a & (-a); a ^= y
            yi = y.bit_length() - 1
            nf = forbidden
            c = chosen
            while c:
                b = c & (-c); c ^= b
                nf |= lm[yi][b.bit_length() - 1]
            if g(chosen | y, nf) == 0:
                res = 1
                break
        memo[chosen] = res
        return res

    def forbidden_of(ptset):
        nf = 0
        pl = list(ptset)
        for a in range(len(pl)):
            for b in range(len(pl)):
                if a != b:
                    nf |= lm[pl[a]][pl[b]]
        return nf

    def is_cap(ptset):
        # a cap iff no point lies on a line through two OTHER points of the set
        pl = list(ptset)
        for p in pl:
            others = [x for x in pl if x != p]
            f = forbidden_of(others)   # lines through pairs of the others
            if (f >> p) & 1:
                return False
        return True

    def value(ptset):
        chosen = 0
        for p in ptset:
            chosen |= 1 << p
        return g(chosen, forbidden_of(ptset))

    root = g(0, 0)

    vals = {1: set(), 2: set(), 3: set(), 4: set()}
    frame_val = None
    # enumerate caps of size k (k<=4) up to a cap check; compare values
    for k in (1, 2, 3, 4):
        for combo in combinations(range(N), k):
            s = set(combo)
            if k >= 2 and not is_cap(s):
                continue
            v = value(s)
            vals[k].add(v)
            if k == 4 and frame_val is None:
                frame_val = v

    ok = all(len(vals[k]) == 1 for k in (1, 2, 3, 4))
    chain = (root == frame_val)
    print(f"PG({m},{q})  root={'P' if root==0 else 'N'}  "
          f"size1={sorted(vals[1])} size2={sorted(vals[2])} "
          f"size3(tri)={sorted(vals[3])} size4(frame)={sorted(vals[4])}  "
          f"single-orbit(1..4): {ok}  root==frame: {chain}", flush=True)
    return ok and chain


if __name__ == "__main__":
    cases = eval(sys.argv[1]) if len(sys.argv) > 1 else [(2, 3), (2, 4), (2, 5)]
    allok = True
    for (m, q) in cases:
        allok &= check(m, q)
    print("FRAME_ORBIT_VERIFY_DONE", "ALL_OK" if allok else "FAILED")
