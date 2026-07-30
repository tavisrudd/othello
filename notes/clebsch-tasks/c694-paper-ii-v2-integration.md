# C694 — Paper II v2 synthesis and integration

**Lane:** `clebsch`

**Opened:** 2026-07-29

**Status:** queued and unblocked; manuscript integration.

## Objective

Integrate the C665/C688/C689 upgrade as one Paper II v2 theorem arc:
uniform balanced-orbit classification, generic first-wall verification,
and canonical alternating-cycle radial nonvanishing.

## Work package

1. Replace the residual type-by-type \(B_3/H_3\) ending by C689's common
   edge-selected alternating cycle and Dickson/resultant proof.
2. Present the Paley design/Hadamard carrier only where it explains the
   construction or orientation; do not let the extra structure bury the
   theorem spine.
3. Apply C692's maximal-isotropic quotient proof to shorten the
   Gorenstein argument.  Do not present the cross-sheet design as the
   Gorenstein pairing: it misses the radial/common-sum pair by one
   dimension.  Retain C689 only for radial nonvanishing.
4. Retire field-sized replay from the load-bearing path in favor of C688's
   generic local checker, retaining historical cases as corroboration.
5. Rework title/abstract/introduction/headlines and theorem dependencies,
   update the trust surface, run the full replay, and obtain a fresh cold
   read against v1.

## Boundaries

- Record the frozen v1 baseline and do not hold its release.
- Keep Paper II standalone and preserve Paper III's surprise results as a
  cliffhanger rather than importing their machinery.
- Do not generalize C689 beyond the classified \(B_3/H_3\) configurations.
- Run the required targeted novelty audit before any new priority wording.
- Synchronize an accepted authoritative v2 change to the standalone mirror
  only as an ordinary forward commit.

## Inputs

- C665: `notes/2026-07-29-c665-frobenius-digit-spill.md`
- C688 generic replay record
- C689: `notes/2026-07-29-c689-shared-radial.md`
- C692: `notes/2026-07-30-c692-cross-sheet-gorenstein.md`
