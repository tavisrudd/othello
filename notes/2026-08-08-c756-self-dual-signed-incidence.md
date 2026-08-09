# C756 self-dual signed incidence and Smith audit

## Verdict

The signed passant square root has a second exact structure in every
certified prime field.  After switching rows, it becomes a symmetric or
skew-symmetric integral matrix \(W\), with observed sign
\[
 \vartheta=-\chi_q(-2),
\]
and
\[
 W^{\mathsf T}=\vartheta W,\qquad
 W^2=\vartheta(mI-\epsilon K). \tag{1}
\]
This is verified for \(q=5,7,11,13,17,19,23\).  No uniform claim is made
yet; the natural proof target is a polarity-equivariant signing or the
Frobenius--Schur indicator of the signed internal-point module.

The exact Smith audit changes the arithmetic prognosis.  In all seven
fields, every nonzero Smith invariant of \(W\) is \(1\).  Thus its integral
image is saturated and its cokernel has no torsion on the nonzero image.
The hoped-for raw \(p\)-adic obstruction is absent in this range.  Any
arithmetic finisher must use the sparse \(\{\pm1\}\)-kernel vector itself,
not torsion of the signed incidence operator.

## 1. Bounded self-duality theorem

Let \(Z\) be the signed passant/internal incidence matrix of Proposition
18.1, so
\[
 Z^{\mathsf T}Z=mI-\epsilon K. \tag{2}
\]

> **Proposition 23 (certified self-duality).**  For each
> \(q\in\{5,7,11,13,17,19,23\}\), there is a diagonal sign matrix \(D_q\)
> such that \(W_q=D_qZ_q\) satisfies (1), with
> \(\vartheta=-\chi_q(-2)\).  Its rank is
> \((q^2-1)/4\).

The checker constructs \(D_q\) by propagating the edge condition
\[
 (D_qZ_q)_{PQ}=\vartheta(D_qZ_q)_{QP}
\]
through the connected support graph and verifies consistency on every edge.
Once \(W^{\mathsf T}=\vartheta W\) is known, the square identity is not an
independent numerical coincidence:
\[
 W^2=\vartheta W^{\mathsf T}W
 =\vartheta Z^{\mathsf T}Z
 =\vartheta(mI-\epsilon K).
\]
Consequently the nonzero spectrum lies over
\(\mathbb Q(\sqrt{\vartheta q})\): in the symmetric cases it is
\(\{\pm\sqrt q\}\), and in the skew cases it is
\(\{\pm i\sqrt q\}\), with the remaining space equal to the relevant
\(K\)-eigenspace kernel.

The observed types are:

| \(q\) | \(5\) | \(7\) | \(11\) | \(13\) | \(17\) | \(19\) | \(23\) |
|---|---:|---:|---:|---:|---:|---:|---:|
| \(-\chi_q(-2)\) | \(+1\) | \(+1\) | \(-1\) | \(+1\) | \(-1\) | \(-1\) | \(+1\) |
| type | symmetric | symmetric | skew | symmetric | skew | skew | symmetric |

## 2. Smith-form result

> **Proposition 24 (certified saturated image).**  In the same seven
> fields, the Smith normal form of \(W_q\) has
> \((q^2-1)/4\) nonzero diagonal entries, all equal to \(1\), and all
> remaining entries zero.

Thus
\[
 \operatorname{im}_{\mathbb Z}W_q
 =(\operatorname{im}_{\mathbb Q}W_q)\cap\mathbb Z^{\mathcal I}
\]
throughout the certified range.  In particular no prime, including the
characteristic prime, appears as torsion in the cokernel on the image.

This does not classify sparse integral kernel vectors.  It closes only the
coarse route in which divisibility or a nontrivial Smith factor was supposed
to obstruct \(Wy=0\).  The coherent equality problem remains the
classification of a \(\{0,\pm1\}\)-valued kernel vector of support
\((q+3)/2\).

## 3. Reproducibility

The checker imports the committed signed-fusion constructor, propagates the
self-dual switching exactly, verifies every entry of (1), and computes Smith
normal form over \(\mathbb Z\) using SageMath 10.7.

Replay from the repository root:

    nix-shell -p sage --run 'sage -python notes/2026-08-08-c756-self-dual-signed-incidence.py --check'

| artifact | bytes | SHA-256 |
|---|---:|---|
| 2026-08-08-c756-self-dual-signed-incidence.py | 4,126 | 59f3f376ce9547d7d621bde0a83caf3cf364648ebe102499d4c358ca94664ffc |
| 2026-08-08-c756-self-dual-signed-incidence.json | 2,631 | b1edc7bdccb2c1611d74cdae0d8ea8be5dc320b812ab01764e93649321d50342 |
| input 2026-08-08-c756-signed-elliptic-fusion.py | 12,019 | e797763d12f5e82259af454c3dafe466192f7d4d33211d65a72c7fe70f3d6f87 |

Trusted boundary: matrix construction and switching use the earlier
self-contained prime-field implementation; Smith form relies on Sage's
exact integer algorithm.  The identity \(W^2=\vartheta(mI-\epsilon K)\)
has the independent deduction from (2) above.  No independent Smith
implementation was run.

## EJ + TT closeout

**EJ.**  The real frame now has a Dirac-type integral square root.  Depending
on the Frobenius--Schur sign, it is a symmetric involutory or skew-complex
structure after scaling by \(\sqrt q\) on the complementary module.  This is
a cleaner representation-theoretic spinoff than the earlier modular-rank
pattern.

**TT.**  Self-duality is aesthetically strong but does not strengthen the
kernel equation: \(Wy=0\) is exactly \(Zy=0\).  Worse for the arithmetic
route, the observed Smith form is maximally primitive.  Do not infer a
\(p\)-adic obstruction from the square identity alone.  The only live payoff
from this pass is either a uniform polarity/Frobenius--Schur theorem as a
publishable structural result or an obstruction that uses the actual sparse
sign pattern of \(y\).

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Can signed passant incidence be made self-dual? | settled for seven primes | prove uniformly over odd prime powers |
| What determines symmetric versus skew? | exact finite pattern | prove \(\vartheta=-\chi_q(-2)\), likely by polarity or Frobenius--Schur indicator |
| Does self-duality create a new equality bound? | settled negative at the operator level | it has the same kernel as \(Z\) |
| Does the signed incidence cokernel carry characteristic torsion? | settled negative in seven primes | every nonzero Smith invariant is \(1\); no uniform theorem yet |
| Can raw Smith or \(p\)-adic divisibility finish all-\(k\)? | strongly downgraded | only a sparse-sign-sensitive lift remains credible |
| Is the self-dual square root independently publishable? | open novelty gate | audit signed incidence intertwiners for the elliptic scheme |

## Next action

Seek a uniform coordinate or representation-theoretic proof of
\(W^{\mathsf T}=-\chi_q(-2)W\).  Stop after one bounded pass if the required
edge cocycle merely restates the row-sign construction.  Whether proved or
not, do not promote Smith torsion as an all-\(k\) route; return to the
branch-specific signed tangent/polarity classification.
