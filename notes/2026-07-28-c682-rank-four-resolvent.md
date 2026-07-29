# C682 complete ten-pair rank-four resolvent

## Outcome

The proposed six-point exhaustiveness statement is false on the full
ten-pair module.  The exact replacement is stronger and more structured.

Let
\[
 \widehat\Theta(x):H_6\longrightarrow \operatorname{Sym}^{12}
 \qquad
 (x\in P_{10}=\mathbf1\oplus V_4\oplus V_5)
\]
be the marked characteristic-\(11\) operator pencil constructed in the
transvectant-deformation report, and let
\[
 Z=V(I_5(\widehat\Theta))\subset\mathbf P(P_{10})
\]
be its projective rank-at-most-four scheme.  Then:

1. \(Z\) is a reduced set of \(22\) \(\mathbf F_{11}\)-rational points;
2. every point has operator rank exactly four, projective tangent-equation
   rank nine, and a fifth-transvectant-isotropic three-dimensional kernel;
3. the kernel map is injective on these \(22\) points;
4. the \(A_5\)-orbit decomposition is
   \[
      Z=Z_1\sqcup Z_5\sqcup Z_6\sqcup Z_{10},
   \]
   with orbit sizes \(1,5,6,10\) and stabilizer orders \(60,12,10,6\);
   and
5. the canonical linear section
   \[
      Z\cap\mathbf P(\mathbf1\oplus V_4)
   \]
   is scheme-theoretically exactly the previously constructed reduced
   \(1+5\) configuration.

Thus the correct full object is a reduced \(1+5+6+10\) Platonic operator
resolvent.  The requested reduced \(1+5\) theorem becomes true after the
canonical Petersen-\(V_5\) direction is removed.

## Explicit \(22\)-point resolvent

Write the ten extended-normal coordinates as
\((x_0,\ldots,x_9)\), with \(x_0\) the Bockstein coordinate.  Every point
of \(Z\) occurs exactly once as
\[
\begin{aligned}
x_0&=1,\\
x_1&=t,&
x_2&=5t^2,&
x_3&=4t^3,&
x_4&=8t^4,\\
x_5&=10+9t^5+s,\\
x_6&=9t^6+6st,&
x_7&=8t^7+4st^2,&
x_8&=4t^8+9st^3,&
x_9&=5t^9+4st^4,
\end{aligned}
\]
where
\[
 t\in\mathbf F_{11},\qquad s\in\{1,-1\}.
\]
The inverse is already visible in the first and sixth coordinates:
\[
 t=x_1,\qquad s=x_5-10-9x_1^5.
\]
Consequently the affine coordinate algebra is
\[
 \mathbf F_{11}[t,s]/(t^{11}-t,\ s^2-1)
 \simeq \mathbf F_{11}^{22}.
\]
This also makes reducedness and rationality transparent once
exhaustiveness has been proved.

## Exhaustiveness proof

Put
\[
 S=\mathbf F_{11}[x_0,\ldots,x_9],\qquad
 I=I_5(\widehat\Theta).
\]
There are
\[
 \dim S_5=\binom{14}{5}=2002
\]
degree-five monomials.  Exact expansion of all \(5\times5\) minors gives
\[
 \dim I_5=1980,\qquad
 h_{S/I}(5)=22.
\]
In degree six,
\[
 \dim S_6=\binom{15}{6}=5005,
\]
and exact row reduction of all coordinate multiples of a basis of \(I_5\)
gives
\[
 \dim (S_1I_5)=4983,\qquad
 h_{S/I}(6)=22.
\]

The decisive point is not merely the repeated number \(22\).  Multiplication
by the Bockstein coordinate has full rank:
\[
 x_0:(S/I)_5\overset{\sim}{\longrightarrow}(S/I)_6.
\]
Surjectivity says
\[
 S_6=I_6+x_0S_5.
\]
Multiplying this identity and inducting gives
\[
 S_d=I_d+x_0^{d-5}S_5\qquad(d\ge6).
\]
Hence \(h_{S/I}(d)\le22\) for every \(d\ge5\).

The displayed parameterization supplies \(22\) distinct projective points
at which every \(5\times5\) minor vanishes.  Their degree-five evaluation
matrix on the \(22\) standard quotient monomials has rank \(22\).
Therefore \(Z\) contains a reduced length-\(22\) subscheme, while the
preceding Hilbert-function argument bounds its total projective length by
\(22\).  The inclusion is consequently an equality of schemes.

As a local cross-check rather than a substitute for the Hilbert argument,
the linearized determinantal equations have projective rank nine at all
\(22\) points.

## The \(1+5\) section and the extra sixteen

Under the exact intertwiner
\[
 P_{10}\longrightarrow\widehat N,
\]
the submodule \(\mathbf1\oplus V_4\) is the five-dimensional star-sum
space
\[
 (a_1,\ldots,a_5)\longmapsto(a_i+a_j)_{1\le i<j\le5}.
\]
Exactly six of the \(22\) parameter points lie in this image.  They are
the fixed radial point and the previously certified \(A_5/A_4\) orbit of
five exchanged points.  Since \(Z\) itself is reduced and zero-dimensional,
its scheme-theoretic intersection with this linear space is the reduced
six-point subset.  This proves the strongest true version of the requested
claim:
\[
 \boxed{
 Z\cap\mathbf P(\mathbf1\oplus V_4)
 = Z_1\sqcup Z_5.
 }
\]

The other sixteen points form orbits of sizes six and ten.  Their
stabilizer orders are ten and six, the standard \(D_5\) and \(S_3\)
Platonic stabilizers.  They are genuine rank-four points, not embedded
or non-isotropic debris: all sixteen have rank four, reduced tangent
space, and isotropic kernel.

## Meaning and boundary

The total length \(22\), the isotropy of every kernel, and injectivity of
the kernel map make the agreement with the anticanonical degree of the
Mukai--Umemura threefold impossible to ignore.  What is proved here is the
finite marked statement: the operator resolvent gives \(22\) distinct
isotropic planes.  It is not yet proved that their image is a linear
section of the anticanonical \(U_{22}\) model.  That stronger statement
requires an intrinsic target-side linear system, not the numerical
coincidence of degrees.

The result is entirely in the marked characteristic-\(11\) fibre.  It does
not globalize the Bockstein extension, assert an integral \(22\)-point
model, reopen Paper III, or make a novelty claim.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-28-c682-rank-four-resolvent.py --check
python3 ../notes/2026-07-28-c682-rank-four-resolvent-replay.py
```

The generator compiles the adjacent C++ core in a temporary directory.
The core expands every \(5\times5\) minor of the \(13\times7\) linear
matrix and performs exact \(\mathbf F_{11}\) Macaulay row reduction.  The
Python layer checks the explicit points, evaluation bases, multiplication
tables, ranks, kernels, isotropy, tangent spaces, \(A_5\)-orbits, and
star-sum section.

The independent replay does not reuse the Macaulay implementation.  It
rechecks the compact multiplication-table certificate, the
\((t,s)\)-parameterization, all \(22\) operator ranks and isotropy
conditions, tangent ranks, orbit sizes, and the exact six-point linear
section.  The exhaustive minor-span ranks remain the trusted boundary of
the separately compiled C++ core.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-28-c682-rank-four-resolvent.cpp` | 13872 | `a1b64a089bc44242e6454209d61fda6d11880fcde3fd9ae16bfaee04fbdfa718` |
| `2026-07-28-c682-rank-four-resolvent.py` | 18428 | `88392afdbeafee706f4860d90c79dc9f5dd4d970ec3fff382177eb87ba86a942` |
| `2026-07-28-c682-rank-four-resolvent.json` | 110767 | `a6b1b642e7e99bbe343943ac5c5d710618dd2f94789a5358f41e59e664e85bd7` |
| `2026-07-28-c682-rank-four-resolvent-replay.py` | 10855 | `f36cb5b42abf76e5fb770aa44416982b2ef51d9f6bbc9a95231b4129e055f292` |

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the full projective rank-four scheme is not the six known
  points.  It is exactly the reduced \(22\)-point scheme above.
- **Closed:** the six known points are nevertheless canonical: they are
  exactly the \(\mathbf P(\mathbf1\oplus V_4)\) linear section.
- **Closed by `ej`:** the extra sixteen split into the two natural Platonic
  orbits of sizes six and ten, giving the complete
  \(1+5+6+10\) resolvent.
- **Closed by `tt`:** isotropy does not remove the extra points.  Every one
  of the \(22\) kernels is fifth-transvectant-isotropic, and the kernel map
  is injective on the finite scheme.
- **Open at highest value:** explain intrinsically why the Bockstein
  ten-pair pencil cuts out \(22=\deg U_{22}\) isotropic planes.  Promotion
  requires a target-side linear-section or bundle construction; equality
  of degrees is not enough.
- **Open:** interpret the split algebra
  \(\mathbf F_{11}[t,s]/(t^{11}-t,s^2-1)\) and the orbit partition
  \(1+5+6+10\) without the marked coordinates.  The exact evidence gap is
  an \(A_5\)-equivariant intrinsic definition of \(t\) and the sheet
  coordinate \(s\).
- **Open:** decide whether the \(6\)- and \(10\)-orbits have an incidence
  meaning alongside the five Clebsch parents that reconstructs more than
  the selected Clebsch frame.

C682 remains open; completion is the user's decision.
