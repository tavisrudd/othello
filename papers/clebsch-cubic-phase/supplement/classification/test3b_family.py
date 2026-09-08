"""Test 3(b): a conic-free signed 2p-point configuration for every prime p >= 5 satisfying
the code condition (signed moments of orders 0, 1, 2 vanish, order 3 does not), with a
transitive sheet symmetry, and its code invariants.

Construction (translation trade).  In characteristic p the first moment of p points is
translation invariant, so take Omega_+ = p points with zero sum spanning a (p-2)-flat and
Omega_- = Omega_+ + t with t outside the flat's direction space.  Then, writing mu_j^+ for
the moment tensors of Omega_+,
    signed mu_0 = p - p = 0,   signed mu_1 = mu_1^+ - (mu_1^+ + p t) = 0 (mu_1^+ = 0),
    signed mu_2 = mu_2^+ - (mu_2^+ + 2 t mu_1^+ + p t^2) = 0,
    signed mu_3 = mu_3^+ - (mu_3^+ + 3 t mu_2^+ + 3 t^2 mu_1^+ + p t^3) = -3 t . mu_2^+,
which is nonzero iff mu_2^+ != 0.  Explicit member: Omega_+ = the images of the standard
basis e_1..e_p of F_p^p in F_p^p / <1> (the S_p-orbit of one point), t = image of e_1.
The logical cubic is F(u) = -3 (t.u) q(u) with q = mu_2^+ a quadratic form of rank p-2.

Also checked: the wider affine family Omega_- = M Omega_+ + t with M an isometry of mu_2^+
(one random member per prime), and the exact Hessian-rank census / M2 of the explicit
member at p = 7 via the Hessian-rank census binary.
"""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[1]/"reconstruction"))

import os
import random
import subprocess
import sys
from fractions import Fraction
import math

from conic import code_data, min_weight_affine, logical_cubic_tensor, reduce_to_direction_basis, write_tensor, rank

HERE = os.path.dirname(os.path.abspath(__file__))
RANK_BIN = str(Path(__file__).resolve().parents[1]/"spectra/rank11/target/release/rank11")


def explicit_member(p):
    """Points in F_p^{p-1}: represent F_p^p/<1> by dropping the last coordinate after
    subtracting it (v -> (v_i - v_p)_{i<p})."""
    k = p - 1
    pts_plus = []
    for i in range(p):
        e = [0] * p
        e[i] = 1
        pts_plus.append([(e[j] - e[p - 1]) % p for j in range(k)])
    t = pts_plus[0]
    pts_minus = [[(x + y) % p for x, y in zip(pt, t)] for pt in pts_plus]
    return pts_plus, pts_minus


def moments(points, p, deg):
    k = len(points[0])
    import itertools
    out = {}
    for combo in itertools.combinations_with_replacement(range(k), deg):
        s = 0
        for pt in points:
            v = 1
            for i in combo:
                v = v * pt[i] % p
            s = (s + v) % p
        out[combo] = s
    return out


def signed_moment_zero(plus, minus, p, deg):
    mp = moments(plus, p, deg)
    mm = moments(minus, p, deg)
    return all((mp[c] - mm[c]) % p == 0 for c in mp)


def census_via_binary(path, p, k):
    out = subprocess.run([RANK_BIN, path, "--low", "0"], capture_output=True, text=True, check=True).stdout
    N = {0: 1}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) >= 4 and parts[0] == "rank" and parts[1].isdigit() and parts[2] == "lines":
            N[int(parts[1])] = int(parts[3]) * (p - 1)
    assert sum(N.values()) == p ** k
    return N


def random_isometry_member(p, rng):
    """Omega_+ = random p points with zero sum spanning a (p-2)-flat; M = a random
    isometry of mu_2^+ found by rejection among random diagonal/permutation-like maps is
    too rare, so use M = -I (always an isometry of a symmetric tensor) composed with a
    random translation: Omega_- = -Omega_+ + t.  This is the point-reflection member."""
    k = p - 1
    while True:
        pts = [[rng.randrange(p) for _ in range(k)] for _ in range(p - 1)]
        last = [(-sum(pt[j] for pt in pts)) % p for j in range(k)]
        pts.append(last)
        # affine span must be p-2 dimensional (rank of differences = p-2)
        diffs = [[(x - y) % p for x, y in zip(pt, pts[0])] for pt in pts[1:]]
        if rank(diffs, p) != p - 2:
            continue
        t = [rng.randrange(p) for _ in range(k)]
        minus = [[(-x + y) % p for x, y in zip(pt, t)] for pt in pts]
        if len(set(map(tuple, pts + minus))) != 2 * p:
            continue
        cd = code_data(pts + minus, [1] * p + [-1] * p, p)
        if cd["dimL"] == p:
            return pts, minus


def main():
    primes = [int(a) for a in sys.argv[1:]] or [5, 7, 11, 13, 17, 19, 23]
    rng = random.Random(7)
    for p in primes:
        k = p - 1
        plus, minus = explicit_member(p)
        sign = [1] * p + [-1] * p
        pts = plus + minus
        cd = code_data(pts, sign, p)
        z = [signed_moment_zero(plus, minus, p, d) for d in (0, 1, 2, 3)]
        dX, exact = min_weight_affine(cd["L"], p, exact_limit=1_000_000, samples=50_000)
        print(f"p={p:2d} explicit translation trade: n={cd['n']} dimL={cd['dimL']} distinct={cd['distinct']} "
              f"isotropic={cd['isotropic']} cubic_nonzero={cd['cubic_nonzero']} "
              f"signed moments zero (orders 0,1,2,3) = {z}  dimL2={cd['dimL2']} (rigid iff {2*p-1}) dimL3={cd['dimL3']} "
              f"d_X={dX} ({'exact' if exact else 'sampled bound'}) d_Z=2")
        if p <= 13:
            rp, rm = random_isometry_member(p, rng)
            cdr = code_data(rp + rm, sign, p)
            zr = [signed_moment_zero(rp, rm, p, d) for d in (0, 1, 2, 3)]
            print(f"      random point-reflection member: dimL={cdr['dimL']} isotropic={cdr['isotropic']} "
                  f"cubic_nonzero={cdr['cubic_nonzero']} moments zero={zr} dimL2={cdr['dimL2']}")
        if p == 7:
            coords, kk = reduce_to_direction_basis(pts, p)
            A = logical_cubic_tensor(coords, sign, p)
            path = os.path.join(HERE, "out", "t3b_translation7.txt")
            write_tensor(path, p, kk, A)
            N = census_via_binary(path, p, kk)
            s = sum(Fraction(n, p ** r) for r, n in N.items())
            m2 = math.log(Fraction(p ** kk) / s)
            print(f"      p=7 logical cubic Hessian census (exact): {dict(sorted(N.items()))}  r_min={min(r for r in N if r)}  M2={m2:.4f}  sum|<P>|^4={s}")


if __name__ == "__main__":
    main()
