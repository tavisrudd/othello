import itertools

V = [1,2,3,4,5,6]
edges = [frozenset(p) for p in itertools.combinations(V,2)]

def matchings_of(vs):
    vs = sorted(vs)
    if not vs: return [frozenset()]
    out=[]
    a = vs[0]
    for b in vs[1:]:
        rest = [v for v in vs if v not in (a,b)]
        for m in matchings_of(rest):
            out.append(m | {frozenset((a,b))})
    return out

PM = matchings_of(V)
print("n perfect matchings:", len(PM))
# each edge in exactly 3 matchings
counts = {e: sum(1 for m in PM if e in m) for e in edges}
print("edge-in-matching counts all 3:", set(counts.values()))

# union of two disjoint PMs is a 6-cycle
def is_6cycle(edgeset):
    adj = {v: [] for v in V}
    for e in edgeset:
        a,b = tuple(e)
        adj[a].append(b); adj[b].append(a)
    if any(len(adj[v])!=2 for v in V): return False
    # traverse
    seen={1}; cur=1; prev=None
    for _ in range(5):
        nxt=[w for w in adj[cur] if w!=prev]
        prev,cur=cur,nxt[0]
        if cur in seen: return False
        seen.add(cur)
    return len(seen)==6 and 1 in adj[cur]

allcyc = True
for m1,m2 in itertools.combinations(PM,2):
    if m1.isdisjoint(m2):
        if not is_6cycle(m1|m2): allcyc=False
print("union of any two disjoint PMs is a 6-cycle:", allcyc)

# one-factorizations of K6
OFs = []
for combo in itertools.combinations(PM,5):
    es = set()
    ok=True
    for m in combo:
        for e in m:
            if e in es: ok=False; break
            es.add(e)
        if not ok: break
    if ok and len(es)==15:
        OFs.append(frozenset(combo))
print("n one-factorizations of K6:", len(OFs))

def M(*pairs): return frozenset(frozenset(p) for p in pairs)

# standard total from the six-cycle labelling p1..p6
F1 = M((1,2),(3,4),(5,6))
F2 = M((1,6),(2,3),(4,5))
# prism = complement of C6(1..6); its one-factorization(s)
C6 = F1 | F2
prism = [e for e in edges if e not in C6]
prismPM = [m for m in PM if all(e in prism for e in m)]
print("perfect matchings of K6 lying inside the prism complement:", len(prismPM))
for m in prismPM: print("  ", sorted(tuple(sorted(e)) for e in m))
prismOF = []
for combo in itertools.combinations(prismPM,3):
    es=set().union(*combo)
    if len(es)==9:
        prismOF.append(combo)
print("one-factorizations of the prism:", len(prismOF))
F = None
for of in OFs:
    if F1 in of and F2 in of:
        F = of
print("one-factorizations of K6 containing both six-cycle factors:", sum(1 for of in OFs if F1 in of and F2 in of))
print("standard total F:")
for m in sorted(F, key=lambda m: sorted(map(sorted,m))):
    print("  ", sorted(tuple(sorted(e)) for e in m))

# Golden module's four matchings
M1 = M((1,2),(3,4),(5,6))
M2 = M((1,4),(2,3),(5,6))
M3 = M((1,3),(2,5),(4,6))
M4 = M((1,4),(2,5),(3,6))
targets=[M1,M2,M3,M4]
print("targets distinct:", len(set(targets))==4)

def apply(sigma, m):
    return frozenset(frozenset(sigma[v] for v in e) for e in m)

good=[]
for perm in itertools.permutations(V):
    sigma = dict(zip(V,perm))
    if all(apply(sigma,t) not in F for t in targets):
        good.append(perm)
print("relabellings sending all four golden matchings off the standard total:", len(good))
if good:
    print("example permutation (p_i -> p_perm[i]):", good[0])
    sigma=dict(zip(V,good[0]))
    for i,t in enumerate(targets,1):
        print(f"  M{i} image:", sorted(tuple(sorted(e)) for e in apply(sigma,t)), "in F?", apply(sigma,t) in F)

# also: how many of the 10 concurrent matchings do the four images use, sanity
conc = [m for m in PM if m not in F]
print("concurrent count:", len(conc))

# check: does EVERY one-factorization admit such a relabelling (equivalently by transitivity)? check all 6
for of in OFs:
    cnt = sum(1 for perm in itertools.permutations(V)
              if all(apply(dict(zip(V,perm)),t) not in of for t in targets))
    print("OF admits", cnt, "good relabellings")
