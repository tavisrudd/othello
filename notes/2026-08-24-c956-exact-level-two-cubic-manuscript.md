# C956 -- exact level-two cubic manuscript

**Lane:** cubic-threefolds

**Status:** release candidate; reopened for multiple hostile referee rounds

## Result

The replacement paper is *Sharpness of Irrationality after One Stabilization
for Cubic Threefolds*. For each of the two displayed smooth cubic threefolds
`X/Q`, it proves

`ell_Q(X) = ell_C(X_C) = 2`.

Its reusable geometric theorem proves `S x A2` rational for a smooth quartic
del Pezzo surface over a characteristic-zero field when `S(k)` is nonempty
and the geometric Picard lattice is stably permutation. Its structural theorem
gives a rational Rosenlicht quotient from a descended unimodular tangent
section for a projectively linear torus action.

The same argument gives `X_{j,r} x P2` rational for every member of both
explicit cubic families. For the cubic threefold members,
`Y = X x P1` is a nonrational smooth projective fourfold over `Q`, remains
nonrational over `C`, and satisfies `Y x A1` rational over `Q`.

## Framing and source boundary

The paper leads with the exact cubic level, presents the quartic-del-Pezzo
theorem as the engine, and presents the fourfold as a consequence. It credits
Tschinkel--Zhang's Cox/OADP geometry, four-type classification, torsor
density and splitting, and explicit fibrations at their points of use. The
rank-three quotient, descended tangent section, two-variable conclusion, and
generic-fibre function-field deduction are proved in the paper.

The positive direction of their Corollary 4.3 therefore holds with the
explicit `A2` bound, and their cubic-family stable-rationality conclusions
hold with the `P2` bound. The paper does not use a priority or literature-
absence assertion.

## Proof and release audit

- The projective weights are handled up to common translation; only the
  selected weight sum and its complement are asserted to descend.
- Saturation removes the spurious projective `mu_2` kernel.
- The quotient proof gives signed-minor orbit correction, isolates the image
  component, makes that same component meet the tangent-projection
  isomorphism open, and records an inverse graph with both composites.
- The incidence proof chooses one orbit-test point in the tangent-projection
  open and takes the kernel of evaluation there; this forces the
  maximal-minor and tangent-open conditions to hold on the same component.
- The generic-fibre proof is an explicit function-field identity and invokes
  no specialization principle.
- The Proposition 5.2 cubic tail is transcribed as
  `x_3^3 - x_3*x_4^2 + x_4^3`.
- The coefficient wall is confined to an appendix; the main proof has a
  compact four-witness table and geometric explanation.
- `make check` passes in the authority. The PDF is warning-free, ten pages,
  and its revised title and first-page hierarchy have been visually inspected.
- The exact-arithmetic replay reconstructs the Cox weights, saturation,
  tangent matrices, eight localized branches, and Bezout identity from the
  transcribed source data. A second checker verifies the resulting
  certificate, and all verification programs reject optimized Python so that
  assertions cannot be bypassed.
- No Lean development formalizes the new result; the claim map records
  coverage as `absent`. The earlier unrelated paper-local Lean package was
  audited and removed with the obsolete manuscript rather than represented as
  coverage of this theorem.
- No archival DOI is claimed for this revision. The old concept DOI still
  resolves to the retired manuscript and has been removed from release-facing
  README surfaces until a new version is deposited.

The repaired authority remains ahead of standalone commit `d7dd18a`; the
standalone mirror, export provenance, and public GitHub repository must be
updated only after the present hostile-review round passes. The removed
conditional sources remain recoverable from Git history.

## EJ + TT closeout

The closeout pass added the constructive interpretation of the quotient
theorem: a tangent-section witness computes the orbit correction by signed
maximal minors and the inverse parametrization by elimination. It also
narrowed the imported torsor dependency from the final universal-torsor
rationality theorem to the density, splitting, and Cox-embedding statements
actually used, and expanded the descent incidence as a relative frame-bundle
open.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Can the abstract signed-minor construction be expanded into compact explicit rational maps for `X_j x P2`? | open and valuable | successor should compute, simplify, and independently verify the two maps; no such formula is claimed here |
| Does the rational CARAT class `(5,232,15)` with non-retract-rational dual yield a separate torus theorem? | open, independent | requires a dedicated post-2017 source audit and standalone proof packet; excluded from this paper |
| Is there kernel-checked formal coverage of the new quotient and rationality theorems? | open coverage gap | claim map honestly records `absent`; a future formalization needs its own task and scope |
| Is any global firstness claim supported? | settled editorially | none is needed or made; the theorem is stated on its mathematical content and exact source chain |
| Is there a remaining descent, saturation, incidence, or function-field gap found by the cold audits? | under final recheck | the latest same-component gap is repaired in the authority; fresh quotient and geometry reads must accept it before release |

The hostile referee rounds requested after the first release-candidate build
remain an acceptance gate. Their findings and repairs will be appended here
before final closure.

**Vibe:** strong mathematical candidate, not yet releasable. The authority
gate is green; standalone, public GitHub, Zenodo, and fresh hostile verdicts
remain outstanding.
