# C928 -- standalone blown-up-theta integral lattice paper

**Lane:** cubic-threefolds

**Status:** active; split from C908 by author instruction on 2026-08-20

## Stable entry points

- structural saturation theorem:
  `notes/2026-08-20-c928-structural-saturation.md`

## Goal

Produce a self-contained standalone paper on the integral cohomology of the
resolved theta divisor

\[
M=\operatorname{Bl}_0\Theta
\]

of the intermediate Jacobian of a smooth cubic threefold.  The paper must
replace finite-certificate discovery steps by human structural proofs, state
the exact integral lattice and escape group without the superseded
`(Z/2)^10` error, derive the intersection-cohomology consequence for
`Theta`, and delimit novelty against the full primary-source boundary.

C908 retains the generic relative Chow-index and intrinsic `p`-typical
classification problems.  C928 may cite their shared geometric setup but
must not claim to solve either crown.

## Theorem package in hand

- `H^3(M,Z)` is torsion-free of rank 130.
- It is a nonsplit integral extension of `H^3(X,Z)` by `wedge^3 Lambda`, with
  glue described by the mod-two map `rho`.
- `b_*H^3(M,Z)` is the saturation of
  `Theta wedge wedge^3 Lambda` in `wedge^5 Lambda`, of index `2^10`.
- The degree-six Fano-surface model transfers integrally onto the full
  lattice.
- The escape group
  `H^5(M,Z)/(b^*H^5(J,Z)+tors)` is free of rank ten, and the exceptional
  Gysin image is exactly its doubled sublattice.

Authority notes begin with:

- `notes/2026-08-12-c908-h3-lattice-adjudication.md`;
- `notes/2026-08-12-c908-h3-compression.md`;
- `notes/2026-08-12-c908-z2-naturality-checks.md`;
- `notes/2026-08-12-c908-h3-lattice-proof-audit.md`;
- `notes/2026-08-12-c908-h3-lattice-priority-audit.md`.

## Work plan

1. Freeze the exact theorem statements and dependency graph, distinguishing
   structural arguments from certificate-backed discovery and from imported
   geometry.
2. Prove structurally, for a general rank-`2g` unimodular symplectic lattice,
   the saturation formula and the surjectivity/naturality of the glue map
   needed at `g=5`.
3. Reassemble the geometric theorem, including integral base change through
   the degree-six Fano model and the corrected free escape lattice.
4. Derive `IH^*(Theta,Z)` to the strongest coefficient level justified by
   the decomposition theorem and the local singularity calculation.
5. Close the two inherited debts that affect paper correctness: the false
   relative-Ext twist-lemma branch and the incorrect non-descent statement in
   the lambda note.  Quarantine material not used by the paper rather than
   importing it.
6. Complete a bounded full-text source audit centered on Beauville LNM 947,
   Kraemer, and Artebani--Kloosterman--Pacini, plus the general symplectic-
   lattice lemma's predecessor boundary.
7. Write and validate `papers/blown-up-theta-lattice/` with a compact
   certificate/replay appendix only where computation remains expository.
8. Run hostile proof, priority, consistency, and `ej`+`tt` closeout passes;
   refresh the mystery ledger and commit the complete evidence bundle.

## Acceptance criteria

- Every headline lattice assertion has a coordinate-free proof; finite
  computation is corroboration, not the sole proof.
- All imported geometric and topological inputs have precise primary-source
  loci or are proved in the paper.
- The `IH^*(Theta)` corollary states exactly what follows integrally,
  rationally, and with any torsion caveats explicit.
- The deck/mod-two naturality observation is presented only as a trivial
  action warning, never as a label-selecting companion theorem.
- The relative-Ext and attribution debts are either repaired or proved
  irrelevant and explicitly excluded from the dependency graph.
- The manuscript, source audit, theorem-dependency map, and compact replay
  evidence are committed atomically enough to reproduce every paper-facing
  computational claim.
- No C907/C908/C909 manuscript, mirror, or Lean source is changed.

## Owned paths

- `notes/cubic-threefolds-tasks/c928-blown-up-theta-lattice-paper.md`
- `notes/2026-08-20-c928-*.md`
- `papers/blown-up-theta-lattice/`
- the C928 row in the live queue and C928 entry in the cubic-threefolds
  handoff
- narrow C908 scope annotations required to record the split

Standalone-mirror creation or synchronization is not authorized until the
authoritative monorepo paper passes its acceptance gates.

## Next

Prove the endpoint Pontryagin/divided-power identity for
`b_*q_*mu^*(beta tensor 1)` and use the integral cylinder isomorphism to
close the onto half of the glue map.
