"""C115 opt-b v2: nail the reduction + axis cap-set closed form; classify TO/RC/IC type.

  tau(x) = (q+1) - M(x).  Axis rep (0,1,0,0) projects out x1 -> cuspidal v^2=u^3,
  cusp at t=0, additive coord phi(t)=1/t (phi(inf)=0): 3 smooth collinear <=> sum 1/t_i = 0.
  => M_axis = cap_3(h) + 1 (cusp always addable), tau_axis = q - cap_3(h).
"""
import itertools
import numpy as np
import galois
import pulp

CAP3 = {1: 2, 2: 4, 3: 9, 4: 20, 5: 45, 6: 112}  # max cap in AG(h,3)

def max_indep_3unif(nverts, edges):
    prob = pulp.LpProblem('mis', pulp.LpMaximize)
    xs = [pulp.LpVariable(f'v{i}', cat='Binary') for i in range(nverts)]
    prob += pulp.lpSum(xs)
    for (a, b, c) in edges:
        prob += xs[a] + xs[b] + xs[c] <= 2
    prob.solve(pulp.PULP_CBC_CMD(msg=0))
    sel = [i for i in range(nverts) if xs[i].value() and xs[i].value() > 0.5]
    return len(sel), sel

def run(q, mode='full'):
    GF = galois.GF(q)
    p, h = int(GF.characteristic), int(GF.degree)
    field = list(GF.elements)
    print(f"=== q={q} (p={p}, h={h}), q+1={q+1}, cap_3(h)={CAP3.get(h)} ===")

    rows, labels = [], []
    for t in field:
        rows.append([1, int(t), int(t*t), int(t*t*t)]); labels.append(('t', t))
    rows.append([0, 0, 0, 1]); labels.append(('inf', None))
    P = GF(rows); n = P.shape[0]

    triples = list(itertools.combinations(range(n), 3))
    N = GF([[int(a) for a in P[[i, j, k], :].null_space()[0]] for (i, j, k) in triples])

    def edges_through(x):
        z = np.asarray((N @ x) == 0)
        return [triples[idx] for idx in np.nonzero(z)[0]]
    def incidence(x):
        return int(np.count_nonzero(np.asarray((N @ x) == 0)))

    def canonify(vec):
        v = [int(a) for a in vec]
        first = next((a for a in v if a != 0), 0)
        inv = int(GF(first) ** -1)
        return tuple(int(GF(a) * GF(inv)) for a in v)

    cubic_set = set(canonify(P[i]) for i in range(n))
    axis_pts = set([(0, 0, 1, 0)] + [(0, 1, int(s), 0) for s in field])

    # projection-collapse count: #distinct images of C under pi_x (Phi = x-perp)
    def n_distinct_images(x):
        Phi = GF([x]).null_space()          # 3x4, rows span x-perp
        imgs = (Phi @ P.T).T                 # (n,3)
        seen = set()
        for row in imgs:
            v = [int(a) for a in row]
            first = next((a for a in v if a != 0), None)
            if first is None:
                seen.add((0, 0, 0)); continue
            inv = int(GF(first) ** -1)
            seen.add(tuple(int(GF(a) * GF(inv)) for a in v))
        return len(seen)

    reps = {}
    def consider(tpl):
        cx = canonify(GF(list(tpl)))
        if cx in cubic_set:
            return
        inc = incidence(GF(list(cx)))
        key = (inc, cx in axis_pts)
        if key not in reps:
            reps[key] = cx

    if mode == 'full':
        for a in field:
            for b in field:
                for c in field:
                    consider((1, int(a), int(b), int(c)))
        for b in field:
            for c in field:
                consider((0, 1, int(b), int(c)))
        for c in field:
            consider((0, 0, 1, int(c)))
        consider((0, 0, 0, 1))
    else:
        consider((0, 1, 0, 0))
        got = 0
        for a in field:
            for b in field:
                for c in field:
                    consider((1, int(a), int(b), int(c)))
            if len(reps) >= 4:
                break

    print("  class(inc,axis)  rep                  #edges  #distinct-img  M    tau")
    for key in sorted(reps):
        cx = reps[key]
        x = GF(list(cx))
        edges = edges_through(x)
        M, sel = max_indep_3unif(n, edges)
        ndi = n_distinct_images(x)
        tag = 'AXIS' if key[1] else ''
        print(f"  {str(key):16s} {str(cx):20s} {len(edges):6d} {ndi:9d}     {M:3d} {tau_str(n, M)} {tag}")
        if key[1]:
            verify_axis(GF, edges, labels, sel, h, q)
    print()

def tau_str(n, M):
    return f"{n-M:4d}"

def verify_axis(GF, edges, labels, sel, h, q):
    def lab(i):
        k, v = labels[i]
        return None if k == 'inf' else v      # inf -> None (phi=0)
    def phi(v):                                # additive coord: 1/t, phi(inf)=0
        return GF(0) if v is None else v ** -1
    ok = 0; bad = 0
    for (i, j, k) in edges:
        s = phi(lab(i)) + phi(lab(j)) + phi(lab(k))
        if s == 0: ok += 1
        else: bad += 1
    # cusp = param t=0 (should be in NO edge); smooth group = other q params via phi
    in_edge = set()
    for e in edges:
        in_edge.update(e)
    cusp = [i for i in range(len(labels)) if i not in in_edge]
    cuspv = [str(lab(i)) for i in cusp]
    selv = sorted(str(lab(i)) for i in sel)
    print(f"      [axis] phi=1/t sum-zero check: {ok} edges hold, {bad} fail; "
          f"cusp params(no edge)={cuspv}; M-set={selv}; expect M=cap+1={q and CAP3[h]+1}")

if __name__ == '__main__':
    run(9, 'full')
    run(27, 'rep')
