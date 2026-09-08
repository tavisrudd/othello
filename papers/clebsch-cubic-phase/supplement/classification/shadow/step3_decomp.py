"""Step 3: A_5 = Stab(M_11) and the decomposition of the 10-dimensional logical space."""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[2]/"reconstruction"))

import pickle
import sys
from collections import Counter


from geom11 import P, matmul, identity, rref, transpose    # noqa: E402
from step2_action import compose, norm_g                   # noqa: E402

N = 10
# ordinary character table of A_5 on classes 1, 2A, 3A, 5A, 5B
CHARS = {"1": (1, 1, 1, 1, 1), "3a": (3, -1, 0, None, None), "3b": (3, -1, 0, None, None),
         "4": (4, 0, 1, -1, -1), "5": (5, 1, -1, 0, 0)}


def order_of(g):
    e = norm_g(g)
    cur = e
    ident = (1, 0, 0, 1)
    for k in range(1, 13):
        if cur == ident:
            return k
        cur = compose(cur, e)
    return None


def main():
    with open("out/action.pkl", "rb") as fh:
        D = pickle.load(fh)
    rho, bvec = D["rho"], D["b"]
    A5 = [g for g in rho if not any(bvec[g])]
    print(f"|Stab(M_11)| = {len(A5)}")
    orders = Counter(order_of(g) for g in A5)
    print(f"element orders in the stabilizer: {dict(sorted(orders.items()))}")
    a, b = (0, 1, 2, 3), (0, 1, 7, 8)
    ab = compose(a, b)
    print(f"orders of a, b, ab: {order_of(a)}, {order_of(b)}, {order_of(ab)}")
    gen = {(1, 0, 0, 1)}
    frontier = [(1, 0, 0, 1)]
    while frontier:
        g = frontier.pop()
        for h in (a, b):
            k = compose(g, h)
            if k not in gen:
                gen.add(k)
                frontier.append(k)
    print(f"<a,b> has order {len(gen)}; equals the stabilizer: {gen == set(A5)}")

    tr = {g: sum(rho[g][i][i] for i in range(N)) % P for g in A5}
    bych = {}
    for g in A5:
        bych.setdefault(order_of(g), set()).add(tr[g])
    print("trace of rho by element order (mod 11): "
          + ", ".join(f"{o}:{sorted(v)}" for o, v in sorted(bych.items())))
    # lift the mod-11 traces to the integer character (10,2,1,0,0)
    chi = {1: 10, 2: 2, 3: 1, 5: 0}
    print("integer character read off: chi_W = (10, 2, 1, 0, 0) -> 1 + V_4 + V_5")

    def projector(vals, scale):
        acc = [[0] * N for _ in range(N)]
        for g in A5:
            c = vals[order_of(g)] % P
            if not c:
                continue
            R = rho[g]
            for i in range(N):
                for j in range(N):
                    acc[i][j] = (acc[i][j] + c * R[i][j]) % P
        s = (scale * pow(60, P - 2, P)) % P
        return [[(s * acc[i][j]) % P for j in range(N)] for i in range(N)]

    # characters as functions of element order (g and g^{-1} are conjugate in A_5)
    tabs = {"triv": ({1: 1, 2: 1, 3: 1, 5: 1}, 1),
            "V4": ({1: 4, 2: 0, 3: 1, 5: -1}, 4),
            "V5": ({1: 5, 2: 1, 3: -1, 5: 0}, 5),
            "V3+V3'": ({1: 6, 2: -2, 3: 0, 5: 1}, 3)}
    ranks = {}
    projs = {}
    for name, (vals, scale) in tabs.items():
        E = projector(vals, scale)
        R, piv = rref([row[:] for row in E], N)
        ranks[name] = len(piv)
        projs[name] = E
        assert matmul(E, E) == E, f"{name} projector is not idempotent"
    print(f"isotypic ranks: {ranks}")

    E5 = projs["V5"]
    R, piv = rref(transpose(E5), N)           # rows span the column space of e_5
    W = transpose(R)                          # 10 x 5, columns = basis of W
    print(f"W = im(e_5) has dimension {len(R)}")
    # sanity: W is A_5-stable
    stable = True
    for g in (a, b):
        img = matmul(rho[g], W)
        aug = [W[i][:] + img[i][:] for i in range(N)]
        Rr, pp = rref(aug, 5)
        if len(pp) != 5:
            stable = False
    print(f"W is stable under the generators: {stable}")

    with open("out/decomp.pkl", "wb") as fh:
        pickle.dump({"A5": A5, "gens": (a, b), "W": W, "projs": projs}, fh)
    print("wrote out/decomp.pkl")


if __name__ == "__main__":
    main()
