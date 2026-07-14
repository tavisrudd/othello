"""C116 opt-a: external-point tau-spectrum at q=81 (and 243) via ILP.
Confirm axis prediction tau_axis = q - cap_3(h); pin TO/RC/IC closed forms.
Edges computed by projecting C from rep x and taking image-collinear triples (vectorized 3x3 det).
M = max no-3-collinear subset (ILP); tau = (q+1) - M."""
import itertools, sys
import numpy as np
import galois
import pulp

CAP3 = {1: 2, 2: 4, 3: 9, 4: 20, 5: 45, 6: 112}

def max_indep_3unif(nverts, edges, solver=None):
    prob = pulp.LpProblem('mis', pulp.LpMaximize)
    xs = [pulp.LpVariable(f'v{i}', cat='Binary') for i in range(nverts)]
    prob += pulp.lpSum(xs)
    for (a, b, c) in edges:
        prob += xs[a] + xs[b] + xs[c] <= 2
    prob.solve(solver or pulp.PULP_CBC_CMD(msg=0))
    return int(round(pulp.value(prob.objective)))

def run(q, chunk=400000):
    GF = galois.GF(q)
    p, h = int(GF.characteristic), int(GF.degree)
    field = list(GF.elements)
    print(f"=== q={q} (h={h}), q+1={q+1}, cap_3(h)={CAP3.get(h)}, predict axis tau={q-CAP3[h]} ===")
    rows = [[1, int(t), int(t*t), int(t*t*t)] for t in field] + [[0, 0, 0, 1]]
    P = GF(rows); n = P.shape[0]
    triples = np.array(list(itertools.combinations(range(n), 3)), dtype=np.int64)
    I, J, K = triples[:, 0], triples[:, 1], triples[:, 2]

    def edges_and_incidence(xtuple):
        x = GF(list(xtuple))
        Phi = GF([x]).null_space()             # 3x4, ker = <x>
        Img = (Phi @ P.T).T                     # (n,3)
        a, b, c = Img[:, 0], Img[:, 1], Img[:, 2]
        mask = np.zeros(len(triples), dtype=bool)
        for s in range(0, len(triples), chunk):
            i, j, k = I[s:s+chunk], J[s:s+chunk], K[s:s+chunk]
            det = (a[i]*(b[j]*c[k]-b[k]*c[j])
                   - b[i]*(a[j]*c[k]-a[k]*c[j])
                   + c[i]*(a[j]*b[k]-a[k]*b[j]))
            mask[s:s+chunk] = np.asarray(det == 0)
        # distinct-image count (type)
        seen = set()
        for row in Img:
            v = [int(t) for t in row]
            f = next((t for t in v if t != 0), None)
            seen.add((0,0,0) if f is None else tuple(int(GF(t)*GF(f)**-1) for t in v))
        return mask, len(seen)

    def canonify(vec):
        v = [int(a) for a in vec]; f = next((a for a in v if a != 0), 1)
        inv = int(GF(f)**-1); return tuple(int(GF(a)*GF(inv)) for a in v)
    cubic_set = set(canonify(P[i]) for i in range(n))
    axis_pts = set([(0,0,1,0)] + [(0,1,int(s),0) for s in field])

    inc_target = {'TO': q*(q-3)//6, 'RC': q*(q-1)//6, 'IC': q*(q+1)//6}
    reps = {'axis': (0,0,1,0)}    # nucleus
    # find TO/RC/IC by incidence among chart0 samples
    need = {'TO', 'RC', 'IC'}
    for a in field:
        if not need: break
        for b in field:
            if not need: break
            for c in field:
                cx = canonify(GF([1,int(a),int(b),int(c)]))
                if cx in cubic_set or cx in axis_pts: continue
                mask, ndi = edges_and_incidence(cx)
                inc = int(mask.sum())
                for name in list(need):
                    if inc == inc_target[name]:
                        reps[name] = cx; need.discard(name); break
                if not need: break

    print(f"  orbit  rep                    inc      #img   M    tau")
    for name in ['TO', 'RC', 'IC', 'axis']:
        if name not in reps:
            print(f"  {name}: no rep found"); continue
        mask, ndi = edges_and_incidence(reps[name])
        edges = [tuple(triples[idx]) for idx in np.nonzero(mask)[0]]
        M = max_indep_3unif(n, edges)
        tau = n - M
        flag = ''
        if name == 'axis':
            flag = 'OK' if tau == q - CAP3[h] else f'MISMATCH(pred {q-CAP3[h]})'
        print(f"  {name:5s}  {str(reps[name]):20s} {int(mask.sum()):6d} {ndi:6d}  {M:4d} {tau:4d}  {flag}")
    print()

if __name__ == '__main__':
    for q in (int(x) for x in sys.argv[1:]) if len(sys.argv) > 1 else [81]:
        run(q)
