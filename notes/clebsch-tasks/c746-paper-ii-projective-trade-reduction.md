# C746 — Paper II projective--trade reduction

**Lane:** `clebsch`

**Status:** complete; human proof round 1/4

## Objective

Replace the asserted projective--trade bridge in
`lem:uniform-sheet-exclusion` by a short, invariant proof that makes the
logical reduction from a two-valued quadratic trade to the relevant
extension class completely explicit.

## Proof standard

- Work with the sheet permutation module, augmentation sequence, Schur
  square, and the outer involution as intrinsic objects.
- State one abstract lemma whose hypotheses are exactly those used later and
  whose conclusion isolates the only possible obstruction.
- Prefer exact sequences, adjunction, projectivity, and parity eigenspaces to
  bases, matrices, coefficient tables, or case enumeration.
- Separate the formal homological argument from the later
  representation-specific non-splitting input.
- Cite every imported modular-representation fact at theorem level.

## Acceptance gate

The manuscript contains a self-contained proof from the trade hypothesis to
one precisely named extension/non-splitting obligation.  A cold reader can
reconstruct every map and implication without consulting a checker, task
report, or coordinates.  No executable evidence is load-bearing.

## Boundaries

C746 does not prove the Lucas-socle or first-wall theorem; C747 owns that
obligation.  It may simplify or delete obsolete computational scaffolding but
must not weaken the all-`q` theorem.
