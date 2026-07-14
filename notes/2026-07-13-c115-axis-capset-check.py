"""C115: independent q=81 confirmation of the axis reduction to cap-sets.
Axis rep (0,1,0,0): project out x1 -> image (1:t^2:t^3) (cuspidal v^2=u^3).
Edges = image-collinear triples (computed by direct 3x3 det, NOT assuming phi).
Confirm: edge set == {1/t-sum-zero triples}, count == q(q-1)/6, cusp t=0 in no edge.
Then tau_axis = q - cap_3(4) = 81 - 20 = 61 by the theorem (cap_3(4)=20 known)."""
import itertools
import numpy as np
import galois

def run(q):
    GF = galois.GF(q)
    p, h = int(GF.characteristic), int(GF.degree)
    field = list(GF.elements)
    # image points of C under projection from (0,1,0,0): drop x1 -> (x0,x2,x3)
    rows, params = [], []
    for t in field:
        rows.append([1, int(t*t), int(t*t*t)]); params.append(t)   # (1, t^2, t^3)
    rows.append([0, 0, 1]); params.append(None)                     # inf -> (0,0,1)
    Img = GF(rows)                    # (q+1, 3)
    nP = Img.shape[0]

    a = Img[:, 0]; b = Img[:, 1]; c = Img[:, 2]
    triples = list(itertools.combinations(range(nP), 3))
    idx = np.array(triples)          # (T,3)
    i, j, k = idx[:, 0], idx[:, 1], idx[:, 2]
    # 3x3 det of rows (Img[i],Img[j],Img[k]) via cofactor expansion, all field-vectorized
    det = (a[i]*(b[j]*c[k]-b[k]*c[j])
           - b[i]*(a[j]*c[k]-a[k]*c[j])
           + c[i]*(a[j]*b[k]-a[k]*b[j]))
    edge_mask = np.asarray(det == 0)
    n_edges = int(edge_mask.sum())

    # independent phi=1/t sum-zero predicate; cusp t=0 excluded (sentinel), inf->0
    def phi(v):
        if v is None:
            return GF(0)              # inf = smooth identity
        if v == 0:
            return None               # cusp: excluded from the additive group
        return v ** -1
    phis = [phi(pp) for pp in params]
    def sumzero(tr):
        vals = [phis[t] for t in tr]
        if any(v is None for v in vals):   # triple hits the cusp -> not an edge
            return False
        return (vals[0] + vals[1] + vals[2]) == 0
    pred_mask = np.array([sumzero(tr) for tr in triples])

    agree = int((edge_mask == pred_mask).sum())
    cusp_idx = params.index(GF(0))   # t=0
    cusp_in_edges = any(cusp_idx in triples[m] for m in np.nonzero(edge_mask)[0])
    print(f"q={q} (h={h}): #edges(det)={n_edges}  q(q-1)/6={q*(q-1)//6}  "
          f"edge==phi-sumzero: {agree}/{len(triples)}  cusp(t=0) in any edge: {cusp_in_edges}")
    print(f"  => M_axis = cap_3({h})+1, tau_axis = q - cap_3({h}) = {q} - "
          f"{ {2:4,3:9,4:20}[h] } = {q - {2:4,3:9,4:20}[h]}")

if __name__ == '__main__':
    run(9); run(27); run(81)
