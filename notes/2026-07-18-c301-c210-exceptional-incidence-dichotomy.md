# C301: exceptional-incidence dichotomy for bounded-degree full layers

**Lane**: `relconic`

Date: 2026-07-18.

## Result

The exceptional-cover analogy has a precise useful part, but the C210 collision relation is not
itself an exceptional cover in the standard sense.

An exceptional cover `f : X -> Y` is a finite generically etale map for which the diagonal is the
only base-field-defined geometrically irreducible component of `X times_Y X`.  Its arithmetic
content is injectivity, hence bijectivity, on rational points over an infinite set of extensions.
The C210 collision scheme instead asks an arbitrary three-layer incidence relation to have **no**
rational point.  No self-fiber-product, separated-variable, or finite-map presentation of that
relation has been proved.  Therefore the classified exceptional-polynomial and exceptional-cover
types cannot simply be assigned to C210 from the degrees of its two projections.

What does transfer is the underlying Frobenius-component obstruction.  This report proves the
first applicable full-layer theorem.

> **Bounded-degree full-layer dichotomy.**  Let an ordered three-layer collision component over
> `F_q` have a projective model of bidegree at most `(m,n)` in `P1 times P1`.  Suppose its
> normalization maps to the three full layer-parameter lines with degrees
> `delta_1,delta_2,delta_3`, and remove at most `B` normalization points for projective boundary,
> repeated selected points, singular identifications, and reconstruction failures.  Then either
>
> 1. there is a Frobenius-fixed geometrically irreducible genuine component, in which case it
>    supplies at least
>
>        N = q+1-2*(m-1)*(n-1)*sqrt(q)-B
>
>    ordered genuine collisions, a matching of size at least
>
>        ceil(N/(delta_1+delta_2+delta_3-2)),
>
>    and a transversal lower bound `ceil(N/max(delta_i))` whenever `N>0`; or
> 2. every genuine noncollapsed geometric component is moved by Frobenius, or there is no such
>    component.  This is the exact exceptional-incidence alternative; it is a component-descent
>    condition, not exceptional-cover monodromy.

At the C210 bidegree `(6,4)`, there are at most four genuine noncollapsed geometric components.
Consequently the only fixed-point-free Frobenius cycle types are

    (2), (3), (4), (2,2),

apart from the empty/degenerate case.  For a fixed-coefficient scalar extension through every odd
relative degree, the `3`-cycle is also impossible: Frobenius cubed fixes it.  Thus the only
component-exceptional types capable of evading the theorem on every odd layer are

    (2), (4), (2,2),

or the absence of a genuine noncollapsed curve.  Through **all** relative extension degrees no
nonempty type survives, since a common multiple of the component-orbit lengths fixes every
component.

For C210 itself, C298 has already proved that the generic collision component is base-defined,
geometrically integral, and has all three projection degrees at most nine, after exact removal of
the repeated-point components and projection collapses.  Taking `(m,n)=(6,4)`, `B=10`, and
`delta_i<=9` recovers

    N >= q+1-30*sqrt(q)-10,
    nu >= ceil(N/25),
    tau >= ceil(N/9).

The explicit factorization strata likewise have a base-defined genuine component except at the
two terminal stars isolated by C298.  Those stars belong to the projection-collapse alternative,
not to an exceptional monodromy class.  Hence no unclassified exceptional-cover type remains
inside the certified C210 slice.

This is a broad theorem for bounded-degree algebraic full layers whenever one genuine component
descends to the field of definition.  It is not a classification of arbitrary fresh coefficient
choices in each field: such a family may move among the fixed-point-free component types.

## 1. The standard exceptional-cover framework

Let `k=F_q`.  Guralnick--Tucker--Zieve define a finite, generically etale morphism

    f : X -> Y

of normal geometrically irreducible `k`-varieties to be exceptional when the diagonal is the only
geometrically irreducible component of `X times_Y X` defined over `k`.  Their theorem gives a
bijection `X(k) -> Y(k)` for an exceptional cover.  For curves they also prove an explicit converse
from injectivity when `q` is sufficiently large relative to the cover degree and source genus.

For a polynomial `f`, the off-diagonal fiber product is represented by

    (f(x)-f(y))/(x-y)=0.

Thus its lack of base-defined absolutely irreducible components is exactly the obstruction to
non-diagonal pairs with `f(x)=f(y)`.  This is the legitimate source of the analogy in the C210
synthesis.

Fried's broader terminology does not erase the direction of the maps.  A pr-exceptional
correspondence `W subset X_1 times X_2` requires both finite projections `W -> X_i` to be
pr-exceptional covers; the motivating examples come from Davenport pairs and equality of ranges.
The bare statement that `W(k)` is empty is not that definition.

The C210 collision relation has three layer parameters and is defined by collinearity.  Its
primitive eliminated model is a curve in two parameters, with the third reconstructed rationally.
The desired arc condition is

    collision relation has no genuine k-point.

There is currently no cover `f` for which this relation is the off-diagonal part of
`X times_Y X`, and no pair of covers whose fiber product is the collision curve.  In particular,
projection degrees alone do not define arithmetic or geometric monodromy groups of the kind used
in the exceptional-cover classifications.

### A bidegree obstruction to the naive identification

For a degree-`d` rational self-cover of `P1`, the off-diagonal divisor in
`P1 times P1` has symmetric bidegree `(d-1,d-1)`.  Separate changes of coordinate in the two
parameter lines preserve that bidegree.  C298 records the generic primitive C210 collision cover
with exact degrees six and four in its two natural parameters.  Its bidegree `(6,4)` is asymmetric,
so it is not an off-diagonal self-fiber product in the layer projections.

A new birational quotient or separated-variable presentation could change this conclusion, but
it would be a new theorem and would have to preserve the three layer-vertex maps used by C298.
None is supplied by C210 or C297.  Exceptional-cover classification is therefore not a substitute
for the component and projection audits already completed.

## 2. What the low-degree classifications actually allow

The degree audit is still useful as a boundary on any future cover presentation.  For a separable
indecomposable exceptional polynomial in characteristic two, the Guralnick--Rosenberg--Zieve
classification theorem gives three monodromy possibilities:

1. prime degree different from the characteristic, with solvable arithmetic monodromy;
2. degree `2^e`, with a normal elementary abelian subgroup of order `2^e`;
3. degree `2^e*(2^e-1)/2`, for odd `e>1`, with projective-linear semilinear monodromy.

At degrees at most six this has the following exact consequence.

- Indecomposable degrees `3` and `5` are the prime solvable case and, up to linear equivalence,
  give the classical Dickson/monomial types.
- Degree `4` is the affine `2`-power case.  Additive and subadditive examples lie here, but the
  cited general theorem explicitly does not claim a complete classification of every positive-
  genus affine-monodromy case.
- There is no indecomposable degree-`6` case.  A decomposable separable exceptional polynomial of
  degree six would have degree factors two and three, but a separable quadratic in characteristic
  two is not exceptional: after linear changes its difference has a base-defined off-diagonal
  line.  Since a composition is exceptional only when both factors are exceptional, degree six
  is excluded.
- The first characteristic-two projective-linear family in case 3 has `e=3` and degree `28`.
  No such `PSL_2/PGL_2` type can occur at the C210 projection degrees.

This list is a polynomial-cover statement, not a classification of arbitrary rational covers or
arbitrary bidegree-`(6,4)` relations.  In particular, the affine degree-four possibility cannot be
discarded for a future quotient merely from its degree.  The present C210 relation needs no such
discarding because it has no cover presentation to which that list applies, and its actual
components are already classified directly.

## 3. The component-exceptional definition

Let `D` be the reduced projective collision divisor in `P1 times P1`, defined over `k`.  Its two
coordinates are any lossless pair of collision parameters.  On the normalization of each
geometric irreducible component, let

    phi_i : D_tilde -> P1,       i=1,2,3,

be the three ordered layer-parameter maps, including rational reconstruction where necessary.
Fix a closed bad locus `Z` containing:

- projective boundary points not representing finite layer parameters;
- poles or zero denominators in reconstruction;
- repeated selected points and non-genuine resultant components;
- singular preimages at which normalization points could encode the same ordered triple.

A geometric component is **genuine noncollapsed** when it is not contained in `Z` and all three
`phi_i` are nonconstant.  Write `Omega` for this finite set of components.  Geometric Frobenius
acts on `Omega`.

The collision divisor is **component-exceptional over `k`** when `Omega` is nonempty and
Frobenius fixes no member of `Omega`.  This local term records exactly the point-supply
obstruction used here.  It does not
assert that either projection is exceptional, pr-exceptional, injective, or surjective.

The remaining alternatives have geometric meaning already visible in C298:

- `Omega` is empty because every component is repeated, vertical, or otherwise degenerate;
- a component is genuine but one layer map is constant, producing a star or another concentrated
  collision family;
- `Omega` is nonempty but Frobenius permutes its members without a fixed component;
- a member of `Omega` is Frobenius-fixed and supplies the ordinary Hasse--Weil regime.

These cases are invariant under C297's genuine projective quotient.  A projectivity transports
components and conjugates the parameter maps; repair or seed interchange only relabels them.
Finite-field automorphisms commute with the cyclic Frobenius action up to the same relabeling, so
the component orbit lengths are also invariant under C297's semilinear quotient.  Equation gauge
does not change the reduced collision divisor.

## 4. Bounded-degree full-layer theorem

### Theorem 4.1

Let `D/k` be a reduced divisor of bidegree at most `(m,n)` in
`P1 times P1`, and let `Gamma` be a Frobenius-fixed genuine noncollapsed geometric component.
Let `C -> Gamma` be its normalization.  Assume:

1. the three layer maps `phi_i : C -> P1` have degrees at most `delta_i`;
2. after deleting a set `Z_C` of at most `B` geometric normalization points, every retained
   `k`-point encodes one distinct ordered genuine collision.

Put

    g0=(m-1)*(n-1),
    N=q+1-2*g0*sqrt(q)-B.

If `N>0`, the ordered collision hypergraph has at least `N` edges from `Gamma`, matching number

    nu >= ceil(N/(delta_1+delta_2+delta_3-2)),

and transversal number

    tau >= ceil(N/max(delta_1,delta_2,delta_3)).

#### Proof

Because `Gamma` is invariant under Frobenius, it descends to a geometrically integral curve over
`k`; so does its normalization `C`.  An integral bidegree-`(a,b)` divisor in
`P1 times P1` has arithmetic genus `(a-1)(b-1)`, and normalization can only lower genus.  Since
`a<=m` and `b<=n`,

    genus(C) <= (m-1)*(n-1)=g0.

Hasse--Weil gives

    #C(k) >= q+1-2*g0*sqrt(q).

Deleting `Z_C` leaves at least `N` distinct ordered genuine collisions by assumption 2.

A fixed vertex in layer `i` has at most `delta_i` preimages under `phi_i`, counted even with
geometric multiplicity.  Hence one selected edge meets at most

    1 + (delta_1-1)+(delta_2-1)+(delta_3-1)
      = delta_1+delta_2+delta_3-2

edges including itself.  Greedy selection proves the matching bound.  One vertex covers at most
`max(delta_i)` edges, so every transversal covering all `N` edges has at least the stated size.
This proves the theorem.

### Corollary 4.2: the dichotomy

Under the same bounded-degree and bounded-deletion hypotheses, exactly one of the following holds:

1. The divisor has a Frobenius-fixed genuine noncollapsed component and Theorem 4.1 applies once
   `N>0`.
2. The divisor is component-exceptional.
3. Every remaining genuine component is projection-collapsed, or there is no genuine component.

The alternatives are exhaustive by the Frobenius action on the geometric components and the
definition of `Omega`.

This is uniform in the coefficients: it applies separately to every field and every specialization
for which the displayed degree, projection, and deletion bounds hold.  What is not uniform is
which exceptional orbit type a freshly chosen specialization may occupy.

## 5. Exact Frobenius types at bidegree `(6,4)`

Write the bidegree of a geometric component as `(a_j,b_j)`.  Every genuine noncollapsed component
has `a_j>=1` and `b_j>=1`.  Since component bidegrees add inside the reduced divisor,

    #Omega <= min(sum a_j, sum b_j) <= min(6,4)=4.

If Frobenius has no fixed component, its permutation of `Omega` has no `1`-cycle.  On at most four
objects, the complete list is

    (2), (3), (4), (2,2).

This component-cycle list is the full classification at the actual level of generality of C301.
It is independent of any unproved finite-cover representation.

### Fixed coefficients over extension towers

Now suppose the collision divisor and its component set are defined over a fixed finite field
`k0`, and pass to `k_m/k0` of relative degree `m`.  If a component has `k0`-Frobenius orbit length
`ell`, then it is fixed by the `k_m` Frobenius exactly when `ell` divides `m`.

- Over the full tower, choose arbitrarily large multiples of the least common multiple of the
  orbit lengths.  Every component then descends, and Theorem 4.1 applies to every genuine
  noncollapsed component once the field is large enough.  A nonempty fixed bounded-degree
  collision divisor cannot remain collision-free on all extensions.
- Over all odd relative degrees, any orbit of odd length eventually descends: length one descends
  immediately and length three descends at every odd multiple of three.  Therefore survival of
  the component-descent obstruction through the whole odd tower requires all orbit lengths even.
  At bidegree `(6,4)` this leaves only `(2)`, `(4)`, and `(2,2)`.

This theorem closes the fixed-coefficient full-layer question at the component level.  It does not
close families whose coefficients are selected anew in every larger field, nor components whose
layer projections collapse.

## 6. Application to C210 and the C297 quotient

C297 proves that C210 is a codimension-three slice of the natural constant-p quadratic family and
gives the exact projective and semilinear quotients.  C301 does not enlarge C210's obstruction to
the omitted moduli.  Instead it identifies a quotient-invariant test that applies to any future
specialization in that larger family:

1. form the reduced collision divisor in lossless layer coordinates;
2. remove repeated and reconstruction components;
3. classify Frobenius orbits on genuine noncollapsed components;
4. if one component is fixed, use Theorem 4.1 rather than invoking exceptional-cover
   classification;
5. only fixed-point-free component types or projection collapse survive to a deeper monodromy or
   coverage analysis.

Inside C210, C298 supplies stronger exact data than the abstract theorem requires:

- generic bidegree at most `(6,4)` and normalization genus at most `15`;
- all three layer-map fiber degrees at most nine;
- unique ordered-triple reconstruction off the certified bad locus;
- at most ten generic boundary deletions;
- exact classification of every constant-coordinate component.

Theorem 4.1 therefore reproduces C298's generic linear matching and transversal bounds with

    N=q+1-30*sqrt(q)-10,
    nu>=ceil(N/25),
    tau>=ceil(N/9).

On every noncollapsed factorization or degenerate stratum, C298 and the underlying C210 reports
exhibit a base-defined genuine component and sharper point bounds.  These are alternative 1 of the
dichotomy.  At the two terminal overlaps,

    a=0, e=0,       delta=b=p, w in {0,1}, h0=0,
    a=0, e=delta=p, delta=b=p, w in {0,1}, h0=p^2,

the sole genuine component is a star with one constant repair coordinate.  These are alternative
3, projection collapse.  They are not exceptional covers and have no hidden fixed-point-free
component type: they contain `q-1` rational collision edges, concentrated on one repair vertex.

Thus C210 has no remaining exceptional-incidence case.  Its generic and split components descend;
its only failure of the broad robust conclusion is the already known terminal projection collapse.

## 7. Consumer-ready interface

For a new bounded-degree full-layer architecture, C301 exports the following gate.

> Produce a lossless projective collision divisor, the Frobenius permutation of its genuine
> noncollapsed geometric components, degree bounds for the three vertex maps, and one uniform
> deletion bound.  A fixed component immediately gives Hasse--Weil point supply and linear
> matching/transversal bounds.  At bidegree `(6,4)`, only component cycles `(2)`, `(3)`, `(4)`, and
> `(2,2)` require further descent analysis; on an all-odd scalar tower only `(2)`, `(4)`, and
> `(2,2)` can persist.

This interface is ready for C304's omitted-moduli and alternative-function pilots.  It tells C304
exactly what must be exceptional before any coefficient search is justified.  C303 still requires
C302's coverage identity: C301 proves collision abundance, not retained relative completeness
after deletion.

## Literature and evidence boundary

The primary literature read for this report is:

- Robert M. Guralnick, Thomas J. Tucker, and Michael E. Zieve,
  [*Exceptional covers and bijections on rational points*](https://arxiv.org/abs/math/0511276),
  IMRN 2007, Art. rnm004, for the diagonal-component definition, rational-point bijection, and
  explicit curve converse.  Cached key `arXiv:math/0511276`, PDF SHA-256
  `25f0d5fe4af34992749cc61136844886ee098dd7fc8e1d17f03157a1df6d2db4`.
- Michael D. Fried,
  [*The place of exceptional covers among all diophantine relations*](https://arxiv.org/abs/0910.3331),
  for exceptional towers, Davenport-pair fiber products, and the definition of pr-exceptional
  correspondences.  Cached key `arXiv:0910.3331`, PDF SHA-256
  `579c048fd677df7148947f89ad36db175a655e39c1263b387bd07b994a9b4b77`.
- Robert M. Guralnick, Joel E. Rosenberg, and Michael E. Zieve,
  [*A new family of exceptional polynomials in characteristic two*](https://arxiv.org/abs/0707.1837),
  Ann. of Math. 172 (2010), 1361--1390, for the indecomposable exceptional-polynomial monodromy
  alternatives and the characteristic-two projective-linear family.  Cached key
  `arXiv:0707.1837`, PDF SHA-256
  `b55fc3d373e2ce23dff32e6300091c423ee618837547c2a16d6bc54ccedd3ff7`.

The literature conclusion is bounded: the standard exceptional-cover theory applies only after a
finite cover or pr-exceptional correspondence has been constructed.  This report does not claim a
classification of arbitrary rational exceptional maps of degrees four or six.  The low-degree list
above is explicitly the polynomial boundary of the cited theorem.

The new theorem is a direct proof from Frobenius descent, the genus formula on
`P1 times P1`, Hasse--Weil, and elementary hypergraph estimates.  It introduces no computation or
generated artifact.  Its C210 application consumes the committed exact component, projection, and
genuineness audits in
[`2026-07-18-c298-c210-robust-collision-matching.md`](2026-07-18-c298-c210-robust-collision-matching.md)
and the exact quotient in
[`2026-07-18-c297-c210-normal-form-moduli.md`](2026-07-18-c297-c210-normal-form-moduli.md).

It does **not** prove:

- that every bounded-degree layered collision relation is a fiber product of covers;
- that fixed-point-free component types actually occur in the omitted C297 moduli;
- that fresh per-field coefficients cannot remain in such types;
- that a collision-free partial domain remains relatively complete;
- a global nonexistence theorem for `C`-complete `O(sqrt(q))` arcs.

## Vibe check

This is a good narrowing result.  The hoped-for direct import of exceptional-cover classification
does not exist, but the failure is informative rather than deflationary: the correct obstruction is
much simpler and already proves a broad full-layer theorem.  Future work has only a four-type
Frobenius descent problem at C210's bidegree, with three types on the odd tower, plus the explicitly
separate projection-collapse gate.
