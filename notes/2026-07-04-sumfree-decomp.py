from sumfree_game import addable_Zn
from collections import deque

def components(A, n, L):
    Lset=set(L); Aset=set(i for i in range(n) if A>>i&1)
    adj={x:set() for x in L}
    Ll=list(L)
    def tie(a,b):
        if a!=b: adj[a].add(b); adj[b].add(a)
    for i in range(len(Ll)):
        for j in range(i, len(Ll)):
            p=Ll[i]; q=Ll[j]; r=(p+q)%n
            if r in Lset:                       # live 3-edge
                tie(p,q); tie(p,r); tie(q,r)
            elif r in Aset:                      # p+q lands in A
                tie(p,q)
            if p!=q and (((p-q)%n in Aset) or ((q-p)%n in Aset)):  # a+q=p
                tie(p,q)
            if q==(2*p)%n or p==(2*q)%n:         # doubling
                tie(p,q)
    seen=set(); comps=[]
    for x in L:
        if x in seen: continue
        st=[x]; c=set()
        while st:
            v=st.pop()
            if v in seen: continue
            seen.add(v); c.add(v); st.extend(adj[v]-seen)
        comps.append(frozenset(c))
    return comps

def build(n):
    memo={}
    def g(A, allowed):
        key=(A,allowed); r=memo.get(key)
        if r is not None: return r
        elts=[i for i in range(n) if A>>i&1]
        L=addable_Zn(A,n,elts)
        if allowed is not None: L=[x for x in L if x in allowed]
        opts=set()
        for x in L: opts.add(g(A|(1<<x), allowed))
        m=0
        while m in opts: m+=1
        memo[key]=m; return m
    return g

for n in [12,18,24,30]:
    g=build(n)
    reach=set([0]); dq=deque([0]); dchecked=0; mism=0
    while dq:
        A=dq.popleft()
        elts=[i for i in range(n) if A>>i&1]
        L=addable_Zn(A,n,elts)
        if len(L)>=2:
            comps=components(A,n,L)
            if len(comps)>=2:
                direct=g(A,None); xored=0
                for c in comps: xored^=g(A,c)
                dchecked+=1
                if direct!=xored:
                    mism+=1
                    if mism<=3: print(f"  n={n} MISMATCH A={elts} direct={direct} xor={xored} comps={[sorted(c) for c in comps]}")
        for x in L:
            B=A|(1<<x)
            if B not in reach: reach.add(B); dq.append(B)
    print(f"n={n}: decomposed positions={dchecked}  valid={dchecked-mism}  MISMATCH={mism}"
          + ("   *** VALID ***" if mism==0 else ""))
print("VALID3_DONE")
