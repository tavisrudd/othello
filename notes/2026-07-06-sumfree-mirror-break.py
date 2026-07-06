#!/usr/bin/env python3
"""
Test the "defect-mirror + spare-token" responder strategy for G({p,3})=*1.

Setup: n=3p, p prime >=7. Board B (sum-free subset of Z_n). Order-3 elements p,2p.
A negation-symmetric M with -3 not in M, 2p dead, gives a class P+ = {p,3}∪M + *1.

Claim (to prove G({p,3})=*1): every P+ board is a P-position for the responder Rita,
via: mirror z<->-z, answer "take token" with -3 (Fact C => *0), answer -3 with "take token".
The ONLY gap is a legal move z (z != -3) whose mirror -z is ILLEGAL ("mirror-break").
This script enumerates mirror-break moves and the Schur triple that kills -z.
"""
import sys

def legal_moves(B, n):
    Bset = set(B)
    BpB = set((a+b) % n for a in B for b in B)      # B+B (incl 2a)
    BmB = set((a-b) % n for a in B for b in B)      # B-B
    out = []
    for z in range(n):
        if z in Bset: continue
        if z in BpB: continue          # b+b'=z
        if z in BmB: continue          # z+b=c  (z=c-b)
        if (2*z) % n in Bset: continue # z+z=c in B
        out.append(z)
    return out

def kill_reason(z, B, n):
    """Why is z illegal? Return list of triples (as strings) that block adding z."""
    Bset = set(B); reasons=[]
    for b in B:
        for c in B:
            if (b+c) % n == z: reasons.append(f"{b}+{c}={z}")
    for b in B:
        if (z+b) % n in Bset: reasons.append(f"{z}+{b}={(z+b)%n}")
    if (2*z) % n in Bset: reasons.append(f"{z}+{z}={(2*z)%n}")
    return reasons

def analyze(p, elt3, name):
    n = 3*p
    P = p            # order-3 element
    B = [P, elt3 % n]
    legal = set(legal_moves(B, n))
    breaks = []
    for z in sorted(legal):
        if z == (-elt3) % n:   # z=-3 is the token-cashing move, handled separately
            continue
        mz = (-z) % n
        if mz not in legal:
            reasons = kill_reason(mz, B, n)
            breaks.append((z, mz, reasons))
    print(f"=== {name}: Z_{n}, B={{p={P}, 3rep={elt3%n}}}  (-3 = {(-elt3)%n}) ===")
    print(f"  |legal moves| = {len(legal)}")
    print(f"  is -3 legal? {(-elt3)%n in legal}   (token-cash move)")
    if not breaks:
        print("  *** NO mirror-break moves: the pure defect-mirror closes at this board. ***")
    for z, mz, reasons in breaks:
        # classify: does the killing triple use p or 3 (the defect)?
        usesdefect = any(str(P) in r.split('=')[0].replace(str(3*p),'') or True for r in reasons)
        print(f"  BREAK z={z:>3} legal, -z={mz:>3} ILLEGAL  via {reasons}")
    print()
    return breaks

if __name__ == "__main__":
    for p in [7, 11, 13, 17, 19, 23]:
        analyze(p, 3, f"{{p,3}} p={p}")
    print("################ {p,1} branch ################")
    for p in [7, 11, 13, 17, 19, 23]:
        analyze(p, 1, f"{{p,1}} p={p}")
