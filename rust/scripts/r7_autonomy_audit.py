#!/usr/bin/env python3
"""Frozen boundary-local autonomy audit for round 7.

Q before labels is:
  * the live two-defect incompatibility graph and deck involution;
  * the round-6 tau color on each live vertex;
  * an ordered marked cross-defect pair x,y (and their deck mates);
  * all rank-3 trace rows incident with those four marked-fiber vertices,
    restricted to the old two-line boundary.

The last family is encoded by a 4-bit ternary incidence tensor.  It is kept
explicitly even though collinearity on the two old defect lines makes it
redundant with the side/mark colors.  P/N fields in the existing cohort artifacts
are never inspected or joined.
"""

from collections import Counter, defaultdict
from itertools import combinations, permutations
import os, sys

ROOT = "/home/tavis/src/othello/rust"
sys.path.insert(0, os.path.join(ROOT, "scripts"))
import r5_q11_voltage_signature as R
import r6_attachment_bit as A


def cross(u, v, q):
    return ((u[1]*v[2]-u[2]*v[1]) % q,
            (u[2]*v[0]-u[0]*v[2]) % q,
            (u[0]*v[1]-u[1]*v[0]) % q)


def dot(l, p, q):
    return sum(x*y for x,y in zip(l,p)) % q


def matvec(M, p, q):
    return tuple(sum(M[i][j]*p[j] for j in range(3)) % q for i in range(3))


def canon_matrix(M, q):
    z = next(x % q for row in M for x in row if x % q)
    iz = R.inv(z,q)
    return tuple(tuple(x*iz % q for x in row) for row in M)


def projective_points(q):
    pts = set()
    for x in range(q):
        for y in range(q):
            for z in range(q):
                if x or y or z:
                    pts.add(R.norm((x,y,z),q))
    assert len(pts) == q*q+q+1
    return tuple(sorted(pts))


def is_cap(T, q):
    return len(set(T)) == len(T) and all(R.det(x,y,z,q) for x,y,z in combinations(T,3))


def legal(p, T, q):
    return p not in T and all(R.det(p,x,y,q) for x,y in combinations(T,2))


def status(p, T, q):
    if p in T: return "S"
    return "L" if legal(p,T,q) else "D"


def pairings(items):
    if not items:
        yield ()
        return
    a = items[0]
    for i in range(1,len(items)):
        b = items[i]
        for tail in pairings(items[1:i]+items[i+1:]):
            yield ((a,b),)+tail


def homology_rebases(T, q, PG):
    """All cap-stabilizing 2-fixed/3-swapped homologies with no legal fixed point."""
    found = {}
    ids = tuple(range(8))
    for ia,ib in combinations(ids,2):
        ell = cross(T[ia],T[ib],q)
        rest = tuple(i for i in ids if i not in (ia,ib))
        for pairs in pairings(rest):
            c = cross(cross(T[pairs[0][0]],T[pairs[0][1]],q),
                      cross(T[pairs[1][0]],T[pairs[1][1]],q),q)
            if c == (0,0,0) or dot(ell,c,q) == 0:
                continue
            ec = dot(ell,c,q)
            M = tuple(tuple((ec*(i==j)-2*c[i]*ell[j]) % q for j in range(3))
                      for i in range(3))
            M = canon_matrix(M,q)
            ok = True
            for i,j in pairs:
                if R.norm(matvec(M,T[i],q),q) != T[j] or R.norm(matvec(M,T[j],q),q) != T[i]:
                    ok=False; break
            if not ok: continue
            if any(R.norm(matvec(M,T[i],q),q) != T[i] for i in (ia,ib)):
                continue
            fixed = [p for p in PG if R.norm(matvec(M,p,q),q)==p]
            if any(legal(p,T,q) for p in fixed):
                continue
            assert len(fixed) == q+2
            assert canon_matrix(tuple(tuple(sum(M[i][k]*M[k][j] for k in range(3)) % q
                                             for j in range(3)) for i in range(3)),q) == \
                   ((1,0,0),(0,1,0),(0,0,1))
            found[M] = ((ia,ib), c, ell)
    return [(M,*found[M]) for M in sorted(found)]


def old_boundary(U,a,q):
    C=lambda t:R.norm((t*t,t,1),q)
    T=(C(0),) + tuple(C(u) for u in U) + (R.norm((-a,0,1),q),)
    # Tuple construction above intentionally orders C0,U,za.
    pts={}
    for p in range(q):
        pts.setdefault(R.norm((0,1,p),q),set()).add("0")
        pts.setdefault(R.norm((-a*p,1,p),q),set()).add("a")
    pts.setdefault(C(0),set()).add("0")
    pts.setdefault(R.norm((-a,0,1),q),set()).add("a")
    return T, pts, (lambda P:R.norm((P[0],-P[1],P[2]),q))


def tau_colors(T, locations, deck, q):
    points=sorted(locations); idx={p:i for i,p in enumerate(points)}
    st=[status(p,T,q) for p in points]
    rel=[[0]*len(points) for _ in points]
    for i,p in enumerate(points):
        if st[i]=="S": continue
        for j in range(i+1,len(points)):
            w=points[j]
            if st[j]!="S" and any(R.det(p,w,s,q)==0 for s in T):
                rel[i][j]|=1; rel[j][i]|=1
    for i,p in enumerate(points):
        j=idx[deck(p)]; rel[i][j]|=2; rel[j][i]|=2
    tau={}
    for i,p in enumerate(points):
        if st[i]!="L": continue
        side=next(iter(locations[p]))
        full=set()
        for k,w in enumerate(points):
            if st[k]!="D" or len(locations[w])!=1 or next(iter(locations[w]))==side: continue
            wm=deck(w); km=idx[wm]
            if w!=wm and st[km]=="D" and (rel[i][k]&1) and (rel[i][km]&1):
                full.add(tuple(sorted((w,wm))))
        tau[p]=len(full)%2
    return points,st,rel,tau


def input_Q(U,a,x,y,q):
    T,loc,deck=old_boundary(U,a,q)
    points,st,rel,tau=tau_colors(T,loc,deck,q)
    live=[p for p,s in zip(points,st) if s=="L"]
    marks=(x,deck(x),y,deck(y))
    colors=[]
    for p in live:
        side=next(iter(loc[p]))
        tag=tuple(i for i,m in enumerate(marks) if p==m)
        colors.append((side,tau[p],tag))
    old={p:i for i,p in enumerate(points)}
    lr=[[rel[old[p]][old[w]] for w in live] for p in live]
    # For each marked-fiber lift m and unordered triple m,u,v of distinct live
    # boundary vertices, retain the rank-3 row indicator.  Encode as a symmetric
    # pair label K[u,v] with bit i for m_i.  A rank-3 row is simply collinearity,
    # because all vertices are disjoint from T.
    K=[[0]*len(live) for _ in live]
    for i,m in enumerate(marks):
        for j,u in enumerate(live):
            for k in range(j+1,len(live)):
                v=live[k]
                if len({m,u,v})==3 and R.det(m,u,v,q)==0:
                    K[j][k]|=1<<i; K[k][j]|=1<<i
    # Combine binary live relations and ternary-row pair labels.
    rr=[[lr[i][j] | (K[i][j]<<2) for j in range(len(live))]
        for i in range(len(live))]
    return (colors,rr),T


def output_Q(T,M,fixed,c,ell,q,PG):
    ia,ib=fixed; A0,A1=T[ia],T[ib]
    locations={}
    for p in PG:
        if R.det(c,A0,p,q)==0: locations.setdefault(p,set()).add("0")
        if R.det(c,A1,p,q)==0: locations.setdefault(p,set()).add("a")
    deck=lambda p:R.norm(matvec(M,p,q),q)
    points,st,rel,tau=tau_colors(T,locations,deck,q)
    live=[p for p,s in zip(points,st) if s=="L"]
    old={p:i for i,p in enumerate(points)}
    colors=[]
    for p in live:
        assert len(locations[p])==1
        colors.append((next(iter(locations[p])),tau[p]))
    rr=[[rel[old[p]][old[w]] for w in live] for p in live]
    return colors,rr


def classify(graph, reps):
    for i,r in enumerate(reps):
        if R.isomorphic(graph,r): return i
    reps.append(graph); return len(reps)-1


def cap_key8(T,q):
    """PGL key for old six-set plus ordered marks x,y."""
    old=T[:6]; x,y=T[6],T[7]
    best=None
    for order in permutations(range(8),4):
        P=[T[i] for i in order]
        cols=tuple(tuple(P[j][i] for j in range(3)) for i in range(3))
        try: inv=R.inverse3(cols,q)
        except AssertionError: continue
        coeff=R.matrix_vector(inv,P[3],q)
        if not all(coeff): continue
        diag=tuple(R.inv(z,q) for z in coeff)
        def image(p):
            v=R.matrix_vector(inv,p,q)
            return R.norm(tuple(diag[i]*v[i]%q for i in range(3)),q)
        key=(tuple(sorted(image(p) for p in old)),image(x),image(y))
        if best is None or key<best: best=key
    assert best is not None
    return best


def audit(q):
    PG=projective_points(q)
    _,rows,_=R.geometry_records(q,all_frames=True,live_only=True)
    states={}
    for row in rows: states.setdefault((row["U"],row["a"]),row)
    in_reps=[]; out_reps=[]; transitions=[]
    reb_counts=Counter(); pair_count=0
    for si,(U,a) in enumerate(sorted(states)):
        T,loc,deck=old_boundary(U,a,q)
        assert is_cap(T,q)
        side0=sorted(p for p,L in loc.items() if L=={"0"} and legal(p,T,q))
        sidea=sorted(p for p,L in loc.items() if L=={"a"} and legal(p,T,q))
        for x in side0:
            for y in sidea:
                if not is_cap(T+(x,y),q): continue
                pair_count+=1
                iq,_=input_Q(U,a,x,y,q); iid=classify(iq,in_reps)
                T8=T+(x,y)
                reb=homology_rebases(T8,q,PG); reb_counts[len(reb)]+=1
                pkey=cap_key8(T8,q)
                outs=[]
                for M,fixed,c,ell in reb:
                    oq=output_Q(T8,M,fixed,c,ell,q,PG)
                    # Fixed points are unordered: allow the global side swap.
                    swapped=([( "a" if z[0]=="0" else "0",)+z[1:] for z in oq[0]],oq[1])
                    oid=classify(oq,out_reps)
                    # Merge with an earlier swapped orientation if needed.
                    for j,r in enumerate(out_reps):
                        if R.isomorphic(swapped,r): oid=min(oid,j); break
                    outs.append(oid)
                transitions.append(dict(U=U,a=a,x=x,y=y,iid=iid,outs=tuple(sorted(set(outs))),
                                        nreb=len(reb),pkey=pkey))
    # Normalize output ids under side-swap equivalence a second time.
    # (The first pass can introduce equivalent representatives in opposite order.)
    classes=[]; remap={}
    for i,g in enumerate(out_reps):
        sw=([("a" if z[0]=="0" else "0",)+z[1:] for z in g[0]],g[1])
        for j,r in enumerate(classes):
            if R.isomorphic(g,r) or R.isomorphic(sw,r): remap[i]=j; break
        else: remap[i]=len(classes); classes.append(g)
    for t in transitions: t["outs"]=tuple(sorted({remap[o] for o in t["outs"]}))
    by_input=defaultdict(list)
    for t in transitions: by_input[t["iid"]].append(t)
    bad=[]
    for iid,ts in by_input.items():
        outcomes={t["outs"] for t in ts}
        if len(outcomes)>1: bad.append((iid,ts))
    merged=[]
    for iid,ts in by_input.items():
        ks={t["pkey"] for t in ts}
        if len(ks)>1: merged.append((iid,len(ks),len(ts)))
    print(f"q={q} cohort_rows={len(rows)} normalized_states={len(states)} transitions={len(transitions)} "
          f"input_Q_classes={len(in_reps)} output_Q_classes={len(classes)}")
    print(f"q={q} rebase_count_hist={dict(sorted(reb_counts.items()))}")
    print(f"q={q} autonomy_colliding_input_classes={len(bad)} "
          f"Q_merges_marked_PGL_orbits={len(merged)} max_orbits_merged={max([m[1] for m in merged] or [1])}")
    if bad:
        iid,ts=bad[0]
        byout={}
        for t in ts: byout.setdefault(t["outs"],t)
        a,b=list(byout.values())[:2]
        def brief(t): return (t["U"],t["a"],t["x"],t["y"],t["nreb"],t["outs"])
        print(f"FIRST_AUTONOMY_COLLISION input_Q={iid} A={brief(a)} B={brief(b)}")
        ga,_=input_Q(a["U"],a["a"],a["x"],a["y"],q)
        gb,_=input_Q(b["U"],b["a"],b["x"],b["y"],q)
        mapping=R.isomorphic(ga,gb,want_mapping=True)
        assert mapping is not None
        print(f"  INPUT_ISOMORPHISM={tuple(sorted(mapping.items()))} "
              f"rank3_pair_entries_A={sum((ga[1][i][j]>>2)!=0 for i in range(len(ga[0])) for j in range(i+1,len(ga[0])))} "
              f"rank3_pair_entries_B={sum((gb[1][i][j]>>2)!=0 for i in range(len(gb[0])) for j in range(i+1,len(gb[0])))} "
              f"same_marked_PGL_orbit={'YES' if a['pkey']==b['pkey'] else 'NO'}")
        for name,t in (("A",a),("B",b)):
            T0,_,_=old_boundary(t["U"],t["a"],q); T8=T0+(t["x"],t["y"])
            desc=[]
            for M,fixed,c,ell in homology_rebases(T8,q,PG):
                og=output_Q(T8,M,fixed,c,ell,q,PG)
                desc.append((len(og[0]),tuple(sorted(Counter(og[0]).items())),
                             sum(bool(og[1][i][j]&1) for i in range(len(og[0]))
                                 for j in range(i+1,len(og[0])))))
            print(f"  OUTPUT_DETAIL_{name}=live_vertices,color_counts,I_edges {tuple(desc)}")
        for iid,ts in bad:
            uniq=[t for t in ts if t["nreb"]==1]
            uouts={t["outs"] for t in uniq}
            print(f"  BAD input_Q={iid} transitions={len(ts)} rebase_hist={dict(Counter(t['nreb'] for t in ts))} "
                  f"outcomes={sorted({t['outs'] for t in ts})} unique_only_outcomes={sorted(uouts)}")
            if len(uouts)>1:
                uby={}
                for t in uniq: uby.setdefault(t["outs"],t)
                ua,ub=list(uby.values())[:2]
                print(f"FIRST_UNIQUE_REBASE_COLLISION input_Q={iid} A={brief(ua)} B={brief(ub)}")
    if merged: print(f"FIRST_PGL_MERGE input_Q={merged[0][0]} marked_orbits={merged[0][1]} transitions={merged[0][2]}")
    return not bad and all(t["nreb"]==1 for t in transitions)


def main():
    print("FROZEN_Q live_signed_boundary+tau+ordered_marked_fibers+boundary_restricted_incident_rank3")
    ok11=audit(11)
    ok13=audit(13)
    if ok11 and ok13: audit(17)
    else: print("q=17 SKIPPED_BY_PREDECLARED_SURVIVOR_GATE")

if __name__=="__main__": main()
