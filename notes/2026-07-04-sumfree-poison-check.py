"""Last piece of the n=0 mod6 proof: under the tau-mirror, the only unhandled event is
P1 playing the poison n/2 at a tau-invariant position A. P2 wins overall iff A u {n/2}
is always an N-position (P2-to-move wins). Verify g(A u {n/2}) > 0 for ALL tau-invariant
reachable A where n/2 is playable."""
from sumfree_game import is_sum_free
from decomp_valid3 import build

def tau_invariant_positions(n):
    """all tau-invariant sum-free sets reachable by adding {z,z+n/2} pairs (z!=n/2)."""
    half=n//2; seen=set(); out=[]
    def rec(A):
        if A in seen: return
        seen.add(A); out.append(A)
        for z in range(1,n):
            if (A>>z)&1 or z==half: continue
            if not is_sum_free(A|(1<<z),n): continue
            mz=(z+half)%n
            if is_sum_free(A|(1<<z)|(1<<mz),n):
                rec(A|(1<<z)|(1<<mz))
    rec(0)
    return out

for n in [6,12,18,24,30]:
    g=build(n); half=n//2
    bad=0; checked=0
    for A in tau_invariant_positions(n):
        if not (A>>half)&1 and is_sum_free(A|(1<<half),n):
            checked+=1
            if g(A|(1<<half), None)==0:   # A u {n/2} is P => P2 (to move) LOSES => problem
                bad+=1
    print(f"n={n}: tau-inv positions where n/2 playable checked={checked}  "
          f"A u{{n/2}} that are P (BAD)={bad}  => {'POISON HANDLED (all N)' if bad==0 else 'PROBLEM'}")
print("POISON_DONE")
