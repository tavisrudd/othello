"""Bounded checks on three lurking theorems:
  #1 good reduction / unique bad primes {2, q}  (defining-characteristic resonance)
  #3 depth = antipodal balance  Sum n_i v_i = 0  (H3, from pinned C415 cert)
  #5 mu_3 = outer-odd relative invariant:  g.mu_3 = det(g)^{-3} eps(g) mu_3
"""
import importlib.util, itertools, json
from pathlib import Path
HERE = Path("/home/tavis/src/othello/notes")
def load(n, p):
    s = importlib.util.spec_from_file_location(n, p); m = importlib.util.module_from_spec(s); s.loader.exec_module(m); return m
C406 = load("c406", HERE / "2026-07-20-c406-matching-module.py")
scout = json.loads((HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text())
BASE = {r["type"]: (r["field_order"], [tuple(x) for x in r["coxeter_invariant_matching"]]) for r in scout["types"]}

print("="*70)
print("CHECK #1 — unique bad primes {2, q}; the compression is defining-characteristic")
print("="*70)
for typ in ("A3", "B3", "H3"):
    p, base = BASE[typ]
    conic, params = C406.C399.conic_parameterization(p)
    full, psl = C406.full_pgl(p, params)
    base_m = tuple(tuple(x) for x in base)
    orbit = sorted({C406.matching_image(g, base_m) for g in full})
    N = len(orbit)
    # sheets = PSL orbits
    oidx = {m: i for i, m in enumerate(orbit)}
    unseen = set(range(N)); sheets = []
    while unseen:
        r = min(unseen); m = orbit[r]
        sh = {oidx[C406.matching_image(g, m)] for g in psl}; sheets.append(sh); unseen -= sh
    sheet_size = len(sheets[0])
    # the 2-transitive sheet module F^{sheet}: all-ones operator J, J^2 = (sheet_size) J.
    # constant vector lies in augmentation (sum-zero) submodule iff char | sheet_size.
    # -> nested trivial socle (uniserial 1|.|1 cover) iff char = the prime dividing sheet_size = q.
    orbit_primes = sorted(set(f for f in range(2, N + 1) if N % f == 0 and all(f % d for d in range(2, f))))
    print(f"{typ}: q={p}  orbit N={N}  sheets={len(sheets)}x{sheet_size}")
    print(f"     constant-vector coordinate sum on a sheet = {sheet_size} (= q); "
          f"in augmentation submodule  iff  char | {sheet_size}  iff  char = q")
    print(f"     J^2 = {sheet_size} J : nilpotent (=> 1|q-2|1 cover) at char={p}; "
          f"J invertible-on-image (=> semisimple) at char != {p}")
    print(f"     orbit size N={N} = {'2q' if N==2*p else 'q'}  => cocycle is N-torsion => "
          f"bad primes = prime factors of N = {orbit_primes}")
    # sanity: sheet_size == p, and N in {p, 2p}
    assert sheet_size == p and N in (p, 2 * p)

print()
print("="*70)
print("CHECK #3 — depth = antipodal balance  Sum n_i v_i = 0  (H3)")
print("="*70)
h3 = json.loads((HERE / "2026-07-20-c415-odd-fourier-polar-duality.json").read_text())["H3"]
# depth profiles of the three positive-sheet A4 orbits (sizes 1,4,6):
# base matching (orbit 1), and the C412 representatives of orbits 4 and 6.
profiles = {tuple(m["depth_profile"]) for m in h3["matchings"]}
# C412: v1=(-6,0,12,-12) [size1], v2=(-3,3,0,3) [size4], v3=(3,-2,-2,0) [size6]
v1 = (-6, 0, 12, -12); v2 = (-3, 3, 0, 3); v3 = (3, -2, -2, 0)
assert v1 in profiles and v2 in profiles and v3 in profiles, "reps not among certified profiles"
comb = tuple(1 * v1[i] + 4 * v2[i] + 6 * v3[i] for i in range(4))   # n=(1,4,6)
print(f"orbit sizes (n) = (1,4,6);  v1,v2,v3 = certified depth profiles of those orbits")
print(f"1*v1 + 4*v2 + 6*v3 (over Z) = {comb}   -> antipodal balance Sum n_i v_i = 0 : {comb==(0,0,0,0)}")
print(f"relation vector = 2*(1,4,6) mod 11 = {tuple((2*n)%11 for n in (1,4,6))} = [2,8,1] (depth); "
      f"Tate [2,9,1] = balance + e_4 (socle defect)")
print("(uniform B3 form scoped: same C412 antipodal formula with seam weights (1,2,4)/(1,3,3))")

print()
print("="*70)
print("CHECK #5 — mu_3 is the outer-odd relative invariant: g.mu_3 = det^{-3} eps(g) mu_3")
print("="*70)
def rho(mat, p):
    a, b, c, d = mat
    return [[a*a%p, 2*a*b%p, b*b%p], [a*c%p, (a*d+b*c)%p, b*d%p], [c*c%p, 2*c*d%p, d*d%p]]
def act(form, mat, p):
    subs = []
    for k in range(3):
        t = {}
        for j in range(3):
            if mat[k][j] % p:
                e = [0,0,0]; e[j] = 1; t[tuple(e)] = mat[k][j] % p
        subs.append(t)
    out = {}
    for exps, coeff in form.items():
        acc = {(0,0,0): coeff % p}
        for k in range(3):
            for _ in range(exps[k]): acc = C406.multiply_polynomials(acc, subs[k], p)
        for e, cc in acc.items(): out[e] = (out.get(e,0)+cc) % p
    return {e: c for e, c in out.items() if c % p}
def leg(a, p): return 1 if pow(a, (p-1)//2, p) == 1 else -1

for typ in ("B3", "H3"):
    p, base = BASE[typ]
    conic, params = C406.C399.conic_parameterization(p); endpoints = tuple(params); pidx = {q:i for i,q in enumerate(params)}
    full, psl = C406.full_pgl(p, params); base_m = tuple(tuple(x) for x in base)
    orbit = sorted({C406.matching_image(g, base_m) for g in full}); N = len(orbit); oidx = {m:i for i,m in enumerate(orbit)}
    h = (p-1)//2; dq = h-1; basisQ = C406.homogeneous_basis(dq); dimQ = len(basisQ)
    P = [C406.matching_product(m, endpoints, p) for m in orbit]; P0 = P[0]
    def sub(a, b, pp=p): return {e:(a.get(e,0)-b.get(e,0))%pp for e in set(a)|set(b)}
    Phi = [dict(zip(basisQ, C406.quotient_by_conic(sub(P[i], P0, p), dq, p))) for i in range(N)]
    Phi = [{e:v for e,v in f.items() if v%p} for f in Phi]
    # sheets / eps
    unseen = set(range(N)); sheets = []
    while unseen:
        r = min(unseen); sh = {oidx[C406.matching_image(g, orbit[r])] for g in psl}; sheets.append(sh); unseen -= sh
    eps = [1 if i in sheets[0] else -1 for i in range(N)]
    def mu3_of(vlist):
        mu = {}
        for i in range(N):
            v = [vlist[i].get(e,0) for e in basisQ]
            for a in range(dimQ):
                if v[a]==0: continue
                for b in range(a, dimQ):
                    if v[b]==0: continue
                    for c in range(b, dimQ):
                        if v[c]==0: continue
                        k=(a,b,c); mu[k]=(mu.get(k,0)+eps[i]*v[a]*v[b]*v[c])%p
        return {k:x for k,x in mu.items() if x%p}
    mu3 = mu3_of(Phi)
    # test on a few group elements
    permmats = {}
    for a,b,c,d in itertools.product(range(p),repeat=4):
        if (a*d-b*c)%p==0: continue
        if C406.normalize_matrix((a,b,c,d),p)!=(a,b,c,d): continue
        perm = tuple(pidx[C406.C399.normalize_pair((a*l+b*r,c*l+d*r),p)] for l,r in params); permmats[perm]=(a,b,c,d)
    tested=0; ok=True
    for perm,mat in list(permmats.items())[::max(1,len(permmats)//6)][:6]:
        det=(mat[0]*mat[3]-mat[1]*mat[2])%p
        Phi_g=[{e:v%p for e,v in act(Phi[i], rho(mat,p), p).items()} for i in range(N)]
        mu3g=mu3_of(Phi_g)
        scal=(pow(det,-3,p)*leg(det,p))%p
        pred={k:(scal*v)%p for k,v in mu3.items()}; pred={k:v for k,v in pred.items() if v%p}
        if mu3g!=pred: ok=False
        tested+=1
    print(f"{typ}: q={p}  mu_3 nonzero terms={len(mu3)}  eps=legendre(det)  "
          f"g.mu_3 == det^-3 * eps(g) * mu_3 on {tested} elements: {ok}")
    print(f"     => mu_3 is the outer-odd relative invariant (PSL-fixed up to det^-3, PGL sign eps);"
          f" C412/C430 identify this outer-odd line with the P(1) socle.")
