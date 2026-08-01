# C716 — Golden synthesis of two-\(U(1)\) anomaly lines

**Lane:** `golden`

**Date:** 2026-07-31

## Verdict

The two mixed Abelian anomaly equations are exactly the two middle
coefficients of the Segre cubic along a projective line.  In the frozen C707
marking they are also the two mixed determinant--Pfaffian identities

\[
 \sum_T\det A_T(x)\operatorname{Pf}A_T(y)=0,
 \qquad
 \sum_T\operatorname{Pf}A_T(x)\det A_T(y)=0,
 \quad A_T(x)=[D_x,C_T].
\]

The Golden lift gives a direct control model for all 21 classical components
of the Fano scheme.  The fifteen plane components are the fifteen fixed path
collisions.  The six degree-five del Pezzo components are the six choices of
one moving path point with the other five fixed.  Thus every chiral component
has a linear one-control sweep, and its five vectorlike crossings form a
synthematic total.  That five-crossing syndrome identifies the moving path and
hence the component.

This does not change the classical Fano classification.  It adds its exact
Golden marking, minimal control degree, physical filter witnesses, and mixed
Majorana identities.

## 1. Lines and the six anomaly equations

Let \(q,r\in k^6\) be independent and put \(z(t)=q+tr\).  In characteristic
zero,

\[
 \sum_i z_i(t)^3
 =\sum_iq_i^3+3t\sum_iq_i^2r_i
  +3t^2\sum_iq_ir_i^2+t^3\sum_ir_i^3.
\]

Consequently the projective line \(\mathbf P\langle q,r\rangle\) lies on the
Segre cubic

\[
 S=\{\textstyle\sum_i z_i=\sum_i z_i^3=0\}\subset\mathbf P^5
\]

if and only if

\[
\begin{gathered}
 \sum_iq_i=\sum_ir_i=0,\qquad
 \sum_iq_i^3=\sum_ir_i^3=0,\\
 \sum_iq_i^2r_i=\sum_iq_ir_i^2=0.
\end{gathered}
\]

These are precisely the gravitational and cubic anomaly equations for the
two factors and the two mixed cubic equations.  A change of basis in the two
\(U(1)\)'s only reparametrizes the same line.

## 2. The marked Fano components

Write \(\Phi:(\mathbf P^1)^6\dashrightarrow S\) for the frozen Golden/Joubert
map.  Each coordinate of \(\Phi\) is multihomogeneous of degree one in each
path point.  Fix five path points and vary the remaining point \(p_i\).  The
image is therefore a projective line

\[
 L_i(p_{\widehat\imath})
 =\{\Phi(p_0,\ldots,p_{i-1},u,p_{i+1},\ldots,p_5):u\in\mathbf P^1\}.
\]

For five general distinct fixed points this line is chiral.  Its parameters,
modulo the diagonal \(\operatorname{PGL}_2\)-action, form \(M_{0,5}\).  Its
compactification \(\overline M_{0,5}\) is the split degree-five del Pezzo
surface.  The imported Fano classification has exactly six such components,
so the six choices of moving path give all of them.  This also explains their
natural outer \(S_6\)-action: ordinary permutation of path labels permutes the
moving-control label, while the charge coordinates carry the frozen outer
action.

In the notation of Gripaios--Nguyen Nguyen, the exact C707 identification is

\[
 (D_0,D_1,D_2,D_3,D_4,D_5)
 \longleftrightarrow
 (D^{\rm path}_4,D^{\rm path}_1,D^{\rm path}_0,
  D^{\rm path}_2,D^{\rm path}_3,D^{\rm path}_5).
\]

When the moving point meets one of the five fixed points, the line meets a
vectorlike plane.  The five collision planes form a synthematic total.  For
example, moving path 5 gives

\[
 \{01|24|35,\ 02|15|34,\ 03|12|45,\ 04|13|25,\ 05|14|23\}.
\]

This collision pentad is an operational component readout.  It is equivalent
to the classical total, so it is not a new unmarked invariant of the Fano
scheme.

For the nonchiral components, a fixed path collision \(p_i=p_j\) maps onto one
of the fifteen Segre planes.  The frozen outer correspondence is

\[
\begin{array}{c|ccccc}
ij&01&02&03&04&05\\ \hline
\text{charge syntheme}&01|23|45&05|13|24&04|12|35&03|14|25&02|15|34\\[2pt]
ij&12&13&14&15&23\\ \hline
\text{charge syntheme}&02|14|35&03|15|24&05|12|34&04|13|25&01|25|34\\[2pt]
ij&24&25&34&35&45\\ \hline
\text{charge syntheme}&04|15|23&03|12|45&02|13|45&05|14|23&01|24|35
\end{array}
\]

Lines in each such plane form its dual \(\mathbf P^2\), giving the fifteen
plane components of the Fano scheme.  The certificate supplies one rational
Golden line on each plane and one on each del Pezzo component.

## 3. Exact physical control families

All controls below lie in the physical cube \([-1,1]^6\).

For a chiral line in \(D^{\rm path}_4\), take

\[
 x(s)=\left(0,-\frac12,-1,-\frac37,s,-\frac35\right).
\]

The amplitude is affine-linear in \(s\).  At \(s=1/2\) and \(s=3/4\),

\[
 Z(x(1/2))=\frac1{140}(59,29,19,-55,-41,-11),
\]

\[
 Z(x(3/4))=\frac3{280}(49,23,17,-45,-35,-9).
\]

Both primitive charge vectors are strictly chiral, their two mixed sums
vanish, and no two ordered charge pairs are opposite.  This is an exact
six-Weyl, two-\(U(1)\) chiral witness.

For a nonchiral line in the plane belonging to the path collision \(01\), take

\[
 y(s)=\left(0,0,-1,-\frac12,\frac12,s\right).
\]

At \(s=2/3\) and \(s=3/4\),

\[
 Z(y(2/3))=\frac1{12}(-13,13,-3,3,1,-1),
\]

\[
 Z(y(3/4))=\frac1{16}(-19,19,-5,5,1,-1).
\]

The three charge pairs \(01,23,45\) are opposite for both factors.  Path
permutation and the marked duad--syntheme table transport these two formulas
to representatives of all fifteen plane components and all six chiral
components.

## 4. Minimal control degree

On any C715 inverse chart, the reconstructed path coordinates are ratios of
matching forms.  Restricting to \(z(t)=q+tr\) makes each matching form linear
in \(t\), so every path coordinate is fractional-linear.  Equivalently, its
homogeneous pair has degree at most one.  For a chiral component the preceding
description is stronger: after one common projectivity, five path points are
constant and the sixth is affine-linear.

Degree zero would make every path point constant and hence make the amplitude
point constant.  Thus homogeneous degree one is minimal for every nonconstant
anomaly line.  Normalizing an affine sweep to the physical cube can replace
the moving scalar by a fractional-linear function on a chamber, but does not
raise the projective degree.

## 5. Mixed Pfaffian identities

For a Golden control \(x\), let

\[
 A_T(x)=[D_x,C_T],\qquad
 \pi_T(x)=\operatorname{Pf}A_T(x)=4Z_T(x).
\]

Since \(A_T(x)\) is a \(6\times6\) skew matrix,
\(\det A_T(x)=\pi_T(x)^2=16Z_T(x)^2\).  Therefore two controls synthesizing
charge bases \(q=Z(x)\) and \(r=Z(y)\) satisfy the mixed anomaly equations if
and only if

\[
 \boxed{\sum_T\det A_T(x)\operatorname{Pf}A_T(y)=0},
 \qquad
 \boxed{\sum_T\operatorname{Pf}A_T(x)\det A_T(y)=0}.
\]

Each left side is 64 times the corresponding mixed charge sum.  Along a
one-path sweep, every \(\pi_T\) is linear in the moving control.  The two
identities are then the middle coefficients of
\(\sum_T\pi_T(x(s))^3=0\).  This is the operator form of line containment,
not an additional anomaly condition.

## 6. Classical input and attribution

The 21-component classification is imported, not reproved.  Gripaios and
Nguyen Nguyen, *Anomaly cancellation for two \(U(1)\) factors*, arXiv
v1:2607.09879, Sections 4.1--4.2.1 and Appendix E, prove that the Fano scheme
has fifteen plane components and six mutually isomorphic split degree-five
del Pezzo components, with the latter permuted transitively by \(S_6\).
**Read depth:** `partial`, exactly those sections, from cache key
`arXiv:2607.09879`, SHA-256
`d9e4e7905e270e31a01c6c3a05e11388650cfd40579b2bf98d2bd9820d2493b3`.

The one-moving-path realization, frozen component dictionary, physical cube
witnesses, and determinant--Pfaffian translation are the Golden transport of
that geometry.  They do not constitute a new abstract classification and do
not construct a gauge theory or Lagrangian.

## 7. Exact evidence and replay

The evidence bundle is:

- `notes/2026-07-31-c716-golden-two-u1-lines.py`;
- `notes/2026-07-31-c716-golden-two-u1-lines.json`;
- `notes/2026-07-31-c716-golden-two-u1-lines-replay.py`;
- `notes/2026-07-31-c716-golden-two-u1-lines.sha256`.

From the repository root, run

```text
python3 notes/2026-07-31-c716-golden-two-u1-lines.py --check
python3 notes/2026-07-31-c716-golden-two-u1-lines-replay.py
```

The generator reconstructs the six frozen cubics from the conference matrix,
derives the fifteen collision synthemes, constructs exact families on all 21
components, and translates the source's six labels through the C715 inverse.
The replay hard-codes the six cubic tables and independently checks every
family, all anomaly sums, strict chirality or the prescribed opposite pairs,
the component dictionary, and the base Pfaffian normalization.  Computation
fixes signs, rational witnesses, and the marked dictionaries.  It does not
prove the imported Fano classification or the standard isomorphism
\(\overline M_{0,5}\cong\operatorname{dP}_5\).

## 8. `ej` + `tt` closeout and mystery ledger

- **Settled by `ej`:** every chiral component has a one-path affine sweep;
  no general nonlinear inverse is needed.
- **Settled by `ej`:** the five collision values of that moving path give a
  component syndrome, and the syndrome is exactly a synthematic total.
- **Settled by `tt`:** homogeneous control degree one is both sufficient and
  minimal.  Physical cube normalization changes affine coordinates to
  fractional-linear ones but introduces no projective obstruction.
- **Settled by `tt`:** the mixed Pfaffian identities contain no independent
  higher invariant; they are the two middle coefficients of the cubic along
  the line.
- **Open by design:** the collision pentad is a new operational readout but is
  algebraically equivalent to the known total.  No priority claim is made for
  a new invariant of the unmarked Fano scheme.
- **No genuine mystery remains in the C716 line synthesis, component marking,
  minimal-degree control, or mixed-Pfaffian interface.**
