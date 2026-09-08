"""Test 3(a) verification: for every HIT pair of translation classes reported by
`conic-search trades P` (out/tradesP.txt), rebuild the signed 2p-point configuration from the
conic recipe, verify the trade-to-code conditions independently of the Rust code, and
compute the code invariants:

  dim L (must be p for a [[2p, p-1, 2]]_p code), signed isotropy eps ⊥ L^{o2},
  eps not ⊥ L^{o3} (nonzero logical cubic), dim L^{o2} (rigidity iff = 2p-1),
  d_X = min wt(L \\ <1>) (exact for p = 7, sampled upper bound otherwise),
  the AGL(1,p)-equivalence class of the pair, the PGL_2(p) set-stabilizer of the signed
  configuration, and the Hessian-rank census of the logical cubic (exact via the Hessian-rank
  Rust census for k <= 10, sampled for k = 12).

Usage: uv run python test3a_verify.py 7 11 13
"""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[1]/"reconstruction"))

import os
import re
import subprocess
import sys
from fractions import Fraction
import math

from conic import (act, code_data, first_matching, hessian_rank_census_sampled, is_square,
                   logical_cubic_tensor, min_weight_affine, pgl2, point_x, product_form,
                   reduce_to_direction_basis, translation_class, write_tensor)

HERE = os.path.dirname(os.path.abspath(__file__))
RANK_BIN = str(Path(__file__).resolve().parents[1]/"spectra/rank11/target/release/rank11")


def parse_hits(path):
    hits = []
    with open(path) as fh:
        for line in fh:
            if line.startswith("HIT"):
                lists = re.findall(r"\[([0-9, ]+)\]", line)
                a = [int(t) for t in lists[0].split(",")]
                b = [int(t) for t in lists[1].split(",")]
                hits.append((a, b))
    return hits


def canonical_pair_under_agl(a, b, p):
    """Canonical form of the unordered pair of translation classes {[a],[b]} under
    AGL(1,p) = {x -> cx + d}."""
    best = None
    for c in range(1, p):
        e = (c, 0, 0, 1)
        ca = min(tuple(t) for t in translation_class(act(e, a, p), p))
        cb = min(tuple(t) for t in translation_class(act(e, b, p), p))
        key = tuple(sorted((ca, cb)))
        if best is None or key < best:
            best = key
    return best


def set_stabilizer(cfg_plus, cfg_minus, p, G):
    """Elements of PGL_2(p) preserving the set of 2p matchings; report how many preserve
    the sheets and how many swap them."""
    sp = set(map(tuple, cfg_plus))
    sm = set(map(tuple, cfg_minus))
    keep = swap = 0
    for e in G:
        ip = set(tuple(act(e, m, p)) for m in cfg_plus)
        im = set(tuple(act(e, m, p)) for m in cfg_minus)
        if ip == sp and im == sm:
            keep += 1
        elif ip == sm and im == sp:
            swap += 1
    return keep, swap


def census_via_binary(path, p, k):
    out = subprocess.run([RANK_BIN, path, "--low", "0"], capture_output=True, text=True, check=True).stdout
    N = {0: 1}
    for line in out.splitlines():
        parts = line.split()
        if len(parts) >= 4 and parts[0] == "rank" and parts[1].isdigit() and parts[2] == "lines":
            N[int(parts[1])] = int(parts[3]) * (p - 1)
    assert sum(N.values()) == p ** k, out
    return N


def m2(p, k, N):
    s = sum(Fraction(n, p ** r) for r, n in N.items())
    return float(math.log(Fraction(p ** k) / s)), s


def main():
    primes = [int(a) for a in sys.argv[1:]] or [7, 11, 13]
    for p in primes:
        path = os.path.join(HERE, "out", f"trades{p}.txt")
        hits = parse_hits(path)
        k = p - 1
        base = product_form(first_matching(p), p)
        G = pgl2(p) if p <= 13 else None
        print(f"\n=== p = {p}: {len(hits)} HIT pairs in {os.path.basename(path)} ===")
        classes = {}
        for (a, b) in hits:
            key = canonical_pair_under_agl(a, b, p)
            classes.setdefault(key, []).append((a, b))
        print(f"  AGL(1,{p})-inequivalent pairs: {len(classes)}")
        for idx, (key, members) in enumerate(sorted(classes.items())):
            a, b = members[0]
            cp = translation_class(a, p)
            cm = translation_class(b, p)
            pts = [point_x(m, base, p) for m in cp + cm]
            sign = [1] * p + [-1] * p
            cd = code_data(pts, sign, p)
            dX, exact = min_weight_affine(cd["L"], p)
            stab = set_stabilizer(cp, cm, p, G) if G else ("n/a", "n/a")
            # PSL_2-orbit structure of the two sheets (are they PSL_2-orbits?)
            print(f"  pair #{idx+1} (x{len(members)} translation-class pairs in this AGL class)")
            print(f"    rep classes: {a} | {b}")
            print(f"    n={cd['n']} dimL={cd['dimL']} distinct={cd['distinct']} isotropic={cd['isotropic']} "
                  f"cubic_nonzero={cd['cubic_nonzero']} dimL2={cd['dimL2']} (rigid iff {2*p-1}) dimL3={cd['dimL3']}")
            print(f"    d_X = {dX} ({'exact' if exact else 'sampled upper bound'}), d_Z = 2, k = {cd['dimL']-1}")
            print(f"    PGL_2({p}) set-stabilizer of the signed configuration: {stab[0]} sheet-preserving, {stab[1]} sheet-swapping")
            if cd["dimL"] == p and cd["isotropic"] and cd["cubic_nonzero"]:
                coords, kk = reduce_to_direction_basis(pts, p)
                assert kk == k
                A = logical_cubic_tensor(coords, sign, p)
                if k <= 10:
                    tpath = os.path.join(HERE, "out", f"t3a_p{p}_pair{idx+1}.txt")
                    write_tensor(tpath, p, k, A)
                    N = census_via_binary(tpath, p, k)
                    val, s = m2(p, k, N)
                    print(f"    Hessian-rank census (exact, all of F_{p}^{k}): {dict(sorted(N.items()))}")
                    print(f"    r_min = {min(r for r in N if r)}  M2 = {val:.4f} ({val/k:.4f}/qudit)  sum|<P>|^4 = {s}")
                else:
                    N = hessian_rank_census_sampled(A, p, k, 20000)
                    tot = sum(N.values())
                    print(f"    Hessian-rank census (sampled, {tot} random v): {dict(sorted(N.items()))}")
                    print(f"    r_min observed = {min(N)}")


if __name__ == "__main__":
    main()
