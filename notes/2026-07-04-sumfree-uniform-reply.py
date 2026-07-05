"""n=0 mod6: is there a UNIFORM winning reply y(x) to every opening {x}?
Test candidate reply-rules; a rule that always yields a winning (P-reaching) reply
would essentially prove {x} is N for all x -> G(empty)=0."""
from sumfree_game import addable_Zn, is_sum_free
from decomp_valid3 import build

def test(n):
    g=build(n)
    def winreplies(x):
        B=1<<x
        return set(y for y in addable_Zn(B,n,[x]) if g(B|(1<<y),None)==0)
    xs=[x for x in range(1,n) if is_sum_free(1<<x,n)]
    wr={x:winreplies(x) for x in xs}
    rules={
        "2x":   lambda x:(2*x)%n,
        "4x":   lambda x:(4*x)%n,
        "-2x":  lambda x:(-2*x)%n,
        "-x":   lambda x:(-x)%n,
        "x+n/2":lambda x:(x+n//2)%n,
        "x+n/3":lambda x:(x+n//3)%n,
        "5x":   lambda x:(5*x)%n,
        "-4x":  lambda x:(-4*x)%n,
    }
    out=[]
    for name,r in rules.items():
        ok=0; bad=0; badx=[]
        for x in xs:
            y=r(x)
            if y in wr[x]: ok+=1
            else: bad+=1; badx.append((x,y))
        out.append((name, ok, bad, badx[:4]))
    return len(xs), out

for n in [12,18,24,30]:
    nx,out=test(n)
    print(f"\nn={n} ({nx} openings):")
    for name,ok,bad,badx in sorted(out,key=lambda t:t[2]):
        flag="  <== UNIFORM WIN" if bad==0 else ""
        print(f"   rule {name:>6}: wins {ok}/{nx}  fails {bad} {badx if bad else ''}{flag}")
print("UNIFORM_DONE")
