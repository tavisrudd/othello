# C956 -- exact level-two cubic manuscript

**Lane:** cubic-threefolds

**Status:** referee-accepted release candidate; active by author instruction

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
- The incidence proof is carried out over the relative frame-bundle open.  In
  split coordinates, evaluation at one orbit-test point in the
  tangent-projection open gives a linear functional on the four-dimensional
  space of hyperplanes through the tangent space; its kernel forces the
  maximal-minor and tangent-open conditions to hold on the same component.
- The generic-fibre proof is an explicit function-field identity and invokes
  no specialization principle.
- The Proposition 5.2 cubic tail is transcribed as
  `x_3^3 - x_3*x_4^2 + x_4^3`.
- The coefficient wall and exact witness table are confined to an appendix;
  the main proof first explains the geometric open condition and rank
  argument that the certificates verify.
- `make check` passes in the authority. The PDF is warning-free, eleven pages,
  and every page has been visually inspected after the exposition repairs.
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

The current manuscript authority change is commit `b0241f344`; portfolio-
summary authority commit `d93878af3` carries the same abstract.  Standalone
paper commit `c50aa13` and portfolio-summary commit `13b3ea1` record the
synchronized exports.  Both paper release gates and
export-manifest verification pass, with content digest
`c6e773f83fbf7660c5c91a08acd045e7efcee72a3ff0db9aaffed3334baf288c`.
The authority and mirror PDFs are byte-identical with SHA-256
`f0e7c845585c15c4130883de86eef0759983264d3c1004c040b8a00319b55dcb`.
The public GitHub remote has not been pushed. The removed conditional sources
remain recoverable from Git history.

## EJ + TT closeout

The closeout pass added the constructive interpretation of the quotient
theorem: a tangent-section witness computes the orbit correction by signed
maximal minors and the inverse parametrization by elimination. It also
narrowed the imported torsor dependency from the final universal-torsor
rationality theorem to the density, splitting, and Cox-embedding statements
actually used, and expanded the descent incidence as a relative frame-bundle
open.  The cross-specialty read then exposed two trust-boundary issues that
were mathematical rather than cosmetic: the singular-compatible tangent-
projection input is Tschinkel--Zhang Theorem 2.4, not the smooth historical
Ciliberto--Mella--Russo result, and Proposition 3.2 must be stated over a
characteristic-zero field.  Both are now explicit, and a fresh isolated
referee accepted the repaired source with no required correction.

The final synchronization pass defined the stabilization-level notation in the
paper README, made the abstract's ground fields literal, and replaced the
portfolio's older abstract paraphrase with the current abstract.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Can the abstract signed-minor construction be expanded into compact explicit rational maps for `X_j x P2`? | open and valuable | successor should compute, simplify, and independently verify the two maps; no such formula is claimed here |
| Does the rational CARAT class `(5,232,15)` with non-retract-rational dual yield a separate torus theorem? | open, independent | requires a dedicated post-2017 source audit and standalone proof packet; excluded from this paper |
| Is there kernel-checked formal coverage of the new quotient and rationality theorems? | open coverage gap | claim map honestly records `absent`; a future formalization needs its own task and scope |
| Is any global firstness claim supported? | settled editorially | none is needed or made; the theorem is stated on its mathematical content and exact source chain |
| Is there a remaining descent, saturation, incidence, characteristic-scope, or function-field gap found by the cold audits? | settled | the relative-open, singular-input, and characteristic-zero repairs passed a fresh isolated referee; no required gap remains |
| Does the split-coordinate display `H_p -> k^4` need another sentence? | settled exposition | the main proof now defines the evaluation map and its open condition before invoking the exact witnesses; the table and certificate are in Appendix A |

No genuine mathematical mystery remains in the present manuscript.  The first
three rows describe successor work or optional production coverage, not a
release defect.  C956 remains active solely because the author instructed that
it not be closed and because publication and Zenodo synchronization are still
external actions.

**Vibe:** green, synchronized, and referee-ready; no required cross-specialty
accessibility or correctness defect remains.
