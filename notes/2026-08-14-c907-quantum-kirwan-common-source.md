# C907 — quantum Kirwan common source and the localized point-row gate

Date: 2026-08-14

**Status:** theorem-grade wall-local reduction, not yet an `X x P^2`
irrationality proof.  Three pieces previously charged to a full
intermediate-quotient Fourier conjecture are now separated and proved.  The
adjoint discrete Fourier formula has a chamber-independent scalar
augmentation.  At a smooth free quotient, linearized quantum Kirwan is
formally surjective and, after the necessary Rees homogenization, intertwines
the formal packet with one uniform half-Tate shift.  Finally, a
component-selective refinement of quantum Kalkman localization proves equality
of the two oriented localized point rows: pole classes put all inputs on one
side, a Liouville character extracts zero degree on the other, and the
common-open point lift kills every wall-fixed term by
Gonzalez--Woodward Proposition 3.15(c).

These facts combine with a finite-module Boolean lemma: two surjective,
equally shifted monodromy maps with one common source row carry the same
primitive-sixth rank Boolean.  This bypasses full Gu--Yu--Yu Conjecture 1.11 /
Iritani Conjecture 43.  The remaining application audit is global: realize the
two endpoint packet maps in one common coefficient/fiber category at each wall
and verify that the resulting intrinsic Boolean composes through the selected
pi-desingularized chain.  Nothing below claims that audit has already passed.

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

That application check is also formal.  Give the source and target big quantum
spaces their total Euler fields `E_W` and `E_Y`.  The virtual-dimension formula
for each affine-gauged coefficient of `kappa` gives the termwise homogeneity
identity

\[
 D\kappa(E_W)=E_Y\circ\kappa.                                 \tag{12e}
\]

At the source origin, with `A=D_0kappa`, equation (12e) says

\[
 A(c_1^G(TW))=E_Y(\kappa(0)).                                 \tag{12f}
\]

Because `A` is an algebra map from the source product at zero to the target
product at `kappa(0)`, equation (12f) implies (12d).  Thus the
Rees-homogenized map really is a shifted `z`-connection morphism.  Finally,
`kappa(0)` has positive Novikov energy.  On every Artin quotient, flatness of
the big quantum connection gives unique parallel transport along
`s kappa(0)`, `0<=s<=1`; the compatible inverse limit conjugates formal
monodromy and transports the Gamma point row.  Hence the primitive-sixth rank
Boolean at the curved target point is the intrinsic small-point Boolean.

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

### Support-collapse theorem for the localized point row

The fixed terms can in fact be eliminated before any contour sum, provided
the wall has the common-open point lift already constructed for the smooth
simple-VGIT theorem.

> **Theorem (commuting-rotation point row).**  Let `W` be a smooth projective
> master with two adjacent smooth free quotient chambers `Y_-` and `Y_+`.
> Assume that a common equivariant class `a_p` restricts to the point class in
> both chambers and to zero on every polarization-wall fixed locus.  Then,
> after the usual quantum-Kirwan change of variables and on the common
> localized graph receiver,
> \[
>  \langle [p],\tau_{Y_-,-}(\kappa_-(\alpha))\rangle
>   =
>  \langle [p],\tau_{Y_+,-}(\kappa_+(\alpha))\rangle .          \tag{18}
> \]
> The equality holds coefficientwise in the remaining Novikov and bulk
> variables.  Its derivatives give equality of the full oriented point row,
> not merely of the scalar graph trace.

### Proof

Choose the point in the common stable open of the two adjacent chambers, and
let `a_p` be an equivariant common-open lift of its point class with

\[
 a_p|_{W^\lambda}=0                                           \tag{19}
\]

for every wall one-parameter subgroup.  Such a lift is the same zero-wall
class used in the simple-VGIT point-column theorem; geometrically its cycle is
disjoint from the wall fixed locus.

Take the graph curve to be `P^1` and retain its commuting rotation torus, with
equivariant parameter `hbar`.  The perfect obstruction theory and the
polarization master space are rotation-equivariant: rotation acts on the
domain and commutes with the group acting on `W`.  Hence the virtual Kalkman
localization identity holds over `Q(hbar)`, with the insertion obtained by
evaluating `a_p` on the parametrized component at `0 in P^1`.

Two standard decorations isolate one oriented localized factor rather than
only their product.

1. For each ordinary input marking, insert the normalized equivariant point
   class of `0 in P^1` through its projection to the parametrized curve.  In
   rotation localization this class is one at the zero pole and zero at the
   infinity pole, so every input lies on the zero-side bubble tree.
2. Choose common equivariant divisor classes `D_1,...,D_r` whose Kirwan
   restrictions span `H^2` of both chambers, and insert the product of
   Woodward Liouville classes with formal parameters `t_j`.  Lemma 9.3
   restricts it on a graph fixed locus to
   \[
    \exp\!\left(\sum_jt_jD_j\right)
    \prod_jx_j^{D_j\cdot d_+},\qquad x_j=\exp(t_j\hbar),        \tag{20}
   \]
   where `d_+` is the curve class on the infinity side.  Multiplication by
   the cohomological exponential does not change the top point insertion.
   Classical Kirwan surjectivity in degree two lets the `D_j` be chosen to
   detect the numerical curve lattices of both endpoints.  Therefore the
   zero Laurent character in all `x_j` is exactly the locus `d_+=0`.

   Using the full divisor lattice is essential.  Adjacent birational chambers
   need not have one common ample class; a wall-nef class can vanish on the
   very extremal ray that must be removed.  The multicharacter extraction has
   no positivity assumption and works in the numerical Novikov group algebra.

Apply rotation localization and extract this zero character.  All
ordinary inputs are on the zero side and the infinity side has degree zero,
so the infinity factor is the unstable identity.  The zero-side fixed
contribution is precisely the defining fixed locus
`Mbar_{0,n+1}(Y,d)` of `tau_{Y,-}`, with inverse Euler factor
`-1/(hbar(-hbar-psi))`; evaluation of `a_p` on the parametrized component is
evaluation at its attaching node.  The two endpoint terms of the polarization
master identity are the localized gauged rows.  Woodward's localized
adiabatic limit, equation (68), identifies them with the two sides of (18),
with the same sign and `hbar` convention.

Every nonendpoint polarization-fixed graph contributes zero.  Indeed, its
principal component maps to `W^lambda/G_lambda`, and the attaching-node
evaluation factors through `W^lambda`.  Equation (19) kills the integrand
before division by the virtual normal Euler class.  Thus no positive-degree,
neutral, descendant, or equivariant residue survives.  The endpoint equality
(18) follows.  Since the construction is multilinear in the ordinary inputs,
polarization/differentiation in `alpha` gives the entire row.  \(\square\)

The support assertion is already in the primary source.  Gonzalez--Woodward
Proposition 3.15(c) says that **every node or marking** of a
polarization-fixed gauged map lands in the fixed point set; Lemma 3.17 and
Proposition 3.18 say that the principal component maps to
`W^lambda/G_lambda`.  Thus no wall-fixed graph can evade (19) by moving the
output onto a bubble.  What is not in the source is the auxiliary-rotation
equivariant version and the component extraction, which are derived above
from the same equivariant perfect obstruction theory and Woodward's published
rotation-localization formulas.  A separate per-wall input is the existence
of the lift `a_p` with (19); it is proved for the smooth simple
VGIT walls used by C907, but should not be inferred for an arbitrary singular
intermediate quotient.

The theorem is a special point-row extension, not the full localized
fundamental-solution wall theorem left open in Remark 1.18(b).  Without the
zero-wall restriction (19), the wall fixed contributions remain and the full
problem returns.

## 6. Global-cobordism reduction and the exact remaining gate

Wlodarczyk Proposition 2(B') supplies a smooth projective `C*` cobordism `W`
between any two smooth projective birational endpoints.  In the explicit
construction its extreme opens are punctured line bundles with the standard
weight-one action, so their geometric quotients are the ordinary smooth
endpoints.  The equivariant resolution is unchanged on those opens.

Choose `p` in the common birational open.  Over that open the cobordism is the
trivial cylinder, and the closure of the orbit of `p` joins only the source and
sink copies of `p`.  Its equivariant Poincare dual is a global class `a_p`:

- its two extreme Kirwan restrictions are the two point classes;
- it restricts to zero on every intermediate fixed component.

Therefore the support-collapse theorem applies **once to the global
cobordism**.  All intermediate wall terms vanish, regardless of singularities
of their coarse quotients, and the two endpoint localized point rows pull back
to one gauged row.  Smooth endpoint classical Kirwan surjectivity and Sections
2--4 then reduce endpoint Boolean invariance to a single common-source packet.
No weak-factorization telescope or intermediate quotient QDM is needed.

The remaining gate is purely a coefficient/fiber-category issue.  The two
endpoint quantum Kirwan maps are initially completed in opposite GIT Novikov
cones.  Their common finite-support input is not automatically large enough to
lift a target formal-monodromy packet, while completing in both directions can
destroy the Novikov topology.  The exact needed statement is:

> **Two-sided gauged packet lemma.**  For the smooth projective global
> cobordism `W`, the two Rees-homogenized endpoint linearized quantum Kirwan
> maps admit one finite meromorphic source module over a common differential
> coefficient field, are surjective there, and have the localized common row
> of (18).  Its shifted formal-primary packet maps onto the intrinsic
> primitive-sixth packets of both endpoints.

There is a sharp positive/neutral split.  In a direction on which
`c_1^G(TW)` is nonzero, the virtual-dimension axiom bounds the gauge degree at
each Artin/cohomological coefficient, so both chamber maps are Laurent
polynomial and share a fixed-nonzero-parameter receiver.  An unbounded kernel
direction is `c_1`-neutral, hence its restricted moving weights sum to zero.
The parameterized Calabi--Yau Gamma contour theorem in
`2026-08-14-c907-neutral-slice-gamma-kernel.md` gives the required two-sided
analytic completion **if** virtual localization of the gauged packet is
identified with that complete common Mellin--Barnes kernel.  This last
identification, for the full packet rather than the already-vanishing point
row, is not yet written down.

Once the two-sided gauged packet lemma is proved, the common-source Boolean
theorem compares the endpoints directly.  The existing endpoint computation
gives a rank-visible length-three primitive-sixth packet on `X x P^2` and no
primitive-sixth packet on `P^5`, yielding the desired contradiction.  This is
the sole remaining implication; the localized row, half-Tate shift, endpoint
surjectivity, and global geometric master are no longer conditional inputs.

## 7. EJ / TT / AA

- **EJ:** use Wlodarczyk's global smooth projective cobordism once, not a
  sequence of chamber quotient QDMs.  The orbit cylinder through a common-open
  point supplies the global zero-wall row.
- **TT:** equality of the localized point row does not put the **packet** maps
  over one ring.  The endpoint quantum Kirwan series begin in opposite Novikov
  completions; completing both directions without a convergence theorem is
  illegal.
- **AA:** apply virtual localization to the whole Rees-homogenized packet.
  Positive `c_1` directions are Laurent-finite.  In every neutral direction,
  prove that the complete fixed-locus sum is exactly the parameterized
  Calabi--Yau Mellin--Barnes kernel, not an incomplete Gamma tail.

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
- Rees homogenization cancels the Novikov-Euler defect; virtual-dimension
  homogeneity and the star-morphism property give the Euler-product identity,
  while Artin-level bulk transport returns the packet from `kappa(0)` to zero.
- The commuting-rotation point-row theorem isolates one localized factor and
  kills every wall term by the zero-wall point restriction.  It is strictly
  weaker than the full fundamental-solution wall theorem left open in the
  literature.

### Open

- **Two-sided gauged packet.**  Construct the common differential coefficient
  field for the two global endpoint quantum Kirwan maps.  The only unbounded
  terms are `c_1`-neutral; identify their complete virtual-localization sum
  with the parameterized Calabi--Yau Gamma kernel.  This must be an identity
  for the full packet map, not merely the already-vanishing point row.

This is now the decisive audit.  It is narrower than the old peak comparison:
the geometry is one smooth global master, the oriented row is fixed, and the
shifted packet maps are fixed.  Only their two-sided neutral completion remains.

## Sources

- Chris T. Woodward, *Quantum Kirwan morphism and Gromov--Witten invariants
  of quotients I*, arXiv:1204.1765v9, Theorem 1.3 and the CohFT-algebra
  morphism formalism; cached PDF SHA-256
  `ebaaeaca4149ea5e44884efab02a7ed58c7be552d9572e6513b3b2f40158b5ef`.
- Chris T. Woodward, *Quantum Kirwan morphism and Gromov--Witten invariants
  of quotients III*, arXiv:1408.5869v7, Remark 8.10(a), Section 9, and the
  Liouville restriction in Lemma 9.3 and localized adiabatic limit around
  equation (68); cached PDF SHA-256
  `5aa794f4d83dd8d127aab769d95a71a4691d7a35d220e81ca73c5b8bb360ea51`.
- Eduardo Gonzalez and Chris T. Woodward, *A wall-crossing formula for
  Gromov--Witten invariants under variation of GIT quotient*,
  arXiv:1208.1727v7, Theorems 1.13, 1.17, and 3.25, Proposition 3.15(c), and
  Remark 1.18(b); cached PDF
  SHA-256
  `2c99203c8e1d7dd373112629bbfac0760e7a3812d348e9110a1eb2b894d9d84c`.
- Zhaoxing Gu, Song Yu, and Tony Yue Yu, *Quantum cohomology of variations
  of GIT quotients and flips*, arXiv:2508.15770v1, Definition 4.13 and
  Proposition 4.14; cached PDF SHA-256
  `9c00f826cb13ad243bd2ad126e74733cacf650a385160a11adc785693c01a358`.
- Jaroslaw Wlodarczyk, *Birational cobordisms and factorization of birational
  maps*, arXiv:math/9904074v1, Proposition 2(B') and its punctured-line-bundle
  construction of the extreme quotients; cached PDF SHA-256
  `ac86c460c3a039284565630ef63a77028af53a71697d4d0deb356574d2b3aa9c`.
