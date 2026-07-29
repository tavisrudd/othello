# C682 transvectant deformation map to the incidence fibre

## Outcome

The missing map exists on the marked characteristic-\(11\) fibre, but it
requires one more coordinate than the ordinary dodecic normal quotient.
That extra coordinate is the Bockstein direction of the primitive divided
transvectant.

Put
\[
 H=\operatorname{Sym}^6(\mathbf F_{11}^2),\qquad
 N=\operatorname{Sym}^{12}(\mathbf F_{11}^2)/
       (V^{(1)}\otimes V).
\]
The ordinary right-slot third transvectant induces an injection
\[
 \Theta:N\longrightarrow
 \operatorname{Hom}(H,\operatorname{Sym}^{12}),\qquad
 [L]\longmapsto(-,L)_3.
\]
Its rank is nine and its kernel before quotienting is exactly
\[
 V^{(1)}\otimes V
 =\langle X^{12},X^{11}Y,XY^{11},Y^{12}\rangle.
\]
Let \(P_F\) be the primitive Bockstein/Hasse operator of the fixed Klein
lift
\[
 F=X^{11}Y+11X^6Y^6-XY^{11}.
\]
Exact linear algebra gives
\[
 P_F\notin\Theta(N).
\]
Consequently the correct normal space is the ten-dimensional extension
\[
 \widehat N=\mathbf F_{11}\beta\oplus N,\qquad
 \widehat\Theta(a,[L])=aP_F+5(-,L)_3.
\]
The map \(\widehat\Theta\) is injective.  On its rank-four locus it gives
the projective kernel morphism
\[
 \kappa:\mathbf P(\widehat N)\dashrightarrow
 \operatorname{Gr}(3,H),\qquad
 [a,L]\longmapsto\ker\widehat\Theta(a,[L]).
\]
The earlier affine formula \(P_F+5(-,K)_3\) is the chart \(a=1\).
Homogenizing by \(\beta\) is what makes the construction a map of normal
lines rather than an affine assignment depending on the chosen origin.

For the corrected class \(K\), the line
\[
 \ell_K=\langle(1,[K])\rangle\subset\widehat N
\]
maps to a rank-four kernel \(U_K\).  The projective exchanger
\[
 R_{\mathrm{bin}}=
 \begin{pmatrix}1&3\\3&6\end{pmatrix}
 \in\operatorname{PGL}_2(\mathbf F_{11})
\]
is the binary image of Paper III's orthogonal exchanger
\[
 (x,y,z)\longmapsto(x,-z,y).
\]
It acts on \(\widehat N\) through the Bockstein cocycle
\[
 R\cdot(a,[L])=(a,[R L+a\,c_R]),
\]
where \(c_R\) is uniquely determined in \(N\) by
\[
 \rho_{12}(R)P_F\rho_6(R)^{-1}-P_F=5(-,c_R)_3.
\]
Thus
\[
 R\ell_K=\ell_{K_R},\qquad
 \kappa(\ell_{K_R})=R\kappa(\ell_K).
\]
The two normal lines are distinct in \(\mathbf P(\widehat N)\).

## The incidence morphism

Use the sixth apolar pairing to write
\[
 V_L=\ker\widehat\Theta(L)^\perp\subset H.
\]
On the rank-four fifth-transvectant-isotropic locus, define
\[
 \widehat{\mathcal I}
 =
 \{([a,L],[f]):[f]\in\mathbf P(V_L)\}.
\]
Then
\[
 ([a,L],[f])
 \longmapsto
 ([f],\ker\widehat\Theta(a,[L]))
\]
is a morphism from this normal-incidence bundle to Hitchin's incidence
scheme
\[
 \mathcal I=\{([f],U):U\in X,\ f\perp U\}.
\]
The construction is scheme-valued on the open set where the operator has
constant rank four: the universal kernel is a rank-three subbundle there,
and the apolar annihilator is its rank-four quotient dual.

For the two exchanged lines, the exact kernels are
\[
\begin{aligned}
U_K={}&\langle
(1,3,3,1,0,0,0),\\
&\qquad(6,8,2,0,5,1,0),
(8,5,9,0,7,0,1)\rangle,\\
U_{K_R}={}&\langle
(10,3,8,1,0,0,0),\\
&\qquad(5,8,9,0,6,1,0),
(8,6,9,0,7,0,1)\rangle .
\end{aligned}
\]
Each plane is pairwise isotropic for the fifth transvectant.  They are
distinct, their sum has dimension six, and their apolar annihilator
four-planes meet in the line
\[
 V_K\cap V_{K_R}
 =
 \left\langle
 X^6+6X^4Y^2+6X^2Y^4+Y^6
 \right\rangle .
\]

This line is exactly \([xyz]\) in the binary convention already used by
the C399/C651 certificates.  Solving for that convention's quadratic
parameterization of the null conic gives
\[
\begin{aligned}
x&=7u^2+8uv+4v^2,\\
y&=4u^2+8uv+7v^2,\\
z&=u^2+v^2,
\end{aligned}
\]
and hence
\[
 xyz|_{\mathcal Q}
 =
 6\bigl(u^6+6u^4v^2+6u^2v^4+v^6\bigr).
\]
Moreover \(R_{\mathrm{bin}}\) acts on the displayed sextic by \(-1\), in
exact agreement with Paper III's \(R(xyz)=-xyz\).

The two points
\[
 ([xyz],U_K),\qquad([xyz],U_{K_R})
\]
therefore lie in Hitchin's incidence fibre and are exchanged by \(R\).
The already-proved finite-etale degree-two theorem at \(xyz\) makes them
the complete fibre.  The selected corrected tower has orientation scalar
\(s=4\), while its exchanged line has \(s=-4=7\); this is now an
object-level incidence comparison, not only equality of quadratic
character algebras.

## Inverse construction

The cheap `ej` upgrade makes the map two-sided on the golden pair.  Given
either parent plane \(U\), impose the linear equations
\[
 \widehat\Theta(a,[L])|_U=0.
\]
They have rank nine in the ten-dimensional space \(\widehat N\), so their
projective solution is one line.  For \(U_K\) it is exactly
\(\ell_K\); for \(U_{K_R}\) it is exactly \(\ell_{K_R}\).  Thus the
kernel and extended-annihilator constructions are inverse on the two
golden incidence points:
\[
 \ell_\pm
 \ \xleftrightarrow[\ 
 U\mapsto\ker(\widehat\Theta(-)|_U)\ ]{\ 
 [a,L]\mapsto\ker\widehat\Theta(a,[L])\ }
 U_\pm .
\]

This resolves the typing defect in the previous report.  The class
\([K]\) is not equated with \(d(5J_0)\).  Instead, its homogenized
Bockstein line maps to an isotropic parent plane; adjoining its apolar
annihilator maps it into the actual incidence scheme, and the two
exchanged images meet over the binary line representing \(xyz\).

## Proof boundary

The following parts are exact finite-field deductions:

- the nine-dimensional ordinary quotient and ten-dimensional Bockstein
  extension;
- the exchanger cocycle and covariance of \(\widehat\Theta\);
- both rank-four kernels and all fifth-transvectant isotropy equations;
- both apolar four-planes and their one-dimensional intersection;
- the binary identification of that intersection with \(xyz\); and
- the inverse extended-annihilator lines.

The identification of the isotropic-plane scheme with the
Mukai--Umemura threefold and the finite-etale degree-two incidence theorem
at \(xyz\) are the human geometric inputs already proved and sourced in
Paper III.  This report does not prove good reduction of the global
incidence comparison, extend the construction away from the marked
mod-\(11\) fibre, make a novelty claim, or reopen the pre-release-green
manuscript.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-28-c682-transvectant-deformation-map.py --check
python3 ../notes/2026-07-28-c682-transvectant-deformation-map-replay.py
```

The generator derives the exchanger from the Euclidean conic action,
constructs the Bockstein extension, and writes the complete canonical
certificate.  The independent replay reimplements symmetric powers,
ordinary transvectants, finite-field row reduction, apolarity, isotropy,
the conic parameterization, and both inverse maps without importing the
generator.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-28-c682-transvectant-deformation-map.py` | 18734 | `1a434682bf199f5eef82f52bed7c0dc49099832afe461ced9e90c740cbb4fd0a` |
| `2026-07-28-c682-transvectant-deformation-map.json` | 10168 | `69586092c1061b103fd544311068968b3e08603b1f0cc8eae10caba0073c45d9` |
| `2026-07-28-c682-transvectant-deformation-map-replay.py` | 12787 | `0295c4eb606cee5f749eda7a00f36750993231d82ae0c22fb2958cc406c8afd2` |

The JSON records byte counts and SHA-256 hashes for every imported
load-bearing input.

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the ordinary quotient alone cannot carry a normal line to
  the incidence scheme.  The obstruction is exact:
  \(P_F\notin\Theta(N)\), and adjoining its Bockstein direction raises the
  operator-space rank from nine to ten.
- **Closed:** the exchanger acts on the extended normal space through the
  explicit cocycle \(c_R\), and carries the selected line to a distinct
  conjugate line.
- **Closed:** the two lines map to distinct isotropic parents over
  \([xyz]\), hence to the complete marked incidence fibre.
- **Closed by `ej`:** the inverse equations recover each extended normal
  line uniquely from its parent plane.  The comparison is therefore not
  a one-way numerical coincidence.
- **Explained:** the former proposed equality \([K]=d(5J_0)\) was
  ill-typed.  The correct bridge is the kernel--apolar-incidence diagram
  above.
- **Open:** globalize \(\widehat N\) as the first-jet or normal-cone
  object of the divided transvectant over \(\mathbf Z_{11}\), and decide
  whether its rank-four isotropic locus maps isomorphically to a formal
  neighborhood of the golden incidence cover.  The present theorem is
  the exact special-fibre map, not that formal comparison.
- **Open:** determine whether the Bockstein extension and cocycle have an
  intrinsic Witt-vector description independent of the chosen marked
  Klein lift.  The quotient class and incidence points are intrinsic in
  the stated marking; this stronger integral formulation is not yet
  proved.

No genuine mystery remains in the marked mod-\(11\) deformation map.
C682 remains open; completion is the user's decision.
