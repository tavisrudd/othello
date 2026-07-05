"""n=0 mod6: is there an S2 'symmetric-with-bounded-defect' P2 strategy?
Compute full Grundy; P2 plays the winning reply MINIMIZING asymmetry |A xor -A|;
measure the max asymmetry reached over the strategy's reachable positions."""
from sumfree_game import is_sum_free, addable_Zn

def neg_mask(A,n):
    B=0; x=A
    while x:
        i=(x&-x).bit_length()-1; x&=x-1
        B|=1<<((-i)%n)
    return B

def analyze(n):
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
    assert g(0)==0
    # simulate: P1 tries ALL moves (adversary); P2 replies with min-asymmetry winning move.
    # track max asymmetry over reachable-under-strategy positions.
    seen=set(); maxasym=[0]
    def asym(A): return bin(A ^ neg_mask(A,n)).count("1")
    def rec(A):  # P2 just moved (or start); P1 to move; A is a P-position
        if A in seen: return
        seen.add(A)
        maxasym[0]=max(maxasym[0], asym(A))
        elts=[i for i in range(n) if A>>i&1]
        for x in addable_Zn(A,n,elts):
            B=A|(1<<x)                # P1's move -> N-position
            # P2 picks winning reply (g==0) minimizing asymmetry
            belts=[i for i in range(n) if B>>i&1]
            reps=[(asym(B|(1<<y)), y) for y in addable_Zn(B,n,belts) if g(B|(1<<y))==0]
            if not reps:  # B terminal (P1 made last move) -> would mean A was N; shouldn't happen
                continue
            reps.sort()
            C=B|(1<<reps[0][1])
            rec(C)
    rec(0)
    return maxasym[0], len(seen)

for n in [6,12,18,24]:
    ma,pos=analyze(n)
    print(f"n={n:>2}: max asymmetry under min-defect P2 strategy = {ma}  "
          f"(reachable P-positions under strategy: {pos})")
print("S2_PROBE_DONE")
