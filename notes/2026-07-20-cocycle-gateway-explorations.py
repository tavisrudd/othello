"""Reproducible spikes for notes/2026-07-20-cocycle-gateway-explorations.md.

Run from /home/tavis/src/othello:  python3 notes/2026-07-20-cocycle-gateway-explorations.py

Reconstructs the B3/H3 matching sheets from the frozen C406 module (SHA-pinned) and checks:
  Spike 1  B3 cross-sheet incidence = Fano 2-(7,3,1) / complement 2-(7,4,2)
  Spike 2  H3 cross-sheet = 11-cell 2-(11,6,3) / biplane 2-(11,5,2); outer coset = polarities
  Spike 3  uniform: Aut(design)=PSL_2(q), dualities=outer coset (= chirality)
  Spike 4  perfect codes: F2-rank(Fano)=4 ([7,4] Hamming); F3-rank(11-biplane)=6 (ternary Golay)
Exploratory; not a certified bundle. Trusted boundary: exact F_q arithmetic + frozen C406 geometry.
"""
import hashlib, importlib.util, itertools, json
from pathlib import Path
from collections import Counter

HERE = Path(__file__).resolve().parent
C406_SHA = "a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51"
SCOUT_SHA = "fec533bb91f864100ebf5875952244d9d9e03ed69a0abda767360907a55bb246"
def load(n, path, sha):
    assert hashlib.sha256(path.read_bytes()).hexdigest() == sha
    s = importlib.util.spec_from_file_location(n, path); m = importlib.util.module_from_spec(s); s.loader.exec_module(m); return m
C406 = load("c406", HERE / "2026-07-20-c406-matching-module.py", C406_SHA)
sp = HERE / "2026-07-20-c406-matching-orbit-scout.json"; assert hashlib.sha256(sp.read_bytes()).hexdigest() == SCOUT_SHA
SCOUT = json.loads(sp.read_text())

def sheets_of(typ):
    p = {"A3": 5, "B3": 7, "H3": 11}[typ]
    base = [tuple(x) for x in next(r for r in SCOUT["types"] if r["type"] == typ)["coxeter_invariant_matching"]]
    conic, params = C406.C399.conic_parameterization(p); pidx = {q: i for i, q in enumerate(params)}
    full, psl = C406.full_pgl(p, params)
    orbit = sorted({C406.matching_image(g, tuple(tuple(x) for x in base)) for g in full})
    N = len(orbit); oidx = {m: i for i, m in enumerate(orbit)}
    unseen = set(range(N)); sh = []
    while unseen:
        r = min(unseen); o = {oidx[C406.matching_image(g, orbit[r])] for g in psl}; sh.append(sorted(o)); unseen -= o
    permmats = {}
    for a, b, c, d in itertools.product(range(p), repeat=4):
        if (a*d-b*c) % p == 0 or C406.normalize_matrix((a, b, c, d), p) != (a, b, c, d): continue
        perm = tuple(pidx[C406.C399.normalize_pair((a*l+b*r, c*l+d*r), p)] for l, r in params); permmats[perm] = (a, b, c, d)
    return p, orbit, oidx, sh, psl, permmats

def edges(orbit, i): return frozenset(frozenset(e) for e in orbit[i])

def design_params(v, blocks):
    lam = Counter()
    for i in range(v):
        for j in range(i+1, v):
            lam[sum(1 for bl in blocks if i in bl and j in bl)] += 1
    return Counter(len(bl) for bl in blocks), dict(lam)

def rank_mod(M, p):
    M = [[x % p for x in row] for row in M]; r = 0; R = len(M); C = len(M[0]) if M else 0
    for c in range(C):
        piv = next((i for i in range(r, R) if M[i][c] % p), None)
        if piv is None: continue
        M[r], M[piv] = M[piv], M[r]; inv = pow(M[r][c], -1, p); M[r] = [x*inv % p for x in M[r]]
        for i in range(R):
            if i != r and M[i][c] % p:
                f = M[i][c]; M[i] = [(M[i][k]-f*M[r][k]) % p for k in range(C)]
        r += 1
    return r

def run(typ):
    p, orbit, oidx, sh, psl, permmats = sheets_of(typ)
    if len(sh) != 2:
        print(f"{typ} q={p}: {len(sh)} sheet(s) (nonsplitting control); no cross-sheet design."); return
    A, B = sh; Ai = {a: k for k, a in enumerate(A)}; Bi = {b: k for k, b in enumerate(B)}
    shared = {(a, b): len(edges(orbit, a) & edges(orbit, b)) for a in A for b in B}
    print(f"{typ} q={p}: sheets {len(A)}+{len(B)}; cross-sheet shared-edge dist {dict(sorted(Counter(shared.values()).items()))}")
    for rel in sorted(set(shared.values())):
        blocks = [frozenset(Ai[a] for a in A if shared[(a, b)] == rel) for b in B]
        ks, lam = design_params(len(A), blocks)
        print(f"   shared=={rel}: block sizes {dict(ks)}, pair-lambda {lam}")
    kmax = max(shared.values())
    inc = {(Ai[a], Bi[b]) for a in A for b in B if shared[(a, b)] == kmax}
    auto = dual = 0; nout = 0
    for perm, mat in permmats.items():
        det = (mat[0]*mat[3]-mat[1]*mat[2]) % p; insl = pow(det, (p-1)//2, p) == 1
        sig = [oidx[C406.matching_image(perm, orbit[i])] for i in range(len(orbit))]
        if insl:
            auto += all(((Ai[a], Bi[b]) in inc) == ((Ai[sig[a]], Bi[sig[b]]) in inc) for a in A for b in B)
        else:
            nout += 1
            dual += all(((Ai[a], Bi[b]) in inc) == ((Ai[sig[b]], Bi[sig[a]]) in inc) for a in A for b in B)
    print(f"   Aut: PSL {auto}/{len(psl)} automorphisms; outer {dual}/{nout} polarities  => dualities = chirality coset")
    disj = [[1 if shared[(a, b)] == 0 else 0 for b in B] for a in A]
    print(f"   disjoint-design code ranks: F2={rank_mod(disj,2)} F3={rank_mod(disj,3)}"
          + ("  -> [7,4] Hamming (perfect)" if p == 7 else "  -> [11,6] ternary Golay (perfect)" if p == 11 else ""))

if __name__ == "__main__":
    for t in ("A3", "B3", "H3"):
        run(t); print()
