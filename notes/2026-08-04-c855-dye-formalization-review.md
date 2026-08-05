# C855 adversarial review: chord-matching bijection and one-factorization modules (2026-08-04)

Adversarial pass over commits `fc263bdb` (chord-pairing bijection, `SixArcChordMatchings.lean`)
and `405b8d84` (one-factorization at equality, `SixArcOneFactorization.lean`), their dated
reports, the earlier C855 Lean chain, and the plan for eliminating
`RelativeConicArcs.ClebschDye.dye1991_equality_classification`.

## Scope and method

- Read in full: `lean/AGENTS.md`; both commit diffs; the two new modules; the supporting
  modules `SixArcConcurrence`, `SixArcConcurrenceBound`, `Moments`, `Arc`, `ProjectiveBridge`,
  `Q11DyeAxioms`, `GoldenHexagonNormalForm`, `SixArcPerspectivity` (header + main statement);
  the plan `notes/2026-08-04-c855-dye-axiom-elimination-plan.md`; both new reports; the earlier
  referee report `notes/2026-08-04-c855-dye-bound-referee.md`; the Dye 1991 scan set
  (`/tmp/persistent/tavis/lit-search/dye-1991/`, OCR pages 270–275 plus the authoritative page
  image `dye-275.png`).
- Independent computation (Python, exhaustive): all K6 perfect-matching facts, the
  one-factorization structure, the 720-relabelling feasibility question, and a GF(11) check of
  `Examples.q11Witness` and the golden hexagons. Scripts under the session scratchpad
  (`c855_check.py`, `c855_gf11.py`); every result below labelled "verified computationally" comes
  from an exhaustive run, not sampling.
- No build was run and no Lean file was edited. The reports' claims that both modules elaborate
  cleanly and that `#print axioms` shows only `propext`, `Classical.choice`, `Quot.sound` are
  taken on trust; nothing in the sources contradicts them, and neither new module contains an
  axiom, `sorry`, or `native_decide`.

## Verdict summary

The mathematics in both commits is correct, the statements match the reports at the claimed
generality, and the load-bearing feasibility question for the remaining route is settled
affirmatively by exhaustive computation (120 of the 720 relabellings work). One must-fix:
the Dye pinpoint in the `SixArcOneFactorization` header cites Section 2.2 for material that is
in the proof of Theorem 1 (Section 2.3), and omits the DOI its sibling modules carry. Everything
else found is optional or favorable (the remaining plan can be simplified; see D).

## A. Mathematical validity of the counting argument — sound

**"Each chord lies in exactly three chord matchings"** (`card_filter_mem_matchings`): correctly
stated for an arbitrary six-element subset of any type with decidable equality — no plane
structure at all (the `Combinatorial` section carries only `{P} [DecidableEq P]`). The proof
names the four off-chord points `a,b,c,d`, constructs the three matchings
`{e,ab,cd}, {e,ac,bd}, {e,ad,bc}`, proves both inclusions (the forward one by locating the chord
of the matching through `a` and forcing the third chord as the complement via
`eq_triple_of_mem`), and proves the three matchings pairwise distinct. Verified computationally:
K6 has 15 perfect matchings and every edge lies in exactly 3.

**Transport of the per-chord bound**: `card_filter_mem_concurrentMatchings` restricts the
chord-pairing bijection to a fixed chord `e`: concurrent matchings containing `e` correspond to
triple-concurrence points on `e.line`, via `x ↦ pairsThrough A x` with
`mem_pairsThrough : e ∈ pairsThrough A x ↔ x ∈ e.line`. Same chord, same line on both sides;
the filter predicate `x ∈ e.line (L := ProjectiveBridge.Point K)` in
`card_filter_mem_concurrentMatchings_eq_two` is literally the filter of
`SixArcConcurrence.card_triplePoints_on_secant_le_two`, so the bound of two transports with no
off-by-one. The general-plane statements really are general: the `Plane` sections of both
modules quantify over `[Configuration.ProjectivePlane P L]`; only the `Coordinate` sections
instantiate `L := ProjectiveBridge.Point K`, exactly where the per-secant bound (which needs the
quadrangle diagonal non-collinearity, hence coordinates and `(2 : K) ≠ 0`) enters. No hidden
coordinate assumption leaks into the plane-general statements.

**Saturation count**: 10 concurrent matchings x 3 chords = 30 incidences
(`sum_card_filter_mem`, a standard filter/sum swap, checked); 15 chords
(`card_arcPair` + `hcard`, `C(6,2) = 15` by `rfl`) x per-chord bound 2 = 30; `Finset.sum_lt_sum`
turns any strict deficit at one chord into `30 < 30`. Correct. The equality per chord then gives
exactly one non-concurrent matching per chord (`3 - 2`), five non-concurrent matchings
(`15 = 5 x 3`), and pairwise chord-disjointness (a shared chord would put two non-concurrent
matchings through it). All three equality theorems check out.

**No circularity.** Import DAG: `SixArcChordMatchings` imports only `SixArcConcurrence`;
`SixArcOneFactorization` imports `SixArcChordMatchings` and `SixArcConcurrenceBound`. The
per-secant bound is proved from `QuadrangleDiagonal` with no reference to chord matchings, and
the ten-point count enters the one-factorization theorems only as the hypothesis `hten`, never as
something derived inside the module. The bijection is used to transport the bound; the bound is
never used to prove the bijection.

**Injectivity and surjectivity of the bijection** (re-checked line by line): injectivity
(`eq_of_pairsThrough_eq`) takes two of the three chords through `x`; if `pairsThrough x =
pairsThrough y` with `x ≠ y`, both chords' lines pass through both points, so both equal the join
of `x` and `y`, contradicting `ArcPair.line_injective` on an arc. Surjectivity
(`triplePoint_of_concurrentAt`) is where `hcard` genuinely enters: the concurrence point is
off-arc (`notMem_of_concurrentAt`, using that the three pairs of a matching exhaust a six-arc,
so an on-arc concurrence point would sit on a second chord and force three collinear arc
points), and then `pointIndex_le_half_card` caps `pairsThrough x` at 3, forcing equality with
the given matching. Correct, including the degenerate-avoidance details.

## B. Statement fidelity — accurate; one favorable understatement

- The chord-pairing report claims the bijection over "an arbitrary finite projective plane, no
  coordinates, no characteristic hypothesis": matches the `Plane` section exactly.
- The one-factorization report claims the counting statements "hold for any six-element point
  set" and only the per-chord bound and final theorems need the coordinate plane with two
  invertible: matches, and `card_filter_mem_matchings` is in fact stronger than the module
  header's phrasing — it needs no incidence structure at all.
- `IsChordMatching` (three chords, pairwise disjoint endpoint pairs), `ConcurrentAt` (a common
  point on all three lines), `concurrentMatchings`, `matchings`, and `nonconcurrentMatchings
  = matchings \ concurrentMatchings` are the intended objects. For `|A| = 6` the partition
  property is a lemma (`biUnion_eq_of_isChordMatching`), not smuggled into the definition —
  correct design.
- Instance compatibility across modules: every finite set involved is a classical `filter` and
  every proof crosses module boundaries through the `mem_*` characterizations, never through
  definitional unfolding; `Fintype`/`Decidable` are subsingletons, so the locally instantiated
  instances in `SixArcChordMatchings`, `SixArcOneFactorization`, `SixArcConcurrence`, and
  `SixArcConcurrenceBound` cannot make the sets differ. The earlier referee pass reached the
  same conclusion for `brianchonPoints` vs `triplePoints` (definitionally identical filters,
  already bridged by the `simpa [brianchonPoints, SixArcConcurrence.triplePoints]` pattern in
  `dye1991_brianchon_bound`), and `ClebschDye.Point11 = Conic.Point K11` is an `abbrev` chain
  down to `ProjectiveBridge.Point (ZMod 11)` (`Conic.lean:315`), so the new coordinate-section
  theorems apply to the axiom's type with no bridge.

## C. Sufficiency for `dye1991_equality_classification` — gap is as claimed, nothing structural missing

Landed and sufficient so far: ten triple points ⇒ ten concurrent matchings (bijection) ⇒ five
pairwise-disjoint non-concurrent matchings partitioning the chords, every other matching
concurrent (definitional from `nonconcurrentMatchings`). Landed separately: the golden normal
form from four labelled concurrences, and the double-perspectivity theorem.

Remaining, matching the reports' own list:

1. **Labelled-hexagon extraction.** Choose two distinct factors (exists since the count is
   five; disjoint by `disjoint_of_mem_nonconcurrentMatchings`), prove their union is a
   six-cycle, and extract the labelling `p1..p6`. Then relabel (see D(iii)) and show the four
   golden matchings are concurrent. Engineering notes, not gaps: (a) the chord-construction and
   `isChordMatching_triple` helpers the labelling module will want are currently `private` in
   `SixArcOneFactorization` — they will need public, docstringed homes; (b) the concurrence
   hypotheses arrive as `ConcurrentAt`/`e.line` memberships and must be converted to
   `ProjectiveCap.Projective.Collinear` triples via
   `ProjectiveBridge.collinear_iff_projective_collinear` — routine, and the pattern exists in
   `SixArcConcurrenceBound`.
2. **Discharging the golden theorem's non-degeneracies.** Simpler than the reports suggest: the
   golden module's own header observation is right that they follow from the arc condition plus
   `x ∉ {p1..p6}` *given the concurrence hypotheses already assumed* — e.g. if `p1,p3,x` were
   collinear then with `p1,p2,x` collinear and `x ≠ p1` the points `p2,p3` share the line
   through `p1,x`, three collinear arc points; so `x = p1`, excluded. `x ∉ A` is landed
   (`notMem_of_concurrentAt`). No triple-point machinery needed here.
3. **Order-eleven identification.** `φ * φ = φ + 1` over `ZMod 11` forces `φ = 4 ∨ φ = 8`
   (decidable). Verified computationally in GF(11): `Examples.q11Witness` is a six-arc with
   exactly 10 Brianchon points, and **both** golden hexagons map onto it by explicit
   projectivities — φ = 4 via the matrix rows `(2,0,10),(9,9,7),(0,3,4)` and φ = 8 via
   `(1,7,9),(10,6,9),(0,5,8)` (acting on column vectors, mod 11). So no root normalization is
   needed: handle each root with its own explicit matrix. The Lean work is a linear equiv from
   the golden frame `u` to the standard basis composed with the explicit matrix, plus six
   projective-point equalities with explicit scalars, plus the `Finset.map` bookkeeping to hit
   `clebschWitness`. Fiddly, finite, mentioned in the plan.

I found nothing needed that no landed theorem supplies and the plan does not mention.

## D. The remaining plan, attacked and computed

**(i) Two factors give a six-cycle — correct, and stronger than stated.** Verified
computationally: the union of *any* two edge-disjoint perfect matchings of K6 is a single
six-cycle (a 4+2 split would need a repeated edge). In the labelling `p1..p6` along the cycle
the two factors are exactly `{p1p2,p3p4,p5p6}` and `{p1p6,p2p3,p4p5}` — the construction is
correct. The Lean case analysis is the alternating-walk argument: each successive vertex is new
because a repeat would either put two factor-edges through one vertex (intra-factor
disjointness) or make the two factors share a 2-subset (inter-factor disjointness, with the
4-cycle closure killed by the leftover pair belonging to both factors). Bounded and small —
three walk steps, each with a two-case distinctness check; comparable in size to
`card_filter_mem_matchings`.

**(ii) The remaining three factors are forced — verified, but see (v): not needed.** Verified
computationally: the complement of the six-cycle is the triangular prism; it has four perfect
matchings (`{13,25,46}, {14,25,36}, {14,26,35}, {15,24,36}` in cycle labels) but a *unique*
one-factorization (`{13,25,46}, {14,26,35}, {15,24,36}` — the all-diagonals matching
`{14,25,36}` meets every other prism matching in an edge). Equivalently: exactly one of the six
one-factorizations of K6 contains both cycle factors. The claimed "standard total" is
`{12,34,56}, {16,23,45}, {13,25,46}, {14,26,35}, {15,24,36}`.

**(iii) The load-bearing feasibility question — YES, with 120 witnesses.** Exhaustive check
over all 720 relabellings, against the standard total `F` above, for the four matchings the
golden module consumes (`M1 = {12,34,56}`, `M2 = {14,23,56}`, `M3 = {13,25,46}`,
`M4 = {14,25,36}`; read off the theorem statement, confirmed): a relabelling is genuinely
required (identity fails: `M1, M3 ∈ F`), and **120 of the 720 permutations send all four off
`F`** — and the same count 120 holds for every one of the six one-factorizations, as it must by
symmetry. Explicit witness: the 3-cycle `σ = (4 5 6)`, i.e. relabel `q1 = p1, q2 = p2, q3 = p3,
q4 = p5, q5 = p6, q6 = p4`. The four golden matchings then correspond, in the original cycle
labels, to `{12,35,46}, {15,23,46}, {13,26,45}, {15,26,34}` — none in `F`.

**(iv) Discarding the transitivity route loses nothing — and more.** The counting route fully
replaces the transitivity/5+1-partition route for the equality structure; nothing downstream
consumed the partition-by-classes form. Stronger: the one-factorization report's sentence that
the triple-perspectivity theorem "remains needed later, to place the concurrences in the
hexagonal labelling" appears to be wrong in the favorable direction. The four relabelled
matchings are concurrent *directly* — concurrent = any matching outside the five factors — so no
perspectivity is invoked anywhere in the remaining chain. `SixArcPerspectivity` will likely end
up unused by the axiom elimination (it stands alone as a clean theorem; no compliance problem,
but the report sentence and handoff expectation should be corrected when the labelling module
lands).

**(v) Cheaper and more robust than the plan for what remains.**
- *Skip (ii) entirely — the shared-edge trick.* To show a relabelled matching `M` is concurrent
  you do not need the three prism factors: each of the four witness images above shares a chord
  with `F1 = {12,34,56}` or `F2 = {16,23,45}` while being distinct from both (`{12,35,46}` shares
  `12` with `F1`; `{15,23,46}` shares `23` with `F2`; `{13,26,45}` shares `45` with `F2`;
  `{15,26,34}` shares `34` with `F1`). A matching sharing a chord with a factor and distinct
  from it cannot itself be a factor (`disjoint_of_mem_nonconcurrentMatchings`), hence is
  concurrent. This removes the prism-uniqueness formalization from the critical path
  completely; only `F1`, `F2` and the six-cycle labelling are ever needed.
- *No root normalization at order eleven*: both `φ = 4` and `φ = 8` have explicit projectivities
  onto `q11Witness` (matrices above); case-split on the disjunction and finish each branch with
  its matrix.
- *Non-degeneracy discharge* via the two-concurrences-through-one-vertex argument of C.2, which
  needs only `Arc`, `x ∉ A`, and the concurrences already in hand.

## E. Referee-facing compliance of the two new modules

- **Docstrings**: every non-private declaration in both modules has a self-contained docstring;
  the private helpers are documented too. No status prose, no workflow vocabulary, no task IDs,
  no internal references, no novelty claims, in either module. Names are stable and
  mathematical; `SixArcOneFactorization` as a module name is backed by the three theorems that
  jointly witness the partition.
- **Citation pinpoint — must fix.** The `SixArcOneFactorization` header attributes "the
  combinatorial half of the classification of the six-arcs attaining the bound" to Dye 1991
  "Section 2.2, page 275". Verified against the page image `dye-275.png`: Section 2.2 ends at
  the top of page 275 with the ten-point bound; the equality analysis — each edge has exactly
  two Brianchon points, hence the five edge-triangles, which are exactly this module's five
  non-concurrent matchings — is in the *proof of Theorem 1, Section 2.3*, lower on page 275.
  The pinpoint should read Theorem 1 / Section 2.3, page 275. The header also omits the DOI
  (`doi:10.1112/jlms/s2-44.2.270`) that `SixArcConcurrenceBound` and `Q11DyeAxioms` include;
  `lean/AGENTS.md` requires the stable identifier when available.
- **The claim at the pinpoint is otherwise the claim made there.** Dye's "five triangles whose
  sides are edges of H and whose vertices are not vertices of H" are precisely the
  non-concurrent chord matchings (a triangle of chords = three pairwise-intersecting,
  non-concurrent chords covering the six vertices), so the mathematical attribution is right.
  Also re-verified from the scans: hexagon = six points no three collinear (p. 270); Clebsch
  hexagon = hexagon with exactly 10 Brianchon points (p. 271); Theorem 1(ii) = PGL3(K)
  transitivity, stated on p. 275 with H* as the canonical Clebsch hexagon — so the axiom's
  statement is a faithful rendering of Theorem 1(ii) plus H*'s membership, and the
  `Q11DyeAxioms` pinpoints are correct as they stand.
- `SixArcChordMatchings` cites nothing external, appropriately — its content is plane-general
  incidence combinatorics.

## Replay of the computational claims

The exhaustive searches behind Sections D(ii), D(iii) and C.3 are committed as tracked programs and
require only a standard Python 3 interpreter:

```
python3 notes/2026-08-04-c855-hexagon-labelling-search.py
python3 notes/2026-08-04-c855-golden-witness-projectivity.py
python3 notes/2026-08-04-c855-golden-witness-projectivity-replay.py
```

The first enumerates the fifteen perfect matchings of the complete graph on the six arc points, the
six one-factorizations, the unique one-factorization containing two given edge-disjoint factors, and
all 720 relabellings, reporting the 120 that carry the four golden matchings off the standard total.
The second checks in the projective plane over the field of eleven elements that
`Examples.q11Witness` is a six-arc with exactly ten triple-concurrence points and finds explicit
projectivities carrying each golden hexagon onto it. The third is an independent program written
against the same witness list; it confirms the existence of both projectivities and returns
different matrices, as it should, since the projectivities are not unique.

## Findings ranked

Must fix before the module backs a gate or a paper claim:

1. `SixArcOneFactorization.lean` header: change the Dye pinpoint from "Section 2.2, page 275"
   to the proof of Theorem 1 (Section 2.3), page 275, and add the DOI. (Section E; a one-line
   prose fix in the owning lane's next Lean edit window.)

Optional / for the next task:

2. Correct the "triple-perspectivity remains needed later" sentence in
   `notes/2026-08-04-c855-one-factorization.md` (or supersede it in the labelling task's
   report): the remaining chain does not need `SixArcPerspectivity` at all. (Section D(iv).)
3. When building the labelling module, use the shared-edge trick of D(v) and drop the prism
   forcing from the critical path; expose (or re-prove publicly) the currently private
   `isChordMatching_triple`-style constructors.
4. Bank the computational witnesses from this review for the labelling task: the relabelling
   `q4 = p5, q5 = p6, q6 = p4`, and the two GF(11) matrices `(2,0,10;9,9,7;0,3,4)` for φ = 4 and
   `(1,7,9;10,6,9;0,5,8)` for φ = 8 carrying the golden hexagon onto `q11Witness`.

No other defect found: the two commits' mathematics, statements, generality claims, instance
plumbing, handoff paragraph, and report claims (modulo finding 2) all withstood the pass.
