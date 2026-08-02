# C577 — Paper II factorization memory

**Lane:** `clebsch`

**Opened:** 2026-07-24

**Status:** active under the C182 external-wait exception; the 2026-07-31
newer-math audit reopened the local proof gate for the all-`q`
classification.  Public packaging remains external and must not begin until
that gate closes.

## Objective

Release *Quadratic recovery and cubic orientation in conic matching
quotients* as a standalone Paper II with no proof dependency on Paper I or
Paper III.

## Frozen spine

1. the matching-secant quotient and four-endpoint switch;
2. the \(A_3,B_3,H_3\) configurations and ranks \(3,6,10\);
3. quadratic balanced-sheet recovery and cubic-first orientation;
4. self-association, Schur powers, and Gorenstein duality;
5. decorated \(H_3\) profile, modular, arithmetic, and relative-cubic
   appendices; and
6. a Paper II-owned trust and replay surface.

## Current state

- The general self-associated/Schur-square/Gorenstein mechanism is credited
  to Rodr\'iguez-Pajares--Ruano--Salizzoni (2025).  Paper II's surviving
  headline is the reverse rigidity theorem: the exact \(B_3/H_3\) full-orbit
  classification follows from the two-valued quadratic-trade condition alone,
  without a self-duality or Gorenstein premise, and the recovered sheet sign
  has a nonzero cubic as its first signed tensor moment.
- The manuscript, conclusion, proof/evidence map, and verification
  architecture are complete except for the reopened all-`q` human-proof
  seam.
- The prior technical rereads and post-spine staged cold read returned `GO`,
  but the later audit found that the projective--trade, Lucas-socle, and
  adjacent-wall identifications are stated below referee proof depth.
- All paper-owned semantic evidence paths and the local aggregate replay are
  green.
- Exact findings and completed trust/editorial repairs are recorded in
  `notes/2026-07-31-c577-paper-ii-new-math-audit.md`.

## Next action

Execute four human-proof rounds in order:

1. C746 proves the intrinsic projective--trade reduction;
2. C747 proves the Lucas-socle and first-wall non-splitting theorem;
3. C748 integrates the Serre-style proof and obtains two cold reads; and
4. C749 attacks, compresses, and freezes the final human proof.

Only then may C750 close the Lean gap.

After that local gate and publication authority are both available, freeze
the Paper II package, obtain its immutable locator, insert the final public
citations, run the isolated release replay, and perform the separate release
pass.

## Boundaries

- C665 results are Paper II v2 candidates and do not hold or enlarge v1.
- C682 characteristic-zero material is inventory unless separately promoted.
- Paper I supplies motivation and a future citation, never inherited proof.

## Acceptance and records

Acceptance requires the immutable locator, isolated replay of the frozen
package, a final PDF/release review with no material objection, and closure
of the 2026-07-31 all-`q` proof-depth finding.

Current priority boundary and adjacent-crown extraction:
`notes/2026-08-02-c577-paper-ii-priority-extraction.md`.  Current proof-depth
boundary and mystery ledger:
`notes/2026-07-31-c577-paper-ii-new-math-audit.md`.  Earlier theorem
development remains in
`notes/2026-07-25-c577-clebsch-factorization-memory.md`.

C797 closes the stronger priority-judo continuation negatively: at \(q=7\),
seven \(S_4\)-fixed affine placements share the unique two-valued trade and
only one is a matching orbit.  This confirms that the perfect-matching carrier
in the current theorem is a genuine hypothesis and does not block C749/C750.
