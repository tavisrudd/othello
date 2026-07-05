"""Search structured involutions tau(h,i) = (Mh + a, c - i) as move-then-mirror
strategies for the coprime peel HxZp. Open tau's fixed point; mirror by tau.
Test which (if any) win, over all opponent lines.

H part options: sigma_H (h -> -oH - h, reflect through socle center oH),
                negation (h -> -h).
Zp part: i -> c - i for c in Z_p (affine reflections), and i -> i (identity).
"""
from itertools import product

def make(Hmods, p):
    mods=tuple(Hmods)+(p,); n=len(mods)
    def add(x,y): return tuple((x[k]+y[k])%mods[k] for k in range(n))
    def neg(x):   return tuple((-x[k])%mods[k] for k in range(n))
    ELTS=[t for t in product(*[range(m) for m in mods])]
    Z=tuple(0 for _ in mods); NZ=[x for x in ELTS if x!=Z]
    def is_sf(A):
        S=set(A)
        for a in A:
            for b in A:
                if add(a,b) in S: return False
        return True
    def order(x):
        c=1;y=x
        while y!=Z:y=add(y,x);c+=1
        return c
    hn=len(Hmods)
    return add,neg,ELTS,Z,NZ,is_sf,order,mods,hn

def test_tau(Hmods,p,tau,fixpts,label):
    add,neg,ELTS,Z,NZ,is_sf,order,mods,hn=make(Hmods,p)
    # tau: element->element (must be an involution with the given fixpts)
    for x in ELTS: assert tau(tau(x))==x, ("not involution",label)
    realfix=[x for x in ELTS if tau(x)==x]
    nzfix=[x for x in realfix if x!=Z]
    if len(nzfix)!=1:
        return None, f"{label}: {len(nzfix)} nonzero fixed pts (need exactly 1 to open)"
    o=nzfix[0]
    if not is_sf({o}): return None,f"{label}: opening not sum-free"
    seen={}
    def opp(A):
        if A in seen: return seen[A]
        S=set(A)
        for y in NZ:
            if y in S: continue
            if is_sf(A|{y}):
                w=tau(y)
                if w==y or w in S or not is_sf(A|{y,w}):
                    seen[A]=False; return False
                if not opp(frozenset(A|{y,w})): seen[A]=False; return False
        seen[A]=True; return True
    r=opp(frozenset({o}))
    return r, f"{label}: open o={o}(ord{order(o)}) -> {'WINS' if r else 'FAILS'}"

def run(Hmods,p):
    add,neg,ELTS,Z,NZ,is_sf,order,mods,hn=make(Hmods,p)
    # socle center oH in H (order-3 element of H, embedded with Zp=0)
    Hsocle=[x for x in ELTS if x[-1]==0 and order(x)==3]
    oH = Hsocle[0] if Hsocle else [x for x in ELTS if x[-1]==0 and x!=Z][0]
    oHh = oH[:hn]
    def sigmaH_part(h): return tuple((-oHh[k]-h[k])%mods[k] for k in range(hn))
    def negH_part(h):   return tuple((-h[k])%mods[k] for k in range(hn))
    print(f"### H={Hmods} x Z{p}, socle center oH={oH}")
    for Hname,Hpart in [("sigmaH",sigmaH_part),("negH",negH_part)]:
        for c in range(p):
            def tau(x,Hpart=Hpart,c=c):
                h=x[:hn]; i=x[-1]
                return Hpart(h)+((c-i)%p,)
            r,msg=test_tau(Hmods,p,tau,None,f"tau=({Hname}, c-i c={c})")
            if True:
                print("   ",msg)
    print()

for Hmods,p in [((3,),5),((3,),7),((3,3),5)]:
    run(Hmods,p)
