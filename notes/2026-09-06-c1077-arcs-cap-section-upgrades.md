# C1077: cross-citations and cap-section upgrades

**Lane**: `relconic`
**Date**: 2026-09-06
**Status**: done; both manuscripts rebuilt through their gates.

## What changed

Arcs/caps paper (`papers/arcs_complete_outside_conic/`):

1. A relationship paragraph after the pencil bound, placing this paper against Integral Secant
   Arcs: the same integer remainder on a different incidence structure (secant–secant collisions
   here, point–block degrees of the maximal-secant family there), neither result containing the
   other. New bib entry `RuddIntegralSecant` with the Zenodo DOI.
2. `prop:plane-fan` (plane-fan bound), after the secant-local coverage theorem: for every secant,
   `Λ(A) ≥ 2T_ℓ + 2T_ℓ²/(k−2)`, and for every covered point `Λ(A) ≥ r(x)² − 1`, where
   `Λ(A) = N(q−1) − |Y|` is the total overlap loss. Consequences stated: `T_ℓ = O(k√q)` and
   `r(x) = O(√(kq))` one step above the counting bound in higher dimension. Full proof in the
   paper; audit row in the proof-audit ledger.
3. One sentence in the higher-dimensional problem of the conclusion pointing at the new
   proposition as the only unconditional concentration bound so far.
4. The deterministic checker's expected page count moved from 35 to 37 to admit the addition.

Integral Secant Arcs (`papers/integral_secant_arcs/`):

5. A paragraph in the introduction, after the mechanism paragraph, naming the arcs/caps paper as
   the secant-collision counterpart of the same counting step. New bib entry `RuddSecantDefects`
   with the Zenodo DOI.

Trust metadata: paper facts re-extracted for both papers. The bib title of Integral Secant Arcs
inside the arcs paper must use the manuscript's exact `\((k,n)\)-Arcs` form, or the facts checker
reports citation-title drift.

## Verification

- Arcs paper: `nix develop .#manuscript --command python3 verification/check_manuscript_build.py`
  passes, 37 pages, warning-free, byte-reproducible.
- Integral Secant Arcs: `make lint` and `make warnings` pass (spacing lint, no LaTeX warnings, no
  undefined citations).
- `python3 lean/scripts/paper-facts.py check` reports no finding for either paper; the 34
  remaining errors are pre-existing and belong to other papers.

## Hand verification of the proposition

Checked at intake and again while writing the proof: the planar loss inequality
`6C(z+2,4)/⌊(z+2)/2⌋ ≥ (z+1)C(z,2)` by parity of `z`; additivity of losses across the planes
through the secant, including the shared points on the secant itself; the second moment
`Σ z_π² = k − 2 + 2T_ℓ` from the pencil identity; Cauchy–Schwarz on `(z^{1/2}, z^{3/2})`. For the
index bound: the `2r(r−1)` cross-secants are pairwise distinct, distinct from the `r` secants
through `x`, and each carries a collision point outside the cap. No computation is involved.

## Not done here

- Astra's Proposition 4 was not added: it is the paper's existing `φ_m`.
- The hyperplane-excess identity, the secant–hyperplane moments, the integer feasibility bounds,
  and the `PG(4,q)` exclusions are reserved for the third paper (C1078), gated on the literature
  check (C1075).
- Math-papers sync of both papers was not run; the last arcs sync predates these edits.
