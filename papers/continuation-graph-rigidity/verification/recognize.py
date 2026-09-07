"""Certified frame recognition for the field models provided by frame_model.

The mathematical algorithm works over any supplied finite field. This reference
implementation supports prime fields and the explicit extension fields below.
"""
from math import isqrt
from frame_model import Field,adjacency,fixed_cliques

def members(mask):
    while mask:
        bit=mask&-mask;mask^=bit;yield bit.bit_length()-1

def closed_common(adj,seed):
    common=(1<<len(adj))-1
    for i in seed:common&=adj[i]
    return common|sum(1<<i for i in seed)

def is_clique(adj,mask):
    return all((adj[i]|(1<<i))&mask==mask for i in members(mask))

def verify_transport(adj,q,coordinates):
    f=Field(q)
    expected={(x,y) for x in range(2,q) for y in range(2,q) if x!=y}
    if len(coordinates)!=len(adj) or len(coordinates)!=len(expected) or set(coordinates)!=expected:return False
    if any(a<0 or a>>len(adj) for a in adj):return False
    words=[(x,y,f.div(x,y),f.div(f.sub(x,1),f.sub(y,1))) for x,y in coordinates]
    for i in range(len(adj)):
        if adj[i]>>i&1:return False
        for j in range(i):
            same=any(a==b for a,b in zip(words[i],words[j]))
            if bool(adj[i]>>j&1)!=same or bool(adj[j]>>i&1)!=same:return False
    return True

def recognize(adj):
    """Return (q, coordinate transport) or None. Does not consult source labels."""
    n=len(adj);root=isqrt(1+4*n)
    if root*root!=1+4*n or (5+root)%2:return None
    q=(5+root)//2
    if q<13:return None
    try:f=Field(q)
    except ValueError:return None
    if any(a>>n or a>>i&1 or a.bit_count()!=4*(q-4) for i,a in enumerate(adj)):return None
    if any(bool(adj[i]>>j&1)!=bool(adj[j]>>i&1) for i in range(n) for j in range(i)):return None
    traces=set()
    for seed in fixed_cliques(adj,4):
        b=closed_common(adj,seed)
        if b.bit_count()==q-3 and is_clique(adj,b):traces.add(b)
    traces=sorted(traces)
    if len(traces)!=4*(q-2):return None
    disjoint=[sum(1<<j for j,b in enumerate(traces) if i!=j and not a&b) for i,a in enumerate(traces)]
    classes=set()
    for seed in fixed_cliques(disjoint,5):
        c=closed_common(disjoint,seed)
        if c.bit_count()==q-2 and is_clique(disjoint,c):classes.add(c)
    classes=sorted(classes)
    if len(classes)!=4 or sum(c.bit_count() for c in classes)!=(sum(classes)).bit_count():return None
    parts=[[traces[j] for j in members(c)] for c in classes]
    ids=[]
    for part in parts:
        assignment=[None]*n
        for j,b in enumerate(part):
            for v in members(b):
                if assignment[v] is not None:return None
                assignment[v]=j
        if None in assignment:return None
        ids.append(assignment)
    m=q-2;identity=m
    def missing(first,second):
        ans=[]
        for a in range(m):
            seen={second[v] for v in range(n) if first[v]==a}
            absent=set(range(m))-seen
            if len(absent)!=1:return None
            ans.append(absent.pop())
        return ans if len(set(ans))==m else None
    row_missing_col=missing(ids[0],ids[1]);row_missing_symbol=missing(ids[0],ids[2])
    if row_missing_col is None or row_missing_symbol is None:return None
    col_to_row={c:r for r,c in enumerate(row_missing_col)}
    symbol_to_row={s:r for r,s in enumerate(row_missing_symbol)}
    div=[[None]*(m+1) for _ in range(m+1)]
    for v in range(n):
        a=ids[0][v];b=col_to_row[ids[1][v]];c=symbol_to_row[ids[2][v]]
        if a==b or div[a][b] is not None:return None
        div[a][b]=c
    for a in range(m):div[a][a]=identity;div[a][identity]=a
    div[identity][identity]=identity
    for b in range(m):
        absent=set(range(m))-{div[a][b] for a in range(m) if a!=b}
        if len(absent)!=1:return None
        div[identity][b]=absent.pop()
    if any(None in row for row in div):return None
    inv=div[identity]
    powers=None;order=q-1
    for t in range(m):
        trial=[identity]
        for _ in range(order-1):trial.append(div[trial[-1]][inv[t]])
        if len(set(trial))!=order or div[trial[-1]][inv[t]]!=identity:continue
        if all(div[trial[i]][trial[j]]==trial[(i-j)%order] for i in range(order) for j in range(order)):
            powers=trial;break
    if powers is None:return None
    for w in range(2,q):
        wp=[f.power(w,i) for i in range(order)]
        if len(set(wp))!=order:continue
        labels=dict(zip(powers,wp))
        coordinates=[(labels[ids[0][v]],labels[col_to_row[ids[1][v]]]) for v in range(n)]
        values={};valid=True
        for v,(x,y) in enumerate(coordinates):
            z=f.div(f.sub(x,1),f.sub(y,1));c=ids[3][v]
            if c in values and values[c]!=z:valid=False;break
            values[c]=z
        if valid and len(set(values.values()))==m and verify_transport(adj,q,coordinates):return q,coordinates
    return None
