# C386--C387 — adjacent mappings after the C382 `E8` stop

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** two successors allocated; neither inherits a positive `E8` comparison claim

## Decision summary

C382 proves that C381's marked Picard family and the natural icosian lattice do not admit the
required equivariant comparison.  A second tempting route—putting the 132 matched configurations
inside the 135-element `W(E8)/W(D8)` set—also cannot retain full `PGL_2(11)` symmetry: the latter
would require a faithful characteristic-two representation in dimension eight, below the known
minimum dimension ten.

Two structurally different mappings remain worth bounded tests:

1. C386 replaces `E8/2E8` by the canonical ten-dimensional deleted permutation module on C379's
   twelve child-conic points.  Perfect matchings then produce maximal singular four-spaces without
   any Picard marking.
2. C387 first uses the canonical `S5`-invariant quadric section of the Clebsch cubic—Bring's
   genus-four curve—as a smooth theta-characteristic control.  It then asks whether the same
   dictionary has a canonical limit on C381's worse-than-weak matched degeneration.  Only an
   exact compatibility or canonical limit could turn the `D8` avatar into intrinsic geometry
   rather than a chosen lattice marking.

The lower-symmetry `A5` residue and the bare `132+3=135` coincidence are parked in the crowns
discovery companion, not allocated.

## Common finite orthogonal calculation

Let `Omega` be the twelve child-conic points and define

```text
V = {x in F_2^Omega : sum x_i = 0} / <1_Omega>.
```

Then `dim(V)=10`, and

```text
q([x]) = wt(x)/2 mod 2
```

is well-defined because every representative has even weight and complementing in length twelve
does not change `q`.  Its polar form is the ordinary mod-two dot product.  Exactly

```text
(binom(12,2) + binom(12,6) + binom(12,10))/2 = 528
```

classes have `q=1`, so `V` has orthogonal minus type and Witt index four.

For a perfect matching `M={e_1,...,e_6}` of `K_12`, view every edge as its weight-two vector in
`V`.  The six edge vectors are mutually orthogonal for the polar form and have the single relation
`e_1+...+e_6=1_Omega=0` in `V`.  Their span `L_M` has dimension five, and `q` restricts to the
nonzero linear functional recording the parity of the number of selected edges.  Therefore

```text
U_M = ker(q|L_M)
```

is a canonical maximal totally singular four-space.  This construction is functorial for every
permutation of `Omega`; in particular it preserves the full finite-geometry action on the child.

This elementary map is already better founded than the `E8` comparison: source and target live on
the same twelve-point object, and no choice of Picard basis, smoothing, or lattice isometry occurs.
What remains unknown is whether the resulting 22-space configuration says anything beyond C379's
matching/biplane theorem.

It also has a canonical candidate for the **full 132-configuration map**.  A matched C381
configuration is exactly a flag `(M,e)` consisting of one of the 22 parent matchings and one of its
six edges.  Since `q(e)=1`, the edge point lies in `L_M` but outside `U_M`, and

```text
(M,e) |--> (U_M,[e]),             L_M = <U_M,e>
```

is equivariant for the full permutation action on the twelve child points.  Thus combining the
matching subspace with the selected edge bypasses the eight-dimensional faithful-representation
obstruction and gives the right cardinality without adding three exceptional points.  C386 must
still prove that these 132 flags are distinct/intrinsic and that their geometry is not merely the
original matching incidence in orthogonal notation.

## What is special about C381's particular `D8<E8` decoration

The bare embedding is not special enough: C382 finds one Weyl orbit of `D8` embeddings in `E8`,
and one `W(D8)` orbit of the inherited unordered `A2` marking.  The effective geometry retains a
strictly richer decoration that the C382 comparison discarded.

Write the seven points on the exceptional conic as `S` and the remaining blown-up point as `r`.
For each `i in S`, the directly effective conic root and reducible singular-cubic root are

```text
c_i = 2H - sum_(j in S, j != i) E_j,
d_i = 3H - 2E_i - sum_(j != i) E_j.
```

Within either seven-set, every distinct pair has intersection `-1`.  Across the sets,
`c_i.d_j=0` exactly when `i=j` and is `-1` otherwise.  Thus the fourteen effective roots carry a
canonical perfect orthogonality matching.  More strongly, all seven matched pairs have the same
sum

```text
c_i + d_i = w = 5H - 2 sum_(j in S) E_j - E_r,       w^2 = -4.
```

So this C381 realization selects a norm-four lift `w` together with seven decompositions
`w=c_i+d_i`, not merely a singular mod-two class or an abstract `D8` subsystem.  This does not yet
prove a new Weyl orbit—the decorated object may still be standard—but it supplies the sharp datum
for C387 to seek in theta/tritangent geometry.

## C386 — canonical `O_10^-(2)` matching code

**Goal.** Determine the exact orthogonal geometry of the 22 spaces `U_M` attached to C379's parent
matchings and require an intrinsic or operational consequence beyond relabelling the known two
one-factorizations.

### Cheap gate

Construct the 22 spaces directly from C379's frozen matchings and certify:

1. their distinctness, dimensions, singularity, and complete intersection spectrum;
   likewise certify the 132 flags `(U_M,[e])` and their pairwise relation spectrum;
2. their `A5`, `PSL_2(11)`, and `PGL_2(11)` orbits and the action of the golden `J`;
3. the automorphism group of the unlabelled 22-space configuration inside the natural orthogonal
   or semilinear category;
4. whether `U_M`, together with the intrinsic weight-two orbit of `V`, recovers `M`; and
5. the resulting constant-dimension-code parameters and distance distribution.

### C492 six-stratum hand-back (2026-07-23)

C386 uses the same H3 `22`-matching `PGL_2(11)`-set as C434/C492.  Before computing or naming a new
association scheme, base at the frozen golden pair and evaluate every proposed orthogonal
intersection invariant on C492's six `K`-orbits.  The reference partition has three strata per
sheet, with orbit sizes `1,4,6`, Mackey matrix `[[2,1],[1,2]]`, and cross cells `K/C2`.

This gives an exact novelty and stop discriminator:

1. if the complete `U_M` intersection code is constant precisely on the existing
   `(sheet,D')` fibres, then it only renames C434's shared-edge information and C386 stops;
2. if it strictly splits a C492 stratum, record the least split stratum and the orthogonal
   invariant responsible before any full association-scheme claim;
3. if it merges C492 strata, identify the lost sheet/profile coordinate and do not claim intrinsic
   matching recovery; and
4. for reconstruction on a cross cell, use the exact homogeneous decoration `K/C2`; an arbitrary
   `K` label overstates the required information.

The Mackey--swap row-sum lemma certifies the six-count without a new orbit census, but it does not
certify that orthogonal data realizes those fibres.  That fibre comparison is C386's cheap gate.
See `notes/2026-07-22-c492-c434-conceptual-refoundation.md`.

Stop if spaces collide, the construction forgets the matching, the stabilizer is not the claimed
full group, or the subspace data merely rename the already certified share-edge/disjoint biplane
incidence.

### Full theorem gate

Proceed only if at least one of the following survives:

- the unlabelled subspace configuration intrinsically recovers the twelve child points, both
  eleven-parent sheets, and the C379 matchings;
- its exact orthogonal stabilizer is `PGL_2(11)` and its intersection relations produce a new
  association scheme, packing, or two-orbit design not already equivalent to the biplane; or
- it yields a concrete subspace-code decoding, erasure, or network-coding property that depends on
  the Clebsch configuration rather than only on generic perfect matchings.

Any optimality, novelty, or best-known-code claim requires a primary and forward-citation audit of
constant-dimension codes, orthogonal Grassmannians, matching embeddings, and `PGL_2(11)` subspace
orbits.  Exact finite claims require a deterministic checker/JSON/replay/checksum bundle.

## C387 — Bring/Bertini theta `D8` bridge

**Goal.** Test whether the Clebsch--Bring theta geometry canonically realizes C381's decorated
norm-four lift and, if the smooth control passes, whether the matched worse-than-weak blow-up has a
canonical limiting genus-four spin object representing the same marked `D8<E8` data.

For a genuine degree-one del Pezzo surface, the Bertini construction and the genus-four
theta-characteristic model give a geometric route into the `E8/2E8` quadratic space.  C381's
matched surface is not weak degree one: its seven-point conic has anticanonical degree `-1`.

There is a cheaper smooth control already on the Clebsch side.  Intersect the Clebsch diagonal
cubic with its canonical invariant quadric: the result is Bring's genus-four curve with full `S5`
automorphism group.  Its 120 odd theta characteristics are represented by tritangents, while its
136 even characteristics have the known `S5` orbit decomposition

```text
136 = 1 + 5 + 5 + 5 + 10 + 10 + 10 + 30 + 30 + 30,
```

including one `S5`-invariant characteristic.  Hence broad count/orbit claims are preempted.  The
possible gain is an exact compatibility: identify C381's `w` and its seven root decompositions
inside this theta/tritangent data, and prove that the construction recovers a C379 matching or the
golden outer action.  Bring's curve supplies only the fixed Clebsch/`S5` scale; it does not by
itself provide a full `PGL_2(11)` map on all 22 parents.

### Cheap gate

1. Reproduce the Clebsch cubic/invariant-quadric model of Bring's curve and its exact `S5` action.
2. Locate, or rule out, an intrinsic theta/tritangent avatar of the decorated packet
   `(w,{w=c_i+d_i}_{i in S})`; compare the known theta orbits before inventing a new count.
3. Test whether that avatar recovers a fixed-parent obstruction matching and transports under the
   two Clebsch contractions/golden involution at the legitimate `S5` or `A5` groupoid scale.
4. Only if the smooth control produces a nontrivial exact target, choose an explicit one-parameter
   smoothing of one matched configuration and construct the Bertini branch/spin data over the
   punctured base.
5. Determine whether the relevant theta characteristic and decorated packet have a unique stable
   limit independent of smoothing, blow-up ordering, and Picard marking; then test transport under
   the matched-pair `D10`, parent `A5` groupoid, the two `PSL_2(11)` sheets, and `J`.

Stop if the Bring comparison is only a standard count/orbit decomposition, or later on
non-uniqueness, smoothing dependence, failure of an admissible spin compactification to contain
this degeneration, or recovery of only the abstract `C2` glue class.

### Full theorem gate

Proceed only if the limit is canonical and yields a stricter consequence: for example, intrinsic
recovery of the obstruction matching from stable spin data, a geometric explanation of the golden
sheet exchange, or a sharp obstruction proving why the matched degeneration lies outside the
weak-degree-one compactification stratum.  A standard restatement of the 120 odd/136 even
genus-four theta count is red.

The literature gate begins with the existing complete theta-orbit classification for Bring's
curve, then reads primary work on degree-one del Pezzo Bertini models, stable spin curves/limit
theta characteristics, and relevant boundary strata before computation expands beyond one matched
pilot.  No general compactified-moduli programme or all-field claim is authorized.

## Rejected and parked routes

- **A5-only `D8` comparison:** characteristic two may erase some rational character distinctions,
  but a fixed-parent construction loses `PGL_2(11)`, the two global sheets, and the certified action
  of `J`.  It has no crown consequence without an independently natural invariant.
- **The raw `132+3=135` fit:** the 135 `D8` embeddings form the nonzero singular set of the
  eight-dimensional plus-type quadratic `E8/2E8` module.  A nontrivial 132-point orbit would force
  faithful `PSL_2(11)` action in dimension eight.  The characteristic-two representation table
  starts at dimension ten, so the full-group map cannot exist.
- **Triality, norm-four packets, and even-theta avatars alone:** these are equivalent presentations
  of the same 135-element homogeneous space.  They do not remove C382's missing common torsor.

## Source and evidence boundary

- **ATLAS of Finite Group Representations, `L_2(11)` page.** Read depth: `partial`, web page,
  representation and maximal-subgroup tables.  It lists all faithful characteristic-two
  irreducibles for `L_2(11)` and `PGL_2(11)`, with minimum dimension ten, and supplies the standard
  12- and 22-point permutation representations.
- **I. Dolgachev, _Classical Algebraic Geometry: a modern view_.** Read depth:
  `abstract/metadata only` for this allocation note; the degree-one-del-Pezzo and genus-four theta
  sections are mandatory C387 entry reading, not treated here as audited evidence.
- **H. W. Braden and L. Disney-Hogg, _Bring's curve: old and new_, Eur. J. Math. 10 (2024),
  article 3, arXiv:2208.13692.** Read depth: `substantive web full-text sections`, especially the
  canonical complete-intersection model and Theorem 5.9/Corollary 5.10 on theta orbits and the
  unique invariant characteristic.  It preempts generic Bring theta counts and supplies the C387
  control computation; the exact C381 compatibility remains open.
- **T. O. Celik, A. Kulkarni, Y. Ren, and M. S. Namin, _Tritangents and Their Space Sextics_,
  arXiv:1805.11702.** Read depth: `abstract`; it records the degree-one-del-Pezzo branch-sextic
  route, the 120 tritangent/odd-theta correspondence, and reconstruction algorithms.  Full text is
  mandatory before any C387 reconstruction claim.
- **C379--C382 local reports.** Read depth: `full text`.  They supply the exact twelve-point child,
  22 matching-decorated parents, two one-factorizations, biplane incidence, marked `D8` invariant,
  and the failed icosian category/character gate.

This note allocates bounded tests and makes no novelty claim.  C386 and C387 must create their own
atomic evidence bundles if they report computational or literature-facing conclusions.
