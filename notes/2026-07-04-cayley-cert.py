"""Structural outcome law: affine involution PAIRING certificates for Cay(Z_n,S).

An affine map sigma(x)=a*x+b (a a unit, a^2=1 mod n, a*S=S, b(a+1)=0) is always an
automorphism of Cay(Z_n,S). Two S1 certificates:

  * WHOLE-GRAPH pairing  => graph is a P-position => G=0.
    Needs sigma fixed-point-free on all of Z_n and x !~ sigma(x) everywhere.
    (a=1,b=n/2 = L1 translation;  a=-1 = reflection, fires when S all-even for even n.)

  * RESIDUAL pairing (after the normalized first move deletes N[0]) => child is P
    => G=1.  Needs sigma to setwise-fix the live set Z_n minus ({0} u S), be fpf and
    non-adjacent-mate on it.  (a=-1,b=0 = negation steal = L2 halving; fires when 2S=S.)

Coverage of these two certificates over the full symmetric-S enumeration = exactly
"when does the pairing / halving condition fire", and the uncovered remainder is the
deep (S2 / non-affine) territory.
"""

import sys
from cayley_sweep import game_G, sym_sets, connected


def gcd(a, b):
    while b:
        a, b = b, a % b
    return a


def affine_involutions(n, Sset):
    invs = []
    for a in range(n):
        if gcd(a, n) != 1:
            continue
        if (a * a) % n != 1:
            continue
        if {(a * d) % n for d in Sset} != Sset:
            continue
        for b in range(n):
            if (b * (a + 1)) % n == 0:
                invs.append((a, b))
    return invs


def whole_graph_paired(n, Sset):
    for a, b in affine_involutions(n, Sset):
        if a == 1 and b == 0:
            continue
        if any(((a - 1) * x + b) % n == 0 for x in range(n)):
            continue  # has a fixed point
        if any(((a - 1) * x + b) % n in Sset for x in range(n)):
            continue  # some vertex adjacent to its mate
        return (a, b)
    return None


def residual_paired(n, Sset):
    dead = {0} | Sset
    live = [x for x in range(n) if x not in dead]
    if not live:
        return ("empty", None)  # empty residual is trivially P
    for a, b in affine_involutions(n, Sset):
        if a == 1 and b == 0:
            continue
        img = {b} | {(d + b) % n for d in Sset}
        if img != dead:
            continue  # does not setwise-fix the live set
        if any(((a - 1) * x + b) % n == 0 for x in live):
            continue  # fixed point in live
        if any(((a - 1) * x + b) % n in Sset for x in live):
            continue  # live vertex adjacent to its mate
        return (a, b)
    return None


def run(even_max, odd_max):
    print("Affine-pairing certificate coverage over Cay(Z_n,S)  (G in {0,1})")
    print(f"{'n':>3} {'|S-sets':>7} {'G0':>5} {'G1':>5} {'cap':>4} | "
          f"{'G0_paired':>9} {'G0_gap':>6} | {'G1_paired':>9} {'G1_gap':>6} | "
          f"{'SOUND?':>6}")
    ns = sorted(list(range(4, even_max + 1, 2)) + list(range(5, odd_max + 1, 2)))
    all_gap0 = {}
    all_gap1 = {}
    for n in ns:
        tot = g0 = g1 = cap = 0
        g0_paired = g1_paired = 0
        gap0, gap1 = [], []
        unsound = 0
        for S in sym_sets(n):
            Sset = set(S)
            g, _ = game_G(n, S)
            tot += 1
            if g is None:
                cap += 1
                continue
            wp = whole_graph_paired(n, Sset)
            rp = residual_paired(n, Sset)
            # soundness
            if wp is not None and g != 0:
                unsound += 1
            if rp is not None and g != 1:
                unsound += 1
            if g == 0:
                g0 += 1
                if wp is not None:
                    g0_paired += 1
                else:
                    gap0.append(sorted(Sset))
            else:
                g1 += 1
                if rp is not None:
                    g1_paired += 1
                else:
                    gap1.append(sorted(Sset))
        print(f"{n:>3} {tot:>7} {g0:>5} {g1:>5} {cap:>4} | "
              f"{g0_paired:>9} {len(gap0):>6} | {g1_paired:>9} {len(gap1):>6} | "
              f"{'OK' if unsound == 0 else 'BAD:' + str(unsound):>6}")
        sys.stdout.flush()
        all_gap0[n] = gap0
        all_gap1[n] = gap1
    return all_gap0, all_gap1


if __name__ == "__main__":
    em = int(sys.argv[1]) if len(sys.argv) > 1 else 18
    om = int(sys.argv[2]) if len(sys.argv) > 2 else 17
    gap0, gap1 = run(em, om)
    # dump the uncovered (deep-certificate) sets, smallest degree first
    print("\n### G0 gap (P but NO affine whole-graph pairing) ###")
    for n in sorted(gap0):
        if gap0[n]:
            ex = sorted(gap0[n], key=lambda x: (len(x), x))
            print(f"  n={n}: {len(gap0[n])} sets; e.g. "
                  f"{ex[:6]}")
    print("\n### G1 gap (N but NO affine residual pairing) ###")
    for n in sorted(gap1):
        if gap1[n]:
            ex = sorted(gap1[n], key=lambda x: (len(x), x))
            print(f"  n={n}: {len(gap1[n])} sets; e.g. "
                  f"{ex[:6]}")
    print("\nCERT_DONE")
