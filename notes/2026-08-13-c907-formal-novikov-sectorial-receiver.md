# C907 — formal-Novikov sectorial receiver

Date: 2026-08-13

Status: exact one-arrow block-level lemma after hostile revision.  Iritani's positive-`z` formal blow-up gauge
can be specialized at a fixed nonzero exceptional parameter and multisummed
with coefficients formal in the ambient Novikov variables.  The construction
uses finite Artin quotients and therefore does not assume convergence in those
variables.  It gives the common receiver needed by the C907 rank-functional
argument; it does not identify the two full large-radius and exceptional-cusp
solution completions.

## 1. The legal specialization

For a blow-up of codimension `r`, Iritani's Theorem 5.18 is defined over

\[
 \mathbf C[z]((q^{-1/s}))[[Q,\widetilde\tau]].
 \tag{1}
\]

The completion is graded.  Remarks 1.3 and 1.5 identify (1), as a graded
ring, with

\[
 \mathbf C[q^{\pm1/s}][[Q,\widetilde\tau]][[z]].
 \tag{2}
\]

Consequently, after fixing a monomial in `Q`, `tau`, and `z`, only a finite
Laurent polynomial in `q^{1/s}` occurs.  For every `q_0 in C^*`, coefficientwise
evaluation therefore gives a well-defined positive-`z` formal gauge

\[
 \widehat\Psi_{q_0}
 \in \operatorname{GL}(V\otimes
 \mathbf C[[Q,\widetilde\tau,z^{1/s}]]) .
 \tag{3}
\]

This is the distinction missed by the false point-covector proof.  The
intrinsic large-radius fundamental solution is a negative-`z` series and can
contain tails `(q/z^{r-1})^n`; it cannot be evaluated in the Laurent cusp.
Equation (3) evaluates the positive-`z` formal comparison gauge, coefficient
by coefficient.  It does not evaluate that large-radius solution.

The connection matrices themselves have the same fixed-`q` specialization
before any summation.  If `L` is an exceptional line in a codimension-`c`
blow-up, then

\[
 c_1(\widetilde Y)\mathbin\cdot L=c-1>0.
 \tag{4}
\]

For a fixed ambient curve class and fixed insertion degrees, the genus-zero
dimension axiom therefore bounds the exceptional degree.  Each coefficient of
the small connection is a polynomial in `q`, and the same count, with the
additional marked points included in the dimension formula, handles the
`tilde tau` derivatives.  At every Artin cutoff only finitely many ambient
classes occur.  Thus the fixed-`q_0` truncated systems below are finite
matrices of evaluated Laurent polynomials, not values assigned to an
unproved convergent Novikov series.

## 2. Formal-parameter sectorial lifting lemma

Let `A` be the completed Novikov/deformation ring
`C[[Q,tilde tau]]`, with the combined ample-energy and `tilde tau`-adic
filtration, and let
`M` and `M'` be finite free `A`-modules carrying integrable meromorphic
`z`-connections of level at most one.  Suppose:

1. their coefficients are convergent meromorphic functions of `z` after
   reduction modulo every filtration step;
2. `widehat G in Hom_A(M,M')[[z^{1/s}]]` is an invertible formal gauge;
3. on a chosen lifted direction the scalar parts of the exponential factors
   belonging to distinct blocks remain distinct modulo the maximal ideal.

Then `widehat G` has a unique multisum on that direction with coefficients
formal in `A`:

\[
 G_{\mathcal S}\in
 \operatorname{Hom}(M,M')\widehat\otimes_A
 \mathcal O_{\mathcal S}[[Q,\widetilde\tau]],
 \qquad G_{\mathcal S}\sim\widehat G.
 \tag{5}
\]

It is an invertible sectorial gauge.  Reduction modulo every filtration step
commutes with (5).  If `widehat G` intertwines auxiliary flat connections in
the formal parameters and a flat pairing, so does `G_S`.

### Proof

Let `A_N=A/F^N A`.  The combined filtration has finitely many monomials below
every cutoff, hence `A_N` is a finite-dimensional local Artin algebra.  Give
it any complex norm.  Borel and Laplace transforms apply directly to
finite-dimensional `A_N`-valued holomorphic functions.  Equivalently, the
regular representation embeds matrices over `A_N` into ordinary complex
matrices.  The reduction `widehat G_N` is a formal solution of the induced
finite-dimensional meromorphic Hom-system.

Classical Hukuhara--Turrittin multisummability, in its explicit iterated
Borel--Laplace form, produces its sectorial sum `G_{S,N}` on every nonsingular
direction.  Nilpotent elements of `A_N` repeat the scalar exponential factors
but do not rotate their Stokes directions, so the direction chosen modulo the
maximal ideal works at every `N`.

The Borel and Laplace transforms are complex-linear and commute with every
homomorphism `A_{N+1}->A_N`.  Therefore

\[
 G_{\mathcal S,N+1}\bmod F^N=G_{\mathcal S,N}.
 \tag{6}
\]

Taking the inverse limit gives (4).  Borel--Laplace summation commutes with
`z`-differentiation and multiplication by convergent coefficients, so the
formal gauge equation becomes the analytic sectorial gauge equation at every
finite level.  The same functoriality applied to the formal inverse proves
invertibility.

For an auxiliary Novikov connection, the defect

\[
 D_i=\nabla'_{Q_i}G_{\mathcal S}
       -G_{\mathcal S}\nabla_{Q_i}
 \tag{7}
\]

is the multisum of the zero formal series: `Q_i partial_{Q_i}` is a linear
endomorphism of every `A_N`, and the remaining coefficients are convergent in
`z`.  Equivalently, flatness makes (7) a homogeneous `z`-flat solution; its
formal expansion is zero because Iritani's gauge commutes with the formal
`Q_i`-connection, and level-one uniqueness gives `D_i=0`.  This explicitly
handles the finite-level isomonodromy step rather than assuming it.  Applying
the same argument to the formal pairing identity proves preservation of the
sectorial pairing.  It also gives an alternative uniqueness proof: (7) is a
homogeneous `z`-flat
solution with zero level-one asymptotic, and Watson uniqueness kills it on a
slightly shrunken sector of aperture greater than `pi`.

There is no parameter-collision problem at a finite Artin level.  A nilpotent
perturbation cannot move a scalar eigenvalue, hence cannot rotate an
anti-Stokes ray.  A nilpotent correction to an exponential produces a
terminating factor `exp(N/z)`, polynomial in `1/z`.  The Stokes geometry is
therefore exactly that of the closed fiber `A/m`; the verified fiber aperture
works uniformly through the inverse system.

For completeness, the regular-representation description descends back to
`A_N`: the connection, the formal gauge, and the differential equation commute
with the right regular action of `A_N`.  Its canonical multisum does too by
uniqueness, so it lies in the commutant, the left regular image of `A_N`.
Thus no matrix entries are introduced outside the coefficient algebra.

The construction is coefficientwise in the formal parameters.  No common
positive radius of convergence in `Q` is asserted or needed.

## 3. Application to the blow-up decomposition

Choose once and for all a lift `q_0^(1/s)` of the fixed nonzero `q_0`.  Apply
the lemma to the corresponding specialization (3) of Iritani's gauge.
Theorem 5.18 and formulas (5.41)--(5.43) give all its formal hypotheses:

- the ambient and center summands are preserved by every ambient Novikov
  connection;
- `Psi` commutes with the full quantum connection;
- `Psi` intertwines the Poincare pairing;
- the center exponential factors have nonzero `q_0`-scale scalar parts,
  while the whole ambient cluster has scalar part zero at the extremal
  specialization.

The last separation is block-level.  No primitive-sixth atom inside the
ambient block is split at `Q=0`, so its confluence is irrelevant.

Shen--Shoemaker identify the sectorial blocks at `Q=0`: the center blocks are
the Gamma images of the exceptional Orlov functors and the ambient tame block
is the Gamma image of pullback from the base.  Their common-sector condition,
with the separate codimension-two repair, supplies the required nonsingular
directions.  Thus the inverse-limit multisum is the common fixed-`q`,
formal-`Q` receiver sought in the Gold note.

## 4. The large-radius point section in the receiver

The preceding construction sums the comparison gauge, not the intrinsic
large-radius point solution.  The latter enters by a different, legal
normalization which never substitutes its `q`-adic series into the cusp.

At each Artin level `A_N`, the fixed-`q_0` quantum connection is a
finite-dimensional meromorphic system.  After the standard factors
`z^{-mu}z^rho` are removed, `w=1/z=0` is its large-radius normalization point.
There is a unique local fundamental solution

\[
 S_N(w)=\mathbf 1+O(w)
 \tag{8}
\]

of the `z` equation.  Its coefficient recursion is finite over `A_N`; the
fixed-`q` polynomiality from Section 1 makes every coefficient well-defined.
Ordinary ODE existence gives a convergent germ in `w` at this finite level.
For each Novikov derivation, apply the connection to `S_N`: integrability says
the defect is `z`-flat, while the normalized recursion gives it zero germ at
`w=0`; uniqueness forces the defect to vanish.  Thus `S_N` solves the full
`z` and Novikov connection equations.  The same joint normalization proves
both compatibility under `A_{N+1}->A_N` and equality with Iritani's
descendant/Gamma fundamental solution on their large-`z` overlap.

Apply `S_N z^{-mu}z^rho` to the Gamma class of the point and analytically
continue the resulting flat section along one path on the chosen ramified
`z`-cover, common to all `N`, from large `z` into the shrunken common sector.
The path respects the fixed lift `q_0^(1/s)` and avoids the finite singular
locus of the closed-fiber system; nilpotent thickenings add no new locations.
Call the result `s_{pt,N}^{LR}`.  It is the intrinsic Gamma
point section: on the ordinary large-radius overlap it has exactly Iritani's
normalization (8), and uniqueness of the normalized flat solution identifies
the two.  The construction is compatible through the Artin inverse system,
so

\[
 s_{pt}^{LR}=\varprojlim_N s_{pt,N}^{LR}
 \tag{9}
\]

is a jointly `nabla_z,nabla_Q`-flat point section in the fixed-`q`, formal-`Q`
receiver.

Now apply the summed comparison gauge `G_S` to (9).  This produces its ambient
and center block coordinates in the same receiver.  Thus both arguments in
the pairings below are genuinely present and jointly `nabla_Q`-flat.  This
does not claim that the original `q`-adic coefficient expansion of the point
section can be evaluated at `q_0`; it constructs the same normalized solution
from the evaluated finite connection.

## 5. Constancy of the rank framing

Let

\[
 \mathfrak r_Y(E)=(-1)^{\dim Y}\chi(\mathcal O_y,E)
 =\operatorname{rk}(E).
 \tag{10}
\]

for a point `y` off the center.  On the Gamma lattice, Iritani's pairing is
`chi(O_y,E)` and derived duality gives
`[O_y]^vee=(-1)^(dim Y)[O_y]`; the displayed sign therefore makes the
functional exactly ordinary rank.  Every exceptional Orlov object is
supported on the exceptional
divisor, hence has rank zero.  This statement is independent of the chosen
`O(kE)` twist and of which side of the ambient block the center copy occupies.

In the receiver, both arguments of the pairing are jointly `nabla_Q`-flat.
Flatness of the pairing gives

\[
 Q_i\partial_{Q_i}[s_1,s_2)=0
 \tag{11}
\]

coefficientwise.  The values can therefore be read at `Q=0`.  There:

1. Shen--Shoemaker identify every center block with rank-zero exceptional
   Gamma classes;
2. the extremal point-unit lemma gives
   `Psi(s(O_ytilde))=s(O_y) direct-sum 0` exactly.

It follows that the rank functional vanishes on every center block and
restricts on the ambient block to the base rank functional, throughout the
formal ambient Novikov base.  This is precisely the constancy-and-unit-column
lemma; no center-row coefficient is computed.

## 6. Scope and formal-constant output

The fixed-`q_0` receiver closes one blow-up arrow, but it does **not**
algebraize the coordinates of the large-radius point covector.  The
connection, formal block projector, and positive-`z` comparison gauge are
Laurent-polynomial in `q^(1/s)` at every Artin level; the analytically
continued point solution and its central-connection row need not be.  Formal
projector polynomiality therefore cannot be used to descend that row into
Iritani's Laurent cusp.

What descends is smaller.  Apply the integrability-defect argument with `q`
as an analytic parameter on a simply connected nonturning subset of `C^*`
and use parameterized summation.  Both paired sections are `nabla_q`-flat,
so each measured pairing is locally constant in `q`.  The ambient Novikov
and bulk equations kill the same scalar in all their directions.  After
passing to numerical Novikov variables, the simultaneous differential
constant field is exactly `C`, including after finite ramification.  Thus the
receiver computes complex horizontal pairing values, not a Laurent row.

The audit in `2026-08-13-c907-formal-constant-banking.md` shows why these
scalars do **not** yet compose.  The constant-field calculation is exact only
after a common horizontal realization is fixed.  It does not construct a
full-Novikov morphism from the `z=0` formal primary packet to the Gamma rank
line.  A later arrow can realize the same intermediate formal packet through
a different Stokes embedding.  Thus the receiver closes one arrow, but a
functorial `P_6 -> 1` morphism, Stokes-invariance theorem, or coherent
two-arrow receiver is still required for the telescope.

The result does not provide:

- an analytic function of the ambient Novikov variables;
- a map between the two full `q=0` and `q=infinity` solution completions;
- a full Gamma/Orlov connection matrix;
- a sectorial splitting of the confluencing primitive atom inside the ambient
  block;
- Laurent-polynomial coordinates for the Gamma rank covector.

The one-arrow construction is uniform in codimension.  For every `nu=c-1>=1`, the
choice `k=floor(nu/2)` is admissible and satisfies both strict inequalities in
Shen--Shoemaker's common-sector window.  A dependency audit of Sections 7--9
finds no dimension, Fano, nef, or further `nu>1` hypothesis after the separate
codimension-two repair.  The `k=0` window first fails at `nu=6`, hence first at
`m=4` (codimension-seven point centers in sevenfolds), but every
`O(kE)`-twisted exceptional block remains rank zero.  Thus no
high-codimension normalization obstruction remains for the rank functional.
This all-codimension statement applies arrow-by-arrow inside each receiver.

## AA / EJ / TT

- **AA:** replace analytic dependence on Novikov variables by an inverse
  system of finite Artin quotients.  Ordinary one-variable multisummation then
  suffices.
- **EJ:** the graded-ring identity (2) is stronger than a Laurent-cusp slogan:
  it permits fixed-`q` evaluation of the formal comparison gauge even though
  it still forbids evaluation of the negative-`z` large-radius solution.
- **TT:** the only spectral separation used is center versus the unsplit
  ambient cluster.  Any proof that diagonalizes the primitive atom at `Q=0`
  reintroduces the confluence error for no gain.
- **Open mystery:** independent fixed-`q` analytic receivers do not compose
  as coordinate systems, and scalar constancy alone forgets which Stokes
  embedding of `P_6` was measured.

## Sources

- H. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3,
  Remarks 1.3--1.5, Section 2.2, Theorem 5.18, and formulas
  (5.41)--(5.43).  Shared-cache SHA-256:
  `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.
- T. Dreyfus, *A density theorem in parameterized differential Galois
  theory*, arXiv:1203.2904v4, Proposition 1.3 and Sections 1.3--1.4,
  especially Proposition 1.10's iterated Borel--Laplace construction.
  Shared-cache SHA-256:
  `927b043d9af6759673cd28be74dfe1765373e60bf6e9c94821a80dd0700dccc0`.
- Y. Shen, M. Shoemaker, *Quantum spectrum and Gamma structure for standard
  flips*, arXiv:2502.08762v2, Theorem 1.4, Remark 1.6, and Sections 7--9.
  Shared-cache SHA-256:
  `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.
