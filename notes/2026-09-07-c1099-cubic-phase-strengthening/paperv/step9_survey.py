"""Step 9: full survey of the twelve projective members of the invariant pencil."""
import pickle
import sys

sys.path.insert(0, "/home/tavis/src/othello/notes/2026-09-07-c1099-cubic-phase-strengthening/paperv")

from geom11 import P, rref                                                   # noqa: E402
from step5_pencil import (sym_tensor, singular_points, census,               # noqa: E402
                          general_position)


def main():
    with open("out/pencil.pkl", "rb") as fh:
        Dp = pickle.load(fh)
    members, cN, confN, chordal = (Dp["members"], Dp["cN"], Dp["confN"], Dp["chordal"])
    print("idx | #Sing(F_11) | rank of their span | general position | "
          "Hessian census (N_0..N_5) | role")
    for i, m in enumerate(members):
        S = sym_tensor(list(m))
        sp = singular_points(S)
        rk = len(rref([list(v) for v in sp], 5)[1]) if sp else 0
        gp = general_position(sp) if 0 < len(sp) <= 14 else None
        cs = census(S)
        role = []
        if m == cN:
            role.append("logical shadow")
        if m == confN:
            role.append("conference")
        if m in chordal:
            role.append("chordal")
        print(f"{i:3d} | {len(sp):11d} | {rk:18d} | {str(gp):16s} | "
              f"{tuple(cs.get(r, 0) for r in range(6))} | {','.join(role)}")

    with open("out/bridge.pkl", "rb") as fh:
        Db = pickle.load(fh)
    from step4_bridge import subst_cubic, pnorm
    q = Db["q"]
    print("\naction of q on P(Pi):")
    for i, m in enumerate(members):
        j = members.index(pnorm(subst_cubic(list(m), q)))
        print(f"  {i:3d} -> {j:3d}" + ("   (fixed)" if i == j else ""))


if __name__ == "__main__":
    main()
