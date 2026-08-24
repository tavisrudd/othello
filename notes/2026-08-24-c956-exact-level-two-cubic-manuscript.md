# C956 -- exact level-two cubic manuscript

**Lane:** cubic-threefolds

**Status:** complete

## Result

The replacement paper is *Explicit Cubic Threefolds Rational after Two
Stabilizations*. For each of the two displayed smooth cubic threefolds
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
- The quotient proof gives signed-minor orbit correction, an inverse graph,
  and both composites on stated dense opens.
- The incidence descent is exhibited as an open in a relative frame bundle.
- The generic-fibre proof is an explicit function-field identity and invokes
  no specialization principle.
- The Proposition 5.2 cubic tail is transcribed as
  `x_3^3 - x_3*x_4^2 + x_4^3`.
- The coefficient wall is confined to an appendix; the main proof has a
  compact four-witness table and geometric explanation.
- `make check` passes in the authority and standalone repositories. The PDF
  is warning-free, nine pages, and visually inspected on the title, theorem,
  quotient, rationality-proof, certificate, and references pages.
- The exact-arithmetic replay checks the Cox weights, saturation, tangent
  matrices, eight localized branches, and Bezout identity.
- No Lean development formalizes the new result; the claim map records
  coverage as `absent`. The earlier unrelated paper-local Lean package was
  audited and removed with the obsolete manuscript rather than represented as
  coverage of this theorem.
- Assigned DOI: `10.5281/zenodo.21937490`.

Authority release source: `2fa9c0564`. Standalone cleanup commit: `2a5f0d2`.
Standalone synchronized commit: `d7dd18a`. Export verification records source
commit `2fa9c056477b5f334d76868a772c4c526ebb69b3` and nineteen tracked files.
The removed conditional sources remain recoverable from Git history.

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
| Is there a remaining descent, saturation, incidence, or function-field gap found by the cold audits? | settled | no fatal gap found; all identified repairs are in the committed manuscript and the integrated gate passes |

No further mystery blocks the present theorem or release.

**Vibe:** strong and clean. The paper now has one sharp cubic statement, one
general geometric engine, and one reusable constructive mechanism, with the
source boundary visible and the obsolete argument absent from the release.
