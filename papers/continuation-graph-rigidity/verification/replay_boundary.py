"""Independent replay: Python field arithmetic, clique search, and nauty upper bounds."""
import hashlib,json,re,subprocess
from pathlib import Path
from itertools import combinations
from frame_model import model,adjacency,fixed_cliques,census
ROOT=Path(__file__).resolve().parent

def digest(obj):return hashlib.sha256(json.dumps(obj,separators=(',',':')).encode()).hexdigest()

def closure(gens,n):
    identity=tuple(range(n));seen={identity};todo=[identity]
    while todo:
        a=todo.pop()
        for b in gens:
            c=tuple(b[a[i]] for i in range(n))
            if c not in seen:seen.add(c);todo.append(c)
    return seen

def nauty_order(n,edges):
    rows=[[] for _ in range(n)]
    for a,b in edges:rows[a].append(b)
    text='n=%d g\n'%n+';\n'.join(' '.join(map(str,row)) for row in rows)+'.\n-a -m x\nq\n'
    p=subprocess.run(['dreadnaut'],input=text,text=True,capture_output=True,check=True)
    match=re.search(r'grpsize=(\d+);',p.stdout)
    if not match:raise RuntimeError(p.stdout+p.stderr)
    return int(match.group(1))

def main():
    for rec in json.loads((ROOT/'boundary.json').read_text())['records']:
        q=rec['q'];f,pts,words,edges,pencils=model(q);n=len(pts);adj=adjacency(n,edges)
        assert n==rec['vertices'] and len(edges)==rec['edges']
        assert all(a.bit_count()==rec['degree'] for a in adj)
        cliques=list(fixed_cliques(adj,q-3))
        classes,resolutions=census(n,edges,cliques)
        assert digest(cliques)==rec['clique_digest']
        assert digest(classes)==rec['class_digest']
        assert digest(resolutions)==rec['resolution_digest']
        assert len(cliques)==rec['block_cliques'] and len(classes)==rec['parallel_classes'] and len(resolutions)==rec['resolutions']
        expanded=sorted(sorted(sorted(list(cliques[k]) for k in classes[j]) for j in res) for res in resolutions)
        assert expanded==sorted(rec['all_resolutions'])
        if len(expanded)==2:
            left,right=[{tuple(b) for c in res for b in c} for res in expanded]
            assert len(left&right)==rec['shared_resolution_blocks']
        group=closure(rec['generators'],n)
        assert len(group)==rec['automorphism_order']==nauty_order(n,edges)
        edge_set=set(edges);ambient=0;images=set()
        for p in group:
            assert sorted(p)==list(range(n))
            assert {tuple(sorted((p[a],p[b]))) for a,b in edges}==edge_set
            image=sorted(sorted(sorted(p[i] for i in b) for b in c) for c in pencils)
            ambient+=image==pencils;images.add(json.dumps(image))
        assert ambient==rec['ambient_order']==24*f.e
        assert len(images)==rec['resolution_orbit_size']==len(resolutions)
        exotic=rec['exotic_representative']
        if exotic is not None:
            assert tuple(exotic) in group
            assert sorted(sorted(sorted(exotic[i] for i in b) for b in c) for c in pencils)!=pencils
        print('PASS q=%d aut=%d resolutions=%d'%(q,len(group),len(resolutions)),flush=True)

if __name__=='__main__':main()
