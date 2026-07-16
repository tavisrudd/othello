# Paper: complete repair hypergraphs under concatenation

**Working title:** *Complete repair hypergraphs under concatenation: a
twisted-cubic--axis family.* Author: Tavis Rudd.

**Status:** assembled manuscript. The mathematical chain is Lean-checked under the strict trust
gate, modulo exactly one quarantined literature theorem: Stichtenoth's self-dual TVZ-family
theorem, specialized to `GF(6561)`. The internal adversarial novelty review records what is and is
not defensible as new. An external specialist citation-chain review remains a submission preflight
gate, not a mathematics or formalization blocker.

## Headline

For a linear code and a coordinate, take the complete hypergraph of all dual-support repair sets
with at most three helpers. Its matching number `nu` measures disjoint availability and its
transversal number `tau` measures adversarial local-repair tolerance.

The characteristic-three point system consisting of the affine twisted cubic and its full axis
gives a `[2q+1,4,q-1]_q` code. Every cubic coordinate has the exact row
`((q-1)/2,q-2)`; the axis rows are exact in terms of the affine cap number. Every coordinate
satisfies `tau > nu` for `q >= 9`. At `q=9`, the three coordinate types have exact rows

```text
(nu,tau) = (4,7), (6,12), (7,13).
```

An exact concatenation theorem preserves the complete radius-three repair hypergraph blockwise.
Using a degree-four extension and Stichtenoth's self-dual outer codes gives an unbounded `GF(9)`
family with exact rate `2/19` and eventual relative distance greater than every fixed
`c < 39/190` (hence greater than `1/5`). Its disjoint exhaustive coordinate partition has exact
multiplicities `9N,9N,N`, exact localities three, two, two, the same three rows at every block,
and guaranteed helper-failure thresholds `6,11,12`. A generic Lean corollary also shows that the
radius-`r` transfer gates preserve every exact inner locality `s <= r`.
Two explicit nondegenerate `GF(3)` examples prove that the strict inner gate and the outer
distance-`r+2` gate cannot be weakened uniformly while retaining complete-hypergraph equality;
no necessity is claimed for a fixed concatenation.

Restoring the projective cubic point at infinity gives a second seed `[2q+2,4,q]_q`. Its full
inclusion-minimal inner repair port stabilizes at radius four, with uniform cubic row
`((q-1)/2,q-1)` and axis row `((5q-3)/6,2q-3)`. At q=9 this is `[20,4,9]_9`, with two equal
coordinate classes and rows `(4,8)` and `(7,15)`. Its degree-four lift has
`[20N,4K,>=9D]_9`; the resulting unbounded family has exact rate `1/10` and every eventual
relative-distance bound `c<351/1600`. Only the bounded radius-four port transfers to the lift.

## Files

- `complete_repair_hypergraphs.tex` / `.pdf` — manuscript and built artifact.
- `refs.bib` — bibliography.
- `proof_ledger.md` — claim-by-claim paper/Lean/import ledger.
- `adversarial_novelty_review.md` — collision search and final novelty posture.
- `../../lean/RepairCodes/` — formal theorem chain.
- `../../lean/RepairCodes/OperationalCoefficients.lean` — coefficient-labelled scalar recovery
  equations and the monomial gauge boundary.
- `../../notes/2026-07-15-c203-q9-coefficient-verifier.py` / `.json` — independent q9 coefficient
  replay and certificate.
- `../../notes/2026-07-15-c203-operational-coefficient-adversarial-review.md` — adversarial audit
  of coefficient gauge, verifier independence, and operational wording.
- `../../lean/RepairCodes/TRUST.md` — stable trust boundary.
- `../../notes/2026-07-13-repaircodes-asymptotic-adversarial-review.md` — strict formalization
  review.

## Trust boundary

- No `sorry`, `admit`, `native_decide`, `unsafe`, or code-generation trust occurs in the
  `RepairCodes` theorem chain.
- All finite geometry, repair, concatenation, trace-duality, finite-field, and analytic-reduction
  steps depend only on Lean's standard logical axioms.
- `RepairCodes.Imported.stichtenoth_selfDual_TVZ_6561` is the sole project axiom consumed by the
  asymptotic headline. It states the exact specialization of Stichtenoth, Theorem 1.6(ii), used by
  the paper.

## Build

From this directory:

```sh
nix shell nixpkgs#tectonic -c tectonic complete_repair_hypergraphs.tex
```

From `lean/`:

```sh
choom -n 1000 -- nix develop --command lake build RepairCodes
```
