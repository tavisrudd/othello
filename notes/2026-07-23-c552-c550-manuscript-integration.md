# C552 — integrate the C550 cover-holonomy theorem into the Clebsch manuscript

**Lane:** `clebsch`

**Date:** 2026-07-23

**Status:** queued; pre-C320-final-review manuscript delta

## Goal

Replace the manuscript's certificate-first account of the four-copy contraction by C550's
reader-facing linear-sheaf theorem.  The paper should explain, before its verification boundary,

1. why constant sections give the universal three-dimensional kernel;
2. how the `24 x 21` system reduces to nine two-matching holonomy blocks on
   `k^4/k(1,1,1,1)`;
3. how the cycle ledger derives `z=2,4/9`;
4. how relative octahedral frames give the `96/192` multiplicities and `8/16` `A4` quotients; and
5. why the characteristic-7 merger and the ramification-only primes have different meanings.

Use the Milnor/Serre presentation already established in C550.  Keep the conceptual proof,
finite certificate, and exact trust boundary visibly separate.

## Required correction

Remove or correct every manuscript-facing use of C548's two inaccurate degree-six representation
descriptions:

- the order-24 group is the rotational octahedral action on six vertices, with point stabilizer
  `C4`, not the tetrahedral edge action with point stabilizer `V4`; and
- the axial `C2^3` seam has orbit sizes `2+4`, not `2+2+2`.

The abstract groups, double-coset sizes, common derived `A4`, and `8/16` quotient counts remain
unchanged.  State that the full octahedral symmetry belongs to the reduced linear transport frame,
not the bare bipartite multigraph.

## Acceptance gate

1. Integrate one compact theorem/proof path into the replacement-spine manuscript; do not add a
   competing spine or reproduce the checker narrative.
2. Preserve the exact hypotheses and boundaries: admitted non-GRS pencil, odd characteristic,
   signed versus reduced sheets, boundary coincidences versus pullback ramification, and no claim
   of complete pencil recovery.
3. Add or update the C320 claim/evidence and adequacy ledgers for every adopted C550 statement,
   including the exact report/checker/certificate hashes and mixed-verification boundary.
4. Correct all affected theorem prose, captions, tables, verification rows, and cross-references.
5. Render the manuscript and rerun its scoped deterministic release checks.  Any C320 independent
   review performed before this delta is stale; the required final review must cover the resulting
   manuscript and return `GO`.
6. Follow `papers/style-guide.md`.  Make no novelty claim without a claim-specific literature
   audit; C550 itself makes none.

## Stop rule

Stop when the manuscript and C320 release package consume C550 cleanly and pass their scoped local
gates.  Do not reopen four-copy minimality, the uniform `LU=LC` conjecture, a larger contraction
census, Paper 2, or the paper's global architecture.  Do not archive C320 or C552 before the
post-delta independent-review `GO`.

## Frozen inputs

- `notes/2026-07-23-c550-four-copy-cover-holonomy.md`
- `notes/2026-07-23-c550-four-copy-cover-holonomy.py`
- `notes/2026-07-23-c550-four-copy-cover-holonomy.json`
- `notes/2026-07-23-c550-four-copy-cover-holonomy.sha256`
- `notes/2026-07-23-c548-c397-contraction-rank-drop-divisor.md`
- `notes/2026-07-23-c396-holonomy-completeness.md`
- `notes/2026-07-20-c320-clebsch-trust-ledger.md`
- `papers/style-guide.md`
- `papers/clebsch-hexagon-code/`

The C550 bundle is authoritative for the conceptual proof and representation correction.  C548
remains the independent exhaustive certificate.  C320 owns the final manuscript trust ledger and
release review.
