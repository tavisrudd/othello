# Campaign design — hunting unexpected homes of the Clebsch hexagon with Ergodis

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-08-31
**Status**: **DESIGN ONLY, PROVISIONAL.** No computation was launched and no literature was newly
searched. Per the lane's standing rule (`notes/handoffs/2026-07-14-gem-mining.md`), everything here
is one session's reasoning, not load-bearing until the user-launched vet passes it. This session did
not self-vet and did not commission a vet. No task IDs are allocated. Read-only outside this file.

**Question answered.** How to direct an Ergodis campaign hunting for unexpected places the Clebsch
hexagon shows up, or unexpected connections between it and other subfields — given that the figure's
own geometry is classical ground (Clebsch 1871 → Edge 1956 → Dye 1988/1991/1996 →
Blokhuis–Seress–Wilbrink 1991/1992 → Korchmáros 1981) and Dye 1991 alone pre-empted this repository
three times on 2026-08-31.

---

## 0. Verdict up front

1. **The campaign is a good use of Ergodis only in a narrowed form.** "Find unexpected connections"
   is reading-shaped, and today's record proves it: the one finding that survived the C1022 audit —
   the bridge identifying Brouwer's `q = 31` census entry with Dye's figure at a second completion
   level — was produced by reading two disjoint literatures side by side, and its mechanism (constant
   figure sizes against the growing threshold `(q+1)/2`) came from the audit's extraction pass, not
   from a wave. The wave (C1020) supplied verification and exactly one conditional ingredient. The
   campaign should therefore be **reading-led, with Ergodis as the verification-and-census arm**, at
   roughly a four-to-one reading-to-compute budget.

2. **The novelty class that survives here is the bridge, not the object.** Every claim *inside*
   conic-and-hexagon geometry has a probable owner; what has repeatedly survived audit is a
   cross-literature identification (the deep-hole/MDS reading, the hexad characterization, the
   Brouwer bridge — each audited unclaimed while the underlying geometry was not). Design rule:
   every direction below is scored by whether a hit lands as a *bridge into a differently-keyed
   classified literature*, because that is the only place the ground is not already turned over.

3. **Three directions pass the well-posedness gate for exhaustion** (§2): the sporadic-census
   decomposition scan, the rank-4 Coxeter phase census, and the Brianchon ten-arc coding scan (with
   a maximality rider). Two of the offered seeds — the diagonal cubic surface, and the famous homes
   of `A₅`/`PSL(2,11)` — are reading tasks and should get no compute until a reading pass hands back
   a decidable question; one seed (the common cause of the triple coincidence) is a theory question
   Ergodis cannot bite on at all in its current form.

**Ranked slate, one line each** (full specifications in §3):

| # | Direction | Shape |
|---|---|---|
| 1 | Sporadic-census decomposition scan — export the completion-level lens to other classified censuses' unexplained entries | reading pass → cheap waves |
| 2 | Rank-4 Coxeter phase census at `q = h+1` — `D₄/7, B₄/9, F₄/13, H₄/31` | one cheap wave |
| 3 | Brianchon ten-arc `[10,3,8]_q` coding scan across `q ≡ ±1 (mod 10)` | one cheap wave |
| 4 | Maximality of the Dye figure as an exterior set along `q ≡ 11 (mod 20)` | rider on #3's driver, gated |
| 5 | Diagonal cubic surface / Eckardt-point dictionary | reading; compute only if a gap survives |
| 6 | Famous homes of `A₅`/`PSL(2,11)` | reading only; keep Ergodis out |

---

## 1. The terrain this designs against

**What changed on 2026-08-31.** C1020 reconstructed Brouwer's exceptional complete-exterior-set
census and found the `q = 11` and `q = 31` entries are one figure at two completion levels; C1022
found the figure, its two-Brianchon-points-per-chord structure, its `A₅` stabiliser, and the
internal-versus-external congruence all in Dye 1991, leaving only the bridge to Brouwer's census
unclaimed — and extracted the mechanism: the figure's sizes are constant (6 vertices, 10 Brianchon
points, over every admissible field) while `(q+1)/2` grows, so `6 = (q+1)/2` and `16 = (q+1)/2` each
have one solution. Third Dye pre-emption in one day; the lane's working rule is now *check Dye 1991
before claiming any conic-hexagon geometry as new*.

**Consequences for design.**

- Any direction whose hit is a statement *about the hexagon-and-conic figure in `PG(2,q)`* starts at
  high pre-emption odds against Dye 1991/1988/1996, Edge 1956, BSW 1991/1992, Korchmáros 1981,
  Storme–Van Maldeghem 1995, Van de Voorde 2011 — and two of those (Dye 1996, Korchmáros 1981) are
  still unread, so the exposure is not even fully mapped. Directions below either leave the plane,
  leave the category, or sit on the coding side the deep-hole audit certified unclaimed.
- The completion-level mechanism is a *new lens the repository owns* (C1022 §6, explicitly the
  auditor's assembly, not Dye's and not BSW's). A lens is more valuable than any single finding: it
  can be pointed at other censuses. That is direction 1.
- The existing Ergodis target slate (`notes/2026-08-31-ergodis-target-mining-from-gem-reports.md`)
  already ranks the *within-conic-geometry* compute program (healthy-arc prime powers, U-atlas,
  Brouwer extension past 131, flag closure, extremal stabilisers). This report deliberately does not
  duplicate it; the two slates are close to orthogonal, and where a direction below touches that one
  (the U-atlas), it is flagged.

**Ergodis capability, verified against source this session** (core at
`papers/complete-repair-ports/ergodis/src/`, plus measured reports):

- `field::SmallField` — runtime `GF(p^h)`, **order ≤ 256**; `projective::ProjectiveIndex` — generic
  `PG(d,q)` ranking; `matrix::null_space_with` — exact kernels over runtime fields. All landed
  2026-08-31.
- Measured census ceiling ≈ `2·10⁹` projective points per wave, memory-bound
  (`notes/2026-08-30-c1018-hunt-prs-deepholes.md` §5.3e: `PG(8,13)`, 8.8·10⁸ points, 396 s, 968 MB).
- Exact minimum-distance search demonstrated at `1.34·10¹⁰` candidates with sharded replay
  (`notes/2026-08-31-certified-distance-prototype.md`); the tasking prompt's `5·10¹¹`-in-72-minutes
  figure was not re-located this session and is carried as unverified here.
- `hall.rs` (matching + Hall-deficiency certificates), `sat.rs`, `zdd.rs`, `coherent_closure.rs`,
  `group_action.rs` all present. **Two standing driver-side gaps** (C1020 §7): no clique engine in
  core (Bron–Kerbosch lives in the C1020 driver) and no `FinitePermutationAction` adapter for
  projective groups (built by hand per driver so far).

Every cell proposed below is at least three orders of magnitude under the census ceiling; the
binding resource for this campaign is reading time and pre-emption risk, never compute. C1020's
entire twelve-field census ran in under three minutes single-threaded under load ≈ 50.

---

## 2. Design principles

The lane's four method rules, translated to connection-hunting:

1. **Census, not curated list — applied to the *other* category.** A connection hunt is well-posed
   only when the far side is a published complete classification (or machine-enumerable domain), so
   that "the hexagon does not appear anywhere in X" is a theorem over X. Hunting the hexagon in an
   open-ended literature is browsing, not mining.
2. **The detector must be decidable and the hit must land on two names at once** — the hexagon's,
   and the far entry's. That is what a bridge is.
3. **Null declared per direction, before looking** (each direction below carries one).
4. **Upgrade protocol on any hit, immediately**: stabiliser by element-order spectrum, distance to
   second-best, perturbation instability, and the same invariant at the neighbouring parameter.

Two additions earned by today:

5. **Reading finds bridges; Ergodis certifies them.** The marginal cost of *verifying* a proposed
   identification is minutes (C1020's model: independent reconstruction, two implementations, two
   conic models, elementwise stabiliser spectra). So the campaign's waves should mostly be
   verification waves behind reading passes, plus the small number of standalone censuses in §3.
6. **A per-direction pre-emption gate is mandatory before any wave**, at the standard of
   `notes/literature-audit-conventions.md`: the far census's own discussion of its sporadic entries,
   plus three-index forward closure on the census paper. The C1022 precedent — zero indexed works
   cite both Dye and BSW — shows why bridges survive this gate when object-level claims do not.

---

## 3. Ranked directions

### Direction 1 — the sporadic-census decomposition scan (export the completion-level lens)

**Rank 1**, because it generalises the one move that produced surviving novelty today, and because
its per-cell cost is C1020-sized.

**The exact question.** Published complete classifications in finite-geometry-adjacent categories
carry entries their own authors call sporadic, exceptional, or unexplained — exactly as BSW §3 did.
For each such entry `E`: does `E` decompose as a *constant-size classical figure* `F` plus completion
strata, with the arithmetic `|F|-levels = threshold(q)` pinning the parameter at which `E` occurs —
the way the Dye figure's `6` and `6+10` pin `q = 11` and `q = 31` against `(q+1)/2`? Concretely,
compute for each entry: setwise stabiliser with element-order spectrum; orbit decomposition under
it; sub-configuration spectra against the named-figure catalogue (arcs, frames, Pasch, unitals,
subconics, the Dye figure itself); point-type and incidence profiles; and the decomposition test.

**The census.** Two-layered. The outer layer — *which* classifications qualify — must itself be
assembled by a bounded literature pass with the criterion "published, complete up to isomorphism,
containing entries the authors flag as sporadic", and recorded as a closed list before any wave.
Candidate seeds from this session's recall, **unverified and to be confirmed or discarded by that
pass, not trusted**: the exceptional entries in Storme–Van Maldeghem's primitive-arc classification;
sporadic maximal partial ovoids and spreads of small generalized quadrangles; the sporadic small
complete arcs in the Hirschfeld–Storme tables; exceptional entries in classified minimal blocking
sets and unitals. The inner layer — the reconstruction of each entry — is exhaustive per cell.

**Ergodis primitive.** Exactly C1020's proven stack: `SmallField` + `ProjectiveIndex` + driver-side
Bron–Kerbosch (or the category's analogous search) + hand-built projective action + element-order
stabiliser typing. All cells are `PG(2..4, q ≤ 32)`-sized or nearby: minutes each. The missing core
clique engine and projective-action adapter (C1020 §7) would be reused in every cell and are the one
infrastructure investment this direction justifies.

**Declared null.** Sporadic entries are irreducibly sporadic: no constant-figure decomposition, no
second name in the stabiliser spectrum, no arithmetic pinning. (BSW's list is now known to violate
this null twice; the null says that was the exception, not the rule.)

**What a hit lands on.** A named classical figure inside a named census entry — a bridge between two
literatures, with the pinning arithmetic as a mechanism statement. This is precisely the C1022
survivor class.

**What a miss buys.** Per cell, a certified "no hidden constant figure" tag the census's own record
lacks — small but real, and it accumulates into a statement about the lens itself (where it does and
does not apply).

**Pre-emption assessment.** Per-cell gate mandatory (§2 rule 6): the census paper's own §-remarks
first — census authors sometimes explain their own sporadic entries — then forward closure on the
census. Structural reason for optimism: a decomposition hit names a figure from a *different*
literature, and the C1022 evidence is that such cross-citations are absent even when both sides are
thirty years old. Structural reason for caution: Dye 1996 ("Double-sixers of hexagons, `A₆` and
`PSL₃(K)`") is located, unread, and could own hexagon-flavoured decompositions of larger figures;
obtain it before any cell whose candidate figure `F` is hexagon-derived.

---

### Direction 2 — the rank-4 Coxeter phase census at `q = h+1`

**Rank 2**: the cheapest fully-specified new census on the board, entirely outside Dye's
neighbourhood, feeding a boundary clause of an existing manuscript — with one live spark.

**The exact question.** The quadratic-trade paper proves the rank-3 phase: at `q = h+1` the
projective complement of the reflection arrangement becomes exactly the full rational conic, at
`(A₃,5), (B₃,7), (H₃,11)`, and the completeness theorem says those are the only occurrences *in
rank 3*. Does anything of the kind survive in rank 4? For each irreducible rank-4 reflection group
at its `q = h+1` prime power — `D₄` at 7, `B₄` at 9, `F₄` at 13, `H₄` at 31 (`A₄` gives `q = 6`,
excluded) — compute the mirror-arrangement complement in `PG(3,q)` and its canonical strata, and
test exact equality with the rational point set of a named variety (quadric, twisted-cubic orbit,
union of conics, Veronese/Segre stratum), plus the `W`-orbit structure.

**Cheap arithmetic already done (this session, by hand — to be recomputed in the driver).** The
count identity is classical and must not be claimed: `χ_W(h+1) = ∏(1+m_i) = |W|` since exponents
pair to `h`. Projectively the complements have sizes `32, 48, 96, 480` at the four cells, against
`q+1 = 8, 10, 14, 32`. In rank 3 the size is always exactly `q+1` — the conic. In rank 4 the ratios
are `4, 24/5, 48/7, 15`: integral exactly at `D₄` (4 times `q+1`) and `H₄` (**15 times `q+1`**),
suggestive of a union of rational-curve orbits at those two cells and of no curve structure at
`B₄`, `F₄`. One run decides.

**The spark.** `H₄`'s cell is `q = 31` — the same field where the hexagon recurs at completion
level two, selected there by a completely different mechanism (`16 = (q+1)/2`). `√5 = 6` in
`F₃₁`, so the `H₄` mirror frame is rational there. And `H₃ ⊂ H₄` puts a projectivized `H₃` mirror
arrangement — which *is* the fifteen Clebsch secants, by the repo's own arrangement theorem — inside
every `H₃`-parabolic wall. Whether the `q = 31` Dye figure literally embeds in the `H₄/F₃₁`
arrangement geometry is a decidable sub-question and comes free with the driver. Two independent
mechanisms selecting 31 that turn out to meet would be exactly the campaign's title deliverable; the
null says they do not meet.

**Ergodis primitive.** `ProjectiveIndex` on `PG(3,q)` (30,784 points at `q = 31` — trivial);
`SmallField` for `B₄/F₉`; `null_space_with` on Veronese evaluation matrices for the variety fits;
driver-side `W`-action (root systems hard-coded; `H₄` needs `√5`, present at 31). Minutes per cell.

**Declared null.** No rank-4 cell has any canonical stratum equal to a named variety's rational
points; the conic phase is rank-3-specific; the `H₄/31` and completion-level/31 coincidence is
numerological; the `15(q+1)` count at `H₄` is not fifteen conics.

**What a hit lands on.** A named variety in `PG(3,q)` carrying `W`-symmetry — a rank-4 sibling of
the conic phase, upgrading the quadratic-trade paper's boundary from "we proved rank 3 stops" to
"and here is what replaces it"; at `H₄` it would additionally tie the arrangement literature to the
exterior-set literature at `q = 31`.

**What a miss buys.** A clean, citable boundary clause for the quadratic-trade completeness theorem:
the phase phenomenon measured dead in rank 4 at all four prime-power cells.

**Pre-emption assessment.** The complement *counts* are Orlik–Terao textbook material and
`χ(h+1) = |W|` is a standard exponent identity — claim neither. Calvo 2024 owns the modern
reflection-arrangement-over-`F_q` ledger (snapshot § priority boundary): gate the write-up on
checking Calvo for rank-4 point-set identifications. Dye is not exposure here — he never leaves the
plane. Residual risk is the invariant-theory literature on reflection arrangements in special
characteristic; the reading gate is one bounded pass over Calvo plus Orlik–Terao forward citations
on the `q = h+1` specialisation.

---

### Direction 3 — the Brianchon ten-arc `[10,3,8]_q` coding scan

**Rank 3**: squarely in the lane's audited-unclaimed seam (classical geometry, unclaimed coding
reading), trivially cheap, and it upgrades an existing one-field side result to a family theorem
either way.

**The exact question.** Storme–Van Maldeghem 1995, Proposition 11 (screened at partial depth in
C1022): the ten Brianchon points of the Clebsch hexagon form a **10-arc** when `q ≡ ±1 (mod 10)`.
That arc is the column set of a `[10,3,8]_q` MDS code with `A₅` inside its monomial group. For every
prime power `q ≡ ±1 (mod 10)`, `11 ≤ q ≤ 251`: compute the code's exact deep-hole locus (points on
no secant of the arc), the arc's completeness and extension spectrum, and the curve-fit of the locus
via Veronese kernels. Step 0: verify that the snapshot's `q = 11` side result — "a ten-arc with the
same `A₅` symmetry has *empty* deep holes" — is this arc, which the snapshot does not quite pin.

**Ergodis primitive.** `SmallField` (reaches 251 exactly), `ProjectiveIndex`, bitset covering masks,
`null_space_with` for the fits. Per-`q` fully exhaustive over off-arc points; the whole scan is one
short wave. Shares its driver skeleton with Direction 4.

**Declared null.** Empty deep holes at every `q` in range — icosahedral emptiness is a family fact,
the hexagon stays the lone exception; the arc's completeness behaviour shows no pinned levels; no
curve-fit lands.

**What a hit lands on.** A second instance of a deep-hole locus equalling a named variety's point
set — the second gem this lane exists to find, in the one category (deep holes of MDS codes) whose
audit found no prior variety-identity instance anywhere.

**What a miss buys.** The family theorem "under icosahedral symmetry the deep-hole locus is empty
for all `q ≡ ±1 (mod 10)` up to 251", which strengthens the exceptionality framing of the deep-hole
companion — the same manuscripts the `q = 11` side result already serves.

**Pre-emption assessment.** The ten-arc itself is Storme–Van Maldeghem's (in print, 1995) and must
be cited as theirs; Dye owns everything about the points' geometry. The coding layer is the lane's
audited seam: the 2026-07-14 deep-holes audit found no prior deep-hole/variety identifications, and
none of the C1022 screened sets touch covering radius. Gate: read SVM's §5 in full (only §4–5
excerpts read so far) and run forward closure on SVM before writing a word.

---

### Direction 4 — maximality of the Dye figure as an exterior set along `q ≡ 11 (mod 20)`

**Rank 4, a rider** on Direction 3's driver, gated on one read.

**The exact question.** By Dye's congruences (C1022 §2 assembly): for `q ≡ 11 (mod 20)` the
hexagon's six vertices form an exterior set; for `q ≡ 31 (mod 60)` so do all sixteen points.
Complete only at `q = 11` and `q = 31`. For every other such `q ≤ 251`: is the 6-set (respectively
16-set) *maximal under inclusion* as an exterior set, and what is its extension spectrum? C1020
found sub-maximum maximal exterior sets exist in quantity but enumerated none structurally; a single
`A₅`-invariant infinite family of maximal exterior sets would be a named structured object in a
literature that currently records sub-maximum maximality as noise.

**Ergodis primitive.** Same stack as Direction 3; per-`q` the extension test is exhaustive over
external points — seconds.

**Declared null.** For every `q > 31` in the classes, the Dye-figure exterior set extends; nothing
distinguishes it in the exterior-set category beyond `q = 31`.

**Hit / miss.** Hit: an infinite `A₅` maximal family bridging Dye's figure into the exterior-set
literature at *all* `q`, not just the two complete levels — a natural companion statement to the
completion-level mechanism. Miss: the completion-level story is the whole story, which rounds off
C1022 §6 cleanly and is worth one sentence in whatever manuscript takes the bridge.

**Pre-emption assessment.** **Gate before compute:** Van de Voorde 2011 Theorem 15 studies
extendability of a specific exterior set and was read only at partial depth; she may already do
this. One cached read settles the gate. Korchmáros-school extendability literature is second
exposure; forward closure on Van de Voorde covers it.

---

### Direction 5 — the diagonal cubic surface: settle the relationship by reading, then at most one census column

**Reading, not compute.** The relationship is not open at its base: Dye 1991 §1.4 states that
Clebsch *encountered the hexagon in the plane representation of the diagonal cubic surface*
(Clebsch 1871, p. 336) — the connection is the figure's birth certificate, not a discovery waiting
to happen. The precise dictionary to verify by reading (candidate statement, this session's, to be
checked against Dolgachev's *Classical Algebraic Geometry* §9 and the Eckardt-point literature, not
trusted): blowing up the six hexagon points carries the ten Brianchon points to ten **Eckardt
points** of the resulting cubic surface, and the diagonal cubic's famous ten Eckardt points are
exactly this configuration. The repository already touches the surface from the other side (the
trace dual of the cross-golden determinant *is* the smooth Clebsch diagonal cubic, snapshot §1; the
Hassett–Tschinkel determinantal converse). What reading should decide: whether any finite-field
question survives — e.g. an Eckardt-point census of cubic surfaces over `F₁₁`/`F₃₁` against the
classified cubic-surface-over-`F_q` literature (Dickson, Swinnerton-Dyer, Hirschfeld, and the
modern complete censuses over small fields), which likely already owns the counts. **Only if the
reading pass returns a decidable unclaimed cell does Ergodis enter**, and then as one census column
(cubic-surface enumeration up to `PGL₄(q)` at `q = 11` is a real but bounded driver; do not start it
on spec). Declared null for that contingent cell: the Eckardt-maximal surfaces over `F₁₁`/`F₃₁` are
exactly the diagonal-cubic orbit and the census adds no new incidence. Pre-emption: the heaviest of
any direction here — assume owned until the reading pass proves a gap.

### Direction 6 — famous homes of `A₅` and `PSL(2,11)`: reading only, and mostly already closed

Keep Ergodis out. The scorecard from the record: the **Paley biplane** meeting is C192, killed by
Edge §32 and Klein 1879; **Bring's curve** is bridged to Dye's hexagon *in print* —
Braden–Disney-Hogg 2022 reproduce the canonical hexagon and its ten Brianchon points for Bring's
curve (screened in C1022) — so that connection exists and is theirs; the **`S(5,6,12)`/`M₁₂`**
side is in-repo (hexad theorem, Witt shadow) with its own audit; **modular curves at level 11 and
Galois's exceptional actions** are a celebrated literature (Klein through Kostant) with no
enumerable far census and no decidable detector — any campaign question here fails §2 rule 1 as
posed. If the user wants this direction, the deliverable is a reading memo mapping which of the
famous homes already cite the hexagon (Bring's curve now does) and which provably cannot see it —
not a wave. The one seed left unresolved by design: the *common cause* of the triple coincidence
(exterior set + Mathieu hexad + deep-hole locus at `q = 11`) is a theory question; the repository's
partial answers (the golden normal form forcing `√5`, the completion-level arithmetic, the
`{0} ∪ QR` orbit mechanics of C147) are the current state, and no census sharpens "why these three
at once" — flag it for a thinking pass or an expert-persona consultation, not for Ergodis.

---

## 4. Do not point Ergodis at

1. **Any claim inside conic-hexagon geometry in `PG(2,q)`.** The Dye rule, three violations caught
   in one day. This includes re-deriving congruences, stabilisers, self-polar triangles, Brianchon
   structure at any `q`.
2. **A census to find the maximum Brianchon count of a six-arc.** C1020's mystery ledger carries
   this as open ("not settled over all six-arcs, which would need a separate census") — but the
   results snapshot states the bound of ten triple-concurrence points as a Lean-checked theorem over
   every field where 2 is invertible, with equality rigid and forcing the golden normal form. If
   that reading is right, the ledger item is answered internally and the census would recompute a
   machine-checked theorem. **Flagged for the vet as a cross-repo consistency check, not acted on.**
3. **Petersen-graph detectors.** The chord graph being Petersen is forced: a connected cubic graph
   on ten vertices with an edge-transitive group is Petersen (C1022's two-line argument). Any
   "Petersen appears!" hit is contentless; detectors must key on rarer invariants.
4. **The order-6 conference two-graph / mystic-pentagon territory.** Five clean pre-emptions logged
   in the golden-operator programme audit (Howard–Millson–Snowden–Vakil, Bussemaker–Mathon–Seidel,
   Gripaios–Nguyen, Fickus–Mixon); the surviving operator layer is `golden`'s manuscript material,
   not a hunting ground.
5. **Anything Hadamard, Legendre-pair, or conference-matrix adjacent** — owned by another agent's
   active work; excluded exactly as the target-mining slate excluded it.
6. **Unkeyed symmetry scans** ("find `A₅` everywhere"). A stabiliser is only a hit when the ambient
   census is complete and the invariant lands in a second classified category; bare `A₅` sightings
   are numerology under rule 2.

---

## 5. The meta-question, answered plainly

**Is this campaign a good use of Ergodis at all?** As posed — no. The machinery's demonstrated
strength is exact exhaustion with certificates over well-posed finite domains (a 2·10⁹-point census
ceiling, 10¹⁰-candidate distance runs with sharded replay, per-node Hall certificates). "Unexpected
connections" is not a finite domain, and the week's own history shows the finding step living in
reading and extraction passes while compute supplies verification and the occasional conditional
ingredient. Three conditions make a connection hunt well-posed enough for the machinery to bite:
the far category has a **published complete classification** (or is machine-enumerable); there is a
**decidable detector** whose hit names objects on both sides; and the **declared null over the
census is itself worth stating**. Directions 1–4 meet all three; Directions 5–6 fail at least one
and are routed to reading. The honest budget is reading-led: one bounded literature pass gates every
direction, waves run only on cells the pass leaves alive, and the upgrade protocol runs on any hit.
Where Ergodis is irreplaceable is the C1020 pattern: once reading proposes a bridge, a
certificate-grade independent reconstruction with elementwise stabiliser typing costs minutes and
converts a proposal into something a vet can lean on. Buy that, repeatedly; do not buy exploration.

**Vibe check**: the terrain is adversarial — the classical ground is mined out and Dye keeps
collecting — but the completion-level lens and the bridge class are genuinely ours, cheap to wield,
and the four computable directions all pay something on a miss.

---

## 6. Trust boundary

All rankings, nulls, feasibility calls, and the hand arithmetic in Direction 2 (`χ_W(h+1) = |W|`
specialisations; complement sizes `32, 48, 96, 480`; `√5 = 6` in `F₃₁`) are this session's and
unreplayed; the Direction 1 candidate-census list is recall-level and explicitly untrusted; the
Eckardt dictionary in Direction 5 is a candidate statement to verify, not a claim. Ergodis
capability claims are read from source and from the cited measured reports at today's core state;
the core moved twice on 2026-08-31 and should be re-checked at wave time. Nothing here allocates
work, expands any lane's scope, or edits any document but this file. The vet is the user's to
launch; this session did not launch one, did not commission one, and did not self-vet.
