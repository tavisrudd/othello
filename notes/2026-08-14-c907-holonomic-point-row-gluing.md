# C907 — holonomic gluing of the marked point row

Date: 2026-08-14

**Status:** internally closed candidate replacement for complete-neutral
continuation, pending hostile source and sign audit.  The finite-dimensional
cyclic-row and analytic gluing lemmas are proved below; Lemma 3 proves general
endpoint clutching-tail holonomicity from Woodward's fixed-locus
factorization; and Picard twisting proves the required marked wall jump is
zero.  No complete residue/graph bijection is assumed.  The manuscript must
remain conditional until the new Lemma 3 has passed an independent audit.

This note supersedes the unconditional claims in
`2026-08-14-c907-complete-neutral-localization.md` and the complete-residue
parts of `2026-08-14-c907-neutral-slice-gamma-kernel.md` and
`2026-08-14-c907-quantum-kirwan-common-source.md`.  The paper correctly keeps
complete-neutral continuation as a hypothesis.

## 1. Why the full continued source is stronger than necessary

Let `V` be a finite-dimensional vector space over a characteristic-zero
field, let `T` be an endomorphism, and let `r` be a row on `V`.  Define the
dual cyclic space

\[
 C_T(r)=\operatorname{span}\{r,rT,rT^2,\ldots\}\subset V^* . \tag{1}
\]

### Lemma 1 (cyclic-row spectral support)

For every eigenvalue `lambda` of `T`,

\[
 r|_{P_\lambda(V)}\ne0
 \quad\Longleftrightarrow\quad
 P_\lambda(T^*)C_T(r)\ne0 .                                  \tag{2}
\]

Hence the set of primary packets detected by `r` is determined by the
isomorphism class of the marked cyclic pair `(C_T(r),r)`.

### Proof

Let `e_lambda(T)` be the polynomial Bezout projector onto the generalized
`lambda`-eigenspace.  The restriction of `r` to `P_lambda(V)` is the row
`r e_lambda(T)`.  This row belongs to `C_T(r)` and is the
`lambda`-primary projection of `r` for the dual action.  It is zero exactly
when the restriction is zero.  This proves (2).  \(\square\)

Consequently C907 does not need a common analytic continuation of every
undetected direction of the two endpoint quantum modules.  It is enough to
continue the pullback of the Gamma point row and all of its **z-covariant**
derivatives.  A scalar Novikov continuation without this joint z-structure
would not control formal monodromy.
Formal smooth-endpoint quantum-Kirwan surjectivity makes the pullback on dual
cyclic modules injective, so no detected endpoint primary factor is lost.

This bypasses the finite common-source quotient used in the conditional
proof.  It also avoids the factorization ambiguity of an unmarked graph
trace: the commuting-rotation support-collapse theorem extracts one
oriented row before any continuation is attempted.

## 2. Hypergeometric tails are holonomic

Let `A` be a finite-dimensional complex Artin algebra.  Fix a congruence
class after clearing stabilizer denominators.  Suppose an `A`-valued sequence
`c_k` is a finite nilpotent parameter derivative of a Gamma-ratio expression
whose arguments are affine integral functions of `k`.  Then, after adjoining
finitely many parameter derivatives to the state vector, there are
polynomial matrices `P(k),Q(k)` such that

\[
 P(k)c_{k+1}=Q(k)c_k .                                        \tag{3}
\]

Indeed `Gamma(x+1)=x Gamma(x)` gives a rational first-order recurrence for
the undeformed Gamma ratio.  Differentiating finitely many times in nilpotent
parameters gives an upper-triangular rational recurrence for the finite jet;
clearing denominators gives (3).  A step larger than one is reduced to this
case by splitting the sequence into finitely many congruence classes.

If `theta=x d/dx` and `F(x)=sum_{k>=k0} c_k x^k`, coefficient extraction
turns (3) into a finite system of differential equations with polynomial
coefficients.  Thus `F` is holonomic and has analytic continuation along
every path avoiding a finite singular set.  Under the neutral balance

\[
 \sum_a \epsilon_a h_a=0,                                    \tag{4}
\]

Stirling's formula gives, after one fixed rescaling of `x`,

\[
 \|c_k\|=O(k^N(\log k)^M)                                    \tag{5}
\]

for some `N,M`.  Hence radial boundary values exist as tempered
`A`-valued distributions.  Polynomial insertions, input/bulk derivatives,
finite sums, and Artin quotient maps preserve these conclusions.

This argument constructs a canonical holonomic germ from the actual
Gamma-ratio recurrence.  It does not infer an arbitrary interpolating
function from its integer values, so the `sin(pi sigma)` ambiguity does not
arise.

## 3. Distribution-to-holomorphic gluing

The following elementary lemma converts the negative shadow in
Gonzalez--Woodward into a positive continuation statement once holonomicity
is available.

### Lemma 2 (finite-support boundary gluing)

Let `F_0` and `F_infinity` be `A`-valued holonomic germs on the two sides of
a circle, with tempered radial boundary values.  Assume their boundary
difference is supported at finitely many points of the circle.  Then they are
branches of one `A`-valued holonomic continuation on the complement of those
points and their other finite singularities.  If the supported distribution
has finite order, the only added singularities are poles of finite order
(after the finite ramification already used for stabilizers).

### Proof

Work in a complex basis of the finite-dimensional algebra `A`.  A
distribution of finite order supported at `xi` is a finite sum of derivatives
of `delta_xi`.  Its Fourier coefficients have the form

\[
 P(n)\xi^{-n}.                                                 \tag{6}
\]

The inside and outside Laurent expansions of

\[
 P(\theta)\frac{1}{1-x/\xi}                                   \tag{7}
\]

differ by exactly (6), with the usual opposite orientation for the outside
expansion.  Subtract the finite sum of the rational principal parts (7).
The two remaining boundary distributions agree on the whole circle.
Polynomial boundary growth permits distributional Morera gluing across
every arc; equivalently, the one-variable edge-of-the-wedge theorem applies.
The two germs therefore continue to one holomorphic function there.  Adding
back (7) proves the assertion.  Holonomicity is preserved by analytic
continuation and finite rational correction.  \(\square\)

The zero-jump case is the one relevant to the marked common-open point row.
No effectivity or termwise residue matching is used; cancellations in the
complete virtual sum are allowed.

## 4. Geometric application and the one remaining gate

Fix a finite ample-energy/bulk Artin quotient, an ordinary equivariant curve
class modulo a primitive affine direction `delta`, and the common-open point
class `a_p` of Section 8 of the manuscript.  The commuting-rotation
support-collapse theorem gives equality of the two oriented endpoint point
rows in Woodward's extended degree-function space: every intermediate
polarization-fixed contribution contains `a_p|_F=0` before division by its
virtual normal Euler class.

If the two marked endpoint series are holonomic and tempered in every
neutral direction, their boundary jump is therefore zero.  Lemma 2 places
them and their z-covariant derivatives in one continued marked cyclic
z-module.  Lemma 1 then identifies their detected formal-monodromy primary
spectra.  Nonneutral directions are
Laurent-finite by the virtual-dimension equation, and the neutral Rees factor
is independent of the affine coordinate.  Input/bulk derivatives and Artin
quotient maps commute with the construction.

Here is the exact module argument.  Choose finitely many common equivariant
inputs whose quantum-Kirwan images span each endpoint module; take the union
of two finite lift sets if necessary.  On each chamber, evaluation of the
pulled-back point row on these inputs realizes the intrinsic dual cyclic
module faithfully, because the endpoint quantum-Kirwan map is surjective.
The row equality in the extended equivariant degree-function space becomes
equality of tempered boundary distributions once (5) is known.  Lemma 2
continues the resulting finite vector of functions.  Its z-connection
equations also continue, by the identity theorem, so the module generated by
its z-covariant derivatives is one common cyclic z-module.  Faithfulness on
each chamber identifies it with the endpoint dual cyclic module.  Lemma 1
then gives the Boolean equivalence.  No continuation of the complementary
undetected directions is used.

Thus the manuscript's complete-neutral hypothesis can be replaced by the
following strictly weaker statement.

> **Point-row holonomicity gate.**  At every finite Artin level and fixed
> ordinary degree, each neutral clutching tail of the point-marked localized
> Woodward graph series is, after a finite congruence split, a finite
> nilpotent derivative of one fixed Gamma-ratio recurrence.

Woodward Corollary 9.10 and the virtual-normal formula provide the expected
recurrence: on each stable clutching tail the moving line degrees are
`h_a k+s_a`, the node factors are independent of `k`, and fixed bubble
degrees contribute adjacent Gamma ratios.  What still has to be checked is
that the coefficient stack, its fixed obstruction theory, and its evaluation
class are constant on each tail.  Sign changes of the clutching
one-parameter subgroups, unstable contractions, and finite stabilizer phases
may split a tower into finitely many tails; finite exceptional values are
harmless Laurent polynomials.

Gonzalez--Woodward Lemma 4.5 proves precisely this constancy for their
polarization-fixed Picard orbits: twisting preserves the relative
obstruction theory, virtual class, bubble components, and evaluation
classes.  It is not a published theorem for Woodward's localized
rotation-fixed graph receiver.  The following is the required extension.

### Lemma 3 (clutching-tail holonomicity)

Assume the degreewise proper Deligne--Mumford and perfect-obstruction-theory
hypotheses used for Woodward's localized gauged graph potentials.  Fix an
ordinary bubble degree, a rotation-fixed graph type, and a finite stabilizer
congruence class.  Along a rank-one affine clutching direction, remove
finitely many degrees at which a sign, stability, or zero-weight condition
changes.  On each remaining tail:

1. the fixed coefficient stack, its fixed perfect obstruction theory,
   virtual class, and evaluation maps are independent of the affine degree;
2. the moving virtual-normal Euler factor is a finite nilpotent derivative
   of one Gamma-ratio recurrence with affine arguments.

Consequently every neutral point-marked endpoint tail satisfies the
point-row holonomicity gate.

### Proof

Woodward Corollary 9.10 and equations (54), (56), and (57) express a
rotation-fixed component as a fibre product of two factors
`F_n^{G,+}(phi_+,d_+)` and `F_n^{G,-}(phi_-,d_-)` over the inertia quotient.
Each factor already contains the full ordinary stable-map space attached at
that end.  Thus arbitrary bubble trees are not an additional induction:
for fixed `d_+`, `d_-`, and markings they lie in fixed proper stable-map
factors with their usual fixed obstruction theories.

For `G=G_m`, changing the affine degree changes each clutching cocharacter
by an integer.  For a nonzero integer `m`, the limit of `m(t)x` depends only
on the sign of `m`; its inertia label depends only on `m` modulo the finite
stabilizer order.  Hence, after a finite sign/congruence split, the limit
strata, the two stable-map factors, their fibre product, and all evaluation
maps are constant.  The finitely many degrees at which the principal
component becomes unstable are separated off and contribute only a Laurent
polynomial.

It remains to identify the induced fixed obstruction theory.  Pull the
equivariant tangent complex of `W/G_m` to the normalization of the universal
domain and apply the normalization triangle.  On every attached bubble the
clutching line is canonically trivial, so the bubble complexes and the node
matching maps are independent of the affine degree.  On the principal
component, split the tangent complex into character roots.  A root of
character `h` has degree

\[
 hk+s.
\]

The weights of its `H^0-H^1` index form one consecutive affine interval.
Away from the finitely many integers at which an endpoint crosses zero, its
weight-zero summand has constant rank and is identified, by evaluation at a
generic point of the principal component, with the same root bundle on the
constant coefficient stack.  The `H^1` statement is the dual assertion by
Serre duality.  This is an identification of complexes, not only of their
K-classes: evaluation at the generic point sends the unique zero-weight
monomial to the root vector with coefficient one, and the normalization maps
are the fixed endpoint evaluations.  Any clutching integer appearing in the
infinitesimal gauge map is a nonzero scalar on the declared tail and is
removed by rescaling that summand; its zero value was already separated as a
threshold.  Therefore the fixed part of the normalization triangle, its
maps, and hence the induced fixed perfect obstruction theory are constant on
the tail.  This also fixes its virtual class.

The complementary moving weights are all nonzero members of the same affine
intervals.  Woodward equations (58)--(59) add only the node-smoothing and
attaching-point factors, which are independent of the clutching degree (and
are omitted for the unstable irreducible type under the source convention).
The uniform `H^0/H^1` Gamma identity therefore writes their Euler factor as
one Gamma ratio with affine arguments.  Chern roots on the constant
coefficient stack are nilpotent, so only finitely many parameter derivatives
occur.  This proves both assertions.  In a neutral direction the signed
slopes cancel, and Section 2 gives holonomicity and tempered boundary values.
\(\square\)

The proof is a new deduction from Woodward's factorization, not a theorem
stated in that source.  Its two most sensitive points are the fixed-POT
identification through the normalization triangle and the unstable-type
convention.  They require independent hostile audit before promotion to the
manuscript.

## 5. Why this avoids the failed complete-residue route

1. No pole is assigned to an individual graph refinement.
2. No generic deformation of coincident poles is given a geometric meaning.
3. No graphwise opposite-chamber bijection is asserted.
4. No full fundamental-solution or Givental-cone comparison is required.
5. The complete sum is used only through the already proved marked
   support-collapse identity; the continued object is the dual cyclic row.

The complete-residue statement in the earlier notes was therefore stronger
than necessary and unsupported.  Aleshkin--Liu remains a model for the
balanced analytic estimates, but their linear GLSM wall theorem is not used
as a black box for nonlinear graph refinement.

## 6. Smallest falsifier

Use a balanced rank-one projective-bundle master with central fixed base
`B=P^1`, normal characters `+1,-1`, and one positive-degree fixed bubble in
`B` attached at one node.  Check explicitly that twisting the principal
bundle by `O(k)`:

1. leaves the fixed coefficient stack, virtual class, and point evaluation
   unchanged on each stable tail;
2. changes only the moving normal index by affine line degrees;
3. leaves the node-smoothing and graph-automorphism factors in one rational
   recurrence;
4. produces no extra nonholonomic dependence when an unstable component is
   contracted.

Failure of any item kills the route.  Success supplies the base case for an
induction over bubble-tree edges; the induction step is the normalization
exact triangle for the moving index together with the standard gluing
formula for the fixed virtual class.

### Regression calculation

Take

\[
 W=\mathbf P_B(\mathcal O\oplus L_+\oplus L_-),\qquad
 B=\mathbf P^1,                                                \tag{8}
\]

with `G_m`-weights `0,+1,-1` on the three summands.  The central fixed
section is `B`, with moving normal bundle `L_+ direct-sum L_-` carrying the
two opposite characters.  Fix a degree-`d` bubble in the central section and
one attaching node.  Its coefficient stack is a stable-map stack

\[
 \overline M_{0,n+1}(B,d),                                    \tag{9}
\]

with fixed obstruction complex `R pi_* f^*T B`; none of these data depends
on the principal bundle degree `k`.

Twisting the principal bundle by `O(k)` changes the moving normal complex to
a sum of the following two kinds of terms:

\[
 R\Gamma(\mathbf P^1,\mathcal O(k))\otimes L_+|_b,
 \quad
 R\Gamma(\mathbf P^1,\mathcal O(-k))\otimes L_-|_b,            \tag{10}
\]

on the principal component, and

\[
 R\pi_*f^*L_+\otimes\chi^k,
 \quad
 R\pi_*f^*L_-\otimes\chi^{-k}                                \tag{11}
\]

on the fixed bubble.  After the splitting principle, every root of (11) is
`alpha_j+(k+c_j)zeta` or `beta_j+(-k+c'_j)zeta`; the ranks and roots are
classes on (9) independent of `k`.  Equations (10)--(11) therefore have one
rational Gamma recurrence.  Their signed slopes cancel.  The node-smoothing
and attaching-point terms are `(-zeta)(-zeta-psi)` and contain no `k`.
Stable-map automorphisms are those of (9), also independent of `k`.

A mode becomes rotation-fixed only when one of finitely many affine weights
in (10)--(11) is zero.  These are finitely many threshold integers (and,
with finite stabilizers, finitely many congruence thresholds).  Removing
them leaves finitely many stable tails with constant fixed POT; the threshold
terms themselves are a Laurent polynomial.  Thus all four falsifier checks
pass in this first nonlinear model.

This is the smallest nonlinear regression for Lemma 3.  It confirms the
normalization-triangle argument with a genuine bubble and node; the general
lemma does not require an induction over bubble-tree edges because
Corollary 9.10 packages the complete tree in the stable-map factors.

## 7. Preferred bypass: shift the polarization-fixed stack

The general-tree audit suggests that extending Picard twisting directly to
the endpoint clutching graphs is unnecessary.  The safer object is the
polarization-wall fixed stack in Gonzalez--Woodward's virtual Kalkman
formula, while retaining Woodward's auxiliary graph rotation only to extract
the oriented point row.

On that fixed stack, Gonzalez--Woodward Lemma 4.5 gives exactly the
coefficient-ring separation needed here.  Tensoring the principal bundle by
the Picard generator:

- identifies the degree-shifted fixed stacks;
- preserves their relative obstruction theories, virtual classes, and
  evaluation classes;
- is trivial on every attached bubble, so the bubble tangent complexes are
  literally unchanged;
- changes only the moving normal index on the principal component.

Equations (40)--(45) of that source compute the entire shift dependence from
the principal normal characters.  In the neutral case their signed sum is
zero.  Thus, after a finite Artin reduction, the nonlinear wall moduli really
is a passive coefficient algebra for one rank-one balanced Gamma recurrence.
There are no additional bubble pole families to match to graph refinements.

The common-open class `a_p` restricts to zero on this polarization-fixed
stack.  After the commuting-rotation extraction, every wall coefficient of
the marked row is therefore zero before the normal Euler class is inverted.
The A-valued rank-one continuation only supplies the common analytic domain;
it is not asked to identify a nonzero nonlinear residue.  This is precisely
the situation in which generic pole splitting and graphwise effectivity are
irrelevant.

The resulting preferred gate is:

> **Localized Picard-row lemma.**  The auxiliary rotation localization used
> to extract the oriented row commutes with the Picard identifications of
> the polarization-fixed stack, and its two endpoint row germs are the two
> boundary germs of the resulting A-valued balanced principal-normal
> kernel.

This is strictly weaker than the localized fundamental-solution extension
left open in Gonzalez--Woodward Remark 1.18(b): it treats one marked row, and
all wall residues in that row vanish by support.  It is also narrower than
the endpoint-tail gate in Section 4.  A proof should combine the equivariant
POT already used by support collapse with Lemma 4.5 before applying rotation
localization; the two torus actions commute, so the fixed/moving
decomposition can be taken in either order.

That last compatibility is algebraic.  Represent the `r`-th Picard shift by
the rotation-linearized line bundle

\[
 Q_r=\mathcal O_{\mathbf P^1}(r[0]),                           \tag{12}
\]

with its canonical trivialization near infinity.  Tensoring by `Q_r` shifts
only the zero-side clutching cocharacter.  It leaves the infinity-side total
degree `d_+ + phi_+` unchanged.  Woodward's Liouville restriction depends
on precisely that total degree, so its full-divisor character and the
zero-character extraction commute with the Picard action.  In particular,
the extracted infinity factor remains the same degree-zero unstable
identity throughout the orbit.

The rotation linearization in (12) makes the Picard action equivariant for
the auxiliary graph rotation.  On the polarization-fixed principal
component, the shifting subgroup acts trivially on the target fixed locus;
on every attached bubble, `Q_r` is trivial.  Gonzalez--Woodward Lemma 4.5
therefore identifies the fixed coefficient stack, POT, virtual class, and
evaluation insertions equivariantly.  Woodward's node-smoothing and
attaching-point factors depend only on graph rotation and are unchanged.
All `r`-dependence is consequently the principal moving-normal index
computed in Gonzalez--Woodward equations (40)--(45).

In a neutral direction its signed character sum is zero.  Since `a_p`
restricts identically to zero on the polarization-fixed stack, its marked
wall coefficient is zero before this normal factor is inverted.  This proves
the required zero-jump statement, subject only to checking the stated
linearization convention against the source's signs.

It does **not** by itself prove that either endpoint row germ is holonomic.
That input comes from Lemma 3.  With that lemma, the endpoint germs are
tempered, the zero jump becomes
equality of their boundary distributions, and Lemma 2 continues them to one
row.  Picard twisting therefore removes the residue/graph matching problem,
while Lemma 3 supplies the separate endpoint control.

Combining the localized Picard-row argument with Lemmas 1--3 gives the
candidate unconditional point-row primary Boolean invariance without
constructing the complete nonlinear graph continuation postulated in
Hypothesis 8.2.  The result remains an internally proved candidate until the
two new geometric arguments have passed external audit.

## Sources

- Gonzalez--Woodward, arXiv:1208.1727v7, Lemma 4.5, equations (40)--(47),
  Remarks 1.18(b,d), 4.6, and 4.7; cached PDF SHA-256
  `2c99203c8e1d7dd373112629bbfac0760e7a3812d348e9110a1eb2b894d9d84c`.
- Woodward, arXiv:1408.5869v7, Corollary 9.10 and equations (54)--(59);
  cached PDF SHA-256
  `5aa794f4d83dd8d127aab769d95a71a4691d7a35d220e81ca73c5b8bb360ea51`.
- Aleshkin--Liu, arXiv:2301.01266v1, Definition 5.18 and Theorem 5.21;
  cached PDF SHA-256
  `921af8ed2105d6a511c0cf485550a263e222983c6fcc628b44c838bb3d8de81f`.

## Mystery ledger

- **Settled:** interpolation uniqueness is unnecessary; the Gamma recurrence
  defines a holonomic germ.
- **Settled:** complete residue/graph exhaustiveness is unnecessary for the
  Boolean; the dual cyclic point row suffices.
- **Settled in the first nonlinear model:** the balanced projective-bundle
  master with one fixed bubble has constant coefficient stack and POT on
  each tail; all unbounded dependence is one rational Gamma recurrence.
- **Settled internally:** choosing the Picard generator as
  `O(r[0])`, trivialized at infinity, makes auxiliary rotation and the
  Liouville zero-character extraction commute with the published Picard
  identification.  External sign/convention audit remains.
- **Settled internally, external audit required:** Lemma 3 proves constant
  fixed POT and Gamma recurrence on every endpoint clutching tail.  The key
  simplification is that Corollary 9.10 packages complete bubble trees into
  fixed stable-map factors, so no edge induction is required.
- **Open:** whether the manuscript's word `meromorphic` should explicitly
  allow the finite ramified/logarithmic cover naturally produced by regular
  holonomic continuation.  This is a statement-level audit after the
  geometric gate passes.
