# C665 uniform C1: contraction correction and reopened \(q=121\) gate

**Lane**: `clebsch`

**Date**: 2026-07-29

## Corrected verdict

The \(q=121\) affine-socle calculation remains valid:
\[
\dim\operatorname{Hom}_H(L(6),F)
=\dim\operatorname{Hom}_H(F,L(6))=1,
\qquad \pi i=0.
\]
Thus \(L(6)\) is still the first certified embedded nonretract in
\(F=\operatorname{Sym}^{59}L(2)\).

The subsequent quadratic-pullback certificate is invalid.  Its order-59
``divided contraction'' is a Hasse pairing on ordinary symmetric powers,
not an \(H\)-equivariant map.  Consequently its inconsistent coboundary
system cannot certify the image of the pullback extension class.  C1 at
\(q=121\) is reopened, and no extension-field-wide C1 theorem is currently
proved.

## Exact defect

The retired detector uses
\[
B(X^iY^jZ^k,X^kY^jZ^i)=(-1/2)^j.
\]
In characteristic eleven and degree \(59\), take
\[
a=X^2Z^{57},\qquad b=X^{57}YZ
\]
and the determinant-one translation
\[
X\mapsto X-2Y+Z,\qquad Y\mapsto Y-Z,\qquad Z\mapsto Z.
\]
Direct expansion gives
\[
B(a,b)=0,\qquad B(ua,ub)=1.
\]
Hence \(B\) is not translation-invariant.  The same failure follows
infinitesimally: for
\[
a=X^iY^jZ^k,\qquad
b=X^kY^{j+1}Z^{i-1},
\]
the coefficient of the translation parameter in
\(B(ua,ub)-B(a,b)\) is
\[
(i-j-1)(-1/2)^j.
\]
The displayed witness has \(i=2,j=0\).

The genuine order-\(r\) contraction is the \(r\)-th power of the invariant
ordinary differential operator.  Relative to the Hasse formula, its
coefficient for pairing multiplicities \((a,b,c)\), \(a+b+c=r\), contains
the essential factor
\[
r!\,a!\,b!\,c!.
\]
At \(r=59\) this operator is zero in characteristic eleven.  Omitting those
factorials produced the non-equivariant map used by the retired detector.

## Reproducibility

Primary checker and canonical certificate:

```text
cd rust
python3 ../notes/2026-07-29-c665-q121-contraction-audit.py --check
```

The checker independently reimplements the monomial translation and the
stated pairing; it does not import Sage or the retired detector.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-29-c665-q121-contraction-audit.py` | 3602 | `83d2c2aab4ab0a356f4e691ae3418b8747def681bc81be38d3fa3de07861754e` |
| `notes/2026-07-29-c665-q121-contraction-audit.json` | 452 | `c57e9a13b6dd843e39fac54aec80c57f33ff7a484d78ebbbf5c988766dfe016e` |

The prose infinitesimal calculation is the independent replay.  The
certificate proves only the non-equivariance of the retired scalar channel
and the vanishing of the genuine order-59 ordinary contraction.  It does
not decide whether the \(q=121\) pullback splits.

## Replacement attacks

The proof search now has four genuinely different routes.

1. Test the ten nonzero ordinary contraction channels
   \(1\le r<11\).  Any inconsistent image cocycle is a valid certificate.
2. Restrict to the Borel.  Since \([H:B]=q+1\) is invertible in
   characteristic \(p\), restriction on first cohomology is injective.  A
   torus-weighted unipotent left-kernel certificate therefore decides the
   pullback without constructing the full symmetric square.
3. Use modular Hermite reciprocity
   \[
   \operatorname{Sym}_{d}(\operatorname{Sym}^{2}V)
   \simeq
   \operatorname{Sym}_{2}(\operatorname{Sym}^{d}V)
   \]
   to replace ternary plethysm by a symmetric square of a binary
   Weyl/dual-Weyl module, then compute embedding, retraction, and extension
   scalars recursively in Frobenius digits.
4. Search for an explicit \(q=121\) splitting.  A positive result would
   falsify C1 rather than merely another proposed detector.

The current highest-EV order is (1), then (2).  Route (3) is the preferred
uniform theorem architecture once the first positive or negative
\(q=121\) model is sound.

The exact source for route (3) is McDowell--Wildon, *Modular plethystic
isomorphisms for two-dimensional linear groups*, J. Algebra 602 (2022),
441--483, Corollary 1.5, DOI
`10.1016/j.jalgebra.2022.02.025`.  The present pass read the statement and
the symmetric-invariant/coinvariant conventions on pp. 1--4 of
arXiv:2105.00538v3.  It is used only as a proof architecture here, not as
evidence that the C1 pullback is nonsplit.

## Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| \(L(6)\) embeds and co-occurs in the head, but \(\pi i=0\) | settled exact occurrence; structural cause open | identify its Frobenius-digit Weyl/dual-Weyl layer under modular Hermite reciprocity |
| retired top Hasse channel gives a \(1\to2\) rank jump | settled as an artifact of a non-equivariant operator | none; do not reuse the rank jump |
| actual \(q=121\) quadratic pullback | open | valid ordinary-contraction obstruction, Borel certificate, or explicit splitting |
| uniform extension-field C1 | open | occurrence-level recursive theorem covering every exceptional candidate family |

Vibe check: the prior positive model failed at a load-bearing seam, but the
failure is sharp and cheap to certify; the task is healthier with the false
shortcut removed, and the Borel/Hermite routes are structurally better than
another field-sized symmetric-square calculation.
