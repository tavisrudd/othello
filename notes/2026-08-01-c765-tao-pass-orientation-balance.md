# C765 Tao pass — determinant uniqueness and universal balance

**Lane:** `golden`

## Verdict

The first C765 scaffold had the correct distinction but left two natural
questions implicit: why the determinant is forced among orientation-covariant
polynomials, and whether the (20+44) boundary is genuinely Golden. Both have
short general answers and are now in the manuscript.

## Minimal orientation carrier

For (K:V\to W) between (n)-dimensional Euclidean spaces, a degree-
(n) polynomial satisfying

\[
 F(R_-^{\mathsf T}KR_+)
 =\det(R_-)\det(R_+)F(K)
\]

for all orthogonal frame changes is a scalar multiple of (det K). Diagonal
sign changes force each degree-(n) monomial to use every row and column once;
two-plane rotations force the alternating signs. Thus the top exterior
amplitude is the unique lowest-degree carrier of the port-orientation
character. This is classical invariant reasoning, and the paper makes no
novelty claim for it.

## Universal balance obstruction

For any orthogonal (d+d) splitting of (2d) paths and any Boolean negative
support (S),

\[
 \operatorname{rank}K_S\leq\min(|S|,2d-|S|).
\]

Hence a filled (d)-fermion determinant can be nonzero only at a balanced
control. The Golden content is stronger: every balanced control is invertible
and all have the same squared singular spectrum. In dimension three, the
universal obstruction accounts for the 44 unbalanced zeros, while Golden
equispectrality supplies the twenty nonzero cases.

## What Tao would still press

1. **Humanize the common spectrum.** The paper currently imports the exact
   Golden spectrum from the frozen source and verifies it locally. A short
   conceptual derivation from the conference identity would improve the proof
   hierarchy if it stays shorter than the current certificate boundary.
2. **Separate mathematical and physical novelty.** The orbit and invariant
   facts are classical. The contribution is their exact synchronization with
   the Golden transfer, calibrated bosonic data, and resource audit.
3. **Do not oversell the bosonic aggregate.** (h_3) is a canonical
   Hilbert--Schmidt aggregate, not the unique invariant scalar.
4. **Keep the anomaly vector subordinate.** It demonstrates use of the
   oriented coordinate but should move to an appendix before it competes with
   the exchange-statistics narrative.
5. **Ask what a many-particle experiment adds beyond tomography.** One-particle
   coherent tomography certifies the carrier and infers its determinant.
   Direct exchange-sector physics begins only with bosonic controls and,
   eventually, the antisymmetric three-qutrit resource.

Items 2--5 are already routed to C768--C770. Item 1 is a cheap opportunity
only if the conference-identity proof is genuinely explanatory; otherwise the
current exact replay is the more honest boundary.

## Mystery ledger

| feature | state | owner |
|---|---|---|
| why only balanced Boolean controls can be invertible | settled universally | C765 Tao pass |
| why the determinant, rather than another cubic, carries orientation | settled at minimal polynomial degree | C765 Tao pass |
| why every Golden balanced block has spectrum `(1/5,4/5,4/5)` | exact and replayed, but the shortest conceptual proof remains to be selected | C767 source / possible C770 exposition |
| what direct many-particle data adds beyond coherent tomography | mathematically separated, experimentally to be sharpened | C769 |
