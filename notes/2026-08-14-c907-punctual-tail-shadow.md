# C907: punctual tail shadows and the first clutching hypothesis

Date: 2026-08-14

## Objective

Remove, or prove in the form actually needed, the tailwise derived
identification hypothesis in
`papers/cubic-stabilization-irrationality/sections/08-global-transport.tex`.
The point-row argument does not need a global identification of nonlinear
gauged-map spaces.  It needs the fixed coefficient data to be constant along
each affine clutching tail after the explicit moving normal factor is removed.

The cheapest sufficient shadow is equality in the common-open quotient

\[
 K_0(Y)/K_0^D(Y),\qquad D=Y\setminus U,
\]

because the Gamma point row is ordinary rank and annihilates every class
supported on the proper boundary `D`.

## Candidate punctual tail-shadow lemma

Let `G=G_m`, let `U` be the free common-open orbit cylinder in a smooth
projective equivariant cobordism `W`, and fix:

- a finite ample-energy/bulk Artin quotient;
- an ordinary bubble degree and rotation-fixed graph type;
- a stabilizer congruence class;
- one component of the complement of the finite sign, stability, and
  zero-mode thresholds.

For two consecutive affine cocharacters in this tail, divide the localized
fixed contribution by the explicit moving-index Gamma ratio.  Then the two
point-marked output classes have the same image in `K_0(Y)/K_0^D(Y)`.
Equivalently, their difference is boundary-supported and is annihilated by
the Gamma point row.

A stronger statement would identify the fixed derived clutching factors,
their universal curves, evaluation maps, fixed perfect obstruction theories,
virtual classes, automorphisms, and inertia gluing.  The quotient statement is
all the conditional theorem consumes.

## What Woodward gives

For a torus, Woodward's Corollary 9.10 describes every rotation-fixed gauged
map by clutching data.  In his notation,

\[
 F_{n}^{G,\pm}(\widetilde\phi,d)
 =\{([u],x):u(z_{n+1})=\lim_{z\to 0}
   \widetilde\phi(z)x\}/G,
\]

and the full fixed locus is a fibre product of the two clutching factors over
the inertia quotient.  Equations (58)--(59) split the moving normal complex.
They do not themselves compare different affine cocharacters.

For `G=G_m`, write a rational cocharacter on a `k`-fold cover as
`phi_a(z)=z^a`.  A clutching degree has two endpoint exponents
`a_-(j),a_+(j)`, affine in the tail coordinate `j`.  If two values of `j`
give the same sign for each endpoint exponent and the same residues modulo
`k`, then

\[
 \lim_{z\to0}\phi_a(z)x=\lim_{z\to0}\phi_b(z)x
\]

whenever either limit exists (with `a,b` denoting either endpoint pair), and
the inertia labels `phi_a(theta)` and `phi_b(theta)` agree.  Lemma 9.9 makes the large-area
stability condition depend only on the generic semistability of `x`.
Consequently the classical clutching stack, its bubble fibre products,
universal stable curves, evaluations, automorphism groups, and inertia map
are literally constant on a sign/congruence tail.

Example 9.11 is the linear calibration: for `W=C^N`, every degree has the
same fixed component `P^{N-1}`; the degree appears only in the moving index.

## The remaining weight-zero lemma

The point not supplied by Woodward's degreewise clutching statement is the
fixed part of the canonical deformation complex of the principal gauged
section.  The required statement is:

> **Weight-zero clutching lemma.**  For two cocharacters in one
> sign/congruence tail, after removing the finite zero-mode thresholds, the
> invariant part of
> `R pi_* ev^* T(W/G)` is canonically identified by evaluation at `z=1`.
> The complementary moving part changes by the affine line-bundle degrees
> already recorded by the Gamma factors.

This has a direct local model.  A fixed section is

\[
 u_a(z)=\phi_a(z)x.
\]

On `G_m` the group action trivializes `u_a^*T(W/G)` by its value at `x`.
Extension across zero and infinity imposes linear weight inequalities.  The
set of invariant extensions changes only when one of those inequalities is
an equality, exactly the removed zero-mode thresholds.  Within a tail,
evaluation at `z=1` therefore identifies the invariant Cech complexes.  The
same argument applies to the two-term tangent complex `[g -> TW]`; its
differential is equivariant and hence respects the weight decomposition.

Attached stable-map factors, including stable degree-zero bubbles, are fixed
by the clutching description.  Their node and attaching factors are adjacent
Gamma ratios and do not affect the fixed complex.  The irreducible unstable
type is handled separately, as in Woodward's Example 9.15.

If this weight-zero lemma holds functorially over the clutching stack, it
proves the stronger tailwise derived identification hypothesis, not merely
the punctual quotient shadow.

## Proof of the weight-zero clutching lemma

The clean proof identifies the derived fixed object itself.  The invariant
Cech complex then supplies an independent tangent-level check.

### Derived-intersection identification

For a nonzero integer `a`, let `W^a` be the attracting locus on which
`lim_{t->0}t^a x` exists.  Evaluation at `1` identifies fixed sections on one
parametrized affine chart with `W^a`: the section determined by `x` is
`z mapsto z^a x`, and it extends across the origin exactly when `x` belongs
to `W^a`.  This identification is functorial in families.  On a `k`-fold
orbifold cover the same statement holds in the inertia component labelled by
`phi_a(theta)`.

A principal clutching section has two such extensions with the same generic
value `x`.  Its derived moduli stack is therefore

\[
 \mathcal C_{a_-,a_+}^{\mathrm{der}}
 = [W^{a_-}/G]\mathop{\times}^{\mathbf R}_{[W/G]}[W^{a_+}/G].       \tag{1}
\]

The two maps to the inertia quotient are induced by the two attracting limit
maps.  Adding the fixed ordinary stable-map factors gives the full fixed
clutching stack as their derived fibre product with (1) over those two inertia
maps.  This is the derived version of Woodward's equations (54)--(57).

For `G=G_m`, replacing either nonzero endpoint exponent by another integer of
the same sign does not change its attracting locus or limit map.  The
stabilizer congruence fixes the inertia component.  Thus (1), its universal
curve, both evaluations, and the derived fibre products with the attached
stable-map factors are literally the same derived stacks throughout one
tail.  Derived cotangent complexes, their maps, and virtual classes are
therefore identified automatically.

The tangent complex of (1) is

\[
 \left[
  T(W^{a_-}/G)\oplus T(W^{a_+}/G)
  \longrightarrow T(W/G)
 \right].                                                   \tag{2}
\]

It can have degree-one cohomology when the two attracting loci meet
nontransversely.  Hence the derived fibre product retains exactly the fixed
obstruction modes which an underived intersection would lose.

### Invariant Cech verification

The same complex follows from a splitting-free Cech description of an
equivariant bundle on the parametrized line.

Let `S` be one connected fixed clutching stack in a chosen graph type, and
let `V` be the restriction at `z=1` of one term of the pulled-back tangent
complex.  Trivialization by the group action over `G_m x S` identifies the
generic fibers for every affine cocharacter in the tail.  Extension across
zero and infinity is encoded by two subbundles

\[
 F^0_\bullet V,\qquad F^\infty_\bullet V.
\]

For the tangent bundle these subbundles have a geometric description.  Write
`W^a` for the locus on which `lim_{t->0}t^a x` exists.  Evaluation at
`z=1` identifies invariant tangent sections extending across that endpoint
with `T W^a`.  For `G_m`, the attracting locus and its retraction depend
only on the sign of `a`; replacing `a` by another integer of the same sign is
precomposition by a power map.  Thus the two extension subbundles are the
tangent bundles of the two fixed attracting loci.  They are independent of
the magnitude of the endpoint cocharacters.

Cover the parametrized line by `A^1_0` and `A^1_infty`.  An invariant section
on the overlap is constant under the group-action trivialization and is
therefore an element of `V`.  It extends invariantly across zero precisely
when it lies in the zero step `F^0_{\leq 0}(a)V`, and across infinity
precisely when it lies in `F^infty_{\leq 0}(a)V`, with the harmless reversal
of the infinity indexing absorbed into the notation.  Taking invariants in
the Cech resolution gives the canonical complex

\[
 R\pi_*E_a^{G_m}
 \simeq
 \left[
   F^0_{\leq0}(a)V\oplus F^\infty_{\leq0}(a)V
   \longrightarrow V
 \right].                                                   \tag{3}
\]

This description does not choose an equivariant splitting of `E_a`.
It is functorial in `S`, in equivariant maps of bundles, and in base change.
For a general equivariant summand it is the filtration-valued form of the
line-bundle calculation below.  Its zero steps change only when an affine
endpoint weight is zero.  For the tangent bundle, constancy also follows
directly from constancy of the attracting loci.  Hence (3) is literally the
same complex for every cocharacter in one remaining tail, with the
identification induced by the identity of `V`.

Apply (3) termwise to the equivariant two-term tangent complex

\[
 [\mathfrak g\longrightarrow TW].                           \tag{4}
\]

The differential in (4) is equivariant, so the Cech identifications commute
with it.  The invariant derived deformation complex of the principal section
is therefore canonically constant along the tail.  Every nonzero character
of the same Cech complex belongs to the moving normal complex.  Its endpoint
filtration indices are the affine degrees `h a+s`, and its change is exactly
the finite product of linear Euler factors written as the Gamma ratio in the
manuscript.

Corollary 9.10 identifies the underlying clutching stack along the tail:
same-sign cocharacters have the same endpoint limits, and the congruence
condition fixes the inertia label.  Lemma 9.9 fixes the stability condition.
Thus the universal stable curves, bubble factors, evaluation maps,
automorphisms, and inertia gluing are unchanged.  Their intrinsic deformation
complexes are unchanged as well.  Combining these fixed factors with (3)--(4)
identifies the full fixed deformation-obstruction complex.

The fixed perfect obstruction theory is the dual of this canonical invariant
deformation complex, together with the unchanged stable-curve terms.  Its map
to the cotangent complex is obtained by differentiating the universal
clutching section.  Under evaluation at `z=1`, that section is the same
universal point `x` on both tails; at the nodes its evaluations are the same
attracting retractions.  Formula (3) is induced by restriction of this same
universal section, rather than by a noncanonical quasi-isomorphism.
Consequently the identification commutes with the maps to the cotangent
complex and is an isomorphism of perfect obstruction theories, not merely an
equality of their K-classes.  Equality of virtual classes follows.  Every
construction commutes with reduction of the coefficient Artin algebra because
(1) is formed from subbundles, direct sums, and a two-term Cech differential.

The required subbundle property is intrinsic in the present smooth
rank-one setting.  The attracting loci of a smooth projective `G_m`-variety
are smooth, and their tangent bundles pull back to subbundles over `S`.
Consequently the principal fixed deformation complex is, before adding the
unchanged bubble terms, the explicit perfect complex

\[
 \left[
  T W^{a_-}|_S
  \oplus T W^{a_+}|_S
  \longrightarrow T W|_S
 \right],                                                   \tag{5}
\]

with the two restriction maps followed by subtraction.  The corresponding
formula for `T(W/G)` is obtained by applying the same construction to
`[\mathfrak g\to TW]`; the adjoint term is constant because `G=G_m`.
No constructible rank refinement is needed.

This is the tangent complex of the derived intersection (1), providing a
second derivation of (2).  It proves the tailwise derived identification
stated in the manuscript for `G=G_m`.

## Exact line-bundle calibration

The threshold claim can be checked without any geometry.  Let `L` be a
linearized line bundle on the parametrized line.  Trivialize it equivariantly
over `G_m`, and let `r_0,r_infty` be the exponents of its invariant Laurent
section in the two endpoint coordinates.  The invariant Cech complex is

\[
 [A_0\oplus A_\infty\longrightarrow A],
 \qquad
 A=A_S,
 \quad A_0=\begin{cases}A&r_0\geq0,\\0&r_0<0,\end{cases}
 \quad A_\infty=\begin{cases}A&r_\infty\geq0,\\0&r_\infty<0.\end{cases}       \tag{6}
\]

When both endpoint sections extend, (6) has one invariant global section;
when neither extends, it has one invariant obstruction; and when exactly one
extends it is acyclic.  Thus its quasi-isomorphism type changes only at
`r_0=0` or `r_infty=0`.  For an affine clutching tail the two exponents are
affine functions of the tail coordinate.  This is exactly the finite
zero-mode threshold set used in the manuscript.  The vector-bundle formula
(3) is the filtration-valued version of (6).

As a nonlinear sanity check, take the standard action on `P^1` and the fixed
power map `u_a(z)=z^a`, `a>0`.  The induced invariant tangent deformation is
the monomial of exponent `a`; evaluation at `z=1` sends it to the same tangent
vector for every `a`.  Hence the fixed tangent line is canonically constant,
although the moving tangent spectrum grows with `a`.  This is precisely the
separation used above.

## What the proof uses and does not use

The proof uses only:

1. the rank-one clutching classification and large-area stability in
   Woodward's Lemmas 9.8--9.9 and Corollary 9.10;
2. fixed graph type, ordinary bubble degree, stabilizer congruence, and the
   removal of finitely many zero-mode thresholds;
3. the derived intersection (1) and its elementary invariant Cech complex
   (3).

It does not use Gonz\'alez--Woodward's Picard-shift lemma, a global
identification of different gauged-map moduli spaces, or a Mellin--Barnes
continuation theorem.  It also explains why the statement is special to the
rank-one cobordism group: for a higher-dimensional torus, changing a
cocharacter can cross infinitely many directions only after the problem is
reduced ray by ray through a finite chamber fan.

## First hostile checks

1. **Multiple covers.**  The parametrized principal component has no domain
   automorphisms.  Replacing `a` by a larger integer changes a multiple cover
   of the same orbit but does not introduce deck automorphisms.  The residual
   stabilizer is the stabilizer of `x`; the congruence split fixes its inertia
   action.
2. **Changing attracting limits.**  For a one-dimensional torus the limit is
   constant on each sign ray.  A change occurs only at sign zero, already a
   threshold.
3. **Fixed modes.**  Pullbacks such as `H^0(P^1,O(n))` can contain a fixed
   monomial for every large `n`; this is not a counterexample.  Evaluation at
   `1` identifies that monomial across the tail.  The issue is a change in
   the invariant subcomplex, which occurs only when a boundary weight crosses
   zero.
4. **Stable bubbles.**  A bubble may leave `U`, so common-open support alone
   does not identify the full moduli problem.  The clutching factorization is
   needed: after ordinary degree and graph type are fixed, the entire bubble
   moduli factor is independent of the affine cocharacter.
5. **Nonlinear target.**  No linear coordinates on `W` are required on the
   open orbit.  The proof must use the equivariant tangent complex and its
   extension inequalities, not coordinatewise multiplication of sections.
6. **Derived compatibility.**  Equality of K-classes is insufficient for the
   current strong hypothesis.  Formula (1) is induced by the universal
   restriction maps and evaluation at `1`, so its quasi-isomorphism commutes
   with the fixed POT morphism rather than merely preserving its source.
7. **Two endpoint exponents.**  The affine tail changes a pair
   `(a_-(j),a_+(j))`, not a single cover degree.  The argument is applied to
   the two endpoint filtrations simultaneously.  Sign and zero-mode
   thresholds for both affine functions are removed, and the stabilizer
   congruence fixes both inertia labels.
8. **Unstable irreducible type.**  There are no attached stable-map, node, or
   attaching-point terms.  Formula (1) applied to the principal tangent
   complex is the whole fixed comparison, so the same proof applies with
   Woodward's unstable normal convention.
9. **Orbifold clutching.**  On the `k`-fold cover, take the residual
   `mu_k`-equivariant part of (1).  The congruence split fixes
   `phi_a(theta)`, so the fixed subbundle, twisted-sector evaluation, and
   inertia gluing are identical on the tail.  Exactness is preserved because
   `mu_k` is linearly reductive over `C`.
10. **Bulk and input derivatives.**  Differentiation only adds marked
    ordinary stable-map factors and evaluation classes.  At each fixed Artin
    level and marking type these factors and evaluations are the same, so the
    comparison commutes with polarization, bulk differentiation, and Artin
    reduction.

## Audit result

The proof has four logically separate parts.

| obligation | result | reason |
| --- | --- | --- |
| fixed clutching stack and evaluations | pass | same endpoint signs give the same attracting loci and limit maps; congruence fixes inertia |
| fixed deformation complex | pass | derived-intersection tangent complex (2), equivalently invariant Cech formula (3) and attracting-tangent complex (5) |
| POT morphism and virtual class | pass | Woodward's Definition 7.13 constructs the POT from the dual of this derived pushforward; the comparison is induced by the universal restriction and evaluation maps |
| bubbles, automorphisms, and Artin reduction | pass | fixed ordinary degree and graph type leave the stable-map factors unchanged; the principal component is parametrized and the residual stabilizer is fixed |

The large-area semistability, proper Deligne--Mumford, and perfect-obstruction-
theory assumptions are not proved here; they are the standing hypotheses at
the start of Section 8 of the manuscript.  Within that stated scope, no extra
tailwise derived hypothesis remains.  The argument says nothing about the
marked Stokes comparison across the finite thresholds.

## Falsifier

The route fails if there is a smooth projective `G_m`-variety, a fixed graph
type, and two cocharacters in one sign/congruence tail such that the invariant
deformation complexes of the corresponding clutching sections are not
quasi-isomorphic after the declared zero-mode thresholds are removed.  The
smallest test is a non-linear orbit closure in a smooth projective surface or
threefold with unequal normal weights at its two limits.

## Source boundary

- Woodward, *Quantum Kirwan morphism and Gromov--Witten invariants of
  quotients III*, arXiv:1408.5869v7, Definition 7.13, Lemmas 9.8--9.9,
  Corollary 9.10, equations (54)--(60), and Examples 9.11 and 9.15; cached PDF SHA-256
  `5aa794f4d83dd8d127aab769d95a71a4691d7a35d220e81ca73c5b8bb360ea51`.
- Gonz\'alez--Woodward, *A wall-crossing formula for Gromov--Witten
  invariants under variation of GIT quotient*, arXiv:1208.1727v7,
  Lemma 4.5; cached PDF SHA-256
  `2c99203c8e1d7dd373112629bbfac0760e7a3812d348e9110a1eb2b894d9d84c`.
  Its Picard-shift identification assumes the shifting subgroup acts
  trivially on the fixed target and is an analogue, not a proof of the lemma
  above.

## Current verdict

The common-open `K`-theory quotient is a valid sufficient shadow, but the
clutching formula gives more.  On a one-dimensional torus, the classical fixed
stack is constant on every sign/congruence tail, and the invariant Cech
complex proves constancy of its fixed deformation theory between zero-mode
thresholds.  The line-bundle model verifies the threshold set, while the
universal-section construction upgrades the comparison from a K-class
identity to an isomorphism of fixed perfect obstruction theories.  The first
manuscript hypothesis is therefore closed by an algebraic rank-one clutching
argument.  This does not touch the second, Stokes-theoretic marked-threshold
hypothesis.

## Mystery ledger

- **Settled:** changing the affine clutching degree inside one
  sign/congruence tail does not change the fixed stack, the invariant
  deformation complex, the fixed POT morphism, or the virtual class.  The
  common-open quotient shadow was weaker than necessary.
- **Settled:** the zero-mode threshold list is the exact list on which the
  invariant Cech complex can change; formula (6) supplies the local model.
- **Open:** the elementary exact triangle at a zero-mode crossing may help
  construct the corresponding marked nearby-cycle map, but it does not by
  itself control the Stokes filtration or preserve the Gamma point row.  This
  belongs to the marked-threshold problem.
- **Open:** sign and stability thresholds change attracting or semistable
  geometry and still require the marked cyclic `z`-module comparison.  The
  bilateral rational counterexample shows that the two tail recurrences do
  not determine it.
- **Evidence boundary:** large-area semistability, properness, and existence
  of the gauged-map POT are the standing Section 8 assumptions and Woodward's
  input, not conclusions of this note.
