# C390 — Clebsch--Bring induced bridge and `E8`/Lagrangian free upgrades

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** allocated and queued; several algebraic corollaries are already formal, while the
arithmetic, triality, and novelty gates remain open

## Executive decision

C382 closes the proposed icosian comparison, but it does not exhaust the structure discovered in
C376--C381.  There are three near-free theorem upgrades and two genuinely high-value open gates.

The near-free upgrades are:

1. C381's fourteen effective roots are the canonical norm-four cap above a lift `w` of a nonzero
   singular class in `E8/2E8`.  Their seven orthogonal decompositions are the star of one vertex in
   the classical `K8` model of the associated Steiner complex.
2. A matching on twelve points canonically determines a **Lagrangian five-space** `L_M`, not only
   C386's singular four-space `U_M`.  The matching is recovered from `L_M`, and intersections of
   two such Lagrangians exactly record the alternating-cycle decomposition of the two matchings.
3. Bring's two trigonal rulings add a third realization of the same `S5/A5` chirality already seen
   in the two Clebsch blowdowns and the two golden code sheets.  Induction from a fixed `A5` parent
   to `PGL_2(11)` gives a category-correct full-family map on 264 pointed and 132 matched
   configurations.

The strongest open doors are:

- reduce the Clebsch--Bring ruling and branch data at a prime above 11 and prove that it becomes
  C379's twelve-point child conic, antipodal matching, and the two golden values `tau=4,8`; and
- compute the orthogonal centralizer/normalizer of the exact `S5` action on `J(Bring)[2]` to test
  whether `O_8^+(2)` triality explains the unexplained triples in the known theta-orbit table.

C390 owns this composition and audit.  It does **not** reopen the failed icosian isometry, assert a
`PGL_2(11)` action on one Bring curve or one `E8` lattice, or claim novelty for classical
`E8`/theta counts.

## I. Norm-four normal form behind C381

Use the positive-definite convention for the `E8` lattice.  For a norm-four vector `w`, put

```text
D_w = {x in E8 : (x,w) is even}.
```

The following is the standard norm-four normal form that C381 can now consume directly.

### Proposition 1 — parity kernel and effective cap

For every `w in E8` with `(w,w)=4`:

```text
D_w is isometric to D8.
```

Among the 240 roots of `E8`, the roots of `D_w` split by their pairing with `w` as

```text
84 with (r,w)=0,
14 with (r,w)=2,
14 with (r,w)=-2.
```

The 14-root cap

```text
C_w = {r : r^2=2 and (r,w)=2}
```

is stable under `r |-> w-r`.  That involution has no fixed point and partitions `C_w` into the
seven unordered orthogonal-root decompositions

```text
w = r + (w-r).
```

The shell and stabilizer counts are

```text
#{w in E8 : w^2=4} = 2160,
#{0 != v in E8/2E8 : q(v)=0} = 135,
2160 = 135 * 16,
Stab_W(E8)(w) = W(D7),
|W(E8):W(D7)| = 2160,
|W(D8):W(D7)| = 16.
```

Thus a nonzero singular class has 16 norm-four lifts, or eight lift-lines after identifying
`w` with `-w`.  Passing from a chosen lift to its mod-two class forgets a genuine 16-element packet;
this is precisely the information the C382 bare `D8` comparison discarded.

### C381 specialization

Return to C381's negative-definite Picard convention.  Let `S` be the seven points on the
exceptional conic and let `r` denote the remaining blown-up point.  The directly effective roots
are

```text
c_i = 2H - sum_(j in S, j != i) E_j,
d_i = 3H - 2E_i - sum_(j != i) E_j,
```

and every orthogonal pair has the common sum

```text
w = c_i+d_i = 5H - 2 sum_(j in S) E_j - E_r,    w^2=-4.
```

After reversing the sign convention, C381's fourteen effective roots are exactly `C_w`; they are
not an accidental fourteen-root subset of an abstract `D8`.  The geometric information is the
effective choice of one lift and its cap.  There is only one Weyl orbit of the underlying
norm-four vectors, so the orbit count itself is classical and not a novelty claim.

### `K8`/Steiner refinement

Fix a nonzero singular class `v in E8/2E8`.  Its eight norm-four lift-lines form the vertices of
the standard `K8` model of the corresponding Steiner complex.  The 28 unordered pairs of
orthogonal root-lines whose mod-two classes sum to `v` form its edges: a pair represented by
orthogonal roots `a,b` joins the lift-lines `[a+b]` and `[a-b]`.  A chosen lift-line is incident
with seven edges, and choosing representatives turns those seven edges into the decompositions
`w=r+s` above.

Consequently C381 selects a **pointed Steiner complex**, equivalently a `K8` star, rather than an
undecorated `D8` subsystem.  C390 must certify this identification in the exact C381 lattice basis
and state it as a normal-form lemma.  Any claim that the `K8` or Steiner complex itself is new is
red; only compatibility with the Clebsch/Bring/code geometry could be new.

## II. The stronger matching--Lagrangian theorem

Let `Omega` have `4k` elements and define

```text
V_(4k) = {x in F_2^Omega : wt(x) is even} / <1_Omega>,
q([x]) = wt(x)/2 mod 2.
```

Its polar form is induced by the ordinary mod-two dot product, and `dim V_(4k)=4k-2`.  If
`M={e_1,...,e_(2k)}` is a perfect matching, regard its edges as weight-two vectors and put

```text
L_M = span(e_1,...,e_(2k)),
U_M = ker(q|L_M).
```

### Proposition 2 — recoverable matching Lagrangian

The edge vectors have the unique relation

```text
e_1+...+e_(2k)=1_Omega=0 in V_(4k).
```

Therefore `dim L_M=2k-1`.  The polar form vanishes on `L_M`, so `L_M` is a Lagrangian subspace of
the underlying symplectic space.  The restriction of `q` is the nonzero linear functional that
records the parity of the number of selected matching edges, and hence

```text
dim U_M = 2k-2.
```

The orthogonal type of `V_(4k)` alternates with `k`; its Gauss sum is

```text
#q^(-1)(0) - #q^(-1)(1) = (-1)^k 2^(2k-1).
```

Thus the type is plus for even `k` and minus for odd `k`.  In the C379 case `4k=12`, so
`V=V_12` is `O_10^-(2)` and `U_M` is a maximal totally singular four-space.

The five-space `L_M` is stronger than `U_M`.  In the marked length-twelve coordinate model, its
`q=1` points have minimum representative weights

```text
six points of weight 2,
ten points of weight 6.
```

The six weight-two points are exactly the edges of `M`.  Hence `M |-> L_M` is injective and
`S_12`-equivariant, and it recovers the matching once the canonical weight-two coordinate orbit is
retained, without the extra flag data previously proposed for C386.  A selected edge still refines
the construction to

```text
(M,e) |-> (L_M,U_M,[e]),
```

which gives the natural linear host for C379's 132 matched configurations.

### Proposition 3 — intersection-cycle formula

For two perfect matchings `M,N`, let `c(M,N)` be the number of alternating components of the
2-regular multigraph `M union N`, counting a shared edge as a doubled 2-cycle.  Then

```text
dim(L_M intersect L_N) = c(M,N)-1.
```

Indeed, before quotienting by `<1>`, membership in both edge spans is exactly the condition that a
binary coordinate function be constant on every alternating component.  This gives dimension
`c(M,N)`; the all-one vector removes one dimension in the quotient.

For the subspace distance on five-spaces in the twelve-point case,

```text
d_S(L_M,L_N) = 10 - 2 dim(L_M intersect L_N)
             = 12 - 2c(M,N).
```

In particular,

```text
M union N is Hamiltonian  <=>  L_M intersect L_N = 0.
```

Any one-factorization of `K_(4k)` therefore gives `4k-1` Lagrangians, and it is a perfect
one-factorization exactly when those Lagrangians are pairwise disjoint.  C385's Hamiltonicity test
is equivalently a partial symplectic-spread test and a maximum-distance constant-dimension-code
test.

This is the most general free upgrade: it is independent of `q=11`, Clebsch cubics, and `E8`.
C390 must audit matching association schemes, symplectic spreads, subspace codes, and the known
perfect-one-factorization/`B`-code correspondence before assigning novelty.  The exact formula is
useful even if prior art owns the interpretation.

### Representation-theoretic payoff at `q=11`

For `G=PGL_2(11)` acting on `P^1(F_11)`, `V_12` is the natural ten-dimensional characteristic-two
host.  The action is faithful, and ten is the minimum faithful characteristic-two dimension in the
ATLAS tables.  Thus the 132 flags above live in a dimension-optimal linear representation of the
full group.  This does not contradict C382: the forbidden `E8/2E8` target had dimension eight.

C390 must reproduce the kernel and minimum-dimension comparison exactly, and C386 should be
sharpened to compute the complete `L_M` and flag configurations rather than only the kernels
`U_M`.

## III. Bring supplies a third chirality and a full induced family

The canonical model of Bring's genus-four curve is the intersection of the Clebsch diagonal cubic
with its invariant smooth quadric.  The quadric has two rulings, giving two degree-three maps to
`P^1`.  The subgroup `A5` preserves each ruling and every odd element of `S5` exchanges them.

Combining this with C376 gives the three-way identity

```text
chi_code = chi_Clebsch_blowdown = chi_Bring_ruling = sign : S5 -> C2.
```

The first equality is the C376 result; the second is the ruling theorem in Braden--Disney-Hogg.
C390 should record the composition as a corollary after checking conventions for the two golden
values.

### Fixed-parent branch matching

Fix a parent group `H=A5`.  The branch set of either trigonal map is a transitive twelve-point
`H`-set

```text
H/C5.
```

The two points fixed by each Sylow 5-subgroup form a canonical antipodal pair.  The six pairs form

```text
H/D10.
```

C379's child points and obstruction matching have the same point and pair stabilizers.  Therefore
the abstract `H`-equivariant point identification is forced up to the antipodal involution, while
the induced identification of the six pairs is canonical.  This statement is stronger and safer
than seeking individual theta characteristics: it compares the actual branch/matching group-set.

### Induction to the full golden group

Let `G=PGL_2(11)` and retain `H=A5`.  Induction gives canonical homogeneous-space identities

```text
G x_H (H/C5)  = G/C5,      size 264,
G x_H (H/D10) = G/D10,     size 132,
G/H,                         size 22.
```

These match, respectively, C379's pointed parent/child incidences, matched configurations, and
parents.  Hence the category-correct full-group target is a **22-member induced family of Bring
branch sets**, not an action of `G` on one Bring curve.  This supplies a complete abstract mapping
at the group-set level.  Geometry beyond the coset tautology requires the arithmetic gate below.

## IV. A hard no-go for direct theta-point maps

Bring's curve has a unique `S5`-invariant even theta characteristic `Delta`.  Taking `Delta` as
origin identifies the theta torsor with the plus-type quadratic space `J(Bring)[2]` of dimension
eight.  The familiar counts are

```text
even: 136 = 1 + 135 nonzero singular points,
odd:  120 nonsingular points.
```

The known `S5` orbit sizes are

```text
even: 1, 5,5,5, 10,10,10, 30,30,30,
odd:  20,20,20,60.
```

A fixed-parent matched source is the transitive `A5/D10` set of size six.  Restriction of an `S5`
orbit to its normal subgroup `A5` either stays one orbit or splits into two equal orbits.  None of
the displayed orbits can therefore contain a six-element `A5` orbit.

**No-go.** There is no injective `A5`-equivariant map from the six fixed-parent matched
configurations to individual even or odd theta characteristics of Bring's curve.

C387 must not search for such a point map.  The viable theta target is structured: a pointed
Steiner complex/`K8` star, or an induced family carrying branch and ruling data.  Even there,
classical `E8` root--tritangent correspondences and the automorphism group `W(E8)/{+-1}` are prior
art; only an exact compatibility with C381's effective cap and C379's matching remains live.

## V. High-value open gate A — golden reduction at 11

The ruling formulas in the Bring model use the golden integer `j` satisfying

```text
j^2-j-1=0.
```

Modulo 11 this polynomial splits with roots

```text
j=4 and j=8,
```

exactly C376's two golden values `tau=4,8`.  This is the clearest possible arithmetic explanation
for why Bring's two rulings might become the two Clebsch/code chiralities.

### Target theorem

Construct the Clebsch--Bring cubic, quadric, rulings, degree-three maps, and branch divisors over an
explicit golden/cyclotomic integer model.  At a specified prime above 11, prove good split
reduction and identify:

```text
the twelve reduced branch points  = C379's rational child conic,
the Sylow-C5 antipodal pairing     = C379's obstruction matching,
the two reduced rulings            = tau=4 and tau=8,
odd S5 ruling exchange             = C376's golden J/code chirality.
```

If all four identities hold, the result composes C376, C379, C381, and the Bring geometry into one
arithmetic theorem and upgrades the abstract induced `G/C5 -> G/D10 -> G/A5` diagram to actual
geometry.

### Stop rules

Stop or soften to the abstract homogeneous-space result if:

- the chosen model has bad reduction at every relevant prime above 11;
- the trigonal map or its branch divisor is nonsplit or does not yield the child conic;
- the antipodal pairing differs from C379's matching;
- the reduction identifies only an abstract `A5/C5` set with no canonical coordinate map; or
- Dye's finite-field Clebsch/conic analysis or a forward citation already proves the same
  composition.

The full text and forward citations of R. H. Dye's 1991 paper are mandatory before a novelty claim.
The finite `A5`/conic portion is the largest pre-emption risk; the combined Bring reduction,
matching, and chirality statement is the narrower possible gap.

## VI. High-value open gate B — triality and the unexplained threes

The published theta-orbit decompositions contain repeated triples:

```text
120 = 3*20 + 60,
136 = 1 + 3*(5+10+30).
```

Braden--Disney-Hogg explicitly leave the repeated "threeness" without a satisfying conceptual
explanation.  Since `J(Bring)[2]` is an eight-dimensional plus-type orthogonal space, the natural
bounded hypothesis is `D4/O_8^+(2)` triality.

### Exact gate

Using the published integral homology matrices, their exact mod-two reductions, or a reproducible
regeneration from the authors' code:

1. construct the precise subgroup `S5 < O_8^+(2)` acting on `J(Bring)[2]`;
2. compute `C_(O_8^+(2))(S5)` and `N_(O_8^+(2))(S5)/S5`;
3. test whether either contains or induces an `S3` that permutes the three size-20 odd orbits and
   the three size-5, size-10, and size-30 even orbits; and
4. if positive, lift the finite calculation to a conceptual action on the theta/tritangent or
   trigonal geometry.

A centralizer/normalizer too small to support the required permutations is a clean negative and
closes this route.  A coincidental permutation of orbit labels without an action on the geometric
objects is not a theorem.

This gate is unusually valuable because a positive result would answer an explicit observation in
recent literature rather than only repackage the local Clebsch construction.

## VII. Bertini model/category reconciliation

C387's proposed stable Bertini limit has a model-level tension that must be resolved before any
degeneration calculation:

- the standard bi-anticanonical model of a smooth degree-one del Pezzo surface has its branch curve
  on a quadric cone; but
- Bring's canonical model lies on a smooth quadric with two rulings; and
- the modular-surface literature nevertheless describes Bring's curve as a fixed curve of a
  Bertini involution on a degree-one del Pezzo model.

These statements may use a weak or singular surface, a different birational model, or different
terminology; they are not yet a contradiction.  C390 requires the primary Burns/Yang construction
to be read and the categories reconciled.  No stable-limit or compactification claim proceeds
until the precise surface, involution, branch model, and relation to the smooth canonical quadric
are explicit.

## VIII. C390 execution contract

### Dependencies

- C376: two Clebsch contractions, golden values, and code chirality;
- C379: exact twelve-point child, 22 parents, and their obstruction matchings;
- C381: effective fourteen-root cap and marked `D8<E8` degeneration;
- C382: failed icosian comparison and the group-category obstruction;
- C385: pairwise-Hamiltonicity pilot;
- C386: matching-subspace census;
- C387: Bring/theta smooth-control task.

C390 may sharpen C385--C387 but does not silently mark them complete.

### Stage 0 — ownership closure

Read primary texts and forward citations for:

- finite-field Clebsch hexagons and conics, beginning with Dye;
- `E8` norm-four shells, Steiner complexes, and genus-four tritangents;
- matching association schemes, perfect one-factorizations/`B`-codes, symplectic spreads, and
  constant-dimension codes;
- Bring theta orbits and exact `S5` homology actions; and
- degree-one del Pezzo/Bertini models containing Bring's curve.

Record exact read depth and distinguish a classical ingredient from the proposed composition.

### Stage 1 — deterministic free-upgrade certificate

Produce one exact checker and replay bundle that:

1. verifies the `E8` norm-four cap counts, parity kernel, lift packet, and the C381 `K8` star;
2. proves or exhaustively replays matching recovery and the intersection-cycle formula, with the
   general symbolic proof recorded separately from the `K12` census;
3. computes the 22 `L_M`, 22 `U_M`, and 132 flags from C379's frozen data;
4. checks the exact `A5`, `PSL_2(11)`, `PGL_2(11)`, and golden-`J` actions; and
5. certifies the subgroup chain `C5 < D10 < A5 < PGL_2(11)` and the induced homogeneous-space
   diagram.

### Stage 2 — golden arithmetic pilot

Build one exact parent over the golden integral model, reduce both rulings and their branch data at
11, and compare coordinates and pairings with C379.  Expand to the induced 22-parent family only
after this pilot passes all four identities in Section V.

### Stage 3 — triality pilot

Compute the exact orthogonal centralizer/normalizer and close either positively with a geometric
`S3` action or negatively with an order/action obstruction.  Do not infer triality from the orbit
counts alone.

### Stage 4 — theta/Bertini refinement

First certify the six-point theta no-go and the pointed-Steiner alternative.  Reconcile the
Bertini model categories.  Attempt a degeneration only if a specific smooth Bring object has
already been matched to the C381 cap and the limit problem is well-posed.

### Promotion gate

C390 earns a new paper-facing theorem only if at least one of the following survives its ownership
audit:

- the explicit golden reduction theorem of Section V;
- a geometric triality explanation of the published theta-orbit triples;
- a genuinely unrecorded general matching--Lagrangian intersection/spread theorem; or
- an induced Clebsch--Bring bridge with exact geometric content beyond homogeneous-space
  induction.

Otherwise report the free normal-form upgrades, strengthen C385--C387 accordingly, and close with
the sharpened negative boundaries.  Broad `E8`/Bring correspondences, raw `120/135/136` counts, and
the abstract coset diagram alone do not pass promotion.

## Source and evidence boundary

- H. W. Braden and L. Disney-Hogg, [*Bring's curve: old and new*](https://arxiv.org/abs/2208.13692),
  European Journal of Mathematics 10 (2024), article 3.  Read depth before allocation:
  substantive full-text sections on the complete-intersection model, trigonal rulings, homology,
  and theta orbit decompositions.  Its exact matrices/code are C390 inputs.
- R. H. Dye, [*Hexagons, Conics, `A5` and
  `PSL2(K)`*](https://academic.oup.com/jlms/article/s2-44/2/270/847669), Journal of the London
  Mathematical Society 44 (1991), 270--286.  Read depth before allocation: metadata/partial.
  Full text and forward citations are mandatory for the finite `A5`/conic ownership gate.
- L. Yang, [*Modular curves, invariant theory and
  `E8`*](https://arxiv.org/abs/1704.01735).  Read depth before allocation: substantive relevant
  sections on Bring's curve, `E8`, tritangents, and the modular/Bertini construction.  The primary
  construction it cites must be checked before resolving Section VII.
- T. O. Celik, A. Kulkarni, Y. Ren, and M. S. Namin,
  [*Tritangents and Their Space Sextics*](https://arxiv.org/abs/1805.11702).  Read depth before
  allocation: abstract.  Full text is mandatory before any reconstruction or theta-to-del-Pezzo
  claim.
- H. W. Braden and L. Disney-Hogg,
  [*Orbits of Theta Characteristics*](https://arxiv.org/abs/2404.09890), published 2025.  Read depth
  before allocation: substantive method overview; exact orbit methods and forward citations are
  mandatory for the triality gate.
- Braden--Disney-Hogg supporting code,
  [`DisneyHogg/Brings_Curve`](https://github.com/DisneyHogg/Brings_Curve).  This is an input to a
  pinned deterministic replay, not by itself a proof citation.
- ATLAS of Finite Group Representations, `L_2(11)` and `PGL_2(11)` representation tables.  Read
  depth before allocation: partial exact tables; they supply the characteristic-two
  minimum-dimension boundary, which C390 must reproduce rather than merely cite.
- C376, C379, C381, C382, and the C386--C387 allocation report.  Read depth: full local text.  They
  own the code chirality, matching data, effective cap, failed icosian comparison, and current
  successor boundaries.

This allocation note makes no novelty claim.  Every computational conclusion must ship with
canonical input, deterministic generator/checker, JSON result, replay command, and checksums.
