# C958 -- explicit level-two parametrizations

**Lane:** cubic-threefolds

**Status:** queued behind C956

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

## First action

Read `../AGENTS.md` in a dedicated command, route with
`go C958 cubic-threefolds`, read this card and the C956 report, then extract
the exact formulas in Theorem 2.1 and Proposition 3.2 before choosing the
type-`I_1` witness. Do not begin from the superseded intermediate bounds.
