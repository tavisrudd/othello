# Ergodis target mining from the gem-mining corpus

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-08-31
**Status**: **PROVISIONAL — unvetted single-model mining output.** Per the lane's standing rule
(`notes/handoffs/2026-07-14-gem-mining.md`, and `notes/2026-07-15-gems-theory-gaps-method.md`
§ Trust boundary), nothing here is load-bearing, citable, or promotable until a stronger reasoning
model has vetted it. This session did not self-vet and did not commission a vet. No task IDs are
allocated, no queue rows are added, and no other lane's document was modified.

**Question answered.** Across the gem-mining record there are computations a report *wanted* and
could not run, leads parked as "not now", and cells declared out of budget. Ergodis has grown since.
This is the intersection: what the corpus asks for that Ergodis can deliver **today**.

**Scope discipline.** Read-only. No searches were launched; three other agents hold compute on this
machine. All feasibility figures below are arithmetic against measured numbers already in the
repository, not new measurements.

---

## 1. What Ergodis can do today — verified against source, not taken on trust

Read at `papers/complete-repair-ports/ergodis/src/` on 2026-08-31, at core commit `f17efd4a2`.

| Primitive | Where | State today |
|---|---|---|
| Runtime `GF(p^h)`, any prime power of order ≤ 256 | `field.rs` `SmallField` | **New today** (commit `62fcd5f28`). Table-backed add/sub/mul/inverse, built from a runtime-located monic irreducible; cold construction, allocation-free thereafter. Supersedes the `Prime<P>` + hand-written `Gf4` pair, which both remain. |
| Exact rank and null space over a runtime field | `matrix.rs` `canonical_row_basis_with`, `null_space_with` | **New today.** Rank is the row count of the canonical basis. The prime-field `const P` forms (`canonical_row_basis`, `null_space`) also remain. |
| Generic `PG(d,q)` point ranking/unranking | `projective.rs` `ProjectiveIndex` | **New today.** Allocation-free `index`/`point` over a borrowed `SmallField`, leading-one normal form, `u64` indices. The older `ProjectivePlane::ternary` specialization is still there. |
| Exact bipartite matching with Hall-deficient-set witnesses | `hall.rs` `solve_hall`, `verify_hall_certificate` | Mature. Workspace allocates once and is reused, which is what made per-node certification affordable in the order-12 plane wave. |
| Orbit/group-action closure over an indexed point set | `group_action.rs` `compile_generator_closure` + `FinitePermutationAction` | Present, with a bitmap-backed BFS closure. **Only two implementors ship** (`BinaryGlProbeAction`, a test table action), so a `PGL(3,q)`/`PGL(2,q)`-on-`ProjectiveIndex` adapter is driver-side work — small, but it does not exist. |
| Exact CSS minimum distance, sharded, anchor/symmetry reduced | `css_distance.rs` | Mature; ~1500 qubits demonstrated. Needs the `large-css` and `parallel` features — the committed release binary refuses instances above 384 coordinates. |
| Coherent-configuration closure on ordered pairs | `coherent_closure.rs` | Present. Coarsest coherent pair colouring refining a given labelling; cost is `O(order³)` and it is explicitly a cold front end, not a solve loop. **Pair-valued only.** |
| Exact bounded hitting set with streamed negative evidence | `residual_hitting.rs` | Present. This is the natural pruning oracle for "the secants must cover every off-conic point". |
| Character sums, multiplier orbits, commutants, packed bitsets | `character_sum.rs`, `commutant.rs`, `bitset.rs` | Present. |

**Three of the five gaps the deep-hole wave logged are now closed.** The Ergodis interface notes in
`notes/2026-08-30-c1018-hunt-prs-deepholes.md` §6 list five asks: no general `GF(p^h)`, no null-space
API, `const P` forcing macro dispatch, no generic `PG(d,q)` indexing, and no orbit closure over a
matrix group acting on an indexed point set. Items 1, 2 and 4 landed today. Item 3 is partly relieved
(`SmallField` is a value, so runtime `--q` no longer needs a fifty-arm match) and item 5 is
half-closed: the closure engine exists, the projective adapter does not.

**Measured ceiling.** `notes/2026-08-30-c1018-hunt-prs-deepholes.md` §5.3e states the exhaustive
census ceiling on this machine as **about 2·10⁹ projective points**, from the `PG(8,13)` run
(883,708,281 points in 396 s using 968 MB) against 10 GB of available memory — roughly 1.1 GB and
0.45 µs per 10⁶ points. That is the ceiling every plane-geometry target below sits far beneath: the
binding cost for this corpus is search branching, not point count.

**One hard boundary on `SmallField`: order ≤ 256.** For odd `q` that admits every prime power up to
`q = 251`, including the previously unreachable `9, 25, 27, 49, 81, 121, 125, 169, 243`.

---

## 2. Ranked targets

Ranking is by expected value with cost as a divisor. The lane's own rule is applied throughout:
*over a complete census a miss is a theorem; over a curated list a miss is worthless*
(`notes/2026-07-15-gems-theory-gaps-method.md` § The rules, rule 1). Each target declares its null
before looking, per rule 3.

---

### Target 1 — the prime-power healthy-arc census

**Rank: 1.** The single item in this corpus whose stated blocker is exactly the primitive that
landed today.

**1. The exact question.** Fix the nondegenerate conic `C` in `PG(2,q)`, `q` odd. Let `E_q` be the
graph on the `q²` off-conic points, adjacent iff their join misses `C`. An *arc-clique* is a clique
of `E_q` with no three points collinear; it is *healthy* if its secants cover every off-conic point
outside it — equivalently, the deep-hole locus of the associated MDS code is exactly the full
`F_q`-point set of a conic. For which **odd prime powers** `q = 9, 25, 27, 49, 81, 121, 125, 169,
243` does a healthy arc exist, and what are the extremal witnesses' stabilizers? The prime cells
`q ≤ 37` are already done and answer `{3, 5, 11}`.

**2. Provenance.** `notes/handoffs/2026-07-14-gem-mining.md` § Settled: *"Prime powers q = 9, 25, 27,
49 are unswept — q=9 matters."* The blocker is named verbatim in
`notes/2026-07-14-gem-mining-next-steps-fable.md` §5: *"Scope, stated plainly: primes only (the
script is GF(p); q = 9, 25, 27 need a field extension pass — q=9 matters, it is SVM's
Brianchon-on-conic case)"*, repeated in that note's § Known limitations (*"censuses are prime-q
only"*) and in `notes/2026-07-14-gem-program-vet.md` §4 item 4, which ranks it 4 of 12 and calls it
*"OPEN; the prime census q ≤ 37 is IN HAND but unreplicated."*

**3. Ergodis primitive, and whether it exists today.** Exists today, and it is the newly landed
piece. `SmallField` supplies `GF(p^h)` arithmetic; `ProjectiveIndex` ranks `PG(2,q)`; `bitset`
carries the `E_q` adjacency and the covered-point mask; `residual_hitting` is the natural pruning
oracle for the covering condition inside the depth-first search. **Missing:** a
`FinitePermutationAction` adapter for `PGL(2,q)` acting on the indexed off-conic points, needed to
fix one representative per point type and avoid a redundant sweep. That is driver-side work in
`ergodis-private`, of the same size as the adapters the C1018 wave wrote locally, and it is not a
core change.

**4. Feasibility.** Trivially inside the point-count ceiling: `PG(2,243)` has 59,293 points against
a 2·10⁹ ceiling, and the `E_q` external-point subgraph at `q = 251` is a 31,626-vertex bitset, about
125 MB. The real cost is branching in the arc-clique search, where the only measurement in the
record is that the Python prototype "died at 37 ≈ 9 min". The pencil bound
`n ≤ (q+3)/2` (`notes/2026-07-14-gem-mining-next-steps-fable.md` §3.3) caps depth at 62 for
`q = 121`. My estimate, provisional: `q = 9, 25, 27, 49` is one wave with high confidence;
`q = 81, 121, 125` needs the measurement; `q = 169, 243` is a genuine unknown. **Even `q` must be
excluded** — in characteristic two the conic has a nucleus and the internal/external dichotomy
collapses, so `E_q` is not defined as stated.

**5. What a hit buys, and what a miss buys.** This is a complete census per `q`, so **the miss is
the product.** It upgrades the manuscripts' census sentence from "exhaustive for primes `q ≤ 37`" to
"exhaustive for all odd `q ≤ N` including prime powers", which is exactly what `clebsch`'s and
`relconic`'s uniqueness framing rests on, and it closes the one caveat a referee can see from the
outside. A hit — a fourth healthy arc at a prime power — would be a genuinely new object and would
break the "family stops after 11" story that the manuscripts currently tell.

**6. Declared null.** No healthy arc exists at any odd prime power `9 ≤ q ≤ 243`; the family is
`{3, 5, 11}` and stops. Secondary null: the extremal `ω_arc` witnesses at prime powers have small
stabilizers with no name, matching the prime cells at `q = 23–37` where nobody has looked.

**Standing gate, non-negotiable.** `notes/handoffs/2026-07-14-gem-mining.md` § Dye warning:
`q = 9` is **Dye 1988** — twelve hexagons with internal vertices, two `PSΩ(9)`-orbits of six, `A₆`
acting inequivalently on each — and the handoff says *"Get this paper before sweeping q=9."* The
census framing and the coding reading survive Dye; **the geometry's novelty at `q = 9` does not**.
Run the sweep for census completeness, obtain Dye 1988 before writing a word about what the `q = 9`
configuration is.

---

### Target 2 — reconstruct Brouwer's complete exceptional census and put the lane's invariants on it

**Rank: 2.** Cheapest genuinely-new-column target on the board, and it settles a lead the record
explicitly declared null and never computed.

**1. The exact question.** BSW 1992 §3 publishes Brouwer's complete-up-to-isomorphism classification
of the exceptional complete exterior sets of a conic: one configuration at `q = 7`, two at `q = 11`
(a 6-arc and a Pasch configuration), one each at `q = 19, 23, 27, 31`, and none for
`q = 43, …, 131`. Reconstruct all of them independently by exhaustive search, then compute, for each
member of that complete census: the stabilizer as a named group, the deep-hole locus and its
curve type, the concurrency invariant `t`, and the induced graph on the 2-secants. **Specifically:
is BSW's `q = 31` configuration — a 6-arc whose 15 2-secants meet a 10-set in 15 pairs forming a
Petersen graph — the same structure as this lane's `q = 11` Brianchon–Petersen dictionary, or a
coincidence of tens and fifteens?**

**2. Provenance.** `notes/2026-07-15-c193-bsw-exceptional-census.md` § The Petersen echo — the
strongest lead here, which states the question, declares the null, and records *"The Petersen echo
not computed. No comparison of BSW's q=31 structure with the lane's q=11 Brianchon–Petersen has been
attempted; the null is not refuted."* The handoff's C193 row calls it *"Strongest lead: BSW's q=31
6-arc + Petersen graph against this lane's q=11 Brianchon–Petersen — null declared, uncomputed."*
The same report's § Cells this opens names the Pasch members, which the lane has never seen because
its `ω_arc` machinery is arc-only and a Pasch configuration has collinear points by construction. The
`q = 11` Brianchon–Petersen dictionary is `notes/2026-07-15-c176-brianchon-petersen-dictionary.md`
(`clebsch`-pegged; read-only from here).

**3. Ergodis primitive.** Exists today. `ProjectiveIndex` over `SmallField` for `PG(2,q)`,
`q ≤ 31`; `bitset` for the exterior-point external-join graph; `group_action::compile_generator_closure`
for the `PGL(2,q)` orbit reduction and for stabilizer computation; `null_space_with` for the
deep-hole curve fit. Same missing adapter as Target 1 — one `FinitePermutationAction` for the
projective action — and it is shared work.

**4. Feasibility.** Negligible. `PG(2,31)` has 993 points and 496 exterior points; complete exterior
sets have at most `(q+1)/2 = 16` points; `|PGL(2,31)| = 29,760`. This is seconds to minutes, six
orders of magnitude below the census ceiling. It fits in the gaps of another wave.

**5. What a hit buys, and what a miss buys.** Brouwer's list is a **published complete census up to
isomorphism**, which is the exhaustion guarantee rule 1 demands and which the lane does not have to
produce itself. So a miss is a theorem-shaped statement: *the Brianchon–Petersen structure is a
`q = 11` accident and does not deform across the exceptional family.* That directly settles a
mechanism-deformation question the lane's method cares about, and it retires a live lead cheaply. A
hit — the same structure at `q = 31`, where no 6-arc complete exterior set of the `q = 11` kind
exists — makes it a deformation across the exceptional family rather than a small-numbers accident,
which is the predicate the method calls "the mechanism deforms". Side payoff either way: BSW publish
no data files, so an independent reconstruction of Brouwer's 1992 search is a replication of an
unpublished computation, and the two Pasch members become visible to this lane for the first time.

**6. Declared null.** The 15-edge/10-vertex match is forced by any 6-arc and carries no content; the
`q = 31` Petersen and the `q = 11` Brianchon–Petersen are unrelated, and the exceptional
configurations at `q = 19, 23, 27` carry no invariant that lands on a name. This is C193's own
declared null, restated unchanged.

---

### Target 3 — the U-atlas with elliptic targets admitted (queued as C159, never run past its seed)

**Rank: 3.** The corpus's own "most generative, least targeted" item, and the curve-fit primitive it
needs landed today.

**1. The exact question.** For every odd `q ≤ 16` or so, enumerate all `n`-arcs of `PG(2,q)` up to
`PGL(3,q)` and, for each class, compute the deep-hole locus `U` and fit it against the rational
points of a curve of low degree — line, conic, cubic split by singular type and `j`-invariant, then
higher. Which classes have `U` **exactly equal** to the full `F_q`-point set of a curve, and does any
such exact fill land on an **elliptic** curve?

**2. Provenance.** `notes/handoffs/2026-07-14-gem-mining.md` § Open frontiers, "The U-atlas":
*"Drops C132's genus-0 prescription, which was a restriction by fiat: elliptic-curve targets are the
cheapest route to a new kind of gem."* Fully specified in
`notes/2026-07-14-gem-mining-next-steps-fable.md` §10.4 with its census, invariant and declared null.
Ranked 5 of 12 in `notes/2026-07-14-gem-program-vet.md` §4 — *"The most generative proposal on the
board and the least targeted"* — and queued as C159 with an import boundary in
`notes/2026-07-14-c153-c160-queue-rationale.md`: consume C184's complete `q = 11` six-arc
degree/rank table as seed, **do not** regenerate it, and begin with the missing `q ≤ 11` cells.

**3. Ergodis primitive.** Exists today. The curve fit is exactly `matrix::null_space_with` over a
`SmallField`: build the degree-`d` Veronese evaluation matrix on the points of `U` and take its
kernel; nonzero kernel means `U` lies on a degree-`d` curve, and the exact-fill test is whether that
curve's full rational-point set is `U`. Before today this was prime-field only, which excluded
`q = 9, 16, 25, 27` — the cells where characteristic-two and characteristic-three behaviour is most
likely to be different. `ProjectiveIndex` handles the enumeration; the `PGL(3,q)` frame
normalization is standard driver work.

**4. Feasibility.** Well inside every ceiling. `PG(2,16)` has 273 points, `PG(2,27)` has 757. Arc
enumeration up to `PGL(3,q)` by frame normalization plus completion sweep is the dominant cost and
grows like `q^(2(n−4))` before quotienting; the record's own estimate is one cell (`q ≤ 11`, all `n`)
as the first unit of work. Rank computations are microseconds each. One wave should cover
`q ≤ 13`; `q = 16, 25, 27` needs a measurement.

**5. What a hit buys, and what a miss buys.** Complete census, so a miss is a theorem: *no arc in
any `PG(2,q)`, `q ≤ N`, has its deep-hole locus equal to the rational points of a curve other than
the known conic instances.* That is a real sharpening of the manuscripts' "deep holes fill a conic"
statement. A hit on an elliptic target is the largest upside in this report — a new *kind* of gem
rather than a sibling, with the Hasse window `|U| = q + 1 − a`, `|a| ≤ 2√q` available as an
independent sanity null. **Caveat on novelty:** the raw arc classification of small `PG(2,q)` is
published and was conceded outright to the Hirschfeld–Sadeh school
(`notes/2026-07-14-novelty-status-review-summary-tables.md` §3 row 14). The curve-fit column is the
new part; the census is not.

**6. Declared null.** Generic `U` fits no curve of degree ≤ 3 once `|U| > 9` or so, and exact fills
are isolated and group-caused. Concretely: the only exact fills in the whole atlas are the already
known ones — the Clebsch hexagon at `q = 11`, the projective frame at `q = 5`, the triangle at
`q = 3` — and no elliptic target occurs at any `q ≤ 16`.

---

### Target 4 — extend Brouwer's exceptional-exterior-set search past `q = 131`

**Rank: 4, and it is the highest-variance item here.** Its stated blocker has been paid since the
blocker was written, and nobody has re-scored it.

**1. The exact question.** For odd prime powers `q ≡ 3 (mod 4)` with `131 < q ≤ 251` — that is
`139, 151, 163, 167, 179, 191, 199, 211, 223, 227, 239, 243, 251` — does a complete exterior set of
the conic exist that does not consist of all exterior points of a passant? BSW's own words on their
conjecture that none exists for `q > 31`: *"How to prove this we have no idea."*

**2. Provenance and the cleared gate.** `notes/2026-07-14-gem-program-vet.md` §3 item 1 abandons
this: *"Any restatement — including a future Rust sweep to q ≈ 150 pitched as conjecture support —
is unpublishable without first obtaining BSW 1992 and refuting Van de Voorde's report of it."*
**BSW 1992 was subsequently obtained and read at full text** —
`notes/2026-07-15-c193-bsw-exceptional-census.md`, from page scans at
`/tmp/persistent/tavis/lit-search/bsw-1992/` — and it confirms the range as Brouwer's
`q = 43, …, 131` inside BSW 1992 rather than Van de Voorde's. The vet's named gate is therefore paid,
and the ban it imposed was scoped to sweeps *inside* the checked range. The abandonment was correct
when written and is now stale for `q > 131`; the record has not been re-scored since C193 landed.
Note that C193 §"Cells this opens" quietly says the same thing in different words: *"What BSW's
remark licenses is work on a proof, which is a different activity from a wider search"* — a wider
search is what this target is, and C193 does not endorse it. **Treat that as a live disagreement
inside the corpus, and let the vet settle it.**

**3. Ergodis primitive.** Partly. `SmallField` reaches `q = 251` exactly; `ProjectiveIndex` and
`bitset` handle the geometry; `group_action` handles the `PGL(2,q)` reduction. What does not exist
is any clique-search engine: the exterior-set search is a maximal-clique enumeration in a
31,626-vertex graph seeking cliques near size 126, and nothing in `src/` does that. This needs a new
driver with real algorithmic content, and it is the only target here where the mathematics of the
search is the hard part rather than the arithmetic.

**4. Feasibility — genuinely unknown, and that must not be papered over.** Point counts are
irrelevant (`PG(2,251)` is 63,253 points). The branching factor of a size-126 clique search on
31,626 vertices is not measured anywhere in this repository, and I would not guess it. **The correct
first move is a calibration run at `q = 43, 47, 59`, where Brouwer's answer is known to be "none", as
a positive control that also measures the branching.** If `q = 43` does not complete in a wave, the
target is dead in this form and should be down-scoped to a structured subfamily (for example, sets
invariant under a prescribed prime-order subgroup of `PGL(2,q)`), exactly the way the C1018 scout
down-scoped the order-12 plane search.

**5. What a hit buys, and what a miss buys.** Over a complete per-`q` census, a miss extends the
verified range of a conjecture open since 1991 and unextended since 1992 — modest, directly citable,
and the kind of contribution the BSW conversation accepts. A hit would refute a 35-year-old
conjecture, which is the largest single prize named anywhere in this corpus. The asymmetry is what
justifies the rank despite the feasibility risk.

**6. Declared null.** No exceptional complete exterior set exists for any `131 < q ≤ 251`; the
conjecture holds throughout the extended range and the search returns only the linear examples.

**Mandatory gate before compute.** A literature audit under
`notes/literature-audit-conventions.md`, on one question: has anyone extended Brouwer's range since
1992? Van de Voorde 2011 reports `q < 131`, so the window to check is 2011–2026, and
`notes/2026-07-14-gem-mining-next-steps-fable.md` §7 flags a 2025 "untouchable sets" line
(arXiv:2505.08551) showing the area is active. This audit costs far less than a wave and can kill the
target outright.

---

### Target 5 — the flag-lifted coherent configuration for the arc bound

**Rank: 5.** The one target that attacks the lane's own longest-standing unexplained fact, and the
primitive is closer than it looks.

**1. The exact question.** The pencil bound `ω_arc ≤ (q+3)/2` is linear in `q` while the census data
`3, 4, 4, 6, 6, 6, 6, 8, 10, 10, 10` for primes `3 … 37` look sublinear. Every scalar two-point
certificate is provably bounded below by the `q+1`-point passant-line clique, so no pair-valued
scheme can see the arc condition. **Does the coherent closure of the natural labelling on the
flag set of `PG(2,q)` — or on rooted pairs of off-conic points — produce a configuration whose
Perron or positive-semidefinite bound on arc-cliques falls below the pencil bound at `q = 7, 11, 13`?**

**2. Provenance.** The bound-shape mismatch is an internal detector in
`notes/2026-07-15-gems-theory-gaps-method.md` § Internal detectors, and its founding entry is
`notes/2026-07-15-gem-discovery-track.md`, entry 2026-07-14: *"the pencil bound `(q+3)/2` is linear
in q while the census data look sublinear. A bound whose shape differs from the truth's means the
bound's mechanism is not the truth's mechanism — and the true one has no name."* The specific attack
comes from `notes/2026-08-01-c760-ten-proofs-method-spike.md` § `ej`+`tt` closeout and § Mystery
ledger, which kills the scalar route uniformly and leaves open exactly one successor: *"can C725's
rooted-pair/flag orbit DAG be compressed into a genuine matrix-valued three-point projection
identity? Evidence gap: no candidate kernel, transition graph, or Perron/PSD certificate has been
constructed."* The route survives *"only if 'association scheme' is upgraded to a triple/flag
coherent configuration that detects collinearity."*

**3. Ergodis primitive.** Half exists. `coherent_closure.rs` computes the coarsest coherent pair
colouring refining a given labelling — a genuine coherent-configuration closure with exact replay.
It is pair-valued, which is precisely what C760 killed. **The move that needs no new core code is to
run the existing pair closure on a lifted state space**: take flags (incident point–line pairs) or
rooted pairs of off-conic points as the vertex set, so that a "pair" of flags already encodes three
points of the plane, and let the closure discover the fibres. That is a driver-side construction on
top of an existing primitive, not a new algorithm. What is genuinely absent is the Perron/PSD bound
on top of the resulting configuration — Ergodis has no LP or SDP layer, so the bound would have to be
computed exactly by hand from the intersection numbers or by an external exact solver.

**4. Feasibility.** Governed by the closure's `O(order³)` cost. Flags of `PG(2,q)` number
`(q²+q+1)(q+1)`: 456 at `q = 7` (`9.5·10⁷` operations, trivial), 1,596 at `q = 11`
(`4.1·10⁹`, one wave), 2,562 at `q = 13` (`1.7·10¹⁰`, multi-wave and probably the practical stop).
Rooted pairs of off-conic points are larger and likely out of reach past `q = 7`. Nothing here
touches the projective-point ceiling; the cost is cubic in the lifted state count.

**5. What a hit buys, and what a miss buys.** This is **not** a census, so the lane's own rule bites:
a miss over a curated set of state lifts is worth close to nothing as mathematics. What it *is* worth
is a stopping rule — C760 already priced the scalar route to zero, and a measured failure of the
first flag lift converts "we have not tried" into "we tried the cheapest lift and the intersection
numbers do not separate collinear triples", which is a real narrowing of C756's route list. A hit —
any exact bound below `(q+3)/2` at any `q` — would be the first structural explanation of the
`ω_arc` growth curve, which is the oldest unexplained item in the handoff. Rank it here, not higher,
precisely because the miss is cheap in information.

**6. Declared null.** The flag-lifted coherent closure collapses to the orbital configuration of
`PGL(3,q)` on flags, its fibres do not separate collinear from non-collinear point triples, and the
resulting bound is no better than `(q+3)/2`.

**Cross-lane flag.** The proof objects (C725, C756) are pegged `clebsch`. The bound-shape detector
and the `ω_arc` census are `gem-mining`'s. If this is promoted it must be split or pegged to
whichever lane owns the deliverable, per the handoff's cross-lane rule.

---

### Target 6 — extremal-witness stabilizers at `q = 23–37`, and the mixed-type profile

**Rank: 6.** Nearly free, explicitly flagged as never done, and the corpus itself says do the
stabilizers before anything else in this direction.

**1. The exact question.** For each prime `q = 23, 29, 31, 37`, canonicalize the maximum arc-cliques
of `E_q` and compute their stabilizers in `PGL(2,q)` and their internal/external type profiles. Does
any extremal witness have a large or named stabilizer?

**2. Provenance.** `notes/2026-07-14-gem-program-vet.md` §4 item 6: *"the extremal witnesses at 23–37
are uninspected — compute their stabilizers; a big group there is a gem candidate nobody has looked
at."* Its recommendation is explicit: *"Worth compute: rank 6 (the stabilizers first; the Rust sweep
only if they show structure)."* The same note's § Known limitations records *"ω_arc witnesses at
q ≥ 23 not canonicalized or stabilizer-typed"*. The handoff's § Open frontiers keeps
*"the uninspected extremal-witness stabilizers"* as the surviving residue of the downgraded `ω_arc`
programme.

**3. Ergodis primitive.** Exists today. `group_action::compile_generator_closure` for orbits and
stabilizers; `ProjectiveIndex` for the point indexing; the same `PGL(2,q)` adapter Targets 1 and 2
need. Falls out of Target 1's driver at no marginal cost.

**4. Feasibility.** An afternoon, in the vet's own estimate. `PG(2,37)` has 1,407 points. Bundle it
with Target 1.

**5. What a hit buys, and what a miss buys.** Low on both sides, and the corpus is candid about why.
`notes/2026-07-15-c191-gap-mining-backfill.md` cell 3 scores the mixed-type invariant *"forced-empty,
genuinely novel, and worthless"* — the literature is keyed to external points and structurally cannot
see it, and *"the sweep found nobody who cares"*. A large stabilizer would upgrade that to a named
object worth a look; a generic result confirms the downgrade and closes the frontier permanently,
which is worth doing because the frontier currently sits open in the handoff with no ID and no
resolution.

**6. Declared null.** The extremal witnesses at `q = 23–37` have small stabilizers of order 1, 2, 3
or 4 with no name, the type profiles are mixed with no pattern, and the `ω_arc` frontier closes as
the data note the vet already called it.

---

### Target 7 — the `k = 4` twisted-cubic healthy search (C158, `cubic`-pegged)

**Rank: 7 in this report only because it is not this lane's to run.** On mathematical upside the
corpus ranks it second overall.

**1. The exact question.** In `PG(3,q)` for `q = 11, 13`, enumerate `n`-point sets in general
position up to `Stab(twisted cubic) = PGL(2,q)` and ask whether any has its deep-hole locus — the
points on no trisecant plane of the set — equal exactly to the `q+1` rational points of the twisted
cubic.

**2. Provenance.** `notes/2026-07-14-gem-program-vet.md` §4 item 2, ranked 2 of 12: *"The one
direction where a hit is a new kind of object."* Fully specified in
`notes/2026-07-14-gem-mining-next-steps-fable.md` §10.3 with its census, nulls and ceiling.
`notes/2026-07-14-c153-c160-queue-rationale.md` C158 says *"Rust from the start, not a Python
prototype"* and, critically, *"Do the dictionary before the search"* — re-derive the redundancy-4
coset correspondence from arXiv:1909.00207 before writing any code.

**3. Ergodis primitive.** Exists today for the search: `ProjectiveIndex` now handles `PG(3,q)`
generically, `bitset` carries the plane masks, `group_action` gives the `PGL(2,q)` reduction. The
blocker is not computational — it is the unverified dictionary, which is mathematics.

**4. Feasibility.** Small. `PG(3,11)` has 1,464 points, about 1,332 off the cubic, with symmetry
order 1,320; `PG(3,13)` has 2,380. Far inside every ceiling. Depth-first with plane masks is the
prescribed shape.

**5. What a hit buys, and what a miss buys.** Complete census per cell, so the miss is a theorem and
it closes the `clebsch` manuscript's one open forward question with a census rather than a shrug. A
hit is the first deep-holes-fill-a-curve instance beyond the plane — rung 2 of the `k`-tower and a
new kind of object, not a sibling.

**6. Declared null.** No such set exists at `q = 11` or `q = 13`; the capacity bound `n ≥ 5` is met
but the covering fails for the same fine reasons it fails in the plane for `q ≥ 13`.

**Cross-lane.** Pegged `cubic`, queued as C158. Listed here because the Ergodis fit is now clean and
the record marks it "OPEN, user's call"; running it is that lane's decision, not this one's.

---

### Target 8 — the 0-of-55 anomaly in the hexagon 1-factorizations, deformed across `q`

**Rank: 8. Marginal, listed because it is a real declared anomaly nobody has explained.**

**1. The exact question.** At `q = 11`, each of the two systems of eleven Clebsch hexagons is a
1-factorization of `K₁₂` on the conic's twelve points, and **zero of the 55 factor-pairs in either
system unions to a Hamiltonian 12-cycle** — so neither is a perfect 1-factorization. A random
1-factorization would show some perfect pairs; unanimous failure is structure. Does the same
vanishing hold for the analogous configurations at other `q`, and is there a mechanism?

**2. Provenance.** `notes/2026-07-15-c192-hexagon-biplane.md` § The K₁₂ reframe: *"0 of 55
factor-pairs in either system union to a Hamiltonian 12-cycle … Recorded as an observation, not a
theory … Nobody has explained it and nobody should pretend to."* The same report's § Next says *"If
anything here is pursued, it is the 0/55 anomaly — and only after a search of the answer, not the
question."*

**3. Ergodis primitive.** Exists today, and is overkill: this is minutes of ordinary computation.
The only reason it appears in an Ergodis target list is that generic `SmallField` makes the
prime-power cells reachable in the same driver as Target 1.

**4. Feasibility.** Trivial.

**5. What a hit buys, and what a miss buys.** Weak on both sides. The all-external configurations
at other `q` are exactly Brouwer's exceptional census (Target 2), so this is a column on that table
rather than a target of its own, and it should be run as part of Target 2 if at all. C192's own gate
stands: 1-factorizations of `K₁₂` carrying `PSL(2,11)` are classical ground and Edge's Klein 1879
pointer says where the configuration already lives, so **search the answer before computing
anything**.

**6. Declared null.** The vanishing is a consequence of the `PSL(2,11)` action forcing every
factor-pair union to split into two 6-cycles, it is classical, and it says nothing about any other
`q` because no other `q` has two systems of hexagons.

---

## 3. Do not pursue

Each of these looks like a live Ergodis target and is not. Reasons are from the corpus, not from me.

1. **Any `ω_arc` all-external sweep pitched as supporting or extending the BSW conjecture inside
   `q ≤ 131`.** `notes/2026-07-14-gem-program-vet.md` §3 item 1 abandons it outright; the range is
   Brouwer's, checked inside BSW 1992 §3 and confirmed at full text by C193. A sweep to `q = 37` or
   `q = 150` recomputes inside a checked range. Target 4 above is the only version of this that is
   not already answered, and it starts *above* 131.

2. **The `q = 5` projective frame as new geometry.** `notes/handoffs/2026-07-14-gem-mining.md`
   § Dye warning: it is **Dye 1991 §1.4** — *"When K is GF(5) then PSΩ(5) is A₅, and 𝒞 has six points
   which form a hexagon. Through each of the 10 internal points passes three chords; these are just
   the edges of the hexagon."* The "cheap check: structure or degeneracy?" that the novelty tables
   list as outstanding has an answer in print. The coding reading of `[4,1,4]₅` survives; the
   geometry does not.

3. **The `q = 9` twelve-hexagon configuration as new geometry.** **Dye 1988**, *Twelve hexagons
   associated with the 10-point conic and the isomorphism PSL₂(9) ≅ A₆*, J. London Math. Soc. (2) 37
   (1988) 437–446 — twelve hexagons with internal vertices, two `PSΩ(9)`-orbits of six, `A₆` acting
   inequivalently on each. Target 1 may sweep `q = 9` for census completeness; it may not describe
   what it finds there as new until Dye 1988 is obtained.

4. **The octad analogue at `q = 23`, in any form.** Dead for a structural reason, not for want of
   compute: the mechanism needs `|H| = 2 × 3` so that a concurrent triple is a *perfect* matching. At
   `|H| = 8` a triple covers six of eight points, determines no involution, and there are 420 triples
   to avoid instead of 15 (`notes/handoffs/2026-07-14-gem-mining.md` § Open frontiers). It is a
   coincidence of small numbers, not a Mathieu tower. Note that the `q = 23` octad computation is
   trivially inside Ergodis's reach, which is exactly why this entry exists: reachability is not a
   reason.

5. **Any spectral or eigenvalue bound on `E_q`.** Dead a priori and computed, not conjectured: every
   external line is a `(q+1)`-clique of `E_q`, so `ω(E_q) ≥ q+1` and no clique bound can ever see the
   arc condition; and `E_q` is biregular, hence not strongly regular
   (`notes/2026-07-14-gem-mining-next-steps-fable.md` §2, §3.4, §6). The only strongly regular graph
   in the family is external-points-under-tangent-adjacency, which is the triangular graph `T(q+1)`
   in disguise. Ergodis's commutant and character-sum machinery does not rescue this.

6. **"What code do Edge's 22 hexagons give?"** Computed and closed. The parity-check matrix has
   column weight 2, so the code is a graph cycle code `[66,45]₂`, the two systems' incidence is the
   complement of the Paley biplane with `|Aut| = 660`, and **Edge states the same structure in his
   §32** as a symmetric (6,6)/(5,5) correspondence, pointing at Klein 1879
   (`notes/2026-07-15-c192-hexagon-biplane.md`). The question factored through a coarsening the far
   side studies exhaustively. λ and a modern name are not a finding.

7. **The four-orbit classification, the stabilizer-parity form, and the point↔involution
   machinery.** All published: Cameron–Omidi–Tayfeh-Rezaie, *Electron. J. Combin.* 13 (2006) #R50,
   Thm 4 and Thm 1 / Thm 2(i); Nguyen arXiv:1912.12200 §§3–4
   (`notes/2026-07-14-novelty-status-review-summary-tables.md` §2, §3 rows 4, 5, 7). Recomputing any
   of it is a self-inflicted scoop.

8. **The fill-signature detector, in any re-keyed form.** Retired for failing all four generator
   rules, reconfirmed by the vet, and the method doc's § Overturned claims forbids re-proposing it
   (`notes/2026-07-15-gems-theory-gaps-method.md`; `notes/2026-07-14-gem-program-vet.md` §3 item 3).

9. **The `E_q` involution / Erdős–Ko–Rado transfer.** `notes/2026-07-14-gem-program-vet.md` §4 item
   10 rates it **BLOCKED as a compute item — it is a theory question**, with *"Worth compute:
   none directly."* Meagher–Spiga have the derangement-graph spectra for the whole of `PGL(2,q)`, not
   the involution class. Ergodis has no primitive that changes this.

10. **The equiangular-line maximum `M(18) ∈ {57,58,59}`.** Not ruled out — **already queued** as
    `C1000(a)` / `C737`, with a completed feasibility spike
    (`notes/2026-08-29-c1000-feasibility-spike.md`, §4.1 recommends candidate (a), absorbing C737),
    and ranked 6 in `notes/2026-08-30-c1018-target-scout.md`. Scheduling it is a coordination
    decision about existing rows, not a new mining target, and this report does not re-derive it.
    Its pre-emption risk is documented: Greaves–Syatriadi published the enumeration speed-up in
    April 2025.

11. **Everything Hadamard, Legendre-pair or conference-matrix adjacent.** Owned by another agent;
    excluded here for the same reason the C1018 scout excluded it. Recorded so the exclusion is
    visible, not as a judgment on value.

---

## 4. Two observations for the vet, not findings

**The corpus contains one stale abandonment.** `notes/2026-07-14-gem-program-vet.md` §3 item 1 bans
a wider exterior-set sweep *until BSW 1992 is obtained*. C193 obtained and read it three weeks later
and did not revisit the ban. Whether Target 4 is now permitted, and whether C193's own preference for
"work on a proof" over "a wider search" should override it, is a judgment call this session should
not make. It is flagged, not resolved.

**Three of the deep-hole wave's five recorded engine asks were closed by the core commits that
landed today, and no document in the corpus knows it yet.** `SmallField`, `null_space_with` and
`ProjectiveIndex` close items 1, 2 and 4 of
`notes/2026-08-30-c1018-hunt-prs-deepholes.md` §6, and the same wave's §5.3e out-of-budget cells at
`q = 16` and `q = 17` were budget-bound rather than field-bound, so they are unaffected. The
`notes/2026-08-30-c1018-target-scout.md` closing note 5 — *"the rank oracle is prime-field only
(blocks GF(p^h) cells in targets 4, 7 and 8)"* — is now out of date, which changes the scout's own
targets 4, 7 and 8 as well as everything ranked above. That scout is another wave's document and was
not edited from here.

---

## 5. Trust boundary

Every ranking, cause, feasibility estimate and null above is one model's reasoning over documents,
produced in a single session, and is **provisional under the lane rule**. No computation was run. No
literature was searched. The Ergodis capability table in §1 is the one part read directly from source
rather than from a report, and it should still be re-checked before a wave is scheduled, because the
core moved twice today. The vet is the user's to launch; this session did not launch one, did not
commission one, and did not self-vet.
