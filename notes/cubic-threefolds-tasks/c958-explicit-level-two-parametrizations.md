# C958 -- explicit level-two parametrizations

**Lane:** cubic-threefolds

**Status:** active; C956's accepted quotient and rationality statements are
frozen inputs

## Current state

The generic split Cox orbit section is explicit and certified over `Q(a,b)`:
three tangent hyperplanes, four signed minors, and all sixteen Laurent
correction factors.  The formulas and replay are in
`notes/2026-08-24-c958-generic-split-parametrization.md` and its adjacent
`.py`, `.json`, and `.sha256` bundle.  The certificate deliberately stops
before inverse tangent elimination.

The first genuine gate is descent.  Tschinkel--Zhang's fibration coordinate
`a` is not the split blow-up modulus `a`; their type computation supplies the
Galois action but not an explicit change to the marked Cox basis.  Begin with
type `I_1`: realize the permuted conic-fibre components over the cubic and
quadratic étale algebras, use trace coordinates to derive the `C2 x S3`-
equivariant descended Cox representation, and express a rational
tangent/orbit-test pair in it.  Descend the four block evaluations and their
Plücker coordinates before expanding the full hyperplanes.

The finite permutation part of this descent is now exact.  After an explicit
`W(D5)` conjugation, the twelve selected Cox coordinates form the regular
type-`I_1` Galois set, while the four boundary coordinates and the four
quotient blocks are both `G/C3`.  Thus the scalar-normalized affine Cox module
has the prospective descended form `L + L^C3`.  The remaining gate is to
construct the scalar normalization and trace coordinates over the generic
function field, not to identify the Galois permutations.  Report and replay:
`notes/2026-08-24-c958-type-i1-descent-action.md` and its adjacent bundle.

The divisor-level change of marking is explicit as well.  Solving the five
singular-fibre component conditions produces exactly sixteen line sections,
indexed by the odd subsets, over the degree-twelve field
`K(r,d,v)`.  Exact substitution checks the cubic equation and the full
`C2 x S3` action on every coefficient.  After contraction of the distinguished
line these are the marked exceptional curves `Ei,Lij,Q`.  The next step is to
contract the five singleton curves, or equivalently normalize their Cox
sections at a rational torsor point.  Report and replay:
`notes/2026-08-24-c958-type-i1-exceptional-sections.md` and its adjacent bundle.

## Goal

Turn the constructive existence proof in C956 into explicit, independently
checkable forward and inverse birational maps for
`X_1 x P2` and `X_3 x P2` over `Q`.

## Stable inputs

- C956 report:
  `notes/2026-08-24-c956-exact-level-two-cubic-manuscript.md`
- theorem and proof:
  `papers/cubic-stabilization-irrationality/cubic_stabilization_irrationality.tex`
- exact tangent certificate:
  `papers/cubic-stabilization-irrationality/verification/slice-cover-certificate.json`
- replay checker:
  `papers/cubic-stabilization-irrationality/verification/check_slice_cover.py`

Load the C956 report and the quotient/tangent/function-field sections, not the
C925 research history.

## Deliverables

1. Choose rational tangent-section witnesses for the type-`I_1` and
   type-`I_3` generic quartic-del-Pezzo fibres used by the two cubic families.
2. Compute the signed-minor orbit correction and inverse tangent projection
   over the corresponding function fields.
3. Compose these maps with the contraction of the distinguished line and the
   cubic fibration to obtain forward and inverse maps for `X_j x P2`.
4. State the dense opens, denominators, and exceptional loci on which both
   compositions are identities.
5. Produce a compact exact certificate and an independent replay. Record
   coefficient growth and formula size; do not claim a complexity bound
   unless a uniform theorem is proved.
6. Decide whether compact formulas strengthen the main paper, an ancillary
   machine-readable artifact is preferable, or the expanded maps are too
   large to improve reviewability.

## Acceptance gate

- Both maps are defined over `Q`, not merely over a splitting field.
- The certificate checks every defining equation after substitution and both
  composites on explicit localized coordinate rings.
- Descent is invariant under common character translation and does not
  reintroduce the nonsaturated `mu_2` cover.
- Function-field variable counts agree with the dimensions involved.
- A human derivation explains the maps independently of the replay.
- Any manuscript change passes the full C956 authority and standalone gates.

## Completed first action

Read `../AGENTS.md` in a dedicated command, route with
`go C958 cubic-threefolds`, read this card and the C956 report, then extract
the exact formulas in Theorem 2.1 and Proposition 3.2 before choosing the
type-`I_1` witness. Do not begin from the superseded intermediate bounds.
