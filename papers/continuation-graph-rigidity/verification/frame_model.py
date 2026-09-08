"""Standard-library reference model and finite exact-cover enumerator."""
from itertools import combinations

class Field:
    def __init__(self,q):
        self.q=q
        extensions={8:(2,3,(1,1,0,1)),9:(3,2,(1,0,1)),
                    16:(2,4,(1,1,0,0,1)),25:(5,2,(2,0,1))}
        if q in extensions:
            self.p,self.e,self.mod=extensions[q]
        elif q>=2 and all(q%d for d in range(2,int(q**0.5)+1)):
            self.p,self.e,self.mod=q,1,(0,1)
        else:
            raise ValueError('reference field model supports primes and orders 8,9,16,25')
    def digits(self,x):
        return [(x//self.p**i)%self.p for i in range(self.e)]
    def encode(self,v):return sum((x%self.p)*self.p**i for i,x in enumerate(v))
    def add(self,x,y):return self.encode([a+b for a,b in zip(self.digits(x),self.digits(y))])
    def neg(self,x):return self.encode([-a for a in self.digits(x)])
    def sub(self,x,y):return self.add(x,self.neg(y))
    def mul(self,x,y):
        v=[0]*(2*self.e-1)
        for i,a in enumerate(self.digits(x)):
            for j,b in enumerate(self.digits(y)):v[i+j]+=a*b
        for k in range(len(v)-1,self.e-1,-1):
            for j in range(self.e):v[k-self.e+j]-=v[k]*self.mod[j]
        return self.encode(v[:self.e])
    def power(self,x,k):
        r=1
        while k:
            if k&1:r=self.mul(r,x)
            x=self.mul(x,x);k//=2
        return r
    def div(self,x,y):
        if not y:raise ZeroDivisionError
        return self.mul(x,self.power(y,self.q-2))

def model(q, *, field=None):
    f=Field(q) if field is None else field
    if f.q!=q:raise ValueError("supplied field order mismatch")
    points=[(x,y) for x in range(2,q) for y in range(2,q) if x!=y]
    words=[(x,y,f.div(x,y),f.div(f.sub(x,1),f.sub(y,1))) for x,y in points]
    edges=[(i,j) for i,j in combinations(range(len(points)),2) if any(a==b for a,b in zip(words[i],words[j]))]
    pencils=[sorted([i for i,w in enumerate(words) if w[c]==a] for a in range(2,q)) for c in range(4)]
    pencils=sorted(pencils)
    return f,points,words,edges,pencils

def exact_covers(masks,universe):
    incidence={i:[] for i in range(universe.bit_length())}
    for j,m in enumerate(masks):
        for i in incidence:
            if m>>i&1:incidence[i].append(j)
    def visit(left,chosen):
        if not left:
            yield tuple(sorted(chosen));return
        best=None
        for i in incidence:
            if left>>i&1:
                choices=[j for j in incidence[i] if masks[j]&left==masks[j]]
                if not choices:return
                if best is None or len(choices)<len(best):best=choices
                if len(best)==1:break
        for j in best:yield from visit(left^masks[j],chosen+[j])
    yield from visit(universe,[])

def adjacency(n,edges):
    out=[0]*n
    for a,b in edges:out[a]|=1<<b;out[b]|=1<<a
    return out

def fixed_cliques(adj,size):
    def visit(chosen,remaining):
        if len(chosen)==size:
            yield tuple(chosen);return
        while remaining:
            if remaining.bit_count()<size-len(chosen):return
            bit=remaining&-remaining;remaining^=bit;i=bit.bit_length()-1
            yield from visit(chosen+[i],remaining&adj[i])
    yield from visit([],(1<<len(adj))-1)

def census(n,edges,cliques):
    masks=[sum(1<<i for i in c) for c in cliques]
    classes=sorted(exact_covers(masks,(1<<n)-1))
    edgeids={p:i for i,p in enumerate(edges)}
    emasks=[sum(1<<edgeids[p] for p in combinations(c,2)) for c in cliques]
    pmasks=[sum(emasks[j] for j in c) for c in classes]
    resolutions=sorted(exact_covers(pmasks,(1<<len(edges))-1))
    return classes,resolutions
