"""N-side proof: for n=2,4 mod6, does P1 win by opening n/2 then negation-mirroring?
(n/2 is self-symmetric => position stays symmetric; 3 does not divide n => the only
mirror obstruction is the fixed point n/2, which is now already played.)"""
from sumfree_game import is_sum_free

def sim_p1_open_half(n):
    half=n//2
    if not is_sum_free(1<<half,n):
        return (False,'n/2 not playable')
    seen=set(); ok=[True]; why=[None]
    def rec(A):  # symmetric, contains half, P2 to move
        if A in seen: return
        seen.add(A)
        for x in range(1,n):
            if (A>>x)&1: continue
            if not is_sum_free(A|(1<<x),n): continue   # P2 plays x
            mx=(-x)%n
            if mx==x:                                   # P1 can't mirror (fixed pt)
                ok[0]=False; why[0]=('fixed-pt',x); return
            if not is_sum_free(A|(1<<x)|(1<<mx),n):
                ok[0]=False; why[0]=('mate-illegal',x,mx); return
            rec(A|(1<<x)|(1<<mx))
            if not ok[0]: return
    rec(1<<half)
    return (ok[0],why[0])

for n in range(8,33):
    if n%6 in (2,4):
        ok,why=sim_p1_open_half(n)
        print(f"n={n:>2} mod6={n%6} (N): P1 open-{n//2}+mirror wins={ok}"
              + (f"  break={why}" if not ok else ""))
print("NSIDE_DONE")
