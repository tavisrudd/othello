# C1020 — Brouwer's exceptional complete-exterior-set census, reconstructed, with the lane's invariants

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-08-31
**Status**: **REPORTED, PROVISIONAL.** Every verdict below is one mining session's reasoning over its
own computation and is **not load-bearing until a stronger reasoning model has vetted it**
(`notes/handoffs/2026-07-14-gem-mining.md`, provisional gate). This session did not self-vet and did
not commission a vet.

**What this closes.** `notes/2026-07-15-c193-bsw-exceptional-census.md` § The Petersen echo declared a
null and left it uncomputed: *"is BSW's q=31 Petersen the same structure as the lane's q=11
Brianchon–Petersen, or a coincidence of 10s and 15s?"*, with *"The Petersen echo not computed … the
null is not refuted"* as its own open item. It is now computed.

---

## 1. Verdict

**The declared null is refuted, and the two configurations are the same object.**

At `q = 31` the exceptional complete exterior set of the conic is exactly **a six-arc together with
its ten Brianchon points**, the ten points being the concurrency points of the ten perfect matchings
of the arc's fifteen chords that happen to concur. Every one of the fifteen chords carries exactly
two of the ten, and the resulting cubic graph on ten vertices and fifteen edges **is the Petersen
graph**. That six-subset split of the sixteen points is **unique**: of the 453 six-subsets that are
arcs, 28 have the full complement of ten Brianchon points, and exactly one has its ten Brianchon
points equal to the complementary ten points of the exterior set.

The `q = 11` Clebsch hexagon has the identical structure: ten Brianchon points, each chord carrying
two of them, chord graph the Petersen graph.

**The setwise stabilisers are the same group, checked by element orders rather than by order alone.**
Both are of order 60 with element-order spectrum `{1: 1, 2: 15, 3: 20, 5: 24}`, which is `A₅` and
nothing else of order 60. Across the *entire* exceptional census — eight configurations at six values
of `q` — `A₅` occurs exactly twice, at `q = 11` and at `q = 31`, and those are exactly the two
carrying the six-arc-plus-Petersen structure. No other exceptional configuration contains a
six-subset with the shape at all.

**The one discriminator is the type of the Brianchon points.** At `q = 11` all ten are *internal*, so
they lie outside the exterior set and the six-arc alone is already complete, because
`(q+1)/2 = 6`. At `q = 31` all ten are *external*, so they belong to the exterior set, and the arc
alone is not complete — the completion is precisely `6 + 10 = 16 = (q+1)/2`. Seen this way the two
BSW entries are one configuration at two different completion levels, and Edge's "endowed ten times
over with the Brianchon property" describes both.

**Priority, added 2026-08-31 after the C1022 audit — most of the above is Dye's, not ours.**
`notes/2026-08-31-c1022-q31-clebsch-recurrence-novelty-audit.md` finds the same-figure claim, the
two-Brianchon-points-per-chord structure, the `A₅` stabiliser, and the internal-versus-external
discriminator all already in R. H. Dye, "Hexagons, conics, `A₅` and `PSL₂(K)`", J. London Math. Soc.
(2) **44** (1991) 270–286, read at full text from the page scans. Dye gives the discriminator as a
congruence rather than a case split — italicised on p. 282, *the Brianchon points are external if
`q ≡ 1 (mod 3)`*, with the vertex condition on p. 284 — and substituting `q = 11` and `q = 31`
reproduces this section's finding exactly. **What survives with no located predecessor is only the
bridge to Brouwer's census:** that BSW's `q = 31` exceptional complete exterior set *is* the Clebsch
hexagon plus its ten Brianchon points, and that the two census entries are one figure at two
completion levels. Dye and BSW never cite each other, and no work located across OpenAlex, Crossref
and Semantic Scholar cites both. State the contribution as that bridge and cite Dye for the figure.

**What the null got wrong, stated exactly.** C193's null was *"the 15-edge/10-vertex match is forced
by any 6-arc and carries no content"*. It is not forced: over the 453 six-subset arcs inside the
`q = 31` configuration the Brianchon count runs `0, 2, 3, 4, 6, 10` with multiplicities
`120, 270, 10, 20, 5, 28`, and at `q = 19, 23, 27` the best six-subset of the exceptional
configuration reaches only 6, 4 and 6 Brianchon points respectively, never 10. Ten is the top of the
spectrum and it is attained by the special configurations, not by six-arcs generally.

**Scope limit, stated plainly.** This settles that the two configurations carry the same structure and
the same stabiliser. It does **not** supply a mechanism, and it does not show that a six-arc with ten
Brianchon points forces a complete exterior set. Both of those are open and are recorded in the
mystery ledger.

---

## 2. Definitions, fixed in code rather than assumed

Fix the nondegenerate conic `C` in `PG(2,q)`, `q` odd. A line is a **secant**, **tangent** or
**passant** as it meets `C` in two, one or zero points; a point off `C` is **external** if it lies on
two tangents and **internal** if it lies on none. An **exterior set** is a set of external points
whose pairwise joins are all passants.

Two facts fix the search; both are re-derived in the run rather than quoted.

- **Distinct points of an exterior set have disjoint tangent pairs**, since two points sharing a
  tangent would be joined by that tangent rather than by a passant. Hence every exterior set has at
  most `(q+1)/2` points, and one of exactly that size has tangent pairs partitioning the `q+1`
  tangents of `C`. The run checks the partition directly for every maximum-size configuration.

- **"Complete" has to mean maximum-size, not merely maximal, and the lane's record did not carry
  this.** Under maximal-under-inclusion the classification in BSW §3 is not complete: exterior sets
  that cannot be extended but have fewer than `(q+1)/2` points exist in quantity at every `q` from 9
  upward, including at `q = 13, 17, 25, 29` where BSW's theorem forbids non-linear examples of full
  size. The size histograms in §4 record them. Under the maximum-size reading the reconstruction
  matches BSW §3 exactly in all six of their cells and in all four control cells.

**A tempting stronger reading is false, and the run caught it.** It is natural to define a complete
exterior set as one for which `C ∪ S` is a set without tangents — no line meeting it in exactly one
point — which is BSW §1's motivating construction, their `q = 11` example being *"18 = 12 + 6 points
consisting of the 12 points of a conic together with a set of 6 exterior points"*. That reading is
correct at `q = 11`, where `C ∪ S` has 18 points and no line meets it once. It **fails at `q = 31`**:
there `C ∪ S` has 48 points and 120 lines meet it exactly once. The tangent lines are fine at both —
the failure is in the passants, and it is forced by the line profile. At `q = 11` each of the six
points lies on five passants and the fifteen joins account for all `6 × 5 = 30` incidences, so every
passant through a point of `S` carries a second one. At `q = 31` each of the sixteen points lies on
fifteen passants, giving 240 incidences, while the joins carry only `30 × 2 + 15 × 4 = 120`; the
other 120 are single-hit passants. So BSW's `18 = 12 + 6` tangent-free example is special to
`q = 11` and does not generalise along their own exceptional list.

---

## 3. Method, primitives, and cost

The census runs on the graph `G` whose vertices are the `q(q+1)/2` external points and whose edges
are the pairs joined by a passant; exterior sets are the cliques of `G` and maximal exterior sets are
its maximal cliques. `PGL(2,q)` — the stabiliser of `C` in `PGL(3,q)`, realised as the symmetric
square of the natural two-dimensional action — is transitive on external points, so every isomorphism
class has a representative through one fixed external point, and enumerating the maximal cliques of
that point's neighbourhood is exhaustive. Classes are separated by orbit marking under the full conic
stabiliser: `PGL(2,q)` for prime `q`, `PΓL(2,q)` for `q = 9, 25, 27`. Orbit size times stabiliser
order equals the group order in every class, which is the run's internal consistency check.

**Ergodis primitives used, core read-only throughout.** `field::SmallField` for `GF(p^h)` arithmetic
and `projective::ProjectiveIndex` for allocation-free ranking and unranking of `PG(2,q)` — both
landed in the Ergodis core on 2026-08-31 in commit `62fcd5f28`, and they are what let `q = 9, 25, 27`
run in the same driver as the primes rather than needing a hand-written extension field. No core file
was modified, and the driver is additive under `src/bin` autodiscovery with no manifest edit. The
bitset Bron–Kerbosch with pivoting is written in the driver, since the core has no clique engine.

**Cost.** Far below the roughly `2·10⁹` projective-point census ceiling measured in
`notes/2026-08-30-c1018-hunt-prs-deepholes.md` §5.3e: the largest plane here, `PG(2,31)`, has 993
points. The binding cost is the maximal-clique enumeration and the orbit marking, not the point
count. Single-threaded throughout — three other agents held the machine, with load average near 50
for most of the session. Whole census: under three minutes.

**One driver-level cost finding worth carrying forward.** Canonicalising every maximal clique against
the group is `O(|G|)` per clique and made `q = 27` and `q = 31` impractical under contention. Marking
one orbit per class instead is `O(|G|)` per *class*, which at `q = 31` is 553 orbit computations
rather than 201,261 canonicalisations, and it turned a projected hour into 38 seconds. The two
methods were checked to give identical class counts and profiles at `q = 7, 11, 19, 23`.

---

## 4. The census

Maximal exterior sets through a fixed external point, with the `PΓL(2,q)`-class count. `max` is the
largest size found and equals `(q+1)/2` in every cell.

| `q` | external pts | maximal cliques | classes | size histogram | max | non-linear at max |
|----:|-------------:|----------------:|--------:|----------------|----:|------------------:|
| 5  | 15  | 2       | 1   | 3:2                                              | 3  | 0 |
| 7  | 28  | 5       | 2   | 4:5                                              | 4  | **1** |
| 9  | 45  | 20      | 2   | 3:16, 5:4                                        | 5  | 0 |
| 11 | 66  | 12      | 3   | 6:12                                             | 6  | **2** |
| 13 | 91  | 174     | 6   | 4:48, 5:120, 7:6                                 | 7  | 0 |
| 17 | 153 | 1128    | 15  | 3:32, 5:560, 6:416, 7:112, 9:8                   | 9  | 0 |
| 19 | 190 | 1377    | 16  | 4:108, 6:1215, 10:54                             | 10 | **1** |
| 23 | 276 | 9097    | 51  | 6:7920, 8:1056, 12:121                           | 12 | **2** |
| 25 | 325 | 29148   | 61  | 5:768, 6:6048, 7:21504, 8:384, 9:432, 13:12      | 13 | 0 |
| 27 | 378 | 46046   | 58  | 5:1560, 6:4758, 7:25506, 8:12168, 10:1950, 14:104| 14 | **1** |
| 29 | 435 | 193550  | 558 | 5:1498, 6:18088, 7:130340, 8:34272, 9:8904, 10:280, 11:154, 15:14 | 15 | 0 |
| 31 | 496 | 201261  | 553 | 6:49410, 7:90230, 8:47370, 9:6840, 10:6900, 12:480, 16:31 | 16 | **1** |

**This is BSW §3 exactly.** Their list is one configuration at `q = 7`, two at `q = 11`, one each at
`q = 19, 23, 27, 31`, and their theorem gives none for `q ≡ 1 (mod 4)`. The reconstruction returns
`1, 2, 1, 2, 1, 1` in those six cells and zero in all four `q ≡ 1 (mod 4)` control cells
`q = 5, 9, 13, 17, 25, 29`. Two of the controls, `q = 9` and `q = 25`, are prime powers that were out
of reach before the runtime prime-power field layer landed.

### The eight exceptional configurations, with the lane's invariants

Element-order spectra name each stabiliser; the order alone would not.

| `q` | line profile | BSW's own words | orbit | stabiliser | element orders | six-arc + Petersen |
|----:|--------------|-----------------|------:|-----------:|----------------|--------------------|
| 7  | `2:6` | "4 points, no 3 collinear" | 14 | 24 | `1:1, 2:9, 3:8, 4:6` — `S₄` | too small |
| 11 | `2:3, 3:4` | "a Pasch-configuration" | 55 | 24 | `1:1, 2:9, 3:8, 4:6` — `S₄` | no |
| 11 | `2:15` | "a 6-arc" | 22 | 60 | `1:1, 2:15, 3:20, 5:24` — **`A₅`** | **yes** |
| 19 | `2:18, 3:4, 6:1` | "a Pasch-configuration, with 4 additional points on one of the 2-secants" | 855 | 8 | `1:1, 2:5, 4:2` — `D₈` | no |
| 23 | `2:30, 4:6` | "6 lines having four points, such that at each of the 12 points 2 of the 4-lines meet" | 1012 | 12 | `1:1, 2:7, 3:2, 6:2` — `D₁₂` | no |
| 23 | `2:24, 3:8, 4:3` | "two Pasch-configurations joined by three transversals" | 1518 | 8 | `1:1, 2:5, 4:2` — `D₈` | no |
| 27 | `2:25, 3:12, 6:2` | "3 Pasch-configurations on two points, with one further two-secant in common" | 2457 | 8 in `PGL`, 24 in `PΓL` | `1:1, 2:5, 3:2, 4:2, 6:10, 12:4` | no |
| 31 | `2:30, 4:15` | "6 points forming an arc, and 10 points forming a Petersen graph" | 496 | 60 | `1:1, 2:15, 3:20, 5:24` — **`A₅`** | **yes, unique** |

Every line profile matches BSW's verbal description independently. A Pasch configuration is six
points on four 3-point lines and three 2-point lines, which is the `q = 11` row; two Pasch
configurations plus three transversals give `4 + 4 = 8` three-point lines and three 4-point lines,
which is the second `q = 23` row; six 4-point lines with two through each of twelve points is the
first `q = 23` row; three Pasch configurations give twelve 3-point lines, which is the `q = 27` row;
and the `q = 19` row is one Pasch plus four points on a 2-secant, turning that line into a 6-point
line. The `q = 11` Pasch and the `q = 7` 4-arc both have stabiliser `S₄`, which is the automorphism
group of the complete quadrilateral.

**Orbit sizes reproduce Edge independently.** At `q = 11` the 6-arc class has orbit 22 and stabiliser
60, so there are 22 Clebsch hexagons over a fixed conic and each of the 66 external points lies on
`22 × 6 / 66 = 2` of them — Edge 1956 §§29–32, recovered here from an exterior-set search that knows
nothing about Edge. At `q = 31` the orbit is 496, the number of external points, so each external
point lies on `496 × 16 / 496 = 16` of the configurations.

### The Pasch members, which an arc-only census cannot see

C193 flagged that *"a Pasch configuration has collinear points by construction, so the lane's ω_arc
machinery is blind to it by design"*, and that the lane had never seen the `q = 11` Pasch. It is now
in hand: six external points, four 3-point lines and three 2-point lines, orbit 55, stabiliser `S₄`,
and it contains no six-subset that is an arc, so no Brianchon structure at all. Pasch configurations
dominate the exceptional list — they are the whole story at `q = 11, 19, 23, 27` — and the
six-arc-plus-Petersen shape is the exception rather than the rule, occurring only at the two `A₅`
cells.

---

## 5. Independent cross-check

`notes/2026-08-31-c1020-exterior-set-crosscheck.py` is a from-scratch second implementation. Its
census uses the conic `x² + y² + z² = 0` where the Rust driver uses `x0 x2 = x1²`, so the point
labelling, the internal/external split and the passant set are different objects; all nondegenerate
conics of `PG(2,q)` are projectively equivalent, so the class data must agree anyway, and that
agreement is the check. The clique enumeration is a plain recursive Bron–Kerbosch over Python sets
with no bitsets.

It reproduces, at `q = 7, 11, 19`, the same maximal-clique counts through the base point
(5, 12, 1377), the same size histograms, and the same maximum-size line profiles with the same
multiplicities. On the `q = 31` configuration it independently confirms all sixteen points external,
zero non-passant joins, the full tangent partition, the line profile `{2:30, 4:15}`, that no external
point extends the set, the Brianchon spectrum `{0:120, 2:270, 3:10, 4:20, 6:5, 10:28}`, the unique
six-subset whose ten Brianchon points are the complementary ten and all external, and that the chord
graph is the Petersen graph.

---

## 6. Replay

```bash
# driver: additive binary, Ergodis core and ergodis-private lib untouched
cd ~/src/othello/ergodis-private
cargo build --release --bin c1020_exterior_sets
./target/release/c1020_exterior_sets --q 5,7,9,11,13,17,19,23,25,27,29,31 \
    --json-out ~/src/othello/notes/2026-08-31-c1020-brouwer-exceptional-census.json

# the two A5 configurations, in full
./target/release/c1020_exterior_sets --q 11 --points 2,37,57,66,78,125
./target/release/c1020_exterior_sets --q 31 \
    --points 3,31,105,162,225,296,323,376,516,590,630,736,757,851,946,974

# independent cross-check
cd ~/src/othello/notes
python3 2026-08-31-c1020-exterior-set-crosscheck.py census 7 11 19
python3 2026-08-31-c1020-exterior-set-crosscheck.py verify 31 \
    1,0,3 1,1,0 1,3,12 1,5,7 1,7,8 1,9,17 1,10,13 1,12,4 \
    1,16,20 1,19,1 1,20,10 1,23,23 1,24,13 1,27,14 1,30,16 0,1,13
```

**A build note that is not this task's to fix.** `cargo build` inside `ergodis-private` currently
fails on `src/g53_mod7_reduction.rs:583` with `cannot move out of *error which is behind a shared
reference` — an in-progress edit belonging to another agent's lane. The driver here depends only on
the read-only `ergodis` core, so it was built out of tree against that core while the library was
broken. The replay command above is the intended one and will work once the foreign edit compiles;
nothing in this task touched that file.

**Point indices** are ranks in `ProjectiveIndex` order for `PG(2,q)`: points sorted by first nonzero
coordinate, that coordinate normalised to one, the remaining suffix read as a big-endian base-`q`
number. The `--points` output prints coordinates so the indexing can be checked.

### Evidence bundle

| path | sha256 |
|---|---|
| `ergodis-private/src/bin/c1020_exterior_sets.rs` | `3b73f8fdf6ef4a9cae515b406f81c5c559423c203f3f9006d76006deee94a7b8` |
| `notes/2026-08-31-c1020-exterior-set-crosscheck.py` | `a0ae604d05cc1466917ddd9b85639a4739bd7e793f7e188f8f1e2b47e830e2c0` |
| `notes/2026-08-31-c1020-brouwer-exceptional-census.json` | `fd87a2cbd1f2a0cc879d4184363213fdf6a9517431358f7c7c024cde1a8a3ab8` |

---

## 7. Ergodis interface notes

**What fitted.** `SmallField` plus `ProjectiveIndex` is the right pair for this class of problem and
needed no wrapper: construct the field from `(p, h)`, build the index at projective dimension two,
and everything else is `index` and `point` on `u64` ranks. The prime-power cells `q = 9, 25, 27` cost
no extra code at all, which is the concrete payoff of the 2026-08-31 core generalisation — the same
work under the previous core would have needed a hand-written `GF(p^h)` in the driver, exactly as
`notes/2026-08-30-c1018-hunt-prs-deepholes.md` §6 item 1 had to do.

**What was missing, with the workaround taken; no Ergodis core file was modified.**

1. **No clique enumeration anywhere in the core.** Maximal cliques of a moderate dense graph is the
   central primitive for every exterior-set, arc-clique and cap problem this lane runs, and there is
   no module for it. A bitset Bron–Kerbosch with pivoting was written in the driver. This is the one
   addition that would be reused immediately by the healthy-arc census and the `U`-atlas.
2. **No projective group action.** `group_action::compile_generator_closure` exists and is the right
   engine, but the only shipped `FinitePermutationAction` implementors are `BinaryGlProbeAction` and
   a test table action, so acting with `PGL(3,q)` or `PGL(2,q)` on `ProjectiveIndex` ranks is
   driver-side work. Here the group was built directly as the symmetric square of `GL(2,q)` and
   materialised as permutations. A `ProjectiveAction` adapter — matrix generators plus a
   `ProjectiveIndex` — would close item 5 of the deep-hole wave's list and is small.
3. **No orbit-marking helper.** The performance lesson in §3 — mark one orbit per class rather than
   canonicalising every object — is generic and belongs next to the action adapter rather than being
   rediscovered per driver.
4. **Positive.** `ProjectiveIndex::index` round-trips exactly and the `u8` element convention was
   never a constraint at these orders. Peak memory stayed under 200 MB at `q = 31`, dominated by the
   materialised permutation table, and would drop to nothing with the adapter in item 2.

---

## 8. Mystery ledger

- **SETTLED 2026-08-31 by the C1022 extraction pass — why `A₅` appears exactly twice, and why the
  sizes land where they do.** These two entries were recorded here as separate open mysteries; the
  audit's adjacent-crown extraction derives both from one observation. The figure's sizes are
  *constant* — six arc points, ten Brianchon points — while the completion size `(q+1)/2` grows with
  `q`. So `6 = (q+1)/2` has the single solution `q = 11`, and `6 + 10 = (q+1)/2` has the single
  solution `q = 31`; Dye's congruence (external Brianchon points iff `q ≡ 1 mod 3`, 1991 p. 282) then
  delivers the correct point type at each. `A₅` occurs exactly twice in the census because those two
  equations have exactly one solution each. This also explains why `q = 19` and `q = 29` carry no
  configuration despite admitting `A₅ ≤ PSL(2,q)`: the subgroup's existence was never the cause.
  **A third member at either completion level is arithmetically impossible**, which is stronger than
  the "look outside the searched range" reading recorded before. Residual gap, genuinely open: this
  rules out a third member of *this* family, not a different constant-size figure meeting `(q+1)/2`
  at some other `q`. Owning successor: unallocated.
- **Whether ten is the global maximum Brianchon count for a six-arc in `PG(2,q)` is unknown.**
  Settled by this pass only *within* the exceptional configurations: the spectrum tops out at ten,
  reached at `q = 11` and `q = 31` and never at `q = 19, 23, 27`. Not settled over all six-arcs, which
  would need a separate census. Evidence gap: no run over unrestricted six-arcs.
- **Settled by this pass.** That the `q = 31` Petersen and the `q = 11` Brianchon–Petersen are the
  same structure — they are. That C193's null holds — it does not. That "complete exterior set" can
  be read as maximal-under-inclusion — it cannot, because sub-maximum maximal sets exist from `q = 9`
  upward. That BSW's tangent-free `12 + 6` reading generalises along their list — it does not; it
  fails already at `q = 31`, by 120 single-hit passants. **Both of these are in print already**
  (C1022): the size-pinned reading is BSW's own definition, p. 143, verified against the page image,
  and Van de Voorde 2011 §3 states that `q = 7` and `q = 11` are the only tangent-free cases. Recorded
  here as confirmation, not as findings.
- **Not a mystery, recorded to stop it becoming one.** The matching-disjointness graph on the ten
  Brianchon points is *not* the Petersen graph at either `q`. C176's Petersen is a third object — the
  Kneser graph on pairs from the invariant synthematic total, where adjacency is disjointness of
  triangle pairs — and it is Petersen by construction once the bijection to Brianchon points is
  established. The graph that matches BSW's `q = 31` description is the chord graph, and that is the
  one checked here at both `q`.

---

## 9. Trust boundary

The census is exhaustive per `q` by the transitivity argument in §3, over the exact domain
`q ∈ {5, 7, 9, 11, 13, 17, 19, 23, 25, 27, 29, 31}`, all odd prime powers in that range. **Even `q`
is excluded and not merely unrun**: in characteristic two the conic has a nucleus and the
internal/external dichotomy does not exist, so the object under study is undefined and the driver
refuses. Nothing above `q = 31` was attempted; BSW report Brouwer's negative for `q = 43, …, 131` and
that range was not re-run here.

Two implementations agree on every reported number, one in Rust over `x0 x2 = x1²` and one in Python
over `x² + y² + z²`. Both are this session's, so they are not independent of its understanding of the
definitions — the definitional risk is stated explicitly in §2 and is the place a vet should look
first. The identification of BSW's configurations with the reconstruction rests on matching line
profiles against their prose, transcribed at L4 in C193 from page scans; the prose is not a formal
specification and the match is a judgment, not a proof.

Everything here is provisional under the lane rule. The vet is the user's to launch; this session did
not launch one, did not commission one, and did not self-vet.
