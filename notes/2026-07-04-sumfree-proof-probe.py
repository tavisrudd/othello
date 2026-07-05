"""Proof exploration for the mod-6 law: does the 2nd player win P-positions via the
negation mirror x->-x?  Characterize the break points."""
from sumfree_game import is_sum_free, addable_Zn

def sim_negation_mirror(n):
    """Second player strategy: respond to x with -x. Return True if it is a valid
    winning strategy against ALL first-player play (via full search of P1's moves).
    Position kept symmetric. Returns (works, first_break_reason)."""
    # We verify: from every symmetric sum-free set A reachable under the mirror, for
    # every P1 move x, the reply -x is legal and A u {x,-x} is sum-free & symmetric,
    # AND -x != x (fixed point) -- if -x==x the mirror fails.
    from functools import lru_cache
    def elts(A): return [i for i in range(n) if A>>i&1]
    seen=set()
    ok=[True]; reason=[None]
    def rec(A):  # A symmetric sum-free, P1 to move
        if A in seen: return
        seen.add(A)
        adds=[x for x in range(1,n) if not (A>>x&1) and is_sum_free(A|(1<<x),n)]
        for x in adds:
            mx=(-x)%n
            if mx==x:
                ok[0]=False; reason[0]=('fixed-point',x,'A=',elts(A)); return
            B=A|(1<<x)
            if not is_sum_free(B|(1<<mx),n):
                ok[0]=False; reason[0]=('reply-illegal',x,'mate',mx,'A=',elts(A)); return
            C=B|(1<<mx)
            rec(C)
            if not ok[0]: return
    rec(0)
    return ok[0], reason[0]

for n in range(4,26):
    cls='P' if n%6 in (0,1,5) else 'N'
    works,reason=sim_negation_mirror(n)
    print(f"n={n:>2} mod6={n%6} law={cls}: negation-mirror valid={works}"
          + (f"  break={reason}" if not works else ""))
print("PROOF_PROBE_DONE")
