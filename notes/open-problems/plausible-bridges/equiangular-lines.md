# Maximum equiangular lines versus the Golden ETF

**External ID:** `BIG-414`
**Verdict:** a classical solved extremizer with a new internal explanation,
not progress on the open maximum problem.

## Exact comparison

The Golden sign factor produces ten equiangular lines in `R^5` with common
absolute inner product `1/3`.  They form an `ETF(5,10)` and meet the relative
bound with equality.

But `M(5)=10` has been known since van Lint--Seidel.  At angle `1/3`, the wider
fixed-angle problem is also well understood: the relative bound gives ten in
dimension five, and the large-dimensional behavior belongs to the classical
Lemmens--Seidel theory.  The repository's novelty is the reverse Golden
sign-factorization and its semantic origin, not a larger line system or a new
upper bound.

## Live exact targets

The first unresolved low-dimensional maxima are currently:

| Dimension | Current recorded range | Main obstruction language |
|---|---:|---|
| 18 | `57 <= M(18) <= 59` | Seidel spectrum, complementary subgraphs, lattices |
| 19 | `72 <= M(19) <= 74` | Seidel spectra and strongly regular graphs |
| 20 | `90 <= M(20) <= 94` | Seidel spectra and strongly regular graphs |

These bounds are a 2026 snapshot and must be refreshed before publication.
Dimension 18 is the smallest and narrowest exact target.

There is also a distinct fixed-angle frontier.  Balla's proposed general bound
has been proved for several special angles but was shown in June 2026 to fail
for infinitely many other angles.  Any project there must state the surviving
angle class rather than citing “Balla's conjecture” unqualified.

## Independent attack routes

1. **Exact `M(18)` certification.**  Enumerate feasible Seidel characteristic
   polynomials, apply interlacing/Jacobi identities to complementary principal
   subgraphs, and use graph isomorphism plus exact SDP or integer certificates
   to eliminate sizes 58 and 59 (or construct one).  This is the strongest
   bounded target.
2. **`M(19)` and `M(20)` spectral reduction.**  Translate candidate Gram
   matrices into Seidel matrices/strongly regular graph extensions and certify
   nonexistence one spectrum at a time.  Larger search, still sharply posed.
3. **Repair the fixed-angle conjectural picture.**  Determine structural
   hypotheses on the spectral-radius order under which Balla's bound survives.
   This is more conceptual and independent of the Golden configuration.

The local projection and conference identities may supply useful exact-linear-
algebra code, but no current identity transfers from dimension five to these
open cases.

## Promotion gate

Require a new construction, a strict upper-bound improvement, or a complete
classification in an open dimension/angle.  Reclassifying `ETF(5,10)` by a new
origin theorem remains valuable, but should be sold as rigidity and synthesis.

## Sources

- Igor Balla, *Equiangular lines via matrix projection*, arXiv `2110.15842`;
  `partial`, cached SHA-256
  `04bc2cda09ed2e86128a1884006f83caedc7c91af8d15c7dbbd102fca8267389`.
- Gary Greaves, Jeven Syatriadi and Pavlo Yatsyna, *Equiangular lines in low
  dimensional Euclidean spaces*, arXiv `2002.08085`; `abstract/metadata only`:
  https://arxiv.org/abs/2002.08085.
- Gary Greaves, *Real equiangular lines in dimension 18 and the Jacobi identity
  for complementary subgraphs*, DOI `10.1016/j.jcta.2023.105812`;
  `abstract/metadata only`.
- Chuanyuan Ge and Shiping Liu, *New bounds for equiangular lines and Balla's
  conjecture*, arXiv `2606.29392`; `abstract/metadata only`:
  https://arxiv.org/abs/2606.29392.
- Current numerical ranges cross-checked against OEIS A002853 on 2026-07-31;
  secondary status source, not a novelty source.
