# C907 — the minimal ambient-target Stokes countermodel

Date: 2026-08-13

Status: exact rank-two analytic countermodel, with paired and `P2`-tagged
extensions.  It does **not** come from a known smooth-projective peak.  It
proves that formal monodromy, a flat pairing, an integral Stokes lattice,
and the common `N=1-L` action cannot by themselves imply the rank-zero-target
lemma.  Some genuinely geometric input—one-sided kernel support, a window/
Gamma comparison, or an actual two-wall Fourier-residue theorem—is necessary.

## 1. A rank-two meromorphic connection

Put `alpha=1/6` and consider, on the punctured `z`-disc, the system

\[
 \frac{d}{dz}\binom{y_0}{y_1}=
 \begin{pmatrix}
 0&z^{-2}\\
 0&z^{-2}+\alpha z^{-1}
 \end{pmatrix}\binom{y_0}{y_1}.                                  \tag{1}
\]

One flat column is

\[
 f_0=(1,0)^t.                                                     \tag{2}
\]

The second is

\[
 f_\alpha(z)=
 \left(\Gamma(1-\alpha,1/z),\ z^\alpha e^{-1/z}\right)^t.       \tag{3}
\]

Indeed

\[
 \frac d{dz}\Gamma(1-\alpha,1/z)
   =z^{\alpha-2}e^{-1/z},                                        \tag{4}
\]

which is exactly the first row of (1), and the second row follows by
differentiating `z^alpha exp(-1/z)`.

The formal factors of (1) are

\[
 (0,1),\qquad (-1/z,z^\alpha).                                   \tag{5}
\]

Thus the second factor has formal-monodromy eigenvalue
`exp(2 pi i alpha)=zeta_6`, while the first has eigenvalue one.

## 2. The forbidden target occurs

The standard continuation formula for the incomplete Gamma function is

\[
 \Gamma(s,xe^{2\pi i})
 =e^{2\pi i s}\Gamma(s,x)+(1-e^{2\pi i s})\Gamma(s).             \tag{6}
\]

For `s=1-alpha=5/6`, the additive coefficient in (6) is nonzero.  After
removing the formal-monodromy factor and rescaling `f_alpha` by this nonzero
constant, the Stokes jump is

\[
 f_\alpha^+=f_\alpha^-+f_0.                                     \tag{7}
\]

Let `r` be the flat scalar functional specified in the minus-sector basis by

\[
 r(f_0)=1,\qquad r(f_\alpha^-)=0.                                \tag{8}
\]

Then

\[
 r(f_\alpha^+)=1.                                                \tag{9}
\]

Equation (7) is exactly an elementary Stokes shear whose source is the
primitive-sixth formal line and whose **target** is a rank-visible ambient
line.  It changes the zero/nonzero restriction of `r` to the sectorial lift
of that primitive-sixth line.

This is rank-minimal.  Rank one has no second exponential factor and hence
no nontrivial Stokes root group.  Rank two already realizes the forbidden
target.

## 3. Confluence and a carrier parameter

Pull (1) back by the scaling coordinate `w=z/t`.  On `t!=0` this gives the
flat two-variable meromorphic connection whose `z`-equation is

\[
 \frac{d}{dz}Y=
 \begin{pmatrix}
 0&t z^{-2}\\
 0&t z^{-2}+\alpha z^{-1}
 \end{pmatrix}Y.                                                  \tag{10}
\]

A second column in the pullback normalization is

\[
 \left(\Gamma(1-\alpha,t/z),
       (z/t)^\alpha e^{-t/z}\right)^t.                            \tag{11}
\]

The compatible `t`-equation is obtained directly from
`d-A_0(w)dw`; its matrix is

\[
 C(t,z)=
 \begin{pmatrix}0&-z^{-1}\\0&-z^{-1}-\alpha t^{-1}\end{pmatrix}.
                                                                    \tag{12}
\]

Thus this is a genuinely flat parameter family on the punctured carrier
line, not an arbitrary coefficient deformation.  On the ramified carrier
cover `t^(1/6)`, the Stokes coefficient is the same nonzero constant as in
(7); the `t^{-alpha}` factor records the carrier monodromy.  The two
exponential factors collide at `t=0`.  Therefore (10) has precisely the
singular shape left by the C907
shadow sieve: the primitive-sixth line, a rank-visible ambient target, and a
confluence at which the target orientation can enter.  Purely formal data at
the confluent fibre do not see (7).

This is an analytic carrier model, not a Gromov--Witten construction of a
carrier-dressed peak.  In particular it does not refute Gold.  It refutes the
claim that confluence plus the formal labels is harmless for structural
reasons.

## 4. Pairing, integrality, and the `P2` divisor tag do not kill it

Let `A(z)` be the matrix in (1).  Add the dual system and put

\[
 B(z)=\operatorname{diag}(A(z),-A(z)^t),\qquad
 J=\begin{pmatrix}0&I_2\\ I_2&0\end{pmatrix}.                    \tag{13}
\]

Then

\[
 B^tJ+JB=0,                                                       \tag{14}
\]

so the doubled rank-four connection has an exact flat nondegenerate
symmetric pairing.  If the jump (7) is normalized to

\[
 S=\begin{pmatrix}1&1\\0&1\end{pmatrix},                         \tag{15}
\]

the doubled Stokes operator is `diag(S,S^{-t})`; it preserves `J` and the
obvious integral lattice (over `Z[zeta_6]` after recording formal
monodromy).  Hence Euler/pairing preservation and Stokes integrality do not
exclude the ambient target.

Finally tensor with

\[
 R=\mathbf Q[N]/(N^3),                                           \tag{16}
\]

the abstract length-three `P2` module.  The jump becomes `S tensor 1`, so it
commutes with `N`.  With the rank row tensored by the functional extracting
the constant term of `R`, one has `rN=0`, yet (9) remains true on the
primitive-sixth `J_3` string.  Thus the common line-bundle tag, `N^3=0`, and
`N`-linearity do not force rank-zero target either.

## 5. Exact consequence for Gold

The countermodel separates two statements which had been drifting together.

1. The geometric statement

   \[
   r_p(T_Y-1)|_{P_6}=0                                           \tag{17}
   \]

   for an actual carrier-dressed AKMW peak remains open.
2. Equation (16) cannot be deduced from formal-monodromy labels, local
   constancy away from turning, pairing preservation, an integral Stokes
   lattice, or `N`-linearity.  The model satisfies all of those shadows
   after the extensions above and still has (7)--(9).

The next proof must therefore use a shadow which this model cannot possess:

- one-sided geometric kernel support in `Y times D`;
- equality of the numerical Gamma/Stokes and window rank rows; or
- a two-wall Mellin--Barnes/Fourier residue theorem showing that every
  contour-change residue lands in an unstable-stratum output block.

Conversely, the first genuine Gold counterexample must upgrade (10) to the
small quantum connection of a smooth projective fivefold peak and identify
the rank-visible target with an off-boundary Gamma class.  No current
regression does this.

## EJ / TT / AA

- **EJ:** the smallest dangerous analytic object is the incomplete-Gamma
  extension (1); its Stokes jump points from the `zeta_6` line into a
  rank-one ambient line.
- **TT:** pairing, integrality, `N^3=0`, and `N`-linearity are not singular
  obstructions.  Each survives the doubled/tagged countermodel.
- **AA:** do not compute another nullity system from those shadows.  Attack
  the output support of the two-wall Fourier residues.  If that support
  theorem fails, the first non-supported residue is already the geometric
  realization of (7).
