"""When s=2y-a in D, is (y,1) always illegal? If so, WHICH triple blocks it?
Enumerate sigma-sym (star)-valid D, and for slots y with 2y-a in D, test (y,1)
legality; when illegal, report the specific violating triple.
"""
from itertools import product
from collections import Counter

def build(b):
    V=list(product(range(3),repeat=b)); Z=tuple([0]*b)
    def sub(x,y): return tuple((x[i]-y[i])%3 for i in range(b))
    def smul(c,x): return tuple((c*x[i])%3 for i in range(b))
    def add(x,y): return tuple((x[i]+y[i])%3 for i in range(b))
    return V,Z,add,sub,smul

def star_ok(eps):
    Dset=set(eps)
    for v in eps:
        for w in eps:
            u=tuple((v[i]+w[i])%3 for i in range(len(v)))
            if u in Dset and (eps[v]+eps[w]+eps[u])%2!=1:
                return False
    return True

def find_viol_triple(eps):
    # return a violating triple (v,w,u) with v+w=u and even sum, or None
    Dset=set(eps)
    for v in eps:
        for w in eps:
            u=tuple((v[i]+w[i])%3 for i in range(len(v)))
            if u in Dset and (eps[v]+eps[w]+eps[u])%2==0:
                return (v,w,u)
    return None

def run(b,a):
    V,Z,add,sub,smul=build(b)
    base={Z:1, a:0}
    def mate(v): return sub(a,v)
    seen=set(); pairs=[]
    for v in V:
        key=frozenset({v,mate(v)})
        if key not in seen:
            seen.add(key); pairs.append((v,mate(v)))
    positions=[]
    def dfs(eps, idx):
        positions.append(dict(eps))
        for j in range(idx,len(pairs)):
            v,mv=pairs[j]
            if v in eps or v==mv: continue
            for lv in (0,1):
                ne=dict(eps); ne[v]=lv; ne[mv]=1-lv
                if star_ok(ne): dfs(ne,j+1)
    dfs(base,0)

    ell1_legal_with_s=0
    block_shapes=Counter()
    tested=0
    for eps in positions:
        for y in V:
            if y in eps: continue
            s=sub(smul(2,y),a)   # s = 2y - a
            if s not in eps: continue
            tested+=1
            ne=dict(eps); ne[y]=1
            if star_ok(ne):
                ell1_legal_with_s+=1
            else:
                tr=find_viol_triple(ne)
                # classify the blocking triple relative to {y,s,a,0,s*}
                sstar=sub(a,s)
                names={y:'y', s:'s', a:'a', Z:'0', sstar:'s*'}
                v,w,u=tr
                shape=tuple(sorted([names.get(v,'?'),names.get(w,'?')]))+ (names.get(u,'?'),)
                block_shapes[shape]+=1
    print(f"b={b} a={a}: tested(s in D)={tested}  (y,1)-legal-with-s={ell1_legal_with_s}")
    print(f"   blocking-triple shapes {{v,w}}->u (names y,s,a,0,s*):")
    for sh,c in block_shapes.most_common():
        print(f"      {sh}: {c}")

if __name__=="__main__":
    for b in (2,3):
        V,Z,add,sub,smul=build(b)
        run(b, tuple([1]+[0]*(b-1)))
