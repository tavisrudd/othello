# C161 — priority boundary for the rigidity TFAE

**Date**: 2026-07-15
**Lane**: `clebsch` — see `AGENTS.md` § Lane routing.
**Status**: **REPORTED**.

## Verdict

For clauses `(iv)` and `(v)` of the Clebsch rigidity theorem:

- Dye, Theorem 1(ii), proves that all Clebsch hexagons over the field form one projective orbit.
- Dye, Theorem 3, computes the projective stabilizer of a Clebsch hexagon as `A5` outside
  characteristic five, hence in characteristic eleven. This is `(iv) => (v)`.
- Storme--Van Maldeghem, Proposition 12, proves projective uniqueness of the six-point orbit fixed
  by `A5` for `q = +/-1 (mod 10)`. At `q=11` this is `(v) => (iv)`.

Thus the equivalence is a classical import, split precisely between Dye 1991 and
Storme--Van Maldeghem 1995. Sadeh's six-arc census is not the source needed for this implication,
and no unresolved earliest-source claim remains in the manuscript.

## Manuscript disposition

The proof of the rigidity theorem names Dye for the equality classification and forward
stabilizer implication, and Storme--Van Maldeghem for the converse. The novelty remark now repeats
that split rather than attributing the whole equivalence to Storme--Van Maldeghem or saying that it
rests on Sadeh's census.

The source/page ledger and the separate BSW covering boundary are recorded in
`notes/2026-07-15-dye-bsw-primary-source-audit.md`.
