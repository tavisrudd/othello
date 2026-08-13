# C907 — Geiser attachment as a Novikov-line continuation problem

Date: 2026-08-13

Status: reduction, not a theorem.  The two point-blowup receivers and the
Chen--Tseng middle-flop intertwiner can be placed on one analytic path after
the nonextremal Novikov degree is treated as a line bundle over the extremal
Kahler coordinate.  All algebraic, aperture, and local-finiteness obstacles
then disappear.  The remaining hypothesis is one parameter-uniform
sectorial-realization lemma for a separated whole block near each endpoint.

## 1. The apparent incompatibility

For the Geiser peak use the curve bases

\[
 (e,c)\quad\text{on }Y=\operatorname{Bl}_pX,
 \qquad
 (e',c')\quad\text{on }Y^+,
\]

where `e,e'` are point-exceptional lines and `c,c'` are the effective
flopping curves.  The middle flop gives

\[
 c'=-c,\qquad e'=e+3c.
 \tag{1}
\]

Thus, for `q=Q^e`, `s=Q^c`, `q'=Q^{e'}`, `s'=Q^{c'}`,

\[
 s'=s^{-1},\qquad q'=qs^3.
 \tag{2}
\]

The left and right large-radius rings are `C[[q,s]]` and `C[[q',s']]`.
Neither origin lies in their Laurent overlap.  Holding `q` fixed while
continuing `s` sends `q'` to infinity; holding `q'` fixed forces
`q=q's^{-3}`.  This is the exact failure of all fixed-parameter banking
proposals.

## 2. Quotient degree is a Novikov line, not a global coordinate

Lee--Lin--Qu--Wang index ordinary-flop series by a curve class modulo the
extremal ray.  Here

\[
 N_1(Y)/\mathbf Zc\cong\mathbf Z[e]
 \cong N_1(Y^+)/\mathbf Zc'.
\]

For quotient degree `a`, the left effective representatives are

\[
 ae+bc,\qquad b\ge0,
\]

while the corresponding right representative is

\[
 ae'+(3a-b)c'.
\]

The monomial equality is

\[
 q^as^b=(q')^a(s')^{3a-b}.
 \tag{3}
\]

Equation (3) means that `q` and `q'` are local frames of the same quotient
Novikov line over the compactified `s`-sphere, with transition `s^3`.
Equivalently, choosing the shifted source lift `e+3c` makes its local monomial
`qs^3` equal to `q'`.  The source extremal series then has a finite Laurent
tail down to `s^{-3a}` rather than being a power series.  This is harmless:
each quotient degree is treated separately, exactly as in LLW.

The correct common object is therefore not a bidisk with one global
nonextremal coordinate.  It is the completed direct sum of the powers of
this Novikov line, with analytic continuation in `s` and formal completion
in its fibre degree.

## 3. Local finiteness is exact

On `Y`,

\[
 c_1(Y)=2(H-E),\qquad
 c_1(Y)\cdot e=2,\qquad c_1(Y)\cdot c=0.
\]

For a genus-zero coefficient of degree `ae+bc`,

\[
 \operatorname{vdim}_{\mathbf C}\overline M_{0,n}(Y,ae+bc)=n+2a.
\]

Fixed homogeneous insertions and descendant powers therefore fix `a`.
The only infinite sum is the extremal `b`-series, precisely the series LLW
prove analytic and continue by `s'=s^{-1}`.  After product with `P^2`, a
base-line degree adds `3d` and the same conclusion holds coefficientwise.

Hence the proposed path requires no illegal map `C[[q]] -> C` and no
unproved convergence in the transverse degree.  It is a locally finite
formal family of one-variable analytic continuations.

## 4. Endpoint sectors have enough aperture

For either codimension-three point blowup, Shen--Shoemaker has
`r=3`, `s=1`, `nu=2`.  With the balanced Orlov normalization `k=1`, the two
center indices are `m=-1,0`, and the whole decomposition has the common
sector

\[
 -\pi<\arg(z/q)<\pi.
 \tag{4}
\]

An off-center point belongs to the tame/ambient block, whose own sector is
already (4).  On a positive-real continuation path, (2) preserves the phase
of the two local frames `q,q'`; the same `z`-sector can be used at both ends.
Thus neither sector width nor the pairing flip is the obstruction.

## 5. The exact remaining lemma

Let `A_L` be the whole ambient block in the left point-blowup comparison and
`A_R` the whole ambient block on the right.  At the respective endpoint
germs the leading irregular eigenvalues of the point-exceptional center
blocks are nonzero multiples of `q` or `q'`, whereas the ambient cluster
conflues at zero.  Therefore each ambient cluster is spectrally separated
from its point-exceptional center clusters when its local Novikov frame is
nonzero.

The needed statement is:

> **Separated-cluster continuation lemma.**  For the Geiser two-parameter
> quantum connection, the formal ambient projector supplied by the
> point-blowup comparison has a canonical sectorial realization on (4),
> holomorphic in the quotient-Novikov line near the endpoint and compatible
> with LLW analytic continuation in `s`.  Its realization is jointly flat in
> the parameter directions.  Under Chen--Tseng's descendant transformation
> it becomes the corresponding right ambient realization.

Only whole clusters occur in this statement.  The cubic primitive-sixth atom
is allowed to confluence at the endpoint and is restricted only after the
whole-block identity has been transported to a nonzero interior parameter.
This avoids the false deconfluence move.

The lemma has standard analytic shape: parameterized
Hukuhara--Turrittin/multisummation on a domain without a turning point between
the ambient and center clusters.  What must still be checked, rather than
assumed, is that the correlated path can be chosen inside one such domain or
covered by finitely many domains whose transition maps are exactly the
Chen--Tseng descendant continuation.

## 6. Conditional closure of the Geiser peak

Assume the separated-cluster continuation lemma.

1. The left Gu--Yu--Yu/Shen--Shoemaker receiver identifies the endpoint
   cubic rank Boolean with the restriction of the intrinsic Gamma rank row
   to `P_6(Y)` inside `A_L`.
2. Continue `A_L` along the quotient-Novikov line and the extremal coordinate.
   Chen--Tseng's Gamma/Fourier--Mukai square fixes the off-exceptional point
   class and transports the complete formal-monodromy packet across the
   middle flop.
3. The lemma identifies the result with `A_R` in the right balanced receiver.
   The right point-blowup theorem then identifies its Boolean with that of
   the target cubic.
4. Tensoring the entire construction with the small QDM of `P^2` preserves
   the point row, the aggregate primitive-sixth packet, and the continuation.

Therefore the lemma implies rank-Boolean invariance for the complete Geiser
peak and for its product with `P^2`.

This does not prove Gold: a general fivefold weak factorization has peaks
other than the Geiser link.  It does, however, reduce the first genuine peak
from an undefined frame comparison to one named analytic lemma with all
algebraic and angular hypotheses explicit.

## 7. Falsifiers

The lemma fails if any of the following occurs.

1. Along every correlated path from the left to the right chamber, an ambient
   eigenvalue collides with a point-exceptional eigenvalue, producing an
   unavoidable turning divisor.
2. The parameterized sectorial projector has monodromy around such a divisor
   not equal to the Chen--Tseng Fourier--Mukai transformation.
3. The point-blowup formal ambient projector is not the Taylor asymptotic of
   the intrinsic analytic ambient cluster even on a small punctured endpoint
   domain.
4. Product with `P^2` introduces a turning collision absent in dimension
   three.  Since projective-space factors add the same exponential to every
   compared block, this is not expected, but it should be stated in a proof.

The first bounded computation should be the turning-divisor test for the
small quantum connection of `Bl_pX`, using the exact Geiser coordinate
change (2).  A collision-free path would put the remaining work squarely in
standard parameterized summability; a forced collision would identify the
finite Stokes mutation that must be computed.

## Sources

- J.-C. Chen and H.-H. Tseng, *Descendant and Fourier--Mukai equivalences
  for simple flops*, arXiv:2604.09962v1, especially Theorem 0.2 and Section
  3.  Cached PDF SHA-256:
  `edee1bc9cce58e216ec5973dd409a72de80db593820a912ed54325773edef6df`.
- Y.-P. Lee, H.-W. Lin, F. Qu, and C.-L. Wang, *Invariance of quantum rings
  under ordinary flops III*, arXiv:1401.7097, Theorem 0.1.1 and Sections
  1.2--1.3.  Cached PDF SHA-256:
  `eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c`.
- Shen--Shoemaker, arXiv:2502.08762v2, equations (64), (78), and Remark 1.6,
  for the endpoint sectors.  Cached PDF SHA-256:
  `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.
- T. Dreyfus, *A density theorem for parameterized differential Galois
  theory*, arXiv:1203.2904, for parameterized Hukuhara--Turrittin and Stokes
  operators.  This is a technology pointer, not yet a checked theorem citation
  for the separated-cluster lemma.

## EJ / TT / AA

- **EJ:** `q'=qs^3` is best read as the transition of a Novikov line.  In
  quotient degree, LLW already performs exactly the required Laurent
  reindexing.  The fixed-parameter contradiction disappears without ever
  evaluating a formal series at an unauthorized point.
- **TT:** line-bundle reindexing does not itself compare sectorial fibre
  functors.  The separated-cluster continuation lemma is load-bearing and is
  not claimed to follow verbatim from any cited theorem.
- **AA:** this is a conditional closure of one peak, not a globalization
  theorem.  Its immediate regression is the turning-divisor computation,
  not another formal-corner proposal.
