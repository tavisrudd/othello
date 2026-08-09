# C897 Paper III sealed regrade synthesis

**Lane:** `clebsch`

**Date:** 2026-08-09

**Standalone commit:**
`9fe1f912d0fb48d61a1b2587387d1a2516c3afb8`

**PDF SHA-256:**
`a9e270277638e0a345d5385d73f6186df47dd68074a70675af3e31deca83090d`

**PDF extent:** 32 A4 pages, 232,877 bytes, PDF 1.7.

## Categorical outcome

All four independent repaired-artifact reads passed:

- Hitchin full-paper geometric regrade: `PASS`;
- Greaves table/design regrade: `PASS`;
- Snowden complementary-minor/orientation regrade: `PASS`; and
- Si Kaddour reconstruction/query regrade: `PASS`.

No reader returned an unresolved `MAJOR` or `MINOR`.  Numerical grades were
not written to disk.

The frozen reports and SHA-256 digests are:

- `notes/2026-08-09-c897-paper-iii-hitchin-regrade.md`,
  `5ce3aef4cfbe9dac70d54bdf721445316707d286fac61a5a378aa0ec37892b57`;
- `notes/2026-08-09-c897-paper-iii-greaves-regrade.md`,
  `862dc485519fa38b11e8c6001a151dd1466ee8bd443b4dd7925c9dc631dcd267`;
- `notes/2026-08-09-c897-paper-iii-snowden-regrade.md`,
  `50516eada364f04a27c8fb65e2f27386c43fe76ccebbfcc49aa0d795b86dc0b8`;
  and
- `notes/2026-08-09-c897-paper-iii-si-kaddour-regrade.md`,
  `cf495e655c2da9f7a32485d8d697f8116998c0c37808138ca908d8cdb0f59c97`.

## Disposition of the first-batch MAJOR

The first-batch MAJOR was a proof error: a load-bearing scheme-theoretic
implication was absent.  It was not a demonstrated false theorem and was not
merely exposition or framing.  The accompanying exact-scale ambiguity and
citation overreach were proof-boundary/framing defects caused by the same
omission.

Git-history and related-note forensics found that no complete proof had been
compressed during manuscript editing.  The citation-only jump was present
when the arithmetic theorem first entered the manuscript and survived later
edits.  The repaired paper now owns the missing argument: canonical classes
give ramification divisor class `3h`; generic degree two gives branch-cycle
degree six; the dense real boundary inserts Hitchin's irreducible sextic; and
degree exhaustion plus tame quadratic ramification makes it the complete
reduced multiplicity-one branch divisor.  The finite-etale comparison then
makes the `xyz` fibre complete and reduced, while the chart pullback fixes one
exact internal rational `J_0` scale.

Hitchin's regrade independently reconstructed that chain and found it sound.

## Disposition of the local MINOR findings

- All six Table (5.1) words now reproduce exactly from the printed conference
  matrix, permutations, parity twist, and subset order.  The corrected `r=2`
  word is `+-+-+---++--+++-+-+-`.
- The complementary-minor bridge now displays both triangle-orbit
  representatives, their determinants, Hodge signs, and internal triangle
  products.  The transported determinant-line orientation fixes the
  cross-golden identity as an exact equality rather than an unexplained sign.
- The Holtz--Sturmfels comparison is restricted to its strict nondegeneracy
  hypothesis; the paper's actual Seidel step is unconditional.  The adaptive
  argument uses six known points and proves that one further alignment query
  distinguishes the two candidate rooted values.
- `aligned` is explicitly translated as the union of the coherent and
  incoherent four-set types, and every reconstruction boundary stops at the
  correct complement/global-negation ambiguity.

The three focused regrades independently found these surfaces correct.

## Artifact closeout

The authoritative manuscript repair is in source commit
`457e15c6e6e3c761f1c8106803f5cf007e8aa045`.  The normal exporter audit found
no private-repository coupling.  The standalone exporter identity verifies
all 64 tracked files against that immutable source, and the clean mirror's
paper-only aggregate passes its allowlist, vocabulary, statement, trust,
companion-pin, primary/independent/checksum evidence, spacing, and
deterministic manuscript-build checks.

Per author direction, no Lean work was performed in this closeout; the
standalone aggregate therefore reports its three Lean gates as unchecked.
Any Lean follow-up belongs to a separately queued lane.  The exact integral
exceptional-prime set and immutable formal-companion publication remain
explicit research/release boundaries, not unresolved C897 manuscript review
findings.

**C897 categorical closeout:** `COMPLETE`.
