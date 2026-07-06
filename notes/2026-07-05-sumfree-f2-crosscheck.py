"""Independent-representation cross-check: the F_2^k sum-free achievement game.

Board = nonzero vectors of F_2^k (integers 1..2^k-1). Legal position = sum-free set
(no x,y,z chosen with x^y == z, i.e. no chosen triple XORing to 0). Move = add a
vector keeping it sum-free. Normal play. This must give the SAME outcome as the
PG(k-1,2) cap game (each projective point = one nonzero vector, each line = {a,b,a^b}).

Completely separate code path from the projective build (no GF, no canon, no line
masks) -> catches bugs in either representation.
"""
import sys

sys.setrecursionlimit(1 << 20)


def solve(k):
    N = (1 << k) - 1            # nonzero vectors 1..2^k-1
    pts = list(range(1, N + 1))  # vector value == its own id
    # forbidden-on-add: adding v to set S forbids, for each s in S, the vector v^s
    # (since {v, s, v^s} would XOR to 0). Precompute nothing; XOR is O(1).
    memo = {}

    def g(chosen_mask, chosen_vecs, forbidden_mask):
        v = memo.get(chosen_mask)
        if v is not None:
            return v
        res = 0
        for v in pts:
            bit = 1 << (v - 1)
            if chosen_mask & bit or forbidden_mask & bit:
                continue
            nf = forbidden_mask
            for s in chosen_vecs:
                w = v ^ s
                if w != 0:
                    nf |= 1 << (w - 1)
            if g(chosen_mask | bit, chosen_vecs + (v,), nf) == 0:
                res = 1
                break
        memo[chosen_mask] = res
        return res

    root = g(0, (), 0)
    return root, N, len(memo)


if __name__ == "__main__":
    ks = eval(sys.argv[1]) if len(sys.argv) > 1 else [2, 3, 4, 5]
    print(f"{'F_2^k':>7} {'=PG':>9} {'N':>4} {'states':>10} {'outcome':>9}")
    for k in ks:
        root, N, st = solve(k)
        outc = "P (2nd)" if root == 0 else "N (1st)"
        print(f"{('F_2^%d' % k):>7} {('PG(%d,2)' % (k - 1)):>9} {N:>4} {st:>10} {outc:>9}",
              flush=True)
    print("SUMFREE_XCHECK_DONE")
