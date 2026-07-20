# C373 — full automorphisms and intrinsic Clebsch chirality

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `THEOREM; FULL AFFINE A5 AUTOMORPHISM GROUP; INTRINSIC UNORDERED 10+10 CHIRALITY TORSOR`

**Amendment verdict:** `GENERAL ODD-PRIME RIGIDITY PRE-EMPTED; p=2 EXCEPTION; GOLDEN-CONJUGATE OUTER-SYMMETRY PHASE EXPOSED`

**Literature depth:** zero external sources read at full text; six read partially; three at
abstract/metadata depth only.  The added search establishes a positive prior-art boundary for
general affine rigidity and records research doors, not a novelty or priority verdict.  No
forward-citation closure was run.

## Theorem

Let `V=F_11^3` and let `X` be C341/C372's rank-eight translation association scheme, with
relations in the fixed order

```text
0, column_D5, triple_S3, deep_hole_C5, double_V4,
single_secant_C2_1, single_secant_C2_2, single_secant_C2_3.
```

Then the full color-preserving vertex automorphism group is exactly

```text
Aut(X) = V semidirect (F_11^* x A5),       |Aut(X)| = 798600.
```

More strongly, this is already the full automorphism group of the single valency-60
`column_D5` constituent graph.  That constituent is canonically distinguished by its valency, so
none of the other six nontrivial colors is needed to recover the affine group or chirality torsor.

The full algebraic automorphism group is trivial: the identity is the only permutation of the
eight relations preserving every intersection number.  Consequently forgetting the displayed
names of the colors introduces no extra relation permutation.

From the abstract unmarked scheme and any chosen vertex `o`, the `column_D5` neighborhood of `o`
intrinsically splits into six connected `K_10` components.  They are exactly the six punctured
scalar lines through the parity-check columns.  The induced action of `Aut(X)_o` on these six
blocks is the degree-six `A5`; its action on their twenty three-subsets has exactly two orbits of
size ten.  Hence the scheme canonically recovers the **unordered** pair of chirality classes.  It
does not canonically name either half.

The normalizer of this degree-six `A5` in `S6` has order 120.  Its 60-element outer coset exchanges
the two ten-element classes, recovering the classical outer-`S6`/icosahedral chirality operation.
No member of that outer coset lifts to an automorphism of `X`: the full point stabilizer induces
only `A5`, and the algebraic automorphism group supplies no color-twisting escape.  Thus this
interface **recovers rather than forgets** the chirality torsor.

Two structural corollaries are free.  The column graph is a normal Cayley graph: its translation
group `V` is the normal Sylow-11 subgroup of the displayed full automorphism group, hence the unique
Sylow-11 subgroup and characteristic in `Aut(X)`.  It acts regularly, so the abstract graph recovers
the syndrome affine addition up to the unavoidable choice of an origin.  Also the affine group
`V semidirect (F_11^* x A5)` is 2-closed, because its orbital association scheme has exactly that
same full vertex automorphism group.

## Conceptual affine-rigidity proof

Write `D` for the six projective column directions and retain only the `column_D5` graph for this
argument.  C341's nonzero three-by-three minors say exactly that `D` is a six-arc: no three of its
points are collinear in `PG(2,11)`.

The maximal 11-cliques of the column graph are precisely the affine lines whose direction lies in
`D`.  Indeed, if a clique contains `x`, `x+u`, and `x+v` on three distinct candidate directions,
then `[u]`, `[v]`, and `[v-u]` are three points of `D` on the projective line spanned by `[u]` and
`[v]`, contradicting the arc property.  Thus every third vertex of a clique lies on the same
affine line, and that line already has all eleven vertices.  Scheme automorphisms therefore
preserve this six-direction partial affine geometry.

Its six parallel classes are intrinsic, not supplied labels.  Two intersecting allowed lines of
directions `d,e` generate an affine two-flat.  Because no third point of `D` lies on the projective
line `span(d,e)`, the allowed-line incidence inside that flat is exactly the `11 by 11` rook grid:
eleven `d`-lines and eleven `e`-lines, with each line in one family meeting every line in the other.

One must still exclude false transport through a skew-line transversal grid.  Take two parallel
`d`-lines separated in an allowed `e`-direction.  Their eleven pairwise-disjoint `e`-transversals
are graph-intrinsic.  If an automorphism sent the two base lines to skew lines, their eleven
pairwise-disjoint common transversals would have eleven distinct directions, all different from
the two base-line directions.  But the graph has only the six directions in `D`.  Hence the image
base lines remain parallel.  Transporting this relation across two further arc directions whose
images span `V/d` propagates each local direction component to one global parallel class.  The
column graph is connected because any three members of `D` form a vector-space basis, so every
automorphism induces one global permutation of the six classes.

Now let an automorphism fix the origin.  Choose any three directions as a basis.  Their images are
again three independent directions; compose with a linear map carrying those image directions
back to the three coordinate axes.  A bijection preserving the three coordinate-line families has
the separated form

```text
(x,y,z) |-> (f_1(x), f_2(y), f_3(z)).
```

Choose a fourth column direction.  Relative to either three-direction basis all three of its
coordinates are nonzero, again by the arc property.  Preservation of its parallel lines says that
for every step `t`, the three increments

```text
f_i(a_i+t d_i)-f_i(a_i)
```

are fixed proportional coordinates of one image-direction step.  Since the three base coordinates
`a_i` vary independently, each increment is independent of `a_i`; after normalizing the three
coordinate scales, all three functions obey the same additive difference law.  Thus each `f_i` is
additive.  Over the prime field `F_11`, every additive bijection is multiplication by a scalar, so
the origin stabilizer is linear.  Undoing the initial coordinate change shows that every vertex
automorphism is affine.

Its linear part projectively stabilizes `D`.  C341 independently computed that projective
stabilizer as the displayed `A5` of order 60; each projectivity has exactly ten scalar lifts.
Therefore the point stabilizer has order at most `60*10=600`, and translations give the conceptual
upper bound `1331*600`.  The explicit C341 action attains it.  Since the proof used only the column
graph, it proves simultaneously that the column graph and full scheme have the same automorphism
group.

This elementary argument is useful exposition for the q=11 object, but its general odd-prime
rigidity content is prior art.  Cara--Rottey--Van de Voorde's main theorem for linear
representations `T_2^*(D)` makes every incidence automorphism ambient-projective when `q>2`, the
closure of `D` is the hyperplane at infinity, and their exceptional line configurations are absent.
A spanning arc with at least four points over a prime field contains a projective frame, so its
closure is the whole `PG(2,p)` and the hypotheses apply.  The result above is therefore also an
immediate specialization of their theorem, not a new general affine-rigidity theorem.

## Exact independent certificate

The checker independently certifies the same sharp bound without relying on the rook-grid rigidity
argument.  Scalar-closing the 60 reduced `H3` matrices gives 600 linear maps; direct enumeration
checks that each fixes all eight vector classes.  Translations then give
`1331*600=798600` color-preserving permutations.

For the upper bound, apply exact equitable refinement to the complete edge-colored graph, with a
cell signature consisting of all color-to-cell neighbor counts.

1. After individualizing `0`, the stable cells have the eight relation valencies
   `1,60,100,120,150,300,300,300`.
2. Individualize the column vector `(0,1,4)` from its 60-cell.  Refinement produces 198 cells: 11
   singletons, 110 cells of size five, and 77 cells of size ten.
3. The vector `(1,0,9)` lies in one of the ten-cells.  Individualizing it refines all 1,331
   vertices to singletons.

Equitable-refinement cells are invariant under the pointwise stabilizer of the individualized
base.  Orbit--stabilizer therefore gives

```text
|Aut(X)| <= 1331 * 60 * 10 = 798600.
```

The explicit affine subgroup attains equality.  As an independent internal cross-check, direct
matrix enumeration gives stabilizer orders `600,10,1` along the same fixed-vector chain and orbit
sizes `60,10` for the two nonzero base vectors.  The group equality is therefore not inferred from
an automorphism package or from the intersection tensor alone.

The checker repeats the complete refinement after fusing all noncolumn pairs into one color.  The
column graph alone again has successive base-cell factors `1331,60,10` and becomes discrete after
the same three vertices.  Thus the stronger single-constituent equality is mechanically certified,
not merely suggested by the conceptual line argument.

## General arc-direction rigidity boundary

For an odd prime `p` and a spanning arc `D` with at least four points, Cara--Rottey--Van de
Voorde's theorem gives the general formula

```text
Aut Cay(F_p^3, union_(L in D) (L - {0}))
  = F_p^3 semidirect {A in GL_3(p) : [A]D=D}.
```

The unrestricted prime statement is false at `p=2`.  The unique four-arc
`{e_1,e_2,e_3,e_1+e_2+e_3}` contains exactly the four odd-weight vectors of `F_2^3`, so its graph
is `K_4,4`.  Its full automorphism group has order `2*(4!)^2=1152`, whereas the affine subgroup
has order `8*24=192`, an exact factor-six enlargement.

The checker independently exhausts every frame-marked normalized arc at `p=3,5,7`.  This means a
fixed ordered projective frame is retained and all legal extra points are enumerated; the instances
are not quotient classes.  It checks respectively `1,10,116` arcs, with size distributions

```text
p=3: 1
p=5: 1,6,3              at sizes 4,5,6
p=7: 1,20,70,20,5       at sizes 4,5,6,7,8.
```

For all 127 odd cases, deterministic individualization/refinement reaches exactly the affine lower
bound `p^3*(p-1)*|Stab_PGL3(p)(D)|`; the JSON records every stabilizer distribution and base-cell
chain.  This is a bounded replay of the cited theorem, not evidence of a new general rigidity
result.

## Metric, spectrum, and what the column graph forgets

The column graph has diameter three and exact distance-shell sizes

```text
1, 60, 1150, 120.
```

The last shell is precisely `deep_hole_C5`.  Thus the single graph intrinsically recovers not only
the six columns and chirality torsor but also the complete projective deep-hole relation.  It is
not distance-regular: distance-two vertices have four distinct neighbor-count profiles.

For any `k`-arc in `PG(2,q)`, a character indexed by a dual line meeting the arc in `z=0,1,2`
points has eigenvalue `qz-k`.  Hence the direction graph has four eigenvalues

```text
k(q-1),  2q-k,  q-k,  -k,
```

with multiplicities determined only by the counts of secant, tangent, and external lines.  For the
Clebsch six-arc the exact spectrum is

```text
60^1, 16^150, 5^420, (-6)^760.
```

The eleven-point direction lines attain the Hoffman clique bound.  Consequently all six-arcs in
`PG(2,11)` give the same spectrum, while the Cara isomorphism theorem and C373 automorphism result
recover projective moduli and chirality from the full graph.  This exposes a potentially useful
inverse-spectral theme: spectrum forgets the arc, whereas graph isomorphism and 2-closure recover
it.  No claim that this cospectral-family packaging is new is made without a dedicated audit.

## Arithmetic outer symmetry across the golden fibers

The outer symmetry missing from one q=11 fiber reappears between the two golden-conjugate fibers.
With the six columns kept in their common integral order, exhaustive frame matching finds exactly
60 projectivities from `tau=8` to `tau=4`.  The induced degree-six `A5` actions in the two fibers
are equal; the 60 cross-fiber projectivities are exactly the outer coset in its order-120 `S6`
normalizer, and every one exchanges the two ten-element chirality classes.

At the ramified characteristic-five fiber `tau=3`, the two golden roots coalesce.  The six points
form the full conic, their projective stabilizer has order 120, and the faithful `A5` has index two.
The other 60 projectivities are now internal and exchange chirality.  Thus the same arithmetic
event that makes the parent code GRS also upgrades `A5` to `S5=PGL_2(5)`.

These exact q=11/q=5 facts open, but do not yet prove, an all-good-prime phase theorem.  The proposed
shape is: the outer involution exchanges split conjugate fibers; at inert primes it becomes an
internal semilinear symmetry after Frobenius; and at the ramified prime five it becomes internal
linearly.  The next decisive artifact is a symbolic outer intertwiner over `Z[tau]`, including its
cocycle square and inert-prime specialization.  That synthesis would connect the two three-
dimensional `A5` representations, Galois descent, outer-`S6` chirality, and the GRS boundary.

## Intrinsic reconstruction and C207 hand-back

Inside the 60-point column neighborhood, two vertices are joined in the column color precisely
when their difference lies on one of the six column directions.  Exact component enumeration gives
six components of size ten and checks them against the six scalar-line sets.  The induced
projective group has order 60, its triple-orbit sizes are `10+10`, and exhaustive normalization in
`S6` gives

```text
|N_S6(A5)| = 120,       |N_S6(A5) - A5| = 60.
```

Every outer-normalizer element exchanges the two triple orbits.  But the sharp vertex-group theorem
shows that the stabilizer of any chosen origin has scalar kernel `F_11^*` and induced group exactly
`A5`.  This supplies C207's requested intrinsic object in the association-scheme language: the
unordered obstruction torsor is recoverable without supplied parity-check columns or a supplied
Clebsch-hexagon marking.

There is now a direct bare-code hand-back.  From the code `C <= F_11^6`, form the canonical quotient
graph on `F_11^6/C`, joining two cosets when their difference contains a weight-one vector.  This
uses only the Hamming code and is exactly the column graph above.  Its characteristic regular
translation group recovers syndrome addition up to origin, and its six Delsarte-clique directions
recover the coordinate columns and unordered chirality torsor.  Ryabov's theorem adds that every
normal Cayley graph on an odd abelian p-group of order at most `p^5` is a CI-object; at order
`11^3`, any Cayley isomorphism is therefore induced by a group automorphism.  Thus the ingredients
support the C207 theorem that the unmarked Hamming code determines the torsor through its coset
graph.  C207 retains ownership of the cross-lane theorem statement and manuscript integration.

Howard--Millson--Snowden--Vakil retain priority for the classical `10+10` labeled-icosahedron
dictionary.  This task claims only the exact recovery/forgetting verdict for C341's unmarked
syndrome scheme.

## Research doors opened by the combined picture

These are scoped successor candidates, not allocated tasks or novelty verdicts.

1. **Arithmetic outer/Galois/GRS phase — highest EV.**  Derive the symbolic golden-conjugate
   intertwiner and prove the split/inert/ramified trichotomy suggested above.  This is the most
   Clebsch-specific route and the one most likely to add a new theorem rather than repackage linear-
   representation prior art.
2. **Bare-code chirality and CI reconstruction — near-free publication bridge.**  Package the
   quotient-graph construction, Ryabov CI theorem, six-clique recovery, and C373 torsor as C207's
   intrinsic-code theorem.  The CI and linear-representation ingredients are prior; the exact
   Clebsch obstruction and hand-back are the family-specific content.
3. **Cospectral moduli versus rigid isomorphism.**  All `(q,k)` arc-direction graphs share the
   four-eigenvalue spectrum, while graph isomorphism recovers the projective arc under the Cara
   hypotheses.  A bounded q=11 pair of inequivalent six-arcs with visibly different stabilizers
   would give the first cheap exhibit; a broad census is not authorized by this observation.
4. **Chiral refinement of deep-hole multiple covering.**  General MDS theory gives every farthest
   coset of this `[6,3,4]` code exactly `binom(6,3)=20` minimum-weight leaders.  C373 splits their
   supports intrinsically into `10+10`.  Compute the two sheetwise leader-incidence/intersection
   algebras and stop unless they yield a new exact design, transition, robustness, or list-decoding
   invariant beyond the prior almost-perfect multiple-covering theorem.
5. **Symmetric but non-completely-regular MDS code.**  The code is transitive on weight-one cosets
   and on all deep holes, but its distance-two shell splits into five `A5` orbits and the coset graph
   is not distance-regular.  This places it between neighbor-transitive and completely transitive
   code classes.  The cheap gate is whether that end-transitive/middle-fractured profile is already
   classified or supplies a genuinely new small MDS example.
6. **C374 local-Clifford shortcut.**  Any LC equivalence to a Reed--Solomon AME presentation that
   preserves the Pauli-`X` Lagrangian would induce a classical monomial code equivalence, forbidden
   by C341's non-GRS theorem.  Hence any surviving LC map must genuinely mix `X` and `Z` on at least
   one party.  The arithmetic outer intertwiner should organize the allowed party permutations and
   may sharply reduce C374's exact symplectic search.
7. **Linear-representation LDPC geometry — low EV without an operational gate.**  The incidence
   system `T_2^*(D)` has 1,331 points and 726 allowed lines, with point degree six, line size eleven,
   and the exact affine `A5` group above.  Sin--Sorci--Xiang already develop LDPC codes from these
   incidence matrices.  Pursue the Clebsch member only if an exact rank, distance, trapping-set,
   decoder, or CSS-compatible advantage separates it from their general construction.

Current ranking is therefore: arithmetic outer phase; bare-code C207 composition; chiral deep-hole
refinement; cospectral rigidity; C374 symplectic obstruction; symmetry taxonomy; and finally LDPC.
The last three should not displace C374 without a positive cheap gate.

## Literature/read-depth boundary

This amendment read zero external sources at full text.  It establishes one positive pre-emption
and maps adjacent interfaces; it does not depend on an absence-of-prior-work claim.

- Cara, Rottey, and Van de Voorde, *The isomorphism problem for linear representations and their
  graphs*, arXiv `1207.4726v3`, published DOI
  [`10.1515/advgeom-2013-0040`](https://doi.org/10.1515/advgeom-2013-0040): **partial**, delegated
  access to the arXiv preprint, introduction/Main Theorem and Sections 3--5 on closure, rigidity,
  exceptions, isomorphism, and automorphism groups; not cached and the published text was not read
  separately.  This is the decisive pre-emption of the proposed general odd-prime rigidity theorem.
- Ball and Lavrauw, *Arcs in finite projective spaces*, arXiv `1908.10772`: **partial**, cached PDF
  SHA-256 `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`, arc definitions and
  planar-arc background only.  Used for vocabulary and the finite-geometry boundary, not novelty.
- Bamberg, Devillers, Fawcett, and Praeger, *Partial linear spaces with a rank 3 affine primitive
  group of automorphisms*, arXiv `1908.11110v2`: **partial**, arXiv browser access, abstract,
  introduction, and affine partial-linear/rank-three scope; not cached.  Its rank-three
  classification does not directly cover the present rank-eight orbital refinement.
- Sin, Sorci, and Xiang, *Linear representations of finite geometries and associated LDPC codes*,
  arXiv `1908.06824v2`: **partial**, arXiv HTML abstract and introduction, including the definition
  of `T_(n-1)^*(K)` and the incidence-matrix LDPC constructions; not cached.  Used to mark the LDPC
  door as established general machinery.
- Gillespie and Praeger, *Neighbour transitivity on codes in Hamming graphs*, arXiv `1112.1244v1`,
  published DOI [`10.1007/s10623-012-9614-5`](https://doi.org/10.1007/s10623-012-9614-5):
  **partial**, arXiv HTML abstract, introduction, Definition 1.1 and Theorem 1.2; not cached and the
  published version was not separately read.  Used only to place the symmetry-taxonomy door.
- Davydov, Marcugini, and Pambianco, *On the weight distribution of the cosets of MDS codes*, arXiv
  `2101.12722`: **partial**, arXiv HTML abstract, introduction, Theorem 4.6 and Theorem 7.7; not
  cached.  Used for the prior uniform `binom(6,3)=20` farthest-coset leader count and almost-perfect
  multiple-covering boundary.
- Ryabov, *On CI-property of normal Cayley digraphs over abelian groups*, arXiv `2503.00859v1`:
  **abstract/metadata only**, arXiv abstract and submission metadata; not cached.  The abstract
  states that every normal Cayley digraph over an odd abelian p-group of order at most `p^5` is CI.
- Xu, *Automorphism groups and isomorphisms of Cayley digraphs*, DOI
  [`10.1016/S0012-365X(97)00152-0`](https://doi.org/10.1016/S0012-365X(97)00152-0):
  **abstract/metadata only**, ScienceDirect title/abstract/metadata; no full text accessed.  Used
  only for normal-Cayley terminology and historical boundary.
- Lim and Praeger, *On generalised Paley graphs and their automorphism groups*, arXiv
  `math/0605252v2`: **abstract/metadata only**, arXiv title/abstract/metadata; not cached.  Used only
  to separate the present arc-direction graphs from established affine/cyclotomic examples.
- Howard--Millson--Snowden--Vakil's labeled-icosahedron `10+10` dictionary: **secondary only** via
  the fully read local C371 audit and its question-to-source ledger; the external source was not
  reread in C373.  No priority beyond C371's recorded boundary is inferred.

MathSciNet, zbMATH, Google Scholar, and all forward-citation graphs were **NOT COVERED** in this
amendment.  Accordingly the arithmetic outer-phase, cospectral-moduli, chiral-covering, and symmetry-
taxonomy items remain candidates requiring their own source-level and forward-citation gates.

## Reproduction and trusted boundary

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-19-c373-clebsch-scheme-automorphisms.py --check
sha256sum -c notes/2026-07-19-c373-clebsch-scheme-automorphisms.sha256
```

The standard-library-only checker pins C341's source by SHA-256.  It checks all `1331^2` edge
colors, exhausts all `7!=5040` algebraic color permutations against all 512 tensor entries, proves
the sharp individualization/refinement bound for both the full scheme and the column graph alone,
independently enumerates the attaining matrix stabilizer chain, reconstructs the six column blocks,
and exhausts all 720 elements of `S6` for the normalizer and chirality action.  The amended checker
also certifies the column-graph distance/spectral data, all 720 q=11 cross-fiber frame matchings,
all 720 characteristic-five self-matchings, the exact `K_4,4` exception, and all 127 frame-marked
normalized arcs at `p=3,5,7` with independent projective-stabilizer lower bounds.

The trusted boundary is Python 3 exact integer arithmetic, exhaustive finite-field enumeration,
the elementary invariant-cell upper-bound lemma for equitable refinement, and C341's pinned orbit
construction.  The computation does not establish separability for arbitrary schemes sharing the
same intersection tensor, prove the proposed all-good-prime arithmetic outer phase, or claim a new
outer-`S6`, CI, affine-rigidity, LDPC, MDS-coset, or neighbor-transitivity theorem.  The bare-code
statement uses the elementary canonical coset-graph construction plus the cited CI theorem; C207
still owns its formal manuscript integration.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 27,824 | `d6c01bf8ba22e061b5c514261046eebc9325e38d4b7ec6fb18deed06ef93f6da` |
| certificate `.json` | 7,652 | `3101767e4d5f39f27a7faa0e5be1c4e2622775ee5fc5a54aa21f94fbb0a044b8` |
