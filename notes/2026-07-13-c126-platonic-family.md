[REPORTED 2026-07-13]

# C126 — mod-p Platonic family: Family A construction + chirality across solids

**Task**: replicate the q=11 icosahedral `[6,3,4]₁₁` construction (arc = poles of antipodal-vertex
axis chords; deep holes = conic; chirality = unmergeable orbit split) for the other Platonic
rotation groups at their Family-A matching primes (vertex count = p+1): octahedron/p=5 (S₄),
cube/p=7 (S₄), tetrahedron/p=3 (A₄), dodecahedron/p=19 (A₅); icosahedron/p=11 (A₅) re-run as
cross-check.

**Method**: generalized `c121_check.py`/`c124_check.py` to arbitrary prime `p`. For each case:
enumerate `PGL(2,p)` (Möbius maps on `P¹(F_p)`, `p+1` points, deduped by induced permutation);
search for a subgroup `G` of the target order by generating from pairs of elements of matching
orders (e.g. order-2 + order-3 for `A₄`/`S₄`/`A₅`) and testing closure order + transitivity;
confirm `G`'s point-stabilizer order/cyclicity; find the **antipodal partner** of a point (the
other rational fixed point of a nontrivial point-stabilizer element — a genuine vertex–vertex
rotation axis iff this exists); build the arc as poles (wrt conic `X·Z=Y²`) of the secant lines
through each antipodal pair; test arc property (no 3 collinear), "complete outside the conic"
(secant-covered set of `PG(2,p)` minus arc equals exactly `PG(2,p)` minus its uncovered set, and
that uncovered set should equal the conic); build weight-3 deep-hole leaders for target
`conicVec(0)` and test `G`'s orbit structure on them, plus (where feasible) exhaustive search over
`S_k` (k = arc size) for any permutation — odd or even — realizing an orbit merge.

Scripts (scratchpad, plain `python3`, stdlib only):
`/tmp/claude-1000/-home-tavis-src-othello-rust/32d73511-d33d-463f-906c-3d5b62f92839/scratchpad/c126_check.py`
(main driver, all 5 cases), plus two standalone follow-ups for the dodecahedron merge-search
(`c126_dodeca_merge.py`) and octahedron column-parity (`c126_octa_parity.py`).

## Per-solid table

| Solid          | Group | Order | p  | Vertex-orbit fills P¹(F_p)? | Point-stab (cyclic?) | Antipodal axis exists? | Arc size | Arc (no 3 collinear)? | Complete outside conic? | Chirality |
|----------------|-------|-------|----|------------------------------|-----------------------|--------------------------|----------|------------------------|--------------------------|-----------|
| Tetrahedron    | A₄    | 12    | 3  | Yes (4/4)                    | order 3, cyclic       | **No** (parabolic, 1 fixed pt) | — (no construction) | — | — | N/A (see below) |
| Octahedron     | S₄    | 24    | 5  | Yes (6/6)                    | order 4, cyclic       | Yes                      | 3        | Yes                    | **No** (all 6 conic pts wrongly covered; 16 extra non-conic pts uncovered) | Vacuous (arc too small: C(3,3)=1, not even a valid weight-3 leader) — but independently: G's induced action on the 3 poles is the **full S₃** (all 6 perms, 3 even+3 odd) |
| Cube           | S₄    | 24    | 7  | Yes (8/8)                    | order 3, cyclic       | Yes                      | 4        | Yes                    | **No** (conic fully uncovered — correct direction — but 12 extra non-conic pts also uncovered) | **Not chiral**: single G-orbit of size 4 on all C(4,3)=4 leaders; G's induced action on columns already contains odd perms (12 even + 12 odd of 24) |
| Icosahedron ✓  | A₅    | 60    | 11 | Yes (12/12)                  | order 5, cyclic       | Yes                      | 6        | Yes                    | **Yes** (uncovered = exactly the 12 conic pts) | **Chiral**: 2 complementary orbits (10,10); G all-even (parity {0:60}); merge requires odd `S₆` perm only (0 even merges of 60 found) — reproduces C121/C124 exactly |
| Dodecahedron   | A₅    | 60    | 19 | Yes (20/20)                  | order 3, cyclic       | Yes                      | 10       | Yes                    | **No** (over-covers: uncovered = 0, arc's 45 secants swallow the entire plane including the conic) | **Does not cleanly instantiate the 2-orbit picture**: 96 leaders split into **5** G-orbits, sizes [7,14,24,24,27] (not a clean complementary 2-split); G still entirely even (parity {0:60}); exhaustive search over **all 3,628,800** permutations of `S₁₀` found **zero** permutations (odd or even) mapping the two size-24 orbits onto each other — a strictly stronger "unmergeable" result than the icosahedron case, but not the same S/Sᶜ chirality structure |

## Key verbatim output

```
Tetrahedron (A4): p=3, |G|=12, expect point-stab order 3
Found subgroup G, |G| = 12 (target 12) via generator orders (2, 3)
Orbit of point 0 under G has size 4 / 4 -> transitive = True
|Stab_G(0)| = 3 (expect 3)
Fixed-point sets of nontrivial Stab_G(0) elements: [(3, (0,))]
Antipodal partner of point 0 (2 rational fixed points incl. 0): None
NO antipodal vertex-vertex axis exists for Tetrahedron (A4) at p=3

Octahedron (S4): p=5, |G|=24
Antipodal partner of point 0: 4; axes orbit size 3; arc size 3; no-3-collinear = True
|covered by arc+secants| = 15, |uncovered| = 16, uncovered == conic (6 pts) = False
  conic - uncovered = {6 pts}   (i.e. ALL 6 conic points are wrongly covered)
octa parity follow-up: distinct col perms on the 3 arc columns: 6
parity census: {1: 3, 0: 3}   (G realizes the FULL S3 on the 3 poles)

Cube (S4): p=7, |G|=24
Antipodal partner of point 0: 2; axes orbit size 4; arc size 4; no-3-collinear = True
|covered| = 37, |uncovered| = 20, conic - uncovered = set()   (conic fully uncovered, correct
  direction, but 12 extra non-conic points also uncovered)
Weight-3 leaders: 4/4; G-orbits on leaders: 1 orbit of size 4 (trivially non-chiral)
Parity census of G's induced column-perms: {0: 12, 1: 12}

Icosahedron (A5) [cross-check]: p=11, |G|=60
Antipodal partner of point 0: 5; axes orbit size 6; arc size 6
|covered| = 121, |uncovered| = 12, uncovered == conic (12 pts) = True
Weight-3 leaders: 20/20; G-orbits: 2 orbits of size 10 each
Parity census: {0: 60} (G all even)
Permutations of S6 merging orbit0 into other orbit: 60, parity census: {1: 60}
EVEN merges available: 0 -> CHIRAL
[matches C121/C124 exactly — cross-check PASS]

Dodecahedron (A5): p=19, |G|=60
Antipodal partner of point 0: 9; axes orbit size 10; arc size 10
|covered| = 381 (= all of PG(2,19)), |uncovered| = 0  (over-covers; conic - uncovered = 20 pts,
  i.e. all 20 conic points wrongly covered too)
Weight-3 leaders: 96/120; G-orbits: 5 orbits, sizes [7, 14, 24, 24, 27]
Parity census: {0: 60} (G all even)
searching S_10 for a permutation mapping the two size-24 orbits onto each other...
NO merge permutation found in all of S_10 (3,628,800 checked), elapsed ~26s
```

## Findings

1. **Group embedding (step 1) works cleanly for all five cases.** `A₄`⊂`PGL(2,3)`,
   `S₄`⊂`PGL(2,5)`, `S₄`⊂`PGL(2,7)`, `A₅`⊂`PGL(2,11)`, `A₅`⊂`PGL(2,19)` all instantiate at the
   correct order, transitive on the full `p+1` points, with cyclic point-stabilizer of the
   predicted vertex-valence order (3,4,3,5,3 respectively). `PGL(2,3)` has order 24 = 4! and is
   in fact the full `S₄` (well-known isomorphism `PGL(2,3)≅S₄`) — so the tetrahedron's "reflection"
   extension is not an abstract outer construction, it is **already the ambient conic-stabilizer
   group itself**.

2. **The antipodal-axis construction (step 2) genuinely fails for the tetrahedron, for a precise
   arithmetic reason, not an oversight.** The order-3 point-stabilizer generator has `order = p`
   (since `p=3`), making it a **parabolic** Möbius map (repeated/single rational fixed point), not
   hyperbolic — it fixes only the point itself, no second rational point. This matches the
   well-known geometric fact that the **tetrahedron has no central symmetry / no antipodal vertex
   pairs** (its 3-fold axes run vertex-to-opposite-face-centroid, not vertex-to-vertex) — the
   arithmetic obstruction (order-3 = order-`p` parabolic) is the exact mod-3 shadow of that
   geometric fact. No substitute vertex-based axis construction is available at any prime for the
   tetrahedron (it structurally lacks the required symmetry), so **the arc-pole construction does
   not apply to the tetrahedron at all** — reported as a genuine negative, not forced.

3. **"Complete outside the conic" (deep holes = conic exactly) is *not* a generic Family-A
   phenomenon — it is special to the icosahedron/p=11 case.** Octahedron and cube under-cover
   (arc too small: 3 and 4 points respectively, `C(3,2)=3` / `C(4,2)=6` secants cannot reach
   `PG(2,p)`'s ~25–49 non-conic points) and, worse, octahedron's secants *do* cover all 6 conic
   points (getting the direction wrong entirely), while cube's secants correctly leave the whole
   conic uncovered but also leave 12 extra non-conic points uncovered (partial success: `conic ⊆
   uncovered` holds, but not equality). Dodecahedron over-covers in the opposite direction (10
   points, 45 secants, swallows literally everything including the conic — 0 points left
   uncovered at all). Only icosahedron/p=11 hits the exact equality. This sharpens the handoff's
   own uniqueness claim ("p=11 is the only prime where Family A and Family B coincide") into a
   second, independent uniqueness axis: **p=11 is also the only Family-A case where this specific
   secant-covering construction is exactly deep-holes-equal-conic**, not merely close.

4. **Chirality prediction (reflection-free ⟺ chiral): CONFIRMED, with one genuine complication.**
   - **Cube (S₄): non-chiral, confirmed strongly.** Not only does *some* even merge exist — `G`
     itself (order 24) already acts as the **full** symmetric group on the arc's induced
     structure (single orbit of size 4 under G alone; separately, on the 3-axis-pole structure for
     the octahedron, `G` realizes the **entire `S₃`**, 3 even + 3 odd permutations). No appeal to
     an outer/abstract extension is even needed — the rotation group's own odd elements already do
     the job. This matches the theoretical explanation: `S₄`'s abelianization is `Z/2` (the sign
     map), so it is entirely expected (and here confirmed) that its natural actions carry odd
     permutations.
   - **Icosahedron (A₅): chiral, reproduced exactly** (2 complementary orbits of 10, all of `G`
     even, merge requires an odd `S₆` element, 0 even merges — identical to C121/C124).
   - **Dodecahedron (A₅): the *necessary condition* for chirality holds (`G`'s induced action is
     entirely even — parity census `{0:60}`, forced by `A₅` being simple: `Hom(A₅,Z/2)=0`, so
     *any* permutation representation of `A₅` is automatically all-even, not a coincidence of this
     particular action) — but the clean "2 complementary orbits, S vs Sᶜ" structure from the
     icosahedron does **not** carry over.** With arc size 10, the 96 valid weight-3 leaders split
     into **5** `G`-orbits (sizes 7,14,24,24,27), not a 2-way split (a 3-subset of a 10-set has no
     natural size-preserving "complement" the way a 3-subset of a 6-set does). The only candidate
     pair of equal-size orbits (24,24) was tested by **exhaustive brute force over all 3,628,800
     permutations of `S₁₀`** — zero permutations, odd or even, map one onto the other. So the
     obstruction here is *stronger* than "chiral" in the icosahedron sense (unmergeable by *any*
     relabeling at all, not just by rotation-type ones) — but it is a **different combinatorial
     phenomenon** (5-way split, not a 2-way chirality split), so it should **not** be reported as a
     direct confirmation of the same "orbitA/orbitB chirality Z/2" structure, only as a further,
     more complex instance of "no automorphism merges the orbits," consistent with (but not a
     clean instance of) the reflection-free ⟹ unmergeable direction.
   - **Tetrahedron:** no arc-based chirality test is possible (step 2 failure, see #2). The only
     available structural evidence is at the group level: `PGL(2,3) ≅ S₄` already contains `A₄` as
     an index-2 subgroup, so if some `A₄`-invariant structure on the 4 points *did* split into two
     orbits, the merge would already be realized by an element of the ambient conic-stabilizer
     group itself (no abstract extension needed) — suggestive of non-chirality, but this is an
     argument about the ambient group, not a computed chirality result, since no analogous
     leader/orbit structure exists to test directly.

## Verdict on the chirality-iff-reflection-free prediction

**Directionally confirmed, with the dodecahedron flagging that the prediction's *clean form*
(a single unmergeable Z/2, S-vs-Sᶜ) is specific to the icosahedron/p=11 arc-size-6 case, not a
generic feature of every reflection-free (`A₄`/`A₅`) case:**

- **S₄ cases (octahedron, cube) are unambiguously non-chiral** — cube gives a clean, strong
  confirmation (single G-orbit, G itself odd-inclusive); octahedron's test is vacuous at the
  leader level (arc too small) but independently confirms `G` realizes the full `S₃` on its 3
  poles, so no obstruction could exist regardless.
- **A₅ at p=11 (icosahedron) is unambiguously chiral** in the precise "even-only orbit split,
  unmergeable except by an odd permutation" sense — reproduced exactly as a cross-check.
- **A₅ at p=19 (dodecahedron) is "even-only" (the necessary condition, forced by A₅'s simplicity)
  and its orbits are unmergeable by brute force** — consistent with, but not a clean instance of,
  the same chirality structure; the finer 2-orbit/complement picture is an accident of arc size 6
  (=6 choose 3, with a genuine complement operation on a 6-set), not a generic consequence of
  `A₅`-reflection-freeness.
- **A₄ at p=3 (tetrahedron) cannot be tested this way at all** — the construction itself doesn't
  instantiate (no antipodal axis exists, arithmetically because `p=3` makes the relevant
  stabilizer element parabolic rather than hyperbolic, which is the precise mod-3 shadow of the
  tetrahedron's genuine lack of central symmetry).

**Net**: the "reflection-free groups (A₄/A₅) are forced to act by even permutations, so any orbit
split they produce cannot be merged by their own elements — merging (if possible at all) needs an
odd permutation, i.e. groups with reflections (S₄) merge trivially, reflection-free groups don't"
argument is a theorem (not a coincidence): `Hom(A_n,\mathbb Z/2)=0` for `n=4,5` (abelianizations
`\mathbb Z/3` and trivial respectively) forces every permutation representation of `A₄`/`A₅` to be
all-even, while `S₄`'s nontrivial sign character makes odd images generic. The icosahedron's
*exact* 2-orbit chirality Z/2 is the sharpest instance of this at Family-A arc size 6; the
dodecahedron shows the same all-even necessary condition and the same brute-force unmergeability,
but the specific arc size (10) breaks the clean complementary-pair packaging into a messier 5-orbit
split — report this as the honest, more complex picture rather than forcing a five-orbit/two-orbit
narrative onto it.
