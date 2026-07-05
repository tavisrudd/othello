"""n=3 mod6 (N): does P1 win by opening n/3 then negation-mirroring? (n odd => no n/2
fixed point; opening n/3 blocks 2n/3, removing the 3x=0 obstruction => negation valid.)"""
from sumfree_game import is_sum_free
def neg(z,n): return (-z)%n
def sim_open_n3(n):
    t3=n//3
    start=1<<t3
    if not is_sum_free(start,n): return (False,'n/3 not playable')
    seen=set(); ok=[True]; why=[None]
    def rec(A):   # P2 to move (P1 is the mirrorer/responder)
        if A in seen: return
        seen.add(A)
        for z in range(1,n):
            if (A>>z)&1: continue
            if not is_sum_free(A|(1<<z),n): continue
            mz=neg(z,n)
            if mz==z or (A>>mz)&1:
                ok[0]=False; why[0]=('no-mate',z,'A=',[i for i in range(n) if A>>i&1]); return
            if not is_sum_free(A|(1<<z)|(1<<mz),n):
                ok[0]=False; why[0]=('mate-illegal',z,mz); return
            rec(A|(1<<z)|(1<<mz))
            if not ok[0]: return
    rec(start)
    return (ok[0],why[0])
for n in [9,15,21,27,33]:
    ok,why=sim_open_n3(n)
    print(f"n={n} (mod6={n%6}, N): P1 open-n/3({n//3})+negation-mirror wins = {ok}"
          + (f"  break={why}" if not ok else ""))
print("N3_DONE")
