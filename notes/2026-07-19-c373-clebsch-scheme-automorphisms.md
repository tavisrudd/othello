# C373 — full automorphisms and intrinsic Clebsch chirality

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `THEOREM; FULL AFFINE A5 AUTOMORPHISM GROUP; INTRINSIC UNORDERED 10+10 CHIRALITY TORSOR`

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
This identifies opposite lines in the same direction class.  Transporting that identification
across such grids propagates each of the six local line components globally.  The column graph is
connected because any three members of `D` form a vector-space basis, so the propagation reaches
every vertex and every allowed line.  Hence every automorphism induces one global permutation of
the six direction classes.

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
Clebsch-hexagon marking.  The stronger claim that the abstract code alone, with no syndrome
relations reconstructed, already determines this scheme remains owned by C207 and is not asserted
here.

Howard--Millson--Snowden--Vakil retain priority for the classical `10+10` labeled-icosahedron
dictionary.  This task claims only the exact recovery/forgetting verdict for C341's unmarked
syndrome scheme.

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
and exhausts all 720 elements of `S6` for the normalizer and chirality action.

The trusted boundary is Python 3 exact integer arithmetic, exhaustive finite-field enumeration,
the elementary invariant-cell upper-bound lemma for equitable refinement, and C341's pinned orbit
construction.  The computation does not establish separability for arbitrary schemes sharing the
same intersection tensor, reconstruct the syndrome graph from the bare code, or claim a new
outer-`S6` dictionary.  No external papers were read for C373; it consumes the depth-marked C371
audit and the committed C207/C341/C372 statements.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 14,401 | `0e22e734d14bc7c9642c60857549d69f2bb4f677f3680e1ac97a5034ba824e2f` |
| certificate `.json` | 3,812 | `bb1d247370480421943b5ab566a89912a21e87bb94df77b36bf1226e38340314` |
