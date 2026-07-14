[REPORTED 2026-07-13]

# C124 — Petersen graph + chirality checks on the q=11 icosahedral MDS code

**Object**: same as C121 — q=11 non-GRS `[6,3,4]₁₁` MDS code, 6-arc columns from
`lean/RelativeConicArcs/Examples.lean:46` (`q11Witness`), conic `X·Z=Y²`. Arc stabilizer in
`PGL(2,11)` = 60-element `A₅` (exotic 2-transitive action on the 6 columns; cycle-type census
`(1,5)×24 + (3,3)×20 + (1,1,2,2)×15 + id×1`, confirmed in C121). The 20 weight-3 deep-hole
leaders = all `C(6,3)=20` column 3-subsets, split by `A₅` into two complementary size-10 orbits
`orbitA`/`orbitB` (`orbitB = {Sᶜ : S ∈ orbitA}`, `orbitA ∩ orbitB = ∅`).

**Method**: extended the C121 script (same `PGL(2,11)` enumeration, arc, witness data).
Script: `/tmp/claude-1000/-home-tavis-src-othello-rust/32d73511-d33d-463f-906c-3d5b62f92839/scratchpad/c124_check.py`
(plain `python3`, stdlib only).

## C124a — Petersen graph

**Vertices**: the 10 complementary pairs `{S, Sᶜ}` of column 3-subsets, canonicalised to their
`orbitA` representative (each pair has exactly one member in `orbitA`, one in `orbitB` — this was
already shown in C121; re-confirmed here).

Commands + output:

```
$ python3 c124_check.py
...
orbitA size 10, orbitB size 10, disjoint & complementary: OK

=== C124a: Petersen graph ===
orbit of vertex0 under A5 has size 10 (expect 10, transitive)
point-stabilizer of vertex0 has order 6 (expect 6, S3)
element orders present in point-stabilizer: [1, 2, 3] (S3 has orders {1,2,3}; Z6 would have order 6 present)
rule [disjoint (|S∩T|=0, using orbitA reps directly, no complement canonicalisation)]: |E|=0, degrees=[0]*10, 3-regular=False, girth=None, A5-invariant=True
rule [intersection size 1 (orbitA canonical reps)]: |E|=30, degrees=[6]*10, 3-regular=False, girth=3, A5-invariant=True
rule [intersection size 2 (orbitA canonical reps)]: |E|=15, degrees=[3]*10, 3-regular=True, girth=5, A5-invariant=True

Distribution of |S∩T| for canonical orbitA reps (all 45 unordered pairs): {2: 15, 1: 30}
```

**Adjacency rule that works**: fix the `orbitA` representative `S` for each vertex; two vertices
`S,T ∈ orbitA` are adjacent **iff `|S∩T|=2`** (equivalently `|S∩T|=1` is the complementary
"triangle-forming" rule, rejected — see below). This gives a graph with 10 vertices, 15 edges,
3-regular, **girth 5**, and it is `A₅`-invariant (checked against every one of the 60 group
elements acting on vertex indices). That is exactly the Petersen graph's defining data.

Notes on why this is the *natural* rule and not an artifact: for two distinct 3-subsets of a
6-set, `|S∩T|∈{1,2}` only (never 0 or 3 for distinct `orbitA` reps, since `|S∩T|=0` would force
`T=Sᶜ`, i.e. same vertex under our canonicalisation) — the two intersection sizes 1 and 2 are
literally the *only* nontrivial invariant available, and exactly one of the two choices
(`=2`, i.e. "share a pair") gives 3-regularity + girth 5; `=1` gives a 6-regular graph of girth 3
(the complementary/Kneser-type graph, which is the "collinearity"-triangle graph on `orbitA`, not
Petersen). So "share exactly 2 of 3 columns" is the correct rule, dual to "share exactly 1"
(consistent with Petersen's standard `K(5,2)`-disjointness description once translated through
the bijection to 2-subsets of a 5-set implied by the `S₃` point-stabilizer below).

**(i) Transitivity + stabilizer — PASS.** Orbit of one vertex under the 60-element `A₅` has size
10 (transitive). Point-stabilizer has order 6, element orders `{1,2,3}` present, no order-6
element ⇒ stabilizer is the non-abelian group of order 6, i.e. **`S₃`** (not `Z₆`, the only other
group of order 6). This is exactly the standard `A₅`-on-10-points action (point stabilizer `S₃`,
same as `A₅` acting on unordered pairs from a 5-set).

**(ii) Petersen graph — PASS.** 10 vertices, 15 edges, 3-regular, girth 5, `A₅`-invariant, with
adjacency rule **"share exactly 2 of the 3 columns."** `A₅` acts as a vertex-transitive subgroup
of `Aut(Petersen)` (order 60 ⊆ 120 = `|Aut(Petersen)| = S₅`); full `S₅`-automorphism identification
not separately re-derived here (well known: `Aut(Petersen) ≅ S₅` acting on 2-subsets of 5 points,
and our point-stabilizer `S₃` matches `Stab_{A₅}(pair)` in that model), but the `A₅` half is
directly certified.

**C124a verdict: PASS** — Petersen graph confirmed with adjacency rule "orbitA-canonical triples
share exactly 2 columns."

## C124b — chirality / five-tetrahedra

Commands + output:

```
=== C124b: chirality ===
total S6 permutations checked: 720
# permutations in S6 mapping orbitA -> orbitB (merge/reflection candidates): 60
# permutations in S6 mapping orbitA -> orbitA (preserve/normalizer candidates): 60
parity census of merge perms (0=even,1=odd): {1: 60}
parity census of preserve perms (0=even,1=odd): {0: 60}
A5 subset of preserve-normalizer group: True
|preserve group| = 60, |A5| = 60, preserve group == A5? True
EVEN permutations achieving the orbitA<->orbitB merge: 0
ODD permutations achieving the merge: 60
full group order: 120
closed under composition (is a subgroup): True
cycle types of merge (odd) perms: Counter({(1, 1, 4): 30, (6,): 20, (2, 2, 2): 10})
cycle types of A5 (even) perms: Counter({(1, 5): 24, (3, 3): 20, (1, 1, 2, 2): 15, (1,1,1,1,1,1): 1})
```

**What the Z/2 is, precisely.** Among all 720 permutations of the 6 columns:
- exactly 60 preserve `orbitA` setwise — these are **exactly** the arc-stabilizer `A₅` itself
  (`preserve_set == A5_set`, checked), all even;
- exactly 60 map `orbitA` onto `orbitB` (the "merge"/reflection candidates) — **all 60 are odd
  permutations**, zero are even;
- the union of these 120 permutations is closed under composition (verified by brute-force
  composition table), i.e. it is a genuine subgroup of `S₆` of order 120, with class sizes
  `{1,24,20,15,30,20,10}` — the exact class-size multiset of an abstract `S₅` (`1+10+20+30+24+15+20
  =120`), realized here via the **exotic/outer-automorphism embedding of `S₅` into `S₆`** (matches
  handoff L4: the arc stabilizer is the `A₅` half of the exotic hexad action, and its "reflection"
  extension is the corresponding exotic `S₅`).

So the Z/2 is precisely: **(exotic-`S₅` in `S₆`) / (exotic-`A₅` = actual arc stabilizer)**. It
separates `orbitA` from `orbitB` (equivalently separates the two size-10 leader classes / the two
"handedness" labelings of the deep-hole leaders), and the coset representing the swap consists
*only* of odd permutations. Since the code's actual projective automorphism group is exactly the
60-element `A₅` (established in C121: `PGL(2,11)` order 1320 fully enumerated, arc-stabilizer
= 60, and any code automorphism must fix the code's own canonical deep-hole conic, so lies inside
the conic's `PGL(2,11)`-stabilizer already enumerated) — **no automorphism of the actual code
merges the two orbits.** The merge requires an odd permutation, and `A₅` (only even permutations,
by definition/by the cycle-type census) contains none. This is a clean, checked instance of
"rotation group has no reflections."

**Five-tetrahedra structure — checked, does NOT drop out cleanly (PARTIAL / negative for the
fine claim).** Tested whether `orbitA`'s 10 elements carry an `A₅`-invariant finer structure of
5 pairs (as the "5 chiral tetrahedra, each split into an antipodal-style pair" reading would
need): brute-forced **all 945 perfect matchings** of the 10 vertices and **all size-(5+5)
bipartitions**, checked invariance under all 60 group elements:

```
A5-invariant perfect matchings (5-block systems) found: 0
A5-invariant 5+5 partitions found: 0
```

Zero invariant block systems of either kind exist — the `A₅` action on the 10 vertices is
**primitive** (this is the standard fact that the `A₅`/`S₅`-on-10-points = Petersen-vertex action
is primitive, rank-3). So while `10 = 2×5` numerically and the two-orbit chirality is real and
precisely characterized above, **the specific "each orbit further resolves into 5 chiral pairs of
tetrahedra" bijection is NOT combinatorially present** — there is no `A₅`-invariant way to group
either 10-vertex orbit into 5 pairs. Report this as suggestive-but-unconfirmed (matches the L2
directive not to overclaim the exact five-tetrahedra bijection); the confirmed content is the
Petersen graph (C124a) + the plain orbitA/orbitB chirality Z/2 (C124b core), not a finer
five-pair decomposition.

## Verdicts

- **C124a — PASS.** 10 complementary-pair vertices, transitive under `A₅`, point-stabilizer order
  6 (`S₃`, confirmed non-cyclic). Adjacency rule **"orbitA-canonical triples share exactly 2 of 3
  columns"** yields the Petersen graph exactly (10v/15e/3-regular/girth 5), `A₅`-invariant.
- **C124b — PASS (core chirality Z/2); PARTIAL/negative (five-tetrahedra fine structure).** The
  Z/2 = exotic-`S₅`/exotic-`A₅` (in `S₆`) separates `orbitA` from `orbitB`; the 60 permutations
  realizing the swap are all odd, the 60 preserving each orbit are exactly `A₅` (all even) — no
  even permutation, and in particular no actual code automorphism, merges the orbits. The finer
  claim that each 10-orbit further splits into 5 `A₅`-invariant chiral pairs is **refuted**
  computationally (no invariant perfect matching or 5+5 partition exists among the 945/126
  candidates checked) — the primitivity of the action rules it out. State the five-tetrahedra
  connection only at the `10 = 2×5`-numerology / Petersen level, not as an exact pairing.

## Cheap `decide`-grade Lean

Same style/scale as C121's (a computable `Finset`-valued `A₅` acting on `Fin 6`, once plumbed):

- **C124a.** Given the already-needed `stabGL`/induced-permutation `Finset` from C121, define
  `orbitA : Finset (Finset (Fin 6))` as the orbit of one 3-subset; `decide` `orbitA.card = 10`,
  transitivity, and stabilizer order 6. Define `petersenAdj S T := (S ∩ T).card = 2` on `orbitA`
  and `decide` 3-regularity + edge count 15 (girth-5 is a slightly bigger but still finite
  `decide`/`Decidable` check — shortest-cycle search over a 10-vertex graph, comparable cost to
  existing `Finset.powersetCard` proofs in the file).
- **C124b.** `decide` over `Finset.univ : Finset (Equiv.Perm (Fin 6))` (720 elements, same scale as
  the file's existing full-search lemmas): partition permutations into "preserve orbitA"
  (=`A₅`) vs "map orbitA to orbitB" (merge set), and `decide` the merge set is entirely odd
  (`Equiv.Perm.sign`) while the preserve set is entirely even and equals the existing arc-stabilizer
  `Finset`. The five-tetrahedra negative result (no invariant perfect matching) is also cheap:
  `decide` over the 945 perfect matchings of `Fin 10`... (would need `orbitA` as `Fin 10` first)
  that none is fixed setwise by every element of the 60-group.

## Script

`/tmp/claude-1000/-home-tavis-src-othello-rust/32d73511-d33d-463f-906c-3d5b62f92839/scratchpad/c124_check.py`
(extends C121's `c121_check.py`; also used inline via a follow-up snippet for the group-closure /
cycle-type / block-system checks — both captured verbatim above).
