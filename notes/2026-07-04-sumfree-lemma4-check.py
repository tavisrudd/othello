"""Verify the mechanism behind the augmented negation mirror (Lemma 4):
in the {n/2,n/3}-mirror, the ONLY way responder's w=-z could create a violation is
w = t + b (b in C), which needs z = 2t - b; but then z+t = -b in C (since 3t=0), so z
is ILLEGAL. Confirm: over all reachable tau/mirror positions C and all b in C, z=2t-b is
never a legal attacker move (i.e. C u {z} is never sum-free for z=2t-b, z not in C)."""
from sumfree_game import is_sum_free
def neg(z,n): return (-z)%n

def check(n):
    m=n//2; t=n//3; t2=(2*n)//3
    # enumerate reachable {m,t}-mirror positions C
    seen=set(); bad=0; total_dangerous=0
    def rec(A):
        if A in seen: return
        seen.add(A)
        C=[i for i in range(n) if A>>i&1]
        # for each b in C, z=2t-b: is it a legal attacker move? (should be NO)
        for b in C:
            z=(t2-b)%n
            if z==0 or (A>>z)&1: continue
            if is_sum_free(A|(1<<z),n):   # z legal AND dangerous => would break mirror
                total_dangerous+= (1 if (neg(z,n)==(t+b)%n) else 0)
                # check if it's actually the dangerous w=t+b case
                if neg(z,n)==(t+b)%n:
                    bad+=1
        for z in range(1,n):
            if (A>>z)&1 or z in (m,t,t2): continue
            if not is_sum_free(A|(1<<z),n): continue
            w=neg(z,n)
            if is_sum_free(A|(1<<z)|(1<<w),n):
                rec(A|(1<<z)|(1<<w))
    rec((1<<m)|(1<<t))
    return bad, len(seen)

for n in [6,12,18,24,30,36]:
    bad,ns=check(n)
    print(f"n={n}: reachable {{n/2,n/3}}-mirror positions={ns}  legal-dangerous-z (mirror-breakers)={bad}"
          f"  => {'MECHANISM HOLDS (0 breakers)' if bad==0 else 'BREAKS'}")
print("L4_DONE")
