# Fable review — the gap-mining method, adversarial pass

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-15

Reviewing [the gap-mining method](2026-07-15-gems-theory-gaps-method.md) and the design discussion
that produced it. Companion file only; nothing else touched. Two instrument spikes were run for this
review (§7). Evidence-tag convention: claims relayed from in-repo records cite the record and carry
the level recorded there; the two spikes are tagged at their own level; anything from my model
memory is tagged L0 and is never load-bearing.

## Verdict

The central reframe is right and should survive this review: convert unbounded, per-claim,
adversarial negative-proving into bounded structural reading, priced per region. The ledger, the
statable-null rule, the upgrade protocol, and value-in-the-detector are keepers. But the doc
repeatedly says something stronger than the reframe supports — that structure *replaces* reading —
and several load-bearing claims are wrong in that consistent direction. **The method's true product
is a reading budget, not a reading exemption.** Findings, ranked by how much they change:

1. Tier-1 novelty is *discounted* by argument, not pre-paid — both flagship exemplars bought their
   premises with sweep reading (§1).
2. An un-asked question is not an unknown answer; the lane's most realized failure class
   (known-under-another-name) is missing from the failure table (§2).
3. Search is mis-aimed, not useless; the kill order is missing its two cheapest kill steps, and its
   "free" labels are wrong (§3).
4. The spine welds two orthogonal axes, and forced-empty regions carry a high boring-prior the doc
   assigns only to tier 3 (§4).
5. "Thin beats empty" ignores gate accessibility and is currently unfalsifiable as stated (§5).
6. The composed tier conflates dictionary validity with cell virginity, and its social premise is
   contradicted by the lane's own founding example (§6).
7. Measured today: the doc's cheapest seam instrument reads "dense — skip" on the region containing
   the founding hit, while the object-level instrument resolves the cell correctly at the same cost
   (§7).
8. The doc lost the chat's two internal detectors, and rule 2 as written excludes them
   structurally (§8).

None of this is fatal. A restructure that keeps the spine and fixes all of it is in §9, a first dig
in §10.

## 1. Tier-1 economics — "pre-paid by argument" is false accounting

This is the sharpest problem because the whole move ordering rests on it. Take the doc's own
flagship exemplars:

- **Well-posedness inversion.** The argument's load-bearing citation — that no-accidental-concurrency
  is generic over ℝ/ℚ — is Halbeisen–Hungerbühler, which entered the lane *through the 2026-07-14
  sweeps* (handoff § Literature; in-repo L3 via the hexad sweep and the vet's extraction check).
  Without that read, the lane does not know the char-0 question exists, let alone that it is
  generic. And the argument forecloses only the char-0 wing of the library: nothing stops a finite
  geometer from having asked the concurrency question over F_q directly, with no classical
  antecedent. That wing was closed by reading — the vet closed Lord 1988, Edge 1965a, and Edge 1955b
  at full-text level (in-repo L3/L4, vet §1.6). So C147's ABSENT verdict was paid for in exactly the
  currency the method claims tier 1 avoids. What the structural argument actually secured is the
  **non-specializable value predicate** — it forecloses "corollary of a classical fact", which is
  real and durable — not the novelty claim.
- **Definitional blind spot.** "The exterior-set literature is keyed to external points throughout"
  is an empirical claim about a corpus. It was established by the sweeps (in-repo L2/L3; the vet
  §3 re-verified it against its own reads after one source file was banner-flagged for errors). It
  is reading output. Presented as an "argument", it is a summary of reading wearing an argument's
  clothes.

The correction is a scope split, not a rejection: **every tier-1 argument decomposes into a
mathematical premise and a corpus premise.** The mathematical premise (not well-posed over infinite
fields; the ambient spaces differ; the invariant did not exist before date X) is provable and
ladder-exempt. The corpus premise (all prior work on this object is char-0; the definitions are
keyed one way *throughout*) is a claim about a literature and carries an L-level like any other.
The doc's exemption sentence ("exempt from the ladder but not from scrutiny") has the right
instinct and the wrong scope — exempt the deduction, never the premises.

Consequence for the economics: tier 1 narrows the set of would-be-containing corpora, sometimes
drastically — that is genuine value, and it is why the inversion argument is worth having. But it
zeroes the reading bill only when the surviving corpus is empty, which neither exemplar achieved.
"Pre-paid by argument" should read "discounted by argument", and the spine's priority column should
price the residual read, not assume it away.

## 2. Un-asked question ≠ unknown answer

Forced emptiness is vocabulary-local; mathematical content is vocabulary-global. B's corpus
provably lacking the *question* q(D(O)) does not mean the *answer* is absent from every corpus
under a different question. The lane already paid for this lesson, at scale: the four-orbit
classification, the stabilizer-parity form, the point↔involution machinery, the chirality motif —
each "ours" until a sweep found it under another name (novelty tables §3; CO-TR found by sweep #5,
in-repo L3). The novelty table's own postmortem on C147 says what gap-mined hits become when this
bites: "the pieces all existed; nobody wrote the sentence" — a legitimate note, thinner than the
theorem it looked like. Two consequences:

- **Known-under-another-name must be a named failure mode.** It is the most realized failure class
  in this program's history and it does not appear in the doc's failure table. That is a striking
  omission given the table's other rows were each paid for once; this one was paid for repeatedly.
- **The guard is mechanical, not vigilance.** Fame asymmetry fails precisely when q(D(O)) *factors
  through a coarsening B already studies*. The parity form factored through the 6-subsets of
  P¹(F₁₁) — the conic embedding that made O nameless in B was not load-bearing for that fragment,
  so B (permutation group theory) had answered it. Check per cell: does the transported question
  depend on the structure the far side cannot name? If it factors, assume B answers it and search
  the coarsened form first.

Calibration consequence: because the factoring guard will fire often, expect gap-mined hits to skew
bridge-grade — the *sentence connecting* two literatures rather than a new phenomenon. The Clebsch
hit itself was object+question+computation, not a pure transport. The doc's A+ framing should say
this plainly: transport finds where an A+ result could live; the mathematics still has to be grown
there, and the mined question's answer being partially known elsewhere is the default, not the
exception.

## 3. "A real gap is unsearchable" — overstated, and exactly backwards for this method's candidates

The claim is true for generic un-asked questions and weakest for transport triples, which are the
only candidates this method produces. A triple arrives with q named in B, O named in A, and D
supplying the translation table — the dictionary *is* a vocabulary enumerator, and conjunctive
search over the translated vocabulary is well-aimed by construction. The lane's own record makes
the case:

- The sweeps' actual failure mode was never "search returns nothing on real gaps"; it was
  single-vocabulary search returning confident negatives (consolidated report §4: "Vocabulary
  variation is where the value was" — in-repo, that section is itself the postmortem).
- Sweep #5 posed a transported question in the far side's vocabulary — are the PGL(2,11)-orbits on
  6-subsets published? — and hit CO-TR, the single sweep result that most changed a novelty posture
  (in-repo L3). A method whose doctrine is "gap mining is a reading exercise, not a searching
  exercise" would have deprioritized the query that saved the lane from shipping "we characterized
  S(5,6,12)".
- Sharpest form: **the question is unsearchable; the computed answer is searchable.** Sequences,
  orbit counts, group orders, design parameters are vocabulary-independent keys. OEIS on ω_arc, the
  759-numerology check, the CO-TR table match — all answer-keyed searches the lane already runs by
  instinct (in-repo). A real gap's question has no name, but its smallest computed instance emits
  artifacts that every community's literature indexes the same way.

So the kill order is missing its two cheapest kill steps, and the evidence ladder needs one
clarification, not a rewrite: the ladder prices *negatives* (absence support). Search *positives*
are not on the ladder at all — a hit is an immediate, cheap, L4-grade death for the cell. Amended
kill order in §9.

Two more corrections in the same section of the doc:

- **The "free" labels are wrong.** Naturality-on-the-far-side requires knowing B's survey; the void
  test requires knowing B's track record near O. Both are bounded reads. Only the statable null is
  free. This matters because the doc's economics claims keep depending on steps labeled free that
  are actually the relocated reading — priced-and-bounded is the defensible claim; free is not.
- **The kill filter has an unguarded dual: the degenerate kill.** Smallest-instance computation can
  falsely kill when the smallest parameter is structurally degenerate. In-lane: a hexad cannot lie
  on a conic in PG(2,4) (Edge 1965a; in-repo L4, vet §1.6), and at q=5 the conic has exactly six
  points, so the "6-subset" question is trivial. A smallest-first probe of the hexad question dies
  twice before q=11 — the method as written would have killed the lane's flagship. Rule: kill only
  at the smallest *non-degenerate* instance, and treat degeneracy of the probe as information (it
  is source-1 material — the phenomenon may not be statable below some parameter).

## 4. The spine welds two orthogonal axes

"Name the cause of emptiness" collapses two independent measurements into one ordinal scale:
cause-nameability (an argument) and seam thickness (a citation measurement). They cross freely — an
empty seam with a nameable social cause exists (genuinely disjoint venues and MSC subtrees: nameable,
no swerves to read), and a thin seam with no nameable cause exists. The 2×2 matters because the two
axes have different failure modes and different guards, and the four-tier table silently assigns
each tier one axis's semantics.

Worse, tier 1 inherits a boring-prior the doc assigns only to tier 3. Definitional keying has two
causes the doc does not distinguish: **blindness** (the field structurally cannot see the case — a
gap) and **judgment** (the founders saw the case and dropped it as trivial — a void with a WLOG as
its tombstone). A "we may assume" in a foundational paper is more often a considered act than a
silent omission. The lane's own exhibit: the mixed-type invariant is forced-empty by keying,
genuinely novel — and ranked last in the lane because nobody is forced to care (handoff § Open
frontiers: DOWNGRADED, lowest; queue rationale: "the sweep found nobody who cares"). Forced-empty
plus novel plus worthless is a live combination, and the spine's "mine first" cannot see it, because
the spine optimizes the cheap factor of value × novelty and defers the expensive one to a later
section of the doc.

Two fixes:

- **Promotion is two-axis.** A cell is promoted by (emptiness cause named) AND (value predicates
  pass), scored together before any gate spending. The doc has all the pieces; it just runs them in
  series with the value predicates last, which is the wrong order for a ranking function.
- **A named cause must over-predict.** Cause-naming is the cheapest thing a language model does,
  and the trust boundary's ladder does not currently bind it (causes are not absence claims). The
  guard: a cause that explains only the cell that prompted it is a just-so story. Require one
  out-of-sample prediction per cause, checkable in minutes — definitional keying predicts every
  sampled paper in the corpus exhibits the keying (sample three; one treating internal points kills
  the cause); a social two-community cause predicts near-zero cross-citation at the *object* level
  (one OpenAlex call, §7); a well-posedness cause predicts the classical statement degenerates in a
  specific checkable way. This converts cause narratives from rhetoric into detectors, which is the
  same move rule 3 makes for nulls.

## 5. "Thin beats empty" — three corrections, one of them structural

- **Retrospectivity.** A swerve is visible only relative to a formulated question; the three
  exemplar near-misses were identified after the hit existed. Prospectively, seam thinness is
  measurable but swerves are not — the near-miss cluster is a post-formulation confirmation and a
  gate-bounder, not a mining signal. The doc uses it as both without distinguishing.
- **Dark seams.** "Bounded: read the seam papers" silently assumes the seam papers are obtainable.
  The covering fact is the counterexample sitting in the doc's own motivation section: its seam is
  thin AND two of its papers are ILL-dark (BSW 1991/1992, unread ledger; in-repo), which is
  precisely why it is the stuck claim. Thin-and-dark is the worst cell on the board, not the
  second-best. The rankable quantity is thinness × accessibility, and accessibility is queryable
  (OA status arrives in the same OpenAlex call that measures the seam — §7). Symmetrically, a
  tier-1 claim with a dark near-container is equally stuck; the lane got lucky that Lord 1988's 403
  had an IAS-repository workaround (vet §1.6). The general move-ordering signal, replacing the
  doc's structural-vs-read story (§1 of the doc, and see my §1): **prefer regions whose plausible
  containers are enumerable AND obtainable.**
- **Unfalsifiability as stated.** The thin-beats-empty ordering generalizes from one hit plus
  argument. It can become testable for free: the ledger must record tier-at-entry, the cause as
  named, kill stage reached, gate cost actually paid, and outcome — then a batch of cells tests the
  ordering. The current schema (cell, tier, null, verdict, level) cannot distinguish "the ordering
  works" from "we believed the ordering". Same discipline the lane imposes on every other
  hypothesis: declare the null (tiers are uncorrelated with yield) and let the ledger decide.

## 6. The composed tier — validity is not virginity, and legs do not compose for free

- **The social premise is contradicted in-lane.** "One-hop dictionaries eventually get walked
  because someone knows both fields" — the founding hit is a one-hop cell on a fifty-year-old,
  maximally famous dictionary (arcs ↔ MDS), unwalked for seventy years; and Edge→BSW is a
  thirty-five-year naming gap *inside one field* (in-repo L3/L4 throughout). The observed mechanism
  is vocabulary opacity, which is hop-count-independent. Two-hop cells may still be richer — but
  that is a hypothesis the ledger can test, not a mechanism, and the doc states it as the reason
  composed is the primary mine.
- **Citable legs do not imply a composable dictionary on O.** B→C is documented for B's objects
  generically; it may be degenerate or empty on the image D₁(O). Surveys' connections sections
  document asymptotic and generic links first. Add to the upgrade protocol: compute the composite
  image of O at the smallest non-degenerate instance and check it is not a degenerate case of C
  *before* the cell enters the ledger as live.
- **The Rigor column conflates two properties.** "Real by composition" is a statement about the
  dictionary's validity. Unwalkedness of the cell is an absence claim about a literature and needs
  the same seam/absence evidence as anything else. As written, the table lets composed cells
  inherit a trust status that was only ever argued for their legs.
- **The census overclaim.** "B's survey's connections section *is* the enumeration of B's outgoing
  dictionaries" — no; it is a curated highlight reel with editorial bias toward the fashionable.
  Fine as a generator (positive use), wrong as a census (rule-1 language): a link absent from the
  connections section may be documented in B's research literature. Call it a lower bound and the
  method loses nothing.
- **Value predicates cut against two-hop.** Forced dual audience becomes forced triple audience,
  and it is unclear which corpus a two-hop answer re-keys. Expect composed hits to skew note-grade
  unless the far side is large; that expectation belongs next to the yield claim.

## 7. Instrument spike — the doc's cheapest instrument fails on the founding example

The doc's instrument list is ordered "cheapest first" with arXiv category cross-listing at the top
and citation closure of a seed paper last. Both were run today. [L2 — enumerated at metadata level,
queried 2026-07-15; OpenAlex coverage of 1950s-era citations is incomplete, so old-paper counts are
noisy lower bounds]

| Instrument                        | Query (2026-07-15)                   | Reading                                     |
|-----------------------------------|--------------------------------------|---------------------------------------------|
| category cross-listing, arXiv API | cat:math.CO AND cat:cs.IT            | ≈1850 papers — dense seam                   |
| category cross-listing, arXiv API | cat:math.AG AND cat:cs.IT            | ≈327 papers — dense seam                    |
| object-level closure, OpenAlex    | works citing Edge 1956 (W2319208930) | 7 indexed citers, none coding, latest 1988  |

The Edge citers' venues, for the record: Geometriae Dedicata, Camb. Phil. Soc. (twice), Archiv der
Mathematik, J. Algebra, Annals of Discrete Mathematics, Amer. Math. Monthly — geometry and group
theory throughout, not one coding venue.

Reading: finite-geometry↔coding is one of the *densest* category seams on the arXiv — at the
resolution the doc's lead instrument measures, the region containing the Clebsch cell reads "tier 4,
dense seam — skip." Meanwhile the object-level seam is empty at the same moment: not one coding
venue among Edge 1956's indexed citers. The founding hit is invisible at category resolution and
sharp at object resolution. The doc concedes seam metrics prove nothing, but the problem here is
different — the lead instrument is *anti-correlated* at cell level in exactly the regime this lane
mines (classical object, modern far side), because a dense field-pair seam is *why* the far side's
question list exists at all while saying nothing about whether it ever touched O.

The object-level call costs the same (sub-second, one HTTP request), resolves correctly, and emits
three of the method's needed quantities at once: seam edges, the near-miss candidate list (the
citer titles — "PGL(2, 11) and PSL(2, 11)", J. Algebra 1985, is exactly a near-miss-shaped lead
[L2 — title/venue screened only]), and OA status for the accessibility ranking of §5. The vet
already validated the same instrument on BSW 1992 (nine citers, enumerated and screened in an
afternoon; in-repo L2). Lead with it; demote category cross-listing to a curiosity or drop it.

## 8. What the doc lost between the chat and the disk

Three things the discussion had that the doc dropped, and one rule that now actively excludes them:

- **The mechanism-deformation detector** — transport along the hypotheses of our own proofs, which
  are un-asked by construction because the proofs are new. Ranked in the chat; absent from the doc.
  Its census (our own proofs' hypothesis lists) is the only census in the method that is fully
  owned, fully readable, and confabulation-proof.
- **The bound-shape detector** — a bound whose shape differs from the data's shape (pencil bound
  linear, ω_arc data sublinear; handoff § Settled, flagged unexplained) means the bound's mechanism
  is not the truth's mechanism and the true one is unnamed. In the chat; gone.
- **The null taxonomy** — trivial / vacuous / known-under-another-name / tried-and-failed-silently.
  Rule 3 kept the imperative and dropped the taxonomy. Restore it: known-under-another-name is §2
  of this review, and tried-and-failed-silently is invisible to every instrument in the doc
  (failures are unprinted — a thin seam can be a graveyard of silent attempts, which is a second
  reason thin seams need their swerve-reasons read before being trusted).
- **Rule 2 now excludes the lane's own best internal leads.** "A question posed in our own
  vocabulary is... askable by the community, hence explored" is false when the vocabulary is ours
  and days old — ω_arc, the mixed-type invariant, t(H). No community exists to have asked. The
  chat itself counted the ω_arc shape gap and the mixed-type invariant as accidental validations of
  the method; the doc as written refuses both at rule 2. Fix: scope rule 2 to classical
  vocabulary, and add a source of forced emptiness for it — *the invariant postdates the corpus* —
  which is source 6's sibling and equally decidable by argument (this one genuinely is pre-paid,
  the rare case where the corpus premise is a date).

On the unit of mining: the transport triple is right for the ledger and wrong for the schedule. The
gate amortizes per (dictionary, survey) — one survey read prices every q on its question list for
every O the dictionary carries — so budget and schedule by surveys, ledger by triples. Otherwise
per-cell accounting quietly recreates the per-claim bottleneck this method exists to kill.

## 9. The restructure, compactly

1. **Two-axis promotion.** Score (emptiness cause named, with its out-of-sample prediction) ×
   (value predicates) before spending any gate. Neither alone promotes.
2. **Tier-1 split.** Mathematical premise: ladder-exempt. Corpus premise: L-graded like any absence
   claim. "Pre-paid" becomes "discounted"; the spine's priority column prices the residual read.
3. **Amended kill order.** Statable null (free) → naturality (bounded read, priced) →
   search-to-kill, conjunctive over the dictionary-translated vocabulary (a hit kills; the negative
   is worth ~nothing) → void + degeneracy check → smallest *non-degenerate* instance →
   search-the-answer (OEIS, orbit counts, parameters — vocabulary-independent keys) → factoring
   check (does q(D(O)) survive forgetting the structure B cannot name?) → read to claim, L3/L4,
   survivors only.
4. **Static eval = object-level citation closure.** One call per seed object: seam edges, near-miss
   candidates, OA status. Category cross-listing demoted. Rank regions by
   (cause named) × (value) × (seam thinness) × (gate accessibility).
5. **Failure table additions**: known-under-another-name (guard: factoring check + answer-keyed
   search); degenerate kill (guard: smallest non-degenerate instance); dark seam (guard: OA/ILL
   status before promotion); unfalsifiable cause (guard: out-of-sample prediction).
6. **Ledger schema**: add tier-at-entry, cause-as-named, kill stage reached, gate cost paid, value
   predicates passed. Declare the method's own null — tiers uncorrelated with yield — and let a
   batch of cells test the ordering.
7. **Rules**: rule 2 scoped to classical vocabulary; internal detectors (mechanism-deformation,
   bound-shape, invariant-postdates-corpus) admitted as forced-emptiness sources; the connections
   section renamed a generator, not a census.

## 10. Where to dig first

- **Backfill before mining.** Session one should populate the ledger with the already-decided
  cells, scored as-if-prospective: the Clebsch hit, C147, the mixed-type invariant, C177, C178, the
  octad negative. Cheap, zero new reading, and it calibrates the machine on known ground — the
  mixed-type row exposes the tier-1 value problem immediately, the octad row exercises the
  neighbouring-parameter guard, and the Clebsch row tests whether any proposed static eval would
  have promoted the one cell that mattered. If the method mis-ranks its own history, no new cell
  should trust it.
- **First live cell: C177, already queued.** It is a transport triple with a computable verdict
  (design-theoretic question, geometric object, glue-or-not answer), and running it through the
  full amended kill order makes it the ledger's first prospective datum at near-zero marginal cost.
- **First new dictionary: the composed chain conic-hexads → S(5,6,12) → ternary Golay / M₁₂.**
  Leg 1 is earned (C147). Leg 2 is documented inside design theory and coding — and the lane's own
  sweep record already contains the fame asymmetry in the required direction: Curtis's kitten,
  Conway–Sloane, and Bailey use the same P¹(F₁₁) point set and never embed it as a conic (in-repo
  L3 via the hexad sweep, restated in the handoff § Literature). So the transpose cell — geometry's
  question list (chord concurrency, polarity, the t(H) invariant, secant structure) pulled onto the
  Golay code's standard objects (cosets, weight classes, the two systems) — has named legs, an
  identified thin seam whose papers are known in advance and obtainable without ILL, and a
  computable smallest instance sitting on C147's promoted scripts. My own knowledge of the SPLAG
  chapters' contents is L0 and deliberately carries no weight here; the leg-2 read is the bounded
  gate, identified in advance, which is exactly the shape the method promises.
- **Process**: the first mining pass (backfill + C177 + the Phase A dictionary enumeration) is
  task-shaped and should get the next C-ID at allocation time, pegged `gem-mining`; the method doc
  itself stays infrastructure. The seam-instrument spike the parent flagged as untested is done —
  §7 — and its verdict should be folded into the doc's instrument list before any ordering claim
  rests on it.

## 11. What stands

For completeness, the load-bearing pieces this review leaves intact: the statable-null-first rule;
the upgrade protocol including neighbouring-parameter; closed-cells-as-lane-assets; the value
predicates (add the factoring guard); the evidence ladder for absence claims; source 6 with its
stated anti-over-fear use; and above all the reframe itself — bounded structural reads, priced per
region, in place of unbounded per-claim sweeps. What must go is only the claim that structure makes
reading unnecessary. It makes reading *finite*. That is worth having, and it is enough.
