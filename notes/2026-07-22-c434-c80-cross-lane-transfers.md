# C434 → C80 cross-lane transfers (assessment, no computation run)

**Lane:** `cap` (consumers); C434/crowns artifacts are read-only inputs.

**Date:** 2026-07-22

Assessment only: no new computation was run; every number cited below is from the frozen C80 or
C434 bundles (`notes/2026-07-12-c80-bulk-exhaustion-probe.md`,
`notes/2026-07-22-c434-double-coset-information-lattice.md` and its JSON certificate). Follow-up
work is owned by the allocated probe tasks below.

## Transfer 1 — q=11 identification falsifier

C80's C447/C460 cloud packet: the `C5` kernel of the cap-frame `D10` partitions the 22 opponent
moves into orbits `1,1,5,5,5,5`, with good/bad branches whole orbits separated by the square
class of the intrinsic edge coordinate `u = XZ/Y²` on the unordered P-edge quotient.

C434 at q=11, `D10` J-class: `K = Stab(M0) ∩ Stab(JM0) ≅ D10` (the golden-pair edge stabilizer,
a Borel of `PSL_2(5)` under the exceptional isomorphism) has orbit sizes exactly `[1,1,5,5,5,5]`
on the 22-point two-sheet space (per sheet `1,5,5`), and the level-2 collapse is the sheet sign
(PSL vs outer = determinant square class).

Falsifier-first question: is C80's 22-move set `G`-equivariantly the C434 two-sheet coset space,
with the `C5` orbits refining the double-coset strata and `u`'s square/nonsquare split equal to
the sheet sign? A yes transports C434's certified fibre identity to the cloud packet, with `u` as
the `D'`-analogue; a no is a clean structural refutation. Bounded either way (both objects are
frozen and 22 points each).

## Transfer 2 — bi-Hecke bimodule as the two-sorted coupling candidate

C80's mystery ledger asks for "a canonical incidence bimodule carrying both conic-word traces and
reply-pencil energy while preserving P/N recursion". Structural candidate:
`e_K F[G] e_H ≅ F[K\G/H]` (C434 clause 3), with the C411 caveat attached: the realized map is
set-faithful but linear-rank-dropping (rank 2 on dimension 6 at q=11). The coupling should
therefore be sought as a set-level stratum labeling with a small linear shadow, not a faithful
linear map — a possible reason no linear bimodule has been found.

## Transfer 3 — stratum-constancy probe for bulk descent

C434's method: intrinsic cheap statistic + orbit coordinate, prove joint fibres = `K`-orbits
(certified fibre identity), then evaluate once per stratum. Applied to C80: stratify the q17
three-intruder transitions (59,153; `Y_NK0` covers 2,822) by the double-coset label of
(prior-triple stabilizer, reply) pairs and test whether `Y_NK0`-membership and P-purity are
stratum-constant on the existing frozen census. Constancy reduces bulk descent to one
representative per stratum; non-constancy refutes stratification as the bulk mechanism before
C82 counts anything.

## What does NOT transfer

- The ej4 Borel/Bruhat/exceptional-isomorphism content is q ∈ {7,11} only: q=13/17/19 have no
  subgroup of order `(q²−1)/2`, so no C434-type domain exists there. Method-level transfer only
  at q=17.
- C434's decorated inversion is a reconstruction statement; it contributes nothing to C80(b)'s
  descent-measure / minimax-potential gap (the `|L|` drain).
