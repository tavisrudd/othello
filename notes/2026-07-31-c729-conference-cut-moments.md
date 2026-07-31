# C729 — conference-cut moments and weighted-operator audit

**Date:** 2026-07-31

**Lane:** `golden`

**Status:** higher-order moment, next-order census, stability, and focused
literature gates passed

## Result

The conference lift does continue, but not as a tower of ordinary conference
matrices.  Its invariant continuation is the constant-diagonal Naimark
reflection of an integral tight frame.  Two new facts make that statement
sharp.

First, every symmetric conference matrix of order (2m) satisfies universal
balanced-cut spectral moment identities.  If (B_I=S[I,I^c]), with (I)
uniform among the balanced cuts modulo complement, then

\[
 \operatorname{tr}(B_IB_I^{\mathsf T})=m^2
\]

for every cut, and

\[
 \boxed{\mathbb E_I\operatorname{tr}
   \bigl((B_IB_I^{\mathsf T})^2\bigr)
 =\frac{m^2(3m^2-6m+2)}{2m-3}.}
\]

Equivalently, if (lambda_1(I),\ldots,lambda_m(I)) are the squared singular
values of (B_I), then

\[
 \boxed{\mathbb E_I\sum_{a=1}^m(\lambda_a(I)-m)^2
 =\frac{m^2(m-1)(m-2)}{2m-3}.}
\]

The first two spectral moments are therefore universal; determinant moments
and the third spectral moment are not fixed by this argument and are retained
as arithmetic data.  This locates the right boundary for the theorem proved
here: orthogonality controls mean spectral spread, while Paley orbit data
records how that spread is distributed among cuts.

Second, the order-36 operator from the extremal order-ten cuts is not a roux
operator.  After the coherent base-cut orientation, if (A_i) is the distance-
(i) matrix of the Sylvester graph, then its Gram matrix and weighted operator
are exactly

\[
 X^{\mathsf T}X=2(5I-3A_1+A_2-A_3),
 \qquad
 K=-3A_1+A_2-A_3.
\]

Thus (K) is the integral coordinate form of the primitive idempotent
(40E_{-3}), already inside the Sylvester Bose--Mesner algebra.  Its quadratic
law

\[
 K^2=10K+75I,
 \qquad (K-5I)^2=100I,
\]

is standard primitive-idempotent/Naimark-reflection machinery.  What is special
to the Golden construction is the ({\pm1})-valued cut factor (X), its
extremal-determinant origin, and its full outer-action meaning—not the existence
of a quadratic polynomial for a spherical embedding by itself.

## Universal second-moment theorem

Let (S=S^{\mathsf T}) be a symmetric conference matrix of order (n=2m), so
(S^2=(2m-1)I).  For a balanced half (I), write

\[
 S=\begin{pmatrix}A&B\\B^{\mathsf T}&D\end{pmatrix}.
\]

The (I\times I) block of the conference identity gives

\[
 BB^{\mathsf T}=(2m-1)I-A^2.
\]

Since (A) is a zero-diagonal sign matrix,
(operatorname{tr}A^2=m(m-1)), and hence
(operatorname{tr}(BB^{\mathsf T})=m^2).

For the next moment, classify the closed four-walks contributing to
(operatorname{tr}A^4) by their vertex support.  Supports of size two and
three contribute respectively

\[
 m(m-1),\qquad 12\binom m3.
\]

For the full order-(2m) matrix, the total four-support contribution is

\[
 \operatorname{tr}S^4-2m(2m-1)-12\binom{2m}{3}
 =-2m(2m-1)(2m-2).
\]

A fixed four-set lies in a uniform balanced half with probability
(inom m4/inom{2m}4).  Therefore

\[
 \mathbb E_I\operatorname{tr}A^4
 =\frac{m(m-1)(3m^2-7m+3)}{2m-3}.
\]

Expanding
(operatorname{tr}(((2m-1)I-A^2)^2)) gives the boxed second-moment
formula.  Subtracting (m^3) gives the centered singular-value formula.

This proof also explains the stopping point.  At the next power, closed
six-walks split into five- and six-vertex holonomy terms that are not separated
by the conference identity alone.  The exact third moments in the certificate
are consequently recorded as Paley data, not promoted to a universal formula.

## Exact higher-order census

The deterministic census uses Paley symmetric conference matrices over the
prime fields of orders (5,13,17), together with the universal balanced-cut
Gram construction at order ten.  Cuts are counted modulo complement.  Every
Bareiss determinant is independently replayed by modular Gaussian elimination
at the primes (1000000007) and (1000000009).

| conference order | cuts | absolute cross-determinant distribution |
|---:|---:|---|
| 6 | 10 | (4^{(10)}) |
| 10 | 126 | (0^{(90)},48^{(36)}) |
| 14 | 1716 | (64^{(546)},192^{(624)},256^{(364)},576^{(182)}) |
| 18 | 24310 | (256^{(3672)},512^{(2448)},1024^{(5032)},2048^{(4896)},2304^{(612)},3328^{(1224)},4096^{(1224)},4608^{(2448)},4864^{(1224)},6656^{(816)},8192^{(714)}) |

At order fourteen, the five (operatorname{PGL}_2(13))-orbits have
((|\mathcal O|,|\det B|))

\[
 (546,64),\ (78,192),\ (546,192),\ (364,256),\ (182,576).
\]

Thus determinant value already coarsens the group orbit: the 624 cuts of value
192 split as (78+546).  At order eighteen there are sixteen
(operatorname{PGL}_2(17))-orbits but only eleven determinant values.  In
particular the maximum value (8192) splits into orbits of sizes (306) and
(408), and value (1024) splits into orbits of sizes (136,2448,2448).
The JSON certificate gives a canonical representative half for every orbit.

All determinants obey the elementary divisibility
(2^{m-1}\mid\det B) for odd-order sign matrices (B).  Order fourteen still
contains global (7\times7) D-optimal cuts (value (576)); order eighteen does
not reach the (9\times9) maximum-determinant value.  The all-cut phenomenon at
order six is therefore exceptional twice over: every cut is D-optimal there,
whereas order ten has only 36 D-optimal cuts and the Paley order-fourteen and
order-eighteen distributions have several arithmetic strata.

## Stability boundary

Put

\[
 \Delta(I)=\sum_a(\lambda_a(I)-m)^2,
 \qquad
 \overline\Delta=\frac{m^2(m-1)(m-2)}{2m-3}.
\]

The moment theorem is an exact stability budget.  Since the nonnegative
(lambda_a) sum to (m^2), one has
(0\leq\Delta(I)\leq m^3(m-1)).  Hence, for (0\leq\varepsilon<\overline\Delta),
the fraction (p_\varepsilon) of cuts satisfying
(Delta(I)\leq\varepsilon) obeys

\[
 p_\varepsilon
 \leq
 \frac{m^3(m-1)-\overline\Delta}
      {m^3(m-1)-\varepsilon}.
\]

Also (|\det B_I|^2\leq m^m) by AM--GM, with equality only when
(Delta(I)=0).  These are genuine signing-independent constraints, but they
do not form an inverse theorem: every symmetric conference switching class has
the same budget.  Proximity to a particular Paley or Golden signing must use
third/higher holonomy data or orbit incidence, not merely the first two spectral
moments or a raw count of nearly flat cuts.

## Weighted-operator audit

The exact audit reconstructs the 36 extremal order-ten cuts, orients them
relative to one base cut, and verifies

\[
 X^{\mathsf T}X=40E_{-3},\qquad
 XX^{\mathsf T}=40\left(I-\frac1{10}J\right).
\]

There are 90 unordered entries of magnitude (3) in (K) and 540 of
magnitude (1).  The large-angle graph has intersection triples

\[
 (0,0,5),\ (1,0,4),\ (1,2,2),\ (4,1,0),
\]

and spectrum (5^1,2^{16},(-1)^{10},(-3)^9).  The operator spectra are
(15^9,(-5)^{27}) for (K) and (10^9,(-10)^{27}) for (K-5I).  As an
additional arithmetic check,

\[
 (\operatorname{tr}K^r)_{r=1}^4
 =(0,2700,27000,472500).
\]

This catches the only plausible normalization ambiguity: confusing the
zero-diagonal integral operator (K) with the centered reflection (K-5I).

## Focused literature audit

This audit names five sources; **zero were read at full-text depth**.  The
read-depth markers below are unconditional.  It is a positioning audit, not an
exhaustive priority search, and it licenses no “first” or “to our knowledge”
claim.

- M. R. Alfuraidan and J. I. Hall, *Imprimitive distance-transitive graphs
  with primitive core of diameter at least 3*, DOI
  `10.1307/mmj/1242071683`.  **Read depth: partial**, published PDF, Section
  5.8.2.  Cache SHA-256
  `303e6f86d31e86a3f4a7c170e77141e1598c1819e3ac84f699d2e5783c450e90`.
  It supplies the 36 outer-involution model, commuting adjacency, intersection
  array, distance transitivity, and automorphism group; it does not discuss the
  extremal-cut factor or weighted Gram operator.
- J. I. Haas, J. Cahill, J. Tremain, and P. G. Casazza, *Constructions of
  biangular tight frames and their relationships with equiangular tight
  frames*, arXiv:1703.01786.  **Read depth: partial**, arXiv PDF, Sections 1--2.
  Cache SHA-256
  `fce8d21d26ca978237bcb111ec5296eb73dd7f07dc5bbbba761e6608b0fbaebf`.
  It supplies the BTF terminology and general ETF/BTF setting, not this
  36-line configuration.
- J. W. Iverson and D. G. Mixon, *Doubly transitive lines I: Higman pairs and
  roux*, arXiv:1806.09037.  **Read depth: partial**, arXiv PDF, Sections
  1.2--1.3 and the character-evaluation discussion in Section 2.  Cache
  SHA-256
  `a2b98c480fafc98617b5789eba3291ff427805e611bb5c1364eb14b7b029867a`.
  Roux character evaluations produce ETF signature matrices, hence an
  equiangular line system.  The two-magnitude Sylvester cut frame is therefore
  not a roux output in that sense.  Their discussion points instead to Higman's
  broader regular-weight framework.
- G. Greaves and S. Suda, *Symmetric and skew-symmetric
  ({0,\pm1})-matrices with large determinants*, arXiv:1601.02769,
  published as DOI `10.1002/jcd.21567`.  **Read depth: partial**, arXiv v3,
  Section 4, especially Theorems 4.3 and 4.5.  Cache SHA-256
  `40cde5eff1bbd514c2952cb6ab36ad130116f7432ce6fb250cadb9c1eec093cf`.
  It treats spectra of large *principal* submatrices of conference matrices,
  not balanced complementary cross blocks or their cut moments.
- R. P. Brent and J.-A. H. Osborn, *On minors of maximal determinant
  matrices*, arXiv:1208.3819.  **Read depth: partial**, arXiv PDF,
  Introduction and the scope statements for Sections 2--5.  Cache SHA-256
  `751057c5ff1399601482135568c471ee9c5bbd7f87c067363088d2505a3811a9`.
  Its computed minor spectra concern maximal-determinant and Hadamard matrices,
  without the complementary balanced-cut restriction used here.

Load-bearing web queries included `conference matrix maximal minors
determinants submatrices`, `biangular tight frames association scheme Gram
matrix two angles arxiv`, `roux lines equiangular tight frames signature matrix
Iverson Mixon arxiv`, and `D. G. Higman Weights and t-graphs PDF 1990`.
Higman's original 1990 paper was identified but not obtained; MathSciNet and
Google Scholar were not covered.  The audit therefore resolves terminology
and the nearest mathematical frameworks, but deliberately leaves priority
open.

## Reproducibility

The atomic evidence bundle is:

- `notes/2026-07-31-c729-conference-cut-moments.py` — exact generator and
  checker;
- `notes/2026-07-31-c729-conference-cut-moments.json` — canonical compact
  certificate;
- `notes/2026-07-31-c729-conference-cut-moments.sha256` — hashes and byte
  counts.

Replay from the repository root:

```sh
python3 notes/2026-07-31-c729-conference-cut-moments.py --check
```

The trusted boundary is Python integer arithmetic, canonical enumeration of
all balanced cuts modulo complement, and the stated Paley prime-field
construction.  Bareiss elimination and modular Gaussian elimination are
independent determinant paths.  The computation does not classify all
symmetric conference switching classes of orders fourteen or eighteen and
does not prove a general third-moment formula.

## `ej` + `tt` closeout and mystery ledger

- **Settled by `tt`:** the correct universal quantity is the averaged spectral
  spread, not a conjecturally universal determinant distribution.
- **Settled by `ej`:** the order-fourteen census reaches the (7\times7)
  maximum determinant but already splits one determinant stratum into two
  projective-linear orbits; determinant is not a complete orbit invariant.
- **Settled by `ej`:** the order-eighteen maximum stratum itself splits into
  two (operatorname{PGL}_2(17))-orbits.  Orbit incidence is the cheapest
  next discriminator beyond determinant moments.
- **Settled by `tt`:** (K=-3A_1+A_2-A_3) is a primitive-idempotent element of
  the Sylvester Bose--Mesner algebra.  The quadratic law is contextualized,
  while the integral cut realization remains the Golden-specific theorem.
- **Settled by `ej`:** roux is too narrow: its character evaluations are ETF
  signatures, whereas the 36 lines are biangular.  No roux-type tower should
  be claimed.
- **Open:** whether the third averaged spectral moment has a clean character-
  sum formula for every Paley order.  Evidence gap: the present proof isolates
  unsummed five- and six-vertex holonomies.  A successor must derive those
  sums before computing another order.
- **Open:** a true inverse/stability theorem from an arbitrary signing to a
  nearby conference switching class.  Gate: express the second-moment defect
  for a general Seidel matrix in terms of the conference residual
  (S^2-(n-1)I); the conference-only budget cannot distinguish switching
  classes.
- **Open:** Higman's original regular-weight paper was not accessible in this
  audit.  It may sharpen the terminology for the signed distance relations,
  but cannot turn a two-angle frame into a roux ETF.

The task has no remaining acceptance blocker.  The open items are sequel
directions, not gaps in the (6\to10\to36) reflection theorem.

## Post-closeout internal-minor refinement

`notes/2026-07-31-c729-cut-moments-reflection-audit.md` supplies a compatible
local Cauchy--Binet refinement.  For every balanced half \(A\), it expands the
cross-determinant square as an alternating sum of the squared internal minor
energies of \(S[A,A]\), then resolves their global sums by the overlap size of
the row and column index sets.  At order ten the 90 singular and 36 extremal
projective cuts lift to exactly two full internal-energy profiles.  Its
independent certificate also records the exact antipodal pair-moment
sequences: both Golden cut frames have spherical design strength exactly
three and fail the spherical fourth moment.  This strengthens the stopping
criterion without changing the completed-task boundary.
