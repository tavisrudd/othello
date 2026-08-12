# C909 — degree-one Prym/axis comparison and the actual modular kernel

Date: 2026-08-12

Status: closes the level-two comparison on the common smooth (A_5/D_5)
open; no manuscript, PDF, mirror, or Lean edit

## The theorem

Work on the common smooth open of the nonstandard (A_5) pencil and the
van Geemen--Yamauchi (D_5) model, with a labelled subgroup

\[
 C_5\triangleleft H\cong D_5\subset A_5.
\]

Let (P=\operatorname{Prym}(\mathcal H/H_0)=J(X)) be the principally
polarized genus-eleven/genus-six Prym.  Quotienting both curves by (C_5)
gives an etale double cover \(\overline{\mathcal H}\to\overline H\) of
genera (3\to2), with principally polarized elliptic Prym

\[
 P_0=\operatorname{Prym}(\overline{\mathcal H}/\overline H).
\]

Let (E_H=\operatorname{Im}(\sum_{h\in H}h)^0\subset J(X)) be the
primitive norm axis, with inclusion (i_H).  Then the quotient pullback
restricts to a canonical polarized isomorphism

\[
 \bar\phi:P_0\xrightarrow{\ \sim\ }E_H.                 \tag{1}
\]

Consequently the explicit elliptic Prym (E''_{a,b}=P_0) identifies with the
actual norm axis, not merely up to isogeny, and the induced map

\[
 E''_{a,b}[2]\xrightarrow{\sim}E_H[2]                     \tag{2}
\]

is symplectic and algebraic in the family.  Under the independently checked
quadratic-twist comparison (E''[2]\cong E_T[2]), the cover

\[
 r^2=T
\]

therefore labels the two **actual** exotic (K[2])-graphs.  On the signed
cubic line, (T=81t^2) and (r=9t).

The qualification “common smooth (A_5/D_5) open” is load-bearing: it is
where the VGY quotient curves are smooth, the (A_5)-pencil has its relative
intermediate Jacobian, and the indicated (C_5\subset D_5) is identified.

## Proof

### 1. The canonical map lands in the norm axis

Let \(\rho:\mathcal H\to\overline{\mathcal H}\) be the degree-five
quotient.  It commutes with the two covering involutions, so pullback induces

\[
 \phi=\rho^*:P_0\longrightarrow P.                        \tag{3}
\]

The image is pointwise fixed by (C_5).  On the coefficient representation

\[
 H^1(P,\mathbf Q)=W_5\otimes M_{\mathbf Q},
\]

both \(W_5^{C_5}\) and \(W_5^H\) have dimension one: their character
averages are respectively \((5+4\cdot0)/5=1\) and
\((5+5\cdot1+4\cdot0)/10=1\).  Hence

\[
 P^{C_5,0}=P^{H,0}=E_H.                                     \tag{4}
\]

The first equality uses the displayed isotypic decomposition; the second
also says that the reflection acts trivially on the fixed coefficient line.
Since \(\phi\) is nonzero between elliptic curves, it factors as an isogeny

\[
 \phi=i_H\circ\bar\phi,qquad \bar\phi:P_0\to E_H.        \tag{5}
\]

This proves the required comparison with the *primitive* (D_5)-axis, not
only with the rational order-five factor used in Proposition 1.5 of
van Geemen--Yamauchi.

### 2. Prym polarization calculation

For an etale double cover, the ambient Jacobian theta restricts to twice the
principal Prym polarization.  Write \(\Xi\) and \(\Xi_0\) for the principal
polarizations of (P) and (P_0).  Thus

\[
 \Theta_{\operatorname{Jac}(\mathcal H)}|_P=2\Xi,
 \qquad
 \Theta_{\operatorname{Jac}(\overline{\mathcal H})}|_{P_0}=2\Xi_0.
\]

The adjoint of \(\rho^*\) on Jacobians is the norm \(\rho_*\), and

\(\rho_*\rho^*=[5]\).  Restricting this equality to the Pryms gives

\[
 \phi^*(2\Xi)=10\Xi_0.
\]

The homomorphism group of an elliptic curve to its dual is torsion-free, so
the factor two cancels integrally:

\[
 \phi^*\Xi=5\Xi_0.                                        \tag{6}
\]

On the other hand the primitive Roulleau/norm-axis comparison gives

\[
 i_H^*\Xi=5\Xi_H,                                         \tag{7}
\]

because \(P=J(X)\) carries the principal polarization \(\Xi\) and
\(i_H^\dagger i_H=[5]\).  Thus \(\Xi\) in (7) is the principal Prym
polarization, whereas the factor \(2\Xi\) above is its restriction from the
ambient Jacobian of \(\mathcal H\).  Substituting (5) into (6)--(7) yields

\[
 5\Xi_0=\bar\phi^*(5\Xi_H)
          =5\deg(\bar\phi)\,\Xi_0.
\]

Therefore \(\deg\bar\phi=1\), proving (1).  This is stronger than the
earlier safe statement “degree (1) or (5)”: the axis polarization fixes
the remaining choice.

No hidden trace denominator or a square-root normalization is used.  The
only cancellation is by the literal integer (2) in a torsion-free Hom
group, and the degree convention is that a degree-(m) isogeny of elliptic
curves pulls a principal polarization back to (m) times a principal
polarization.

### 3. Actual kernel marking

The six coherent norm-axis transports make

\[
 f:E_H^5\longrightarrow J,qquad f^*\Theta=6I_5-J_5,
\]

an actual relative isogeny with \(K=\ker f\).  Equation (1), transported by
(A_5), identifies its two-primary coefficient system with the explicit Prym
coefficient system.  A quadratic twist does not change the finite etale
two-torsion group or its Weil pairing, hence the exact VGY-to-Tate twist
comparison identifies this with (E_T[2]).

The rational three (A_5)-graphs and the exotic pair are invariant subsets
of \(\mathbf P^1(\mathbf F_4)\).  Generic Torelli selects the exotic pair
for the actual kernel, so its permutation character is the discriminant
character of (E_H[2]\cong E_T[2]).  That discriminant cover is (r^2=T).
Thus the cover does not merely resolve an auxiliary Prym system: it marks the
actual kernel (K[2]).

## Modular-component consequence, with its exact scope

Let \(B^\circ\) be the labelled common smooth base above.  The norm-axis
isogeny, its actual finite kernel, and (2) define an algebraic map from the
signed cover \(r^2=T\) into the finite-level marked finite-etale
elliptic-Hecke presentation stack (after the finite level cover needed to
trivialize the (2\)- and (3\)-primary marking).  The normalization of its
unmarked image is the (T)-line, the (X_0(3)) parameter line; the signed
cover is its exotic level-two resolvent.

This proves a **presentation curve in the fixed-data stack**.  It does not
prove that this curve is a connected component of the full Hecke stack, which
is normally higher-dimensional, nor that its unmarked image is embedded
without the fixed period/Torelli normalization.  The (A_5) Torelli argument
is exactly what upgrades the generic period map to the asserted normalized
image statement; no global-stack component claim should replace it.

## Hypotheses that must remain visible

1. The VGY identification is made on the same cubic family and for the same
   labelled \(C_5\triangleleft D_5\) as the norm axis.  An abstract isogeny
   of unrelated order-five factors is insufficient.
2. Both double covers must be etale and smooth.  At discriminant/boundary
   fibres the principal Prym-polarization calculation must be replaced by a
   semiabelian/log statement.
3. The identity \(i_H^*\Theta=5\Xi_H\) uses the already proved primitive
   Roulleau comparison.  Replacing (i_Hq_H) by the raw norm would insert a
   false factor two: \(n_H=2i_Hq_H\).
4. The step from (E_T[2]) to the actual graph uses the *actual* (K\) from
   the norm-axis isogeny and the generic-Torelli exoticity theorem.  It does
   not assert a new classification of all (A_5)-stable graphs.

## Source ledger

* Roulleau, arXiv:1002.4467v1, Theorem 11(D) and the proof by the Albanese
  tangent subspace; cached SHA-256
  `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`.
* van Geemen--Yamauchi, arXiv:1506.05346v3, Proposition 2.1 (the principal
  intermediate-Jacobian Prym), Proposition 3.1 (the etale degree-five quotient
  and explicit elliptic Prym), and Proposition 3.2 (the tangent-factor
  isogeny); cached SHA-256
  `f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed`.

The degree-one conclusion is the new structural deduction from these source
inputs and the independently established primitive axis normalization.

## Mystery ledger

The (ej+tt) closeout settles the formerly separate dyadic gate: the oddness
argument upgrades freely to a degree-one polarized comparison once the
primitive axis degree is used.  No one-fibre period normalization remains
needed for (K[2]).  The primitive symplectic-pair wording for the unrelated
Gamma-zero-three endpoint lattice comparison is already recorded in
`2026-08-12-c909-relative-norm-axis-integrality-audit.md`; it remains needed
only if one asks for that full integral Tate/Prym lattice identification,
not for the mod-two kernel marking proved here.

The remaining genuine boundary is degeneration: extending (1) across the
two modular cusps requires a log/semiabelian Prym statement and is not used by
the smooth finite-etale graph theorem.
