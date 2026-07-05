"""For n = 0 mod 6 (P-positions where negation fails at n/2): extract P2's winning
replies to each P1 opening, and test the 'respond -x except at n/2' hypothesis."""
from sumfree_game import is_sum_free, addable_Zn

def grundy_full(n):
    memo={}
    def g(A):
        r=memo.get(A)
        if r is not None: return r
        elts=[i for i in range(n) if A>>i&1]
        opts=set()
        for x in addable_Zn(A,n,elts):
            opts.add(g(A|(1<<x)))
        m=0
        while m in opts: m+=1
        memo[A]=m
        return m
    return g, memo

for n in [6,12,18]:
    g,_=grundy_full(n)
    half=n//2
    assert g(0)==0, f"n={n} not P!"
    print(f"\n=== n={n} (n/2={half}), P2 winning replies to each P1 opening ===")
    for x in range(1,n):
        if not is_sum_free(1<<x,n): continue
        A=1<<x
        # P2 wants a reply y making g(A|{y})==0
        elts=[x]
        wins=[y for y in addable_Zn(A,n,elts) if g(A|(1<<y))==0]
        neg=(-x)%n
        neg_ok = neg in wins
        tag = f"neg({neg}) wins" if neg_ok else f"neg({neg}) NOT winning"
        print(f"  P1={x:>2}: winning replies={wins}   [{tag}]"
              + ("   <== the n/2 fixed point" if x==half else ""))
print("STRAT_PROBE_DONE")
