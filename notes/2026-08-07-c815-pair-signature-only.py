"""Are the three-anchor-point tests of the aligned query family redundant?

The normalized seven-point data of the aligned-design decoder is a triple of
cuts in `Fin 8` and a triple of outside-edge bits, so 4096 configurations.  The
selected query family splits into the tests meeting the four-point anchor in
three points, whose answers are the `anchorSignature` words, and those meeting
it in two, whose answers are the `pairSignature` words.  These are the Lean
definitions of `RelativeConicArcs.AlignedTwoGraph`, transcribed here.

The full signature is injective, which is the content of
`RelativeConicArcs.AlignedTwoGraph.normalizedSevenSignature_injective`.  This
script asks whether the pair signatures alone are already injective, that is
whether the 4(n-4) three-anchor-point tests could be dropped from the count
3n^2-23n+45.  Run it with `python3` and read the two summary lines.
"""
def cutbit(p, i):
    return False if i == 3 else bool((p >> i) & 1)

def anchor_sig(p):
    idx = [(1,2,3),(0,2,3),(0,1,3),(0,1,2)]
    return tuple((cutbit(p,a)==cutbit(p,b)) and (cutbit(p,b)==cutbit(p,c))
                 for a,b,c in idx)

def pair_aligned(p,s,e,i,j):
    return ((cutbit(p,i)^cutbit(s,i)) == (cutbit(p,j)^cutbit(s,j))) and \
           (e == (cutbit(p,j)^cutbit(s,i)))

PAIRS=[(0,1),(0,2),(0,3),(1,2),(1,3),(2,3)]
def pair_sig(p,s,e):
    return tuple(pair_aligned(p,s,e,i,j) for i,j in PAIRS)

OUT=[(0,1),(0,2),(1,2)]
def full_sig(d):
    cut, edge = d
    return (tuple(anchor_sig(cut[x]) for x in range(3)),
            tuple(pair_sig(cut[a], cut[b], edge[q]) for q,(a,b) in enumerate(OUT)))

def pair_only_sig(d):
    cut, edge = d
    return tuple(pair_sig(cut[a], cut[b], edge[q]) for q,(a,b) in enumerate(OUT))

data=[((c0,c1,c2),(e0,e1,e2))
      for c0 in range(8) for c1 in range(8) for c2 in range(8)
      for e0 in (False,True) for e1 in (False,True) for e2 in (False,True)]
for name, f in (("full", full_sig), ("pair-only", pair_only_sig)):
    seen={}
    coll=[]
    for d in data:
        k=f(d)
        if k in seen: coll.append((seen[k], d))
        else: seen[k]=d
    print(f"{name}: {len(data)} data, {len(seen)} distinct signatures, {len(coll)} collisions")
    for a,b in coll[:6]: print("   ", a, b)
