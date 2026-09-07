"""Generate the bounded boundary certificate using Sage; --check is read-only."""
import argparse,json,hashlib
from pathlib import Path
from itertools import combinations
from collections import Counter
from sage.all import GF,Graph,PolynomialRing,matrix,PermutationGroup
from frame_model import model,census
ROOT=Path(__file__).resolve().parent

def digest(obj):return hashlib.sha256(json.dumps(obj,separators=(',',':')).encode()).hexdigest()

def generate():
    records=[]
    for q in (5,7,8,9,11,13):
        f,points,words,edges,pencils=model(q)
        if f.e==1:sf=GF(q)
        else:
            r=PolynomialRing(GF(f.p),'z');sf=GF(q,'a',modulus=r(list(f.mod)))
        def element(i):return sum(sf(a)*sf.gen()**j for j,a in enumerate(f.digits(i))) if f.e>1 else sf(i)
        # Independent geometric construction, with determinant incidence rather than word agreement.
        frame=[(1,0,0),(0,1,0),(0,0,1),(1,1,1)]
        geom=[]
        for i,j in combinations(range(len(points)),2):
            x,y=points[i];u,v=points[j]
            if any(matrix(sf,[(element(x),element(y),1),(element(u),element(v),1),t]).det()==0 for t in frame):geom.append((i,j))
        assert geom==edges
        g=Graph([range(len(points)),geom],format='vertices_and_edges')
        group=g.automorphism_group(algorithm='sage')
        maximal=g.cliques_maximal()
        cliques=sorted(set(tuple(c) for m in maximal for c in combinations(sorted(m),q-3)))
        classes,resolutions=census(len(points),edges,cliques)
        actual=[sorted([sorted(cliques[i]) for i in classes[j]]) for j in range(len(classes))]
        resolutions_expanded=[sorted(actual[j] for j in res) for res in resolutions]
        assert pencils in resolutions_expanded
        # Deterministic generating set, independent of the backend's generator choices.
        identity=tuple(range(len(points)));known={identity};gens=[]
        for perm in sorted(tuple(int(p(i)) for i in range(len(points))) for p in group):
            if perm in known:continue
            gens.append(list(perm));todo=list(known)
            while todo:
                a=todo.pop()
                for b in gens:
                    c=tuple(b[a[i]] for i in range(len(points)))
                    if c not in known:known.add(c);todo.append(c)
        ambient=[];exotic=[]
        for p in group:
            perm=[int(p(i)) for i in range(len(points))]
            image=sorted(sorted(sorted(perm[i] for i in b) for b in c) for c in pencils)
            (ambient if image==pencils else exotic).append(perm)
        assert len(ambient)==24*f.e
        orbit=set()
        for p in group:
            orbit.add(json.dumps(sorted(sorted(sorted(int(p(i)) for i in b) for b in c) for c in pencils)))
        record=dict(q=q,vertices=len(points),edges=len(edges),degree=4*(q-4),
          automorphism_order=int(group.order()),ambient_order=len(ambient),
          generators=gens,exotic_representative=min(exotic) if exotic else None,
          maximal_clique_counts={str(k):v for k,v in sorted(Counter(map(len,maximal)).items())},
          block_cliques=len(cliques),parallel_classes=len(classes),resolutions=len(resolutions),
          resolution_orbit_size=len(orbit),clique_digest=digest(cliques),
          class_digest=digest(classes),resolution_digest=digest(resolutions),
          all_resolutions=resolutions_expanded)
        if len(resolutions_expanded)==2:
            left,right=[{tuple(b) for c in res for b in c} for res in resolutions_expanded]
            record['shared_resolution_blocks']=len(left&right)
        records.append(record)
        print('q=%d aut=%d classes=%d resolutions=%d'%(q,group.order(),len(classes),len(resolutions)),flush=True)
    return dict(schema='continuation-boundary-v1',field_models={'8':'F2[a]/(a^3+a+1)','9':'F3[a]/(a^2+1)'},records=records)

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--check',action='store_true');args=ap.parse_args()
    data=json.dumps(generate(),indent=2,sort_keys=True)+'\n';path=ROOT/'boundary.json'
    if args.check:assert path.read_text()==data,'boundary certificate drift'
    else:path.write_text(data)
