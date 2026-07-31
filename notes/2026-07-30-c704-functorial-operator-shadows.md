# C704 — functorial operator shadows and Clebsch sisters

**Date:** 2026-07-30  
**Lane:** `clebsch`  
**Status:** complete; positive Segre--Igusa and Cartan gates, bounded negative
later-slice gate, positive \(E_6/E_7\) feasibility gates.

## Outcome

C682's paired-\(E_8\) golden return has a functorial classical shadow.  The
six conjugates of its degree-ten diagonal symbol are exactly the signed
outer-\(S_6\) Joubert coordinates.  They land on the Segre cubic, and their
centered squares are its polar coordinates on the Igusa quartic.

This is stronger than the previously known coordinate identity.  Let \(X\)
be the six-axis set, let \(\mathcal T\) be the outer six-set of synthematic
totals, and let \(A_X\) be the augmentation module.  For \(T\in\mathcal T\),
write \(C_T^2=5I\) for the corresponding oriented conference operator and
\[
 K_T=*\mathbin{\circ}\bigwedge\nolimits^3 C_T.
\]
On the distinguished integral support lattice define
\[
 Z_T(x)=\frac14\sum_{S\in\binom X3}(K_T)_{SS}x_S.
\]
Then
\[
 gZ_T=\operatorname{sgn}(g)Z_{gT},\qquad
 \sum_TZ_T=0,\qquad \sum_TZ_T^3=0.
\]
Thus
\[
 j:\mathbf P(A_X)\dashrightarrow
 \left\{\sum_Tz_T=\sum_Tz_T^3=0\right\}\subset\mathbf P^5
\]
is the classical Joubert map to the Segre cubic, now lifted through the
paired-\(E_8\) return.

The polar map is
\[
 W_T=Z_T^2-\frac16\sum_UZ_U^2.
\]
It removes the sign twist, is outer-\(S_6\)-equivariant, and satisfies
\[
 \sum_TW_T=0,\qquad
 \left(\sum_TW_T^2\right)^2=4\sum_TW_T^4,
\]
the Igusa quartic equation.  If \(q_T\) denotes the five matching
quadratics in the synthematic total \(T\), centered into its
five-dimensional permutation module, the exact remaining face of the
diagram is
\[
 \boxed{\quad
 125\,\operatorname{center}_T(Z_T^2)
 =4\,\operatorname{center}_T\bigl(\sigma_3(q_T)\bigr).
 \quad}
\]

The commuting diagram is therefore
\[
\begin{array}{ccc}
(\widehat\Delta,J)\text{ on the paired }E_8\text{ towers}
&\longrightarrow& (C_T,K_T)_{T\in\mathcal T}\\
&&\downarrow\ \frac14\operatorname{diag}\\
&& (Z_T)_T\in\operatorname{Segre}\\
&&\downarrow\ \operatorname{polar}\\
(q_T)_T\longrightarrow
\operatorname{center}_T(\sigma_3(q_T))
&=&125W/4\in\operatorname{Igusa}.
\end{array}
\]
Every arrow is intrinsic to the outer six-set, the oriented golden
operator, or polarization.  Reversing the golden orientation negates all
\(Z_T\) simultaneously and leaves \(W\) fixed.  There is no coordinate-only
identification hidden in the statement.

The hyperplane \(z_T=0\) cuts the Segre cubic by
\[
 \sum_{U\ne T}z_U=\sum_{U\ne T}z_U^3=0,
\]
the diagonal Clebsch cubic surface.  This is the precise sense in which
the Clebsch sister is a distinguished section of the operator-derived
Segre system.

There is a further operator-only form.  If \(D_x=\operatorname{diag}(x)\),
then
\[
 \omega_C(x)=[D_x,C].
\]
Hence
\[
 \boxed{\quad
 \operatorname{Pf}[D_x,C]=4Z_T(x),\qquad
 \det[D_x,C]=16Z_T(x)^2.
 \quad}
\]
The Igusa coordinates are therefore centered determinants:
\[
 W_T=\frac1{16}\operatorname{center}_T\det[D_x,C_T],
\]
and the syntheme identity becomes
\[
 125\,\operatorname{center}_T\det[D_x,C_T]
 =64\,\operatorname{center}_T\bigl(\sigma_3(q_T)\bigr).
\]
On the marked Clebsch chart where C682's normalization is
\(J_0=16\sigma_3^2\) and \(Z_T=\sigma_3\), this identifies Hitchin's
restricted branch sextic with \(\det[D_x,C_T]\).  It is an equality on
that chart, not a claim that the global incidence cover is a determinant
cover.

The basis-free content appears after adjoining \(s=\sqrt5\).  Let
\[
 P_\pm=\frac12\left(I\pm\frac Cs\right),\qquad
 V_\pm=P_\pm V.
\]
In the golden splitting \(V=V_+\oplus V_-\), write
\(B_x=P_-D_xP_+:V_+\to V_-\).  The diagonal blocks of the commutator
vanish and
\[
 [D_x,C]=
 \begin{pmatrix}
 0&-2sB_x^{\mathsf T}\\
 2sB_x&0
 \end{pmatrix}.
\]
Consequently
\[
 \det[D_x,C]=8000\det(B_x)^2,\qquad
 Z_T(x)^2=500\det(B_x)^2.
\]
After choosing the determinant-line orientation,
\[
 \boxed{\quad Z_T(x)=\pm10\sqrt5\,\det(B_x).\quad}
\]
Thus the Clebsch orientation cubic is the determinant of the cross-golden
block of the diagonal algebra.  It measures exactly where multiplication
by \(D_x\) fails to identify the two golden summands.  Golden conjugation
exchanges the summands and reverses the determinant-line orientation.

This also reorganizes two earlier facts.  The six nodes
\([\mathbf1-6e_a]\) are precisely the six rank-one cross-block points;
their commutators have rank two.  And the normalization scalar
\(500=2^2\cdot5^3\) contains only the lattice prime \(2\) and golden
ramification prime \(5\), explaining directly why the cross-Gram primes
\(11,23\) do not occur in this determinant shadow.

The determinant description has a second-order consequence.  Choose the
orientation sign \(\epsilon\) so that
\[
 Z_T=\epsilon\,10\sqrt5\,\det B_x
\]
and put
\[
 Q_x=\epsilon\,10\sqrt5\,\operatorname{adj}(B_x).
\]
Then
\[
 \boxed{\quad B_xQ_x=Q_xB_x=Z_T(x)I_3.\quad}
\]
Thus the paired-\(E_8\) return supplies a \(3\times3\) linear--quadratic
matrix factorization of its six-node cubic threefold.  The cokernel is a
rank-one maximal Cohen--Macaulay module on the cubic away from its
expected nodal defect.

There are correspondingly two kernel incidence varieties:
\[
\widetilde X_+=
\{(x,[v_+]):B_xv_+=0\},\qquad
\widetilde X_-=
\{(x,[v_-]):B_x^{\mathsf T}v_-=0\}.
\]
Over a smooth rank-two point each kernel is one-dimensional.  At each of
the six rank-one nodes the fibre is \(\mathbf P^1\).  Since those
singularities are ordinary nodes, the two incidences are the two
determinantal small resolutions.  Golden conjugation exchanges
\(V_+\) and \(V_-\), transposes the cross block, and hence exchanges the
two resolutions.  This is a categorical operator shadow beyond the
polynomial Segre--Igusa diagram; it does not identify either resolution
with a previously named global moduli space.

## Why the construction is functorial

For the frozen conference matrix \(C\),
\[
 C^2=5I,\qquad K=*\bigwedge\nolimits^3C,\qquad K^2=125I,
\]
and
\[
 K_{SS}=4C_{ij}C_{jk}C_{ki}\quad(S=\{i,j,k\}).
\]
Modulo \(2\), the odd entries of \(K\) recover the intersection-one graph
on the twenty triples, hence the full Johnson support scheme and its
complementation.  The diagonal is consequently read only after the
operator has recovered its own support lattice.

The \(S_6\)-orbit has six oriented shadows.  The stabilizer of one
synthematic total acts on its cubic by the sign character, so the coherent
orbit satisfies
\[
 gZ_T=\operatorname{sgn}(g)Z_{gT}.
\]
The resulting action on \(\mathcal T\) is faithful of order \(720\).
This is exactly the signed outer-standard representation identified in
the classical literature.  Squaring is the canonical passage from the
signed outer module to the ordinary outer module, and differentiating
\(\sum z_T^3\) gives the same centered-square map.  Hence operator descent,
outer covariance, and projective polarity are one construction.

## Cartan cubic branch

The Cartan gate is positive and literal.  Put
\[
 \omega_C(x)_{ij}=C_{ij}(x_i-x_j).
\]
This skew form kills the constant line, so it gives a linear map
\[
 A_X\longrightarrow\bigwedge\nolimits^2\mathbf Q^6.
\]
On the \(A_1\times A_5\) model
\[
 (A\otimes U^\vee)\oplus\bigwedge\nolimits^2U
\]
of the minuscule \(27\), restrict the Cartan cubic
\[
 \mathcal C(a,b,\omega)=\omega(a,b)+\operatorname{Pf}(\omega)
\]
to \((0,0,\omega_C(x))\).  Exact expansion gives
\[
 \boxed{\quad
 \operatorname{Pf}\bigl(C_{ij}(x_i-x_j)\bigr)=4Z_T(x).
 \quad}
\]
Equivalently, this is the Pfaffian of the infinitesimal diagonal-conjugacy
direction \([D_x,C]\).  Squaring gives the determinant branch formula
above.
Thus the operator Clebsch cubic is a Pfaffian linear section of the Cartan
\(E_6\) cubic.  Compatibility with the degree-ten return is built in:
the embedding itself uses the conference operator reconstructed from that
return.  This goes beyond C695/C697's equality of the \(30+15\) monomial
support, while making no claim that binary-polyhedral \(E_8\) and Lie
\(E_6\) are the same exceptional structure.

## Bounded census of later \(E_8\) slices

The census used the exact Kostant generator degrees and invariant degrees
\(12,20\).  In degrees \(10\) through \(50\), the balanced
\(\mathbf3,\mathbf3'\) multiplicities are
\[
\begin{array}{c|l}
m&n\\ \hline
1&10,14,18,20,24,28\\
2&30,34,38,40,44,48\\
3&50.
\end{array}
\]
Degrees \(14,30,50\) represent the three patterns met in the bounded
range.

The result is negative at the functorial-input gate.  Degree \(10\) is
distinguished not merely by multiplicity balance but by its natural
six-axis integral support lattice.  The later abstract paired McKay
modules have no canonical six-atom lattice from which a diagonal symbol
or support scheme can be recovered.  Starting at multiplicity two, the
additional \(\operatorname{GL}_m\) commutant makes a chosen diagonal or
determinant pencil still less canonical.  Consequently there is no
intrinsic singular scheme to record for those putative shadows without
adding data not supplied by the paired return.  The sole canonical
degree-ten cubic remains the six-node orientation cubic with outer
\(S_5\) projective symmetry.  The census stops at degree \(50\); it is not
an all-degree nonexistence claim.

## Platonic sister feasibility

Both smaller binary-polyhedral cases pass the requested feasibility gate.

### Tetrahedral / affine \(E_6\)

The relevant conjugate field is
\(\mathbf Q(\zeta_3)\), with trace-zero descent operator \(J^2=-3\).
For the natural binary representation,
\[
 \operatorname{Sym}^3=\mathbf2'\oplus\mathbf2''
\]
is the first balanced conjugate slice.  The conjugate tetrahedral
quartics
\[
 f_\pm=x^4\pm2\sqrt{-3}\,x^2y^2+y^4
\]
are relative invariants.  The second transvectant
\[
 (\,\cdot\,,f_\pm)_2:\operatorname{Sym}^3\to\operatorname{Sym}^3
\]
has rank \(2\) and selects one of the two conjugate binary doublets; its
conjugate selects the other.  This is the minimal separator and supplies
the exact Eisenstein analogue of the first golden projection.

### Octahedral / affine \(E_7\)

The relevant field is \(\mathbf Q(\sqrt2)\), with \(J^2=2\).  The first
balanced slice is
\[
 \operatorname{Sym}^7=\mathbf2_+\oplus\mathbf2_-\oplus\mathbf4,
\]
whose conjugate paired subslice is \(\mathbf2_+\oplus\mathbf2_-\).
For the invariant octavic
\[
 f_8=x^8+14x^4y^4+y^8,
\]
the first-, second-, and third-transvectant ranks on
\(\operatorname{Sym}^7\) are respectively
\[
 8,\ 8,\ 6.
\]
The third transvectant maps to
\(\operatorname{Sym}^9=\mathbf2_+\oplus2\mathbf4\), so its two-dimensional
kernel is exactly \(\mathbf2_-\); the conjugate tower reverses the roles.
It is therefore the minimal octahedral separator.

These are feasibility results only.  They do not classify tetrahedral or
octahedral sisters, integral lattices, nonlinear shadows, or singular
schemes.  Any such classification requires a separately allocated task.

## Arithmetic fibres

- At \(2\), the companion and six-axis golden lattices differ by
  \((\mathbf Z/2)^2\).  The operator \(K\bmod2\) still reconstructs the
  Johnson support scheme, but orientation signs coalesce and the
  centered-square polar formula must be kept in its integral
  denominator-free form.  This is a degeneration, not a second Igusa
  sheet.
- At \(5\), \(C^2=5I\) becomes square-zero while the companion comparison
  remains invertible.  In the syntheme formula the five centered
  coordinates coalesce, so the factor \(125\) records the same
  ramification.  The Cartan Pfaffian restriction remains an integral
  identity.
- At \(11\) and \(23\), the conference, middle-exterior, Segre, polar, and
  Cartan formulas have good integral reduction after using
  denominator-free centered coordinates.  The known defects there belong
  to the cross-Gram scalar image: split conductor \(11\) and inert
  conductor \(23\).  They produce no extra Segre--Igusa configuration in
  this operator model.  Normalizing that scalar image must not be
  confused with normalizing the golden operator itself.

## Literature audit and disposition

The audit consulted five modern primary works: one at `full text` and four
at `partial` depth.  Joubert's 1867 and Coble's 1911 originals were not
accessed and are treated as `secondary only`.  No novelty or priority
claim is made.

- Benjamin Howard, John Millson, Andrew Snowden, Ravi Vakil,
  *A description of the outer automorphism of \(S_6\), and the invariants
  of six points in projective space*, arXiv:0710.5916v1 — `full text`,
  all eight pages read from cached PDF
  `arXiv:0710.5916`, SHA-256
  `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`.
  It gives the triangle-coloring/icosahedron/pentad models, the signed
  outer Joubert coordinates, the Segre relations, the Igusa equation, and
  the centered-square dual map.
- Hanspeter Kraft, *A Result of Hermite and Equations of Degree 5 and 6*,
  arXiv:math/0403323v2 — `partial`, introduction, §2, and §5 read from
  cached PDF `arXiv:math/0403323`, SHA-256
  `969440e0bedbc70fa9c2d97720407c9d7da821179aa5141b75b050a3c79afbec`.
  It proves that the signed outer cubic covariant is the lowest-degree
  one and reconstructs Joubert's squarefree signed cubic explicitly.
- Howard--Millson--Snowden--Vakil, *The relations among invariants of
  points on the projective line*, arXiv:0906.2437v1 — `partial`,
  introduction and the complete six-point discussion read from cached PDF
  `arXiv:0906.2437`, SHA-256
  `dfbdb89c3061b5987f59602a55d5eb40c7c29eab18f9203c0e43c6f765d37508`.
  It records the Joubert--Coble provenance and the Segre/Igusa/Gale
  diagram.
- Igor Dolgachev, *Abstract configurations in algebraic geometry*,
  arXiv:math/0304258v1 — `partial`, §§9.1--9.6 read from cached PDF
  `arXiv:math/0304258`, SHA-256
  `6e8c248e7de2220c55ce0d0437fa66823b6e5c86ddfb5a928ff16683f5391b10`.
  It treats the Cremona--Richmond configuration, Segre cubic, its cubic
  surface hyperplane sections, and the dual Segre/Igusa quartic.
- Shigeyuki Kondō, *The Segre cubic and Borcherds products*,
  arXiv:1110.1126v1 — `partial`, §§1--2 and §§6.6--6.8 read from cached PDF
  `arXiv:1110.1126`, SHA-256
  `0595df2ed7631ba366b1603aca9a924ef08cb93cdc84b906f2877b68c777e9be`.
  It realizes the classical polar map by a five-dimensional automorphic
  linear system and confirms that the Segre--Igusa duality is not new.
- Joubert's 1867 construction — `secondary only` through Kraft
  (`partial` as above) and HMSV 0906.2437 (`partial` as above).
- Coble's 1911 invariant-theoretic interpretation — `secondary only`
  through HMSV 0906.2437 (`partial` as above).  The original text was not
  obtained, so no formula-level claim is attributed directly to it.

The classical content is the outer cubic covariant, Segre equations,
centered-square polarity, Igusa equation, and cubic-surface sections.
The task-owned content beyond that package is:

1. the lift \(Z_T=\frac14\operatorname{diag}(*\Lambda^3C_T)\) from the
   all-degree paired-\(E_8\) return;
2. the intrinsic sign-twisted commuting diagram with the five-syntheme
   Clebsch expression; and
3. the literal Cartan restriction and commutator branch determinant
   \[
   \operatorname{Pf}[D_x,C_T]=4Z_T(x),\qquad
   \det[D_x,C_T]=16Z_T(x)^2.
   \]

These statements were not sought as publication-priority claims, and the
audit does not license one.  The recommended disposition is to retain the
result as a paper-independent research theorem.  It does not reopen Papers
I--III.  A future note would need a dedicated formula-level and
operator/invariant-theory priority audit, plus a consequence not already
implied by classical Segre--Igusa duality.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-30-c704-segre-igusa-operator-shadow.py --check
python3 ../notes/2026-07-30-c704-segre-igusa-operator-shadow-replay.py
```

The primary checker uses only the Python standard library.  It rebuilds
the conference and middle-exterior operators, the six signed outer
shadows and all \(720\) induced actions, the Segre relations, the exact
five-variable eliminated polynomial identity, the Cartan Pfaffian
restriction, the bounded Kostant census, and the tetrahedral/octahedral
selection ranks.  The canonical JSON output is stable and contains no
timestamps or host paths.

The independent replay does not import the primary checker.  Over
\(\mathbf F_{101}\), it checks all \(7^5=16807\) interpolation points;
individual variable degree is at most six, so this is an exact polynomial
identity check in that characteristic.  It separately checks the
tetrahedral rank over \(\mathbf F_{13}\) and the octahedral ranks over
\(\mathbf F_{101}\).  This corroborates rather than replaces the exact
characteristic-zero proof.

`2026-07-30-c704-functorial-operator-shadows.sha256` records the hashes
of the report and all three computational artifacts.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-30-c704-segre-igusa-operator-shadow.py` | 19020 | `f551fb63b4c34ccac88e81ee129ba429d670b6768a3b764ee34c1d9617cd0f66` |
| `2026-07-30-c704-segre-igusa-operator-shadow-replay.py` | 6043 | `833ffc6c224f269ca6a31329656a6b23db58d976a7376a4c15d49dd79902db6f` |
| `2026-07-30-c704-segre-igusa-operator-shadow.json` | 4001 | `540e5db96938d64aac597f19bd193b296453e575d264d9258a6e695b7e01774d` |

## `ej` + `tt` closeout and mystery ledger

- **Settled by `ej`:** the operator does not merely recover one Clebsch
  cubic.  Its six outer conjugates satisfy the Segre equations, and
  polarity is exactly centered squaring.
- **Settled by `tt`:** the sign twist is essential.  The Joubert carrier
  is the signed outer-standard module; polarity removes the twist.  This
  explains functorial compatibility without choosing six unrelated
  coordinate formulas.
- **Settled by `ej`:** the Cartan comparison is a literal Pfaffian
  restriction using the same conference operator, not only equality of
  minuscule monomial support.
- **Settled by the post-close `ej`:** the Pfaffian matrix is canonically
  the commutator \([D_x,C]\).  Its determinant is the squared orientation
  coordinate, so the Segre cubic, the restricted Hitchin branch sextic,
  and the Igusa polar coordinates are respectively Pfaffian, determinant,
  and centered-determinant shadows of the same golden return.
- **Settled by the post-close `tt`:** over the golden field the
  commutator is purely off-diagonal, and the cubic is the determinant of
  \(P_-D_xP_+\) as a map between the two three-dimensional golden
  eigenspaces.  The six nodes become rank-one cross-block degeneracies,
  and the scalar \(500=2^2\cdot5^3\) isolates the exact arithmetic
  normalization primes.
- **Open, high-value but not allocated:** determine whether the adjugate
  of \(P_-D_xP_+\), assembled over the six outer conjugates, gives the
  Segre--Igusa polar map directly as a quadratic-minor construction.  The
  present centered-determinant formula strongly suggests this, but no
  commuting adjugate diagram has been proved.
- **Settled by `ej2`:** the same adjugate already gives a
  linear--quadratic matrix factorization of the six-node cubic.  Its left-
  and right-kernel incidences are the two determinantal small resolutions,
  and golden conjugation exchanges them.
- **Open second-order bridge:** compare these two small resolutions with
  the normalized two-parent incidence geometry and with the
  operator-derived double-six.  Dimensions and involutions now match the
  right pattern, but no map to either existing geometric construction has
  been built.
- **Settled negatively:** later balanced \(E_8\) slices do not inherit the
  degree-ten support lattice functorially.  The bounded census stops at
  degree \(50\); an added geometric lattice could change this verdict.
- **Settled as feasibility:** affine \(E_6\) and \(E_7\) have exact first
  conjugate separators, respectively a rank-two second transvectant on
  degree three and a rank-six third transvectant on degree seven.
- **Open only behind allocation:** determine the integral conference-like
  lattices and nonlinear determinant shadows of the tetrahedral and
  octahedral pairs.  The present task does not establish that their first
  separators produce distinguished classical varieties.
- **No unexplained feature remains inside the primary Segre--Igusa gate.**
  The remaining uncertainty is publication priority and the geometry of
  separately gated sister classifications, not the commuting diagram.

**Vibe check:** this is a strong positive close.  The primary functorial
question and the Cartan restriction both resolve exactly; the risky
classical content is cleanly separated from the genuinely operator-level
lift, and the sister branches end at useful, disciplined feasibility
gates rather than expanding into another open-ended programme.
