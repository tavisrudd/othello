# C797 — trade-only carrier reconstruction

**Lane:** `clebsch`

**Status:** complete; the carrier-free theorem fails sharply at \(q=7\)

## Goal

Turn Paper II's priority collision into a reverse reconstruction theorem.
Remove the residual hypothesis that the configuration is already a full
\(\operatorname{PGL}_2(q)\)-orbit of perfect matchings.  Start instead with a
full orbit in the affine conic-quotient module whose strength-two trade space
is one-dimensional with a two-valued generator.  Decide whether that datum
reconstructs a hidden matching/factorization carrier and forces exactly
\(B_3/\mathbf F_7\) or \(H_3/\mathbf F_{11}\).

The current Paper II theorem is the fallback: it assumes the perfect-matching
carrier but already derives the two sheets, their size, and the exact
\(B_3/H_3\) list without a self-duality or Gorenstein premise.

## Frozen distinction

Rodr\'iguez-Pajares--Ruano--Salizzoni (2025) own the general passage from a
self-dual code and its Schur-square/block defect to arithmetic
Gorensteinness.  C797 runs in the reverse direction and has a different
input: an intrinsic two-valued quadratic residue in the conic-quotient
representation, with neither self-duality, Gorensteinness, nor a matching
realization assumed.

## Starting evidence

- C665's Platinum analysis already proves the common-quotient identity for
  the two sheet evaluations and closes the matching-orbit \(\lambda>1\)
  branches, including the first nonretracting \(q=121\) module.
- The current uniform theorem therefore removes the one-factorization
  premise but not the perfect-matching carrier.
- The trade line itself forces a \(G^+=\operatorname{PSL}_2(q)\) two-block
  system and opposite values.  What is missing is a theorem recovering the
  endpoint-pairing incidence or proving that every admissible affine orbit is
  one of the matching images.
- The hyperplane-square lemma already makes the cubic nonzero once the unique
  full-support trade is known; it is downstream and cannot recover the carrier
  by itself.

## First gates

1. Specify the carrier-free orbit category exactly: the affine hyperplane in
   the extension
   \(0\to F\to E\to\mathbf1\to0\), its projective equivalence, and the
   evaluation space attached to an orbit.
2. Run a deterministic exhaustive falsifier in the first feasible fields,
   beginning with \(q=5\) and \(q=7\), over all affine-module orbits rather
   than only matching images.  Record orbit size, affine rank, Schur-square
   rank, trade dimension, and value profile.
3. If the statement survives, identify the module-theoretic invariant that
   recognizes the Veronese/matching image inside the affine hyperplane and
   replay the \(q=121\) nonretracting gate in that carrier-free language.
4. If it fails, classify the smallest extra fibres and test the nearest exact
   repair: a radial condition, a specified affine-span quotient, or a minimal
   incidence axiom weaker than an assumed matching carrier.

## Acceptance

- Positive: a human reverse theorem reconstructs the matching/factorization
  carrier from the trade and yields the exact \(B_3/H_3\) classification.
- Negative: an exact smallest counterexample and a structural obstruction
  theorem identify why the trade forgets the carrier, together with the
  nearest positive hypothesis and adjacent crown.
- Every paper-facing finite result ships as one atomic report/script/JSON/hash
  bundle with an independent replay or an explicit reason none is available.
- Run the required bounded novelty audit, then an `ej`+`tt` closeout and
  mystery ledger before manuscript placement.

## Ownership

C797 owns its task card, dated report and reproducibility bundle, exact queue
archive row, and Clebsch handoff updates.  It makes no Paper II theorem change
and does not alter C749's current-theorem human freeze or C750's same-spine
Lean gate.

## Result

The first exhaustive affine-module gate closes the proposed theorem
negatively.  At \(q=7\), the \(S_4\)-fixed locus is an affine line of seven
points.  Its points generate seven distinct size-\(14\) orbits, all with the
same unique two-valued trade profile; only one is a matching orbit.  Full
affine rank and the first coarse cubic singularity invariant do not select the
matching placement.  Complete reducibility of one polynomial lift is the
nearest exact repair and reconstructs the matching carrier.

Report and atomic evidence bundle:
`notes/2026-08-02-c797-trade-only-carrier-obstruction.md` and
`notes/2026-08-02-c797-affine-orbit-falsifier.{py,json,sha256}`.
