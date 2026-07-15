# Gap mining — a method for searching theory gaps instead of objects

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-15
**Status**: method only — no cells mined against it yet.

**Terminology.** A *theory gap* here is an un-asked question — a region of question-space nobody has
entered. It has nothing to do with the **gap theorem** of C165/C171, which is a statement about
conic gaps. Do not let the word merge.

The generator in [gem mining](handoffs/2026-07-14-gem-mining.md) § The method mines **objects**: fix
a question, census a domain, evaluate an invariant valued in another classified category, look for
the anomaly. This doc is its analogue for mining **questions** — the un-asked ones whose opening
would be worth a major journal.

## The bottleneck this inverts

Novelty gating is this lane's slowest step, and it is a *back*-loaded cost: find the object, then pay
an unbounded reading bill to learn whether it was Edge's all along. C155 is drafted and blocked on
C156/C157/C169. The covering fact is still conditioned on two ILL-only BSW originals after six
independent sweeps.

The fix is **move ordering**, not exhaustion. A game-tree search does not avoid leaf evaluation; it
spends its budget on lines a cheap static eval promoted. Here the expensive leaf is the L3/L4 read
plus the mathematics; the static eval is a region's *cause of emptiness*, which is cheap, structural,
and computed once per region rather than once per question.

The lane has already validated this by accident. Two of its most durable novelty claims did not come
from sweeping:

- **The well-posedness inversion.** Over ℝ/ℚ, no-accidental-concurrency is generic
  (Halbeisen–Hungerbühler); over F₁₁ it inverts and the exceptions are exactly the Mathieu hexads.
  The question is not well-posed over an infinite field, so no classical corpus *can* contain it.
- **The definitional blind spot.** The exterior-set literature is keyed to external points
  throughout, so it structurally cannot see the all-internal q = 3, 5, 19 configurations.

Neither is search-negative. Both are proofs of absence obtained by argument, and both are closed.
The covering fact, by contrast, was established by reading and is still hanging on an unread source.
**The durable novelty claims are the structural ones; the stuck ones are the read ones.** This method
makes that deliberate instead of lucky.

## What is mined

The unit is a **transport triple** `(O, D, q)`: an object `O` this lane owns, a dictionary `D`
carrying `O` into another vocabulary, and a question `q` that is standard on the far side. The
pullback `q(D(O))` is a question about `O` that our own vocabulary cannot state.

**The dictionary is the scarce resource, not the question.** A question cannot be transported to an
object — only along a dictionary that maps that object. This is what stops the domain from exploding
to `vocabularies × objects × questions`, nearly all of which is nonsense. The real domain is
`(dictionaries we have earned) × (their far-side question lists)`: small enough to exhaust, large
enough to matter.

Dictionaries come in three tiers, and the tier fixes how much trust the cell inherits:

| Tier | Source | Rigor | Use |
|---------|-------------------------------------------------|-----------------------------------|--------------------|
| earned  | read off our own invariants' target categories  | forced by our own results         | safe, same neighbourhood |
| composed| `A→B` earned, `B→C` documented inside B          | both legs citable                 | **primary mine** |
| free    | universal machines that accept any object       | none — the dictionary is automatic| needs the void test |

**Earned** dictionaries are not chosen; they are read off results we already have. Stabilizer A₅ and
PGL₂(11) name group theory; deep-hole locus = a conic names algebraic geometry; hexads name design
theory and the sporadic groups; arcs name MDS codes.

**Composed** is where the yield is. If `A→B` is earned and `B→C` is documented inside B's own
community, then `A→C` is real by composition and essentially nobody has walked it. The mechanism is
social: one-hop dictionaries eventually get walked because someone knows both fields, but two-hop
composites do not, because **no one person knows all three vocabularies**. Rigor survives because
each leg is separately citable — we compose documented connections rather than propose a new one.
The census is available too: **B's own survey has a connections/applications section, and that
section is the enumeration of B's outgoing dictionaries.**

**Free** machines — matroids, association schemes, complexity, model theory, tropical, homology —
accept any object, so the dictionary costs nothing. That is the warning: "nobody pointed a matroid at
this" is usually because the answer is boring. These survive only on the void test below.

## The spine: name the cause of the emptiness

Every candidate region reduces to one question: **can you name why it is empty?** The answer *is* the
move ordering.

| Tier | Region      | Cause of emptiness                            | Novelty gate                    | Priority |
|------|-------------|-----------------------------------------------|---------------------------------|----------|
| 1    | forced-empty| structural — the corpus *cannot* contain it   | pre-paid by argument            | mine first |
| 2    | thin seam   | social — people crossed and swerved           | bounded: read the seam papers   | mine next  |
| 3    | empty seam  | none nameable                                 | unbounded, and probably a void  | defer      |
| 4    | dense seam  | not empty                                     | this is the current bottleneck  | skip       |

Two consequences worth stating plainly, because both are counterintuitive:

**A thin seam beats an empty one.** An empty seam is ambiguous — nobody crossed because there is
nothing there, or because they couldn't see it, and the two look identical. A thin seam carries its
own proof of interest: people *did* cross, and swerved. Those few papers are simultaneously the
novelty gate (bounded, and identified in advance) and the near-miss cluster that shows the gap is
real. Edge had the six points, the conic, and Brianchon and never asked the on-conic question;
Halbeisen–Hungerbühler asked the exact question over the wrong field; Van de Voorde reached stopping
sets but not MDS. Three near-misses, one nameable swerve each.

**Absence is invisible to search and visible in structure.** A genuine gap is a question with no name
in the target vocabulary, so keyword search returns nothing whether the gap is real or imaginary —
the null result is confirmatory noise, not evidence. Absence only shows up where it is *printed*: the
handbook chapter with no such section, the classification with no such row, the definition list where
the case is not. **Gap mining is a reading exercise over authoritative structure, not a searching
exercise.**

## Generating tier 1 — the sources of forced emptiness

Each source is a proof-shaped absence argument with its own census. This is the top of the move
ordering because the novelty gate is paid by an argument, and arguments are cheap and durable.

1. **Field or characteristic inversion.** The phenomenon exists only in finite characteristic, or the
   generic/measure-zero relation inverts against the classical regime. Census: the genericity and
   char-0 hypotheses of the classical theorems. This is the Halbeisen–Hungerbühler template.
2. **Definitional keying.** Every field's definitions make a symmetry-breaking choice — external vs
   internal, ordered vs unordered, one class of a dichotomy, a normalization. The unchosen side is
   forced-empty unless a symmetry exchanges the cases. Census: the definitions and the WLOGs of the
   seed papers. This is the mixed internal/external template.
3. **Ambient mismatch.** Results about the object in a different ambient space cannot be about ours.
   Census: the object's known incarnations. Havlicek/Coxeter/Pellegrino's 12-cap in PG(5,3) is this.
4. **Fame asymmetry.** `O` is classical in A, `q` is standard in B, `D` is documented, and **`O` has
   no name in B**. B's corpus cannot contain `q(D(O))` — not because they tried and failed, but
   because `O` is not in their object list. Census: B's object taxonomy, i.e. its survey's definition
   list. This is why the Clebsch hit was available at one hop: coding theorists do compute covering
   radius, but for *their* objects, and Edge's hexagon was never one.
5. **Parameter regime.** The object lives outside the range anyone computed or cared about. Weakest
   source — verify against printed ranges, since the range is often wider than assumed (Van de
   Voorde's q < 131).
6. **The corpus predates the compute.** A census-derived fact cannot be in Clebsch 1871 or Edge 1956.
   This prunes only the pre-computational half — and note that our actual live gate is BSW 1991/92,
   the post-computational half. Use this to stop over-fearing the classical corpus, never to skip the
   modern one.

## Seam measurement — the cheap static eval

For tiers 2–4, the ordering signal is whether two literatures touch at all. This is a citation-graph
measurement, not a semantic read, and it defeats the unsearchability problem: **we cannot search for
a nameless question, but we can measure that two named literatures do not cite each other.** Look at
the seam, not at the thing.

Instruments, cheapest first: arXiv cross-listing counts between category pairs (a paper cross-listed
math.CO + cs.IT *is* a seam edge); OpenAlex or Semantic Scholar citation-graph queries; MSC
co-occurrence in zbMATH/MathSciNet; the citation closure of a seed paper, forward and backward.

**What this proves: nothing.** It is a static eval and it is allowed to be wrong. Its known failure
mode is parallel discovery without citation — two communities solving the same problem under
different names and never meeting, which is precisely what Edge/BSW did *within* one field. Seam
emptiness is a prior, never a novelty claim. Move ordering does not need to be sound, only
correlated; the leaf evaluation still happens before any claim. What changes is that we read a
handful of promoted papers instead of sweeping a field, and we read them at the *end* of a promoted
line rather than at the start of every line.

## The rules

Analogues of the four rules in the [gem mining](handoffs/2026-07-14-gem-mining.md) handoff, plus one
with no analogue.

1. **Census = the literature's own structure, never a search result.** The test survives verbatim:
   *what does a miss buy?* A missing section in a handbook's classification is a fact. A null result
   from a search engine is noise. Enumerable structures: handbook and survey tables of contents, the
   MSC tree, citation closures, a community's definition list, a survey's connections section.
2. **The question must arrive through a dictionary.** A question posed in our own vocabulary is a
   conjecture — already asked, or askable by the community, hence explored. Only imported questions
   are structurally invisible. Operational predicate: **fame asymmetry** (source 4 above). If `O` is
   famous on both sides, the cell is probably already filled.
3. **Declare the null before investigating.** State the boring answer and why it would be boring. If
   you cannot state it, you do not understand the question well enough to ask it — drop the cell.
   This kills the most, costs nothing, and therefore goes first.
4. **Upgrade protocol on a candidate, immediately.** Smallest computable instance; the *neighbouring
   parameter*, because coincidence-of-small-numbers is the default hypothesis (the q=23 octad lesson:
   the mechanism needed |H| = 2×3 so that a concurrent triple is a *perfect* matching); name the
   mechanism; name who is forced to care.
5. **Dictionaries are earned or composed, never chosen by taste.** Object mining gets its domain for
   free — PG(2,q) is given. Question mining *chooses* its domain, and the choice is the method, so it
   is the failure point. Earned = read off our own invariants. Composed = two citable legs. Anything
   else is analogy, and analogy is how this degenerates into a brainstorm.

## Kill order — compute to kill, read to claim

Order by cost. This lane inverts the usual order, because at q=11 a computation is minutes while a
survey section is an hour plus ILL risk.

1. **Statable null** — free. Kills the meaningless.
2. **Naturality on the far side** — free. Is `q` load-bearing in B's own survey, or did we invent it?
3. **Void test** — free. Can the emptiness be named (tier 1 or 2)? For a free/universal machine: has
   it ever paid off on an object adjacent to ours? If never anywhere nearby, it is a void.
4. **Smallest-instance computation** — minutes to hours. A cheap *negative* filter.
5. **The literature** — expensive, L3/L4 only, and only for survivors.

Computation can never establish novelty, so the reading gate stays mandatory before any claim; it
just moves from per-candidate to per-promoted-line. **Compute to kill, read to claim.**

## Value belongs in the detector

Novelty is free and worthless on its own — there are unlimited un-asked questions and almost all of
them change nobody's belief. The value predicates run inside the detector, not after it:

- **Does answering it re-key an existing corpus?** This is the A+ signature — not difficulty, not
  novelty. The Clebsch hit's worth is that *Edge 1956 becomes a coding theorem*. An isolated new fact
  is a note; a reinterpretation of a classical body of work is a paper.
- **Forced dual audience.** Both communities must update. Cross-vocabulary transport gives this by
  construction; a question only one community cares about is a specialty note.
- **Non-specializable.** If it is a special case of something known over ℝ/ℂ or generically, it is a
  corollary. Source 1 is the check, and it is decidable by argument.
- **The mechanism deforms.** Answerable only at q=11 by exhaustion is a curiosity; a mechanism with a
  parameter is a program.

## Failure modes

| Failure                                   | Guard                                              |
|-------------------------------------------|----------------------------------------------------|
| Confabulated absence                      | evidence ladder below; absence claims carry their level |
| Void mistaken for a gap                   | name the cause of emptiness; near-miss cluster; neighbourhood precedent |
| Dictionary chosen by analogy              | rule 5 — earned or composed only                   |
| Unstatable null                           | rule 3 — drop the cell                             |
| Coincidence of small numbers              | rule 4 — neighbouring parameter, always            |
| Seam emptiness read as proof              | it is a prior; the leaf read is still mandatory    |
| Search-negative read as evidence          | a real gap is unsearchable; only structure shows absence |

## Trust boundary

The instrument for absence is a language model, which will produce a fluent and plausible literature
if permitted. This is the same hazard the lane already fences on the computational side — *no
numerical claim may depend only on a session scratchpad* — and it binds harder here, because a
confabulated absence is indistinguishable from a real one at the point of use.

Every absence claim carries its level:

- **L0** — believed. Worthless; this is what the model emits for free.
- **L1** — search sweep, no hits. Near-worthless: a real gap is unsearchable, so the null result
  arrives identically in both worlds.
- **L2** — citation closure enumerated, titles and abstracts screened.
- **L3** — the survey or handbook section that *would have to contain it* was read, and does not.
- **L4** — the near-miss papers read in full, swerve point identified and named.

**Only L3/L4 support a novelty claim.** Tier-1 forced-empty arguments are exempt from the ladder but
not from scrutiny: they must be stated as a structural argument that a reader could refute, not as a
report of not having found something. This pairs with the unread ledger in
[consolidated literature report](2026-07-14-literature-sweep-consolidated.md) — an absence
conditioned on an unopened source is an open gate, not a result.

## Ledger of mined cells

Closed cells are lane assets, exactly as C178 is: recording that a question was transported and the
answer is boring prevents re-mining it, and the record is cheap. Every cell entered here, whatever
the verdict.

| Cell `(O, D, q)` | Tier | Null | Verdict | Evidence level |
|------------------|------|------|---------|----------------|
| *(none yet)*     |      |      |         |                |
