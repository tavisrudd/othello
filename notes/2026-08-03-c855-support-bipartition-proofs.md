# C855 — structural proofs for the Brianchon–support dictionary, the invariant support bipartition, and the deep-hole orbit theorem

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — Paper I Lean referee-artifact remediation, structural-mathematics stream.
**Scope:** mathematics only. No Lean file was edited, no Lean build, generator, gate, or manifest
was run, and no manuscript was changed.

Targets, all carried in `notes/2026-08-02-c855-paper-i-assertion-inventory.md` as human-proof-only
or full-gap rows:

| target | manuscript label | verdict |
|--------|-----------------------------------|---------------------------------------------------------------|
| 1      | `prop:brianchon-support`          | **proved**, and the Edge citation is eliminated                |
| 2      | `cor:decoder-brianchon`           | **proved**                                                     |
| 3      | `prop:invariant-support-bipartition` | **proved**                                                  |
| 4      | `prop:deep-hole-orbit`            | **proved**, on the already-formalized orbit partition          |
| 5      | monomial automorphism extension   | **proved** (order six hundred, split, central kernel)          |

Two inputs come from the companion C855 notes and are used as established results:

- `notes/2026-08-03-c855-structural-exclusions.md` — for a six-arc in any Desarguesian plane of odd
  order, an off-vertex point lies on a set of pairwise disjoint chords; the concurrence relation on
  the six one-factorizations is an equivalence relation; the concurrence count is at most ten; and
  at equality the five **non**-concurrent one-factors form a one-factorization of the complete graph
  on the six vertices.
- `notes/2026-08-03-c855-dye-orbit-uniqueness.md` — the Clebsch hexagon attains the count ten, is the
  unique such configuration up to projectivity, has projective stabilizer the alternating group of
  degree five, and has a unique associated polarity for which the five triangles cut out by the five
  non-concurrent one-factors are self-polar.

Throughout, `A` is the Clebsch six-arc with the manuscript's parity-check columns, `K₆` is the
complete graph on its six vertices `{0,…,5}`, and
```
𝒯 = the five non-concurrent one-factors  =  the five self-polar triangles of Edge and Dye,
𝔅 = the ten Brianchon points.
```
That `𝒯` is a one-factorization is the equality clause of the structurally proved Dye bound, so the
manuscript's identification of `𝒯` with Edge's five triangles is now a theorem of this development
rather than a citation.

## Target 1 — `prop:brianchon-support`

### The purely combinatorial core

Everything except the single concurrence statement is a fact about an arbitrary one-factorization of
`K₆`. Stating it that way matters: the assertion inventory lists "the uniqueness of the
one-factorization of the complete graph on six vertices" as one of its eighteen external transfers,
and the proofs below never use it.

**Lemma 1 (hexagon).** Two distinct one-factors of `K₆` are disjoint if and only if their union is a
six-cycle.

*Proof.* Two disjoint one-factors have union a two-regular graph on six vertices, hence a disjoint
union of cycles of even length. A cycle of length two is a repeated edge, excluded by disjointness,
so all cycle lengths are at least four and sum to six: there is exactly one cycle, of length six.
Conversely a six-cycle's two alternating edge classes are its only decomposition into one-factors,
and they are disjoint. ∎

For distinct `T, T' ∈ 𝒯` write `C(T,T')` for that six-cycle, `M(T,T')` for the matching of its three
long diagonals (opposite vertices), and `β(T,T')` for the unordered pair of its two alternating
vertex classes.

**Lemma 2 (the diagonal matching lies outside `𝒯`).** `M(T,T')` is disjoint from `T` and from `T'`,
is not a member of `𝒯`, and meets each of the other three members of `𝒯` in exactly one edge.

*Proof.* The three long diagonals are chords of the six-cycle, so they are not edges of `T ∪ T'`.
Suppose `M(T,T') ∈ 𝒯`. Writing the cycle as `v₀v₁v₂v₃v₄v₅`, the union
`T ∪ T' ∪ M(T,T')` is the complete bipartite graph on the alternating classes `{v₀,v₂,v₄}` and
`{v₁,v₃,v₅}`: every cycle edge joins consecutive, hence oppositely-classed, vertices, and every long
diagonal `vᵢvᵢ₊₃` joins vertices of opposite parity. Its complement inside `K₆` is the pair of
triangles on `{v₀,v₂,v₄}` and `{v₁,v₃,v₅}`, and the remaining two members of `𝒯` would have to
partition it. But a one-factor of the six vertices contained in two disjoint triangles would have to
match each triangle's three vertices among themselves, which is impossible for a set of odd size. So
`M(T,T') ∉ 𝒯`.

Each of the three diagonals lies in exactly one member of `𝒯`, necessarily one of the three members
other than `T, T'`. If two diagonals lay in the same `T''`, the third edge of `T''` would cover the
two remaining vertices, which are precisely the endpoints of the third diagonal, so `T'' = M(T,T')`,
contradicting the previous paragraph. Hence the three diagonals lie in three distinct members, which
must be the other three. ∎

**Proposition 1 (the matching bijection).** `{T,T'} ↦ M(T,T')` is a bijection from the ten
two-element subsets of `𝒯` onto the ten one-factors of `K₆` outside `𝒯`.

*Proof.* By Lemma 2 the image lies outside `𝒯`, and `{T,T'}` is recovered from `M(T,T')` as the set
of members of `𝒯` disjoint from it, so the map is injective. There are `15` one-factors of `K₆` and
`|𝒯| = 5`, so the target has ten elements, and an injection between ten-element sets is a
bijection. ∎

**Lemma 3 (crossing count).** Let `S` be a three-element set of vertices. Then exactly two members of
`𝒯` have all three edges crossing the bipartition `{S, Sᶜ}`, and the other three have exactly one
crossing edge each.

*Proof.* A one-factor has one or three crossing edges, since the number of crossing edges is
congruent to `|S| = 3` modulo two. The bipartition has `3·3 = 9` crossing edges in total, and `𝒯`
partitions all fifteen edges, so if `a` members cross fully then `3a + (5 − a) = 9`, giving
`a = 2`. ∎

**Proposition 2 (the support bijection).** `{T,T'} ↦ β(T,T')` is a bijection from the ten
two-element subsets of `𝒯` onto the ten complementary pairs of three-element supports, with inverse
sending `{S,Sᶜ}` to the two members of `𝒯` that cross it.

*Proof.* Every edge of the six-cycle `C(T,T')` joins consecutive vertices, hence crosses the
alternating bipartition `β(T,T')`; so both `T` and `T'` cross it, and by Lemma 3 they are exactly the
two crossing members. Thus `β` is injective with the stated inverse, and it is a map between
ten-element sets. ∎

### The single geometric input

**Proposition 3 (concurrence).** The three chords indexed by a one-factor `M` of `K₆` are concurrent
if and only if `M ∉ 𝒯`, the ten resulting Brianchon points are pairwise distinct, and the fifteen
remaining intersections of disjoint chords are simple.

*Proof.* The first clause is the definition of `𝒯` together with the fact, proved structurally in
the companion note, that the Clebsch hexagon attains the concurrence count ten. If two distinct
concurrent one-factors met at a common point `x`, then all chords of both pass through `x`; since `x`
is off the arc, chords through `x` are pairwise disjoint, so their union is a matching with more than
three edges, which is impossible. For the last clause, two disjoint chords lie in a unique one-factor
(the remaining two vertices form the third edge); if a point `x` carried two disjoint pairs from two
non-concurrent one-factors, the chords through `x` would again form a matching, so the union of the
two pairs has at most three edges and is therefore a one-factor concurrent at `x`, contradicting
non-concurrence. There are `15·3/2 = 45` disjoint chord pairs, `30` of them absorbed by the ten
triple points, leaving fifteen simple ones. ∎

Combining Propositions 1 and 3, `{T,T'} ↦ b(T,T') :=` the common point of the chords of `M(T,T')` is
a bijection onto `𝔅`. Equivariance under any permutation of the six vertices preserving `𝒯` — in
particular under the projective stabilizer `A₅` — is immediate, because `M`, `β` and `b` are defined
from `𝒯` and incidence alone.

### The Petersen adjacency rule, sharpened

The manuscript defines Petersen adjacency by disjointness of index pairs. The following gives it an
intrinsic projective reading, which is a free upgrade.

**Proposition 4.** Every chord of `A` carries exactly two Brianchon points. Two Brianchon points are
Petersen-adjacent — that is, their index pairs in `𝒯` are disjoint — if and only if they lie on a
common chord, and that chord is then unique. Hence the Petersen graph on `𝔅` is exactly the
point–chord incidence graph of the Brianchon configuration, with the fifteen chords as its fifteen
edges.

*Proof.* `A₅` acts on the six vertices two-transitively, hence transitively on the fifteen edges of
`K₆`; so each edge lies in the same number `a` of one-factors outside `𝒯`, and counting incidences
gives `15a = 10·3`, so `a = 2`. `A₅` acts on `𝒯` as the natural alternating group of degree five
(see Lemma 4 below), hence transitively both on the fifteen disjoint pairs of two-subsets and on the
thirty meeting pairs. So `|M(T,T') ∩ M(T'',T''')|` takes one value `x` on disjoint index pairs and
one value `y` on meeting index pairs. Each of the fifteen edges lies in exactly two outside
matchings, contributing exactly one unordered pair of outside matchings that share it, so
```
15x + 30y = 15,   x, y ≥ 0 integers,
```
whose only solution is `x = 1`, `y = 0`. Two Brianchon points lie on a common chord exactly when
their matchings share that edge, which gives the statement. ∎

Note what Proposition 4 rules out: the support pairs alone cannot see adjacency. For distinct
complementary pairs `{S,Sᶜ}` and `{S',S'ᶜ}` the intersection sizes are always `{1,2}`, so Petersen
adjacency is genuinely extra structure carried by `𝒯`, not a function of the bipartitions.

### Formalization shape

The Lean statement should quantify over an arbitrary one-factorization `𝒯` of `K₆` — a
`Finset (Finset (Fin 6))` of five pairwise disjoint perfect matchings whose union is all fifteen
edges — and assert Propositions 1, 2 and 4 for it. Lemmas 1–3 and Proposition 4 are `𝒯`-generic and
finite: the whole combinatorial layer is a statement about a fifteen-element edge set and a
five-element index set, decidable once `𝒯` is a variable, and `decide`-scale after fixing the
standard one-factorization. The only geometric obligation is Proposition 3, whose first clause is the
equality structure of the structurally proved Dye bound and whose remaining clauses are the
matching-of-chords lemma from the companion note; specialized to the displayed hexagon over
`ZMod 11` all three clauses are `decide`-scale.

**Verdict: proved.** The manuscript's appeal to Edge's Clebsch construction for the concurrence of
the ten outside matchings is replaced by the equality clause of the Dye bound, which this development
now proves; and the "uniqueness of the one-factorization of `K₆`" transfer is not used anywhere.

## Target 2 — `cor:decoder-brianchon`

**Corollary.** The ten projective directions with three nearest weight-two errors are exactly the ten
Brianchon points; at each of them the three error supports are pairwise disjoint and form a perfect
matching of the six coordinates; and the ten matchings so recovered are exactly the ten perfect
matchings outside `𝒯`.

*Proof.* By the arc–coset dictionary, the number of weight-two leaders of a nonzero syndrome `s` is
the secant index of the direction `[s]`, that is, the number of chords of `A` through `[s]`, and the
supports of those leaders are the corresponding vertex pairs. For a point off the arc, the chords
through it are pairwise disjoint (a shared vertex would put that vertex on both chords, so the point
would be a vertex), so the supports of the weight-two leaders form a partial matching of the six
coordinates. Hence the secant index is at most three, with equality exactly when the supports are a
perfect matching whose three chords concur — that is, exactly at a concurrent one-factor. By
Proposition 3 these are precisely the ten Brianchon points, distinct, and by Proposition 1 their
matchings are exactly the ten one-factors outside `𝒯`. ∎

The chain has no residual citation: the "ten matchings outside the five self-polar ones" clause is
Proposition 1 plus the identification of `𝒯` with the self-polar triangles from the polarity section
of the companion note.

**Formalization shape.** Quantify over the displayed code: for each nonzero syndrome the leader
multiset is computable, so the statement "the set of directions of ambiguity three equals the set of
concurrence points of one-factors" is a `decide`-scale identity over `ZMod 11`, and two of its three
clauses already have Lean terminals (`Q11Coding.brianchonDirectionIndices_eq_indexThree`,
`...brianchon_weightTwo_leaderSupports`). What is missing is only the matching-theoretic wrapper:
the perfect-matching property of the three supports and the equality of the recovered matching set
with the complement of `𝒯`, both finite `Finset (Fin 6)` computations.

**Verdict: proved.**

## Target 3 — `prop:invariant-support-bipartition`

Write `G ≤ Sym{0,…,5}` for the group of permutations induced by projectivities preserving the six
columns; by the companion note `G ≅ A₅` of order sixty, acting two-transitively.

**Lemma 4 (the action on `𝒯`).** `G` preserves `𝒯`, acts faithfully on it, and the induced group is
the natural alternating group of degree five. Consequently `G` has exactly two orbits on the fifteen
one-factors, of sizes five and ten, namely `𝒯` and the ten Brianchon matchings.

*Proof.* `𝒯` is defined by concurrence, a projective condition, so it is `G`-invariant. If `g ∈ G`
preserves every member of `𝒯`, then for any two members it preserves the six-cycle `C(T,T')` and each
of its two alternating edge classes; inside the dihedral automorphism group of a hexagon the
subgroup preserving both edge classes is the rotation subgroup of order three, so the kernel of
`G → Sym(𝒯)` has order at most three, and being normal in the simple group `G` it is trivial. The
image has order sixty inside the symmetric group of degree five, hence is the alternating group. The
orbit statement follows: `𝒯` is a single orbit, and the ten outside one-factors are equivariantly
indexed by the two-subsets of `𝒯` through Proposition 1, on which the alternating group of degree
five is transitive. ∎

**Lemma 5 (no fixed-point-free involution).** In its degree-six action `G` consists of even
permutations, so no element has cycle type `2+2+2`.

*Proof.* `G ≅ A₅` is simple, so it has no subgroup of index two and the sign homomorphism
`G → {±1}` is trivial. A permutation of type `2+2+2` is a product of three transpositions, hence
odd. ∎

**Proposition 5 (the bipartition).** The twenty three-element supports form two `G`-orbits of size
ten, exchanged by complementation; the stabilizer of a support is a symmetric group of degree three,
of order six, and equals the stabilizer of its complementary pair. The map `S ↦ {`the two members of
`𝒯` crossing `S}` is `G`-equivariant and induces the bijection of Proposition 2 on complementary
pairs.

*Proof.* By Lemma 3 and Proposition 2 the map `S ↦ β⁻¹(S)` is well defined, two-to-one onto the ten
two-subsets of `𝒯`, and equivariant; by Lemma 4 `G` is transitive on that target, so the stabilizer
of a complementary pair `{S,Sᶜ}` has order six and the twenty supports form either one orbit of
twenty or two of ten.

Let `{T,T'} = β⁻¹(S)`. The stabilizer of `{S,Sᶜ}` preserves the six-cycle `C(T,T')`, hence embeds
into its dihedral automorphism group of order twelve. The order-six subgroups of that dihedral group
are the rotation subgroup — which contains the antipodal rotation, of cycle type `2+2+2` — and the
two symmetric groups of degree three, one generated by the even rotations together with the three
reflections in opposite vertex pairs (cycle type `1+1+2+2`), the other with the three reflections in
opposite edge pairs (cycle type `2+2+2`). Lemma 5 excludes every subgroup containing an element of
type `2+2+2`, leaving the vertex-reflection copy. Even rotations and vertex reflections both preserve
each alternating vertex class of the hexagon, so the stabilizer of `{S,Sᶜ}` fixes `S` and `Sᶜ`
individually. Hence the orbit of `S` has length ten and there are two orbits.

Complementation commutes with `G` and fixes no three-element set. If it preserved one orbit `O`,
then `O` would contain both members of some complementary pair, hence — by equivariance and
transitivity of `G` on the pairs — both members of every pair, forcing `|O| = 20`. So it exchanges
the two orbits. ∎

**Proposition 6 (leaders).** For every maximum-distance syndrome `s` and every three-element support
`S`, the coset `H⁻¹(s)` has exactly one leader with support `S`. Hence each of the one hundred twenty
deep-hole cosets has exactly twenty minimum-weight leaders, ten in each support class, and the two
thousand four hundred minimum-weight leaders split as twelve hundred and twelve hundred.

*Proof.* The three columns indexed by `S` are linearly independent because `A` is an arc, so they
form a basis of the syndrome space and `s` has a unique expansion in them. No coefficient vanishes:
otherwise `s` would lie in the span of two columns, so `[s]` would lie on a chord of `A` — or be a
column — and its coset would have weight at most two, contradicting maximum distance. The resulting
error vector has weight exactly three, support exactly `S`, and is the unique such vector in the
coset. Summing over the twenty supports gives twenty leaders per deep-hole coset, ten in each class
by Proposition 5; over the one hundred twenty deep-hole cosets this gives `2400 = 1200 + 1200`. ∎

Proposition 6 also discharges, for this code, the inventory row "each uncovered direction lifts to
field-order-minus-one weight-three cosets, each with twenty minimum-weight leaders", currently
carried as an external transfer to the Davydov–Marcugini–Pambianco dictionary: the twenty-leader
count is a two-line consequence of the arc property.

**Proposition 7 (invariance, and the outside coset).** Every monomial automorphism of `C` preserves
each of the two support classes, hence the unordered bipartition. The stabilizer of `𝒯` in the full
symmetric group of degree six is a symmetric group of degree five, of order one hundred twenty, and
its nontrivial coset over `G` exchanges the two classes; none of its sixty elements is induced by a
monomial automorphism of `C`.

*Proof.* By the exact sequence of Target 5, a monomial automorphism induces a support permutation in
`G`, and `G` preserves each orbit by Proposition 5. The full symmetric group of degree six acts
transitively on the six one-factorizations of `K₆`, so the stabilizer of `𝒯` has order
`720/6 = 120`; it contains `G` with index two. For a two-subset `{T,T'}` of `𝒯`, the stabilizer of
that pair inside the order-one-hundred-twenty group has order twelve and preserves the six-cycle
`C(T,T')`, so it is the full dihedral group; the elements outside `G` are then exactly the odd
rotations and the edge reflections, all of which exchange the two alternating vertex classes. Hence
the outside coset exchanges the two support classes. Finally the image of the monomial automorphism
group in the symmetric group of degree six is exactly `G`, because that image is the projective
stabilizer of the six column rays, which the companion note proves to be the alternating group of
degree five, of index two in the stabilizer of `𝒯`. ∎

In particular only the unordered bipartition is intrinsic: the labelling of the two classes is
exchanged by the outside coset of the exotic normalizer, which acts on the combinatorics but not on
the code.

**Formalization shape.** The Lean statement quantifies over `Finset.powersetCard 3 (Finset.univ :
Finset (Fin 6))` and the concrete subgroup `G ≤ Equiv.Perm (Fin 6)` generated by the two induced
permutations already present in the development. The orbit split `10 + 10`, the stabilizer order,
and the complementation exchange are all `decide`-scale (sixty elements times twenty supports); the
structural proof above is what makes the statement readable, but nothing in it needs a nontrivial
finite search. Proposition 6 needs the arc independence of any three columns (already available) and
the fact that a deep-hole direction lies on no chord (already a Lean terminal, through
`Q11Coding.projective_distanceThreeDirections_eq_standardConic` together with the uncovered-locus
description). Proposition 7 needs the exact sequence of Target 5.

**Verdict: proved.**

## Target 4 — `prop:deep-hole-orbit`

**Step 1: `G` is transitive on the twelve deep-hole directions.** An element of order five in the
three-dimensional representation over the field of eleven elements has three distinct eigenvalues,
since five divides ten, so each of the six Sylow five-subgroups fixes exactly three projective
points. Two distinct Sylow five-subgroups generate `G`, which fixes no point because its
representation is irreducible; so the eighteen fixed points are distinct. By the orbit table of
`prop:a5-point-orbits` six of them are the points with stabilizer a dihedral group of order ten,
leaving twelve points with exact stabilizer of order five; these form a single orbit of length
`60/5 = 12`. The uncovered locus is `G`-invariant of size twelve, and the only way to write twelve as
a sum of the available orbit lengths `6, 10, 12, 15, 30, 30, 30` is as the single twelve-orbit.
Hence `G` is transitive on it.

**Step 2: the monomial group is transitive on the one hundred twenty maximum-distance syndromes.**
Each projectivity in `G` lifts to a monomial automorphism of the parity-check columns (Target 5), and
the central subgroup of global scalars acts transitively on the ten nonzero vectors of each syndrome
ray. So `12 · 10 = 120` syndromes form one orbit, hence so do the one hundred twenty deep-hole
cosets.

**Step 3: the affine group.** Let `Γ` be generated by the monomial automorphism group and the
translations by codewords. Both kinds of generator are Hamming isometries preserving `C`, and
conjugation gives `m tᶜ m⁻¹ = t^{m(c)}` with `m(c) ∈ C`, so the translations are normal and
`Γ = C ⋊ MAut(C)`. The intersection is trivial: a nonzero translation is fixed-point free while every
monomial map fixes the zero word. Hence `|Γ| = 1331 · 600 = 798600`.

**Step 4: transitivity on received words and the stabilizer.** Given deep holes `v, w`, choose `m`
with `σ(mv) = σ(w)` by Step 2; then `w − mv` has zero syndrome, hence lies in `C`, and the
corresponding translation carries `mv` to `w`. There are `120 · 1331 = 159720` deep-hole received
words, so orbit–stabilizer gives stabilizer order `798600 / 159720 = 5`, and a group of prime order
is cyclic.

The stabilizer can be named, which the manuscript does not do: projecting `Γ_v` to `MAut(C)` is
injective, since an element `tᶜ ∘ m` fixing `v` with `m = 1` forces `c = 0`; so `Γ_v` is a
five-element subgroup of `MAut(C) ≅ C₁₀ × A₅`, hence maps isomorphically onto a Sylow five-subgroup
of the alternating quotient. Explicitly it is the graph of a map from that Sylow five-subgroup into
the codeword translations, and it is exactly the stabilizer of the deep-hole direction `[σ(v)]`
lifted through the syndrome map.

**Formalization shape.** Steps 3 and 4 are abstract group theory over a finite group action and
should be done with mathlib's orbit–stabilizer; nothing should enumerate the `159720` words. Step 2
needs the explicit monomial group as `A₅ × F₁₁ˣ` together with its action on syndromes by the sixty
matrices, and transitivity on the twelve conic points, which is a `decide`-scale orbit computation
already close to `Q11A5PointOrbits.unique_twelve_orbit`. Step 1 is the only place needing the orbit
partition, which is already formalized.

**Verdict: proved**, resting on the already-formalized `A₅` point-orbit partition; the counting
corollary `cor:named-variety` (twelve directions, one hundred twenty cosets, twenty leaders,
two thousand four hundred leaders, one hundred fifty-nine thousand seven hundred twenty deep holes)
follows from Proposition 6 and Steps 1–4, closing that inventory row too.

## Target 5 — the monomial automorphism extension

**Proposition 8.** There is an exact sequence
`1 → F₁₁ˣ → MAut(C) → A₅ → 1` with central kernel the global scalars; it splits, and
`MAut(C) ≅ C₁₀ × A₅` has order six hundred.

*Proof.* A monomial map preserving `C` permutes the weight-one cosets, hence induces a permutation
`σ` of the six columns and a projectivity `A` with `A hⱼ = λⱼ h_{σ(j)}`; conversely, given a
projectivity permuting the six column rays, the scalars `λⱼ` it produces define a monomial map
`c'_{σ(j)} = λⱼ cⱼ` preserving `C`, because
`Σⱼ c'_{σ(j)} h_{σ(j)} = A(Σⱼ cⱼ hⱼ)`. So the image of `MAut(C)` in the symmetric group of degree six
is exactly the projective stabilizer of the six rays, which is `A₅` by the companion note.

If `σ` is trivial, `A` fixes all six column rays. Any four of the six arc points are in general
position, so `A` fixes a projective frame and is a scalar matrix; the induced monomial map is then a
global scalar. Hence the kernel is `F₁₁ˣ ≅ C₁₀`, and it is central because global scalars commute
with every monomial map.

For splitting, note that cubing is a bijection of `F₁₁ˣ` since `gcd(3,10) = 1`, so each projective
class has a unique determinant-one matrix representative. These representatives are closed under
multiplication, giving a homomorphic section of `SL₃(F₁₁) → PGL₃(F₁₁)` over `A₅`; composing with the
lift above — which is canonical once the six column representatives are fixed — gives a complement
isomorphic to `A₅`. A split central extension is a direct product, so `MAut(C) ≅ C₁₀ × A₅` of order
`10 · 60 = 600`. ∎

The splitting is not automatic: the Schur multiplier of `A₅` is of order two, so a central extension
by `C₁₀` need not split, and the determinant argument is doing real work. An alternative route is
that the derived subgroup of the preimage in `GL₃(F₁₁)` is a perfect central extension of `A₅`, hence
a quotient of the double cover, which has no faithful three-dimensional representation; but the
determinant argument is shorter and elementary.

**Formalization shape.** The kernel clause needs frame rigidity — four points in general position
determine a projectivity — which is the standard fundamental theorem statement and should be a named
lemma. The image clause needs the projective stabilizer computation, `decide`-scale over `ZMod 11`.
The splitting clause is arithmetic in `F₁₁ˣ` plus the observation that determinant-one
representatives are closed under multiplication.

**Verdict: proved.**

## What the five targets remove from the gap ledger

- Edge's concurrence construction, listed as an external transfer, is no longer used: Proposition 3
  derives the ten concurrences from the equality clause of the structurally proved Dye bound.
- The uniqueness of the one-factorization of `K₆`, also listed as an external transfer, is not used:
  every combinatorial lemma above is generic in the one-factorization.
- The twenty-leader clause of the Davydov–Marcugini–Pambianco dictionary is proved directly
  (Proposition 6).
- `cor:named-variety`, listed as an elementary counting gap, follows from Proposition 6 and the
  deep-hole orbit steps.

Not removed: Dye's projective-stabilizer result is still used, but it is now a proved companion
result rather than a citation; and `prop:a5-point-orbits` is used in Step 1 of Target 4 in its
already-formalized form.

## Extra structure found on the way

- **Petersen adjacency is point–chord incidence** (Proposition 4). The Petersen graph on the ten
  Brianchon points is exactly their incidence graph with the fifteen chords: each chord carries
  exactly two Brianchon points, and two Brianchon points are adjacent precisely when a chord contains
  both. This is a sharper and coordinate-free form of the manuscript's adjacency clause and is worth
  adding to `prop:brianchon-support` and to the figure caption.
- **The support bipartition cannot see adjacency.** For any two distinct complementary support pairs
  the intersection profile is `{1,2}`, so the Petersen structure is carried by `𝒯` and not by the
  bipartitions; the manuscript's diagram is therefore recording genuinely more than the support data.
- **The five/ten split of the one-factors is forced by the group** (Lemma 4): `A₅` has exactly two
  orbits on the fifteen one-factors, of sizes five and ten. Given only that the concurrence count is
  ten, the concurrent set must be the ten-orbit — an independent derivation of the equality structure
  that uses the symmetry rather than the counting bound.

## Mystery ledger

- *Why is the Petersen adjacency count forced without a case analysis?* Settled. The identity
  `15x + 30y = 15` in nonnegative integers has the unique solution `(1,0)`, so the two orbit types of
  pairs of Brianchon points are separated by a counting identity rather than by inspection.
- *Why does the stabilizer of a support pair fix each part rather than swapping them?* Settled: the
  degree-six action of `A₅` lands inside the alternating group of degree six, so it has no
  fixed-point-free involution, and the order-six subgroups of the hexagon's dihedral group that avoid
  cycle type `2+2+2` are exactly the vertex-reflection copies, which preserve the alternating vertex
  classes. The chirality of the bipartition is thus the parity of the degree-six embedding, nothing
  more.
- *Is there a canonical sign on the bipartition after all?* Open, and probably no. Every construction
  tried here is invariant under the full stabilizer of `𝒯`, which exchanges the classes. Evidence
  gap: no invariant separating the two classes was searched for systematically; a natural test is
  whether the associated polarity of the companion note evaluates differently on the two classes.
  Recorded as a descriptive question with no owning successor.
- *Why is the deep-hole word stabilizer a Sylow five-subgroup rather than something twisted?* Settled
  as far as the order goes: the projection to the monomial group is injective, so the stabilizer is a
  five-element subgroup of `C₁₀ × A₅` and therefore maps isomorphically to a Sylow five-subgroup of
  the alternating factor. Which cocycle-twisted complement it is depends on the chosen deep hole and
  was not identified; that is a labelling question, not a gap.
- *Does anything above depend on the order being eleven?* Only Targets 4 and 5 and the numerical
  clauses. Targets 1 and 2 hold for any six-arc of concurrence count ten over any field of odd
  characteristic, and Target 3's combinatorial half holds for the abstract configuration. Worth a
  manuscript remark, since it separates the coding-theoretic specialization from the geometry.

## Computational corroboration (not the deliverable)

`notes/2026-08-03-c855-brianchon-support-dictionary.py` rebuilds the configuration from the
manuscript's parity-check columns and checks every finite clause above:

```
python3 notes/2026-08-03-c855-brianchon-support-dictionary.py
```

It reports ten concurrent and five non-concurrent one-factors; that the five non-concurrent ones form
the one-factorization `01|23|45, 02|14|35, 03|15|24, 04|13|25, 05|12|34` displayed in the manuscript
figure; fifteen simple intersections of disjoint chords; that `M` and `β` are bijections and that `M`
lands exactly on the ten concurrent matchings; the crossing-count lemma for all twenty supports; that
the projective stabilizer has order sixty with cycle types `1⁶, 1²2², 1·5, 3²` and no `2+2+2`; the
support orbit sizes `10 + 10` with support stabilizer of order six; that adjacent index pairs share
exactly one chord and non-adjacent ones share none, and that the shared chord is exactly the set of
chords containing both Brianchon points; that every chord carries exactly two Brianchon points; the
coset-leader weight distribution `(1, 60, 1150, 120)`; twenty leaders per deep-hole coset with the
`10 + 10` class split and the global `1200 + 1200`; that the ten triple-ambiguity directions are the
ten Brianchon points with the predicted supports; monomial group order six hundred; transitivity of
`A₅` on the twelve deep-hole directions and of the monomial group on the one hundred twenty
maximum-distance syndromes; and stabilizer order five.

## What this record does not establish

No Lean file was edited, no Lean build, generator, gate, or manifest was run, and no manuscript text
was changed. The five results are paper-grade human proofs and have not been formalized; the
manuscript still states `prop:brianchon-support` with its Edge citation and the remaining four
statements in their current form.
