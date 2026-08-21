# C936 — Modular resolvent companion

**Lane:** `cubic-threefolds`

**Date:** 2026-08-21

## Goal

Write a short standalone paper proving that the signed parameter of the
nonstandard `A_5` cubic pencil is the sign/discriminant resolvent of the
relative norm-axis elliptic two-division cover.  The paper should turn the
finite `3+2` packet into one exact modular diagram without identifying objects
at stronger levels than the geometry supports.

## Owned paths

- `papers/cubic-gluing-resolvent/`;
- this card and one dated C936 report;
- the cubic-threefold lane queue, handoff, archive, and discovery companion;
- a paper-local reproducibility bundle copied or distilled from the exact C904
  certificates with its own checksums and replay entry point.

No edit to the `m=1` epilogue, its Lean companion, the all-`m` manuscript, or
any standalone mirror follows automatically.

## Theorem spine

1. Define the marked pencil `X_t:P+tQ=0`, the outer involution `t -> -t`,
   and the unmarked coordinate `T=81t^2`.
2. Derive the Prym/norm-axis elliptic factor and its cyclic order-three
   structure from the van Geemen--Yamauchi chart, including the quadratic
   twist that preserves two-torsion.
3. Use the relative six-axis isogeny and the degree-one polarized Prym/axis
   comparison to transport the universal two-division packet to the actual
   principal kernel.
4. Prove that the exotic complement is the sign resolvent and that the signed
   cubic line is `r^2=T`, with `r=9t` after one deck convention.
5. Identify the rational degree-three quotient with `X_0(6)` and the common
   degree-six Galois closure with `Gamma_0(3) ∩ Gamma(2)`.
6. Prove the congruence subgroup, genus, elliptic-point, cusp-width, and eta
   Hauptmodul statements with the coarse/stack distinction explicit.
7. State the exact smooth and compactified boundaries: finite-etale over the
   modular open, ramified at the two cusps after compactification, and no claim
   that every cubic boundary point is a modular cusp.

## Acceptance gates

- self-contained human proofs of the theorem spine;
- source-level literature pinpoints and a priority boundary obeying the
  literature-audit conventions;
- tracked deterministic evidence script, compact output, SHA-256 manifest,
  and an independent algebraic or subgroup cross-check;
- clean manuscript build, warning rejection, page inspection, and a hostile
  mathematical cold read;
- `ej` + `tt` closeout and a mystery ledger before completion;
- mirror/export only after the paper passes locally and the export conventions
  have been read.

## Scope brake

The paper is about the modular resolvent of the actual gluing packet.  Fricke
correspondences, arithmetic trace laws, rational elliptic surfaces, Winger
shadow-sister comparisons, motivic fifth-power decompositions, and explicit
Mordell--Weil generators remain outside unless one short corollary materially
clarifies the main theorem without adding a new proof dependency.
