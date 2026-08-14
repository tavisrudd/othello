# C907 — quantum Kirwan common source and the localized point-row gate

Date: 2026-08-14

**Status:** exact formal reduction, not an `X x P^2` irrationality proof.  Two
pieces that were previously charged to a full intermediate-quotient Fourier
conjecture can be separated.  First, the adjoint discrete Fourier formula has a
chamber-independent scalar augmentation, so the point/rank row is already
common on every input on which the formula is defined.  Second, for smooth free
quotients, the linearized quantum Kirwan map is formally surjective by a
classical-Kirwan plus Neumann-series argument.  These facts combine with a
finite-module Boolean lemma: two surjective, equally shifted monodromy maps with
one common source row carry the same primitive-sixth rank Boolean.

This can bypass full Gu--Yu--Yu Conjecture 1.11 / Iritani Conjecture 43.  The
remaining geometric input is nevertheless new and load-bearing: a **localized
quantum-Kalkman point-row theorem** identifying the two chamber pullbacks of the
Gamma point row in one localized gauged solution object.  Gonzalez--Woodward's
published quantum Kalkman formula treats graph potentials.  Their Remark
1.18(b) explicitly leaves its extension to localized graph potentials, hence
fundamental solutions, for future work.  Nothing below silently fills that
gap.

## 1. The adjoint augmentation lemma

Let `W` be a master space with a torus action, and let `X` be a smooth GIT
quotient.  Gu--Yu--Yu's discrete transform is

\[
 \mathcal F_X(f)=\sum_{k\in\mathbf Z}S^{-k}
                  \kappa_X(\mathbb S^k f),                    \tag{1}
\]

whenever the shifted restrictions are regular and the support condition makes
the series meaningful.  Let

\[
 \epsilon_X:H^*(X)\longrightarrow\mathbf C                 \tag{2}
\]

be projection to `H^0(X)`.  Equivalently, under the Poincare pairing it is the
row represented by the point class.  Let `epsilon_W` be projection to the
constant cohomological and equivariant degree.  Since the classical Kirwan map
is graded and unital,

\[
 \epsilon_X\kappa_X=\epsilon_W.                              \tag{3}
\]

Consequently

\[
 \epsilon_X\mathcal F_X(f)
   =\sum_{k\in\mathbf Z}S^{-k}\epsilon_W(\mathbb S^k f).      \tag{4}
\]

The right side is the same universal scalar Fourier series in every chamber;
only its expansion cone and analytic continuation change.  Formula (4) is an
exact adjoint identity and requires no assertion that `F_X(f)` lies on the
whole quotient Givental cone.  It applies only on the common domain where the
terms and scalar sum are defined.

For a smooth `d`-fold, the Gamma flat section of a point is a fixed scalar
multiple of the cohomological point: `Gamma-hat` and `z^rho` act trivially on
top degree.  With Iritani's pairing convention, the rank row is point in the
second slot,

\[
 [s(E),s(\mathcal O_p))=\chi(E,\mathcal O_p)=\operatorname{rk}E. \tag{5}
\]

Thus (4), after the fixed dimension-dependent `z` normalization, is precisely
the adjoint Gamma point/rank row.  This closes the **point-row half** of the
common-kernel problem for common equivariant inputs.  It does not prove that a
chosen primitive-sixth vector of every quotient lifts to such an input.

## 2. Formal surjectivity at a smooth quotient

Let `A` be a complete nonnegative-energy Novikov algebra with augmentation
ideal `m`, and suppose the stable locus equals the semistable locus and the
quotient `Y` is smooth with free stabilizers.  Fix a bulk point `tau` in `m`
and write

\[
 A_\tau=D_\tau\kappa^G_W:
     H_G^*(W)\widehat\otimes A\longrightarrow
     H^*(Y)\widehat\otimes A.                                 \tag{6}
\]

The zero-energy reduction of (6) is the derivative of classical Kirwan, hence
is surjective.  Choose a linear section `s_0` of that reduction and lift it to
an `A`-linear map `s`.  Then

\[
 A_\tau s=1+N,\qquad N\in m\operatorname{End}_A(H^*(Y)\widehat\otimes A).
                                                                    \tag{7}
\]

Completeness makes `sum_{j>=0}(-N)^j` converge `m`-adically, so

\[
 s(1+N)^{-1}                                                   \tag{8}
\]

is a right inverse.  Therefore `A_tau` is formally surjective.

This is a derived smooth-endpoint lemma, not Woodward's general quantum Kirwan
surjectivity conjecture.  The latter includes orbifold quotients and is stated
as conjectural in Remark 8.10(a) of Part III.  The proof above also uses the
nonnegative-energy completion; it is not a statement after arbitrary Novikov
inversion.

Woodward's CohFT-morphism theorem says that `kappa` is a formal star-morphism,
and its derivative preserves the quantum products at corresponding bulk
points.  It does **not** by itself say that `Dkappa` is horizontal in every
bulk direction: differentiating it produces a `D^2 kappa` term.  The present
route uses (6) only at a fixed bulk for the `z`-formal packet.

## 3. Rees homogenization and the equally shifted packet lemma

The next statement isolates the exact homogeneity input still to be verified
for the intended quantum Kirwan receiver.

Let `M` and `M_i` be finite meromorphic `z`-modules and let

\[
 A_i:M\twoheadrightarrow M_i                                  \tag{9}
\]

be surjective.  Suppose there is one scalar `a` such that

\[
 T_iA_i=A_i(T+a)                                               \tag{10}
\]

for their formal monodromy logarithms, or equivalently that the corresponding
formal monodromies intertwine up to the same scalar character.  For any target
eigenvalue `lambda`, primary decomposition gives

\[
 A_i\bigl(P_{\lambda-a}(M)\bigr)=P_\lambda(M_i).               \tag{11}
\]

Indeed, a polynomial Bezout projector onto the generalized `lambda-a`
eigenspace commutes with (9); applying it to an arbitrary lift of a target
generalized eigenvector proves surjectivity in (11).

The raw linearized quantum Kirwan map does **not** satisfy (10) merely because
it is graded.  Let the group have complex dimension `g`, and give `Q^d` total
degree `2 c_1^G(TW).d`.  If `A=Dkappa` preserves total degree, comparison of
the two grading operators gives

\[
 \mu_YA-A\mu_W=\tfrac g2A-\Theta_QA,                          \tag{12a}
\]

where `Theta_Q(Q^d)=c_1^G(TW).d Q^d`.  Indeed, on a coefficient carrying a
source class of degree `p` to a target class of degree `q`, total homogeneity
says `p=q+2c_1.d`; substituting the definitions of `mu_W` and `mu_Y` gives
(12a).  Omitting `Theta_Q` would be another illegal fixed-parameter frame
change.

Rees-homogenize the map by

\[
 A^{\rm h}(z,Q)=\sum_d z^{c_1.d}Q^d A_d.                      \tag{12b}
\]

On a ramified `z`-cover if necessary,

\[
 z\partial_zA^{\rm h}+\mu_YA^{\rm h}-A^{\rm h}\mu_W
   =\tfrac g2A^{\rm h}.                                       \tag{12c}
\]

If the star-morphism and Euler-homogeneity identities also give

\[
 E_Y\star A^{\rm h}=A^{\rm h}(E_W\star-),                    \tag{12d}
\]

then (12c)--(12d) intertwine the two `z`-connections up to the uniform
`g/2` Tate shift.  Thus (10)--(11) apply to `A^h`; for a `C*` quotient the
shift is exactly `1/2`.

The total-degree part of this calculation is the virtual-dimension axiom, and
the equality of first Chern classes on the stable locus follows from the
quotient tangent sequence.  The remaining application check is (12d) in the
curved receiver conventions.  In particular, `kappa(0)` need not be zero.
The target module must first be taken at bulk `kappa(0)` and only then compared
with the small-bulk module by formal bulk isomonodromy.

## 4. Common-source Boolean theorem

Let the hypotheses of Section 3 hold with the same shift for `i=1,2`.  Let
`r_i:M_i->K` be scalar rows and suppose

\[
 r_1A_1=\rho=r_2A_2                                             \tag{13}
\]

for one row on `M`.  Then

\[
 r_1|_{P_\lambda(M_1)}\ne0
 \quad\Longleftrightarrow\quad
 r_2|_{P_\lambda(M_2)}\ne0.                                   \tag{14}
\]

### Proof

Choose `v_1` in the first target packet with `r_1(v_1) != 0`.  By (11), lift
it to `v` in `P_{lambda-a}(M)`.  Then `rho(v) != 0`.  Equation (13) gives
`r_2(A_2v)=rho(v)`, so `A_2v` is nonzero, lies in the second target packet,
and is detected by `r_2`.  The reverse implication is symmetric.  \(\square\)

If the equivariant source is infinite, replace it by

\[
 M/(\ker A_1\cap\ker A_2).                                    \tag{15}
\]

When the kernels are monodromy-stable, (15) embeds in
`M_1 \mathbin{\oplus} M_2` and is finite.  Thus the theorem needs no global
finite-rank presentation of equivariant quantum cohomology.

For C907 take `lambda=zeta_6`, `r_i` the Gamma rank rows, and `A_i` the
linearized quantum Kirwan receivers.  Sections 1--4 show that the global
telescope would follow from one common-source equality (13), plus the
Rees-homogenized Euler-intertwining check (12d).  No comparison of the two
chamber large-radius coefficient rings is involved.

## 5. What Woodward supplies, and what is missing

Woodward's localized adiabatic limit identifies the quotient localized graph
solution after quantum Kirwan with the localized gauged solution.  In the
notation around equation (68) of Part III, its schematic form is

\[
 \tau_{Y,-}\circ\kappa_W^G=\tau^G_{W,-}.                       \tag{16}
\]

This is the correct common receiver: localized graph potentials are
fundamental solutions of the quotient quantum differential equation.  It
places the target point row and the gauged source row in one analytic object,
rather than evaluating an exceptional-cusp series at the large-radius point.

Gonzalez--Woodward's quantum Kalkman formula compares gauged graph potentials
across a variation of polarization.  Their crepant Theorem 1.17 proves an
almost-everywhere equality for graph potentials.  But Remark 1.18(b) says
explicitly that their results are for graph potentials and that extension to
**localized graph potentials (fundamental solutions)** is expected and left
for future work.  Therefore the following is exactly the new theorem needed:

> **Localized quantum-Kalkman point-row theorem.**  Let a smooth projective
> `C*` master cobordism have two adjacent smooth free quotient chambers.  In
> the localized gauged solution object, the pullbacks of their Gamma
> point/rank rows agree.  At a discrepant wall, finite positive-`c_1` terms are
> supported window corrections; on every `c_1`-neutral tower, the complete
> fixed-stratum residue is the grade-restricted Gamma correction.

The distinction is not cosmetic.  Virtual localization factorizes the scalar
graph potential as a pairing of the two localized solutions; schematically,

\[
 \tau^{\rm graph}=S_-^{\mathsf T}JS_+.                         \tag{17}
\]

For any invertible `G` preserving the relevant pairing convention, replacing
`S_-` by `S_-G` and `S_+` by `G^{-1}S_+` leaves (17) unchanged.  The oriented
point row of either factor can change unless `G` stabilizes it.  The same
ambiguity remains after polarizing the graph potential and taking all of its
derivatives: these recover the trace tensors, not a canonical factorization.
Thus Theorem 1.13 or 1.17 cannot by itself imply the desired point-row
identity.  Remark 1.18(b) marks a logically necessary refinement, exactly as
the earlier receiver countermodels predict.

Only the single adjoint row is asserted, not equality of fundamental
solutions or of Givental cones.  The discrete augmentation formula (4) is its
degree-zero algebraic shadow.  The parameterized Calabi--Yau contour theorem
in `2026-08-14-c907-neutral-slice-gamma-kernel.md` supplies the analytic sum of
every neutral residue **after** virtual localization has placed it in the
common localized kernel.  It does not construct that localized wall formula.

A promising proof is to retain the auxiliary rotation of the graph `P^1`
through the master-space virtual localization used in the quantum Kalkman
formula.  Taking the coefficient paired with the point row should reduce each
fixed term to the scalar shift sum in (4).  Positive-anticanonical terms are
locally finite.  Neutral terms have restricted weights summing to zero and are
then summed by the parameterized contour lemma.  The hostile check is whether
the virtual normal Euler class and node-smoothing factors reproduce the same
Gamma kernel, rather than an incomplete residue.  That check is the theorem,
not bookkeeping to suppress.

### A stronger support-collapse candidate

There is a route that may eliminate the fixed terms before any contour sum.
Choose the point in the common stable open of the two adjacent chambers, and
let `a_p` be an equivariant common-open lift of its point class with

\[
 a_p|_{W^\zeta}=0                                             \tag{18}
\]

for every wall one-parameter subgroup.  Such a lift is the same zero-wall
class used in the simple-VGIT point-column theorem; geometrically its cycle is
disjoint from the wall fixed locus.

Run the quantum Kalkman master-space localization equivariantly for the
commuting rotation of the graph `P^1`, and pair the output of the localized
graph potential with `a_p`.  On a graph-space fixed locus, the output
evaluation in `tau_-` is evaluation at the node joining the bubble to the
principal parametrized component.  On a polarization-wall fixed stratum that
principal component maps to `W^zeta/G_zeta`.  Continuity therefore makes the
output evaluation factor through `W^zeta`, and (18) kills the entire virtual
fixed contribution, including its normal Euler class and all neutral towers.
The two endpoint contributions are exactly the two localized point rows.

The support assertion is already in the primary source.  Gonzalez--Woodward
Proposition 3.15(c) says that **every node or marking** of a
polarization-fixed gauged map lands in the fixed point set; Lemma 3.17 and
Proposition 3.18 say that the principal component maps to
`W^zeta/G_zeta`.  Thus no wall-fixed graph can evade (18) by moving the
output onto a bubble.  What is not in the source is the auxiliary-rotation
enhancement that turns this support fact into an identity of localized
endpoint rows.

This proves the localized point-row theorem provided the following formal
enhancement of Gonzalez--Woodward's construction is written down:

> **Commuting-rotation enhancement.**  The virtual Kalkman localization
> identity remains valid in the equivariant Chow/cohomology ring for the
> auxiliary `C*` rotating `P^1`, with the distinguished output node retained;
> localizing in that auxiliary parameter gives Woodward's `tau_-` endpoint
> terms.

This enhancement changes neither the moduli spaces nor their perfect
obstruction theories: the auxiliary action commutes with the polarization
torus, and virtual localization is coefficient-linear in the output insertion.
It is therefore substantially smaller than a general fundamental-solution
wall theorem.  It is not stated in the cited papers, and the identification of
the endpoint conventions with `tau_-` must be checked rather than inferred
from the scalar graph formula.  The decisive falsifier is equally concrete:
find a wall-fixed graph stratum whose distinguished output evaluation does
not factor through the wall fixed locus.  Standard graph-space fixed-locus
geometry predicts that no such stratum exists, and Proposition 3.15(c) rules
it out in the published fixed-stack geometry.  A separate per-wall input is
the existence of the lift `a_p` with (18); it is proved for the smooth simple
VGIT walls used by C907, but should not be inferred for an arbitrary singular
intermediate quotient.

## 6. Conditional application to `X x P^2`

Assume:

1. one smooth projective equivariant cobordism supplies common gauged source
   objects for the two smooth endpoint chambers, or the localized theorem is
   functorial through a finite cobordism decomposition;
2. the smooth endpoint linearized quantum Kirwan maps are homogeneous in the
   Rees sense of (10)--(12d) and formally surjective;
3. the localized quantum-Kalkman point-row theorem holds at every intervening
   wall.

Then (13) holds between consecutive chambers.  The Boolean theorem transports
nonvanishing of the primitive-sixth Gamma rank row from `X x P^2` to the final
projective chamber.  The existing endpoint computation gives a rank-visible
length-three primitive-sixth packet on `X x P^2` and none on `P^5`, a
contradiction.  Thus these three assumptions imply irrationality of
`X x P^2`.

This is not yet unconditional for two separate reasons.  First, the localized
point-row wall theorem is absent from the literature.  Second, the smooth
projective cobordism theorem gives a smooth master before chamber quotient,
while intermediate coarse quotients can have cyclic singularities; resolving
them materializes extra walls.  The common-source formulation avoids needing
quantum Kirwan surjectivity for those singular intermediate quotients, but a
functorial localized source through the chosen resolution still has to be
recorded.

## 7. EJ / TT / AA

- **EJ:** telescope the primitive-sixth **Boolean through one source**, not a
  vector through incompatible chamber completions.  Surjectivity plus a common
  row is enough; full cone preservation is not.
- **TT:** a CohFT star-morphism is not automatically a horizontal QDM map,
  quantum Kirwan surjectivity is conjectural in the orbifold generality, and
  the published Kalkman theorem is not localized.  These are three distinct
  seams.
- **AA:** prove the localized theorem only after pairing with the point row.
  Its scalar fixed-locus sum has the exact augmentation identity (4), while
  the neutral nonpolynomial tail is already controlled by the Gamma contour
  lemma.  A direct counterexample would be a smooth master wall whose complete
  localized point residue has nonzero common-open rank.

## 8. Mystery ledger

### Closed

- The adjoint discrete Fourier transform of the point row is one universal
  scalar shift sum on every common input.
- Smooth-endpoint formal surjectivity follows from classical Kirwan after
  positive-energy completion; no general surjectivity conjecture is needed
  there.
- Given equally shifted monodromy maps and the common source row, the
  primitive-sixth rank Boolean is chamber-independent by elementary primary
  decomposition.

### Open

- **Localized point-row wall formula.**  Extend quantum Kalkman virtual
  localization to the single localized graph coefficient measured by the
  point row, including the neutral complete residue.  Equality of the scalar
  graph trace is insufficient because of the factorization shear (17).  The
  strongest candidate proof is the commuting-rotation enhancement above:
  every wall term should vanish by the zero restriction (18).
- **Homogeneous packet map.**  The `mu`/Novikov-Euler correction and uniform
  half-Tate shift are the exact Rees identities (12a)--(12c).  Check Euler
  multiplication (12d), curvature, and bulk isomonodromy in the localized
  receiver conventions.
- **Global source coherence.**  Put the endpoint maps in one equivariant
  source, or prove functoriality through the pi-desingularized cobordism.

The first item is the highest-value next proof attempt.  If it fails, the
failure term is itself the sought dangerous object: a localized fixed-stratum
residue with nonzero point augmentation despite zero rank of every complete
window correction.

## Sources

- Chris T. Woodward, *Quantum Kirwan morphism and Gromov--Witten invariants
  of quotients I*, arXiv:1204.1765v9, Theorem 1.3 and the CohFT-algebra
  morphism formalism; cached PDF SHA-256
  `ebaaeaca4149ea5e44884efab02a7ed58c7be552d9572e6513b3b2f40158b5ef`.
- Chris T. Woodward, *Quantum Kirwan morphism and Gromov--Witten invariants
  of quotients III*, arXiv:1408.5869v7, Remark 8.10(a), Section 9, and the
  localized adiabatic limit around equation (68); cached PDF SHA-256
  `5aa794f4d83dd8d127aab769d95a71a4691d7a35d220e81ca73c5b8bb360ea51`.
- Eduardo Gonzalez and Chris T. Woodward, *A wall-crossing formula for
  Gromov--Witten invariants under variation of GIT quotient*,
  arXiv:1208.1727v7, Theorems 1.13 and 1.17, Proposition 3.15(c), and Remark
  1.18(b); cached PDF
  SHA-256
  `2c99203c8e1d7dd373112629bbfac0760e7a3812d348e9110a1eb2b894d9d84c`.
- Zhaoxing Gu, Song Yu, and Tony Yue Yu, *Quantum cohomology of variations
  of GIT quotients and flips*, arXiv:2508.15770v1, Definition 4.13 and
  Proposition 4.14; cached PDF SHA-256
  `9c00f826cb13ad243bd2ad126e74733cacf650a385160a11adc785693c01a358`.
