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
More generally, every ordinary contraction of order \(r\ge p\) vanishes:
the commuting invariant differential operator satisfies the
characteristic-\(p\) freshman's-power identity, and every resulting
\(p\)-th ordinary partial derivative is zero.  Thus all of the retired
high-contraction orders \(54,\ldots,59\) are unavailable.  The complete
nonzero ordinary-contraction range is \(0\le r\le10\), with \(r=0\) the
already-blind multiplication channel.

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

## Valid ordinary contractions are blind

The complete nonzero ordinary-contraction range \(1\le r\le10\) has now
been tested exactly after restriction to the split Borel.  The affine
cocycle is first normalized to vanish on the split torus.  For each
\[
C_r:\operatorname{Sym}^2F\longrightarrow
\operatorname{Sym}^{118-2r}L(2),
\]
the checker solves the two translation coboundary equations inside the
torus-compatible Hom space.  Every system is consistent.  Their numbers of
variables are \(828-21r\), their coefficient ranks are \(825-21r\), and
the rank defect is exactly three in all ten orders.  Thus every valid
ordinary contraction is Borel-blind.

This is a bounded negative result about the ten invariant contraction
images.  It does not show that the original pullback class restricts to
zero on the Borel and does not decide C1.

The streaming checker uses exact arithmetic over
\(\mathbb F_{121}=\mathbb F_{11}[x]/(x^2+7x+2)\).  It performs sparse
elimination without materializing the former large matrices, then
back-substitutes a canonical coboundary and re-evaluates every original
equation.  The ten channels verify between \(60{,}450\) and \(78{,}886\)
equations each.  The compact certificate records the exact ranks, counts,
and SHA-256 hash of each canonical solution.

From the repository root, with SageMath 10.7, regenerate or check the
certificate by

```text
nix shell nixpkgs#sage -c sage -python \
  notes/2026-07-29-c665-q121-borel-stream-replay.py \
  --jobs 5 --check
sha256sum -c notes/2026-07-29-c665-q121-borel-stream.sha256
```

The evidence bundle is
`notes/2026-07-29-c665-q121-borel-stream.sage`,
`notes/2026-07-29-c665-q121-borel-stream-replay.py`,
`notes/2026-07-29-c665-q121-borel-stream.json`, and
`notes/2026-07-29-c665-q121-borel-stream.sha256`.
The exact solution-residual pass is the independent invariant check; no
second implementation of the large Borel systems is claimed.

## The affine class dies in the \(L(6)\) head

The next occurrence-level gate is also closed negatively.  Let
\(\pi:F\to L(6)\) generate the certified one-dimensional projection Hom
space.  Pushing the torus-normalized affine cocycle through \(\pi\) gives
nonzero vectors on all three standard generators, with support sizes
\(3,3,1\).  Nevertheless this projected cocycle is a coboundary: the
unique torus-fixed line in \(L(6)\) supplies correction scalar \(4\), and
all twenty-one generator-coordinate residuals vanish.

Thus the affine class does not survive in the \(L(6)\) head.  Equivalently,
\(\pi\) extends across \(E\), but its extension still kills the embedded
socle because \(\pi i=0\).  The primary head trace therefore cannot replace
the retracted-socle trace; any q=121 obstruction is secondary in the
radical filtration.

The two prime-field cohomology-weight probes do not provide a deeper
quotient: exact systems give
\[
\operatorname{Hom}_H(F,L(8))=
\operatorname{Hom}_H(F,L(8)^{(1)})=0.
\]
Together with the earlier embedding exclusions, neither digit placement of
\(L(8)\) occurs in the head or socle of \(F\).  This is an
occurrence-level statement, not an inference from the associated-graded
binary Weyl factors.

From the repository root, replay this gate with

```text
nix shell nixpkgs#sage -c sage -python \
  notes/2026-07-29-c665-q121-affine-head.sage --check
sha256sum -c notes/2026-07-29-c665-q121-affine-head.sha256
nix shell nixpkgs#sage -c sage -python \
  notes/2026-07-29-c665-q121-affine-head-probes.sage --check
sha256sum -c notes/2026-07-29-c665-q121-affine-head-probes.sha256
```

The exact script, canonical certificate, and load-bearing-input manifest
are `notes/2026-07-29-c665-q121-affine-head.sage`,
`notes/2026-07-29-c665-q121-affine-head.json`, and
`notes/2026-07-29-c665-q121-affine-head.sha256`, together with the
parallel `affine-head-probes` `.sage`, `.json`, and `.sha256` files.
Direct substitution of the scalar \(4\) in every generator coordinate and
the two zero-dimensional Hom kernels are the independent invariant checks.
These results do not decide the quadratic pullback.

## Modular-Hermite filtration locates the affine class

The occurrence-level architecture is now explicit.  In the point-vector
convention, put \(W=\nabla(59)=\operatorname{Sym}^{59}V\).  The standard
\(\mathrm{SL}_2\) dual-Weyl sequence at \(59=4+5\cdot11\) is
\[
0\to B_0:=L(4)\otimes L(5)^{(1)}
\to W\to A:=L(5)\otimes L(4)^{(1)}\to0.
\]
Modular Hermite reciprocity gives
\[
F=\operatorname{Sym}^{59}(L(2))
\simeq\operatorname{Sym}^2W.
\]
Since the characteristic is odd, \(F\) has the three-step filtration
\[
\operatorname{gr}F=
\operatorname{Sym}^2B_0\ \oplus\
(B_0\otimes A)\ \oplus\
\operatorname{Sym}^2A.
\]
All three graded pieces are semisimple: every digitwise tensor product
stays in the bottom alcove.

The split-Borel cohomology of every simple graded factor is now exact.
The fifteen top and fifteen bottom factors have zero \(H^1\).  Among the
twenty-five middle factors, exactly
\[
T_+=L(9)\otimes L(1)^{(1)},\qquad
T_-=L(1)\otimes L(9)^{(1)}
\]
have one-dimensional \(H^1\); the other twenty-three vanish.  Neither
\(T_+\) nor \(T_-\) has a torus-fixed vector.  No graded factor has a
Borel-fixed vector.

It follows from the two filtration long exact sequences that restriction
of the nonsplit affine class injects into
\[
H^1(B,T_+)\oplus H^1(B,T_-).
\]
The normalized nonsquare dilation acts by \(+1\) on \(H^1(B,T_+)\) and
by \(-1\) on \(H^1(B,T_-)\).  The affine extension and the
modular-Hermite filtration are PGL-equivariant, so its outer-invariant
class has zero \(T_-\)-component and a nonzero \(T_+\)-component.  The
unique \(L(6)\) embedding and projection both have outer eigenvalue
\(+1\).

Thus q=121 is not an unexplained finite exception: the affine class is
forced into the single outer-even Frobenius-asymmetric channel \(T_+\).
The \(L(6)\) socle and
head lie in the two outer square/exterior layers, explaining the observed
radical occurrence and why every primary head or ordinary-contraction
trace is blind.

This does not yet prove C1.  In the associated graded of the quadratic
kernel, multiplication by the bottom \(L(6)\) gives a trace back to
\(T_+\) with scalar \(\dim L(6)=7\ne0\).  A complete proof must still
show that this graded trace is not killed by a higher filtration
transgression.  Outer parity isolates the component but does not itself
close the gate: the affine class, embedding, and projection are all
outer-even.  The direct Borel pullback or an exact filtered connecting-map
calculation is now required.

The exact finite Borel presentation uses generators
\(u(1),u(a)\), the split torus, their order and commutation relations, and
the two torus-conjugation relations.  For each simple it computes normalized
cocycles and torus-fixed coboundaries directly.  Replay from the repository
root with

```text
nix shell nixpkgs#sage -c sage -python \
  notes/2026-07-29-c665-q121-borel-simple-h1.sage --check
sha256sum -c notes/2026-07-29-c665-q121-borel-simple-h1.sha256
```

The script, canonical certificate, and input manifest share the stem
`notes/2026-07-29-c665-q121-borel-simple-h1`.  The invariant checks are the
presentation relations, containment of every coboundary in the cocycle
kernel, the \(15+25+15\) complete graded-factor count, normalized dilation
conjugation, and the \(+1,-1\) outer eigenvalues on the only two nonzero
rows.  The adjacent affine-socle certificate independently checks outer
eigenvalue \(+1\) on both unique \(L(6)\) Hom directions.

McDowell--Wildon, arXiv:2105.00538v3, Corollary 1.5 and Section 5 supplies
the characteristic-independent Hermite isomorphism (cached PDF SHA-256
`8e9012cea77b2eca5aecf03238fd0565155a6941c89c98c422533d94aa94a890`).
Martin, arXiv:1705.06980, Lemma 2.3 records the dual-Weyl short exact
sequence (cached PDF SHA-256
`235d7b2f26ca808c6ddfad8d738b744aca23a06a623b3f27108a3c85dbc5f1f2`).
These sources provide the architecture, not the q=121 C1 conclusion.

## Replacement attacks

The contraction route is now closed negatively.  Three genuinely different
routes remain.

1. Restrict the original pullback to the Borel.  Since
   \([H:B]=q+1\) is invertible in
   characteristic \(p\), restriction on first cohomology is injective.  A
   torus-weighted unipotent left-kernel certificate therefore decides the
   pullback without constructing the full symmetric square.
2. Use modular Hermite reciprocity
   \[
   \operatorname{Sym}_{d}(\operatorname{Sym}^{2}V)
   \simeq
   \operatorname{Sym}_{2}(\operatorname{Sym}^{d}V)
   \]
   to replace ternary plethysm by a symmetric square of a binary
   Weyl/dual-Weyl module, then compute embedding, retraction, and extension
   scalars recursively in Frobenius digits.
3. Search for an explicit \(q=121\) splitting.  A positive result would
   falsify C1 rather than merely another proposed detector.

The outer-parity half of the preferred test is now closed but compatible,
not exclusive.  The current highest-EV order is therefore the exact
filtered connecting map on the graded trace above, followed by the full
direct Borel system if needed.  The modular-Hermite filtration remains the
preferred uniform theorem architecture.

The degree-two source of that connecting map is also reduced exactly.
Writing the three graded layers as \(C_0,M,C_2\), its only possible source
is
\[
\operatorname{Hom}_H\!\left(
L(6),(C_0\otimes C_2)\oplus\operatorname{Sym}^2M
\right).
\]
Across all \(225+25+300=550\) small summands this space has dimension
\(60\), all outer-even: twenty one-dimensional
\(C_0\otimes C_2\) channels and forty one-dimensional cross terms between
distinct simple factors of \(M\).  None of the twenty-five diagonal
symmetric squares contributes.  Thus the remaining computation is a
single filtered connecting functional on sixty explicit rows, rather than
a Hom calculation in the full \(1{,}675{,}365\)-dimensional
\(\operatorname{Sym}^2F\).

Replay the streaming reduction with

```text
nix shell nixpkgs#sage -c sage -python \
  notes/2026-07-29-c665-q121-transgression-domain.sage --check
sha256sum -c notes/2026-07-29-c665-q121-transgression-domain.sha256
```

The checker uses tensor adjunction on cross summands and directly verifies
one nonzero and one zero summand in both the direct and adjoint
realizations.  Its three simultaneous streaming eliminations compute the
unrestricted, outer-even, and outer-odd Hom dimensions with memory bounded
by the torus-block variable count.

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
| \(L(6)\) embeds and co-occurs in the head, but \(\pi i=0\) | settled exact occurrence and outer-layer location | prove the middle-to-bottom graded trace survives transgression |
| retired top Hasse channel gives a \(1\to2\) rank jump | settled as an artifact of a non-equivariant operator | none; do not reuse the rank jump |
| all ten valid ordinary contractions | settled Borel-blind with exact coboundaries | none; move to the original Borel class |
| affine class in the \(L(6)\) head | settled zero; correction scalar \(4\) | identify the secondary radical layer carrying the affine class |
| \(L(8)\) and \(L(8)^{(1)}\) head probes | settled absent | none; do not infer a prime-field cohomology head |
| affine-class support | settled in the outer-even \(T_+\) middle channel | none |
| actual \(q=121\) quadratic pullback | open; transgression domain reduced to \(60+0\) outer dimensions | evaluate the filtered connecting functional, or use the direct Borel fallback |
| uniform extension-field C1 | open | occurrence-level recursive theorem covering every exceptional candidate family |

Vibe check: the prior positive model failed at a load-bearing seam, but the
failure is sharp and cheap to certify; the task is healthier with the false
shortcut removed, and the Borel/Hermite routes are structurally better than
another field-sized symmetric-square calculation.
