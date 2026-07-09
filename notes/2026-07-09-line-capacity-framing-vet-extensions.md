# Vet + extensions: the line-capacity incidence framing

Date: 2026-07-09. Author: Fable (vetting pass; read-only, no other artifacts edited).

Scope: critical vet of the "line-capacity independent set" umbrella (handoff
[`2026-07-06-projective-cap-game-handoff.md`](handoffs/2026-07-06-projective-cap-game-handoff.md)
§Literature/Framing), the proposed abstract wording, and the four named tools
(capacity-mirror obstruction, fixed-locus caution, residual-capacity decomposition,
line-load/slack counting); then extensions only for what survives. Builds on
[`2026-07-09-fable-line-capacity-review.md`](2026-07-09-fable-line-capacity-review.md) —
its established results (mirror obstruction correct and capacity-independent;
reservoir→Hall/matching dead below q≈38; blocking-set bound 2q−1 > q+1 forbids whole-board
collapse) are taken as ground truth, not re-derived.

## Net verdict

**POSITIVE WITH SCOPE.** The framing is sound, and the novelty guard is correctly
calibrated — but its theorem-level content is exactly two capacity-general facts (the
slack-1 mirror obstruction and the blocking-set collapse obstruction), not four tools, and
the unification's real computational payoff flows in **one direction only**: capacity-1
(Node-Kayles) theory imported into the capacity-2 endgame via capacity degradation. That
direction is precisely what conic-localization (D3) already is. Two of the four named
tools are vocabulary, not lemmas. Build on the surviving half; do not present the umbrella
as a framework that transfers tools symmetrically, and do not lead a paper with it.

---

## Stage 1 — verdicts

### Q1. Is the unification rigorous, or a shared definition schema? — SOUND (as a subfamily claim), with one sharpening

The reduction is rigorous and the handoff states it correctly: given lines `L` and
capacities `c(L)`, forbid the `(c(L)+1)`-subsets of each line; this is Sieben-style
impartial hypergraph building-avoidance, with c=1 giving Node-Kayles on the conflict graph
and c=2 giving Nofil on the collinearity-triple hypergraph. Legal positions in both cases
are "line-capacity independent sets." So the definition genuinely covers both games.

What IS shared across c:

- the incidence-matrix / line-load / residual-slack view of a position;
- the slack-1 mirror obstruction (capacity-independent — the one theorem-level shared item);
- the blocking-set obstruction to global capacity collapse (a second capacity-general fact,
  added by the C33 corrections);
- a counting template for reservoir/move-availability lemmas.

What is NOT shared — the structural gap the abstract should not paper over:

- **At c=1 the conflict structure is static.** The conflict graph is fully determined
  before play; legality of `x` depends only on pairwise adjacency to selected vertices.
  The whole capacity-1 theory (graph decompositions, path/cycle nimbers, octal-game
  periodicity) rides on that.
- **At c≥2 the effective conflict structure is play-dependent.** Every selected *pair*
  mints new forbidden points (its secant's third points), so the "graph" a c=2 position
  sees is a function of the position. This is why cap-game proofs need residual/maintenance
  arguments where queens proofs use static pairings, and why the reservoir→matching
  transfer died: the static-certificate shapes that close c=1 games do not exist at c=2.

One further sharpening: at c=1 with arbitrary two-point "lines," the subfamily is
coextensive with **all** of Node-Kayles (every edge is a 2-point line). "Structured
incidence-geometric" carries the entire weight of the claim; the abstract should say the
queens case is the four-direction geometric-line instance, not leave "capacity-1 case"
bare.

Conclusion: "line-capacity independent set" names a single useful *object* (the position
and its slack profile), but not a single *dynamics*. One framework = one definition schema
+ two capacity-general lemmas + one counting template. That is a legitimate and useful
framing section; it is not a framework in the sense a referee would demand of a headline.

### Q2. The four named tools

| Tool                            | Verdict                    | Class | Load-bearing?                                        |
|---------------------------------|----------------------------|-------|------------------------------------------------------|
| Capacity-mirror obstruction     | SOUND                      | (i)   | Yes — C27 correction, Lean-checked (D2)              |
| Fixed-locus caution             | JUST-VOCABULARY            | (iii) | No — diagnostic prose, corollary of the obstruction  |
| Residual-capacity decomposition | SOUND but capacity-specific| (ii)  | Yes — as the frame of conic-localization (D3)        |
| Line-load/slack counting        | JUST-VOCABULARY as a tool  | (iii) | Not yet — underwrites the open preservability lemma  |

- **Capacity-mirror obstruction — SOUND, class (i), load-bearing.** Confirmed per the
  prior review: for capacity c, legal `x` forces chord load `r ≤ c−1` and the joint reply
  `S ∪ {x, σx}` fails iff `r = c−1`, i.e. exactly on slack-1 mirror-chord lines. It is the
  corrected form behind the landed elliptic mirror (`PG(2m−1,q)` odd q) and the q-even
  translation mirror, and D2 records it as Lean-checked. One calibration: its **c=1
  instance is folklore** — "the mirror reply fails iff σx attacks x" is implicit in every
  classical mirror argument, including the queens ρ-mirror and center+mirror proofs in
  [`2026-07-01-queens-nimber-a344227.md`](handoffs/2026-07-01-queens-nimber-a344227.md),
  which were proved without any capacity vocabulary. The lemma's value is entirely at
  c ≥ 2, where the side condition is non-obvious (the C27 trap). State it generally, but
  do not claim it teaches the c=1 world anything.
- **Fixed-locus caution — JUST-VOCABULARY, class (iii).** As written ("fixed points must
  be illegal, but that alone is not enough…") it is a design heuristic with no
  hypothesis/conclusion shape. Its entire content is a corollary of the mirror
  obstruction: a blocked fixed locus concentrates chords, so it tends to create slack-1
  mirror-pair lines. It correctly *diagnoses* the C32 composite-mirror negatives
  ([`2026-07-08-codex-evendim-composite-mirror.md`](2026-07-08-codex-evendim-composite-mirror.md):
  the center's row/column obstruction, then the double-pencil and dead-H failures), but it
  proves nothing on its own and appears in no landed proof as a cited step. Keep it as
  prose guidance next to the obstruction lemma; do not name it as a lemma or list it as a
  framework tool in a paper.
- **Residual-capacity decomposition — SOUND but capacity-specific, class (ii).** The
  trichotomy (saturated lines = blockers; slack-1 lines = graph conflicts; slack-2 lines =
  surviving triple constraints) is real and is exactly the frame in which
  conic-localization lives — the live conic *is* the residual subboard where the collapse
  to Node-Kayles happens, and the blocking-set bound (2q−1 vs q+1) correctly scopes the
  collapse to local subboards. So it is load-bearing as an organizing frame for D3. But as
  a general-capacity "decomposition theorem" it is a definition-unfold: partitioning lines
  by load is content-free without the geometry that makes the local collapse *structured*
  (involution matchings, degree ≤ 2). The theorem content is geometric and c=2-specific;
  present the decomposition as the setting, the localization as the result. (The
  whole-board over-read was already corrected by C33 — no further correction needed.)
- **Line-load/slack counting — JUST-VOCABULARY as a named tool, class (iii) bordering
  (ii).** This is standard incidence counting; every finite-geometry argument does it.
  Its concrete instance (the `q − k − C(k,2) − 1` reservoir) is real, is the underwriter
  of the *open* preservability obligation, and per the prior review should be written once
  in incidence-matrix form so row/column/conic reservoirs fall out uniformly — that
  template is worth having (see E3). But it is not load-bearing in any landed proof yet,
  and at c=1 it reduces to the standard queens availability counting that the queens work
  already does without the name. A technique label, not a transferable lemma.

### Q3. Novelty calibration — SOUND; the abstract wording is acceptable with two edits

"Structured finite-incidence subfamily, not a new game class" is the right claim and the
guard in the handoff/proposal enforces it well. On the proposed abstract wording itself:

- "We study a structured incidence-geometric subfamily of impartial hypergraph
  building-avoidance games" — correct and conservative. Keep.
- "legal positions are line-capacity independent sets" — accurate. Keep.
- "**This framework** simultaneously includes…" — the one over-reach risk. "Framework"
  invites the referee question "what does the framework prove that the cases don't?", and
  the defensible answer is two lemmas. Prefer "This subfamily simultaneously includes…" or
  "One definition covers…". Also qualify the c=1 case ("Node-Kayles on queen graphs — the
  capacity-1 case with the grid's four geometric line families") per Q1's coextensiveness
  point.

Adjacent prior art the framing section should add (found in this pass; verify before
citing):

- **General-position achievement game on graphs** (Klavžar et al., arXiv:2111.07425
  [VERIFY authors/venue]) — an achievement game for "no three on a common geodesic," i.e.
  a no-3-in-line-type building game on a different incidence structure. Closest published
  relative of the cap game outside designs; must be cited as adjacent.
- **Impartial avoidance games on convex geometries** (arXiv:2512.06267 [VERIFY]) — recent
  impartial avoidance on geometric set systems; adjacent framing competition.
- **Sieben, Impartial hypergraph games** (Electron. J. Combin. [VERIFY volume]) — the
  ambient PRV/AVD/ACV/DST taxonomy; the umbrella should say which slot our convention
  occupies in his terms.
- **Arc-Kayles and its generalizations** (Schaefer; arXiv:1709.05219 [VERIFY]) — the
  edge-selection sibling, worth one line to preempt "isn't this Arc-Kayles?".

Null result worth recording: searches for capacitated/line-capacity avoidance games found
no prior use of the capacity terminology for this genus — so the *vocabulary* appears free
to claim, hedged as "to our knowledge" (tools are dark matter; a null is not "first").

### Q4. Narrative value — strengthens D1/D2 as a SECTION; would dilute as a LEAD

The umbrella earns its place three ways: it is the natural setting to state D2's
obstruction at full generality; it gives D6 (queens nimbers) a principled citation into
D1; and it supplies the paper's best mechanism sentence (capacity degradation → the cap
endgame is locally Node-Kayles → Dawson's chess on the conic). But D1's selling points —
Segre, the cap-set cousin hook, the even/odd dichotomy — are geometry-specific and
stronger than the umbrella. A two-member family with one shared lemma cannot carry an
abstract's first paragraph; the outcome theorems can.

**Recommendation: lead D1 with the outcome theorems and Segre; place the line-capacity
umbrella as a short framing subsection (with the prior-art additions above), and state the
mirror obstruction there in capacity-general form.** The proposed abstract wording is fine
for that subsection, with the Q3 edits.

---

## Stage 2 — extensions (for the surviving parts only)

Survivors: the mirror obstruction (i), the residual decomposition as the scoped frame of
localization (ii), the blocking-set obstruction, and the reservoir counting template.
Ranked:

### E1 — Mixed-capacity residual games: capacity degradation as the unification's real content
**Tags: (a) high, (c) high. Confidence: high.**

Pressured hardest, per the brief, and it holds — with one demotion. Formalize: a position
`S` induces the residual capacity function `c_S(L) = c − |S ∩ L|` on surviving points; the
continuation game is the line-capacity game with mixed capacities; where all residual
capacities on a subboard are ≤ 1, the local game is Node-Kayles on the residual conflict
graph. This is (a) exactly what conic-localization already relies on — the live conic is
the subboard where degradation completes, and the involution-matching structure is what
makes the degraded game *tractable* Node-Kayles (degree ≤ 2 ⇒ paths/cycles ⇒ Dawson's
chess); and (b) exactly the language of the open maintenance obligation — the mined
`live_on ≤ 2` descent (94.718% in the q=23 one-pair census) is capacity degradation
measured. The demotion: the bare phenomenon "when the available hypergraph collapses to a
graph, Nofil IS Node-Kayles" is **published HHS content** (their Node-Kayles
embedding/hardness bridge — see
[`2026-07-07-nofil-connection.md`](2026-07-07-nofil-connection.md) import #2). So the
claimable statement is the *structured* version: in the geometric family, degradation is
not generic — it lands on unions of Möbius-involution matchings, and the blocking-set
obstruction says it can never complete globally. Concrete deliverable: write this as the
formal preamble of D3 (one definition, one proposition, HHS credited), so the umbrella
converts from vocabulary into the theorem D3 needs.

### E2 — The blocking-set collapse obstruction at general capacity c
**Tags: (c) medium-high, (a) low. Confidence: medium (arithmetic to verify).**

General form of the review's §5: the residual game is globally capacity-≤(c−1) iff `S`
meets every line, so a full collapse requires a *legal blocking set* — a blocking set with
at most c points per line. The obstruction is the comparison "min blocking set size vs
max size of a (·, c)-arc." At c=2 in odd affine planes, 2q−1 > q+1 kills it. At c ≥ 3 the
inequality is **not automatic**: max sizes of point sets with ≤ c per line grow roughly
like (c−1)q (Barlotti bound [VERIFY exact form]; maximal arcs exist iff q is even —
Ball–Blokhuis–Mazzocca [VERIFY]), which crosses 2q−1 already around c=3. So whether a
higher-capacity game can trivialize into a lower-capacity one becomes a real, crisp
threshold question — and q-parity plausibly enters again via maximal arcs, echoing the
even/odd dichotomy that organizes D1. Deliverable: a half-page general statement + the
c=3 threshold computation, in D1's framing subsection. Do not promise outcome theorems at
c ≥ 3; this is a structural remark.

### E3 — The incidence reservoir template, written once at general capacity
**Tags: (a) medium, (b) nil. Confidence: high (value modest).**

Exactly the prior review's §6, adopted as an extension: "legal cells on a target line `T`
≥ `|T|` − (capacity-saturated lines crossing `T` at otherwise-legal cells) − explicit
exclusions," with the row bound `q − k − C(k,2) − 1` derived as an instance and the
Möbius/hyperbola normal form as an explicit hypothesis. Payoff is deduplication (column,
diagonal, conic reservoirs fall out uniformly) and a clean Lean target feeding the
preservability half of the maintenance strategy. State plainly in any paper that at c=1
this is the standard availability count — no new queens content.

### E4 — (exploratory, optional) A capacity-3 empirical leg
**Tags: (c) low-medium. Confidence: low.**

The mirror obstruction is already stated for all c, so the cheapest test of whether the
umbrella has any life at c ≥ 3 is empirical: run the existing grid solver machinery on the
no-4-collinear game for tiny q and see whether the P-pattern and mirror mechanism persist.
Day-scale probe at most; only if idle capacity exists. Explicitly NOT: a capacity-c Lean
`LineCapacityGame` abstraction (the handoff already forbids it; nothing in this vet
changes that).

## Do-not-build list (failed or dead — do not extend)

- **Fixed-locus caution as a named tool/lemma** — prose corollary of the obstruction; keep
  one sentence of guidance, drop the name from paper-facing framing.
- **General-capacity residual-decomposition "theorem"** — definition-unfold; the content
  is the geometric localization, which is D3, not a framework item.
- **Cap→queens tool transfer of any kind** — nothing flows that direction. The c=1
  instances of all four tools are folklore or standard counting; the queens
  mirror/pairing/counting proofs neither use nor need the capacity vocabulary. Any
  abstract sentence implying the framework "gives tools for the queens game" over-promises.
- **Reservoir→Hall/matching and zone-pairing certificates** — already dead
  (review §§1–3, C28); listed here only so no extension resurrects them under capacity
  vocabulary.
- **"Line-capacity games" as a new game class** — the novelty guard stands; the class is
  Sieben building-avoidance with structure, and the adjacent citations in Q3 must appear.

## The three questions, answered

- **(a) Tools for the cap proofs:** Yes, modestly — one genuine load-bearing lemma (the
  capacity-mirror obstruction, Lean-checked) plus the right organizing frame for
  localization and maintenance (residual degradation, E1); the rest is organization, not
  leverage.
- **(b) Tools for the queens proofs:** No — the c=1 instances are folklore; the real
  transfer runs queens→cap (Node-Kayles path/cycle theory into the localized conic
  endgame), and the paper should say so rather than promise the reverse.
- **(c) Paper narrative:** Yes, as a framing subsection of D1 + the setting for D2's
  general statement — never as the lead; add the adjacent citations (general-position
  achievement games, convex-geometry avoidance, Sieben taxonomy, Arc-Kayles) before any
  public use of the wording.

**Single highest-value follow-up:** E1 — write the mixed-capacity residual-game
definition + structured-collapse proposition (HHS credited) as D3's formal preamble; it is
the one place the umbrella becomes a theorem the program already needs.

— Fable
