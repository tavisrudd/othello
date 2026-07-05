"""Close the last gap: P2's reply to the n/2 opening. Test whether {n/2, n/3} is a
P-position (so P2 answers n/2 with n/3), and whether after that P2 can negation-mirror
(n/2 = neg fixed point is placed; n/3 played blocks 2n/3, removing the 3x=0 obstruction)."""
from sumfree_game import is_sum_free
from decomp_valid3 import build

def neg(z,n): return (-z)%n

for n in [6,12,18,24,30,36]:
    g=build(n); half=n//2; t3=n//3
    A={half, t3}
    mask=0
    for x in A: mask|=1<<x
    sf = is_sum_free(mask,n)
    gv = g(mask,None) if sf else None
    print(f"n={n}: {{n/2={half}, n/3={t3}}} sum-free={sf}  G={gv}  "
          f"{'P (P2 answers n/2 with n/3 -> win)' if gv==0 else 'NOT a P-position'}")
print("---")
# Verify a full strategy for the n/2 opening: P2 plays n/3, then for P1 move z plays neg(z),
# with the pair {n/3,2n/3} and n/2 as the placed/handled specials. Check validity.
def sim_after_n2n3(n):
    half=n//2; t3=n//3; t23=(2*n)//3
    start=(1<<half)|(1<<t3)
    if not is_sum_free(start,n): return (False,'start not sf')
    seen=set(); ok=[True]; why=[None]
    def rec(A):  # P1 to move; A should be 'balanced' for P2's mirror
        if A in seen: return
        seen.add(A)
        for z in range(1,n):
            if (A>>z)&1: continue
            if not is_sum_free(A|(1<<z),n): continue
            mz=neg(z,n)
            if mz==z or (A>>mz)&1:
                ok[0]=False; why[0]=('no-mate',z,'A=',[i for i in range(n) if A>>i&1]); return
            if not is_sum_free(A|(1<<z)|(1<<mz),n):
                ok[0]=False; why[0]=('mate-illegal',z,mz,'A=',[i for i in range(n) if A>>i&1]); return
            rec(A|(1<<z)|(1<<mz))
            if not ok[0]: return
    rec(start)
    return (ok[0],why[0])

for n in [6,12,18,24,30]:
    ok,why=sim_after_n2n3(n)
    print(f"n={n}: after {{n/2,n/3}}, negation-mirror valid = {ok}" + (f"  break={why}" if not ok else ""))
print("N2_DONE")
