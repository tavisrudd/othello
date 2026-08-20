# C933 -- Hodge-atom marker-ledger companion closeout

## Result

C933 is complete.  `papers/hodge-atom-marker-ledger/` is a self-contained
six-page companion proving that the standard Hodge-atom chemical formula is
the abstract Hodge specialization of the occurrence-indexed categorical
marker ledger.  It develops the occurrence carrier, presented thin groupoid,
free effective commutative monoid, additive fold, and dimension quotient
before deriving the strictly one-step rank-two projective-bundle obstruction.

The epilogue contains exactly one non-load-bearing sentence pointing to the
companion.  Its theorem graph is unchanged and its checked PDF remains fifty
pages.  No Gamma-row source was touched, and neither manuscript states an
`m=2` or all-stabilization result.

## Source and citation audit

`notes/2026-08-20-c933-hodge-atom-source-audit.md` records the authoritative
KKPYY v2 source and exact theorem/definition pinpoints used for terminology and
type boundaries.  The audit also checks Iritani's blowup input and the
Iritani--Koto projective-bundle input.  The companion proves the ledger algebra
and weak-factorization descent internally; imported quantum-D-module providers
are cited at theorem level.  It never identifies the abstract atom quotient
with the geometric atomic F-bundle classes: the literature supplies only the
map from abstract to geometric classes at the cited boundary.

## Hostile proof and copy read

The final pass attacked the following failure modes.

- Sheet multiplicity is retained without pretending that a connected
  degree-`m` cover has canonical sheet labels: labels are internal occurrence
  relabellings and are forgotten by the thin groupoid.
- The fold lands in the effective monoid and sums multiplicities blockwise;
  no group completion or cancellation is used.
- The weak-factorization quotient kills exactly the lower-dimensional center
  terms required in ambient dimension `d`; the stated birational result starts
  at `d >= 2`.
- Abstract Hodge atoms, geometric atomic F-bundles, and the sibling direct-QDM
  marker remain three separately typed constructions.
- The general projective-bundle provider is used only to explain the quotient
  law.  The advertised stabilization consequence is rank two and one step.
- The epilogue cross-reference is explanatory prose, absent from theorem
  hypotheses, proofs, formal annotations, and dependency edges.
- A final Milnor-order and notation pass found no unresolved ambiguity,
  dangling reference, typography defect, or hidden scope enlargement.

No mathematical or editorial blocker remains.

## Validation and release

- Authority companion: `make check`, warning-free, six pages, 77,500 bytes.
- Authority epilogue: `make check`, source-only formal correspondence gate and
  warning-free build, fifty pages, 365,522 bytes.
- Companion standalone: `make check` and exporter `verify` pass; initial
  release commit `99c3d82`, DOI refresh commit `ff6fb14`, and manifest source
  commit `5b7c2d912e080eb0921fe6479d7926b4229d3e22`.  The public README carries
  the DOI badge for `10.5281/zenodo.22036391`.
- Epilogue standalone: the obsolete atomic-section filename was removed in
  the separately reviewable forward commit `d262c9b`; exporter sync, local
  `make check`, and exporter `verify` pass in commit `2b2d780`.
- The epilogue manifest names immutable authority source commit
  `d9e3054a72f4c32574567c30be60a833dd5cf91f`.  Both standalone paper
  worktrees are clean.  Nothing was pushed.

The portfolio summary now lists the companion with PDF, repository, and DOI
entry points.  Its epilogue abstract has also been refreshed from the current
categorical-proof-spine abstract rather than retaining the superseded
Hodge-atom version; the standalone portfolio summary carries this in commit
`cb2559f` and is clean.

## `ej` + `tt` closeout

The cheap extra value was to make the companion genuinely reusable rather
than merely extract prose: its universal ledger theorem now exposes the exact
specialization interface, and the Hodge and direct-QDM constructions can be
read as siblings without either one carrying the other's analytic input.  The
Tao-style pressure test was whether any named occurrence, geometric atom, or
projective-bundle identity was being treated as canonical beyond its source.
The internal-relabeling convention and the explicit abstract-to-geometric type
boundary settle those points.  No further task-owned shortening or theorem is
free without reopening the manuscript-design decision.

## Mystery ledger

- **Occurrence labels:** initially suspicious because cover sheets are not
  canonically labelled; settled by internal relabelling modulo the presented
  groupoid.
- **Abstract versus geometric atoms:** initially easy to conflate; settled by
  retaining the one-way literature map and never asserting injectivity.
- **Effective versus group quotient:** settled by using the free commutative
  monoid throughout, so the chemical formula does not acquire cancellation.
- **Remaining mysteries:** none genuine within C933.  Any decision to absorb
  the companion into the epilogue, shorten the epilogue around it, or pursue
  higher stabilization belongs to a later author-controlled task.
