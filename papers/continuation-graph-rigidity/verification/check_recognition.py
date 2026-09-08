"""Deterministic relabelling, rejection and transport checks; optional Sage timings."""
import argparse,json,random,time,platform
from pathlib import Path
from frame_model import Field,model,adjacency
from recognize import recognize,verify_transport
ROOT=Path(__file__).resolve().parent

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--benchmark',action='store_true');ap.add_argument('--update-certificate',action='store_true');args=ap.parse_args();records=[];certificates=[]
    assert not (args.benchmark and args.update_certificate)
    if args.benchmark:
        from sage.all import Graph
        from sage.version import version as sage_version
    orders=(13,17,19) if args.benchmark else (9,11,13,16,17,19,25)
    for q in orders:
        field,points,_,edges,_=model(q);n=len(points)
        permutation=list(range(n));random.Random(20260907+q).shuffle(permutation)
        shuffled=sorted(tuple(sorted((permutation[a],permutation[b]))) for a,b in edges)
        adj=adjacency(n,shuffled)
        start=time.perf_counter();result=recognize(adj,field=field);elapsed=time.perf_counter()-start
        assert result is not None and result[0]==q and verify_transport(adj,*result)
        bad=list(result[1]);bad[0]=bad[1];assert not verify_transport(adj,q,bad)
        cloned=[a|((1<<n) if (a&1 or i==0) else 0) for i,a in enumerate(adj)]+[adj[0]|1]
        assert not verify_transport(cloned,q,result[1]+[result[1][0]])
        # Relabelled witness must fail on a genuinely changed graph.
        corrupted=adj.copy();a,b=shuffled[0];corrupted[a]^=1<<b;corrupted[b]^=1<<a
        assert recognize(corrupted) is None and not verify_transport(corrupted,*result)
        # Degree-preserving switch exercises rejection beyond the degree precheck.
        switched=adj.copy();found=False
        for a,b in shuffled:
            for c,d in shuffled:
                if len({a,b,c,d})==4 and not (adj[a]>>c&1 or adj[b]>>d&1):
                    for x,y in ((a,b),(c,d),(a,c),(b,d)):switched[x]^=1<<y;switched[y]^=1<<x
                    found=True;break
            if found:break
        assert found and recognize(switched) is None
        if field.e>1:
            # Frobenius transports are nonidentity field automorphisms, even
            # though their vertex permutations preserve the original graph.
            index={point:i for i,point in enumerate(points)}
            frobenius=[index[(field.power(x,field.p),field.power(y,field.p))] for x,y in points]
            assert frobenius!=list(range(n))
            assert sorted(tuple(sorted((frobenius[a],frobenius[b]))) for a,b in edges)==edges
            twisted=[(field.power(x,field.p),field.power(y,field.p)) for x,y in result[1]]
            assert twisted!=result[1] and verify_transport(adj,q,twisted,field=field)
        if args.benchmark:
            g=Graph([range(n),edges],format='vertices_and_edges');h=Graph([range(n),shuffled],format='vertices_and_edges')
            start=time.perf_counter();ok,transport=g.is_isomorphic(h,certificate=True);generic=time.perf_counter()-start
            assert ok
            records.append(dict(q=q,vertices=n,seed=20260907+q,reconstruction_seconds=elapsed,generic_isomorphism_seconds=generic))
        certificates.append(dict(q=q,seed=20260907+q,coordinates=result[1],frobenius_checked=field.e>1))
        print('PASS recognition q=%d; relabelling, witness mutation, edge deletion, degree-preserving switch'%q,flush=True)
    if not args.benchmark:
        # A genuinely different supplied model must be used throughout;
        # silently constructing Field(16) inside a helper would fail this test.
        supplied=Field(16);supplied.mod=(1,0,0,1,1)  # x^4+x^3+1
        _,points,_,edges,_=model(16,field=supplied)
        adj=adjacency(len(points),edges)
        assert verify_transport(adj,16,points,field=supplied)
        assert not verify_transport(adj,16,points)  # different multiplication
        result=recognize(adj,field=supplied)
        assert result is not None and verify_transport(adj,*result,field=supplied)
        assert recognize(adj,field=Field(9)) is None
        assert not verify_transport(adj,16,points,field=Field(9))
        print('PASS supplied alternate F16 model and field-order mismatch',flush=True)
        data=dict(schema='continuation-recognition-v1',records=certificates,
                  alternate_f16=dict(modulus=list(supplied.mod),coordinates=result[1]))
        payload=json.dumps(data,sort_keys=True,separators=(',',':'))+'\n'
        path=ROOT/'recognition.json'
        if args.update_certificate:path.write_text(payload)
        else:assert path.read_text()==payload,'recognition certificates changed'

    if args.benchmark:
        (ROOT/'benchmark.json').write_text(json.dumps(dict(schema='continuation-benchmark-v1',python=platform.python_version(),sage=sage_version,scope='single-run wall times; graph construction excluded; no speedup claim',records=records),indent=2,sort_keys=True)+'\n')
if __name__=='__main__':main()
