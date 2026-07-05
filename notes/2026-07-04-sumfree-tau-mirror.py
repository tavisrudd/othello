"""n=0 mod6: is P2's translation-by-n/2 mirror tau(z)=z+n/2 a valid strategy?
tau is fixed-point-free (z+n/2=z impossible); pairs {z,z+n/2}; only n/2 is unpaired
(partner 0, unplayable). Check from every tau-invariant reachable position that every
P1 move z != n/2 has a legal mirror z+n/2 keeping the set tau-invariant + sum-free.
Separately track whether n/2 is ever a legal P1 move (the poison to handle)."""
from sumfree_game import is_sum_free

def sim(n):
    half=n//2
    seen=set(); ok=[True]; why=[None]; poison_openings=[]
    def rec(A, depth0):
        if A in seen: return
        seen.add(A)
        for z in range(1,n):
            if (A>>z)&1: continue
            if not is_sum_free(A|(1<<z),n): continue
            if z==half:
                if depth0: poison_openings.append(('n/2 playable at A=',[i for i in range(n) if A>>i&1]))
                continue
            mz=(z+half)%n
            if not is_sum_free(A|(1<<z)|(1<<mz),n):
                ok[0]=False; why[0]=('mate-illegal',z,mz,'A=',[i for i in range(n) if A>>i&1]); return
            rec(A|(1<<z)|(1<<mz), False)
            if not ok[0]: return
    rec(0, True)
    # is n/2 playable in ANY tau-invariant reachable position (not just opening)?
    half_playable_anywhere=False
    for A in seen:
        if not (A>>half)&1 and is_sum_free(A|(1<<half),n):
            half_playable_anywhere=True; break
    return ok[0], why[0], half_playable_anywhere, len(seen)

for n in [6,12,18,24,30]:
    ok,why,hp,ns=sim(n)
    print(f"n={n}: tau-mirror valid (z!=n/2) = {ok}  | n/2 playable in some tau-inv pos = {hp}  "
          f"| tau-inv positions={ns}" + (f"  break={why}" if not ok else ""))
print("TAU_DONE")
