# C621 — self-associated and arithmetically Gorenstein quotient points

**Lane:** `clebsch`

**Date:** 2026-07-25

**Status:** `POSITIVE; PAPER II THEOREM ADOPTED`

## Result

For \(T=B_3,H_3\), let
\[
\widehat X_T=\{[1:x_M]:M\in\Omega_T\}\subseteq\mathbb P^{q-1}.
\]
Both frozen configurations are reduced self-associated arithmetically
Gorenstein sets of \(2q\) points.  Their dualizing residue vector is the
sheet sign \(\epsilon\).  Reduction by the homogenizing coordinate gives
an Artinian Gorenstein algebra with Hilbert function
\[
(1,q-1,q-1,1),
\]
and its Macaulay inverse system is the signed cubic line
\(\mathbb F_q\mu_3\).

Every one-point deletion imposes independent conditions on quadrics.
Thus the configurations have the Cayley--Bacharach property in degree
two.  The positive conclusion is not inferred from symmetry of the
\(h\)-vector alone.

## Conceptual proof

Let \(A\) be the \(q\)-by-\(2q\) matrix with columns
\(\widehat x_M=(1,x_M)\), and put
\(D=\operatorname{diag}(\epsilon(M))\).  The equal sheet sizes and
vanishing signed moments through degree two give
\[
A D A^{\mathsf T}=0.
\]
Since the affine points span their \((q-1)\)-space,
\(\operatorname{rank}A=q\).  The rows of \(AD\) therefore form
\(\ker A\), so \(AD\) is a Gale matrix.  Its columns differ from the
columns of \(A\) only by nonzero scalars.  This proves labeled
self-association over the base field without choosing square roots of
the sheet signs.

C620 gives \(\dim L^{\circ2}=2q-1\), so the \(2q\) points fail by exactly
one to impose independent conditions on quadrics.  The unique dependence
is \(\epsilon\) and has full support.  Deleting any point removes it and
leaves quadratic evaluation rank \(2q-1\).  After base change, the
Eisenbud--Popescu criterion applies: self-association plus this exact
quadratic defect is equivalent to arithmetic Gorensteinness.  The
property descends to \(\mathbb F_q\).

Let \(z\) denote the homogenizing coordinate.  It is regular because
\(z=1\) at every point, and the degree-\(d\) part after reduction is
\[
L^{\circ d}/L^{\circ(d-1)}.
\]
The sheet-sign functional annihilates degrees at most two and is nonzero
in degree three.  It is the socle functional.  Since \(3!\) is invertible
in both fields, polarization identifies its inverse-system generator
with
\[
\sum_M\epsilon(M)x_M^{\odot3}=\mu_3.
\]

This projective duality is compatible with C417's negative affine-origin
result.  Translating every \(x_M\) acts projectively on \(A\) and preserves
the signed Gale identity; it does not split the nontrivial base-choice
cocycle or produce a canonical equivariant centering.

## Exact falsifier suite

The primary checker reconstructs the quotient points from the frozen C406
matching data.  It computes all evaluation ranks and deletion ranks,
constructs the signed Gale matrix, checks all four catalecticant and
Artinian pairing ranks, and records the explicit inverse-system cubics.

Singular 4.4.1 verifies that the quadratic ideals equal the intersections
of the homogeneous point ideals, are saturated, and have Artinian lengths
\(14,22\) with socle dimension one.  Macaulay2 1.26.05 computes the first
half of the linear strand; Gorenstein self-duality completes the minimal
resolutions.  The independent replay reconstructs the points through the
separate C406 implementation and checks the Hilbert functions,
Cayley--Bacharach deletions, signed Gale identity, perfect Frobenius
pairings, inverse cubics, Hilbert numerators, and Betti symmetry.

| type | ambient space | Hilbert function through degree four | Artinian/catalecticant ranks | type |
|---|---:|---:|---:|---:|
| \(B_3/\mathbb F_7\) | \(\mathbb P^6\), 14 points | \(1,7,13,14,14\) | \(1,6,6,1\) | 1 |
| \(H_3/\mathbb F_{11}\) | \(\mathbb P^{10}\), 22 points | \(1,11,21,22,22\) | \(1,10,10,1\) | 1 |

The nonzero graded Betti numbers \(\beta_{i,j}\) are:

- \(B_3\):
  \[
  \beta_{0,0}=1,\quad
  \beta_{1,2}=15,\quad
  \beta_{2,3}=35,\quad
  \beta_{3,4}=\beta_{3,5}=21,
  \]
  \[
  \beta_{4,6}=35,\quad
  \beta_{5,7}=15,\quad
  \beta_{6,9}=1.
  \]
- \(H_3\):
  \[
  \begin{aligned}
  &\beta_{0,0}=1,\quad \beta_{1,2}=45,\quad
  \beta_{2,3}=231,\quad \beta_{3,4}=550,\quad
  \beta_{4,5}=693,\\
  &\beta_{5,6}=\beta_{5,7}=330,\quad
  \beta_{6,8}=693,\quad \beta_{7,9}=550,\quad
  \beta_{8,10}=231,\quad \beta_{9,11}=45,\quad
  \beta_{10,13}=1.
  \end{aligned}
  \]

From `/home/tavis/src/othello`, the replay commands are

```bash
python3 notes/2026-07-25-c621-gorenstein-gate.py --check
python3 notes/2026-07-25-c621-gorenstein-gate-replay.py
sha256sum -c notes/2026-07-25-c621-gorenstein-gate.sha256
```

The machine-readable certificate is
`notes/2026-07-25-c621-gorenstein-gate.json`.  It contains the exact
coordinates, signs, deletion ranks, cubic coefficients, Singular results,
and Betti tables.  No floating-point arithmetic is used.  Singular and
Macaulay2 remain trusted computer-algebra executions for their respective
ideal and resolution calculations; the Gorenstein and self-association
conclusions also have the independent symbolic proof above.

## Focused literature audit

This audit read one source at full text and two at partial depth.  It makes
no novelty or priority claim for the general self-association,
Gorenstein, Schur-square, or inverse-system criteria.

- **G. Rodríguez-Pajares, D. Ruano, and F. Salizzoni,
  _A combinatorial description of when a self-associated set of points
  fails to be arithmetically Gorenstein_, arXiv:2512.16766v1.**
  Read depth: `full text`, all eleven pages, from the cached arXiv PDF.
  Cache key `arXiv:2512.16766`, SHA-256
  `9dc89d58c45537bdd3d7844903da5de7d4d55aef9550dd6ddba36064c03882ca`.
  The paper proves that a self-dual code's point set is arithmetically
  Gorenstein exactly when the code is indecomposable, and expresses the
  Gorenstein defect through the Schur-square dimension.  Its warning is
  load-bearing here: self-association alone is insufficient.  Our exact
  value \(\dim L^{\circ2}=2q-1\) puts both configurations in its
  zero-defect case.
- **D. Eisenbud and S. Popescu, _The Projective Geometry of the Gale
  Transform_, arXiv:math/9807127.**  Read depth: `partial`, Introduction,
  all of Section 7, and the opening linear-algebra criterion in Section 8,
  from the cached arXiv PDF.  Cache key `arXiv:math/9807127`, SHA-256
  `136727dd6bf2cc4d2d08042a994b9f0a4c87c095297b205a0c5ccb473c7e6934`.
  Theorem 7.3 is the classical load-bearing criterion after scalar
  extension: \(2r+2\) nondegenerate points are arithmetically Gorenstein
  exactly when they are self-associated and fail by one on quadrics.
- **J. Elias and M. E. Rossi, _Inverse system of Gorenstein points in
  projective space_, arXiv:2301.07056v2.**  Read depth: `partial`,
  Introduction and Section 3 from Proposition 3.12 through Remark 3.15,
  from the cached arXiv PDF.  Cache key `arXiv:2301.07056`, SHA-256
  `552e849bd8e079782bcb11217559d16a14df33f57bfb875409536d51c4b2a9c4`.
  Theorem 3.14 describes the inverse system as a weighted sum of powers
  of the point linear forms.  Its paper assumes characteristic zero, so
  it is contextual rather than load-bearing for the finite-field claim;
  C621 instead uses the direct degree-three polarization argument, valid
  because the characteristics are \(7\) and \(11\).

The following four searches were screened over returned titles, abstracts,
and snippets:

```text
"B3" "H3" self-associated points Gorenstein finite field
"matching quotient" self-associated Gorenstein conic
"factorization sheets" Gorenstein points Gale transform
"Schur square" Clebsch H3 matching configuration
```

They located general Gale, Gorenstein, code, and Schur-square work but no
source was used to support an absence claim about these two configurations.
MathSciNet, zbMATH Open, and Google Scholar were not covered.  The shared
cache verification checked 269 entries with zero hash problem.

## Paper disposition

The result belongs in Paper II, immediately after the graded-evaluation
corollary.  It identifies the projective structure jointly encoded by the
quadratic dependence and cubic orientation and therefore sharpens the
paper's central mechanism rather than opening a separate branch.

The abstract and headline theorem now state the self-associated
arithmetically Gorenstein conclusion.  The Paper II trust surface grows to
eighteen theorem-like statements and seven evidence bundles.  The C621
bundle is supplementary exact evidence for a theorem whose main implication
is conceptual and classical.

The aggregate command

```bash
python3 papers/clebsch-factorization/verification/verify_release.py
```

passed on 2026-07-25 with all seven evidence bundles, including both C621
routes, and rebuilt the warning-free twenty-one-page manuscript.

## `ej` + `tt` closeout and mystery ledger

The `ej` pass exposed the origin-free meaning of the result.  C417 proves
that the affine quotient torsor has no equivariant origin, while C621 proves
that its homogenization is self-associated.  These statements reinforce
one another: translation changes the affine chart but preserves the
projective Gale identity and graded algebra.  Paper II now states this
boundary explicitly.

The `tt` pass tested the tempting but false shortcut “symmetric
\(h\)-vector plus self-association implies Gorenstein.”  The 2025
Rodríguez-Pajares--Ruano--Salizzoni paper gives counterexamples and
identifies the missing invariant.  Here the unique full-support quadratic
dependence, equivalently \(\dim L^{\circ2}=2q-1\), supplies exactly that
zero-defect condition.  The proof and report now make it load-bearing.

| mystery | status | exact remaining gap or owner |
|---|---|---|
| Does self-association alone force arithmetic Gorensteinness? | settled negatively in general | The 2025 criterion identifies decomposability/Schur-square defect as the obstruction; C620's codimension-one square proves zero defect here. |
| Is the sheet sign merely a quadratic relation? | settled | It is simultaneously the full-support Gale scaling, Cayley--Bacharach dependence, dualizing residue vector, and socle functional. |
| Is \(\mu_3\) only an orientation tensor? | settled | It is also the Macaulay inverse-system generator of the Artinian reduction; the perfect pairing and catalecticant ranks agree. |
| Does the result contradict the absence of an equivariant affine origin? | settled | No. Self-association is projective and survives every common translation; C417's affine cocycle remains nonsplit. |
| Why do both resolutions have only the two dual linear strands and terminal socle? | open, nonblocking | Macaulay2 computes the half-strands and Gorenstein duality completes them. A representation-theoretic explanation of the absence of ghost terms is not needed for Paper II and has no allocated owner. |

No incidental observation outside the task-owned Gorenstein, Gale, inverse
system, and resolution conclusions was found for the discovery track.
