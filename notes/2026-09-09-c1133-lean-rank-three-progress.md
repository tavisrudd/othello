# C1133 — cyclic rank-three centralizer and remaining persistence proof

**Date:** 2026-09-09. **Status:** finite algebra kernel-checked; differential
persistence remains to be formalized. This is core L3 for genera 2–5, not the
optional rank-three modified-residue branch.

## Proved finite calculation

The new `Quantum/CyclicRankThreeCentralizer.lean` works over any commutative
ring, including rings with zero divisors. Put

    E = [[0,0,c],[1,0,b],[0,1,0]].

Lean proves its actual characteristic polynomial is `T³-bT-c`. If a matrix C
commutes with E, then `C=uI+vE+wE²`, where u,v,w are the entries of C's first
column. No polynomial expression for C is assumed. The proof derives the
remaining six entries from the matrix commutation identity.

Lean then proves

    tr C      = 3u + 2bw,
    tr(EC)    = 2bv + 3cw,
    tr(E²C)   = 2bu + 3cv + 2b²w.

Thus the last two expressions belong to `(b,c)`. The public declaration is
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.rankThree_cyclicCentralizer_and_traceIdentities`.
Its conclusion includes the characteristic polynomial, recovered quadratic
commutant, and all three trace formulas.

## Exact next bridge, not yet Lean-proved

Use the conventions already fixed in `transport-vanishing-audit.md`:

    [E,C]=0,   ∂E = -C + [C,A0] + [B0,E],   tr E = 0.

Taking trace first gives tr C=0. In characteristic zero, u=−2bw/3. Cyclicity of
trace and [E,C]=0 kill both commutator contributions after multiplication by
E or E². Since b=tr(E²)/2 and c=tr(E³)/3, the finite formulas give

    ∂b = -2bv - 3cw,
    ∂c = -3cv - (2/3)b²w.

The signs follow the printed `-C` convention. Both derivatives lie in `(b,c)`.
For a formal characteristic-zero bulk germ with initial b=c=0, a nonzero
lowest total degree m would yield a coordinate derivative of degree m−1,
contradicting membership in this ideal. This is the intended formal bridge:
derive the displayed compressed flatness equations, prove the trace derivative
identities, then implement the lowest-degree argument in the actual formal
coefficient ring. The current terminal proves only the finite formulas.

A cyclic vector initially has a unit cyclic determinant, so the nilpotent
rank-three Jordan block remains whole once b=c=0. That cyclic-germ and
primary-compression construction is also a separate interface obligation.
No arbitrary singular specialization is licensed by this argument.

## Verification and correspondence

The complete new module elaborated without Lean warnings through the guarded
wrapper, then built through the guarded queue. Main and AxiomAudit built
subsequently, with a successful final aggregate trace gate.

```sh
lean/scripts/lean-build-queue.py build \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CyclicRankThreeCentralizer \
  --lean-root /home/tavis/src/othello/papers/cubic-stabilization-m1/lean --cores 20-23
lean/scripts/lean-build-queue.py build \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.Main \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit \
  --lean-root /home/tavis/src/othello/papers/cubic-stabilization-m1/lean --cores 20-23
```

Successful runs:
`/home/tavis/.cache/othello-lean-build/run-20260910-013112-6d96d926` (leaf,
1,857,628 kB peak) and
`/home/tavis/.cache/othello-lean-build/run-20260910-013228-f91e2bc7` (interface/audit,
at most 2,079,308 kB peak). The public terminal uses exactly
`propext`, `Classical.choice`, `Quot.sound`.
Captured-log correspondence passes: **190 sources, 325 terminals, 67 claims,
89 machinery entries, 22 imports, 5 evidence bundles**. Existing coverage
remains 14 absent / 26 fragment / 26 conditional / 1 complete. The new
terminal is machinery and no current manuscript statement is promoted.

## EJ+TT and Mystery ledger

- **Settled:** no field or nonzero-denominator assumption is needed for this
  cyclic commutant formula; its first column determines every coefficient.
- **Settled:** trace formulas explicitly expose the characteristic-coefficient
  ideal; this is stronger evidence than just checking nilpotence at one matrix.
- **Open:** the flatness/derivative/lowest-degree bridge above is still a proof
  obligation in Lean. The written mathematics does not count as kernel coverage.
- **Open:** all seventeen geometric identifications, full-primary projectors,
  odd allocation and selector/fold assembly remain as mapped in L2–L5.
