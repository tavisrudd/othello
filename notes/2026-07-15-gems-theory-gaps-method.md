# Gap mining — a method for searching theory gaps instead of objects

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-15
**Status**: backfilled and surviving its own history ([C191](2026-07-15-c191-gap-mining-backfill.md));
the declared null is untested and awaits C177 as the first prospective cell.

**Terminology.** A *theory gap* here is an un-asked question — a region of question-space nobody has
entered. It has nothing to do with the **gap theorem** of C165/C171, which is a statement about conic
gaps. Do not let the word merge.

The generator in [gem mining](handoffs/2026-07-14-gem-mining.md) § The method mines **objects**: fix
a question, census a domain, evaluate an invariant valued in another classified category, look for
the anomaly. This doc is its analogue for mining **questions** — the un-asked ones whose opening
would be worth a major journal. Reviewed adversarially in
[the Fable pass](2026-07-15-gems-theory-gaps-method-fable.md), which this revision incorporates.

## What this method buys, stated exactly

Novelty gating is this lane's slowest step, and it is a *back*-loaded cost: find the object, then pay
an unbounded reading bill to learn whether it was Edge's all along. C155 is drafted and blocked on
C156/C157/C169. The covering fact is still conditioned on two ILL-only BSW originals after six
independent sweeps.

The fix is **move ordering**. A game-tree search does not avoid leaf evaluation; it spends its budget
on lines a cheap static eval promoted. Here the expensive leaf is the L3/L4 read plus the
mathematics; the static eval is cheap, and it is computed once per region rather than once per
question.

**The product is a reading budget, not a reading exemption.** Structure does not make reading
unnecessary — it makes reading *finite*, bounded in advance, and priced before it is spent. Every
claim below that sounds like "this is free" has been checked against that standard, because the
first draft of this doc failed it repeatedly in one direction (§ Overturned claims).

## What is mined

The unit is a **transport triple** `(O, D, q)`: an object `O` this lane owns, a dictionary `D`
carrying `O` into another vocabulary, and a question `q` that is standard on the far side. The
pullback `q(D(O))` is a question about `O` that our own vocabulary cannot state.

**The dictionary is the scarce resource, not the question.** A question cannot be transported to an
object — only along a dictionary that maps that object. This is what stops the domain from exploding
to `vocabularies × objects × questions`, nearly all of which is nonsense.

**Ledger by triples; budget and schedule by `(dictionary, survey)`.** One survey read prices every `q`
on its question list, for every `O` that dictionary carries. This is where the amortization actually
lives, and per-cell accounting quietly recreates the per-claim bottleneck the method exists to kill.

## Dictionaries

| Tier     | Source                                         | What is established       | What is *not* established |
|----------|------------------------------------------------|---------------------------|---------------------------|
| earned   | read off our own invariants' target categories | validity, by our results  | that any cell is unwalked |
| composed | `A→B` earned, `B→C` documented inside B        | validity, by citable legs | that any cell is unwalked |
| free     | universal machines that accept any object      | nothing — automatic       | everything                |

**Validity is not virginity.** A dictionary's tier says whether the translation is real. Whether a
*cell* on it is unwalked is an absence claim about a literature and needs its own evidence, at the
same L-level as anything else. The tier grants no trust to the cell.

**Earned** dictionaries are not chosen; they are read off results we already have. Stabilizer A₅ and
PGL₂(11) name group theory; deep-hole locus = a conic names algebraic geometry; hexads name design
theory and the sporadic groups; arcs name MDS codes.

**Composed.** If `A→B` is earned and `B→C` is documented inside B's own community, `A→C` is real by
composition. Cautions, each load-bearing:

- **Citable legs do not imply a composable dictionary on `O`.** `B→C` is documented for B's objects
  generically and may be degenerate or empty on the image `D₁(O)`. Before a composed cell enters the
  ledger as live, compute the composite image of `O` at the smallest non-degenerate instance and
  check it is not a degenerate case of C.
- **Hop count is not a yield mechanism.** The tempting story — two-hop composites go unwalked because
  nobody knows three vocabularies — is contradicted by this lane's own founding example: arcs ↔ MDS
  is one hop, maximally famous, and sat unwalked for seventy years; Edge→BSW is a thirty-five-year
  naming gap *inside a single field*. The operative mechanism is **vocabulary opacity**, which is
  hop-count-independent. That composed cells are richer is a hypothesis for the ledger to test, not a
  reason to weight the tier a priori.

**Free** machines — matroids, association schemes, complexity, model theory, tropical, homology —
accept any object, so the dictionary costs nothing. That is the warning: "nobody pointed a matroid at
this" is usually because the answer is boring. These survive only on the void test.

**A survey's connections section is a generator, not a census.** It is a curated highlight reel with
editorial bias toward the fashionable. Use it to *propose* outgoing dictionaries; never read a link's
absence from it as absence from B's research literature. It is a lower bound.

## Promotion runs on two axes, scored before any gate is opened

Cause-nameability (an argument) and seam thickness (a citation measurement) are independent and cross
freely: an empty seam can have a nameable social cause (genuinely disjoint venues and MSC subtrees —
nameable, but no swerves to read), and a thin seam can have none. Collapsing them into one ordinal
scale hides that.

**Promotion ranks regions, not cells.** A region is a `(dictionary, survey)` pair — the unit the gate
amortizes over. The kill order below runs **per cell inside an already-promoted region**, and its
bounded reads are charged to the region that promoted it, not to promotion itself. Confusing the two
is how the per-claim bottleneck grows back.

**Promotion score** — no factor alone promotes:

```
(cause of emptiness named, with its out-of-sample prediction confirmed)
  × (value predicates pass)
  × (seam thinness)
  × (gate accessibility)
```

**Value is a promotion factor, not a post-filter.** Forced-empty + novel + worthless is a live
combination, and this lane already owns the exhibit: the mixed-type invariant is forced-empty by
definitional keying and genuinely novel, and it is ranked *last* in the lane because nobody is forced
to care. A ranking function that runs value last cannot see that.

**Gate accessibility is a first-class factor.** "Bounded: read the seam papers" assumes the seam
papers are obtainable. The covering fact is thin **and** ILL-dark (BSW 1991/1992, unread ledger) —
which is exactly why it is the stuck claim. **Thin-and-dark is the worst cell on the board, not the
second-best.** A structural-cause claim with a dark near-container is equally stuck. The general
signal: **prefer regions whose plausible containers are enumerable AND obtainable.** Open-access
status arrives in the same query that measures the seam.

**A named cause must over-predict, or it is a just-so story.** Cause-naming is the cheapest thing a
language model does, and the evidence ladder does not bind it, because a cause is not an absence
claim. Require one out-of-sample prediction per cause, checkable in minutes:

- *definitional keying* predicts every sampled paper in the corpus exhibits the keying — sample
  three; one treating internal points kills the cause;
- *a social two-community cause* predicts near-zero cross-citation at the **object** level;
- *a well-posedness cause* predicts the classical statement degenerates in a specific checkable way.

This is rule 3's move — declare the null — applied to causes.

## The cause of emptiness: what each class buys, and what it leaves to pay

**Cause class** is the emptiness scale, and it is the ledger's ranking key. It is unrelated to the
dictionary tiers above; "tier" means earned/composed/free and nothing else.

| Cause class       | What the argument buys                                     | Residual reading bill                            |
|-------------------|------------------------------------------------------------|--------------------------------------------------|
| structural        | forecloses a wing of the corpus; secures non-specializable | the corpus premise, L-graded; any wing left open |
| social-thin       | the seam papers are identified in advance                  | read them — bounded **if** obtainable            |
| unnamed           | nothing                                                    | unbounded; probably a void                       |
| dense (not empty) | —                                                          | skip; this is where the bottleneck lives         |

**Structural-cause arguments are discounted, not pre-paid.** Every structural argument decomposes
into two premises, and only one is free:

- **The mathematical premise** — *not well-posed over infinite fields*; *the ambient spaces differ*;
  *the invariant postdates the corpus* — is provable and ladder-exempt.
- **The corpus premise** — *all prior work on this object is char-0*; *the definitions are keyed one
  way throughout* — is a claim about a literature and carries an L-level like any other.

Both flagship exemplars bought their corpus premises with sweep reading. Halbeisen–Hungerbühler
entered the lane through the 2026-07-14 sweeps [in-repo L3, handoff § Literature]; without that read
the lane does not know the char-0 question exists. And the inversion forecloses only the char-0 wing —
nothing stopped a finite geometer from asking the concurrency question over F_q directly, and that
wing was closed by reading Lord 1988 and Edge 1965a/1955b at full text [in-repo L3/L4, vet §1.6].
"Keyed to external points throughout" is likewise reading output wearing an argument's clothes
[in-repo L2/L3, vet §3 — the underlying sweep file carries an errors banner].

What the inversion genuinely secures is the **non-specializable value predicate** — it forecloses
"corollary of a classical fact", which is real and durable — not the novelty claim. Exempt the
deduction; never the premises.

**Blindness and judgment are different causes.** Definitional keying has two, and the doc must not
conflate them: *blindness* (the field structurally cannot see the case — a gap) and *judgment* (the
founders saw the case and dropped it as trivial — a void with a WLOG for a tombstone). A "we may
assume" is more often a considered act than a silent omission. The out-of-sample prediction
discriminates them.

## Sources of forced emptiness

Each is an absence argument with its own census. Each decomposes per the split above.

1. **Field or characteristic inversion.** The phenomenon exists only in finite characteristic, or the
   generic/measure-zero relation inverts against the classical regime. Census: the genericity and
   char-0 hypotheses of the classical theorems. Halbeisen–Hungerbühler is the template. *Corpus
   premise: that all prior work on the object is char-0.*
2. **Definitional keying.** Every field's definitions make a symmetry-breaking choice — external vs
   internal, ordered vs unordered, one class of a dichotomy, a normalization. Census: the definitions
   and the WLOGs of the seed papers. *Corpus premise: that the keying holds throughout — and that it
   is blindness, not judgment.*
3. **Ambient mismatch.** Results about the object in a different ambient space cannot be about ours.
   Census: the object's known incarnations. Havlicek/Coxeter/Pellegrino's 12-cap in PG(5,3) is this.
   *Corpus premise: that the object's known incarnations are all in other ambient spaces — L-graded
   like any other. Closing this wing for the hexad required obtaining and reading Lord 1988 at full
   text* [in-repo L3/L4, vet §1.6].
4. **Fame asymmetry.** `O` is classical in A, `q` is standard in B, `D` is documented, and `O` has no
   name in B. Census: B's object taxonomy. **Guarded by the factoring check below** — this source
   fails exactly when the transported question factors through a coarsening B already studies.
5. **Parameter regime.** The object lives outside the range anyone computed or cared about. Weakest
   source — verify against printed ranges, which are often wider than assumed (Van de Voorde's
   q < 131).
6. **The corpus predates the compute.** A census-derived fact cannot be in Clebsch 1871 or Edge 1956.
   This prunes only the pre-computational half — and our live gate is BSW 1991/92, the
   post-computational half. Use it to stop over-fearing the classical corpus, never to skip the
   modern one.
7. **The invariant postdates the corpus.** If the invariant is ours and days old, no corpus can
   contain a question phrased in it. Source 6's sibling, and the rare case that genuinely *is*
   pre-paid: the corpus premise is a date. This is what licenses the internal detectors below.

## Internal detectors — our own censuses, confabulation-proof

These transport nothing and need no far side. Their **census** is our own work, which makes it the
only census in the method that is fully owned, fully readable, and immune to confabulated literature.

**The licence covers the census, not the cell.** Source 7 licenses only questions phrased in an
invariant that postdates the corpus. A deformation that lands back in classical vocabulary — the
Mathieu-tower axis below is one — is not licensed, and takes the ladder like any other cell.

- **Mechanism-deformation.** Take the mechanism of one of our own proofs, not its statement, and
  enumerate the axes along which the *mechanism* deforms. The q=23 octad negative is the lesson: the
  mechanism needed |H| = 2×3 so that a concurrent triple is a *perfect* matching, so the Mathieu-tower
  axis (q=11→23) was never the right one. Census: our proofs' hypothesis lists — owned, and un-asked
  by construction, because the proofs are new. The *cells* it generates still take the ladder unless
  source 7 covers them.
- **Bound-shape.** A bound whose *shape* differs from the data's shape means the bound's mechanism is
  not the truth's mechanism, and the true one is unnamed. Live instance, flagged unexplained in the
  handoff: the pencil bound is linear in q while the ω_arc data look sublinear.

## Instruments — the static eval

**Lead with object-level citation closure.** One query per seed object returns the seam edges, the
near-miss candidate list, and open-access status — several of the method's needed quantities at once,
in a sub-second call.

**Category cross-listing is demoted; it is anti-correlated in this lane's regime.** Measured
2026-07-15 [L2, metadata level]: `cat:math.CO AND cat:cs.IT` returns ≈1850 papers and
`cat:math.AG AND cat:cs.IT` ≈327 — finite-geometry↔coding is one of the densest seams on the arXiv,
so at category resolution the region containing the Clebsch hit reads **"dense — skip."** At object
resolution the same cell is sharp: works citing Edge 1956 number seven indexed citers, not one in a
coding venue, latest 1988 (Geometriae Dedicata, Camb. Phil. Soc., Archiv der Mathematik, J. Algebra,
Annals of Discrete Mathematics, Amer. Math. Monthly). A dense field-pair seam is *why* the far side's
question list exists at all, and says nothing about whether it ever touched `O`.

**Calibrate the replacement before the ordering rests on it.** OpenAlex under-indexes mid-century
citations, so an object-level closure on a classical seed can read empty for a real gap and for an
indexing artifact alike — the same confirmatory-noise disease this method diagnoses in keyword search,
relocated into its replacement.

**The calibration must be non-circular, and the obvious seed is not.** The vet's BSW 1992 citer
enumeration is itself an OpenAlex live query [in-repo, vet §1.5 and its source list], so it cannot be
ground truth for OpenAlex; and a 1992 seed does not probe mid-century under-indexing in any case. The
at-risk seed is Edge 1956. Calibrate by a route that does not pass through OpenAlex — Edge 1956's
citers from MathSciNet or zbMATH, diffed against the OpenAlex closure. Until that diff exists,
object-level emptiness on a classical seed is a lead, not a reading.

## The rules

Analogues of the rules in the [gem mining](handoffs/2026-07-14-gem-mining.md) handoff, plus one
with no analogue.

1. **Census = the literature's own structure, never a search result.** The test survives verbatim:
   *what does a miss buy?* A missing section in a handbook's classification is a fact; a null result
   from a search engine is noise. Enumerable structures: handbook and survey tables of contents, the
   MSC tree, citation closures, a community's definition list.
2. **The question must arrive through a dictionary — or through an invariant that postdates the
   corpus.** A question posed in *classical* vocabulary is a conjecture: already asked, or askable by
   the community, hence explored. This does **not** apply to vocabulary that is ours and days old —
   ω_arc, t(H), the mixed-type invariant have no community to have asked them, and the internal
   detectors above are admitted on exactly that ground (source 7).
3. **Declare the null before investigating.** State the boring answer and why it would be boring. If
   you cannot state it, you do not understand the question well enough to ask it — drop the cell. The
   taxonomy of nulls, all of which must be refuted: **trivial** / **vacuous** /
   **known-under-another-name** / **tried-and-failed-silently**.
4. **Upgrade protocol on a candidate, immediately.** Smallest *non-degenerate* instance; the
   neighbouring parameter, because coincidence-of-small-numbers is the default hypothesis; name the
   mechanism; name who is forced to care.
5. **Dictionaries are earned or composed, never chosen by taste.** Object mining gets its domain for
   free — PG(2,q) is given. Question mining *chooses* its domain, and the choice is the method, so it
   is the failure point. Earned = read off our own invariants. Composed = two citable legs, with the
   composite image checked on `O`. Anything else is analogy, and analogy is how this degenerates into
   a brainstorm.

## Un-asked question ≠ unknown answer

Forced emptiness is vocabulary-local; mathematical content is vocabulary-global. B provably lacking
the *question* does not mean the *answer* is absent from every corpus under a different question.
This lane has paid for this lesson repeatedly — the four-orbit classification, the stabilizer-parity
form, the point↔involution machinery, and the chirality motif were each "ours" until a sweep found
them under another name. It is **the most realized failure class in this program's history**, and the
guard is mechanical rather than vigilant:

**The factoring check.** Does `q(D(O))` depend on the structure the far side cannot name? The parity
form factored through the 6-subsets of P¹(F₁₁) — the conic embedding that made `O` nameless in B was
not load-bearing for that fragment, so permutation group theory had already answered it. **If the
question factors through a coarsening B already studies, assume B answers it and search the coarsened
form first.**

Calibration consequence, stated plainly: because the factoring guard will fire often, expect
gap-mined hits to skew **bridge-grade** — the sentence connecting two literatures rather than a new
phenomenon. The Clebsch hit was object + question + computation, not a pure transport. Transport
finds where an A+ result could *live*; the mathematics still has to be grown there, and the mined
question's answer being partially known elsewhere is the default, not the exception.

## Kill order — priced, not free

Order by cost. Only the first step is free; the rest are bounded reads or bounded compute, and saying
so is what keeps the economics defensible.

1. **Statable null** — free. Kills the meaningless. Every null type must be refuted.
2. **Factoring check** — free. Does `q(D(O))` survive forgetting the structure B cannot name? If it
   factors through a coarsening B already studies, assume B answers it and go straight to step 4 on
   the **coarsened form**. This runs early because it is cheap and because it guards the failure this
   lane has hit most.
3. **Naturality on the far side** — bounded read, charged to the promoted region. Is `q` load-bearing
   in B's own survey, or did we invent it?
4. **Search to kill** — conjunctive, over the dictionary-translated vocabulary. A hit is an immediate,
   cheap, decisive death for the cell. The negative is worth close to nothing; do not record it as
   absence support.
5. **Void test and degeneracy check** — can the emptiness be named, with its out-of-sample prediction?
   For a free machine: has it ever paid off on an object adjacent to ours?
6. **Smallest non-degenerate instance** — compute. **Not** the smallest instance: a hexad cannot lie
   on a conic in PG(2,4) [in-repo L4, Edge 1965a via vet §1.6], and at q=5 the conic has exactly six
   points so the 6-subset question is trivial. A smallest-first probe of the hexad question dies twice
   before q=11 — naive compute-to-kill would have killed this lane's flagship. Treat degeneracy of the
   probe as information: it is source-1 material, since the phenomenon may not be statable below some
   parameter.
7. **Search the answer** — the question is unsearchable; the **computed answer is searchable**.
   Sequences, orbit counts, group orders, design parameters are vocabulary-independent keys that every
   community indexes the same way. OEIS on ω_arc, the 759-numerology check, and the CO-TR table match
   are all this move. Another cheap decisive kill.
8. **Read to claim** — L3/L4, survivors only.

**Compute to kill, read to claim** still holds, with step 5's degeneracy guard attached. Search is
mis-aimed rather than useless: single-vocabulary search returning confident negatives was the sweeps'
actual failure mode, and sweep #5 — a transported question posed in the far side's vocabulary — is
what stopped the lane shipping "we characterized S(5,6,12)". Search is a first-class *kill* step; it
is never novelty evidence.

## Value predicates

Novelty is free and worthless on its own — there are unlimited un-asked questions and almost all of
them change nobody's belief. These run *inside* promotion, before any gate is opened:

- **Does answering it re-key an existing corpus?** The A+ signature — not difficulty, not novelty. The
  Clebsch hit's worth is that *Edge 1956 becomes a coding theorem*. An isolated new fact is a note; a
  reinterpretation of a classical body of work is a paper.
- **Forced dual audience.** Both communities must update. Note this cuts *against* long composites:
  two hops means a forced triple audience, and it is unclear which corpus a two-hop answer re-keys.
  Expect composed hits to skew note-grade unless the far side is large.
- **Non-specializable.** If it is a special case of something known over ℝ/ℂ or generically, it is a
  corollary. Source 1 is the check, decidable by argument.
- **Survives the factoring check** (kill step 2). A question that factors through a coarsening B
  studies is answered elsewhere under another name.
- **The mechanism deforms.** Answerable only at q=11 by exhaustion is a curiosity; a mechanism with a
  parameter is a program.

## Failure modes

| Failure                      | Guard                                                          |
|------------------------------|----------------------------------------------------------------|
| Confabulated absence         | evidence ladder; absence claims carry their level              |
| **Known-under-another-name** | factoring check (step 2); answer-keyed search (step 7)         |
| **Degenerate kill**          | kill at the smallest *non-degenerate* instance only            |
| **Dark seam**                | OA/ILL status before promotion; thin-and-dark is worst         |
| **Unfalsifiable cause**      | one out-of-sample prediction per named cause                   |
| Void mistaken for a gap      | name the cause; blindness vs judgment; neighbourhood precedent |
| Tried-and-failed-silently    | unprinted by construction; a thin seam can be a graveyard      |
| Dictionary chosen by analogy | rule 5 — earned or composed only, composite image checked      |
| Unstatable null              | rule 3 — drop the cell                                         |
| Coincidence of small numbers | rule 4 — neighbouring parameter, always                        |
| Seam emptiness read as proof | it is a prior; the leaf read is still mandatory                |
| Tier read as cell trust      | validity is not virginity                                      |
| Fluent self-review           | provisional until a stronger reasoning model vets it           |

## Trust boundary

The instrument for absence is a language model, which will produce a fluent and plausible literature
if permitted. This is the same hazard the lane fences on the computational side — *no numerical claim
may depend only on a session scratchpad* — and it binds harder here, because a confabulated absence
is indistinguishable from a real one at the point of use.

**Everything this mine produces is provisional until vetted by a stronger reasoning model.** Not only
the literature claims — the *reasoning over them* too: a named cause, a promotion score, a cell
verdict, a ledger row, a claimed mechanism. None is load-bearing until a stronger reasoning model
(Fable, or 5.6 Sol) has passed over it. Route the vet through this lane's own docs, per the
containment rule in the handoff.

The rule is earned rather than precautionary, and this doc is the evidence. Its first draft was
written with apparent care and its central claim was wrong; the Fable pass overturned it. The
revision was then written to fix exactly that, and a coverage review found it had introduced a
*circular* instrument-calibration gate resting on a misreport of an in-repo record — a gate that
could not fail, inside the doc about not confabulating. Both errors read as fluent and plausible at
the point of writing. Fluency is not evidence here, and self-review does not catch this class:
independent, stronger passes do.

**The ladder prices negatives only.** Absence support is what needs grading; a search *positive* is
not on the ladder at all — it is an immediate cheap kill.

- **L0** — believed. Worthless; this is what the model emits for free.
- **L1** — search sweep, no hits. Near-worthless as absence support: for an un-named question the null
  result arrives identically whether the gap is real or imaginary.
- **L2** — citation closure enumerated, titles and abstracts screened.
- **L3** — the survey or handbook section that *would have to contain it* was read, and does not.
- **L4** — the near-miss papers read in full, swerve point identified and named.

**Only L3/L4 support a novelty claim.** A structural-cause argument's *mathematical* premise is
exempt; its *corpus* premise is not, and must be stated as a refutable structural argument rather than
a report of not having found something. This pairs with the unread ledger in
[consolidated literature report](2026-07-14-literature-sweep-consolidated.md) — an absence conditioned
on an unopened source is an open gate, not a result.

**The near-miss cluster is retrospective.** A swerve is visible only relative to a formulated
question, and the exemplar near-misses were identified after the hit existed. Prospectively, seam
thinness is measurable and swerves are not: the cluster is a post-formulation confirmation and a
gate-bounder, never a mining signal.

## Ledger of mined cells

Closed cells are lane assets, exactly as C178 is: recording that a question was transported and the
answer is boring prevents re-mining it. Every cell entered here, whatever the verdict.

**This method declares its own null: cause classes are uncorrelated with yield.** The schema exists to
let a batch of cells refute that. A ledger that records only verdicts cannot distinguish "the ordering
works" from "we believed the ordering", and the ordering generalizes from a single hit until it does.

Backfilled 2026-07-15 by [C191](2026-07-15-c191-gap-mining-backfill.md), which holds the full scoring
and the reasoning per cell. Rows below are the summary.

| Cell `(O, D, q)`                        | Cause class | Cause as named          | Value        | Kill stage    | Gate cost      | Verdict          | Evidence     |
|-----------------------------------------|-------------|-------------------------|--------------|---------------|----------------|------------------|--------------|
| Clebsch hexagon / arcs↔MDS / deep holes | structural  | fame asymmetry (s4)     | pass         | survived      | six sweeps     | HIT              | L3/L4, gated |
| conic 6-subsets / design / hexads?      | structural  | well-posedness (s1)+ s4 | partial      | survived      | six sweeps     | HIT, bridge-grade| L3/L4        |
| mixed arc-cliques / internal / ω_arc    | structural  | definitional keying (s2)| **fail**     | n/a           | none           | novel, worthless | L2/L3        |
| Wu conics / internal / passant six-set  | n/a         | n/a — object probe      | pass         | step 6        | none           | closed negative  | n/a          |
| conic 8-subsets q=23 / design / octads? | n/a         | statement, not mechanism| fail         | step 6+rule 4 | none           | dead             | n/a          |

**The backfill is an in-sample fit, not a validation.** These cells shaped the method, so passing was
close to guaranteed and carries little evidential weight. Its power was falsification — a mis-rank
here would have killed the method — and the ordering survived it. Survived, not validated. **The
declared null remains untested**; no retrospective batch can move it. The first genuine datum is C177,
scored before it is run. Do not add retrospective cells: they inflate confidence without testing
anything.

## First steps

1. **Backfill — DONE**, [C191](2026-07-15-c191-gap-mining-backfill.md). The method survives its own
   history: the revision promotes the founding hit and ranks the known-worthless cell last, while the
   first draft assigned the Clebsch cell tier 1 by cause and tier 4 by seam *simultaneously*. Read
   C191's verdict section before relying on that: it is an in-sample fit and its power was
   falsification only.
2. **Calibrate the instrument, non-circularly.** Diff Edge 1956's citers from MathSciNet or zbMATH
   against the OpenAlex closure — a mid-century seed, by a route that does not pass through the
   instrument under test. Do **not** use the vet's BSW 1992 list: it is an OpenAlex query itself, and
   1992 is the wrong regime for the risk. Until the diff exists, no ordering claim rests on
   object-level emptiness.
3. **First live cell: C177**, already queued. A transport triple with a computable verdict
   (design-theoretic question, geometric object, glue-or-not answer). Running it through the full kill
   order makes it the ledger's first prospective datum at near-zero marginal cost.
4. **First new dictionary: conic-hexads → S(5,6,12) → ternary Golay / M₁₂.** Leg 1 is earned (C147).
   Leg 2 is believed documented inside design theory and coding **[L0 — model memory; this is
   precisely what the leg-2 read must establish, and it carries no weight until it does]**. The fame
   asymmetry runs the required way and is in the sweep record [in-repo L3, hexad sweep]: Curtis's
   kitten, Conway–Sloane, and Bailey use the same P¹(F₁₁) point set and never embed it as a conic. The
   transpose cell — geometry's question list (chord concurrency, polarity, t(H), secant structure)
   pulled onto the Golay code's standard objects (cosets, weight classes, the two systems) — has a
   computable smallest instance sitting on C147's promoted scripts, and the leg-2 read is the bounded
   gate. **Gate accessibility is unmeasured**: run the object-level call for OA status before promoting
   this cell — asserting the seam papers are obtainable without ILL is the one quantity that made the
   covering fact stuck, and it has not been queried here. Run the factoring check first: much of the
   hexad structure factors through the 6-subsets of P¹(F₁₁), which is exactly where this lane has been
   scooped before.

The first pass (backfill + calibration + C177) is task-shaped and takes a C-ID at allocation, pegged
`gem-mining`. This doc stays infrastructure.

## Overturned claims

Recorded because this doc's first version was committed with them, and each is the kind of error that
grows back. Do not slip back to:

- **"Structural causes are pre-paid by argument."** They are discounted. Both exemplars bought their
  corpus premises with sweep reading. Exempt the deduction, never the premises.
- **"The durable novelty claims are the structural ones; the stuck ones are the read ones."** The
  headline of the first draft, and false: both durable exemplars were paid for by reading. What
  structure buys is a *bounded* bill, not no bill.
- **"A question posed in our own vocabulary is askable by the community, hence explored."** False for
  vocabulary that is ours and days old. Rule 2 is now scoped to classical vocabulary, and the internal
  detectors are admitted on that ground.
- **"Lead with arXiv category cross-listing."** Measured anti-correlated at cell level: the region
  containing the founding hit reads "dense — skip". Object-level closure resolves the same cell
  correctly at the same cost.
- **"A real gap is unsearchable, so gap mining is not a searching exercise."** True for generic
  un-asked questions, false for transport triples — which are the only candidates this method
  produces, and which arrive with the far side's vocabulary attached. Search is a first-class kill
  step.
- **"A thin seam beats an empty one."** Only when the seam is *obtainable*. Thin-and-dark is the worst
  cell on the board; the covering fact is the proof.
- **"One-hop dictionaries get walked because someone knows both fields."** Arcs ↔ MDS is one hop,
  famous, and went unwalked for seventy years. The mechanism is vocabulary opacity, not hop count.
- **"A survey's connections section is the enumeration of B's outgoing dictionaries."** It is a
  curated highlight reel — a generator and a lower bound.
- **"The spine reduces to one question: can you name why it is empty?"** Cause-nameability and seam
  thickness are orthogonal axes that cross freely, and value is a promotion factor rather than a
  post-filter. The evidence ladder is untouched by this and is still relied on throughout.
