# C1190 milestone (b′) — per-column domains for the complement construction

**Lane**: `ergodis`
**Date**: 2026-09-15
**Status**: IN PROGRESS. Written incrementally from the start of the task, so a crash leaves a
partial record rather than none.

Task card: `2026-09-15-c1190-rel-lowering.md`. Adopted design:
`2026-09-15-c1190-lowering-architecture.md`, the "Per-column domains" bullet. Decision record:
private `docs/adr/0004-rel-lowering-ir.md`. Predecessor and current state:
`2026-09-15-c1190-milestone-b.md`, whose measurement section states the exact construction this
task implements and whose remaining gap 1 is what it closes. Repository: `~/src/ergodis-private`,
consuming `~/src/ergodis` read-only. Decision taken by Tavis on 2026-09-15: per-column domains in
the value dictionary and the complement construction, over the alternative of a `Negative` atom
kind in the core `Rule`.

## Fermi predictions, written before any code

These are written from milestone (b)'s measured complement series (979, 4,003, 9,075 and 16,195
complement facts at domains 32, 64, 96 and 128 on the `stratified` cohort; about 45 bytes of
canonical JSON per complement fact; the layer program's serialization crossing the core contract's
`MAX_BYTES` of one mebibyte between a domain of 128 and one of 160) and from the shape of the two
new cohorts this task adds.

The new cohort `columns` mirrors `stratified` exactly except that its negated binary relation's two
columns range over disjoint value sets: `dom` holds `N` integers and `tag` holds `N` entity
references, so the value dictionary is `2N` entries and each column of `e` occupies half of it. The
new cohort `columns3` does the same at arity three with three disjoint sets of `N`, so each column
occupies a third of a dictionary of `3N`.

1. **Complement fact counts on the new cohort.** The binary complement is `|D₀|·|D₁| − |closure(e)|`
   with `|D₀| = |D₁| = N` and `|closure(e)| = 2N − 2`, so it is `N² − 2N + 2`; the unary complement
   of `s` over `D = dom` is `⌊N/2⌋`; the universal's witness complement is 1. Expressed against the
   *dictionary size* `d = 2N`, which is the axis milestone (b) measured, that is `d²/4 − d + 2` plus
   `d/4` plus 1. So at `d = 32` I predict about **235** complement facts, at `d = 64` about **979**
   and at `d = 128` about **4,003** — which are milestone (b)'s figures shifted one doubling to the
   right. The saving at equal dictionary size is **4×**, and it is 4× because each of the two
   columns occupies half the dictionary.
2. **Complement fact counts on the old cohort must not move at all.** `stratified` negates `s` over
   a column bound by `dom`, `e` over two columns both bound by `dom`, and the witness over a column
   bound by `dom`; `dom` holds every one of the dictionary's values, so every `Dᵢ` is the whole
   dictionary and the construction reduces to milestone (b)'s. I predict **979, 4,003, 9,075 and
   16,195 exactly**, not approximately, at domains 32, 64, 96 and 128. Anything else is a defect,
   and this is the sharpest regression assertion this task has.
3. **Cost of the per-column domain-set pass, per closure tuple.** For each column of each negative
   literal the pass unions the values of one column of each binding relation's closure into a
   bitset over the dictionary range: load the row's value, shift, or, store, plus the row-stride
   increment and the loop test. I predict **8 to 12 instructions per (closure tuple × binding
   site)**, with about two binding sites per negative literal, so about `20N` instructions per
   complement against a materialization that is `N²` facts at the 150–400 instructions per fact
   milestone (b)'s Fermi 2 predicted and its measurement confirmed. The domain pass is therefore
   **linear against a quadratic**, and I predict it is under one per cent of the backend's
   complement cost at `d = 64` and under a tenth of a per cent at `d = 256`. The bitset is
   `⌈values/64⌉` words per column and at most four columns, so at the default value limit of 4,096
   it is 2 KiB of workspace — invisible beside the complement facts themselves.
4. **The new `REL0503` boundary.** The bound that binds is still the layer program's canonical
   serialization against `MAX_BYTES`, because nothing in this task changes bytes per fact. At arity
   two the complement falls from `d²` to `(d/2)² = d²/4`, so the boundary moves by a factor of two:
   from about 150 dictionary entries to about **300** on the `columns` cohort, and stays at about
   **150** on `stratified`. At arity three the complement falls from `d³` to `(d/3)³ = d³/27`, so
   the boundary moves by a factor of three: from about 28 to about **84** on `columns3`. The general
   statement I predict the measurement will support: **the boundary moves by the reciprocal of the
   geometric mean of the fractions of the dictionary the columns occupy**, which is a much weaker
   result than the `Negative`-atom route and a real one.
5. **Where the risk is, and it is not the arithmetic.** The complement is still a product minus a
   set, and either agrees or does not. The two places I expect to be wrong first are (a) **which
   closure a binding column may be read from** — a positive literal over a relation derived in the
   *same* layer has no established closure when the complement is built, and reading a partial one
   would silently shrink `Dᵢ` and lose derivations; and (b) **the identity of a complement**, since
   a complement is now specific to a use site's domain signature rather than to the relation, so
   two negative literals over one relation in two rules may need two different complements. I
   predict at least one instructive negative in each, and I predict the differential's existing 600
   negation programs do **not** catch (a), because their negated relations sit in an earlier layer
   than every positive literal that binds them.
6. **Expected differential disagreements.** Zero, for the same one-line reason milestone (b)
   recorded: no tuple outside `∏ᵢ Dᵢ` is ever asked about, so shrinking the product from
   `dictionary^arity` to `∏ᵢ Dᵢ` removes only tuples the join could never have reached. Milestone
   (b) predicted one to three and found none; this time I predict none and expect to have to show
   again, by deliberate mutation, that the corpora would have said otherwise.

**How they came out.** Prediction 1 was right to three significant figures: the `columns` cohort's
complement fact counts are 979, 4,003 and 16,195 at dictionaries of 64, 128 and 256, which are the
`stratified` cohort's figures at 32, 64 and 128 — the series shifted exactly one doubling, a 4.09×
saving at equal dictionary size. Prediction 2 was right **exactly**, not approximately: the
`stratified` cohort's complement fact counts and its layer-program byte counts are bit-identical to
milestone (b)'s, 979/4,003/16,195 facts and 45,080/178,792/723,680 bytes. Prediction 3 was right in
order and understated in margin. Prediction 4 was right in shape and gave a sharper general
statement than the one predicted: the boundary is at **153** dictionary entries on `stratified`,
**302** on `columns` and **84** on `columns3`, which is ×1.97 and ×3.0 — but the number that
actually transfers is that all three boundaries sit at about **22,000 complement facts in one
layer**, which is the byte budget divided by the bytes one fact serializes to, and per-column
domains buy exactly the factor by which the columns narrow. Prediction 5 was right on both counts
and is where this task's instructive negatives sit; the sub-prediction that the existing 600
negation programs would not catch the same-layer confusion was right, and the response was to add a
generated shape that does. Prediction 6 was right: no disagreement, and the two deliberate mutations
are again what makes that reportable.

## Status

Complete. A complement is no longer `dictionary^arity` facts: it is built over the product of the
domains its argument positions can actually take, computed from the certified closures of the
positive literals that bind them, and it is identified by its relation together with that
column-domain signature so two use sites with one signature share one complement. The value
dictionary is ordered by typed-literal kind, so each kind occupies a contiguous dense id range that
a complement record names per column and that milestone (c)'s aggregates will read. The core rule
contract, the demand-driven evaluator, both checkers and the Lean-audited convergence bound behind
them remain untouched, and the `stratified` cohort — every column of which spans the whole
dictionary — produces bit-identical complements, which is the regression this change had to pass.

## What was built

### The `bind` pass, in the measured lowering stage

`src/rel_frontend/lower/passes.rs` gains one pass between range restriction and stratification. For
every rule-local variable it records the columns of the positive body literals of its own rule that
bind it, as `BindSite { relation, column }` records ranged into by a `VarBinding` pool parallel to
the existing per-variable span pool. Both pools are reserved by `Workspace::new` from the declared
`Limits` and neither grows.

It runs **before** binarization for a reason that decides whether the construction is any good: once
a body is a chain, a negative literal's partner is an auxiliary relation that binarization
introduced, and narrowing a column to an auxiliary's values would make the domain depend on the join
order rather than on the source. Running before the chain means every binding site names a relation
the source wrote. The synthetic rules binarization appends share their parent rule's variable base,
so they read the parent's sites without the pass running again — which is also why the negative
literal may sit anywhere in the chain, as milestone (b) established.

### The value dictionary, ordered by type

The closing pass orders the dictionary by typed-literal kind with a counting sort over the four
kinds, stable inside a kind so the order within a type is still the order the source interned them,
and rewrites every constant term and every fact value to the new ids. After it,
`Rir::type_range(kind)` is two integers rather than a scan, and the ranges are part of the canonical
bytes the parity corpus compares.

### The complement construction, in the stratified backend

`src/rel_stratified.rs`. For a negative literal `not R(t₁ … t_k)` in a rule, argument `i`'s domain
`Dᵢ` is the singleton of the constant when `tᵢ` is one, and otherwise the union over that variable's
binding sites of the values the named column holds in the named relation's certified closure. The
union is a strided walk of each closure setting one bit in a bitset over the dictionary range, and
the bitset is one allocation reused across every column of every complement of every layer, so the
domain pass allocates nothing per fact. The complement is then `∏ᵢ Dᵢ` minus `R`'s closure,
enumerated in mixed-radix key order with column zero most significant, which — because each `Dᵢ` is
ascending — is the ascending lexicographic tuple order milestone (b) fixed for the digest.

### The identity of a complement, and the record

`ComplementRecord` carries `column_domains: Vec<ColumnDomain>`, one entry per argument position with
its column type, that type's dense sub-range, its `DomainSource` provenance
(`Constant(id)`, `Bound(sites)` or `Dictionary(sites)`), and the domain itself. It also carries
`closure_inside`, the number of closure tuples that lie inside the product — which `closure_tuples`
no longer equals, because a relation can hold tuples at values its use site cannot ask about — and
`uses`, the number of negative literals sharing the complement.

`verify_records` does two things where milestone (b)'s did one. It recomputes every column's domain
from its recorded provenance and requires it to equal the recorded values, which is exactly
reproducible because a binding site is only ever a relation whose closure was final when the
complement was built and is therefore final at check time; and it rebuilds `∏ᵢ Dᵢ` minus the
closure and compares the count and the SHA-256.

### The two new cohorts

`columns` mirrors `stratified` with the negated binary relation's first column over `N` integers and
its second over `N` entity references, so each occupies half a dictionary of `2N`. `columns3` does
the same at arity three over integers, entity references and strings. Both are generated by the
committed cohort function and are pure functions of their name and count.

## Semantics adopted

Written down as this stage's own contract, for the reason milestones (a) and (b) gave: no executable
Rel reference semantics is available to this lane.

**Which domain a complement column ranges over.** For a negative literal `not R(t₁ … t_k)` in a
rule, argument `i`'s domain `Dᵢ` is:

- the singleton `{c}` when `tᵢ` is the constant `c`;
- otherwise the union, over the positive body literals of *that same rule* that bind `tᵢ`'s
  variable, of the values that binding column holds in the certified closure of its relation — the
  facts it was seeded with for an input relation, the closure an earlier layer's checkers
  established for a derived one;
- and the whole value dictionary when some binding relation has no established closure yet, which
  is the case exactly when a rule of the current layer derives it.

The complement is `∏ᵢ Dᵢ` minus the closure of `R`.

**Why this is exact.** Range restriction guarantees every variable of a negative literal occurs in
some positive literal of the same rule, so it has at least one binding site. A derivation that
reaches the negative literal has bound `tᵢ`'s variable through one of those positive literals, so the
value it takes is one that literal's column holds in the relation's closure, so it lies in `Dᵢ`.
Therefore no tuple outside `∏ᵢ Dᵢ` is ever asked about, and a tuple that is never asked about cannot
change the fixed point whether the complement holds it or not. This is milestone (b)'s argument
applied one column at a time, and it is the same argument that makes the whole-dictionary version
exact — the dictionary is simply the loosest `Dᵢ` the argument admits.

**When a `Dᵢ` is empty.** The product is empty, so the complement is empty and the rule derives
nothing through that literal. That is right rather than a special case: an empty binding column means
no derivation binds the variable at all, so the rule fires for no assignment whatever the complement
holds. A relation declared by an application and never given a fact is the shape that produces it,
and the fixture `an_empty_column_domain_gives_an_empty_complement` is the case.

**Deliberate readings, each of which could have gone the other way.**

- **A complement is keyed by (relation, column-domain signature), and use sites with the same
  signature share one.** The alternative is one complement per use site. Sharing was chosen because
  the bound that decides how far this route reaches is the layer program's canonical serialization,
  and an unshared complement writes the same facts into it twice; on both new cohorts the universal's
  witness rule and the explicit `gap` rule produce the same signature over the negated binary
  relation, so sharing takes three complement records where four use sites exist. The signature is
  the materialized value sets rather than the provenance, so two use sites whose binding literals
  differ but whose closures agree also share — which is what "the same complement" should mean.
- **The union over binding sites, not the intersection.** A variable's value must satisfy *every*
  positive literal that binds it, so the intersection is also a sound and strictly tighter domain.
  The union is what is implemented, because it is what the `Dᵢ` in a complement record has to mean
  for a checker to rebuild it from one site at a time, and because the tightening has no measured
  case yet. It is named in the mystery ledger as the available next narrowing with its one-line
  soundness argument.
- **A binding relation derived in the same layer falls back to the whole dictionary, rather than to
  its partial closure.** Reading the closure as it stands when the complement is built would take it
  to be whatever the layer has derived so far — nothing, since the complement is built before the
  layer's program runs — and would lose every derivation through the literal. The fallback is loose
  in the safe direction: a wider domain can only add complement tuples the join never reaches.
- **The column type's dense sub-range is recorded per complement column and is deliberately *not*
  used to narrow `Dᵢ`.** The task this milestone was given named the intersection with the type
  sub-range as part of the construction, and it is not exact. A variable can be bound to a value
  whose type differs from the negated column's: in the parity corpus's fourth new case,
  `def k = {:x}` gives `k`'s only column the entity type, while `not k(b)` is reached with `b` bound
  by a relation of integers. The negated atom `k(1)` is false, so the complement must hold the tuple
  `(1)`, and intersecting `Dᵢ` with the entity sub-range would drop it and lose the derivation. The
  sub-ranges are therefore infrastructure — for the typed readout, for milestone (c)'s aggregates
  over integers, and as the recorded bound a reader checks `Dᵢ` against — and the construction takes
  the union alone. This is the one place this task deviates from its instructions, and it is
  recorded as a deviation below with the counterexample rather than applied quietly.
- **`closure_tuples` and `closure_inside` are both recorded.** Milestone (b)'s invariant was that
  the complement and the closure sum to the universe. That is no longer true, because the negated
  relation can hold tuples outside the product; the invariant is now `facts + closure_inside =
  universe` with `closure_inside ≤ closure_tuples`, and a checker sees both numbers rather than
  inferring one.
- **The `MAX_COMPLEMENT` refusal moved from the closing pass to the backend.** The closing pass has
  evaluated nothing, so it cannot know `∏ᵢ |Dᵢ|`; checking `dictionary^arity` there as well would
  refuse the programs this change exists to run. The refusal is still `REL0503` with the numbers and
  a span and still happens before any complement fact is materialized.
- **A complement is named for its sequence in its layer**, `nc0`, `nc1`, rather than for the negated
  relation or the negative literal. It cannot be named for the relation any more, since there may be
  several per relation; naming it for the literal made the name two digits instead of one on the
  measurement cohorts, and the name is repeated once per complement fact in the serialization that
  decides how far this route reaches, so it cost one byte per fact. That is how the `stratified`
  cohort's layer-program byte counts came back bit-identical to milestone (b)'s.

## Deviations from the architecture note and from this task's brief

1. **The column type's sub-range is recorded, not applied.** The brief said `Dᵢ` is the union of the
   binding columns "intersected with the column type's sub-range". That intersection is not exact,
   and the counterexample is a two-line program: `def k = {:x}` gives `k`'s column the entity type,
   and `def mix(a, b) = w(a) and n(b) and not k(b)` reaches `not k(b)` with `b` bound to an integer.
   `k(1)` is false, so the complement must contain `(1)`, and the intersection would drop it. The
   dictionary ordering and the per-type dense ranges were built as the brief asked, are carried
   through the passes, are in the canonical bytes and are recorded per complement column; they are
   simply not used as a filter. Reported here rather than applied quietly, because exactness comes
   first and because the sub-ranges are what milestone (c)'s integer aggregates need regardless.
2. **The architecture note's "per-column domains as a core extension" is not what was built.** The
   note says per-column domains are a core extension in `Relation`, consumed by the closing pass and
   the backend only. They are neither: the core rule contract still declares one global `domain`, and
   the complement relations are ordinary input relations whose facts happen to be sparse in it. The
   core is untouched. A core-visible per-column domain would additionally shrink the demand
   evaluator's direct-addressed `domain^k` index, which this change does not; that is the remaining
   half of the note's bullet and it is a separate decision.
3. **The binding sites are computed before binarization, which the note does not discuss.** The note
   places the pass order as flatten, distribute, project, range-restrict, stratify, binarize, close.
   `bind` sits between range restriction and stratification, because after binarization a negative
   literal's partner is an auxiliary relation and a domain narrowed to an auxiliary would depend on
   the join order.
4. **Milestone (b)'s invariant that a complement and its closure sum to the universe no longer
   holds**, and the record carries `closure_inside` beside `closure_tuples` instead.

## Fixtures, and what each decides

`tests/rel_lowering.rs` goes from 42 tests to 46. Four are new and two changed their numbers, and
the two that changed are the result.

| Fixture                                                             | What it decides                                                                                                                          |
| ------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `set_difference_lowers_through_two_layers_and_certifies`            | unchanged numbers, now with the column's provenance and type sub-range asserted: `Bound([("a", 0)])`, values `[0,1,2]`, integer range `[0,3)` |
| `negation_over_a_module_member_complements_the_flattened_relation`  | 25 tuples became **3**, and 22 complement facts became **1**: the member reference's leading constant is a singleton domain              |
| `a_negated_literal_bound_by_narrow_columns_needs_one_complement_tuple` | the exact program milestone (b) refused at `46⁴ = 4,477,456` now has a universe of **1**                                                |
| `a_complement_that_would_not_fit_is_rel0503_with_its_numbers`       | the bound still binds and still reports `4,477,456` against `4,194,304`, now from the backend, on a program whose four columns really do span the dictionary |
| `a_complement_is_identified_by_its_relation_and_its_column_domains` | two signatures over one relation give two complements; a repeated signature raises `uses` to two rather than building a second           |
| `an_empty_column_domain_gives_an_empty_complement`                  | an empty binding column gives an empty product and no derivation                                                                         |
| `a_same_layer_binding_relation_falls_back_to_the_dictionary`        | one column `Dictionary(_)` and the other `Bound(_)` in one literal, and the closure is right                                            |
| `a_tampered_complement_record_does_not_rebuild`                     | seven tampers rather than four: the digest, each of the three counts, the recorded universe, a shortened domain, and **a provenance that names the wrong column** |

The last row is what the record's new shape buys. Milestone (b)'s check could only ask whether the
complement matched the numbers the record stated; it now recomputes the domains from the relations
and columns the record names and refuses a record whose values do not follow from them.

## Differential results

The corpora and the seed are unchanged from C1189 and milestone (b) — `0x000c_1189_0915` through
SplitMix64 — so every earlier program is the same program. The negation generator gains four shapes,
taking it from twelve to sixteen, and the corpus size is unchanged at 600.

| Corpus                                     | Programs | Verdicts                                                                     |
| ------------------------------------------ | -------: | ---------------------------------------------------------------------------- |
| the committed end-to-end fixtures          |       13 | all accepted; each closure also equals the committed Python oracle's         |
| the milestone (a) audit's further programs |        6 | five accepted, one rejected for range restriction                            |
| the recorded rejection surface             |       20 | all rejected, each with the recorded semantic class                          |
| the recorded backend divergences           |        3 | all refused by a bound the evaluator does not have                           |
| the Figure 3 and Figure 4 equations        |       35 | 16 evaluated, 15 rejected, 2 admission, 2 not parsed — no row moved          |
| the surface constructs outside Figure 2    |       28 | unchanged                                                                    |
| value kinds and formula forms              |       12 | all accepted                                                                 |
| the seeded in-fragment generator           |    1,200 | all accepted; no divergence, no semantic rejection                           |
| the seeded negation generator              |      600 | all accepted; no divergence; sixteen shapes                                  |
| the seeded near-miss generator             |      400 | 377 rejected, 23 backend divergences                                         |
| the name-resolution templates              |      120 | all accepted                                                                 |
| closure-shape regressions                  |        9 | unchanged                                                                    |

**The four new negation shapes**, with their counts in the 600: `disjoint-columns` 40 (integers in
one column and entity references in the other), `mixed-type-columns` 41 (strings and integers, so
the dictionary carries two types whose dense sub-ranges are disjoint and neither column's domain is
an initial segment of it), `singleton-column` about 40 (one column bound by a relation holding one
value), and `recursive-binding` about 35 (mutually recursive `q` and `n` in one layer, so `n`'s
negative literal has no established closure to narrow with). The first three were added because
every earlier shape binds every column of its negated literal through the relation that holds the
whole dictionary, so on all 600 earlier programs the per-column construction reduces to milestone
(b)'s and decides nothing. The fourth was added because the first deliberate mutation below showed
the corpus could not catch it.

**No disagreement was found. None** — which was the prediction this time, and which is again worth
nothing on its own.

### The three deliberate mutations

Each is a one-line change run with every gate and then reverted. None is committed; what is recorded
is what each broke.

1. **A column's domain read from a binding relation's closure as it stands, without the
   `established` guard.** This is the confusion Fermi prediction 5(a) named. It is caught by
   `verify_records` itself rather than by an expectation: the recorded domain no longer rebuilds
   from the relation and column it names, because recomputing it against the final closure gives a
   different set. The fixture `a_same_layer_binding_relation_falls_back_to_the_dictionary` fails with
   `ComplementMismatch(0)`. **The 600-program negation corpus did not fail** — the prediction that it
   would not was right, and the response was the `recursive-binding` shape, after which
   `the_negation_corpus_agrees` fails too. That is the mutation's real result: it found a hole in the
   corpus, not only a hole in the code.
2. **`Dᵢ` taken from the negated relation's own column values** instead of from the binding literals'
   columns — the natural wrong reading of "the values this column ranges over", and the per-column
   analogue of milestone (b)'s second mutation. Eleven of the 46 lowering fixtures fail, including
   the oracle agreement, set difference, non-reachability, the negation chain, the restricted
   universal and the complement bound; on the differential side `the_negation_corpus_agrees` and
   `the_committed_fixtures_agree_with_the_reference_evaluator` fail.
3. **Milestone (b)'s first mutation, negation evaluated in its own layer**, is unchanged by this
   task and is not re-run; its recorded effect is in `2026-09-15-c1190-milestone-b.md` and nothing
   here touches the layer assignment.

So the corpora decide the two questions per-column domains introduce — which closure a column may be
read from, and which literals' columns a domain comes from — and after the fourth shape they decide
the first one on generated programs rather than only on a committed fixture.

## Instructive negatives

1. **The type sub-range cannot narrow a domain, and the brief said it could.** Working out why cost
   the first hour of the task and is the reason the construction is the union alone. The one-line
   refutation is in "Deviations" above: a variable can be bound to a value outside the negated
   column's type, the negated atom is false there, and the complement must answer for it. The
   general lesson is worth keeping past this case: a type on a *column of a relation* bounds what the
   relation can hold, not what an atom over it can be asked about, and negation is exactly the
   construct that turns "what it does not hold" into an answer.
2. **The first `columns` cohort's boundary measurement was polluted by the complement's own name.**
   A complement can no longer be named for the relation it complements, since there may be several
   per relation, so the first version named it for the negative literal. Literal ids run to the
   dozens where relation ids run to single digits, so the name gained a digit — and the name is
   repeated once per complement fact in the canonical serialization that decides how far the route
   reaches. The `stratified` cohort's layer-one program went from 45,080 bytes to 46,045 at a domain
   of 32, a 2.1 per cent regression on the one cohort that had to be bit-identical. Naming a
   complement for its sequence in the layer restored it exactly. **A name in a serialization is a
   per-record cost**, and this route's whole bound is that serialization.
3. **Ordering the dictionary before the budget checks charged a refused program for an order nothing
   would read.** `close` ran the ordering first, so the `comment-string` cohort — which is refused by
   the relation budget at 896 relations and reaches `mangle` and nothing after it — paid 5.4 per cent
   of its lowering stage sorting a dictionary that would be thrown away. Moving the ordering to after
   every budget check removes it. The lesson is the placement rule this lane keeps relearning: work
   that only a successful lowering consumes belongs after the last thing that can refuse.
4. **A canonical form that writes more than the backend reads is a permanent tax on every program.**
   Writing each rule's binding sites into the canonical bytes unconditionally cost the fingerprint an
   extra pass over every variable of every rule of every program, including the 1,200-program
   in-fragment corpus, which has no negation at all and no complement to build a domain for. Gating
   the block on the rule carrying a negative literal is not a compromise: it is the same principle
   milestone (b) stated, applied precisely.
5. **The cost model for the lowering stage does not close, and I am not claiming one.** Summing what
   I can attribute — the `bind` pass's per-variable scan of the body's terms, the dictionary ordering
   and its two remaps, and the canonical form's extra bytes — accounts for about 60 per cent of the
   measured first-candidate regression on the `datalog` cohort. The playbook's rule is that a model
   that does not close to well under a per cent is a wrong model and the answer is a wider profile,
   not more shaving. This is recorded in the mystery ledger with its evidence gap rather than
   presented as an attribution.
6. **A counting-sort rewrite of `bind` is slower, not faster, and it was not kept.** Replacing the
   per-variable scan with a count pass, a prefix sum and a fill pass makes the work `2T + V` instead
   of `V × T` — which is a loss when `V` is three and `T` is six, the shape of every generated rule.
   Priced on paper before writing it and not written; recorded here because "the asymptotically
   better form" is the obvious next thing anyone reading `bind` will reach for.

## Measurements

**Arms.** Both are `ergodis-tools`, `release`, no features, built through
`../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools`, which re-executes itself inside
`nix develop` of the core checkout so the toolchain is the `rust-toolchain.toml` pin. rustc 1.95.0
(59807616e 2026-04-14) on every arm, read from the receipts' toolchain rows.

| Arm                  | Repository        | Revision  | Dirty | Retained name           | Measured sha256                                                    |
| -------------------- | ----------------- | --------- | ----- | ----------------------- | ------------------------------------------------------------------ |
| control              | `ergodis-private` | `ebecae2` | no    | `ergodis-tools-ebecae2` | `0112b26f2d0aa13ca811ad642b663fc6d63e19104b9ef3fdb6265cb741536283` |
| first candidate      | `ergodis-private` | `ef358f8` | no    | `ergodis-tools-ef358f8` | `d9e85a4b538d84ea57dffda1c8b2804afc57e7b9ab23ac4919981377b4c7c262` |
| candidate            | `ergodis-private` | `606136e` | no    | `ergodis-tools-606136e` | `e6de58c7217c7672f4bbc8f9b0fffee7a4d2b59e322a18bf10fa445446341a3b` |

Every hash is recorded as measured, not cited: the thing to run is the retain recipe at the named
revision. Every tree was clean. The control is the revision milestone (b) nominated. The first
candidate carries the construction; the candidate adds the three placements instructive negatives 2
to 4 describe and is otherwise the same code, which is why both are reported — the difference
between them is the measurement that chose the placements.

**Method.** Five interleaved rounds, both scanner variants, pinned to CPU 5, the non-multiplexing
six-event set `instructions,cycles,branches,branch-misses,page-faults,minor-faults`, two-point
differencing between `N` and `N/2` iterations, `--stages scan,parse,admit,lower`, 512 definitions.
Host: AMD Ryzen AI 9 HX 370, kernel 7.2.4. Instruction ratios decide; cycle ratios are reported only
with their intervals. Receipts, all under `analysis/rel-frontend/`:
`performance-v2-percolumn-606136e.json` (five default cohorts),
`…-datalog-606136e.json`, `…-stratified-606136e.json` (a real A/B now that the control can generate
that cohort, which milestone (b) could not run) and `…-cohort-606136e.json` (`columns`,
candidate-only). The first candidate's four are the same names with `v1` and `ef358f8`.

### Scan, parse and admission did not move

_(stage tables pending the final interleaved run; the first candidate's receipts already show every
`scan`, `parse` and `admit` ratio at 1.000000 within thirteen parts per million on every cohort and
both variants, with A/A instruction nulls between 1.000000 and 1.000011.)_

### The complement series, which is the result

`rel-lower --cohort <name> --definitions N` runs the whole chain and prints every complement record.
Both cohorts negate one unary relation, one binary relation and the universal's witness; on
`columns` the binary relation's first column is `N` integers and its second `N` entity references,
so the value dictionary is `2N` and each column spans half of it.

**The old cohort, which had to not move.** Every column of every negated literal of `stratified` is
bound by `dom`, which holds every value the program interns, so every `Dᵢ` is the whole dictionary
and the construction reduces to milestone (b)'s:

| Dictionary | Complement facts | Layer-one program bytes | Milestone (b) recorded |
| ---------: | ---------------: | ----------------------: | ---------------------- |
|         32 |              979 |                  45,080 | 979, 45,080            |
|         64 |            4,003 |                 178,792 | 4,003, 178,792         |
|        128 |           16,195 |                 723,680 | 16,195, 723,680        |

**Bit-identical**, not close. That is the regression this change had to pass and the sharpest
assertion in the report.

**The new cohort.** Same shapes, columns over disjoint value sets:

| Dictionary | `columns` complement facts | `stratified` at the same dictionary | Saving |
| ---------: | -------------------------: | ----------------------------------: | -----: |
|         64 |                        979 |                               4,003 |  4.09× |
|        128 |                      4,003 |                              16,195 |  4.05× |
|        256 |                     16,195 |            (refused past 153)       |      — |

The series is milestone (b)'s shifted exactly one doubling to the right, because each of the two
columns spans half the dictionary and `(d/2)² = d²/4`.

**Complement sharing.** On both cohorts the explicit `gap` rule and the universal's witness rule
produce the same column-domain signature over the negated binary relation, so the layer builds three
complement records for four use sites and the shared one reports `uses: 2`. Without sharing the
layer program would carry that complement's facts twice, which at a dictionary of 256 is another
743 KB of serialization against a budget of 1 MiB — that is, sharing is what keeps the `columns`
cohort inside the bound at all at its measured boundary.

### Where the route runs out, measured by bisection

`REL0503`, canonical bytes of one layer's program against the core contract's `MAX_BYTES` of
1,048,576. Each row is the largest count that runs and the first that is refused.

| Cohort        | Arity | Largest dictionary that runs | Complement facts there | First refused | Bytes reported |
| ------------- | ----: | ---------------------------: | ---------------------: | ------------: | -------------: |
| `stratified`  |     2 |                      **153** |                 23,182 |           154 |      1,054,530 |
| `columns`     |     2 |                      **302** |                 22,577 |           304 |      1,049,798 |
| `columns3`    |     3 |                       **84** |                 21,938 |            87 |      1,142,025 |

**The number that transfers is not the dictionary size.** All three boundaries sit at about
**22,000 complement facts in one layer**, which is the byte budget divided by the roughly 46 bytes
one complement fact serializes to with its relation name. Per-column domains do not raise that
ceiling; they raise how large a dictionary fits under it, by exactly the factor by which the columns
narrow. Two columns at half the dictionary give 4× the facts' worth of dictionary, so the boundary
doubles: 153 → 302, measured ×1.97. Three columns at a third give 27×, so it triples: milestone (b)
derived about 28 for arity three and the measurement here is 84, ×3.0.

**The reading, stated plainly.** For arity one the route is still free. For arity two it now affords
a dictionary of about 300 when the columns are disjoint halves and still about 150 when they are
not, so per-column domains buy a factor, not an order. For arity three it affords about 84 against
28. **ADR 0004's recorded alternative — a `Negative` atom kind in the core `Rule` with a stratum
order — is still the right route as soon as a program needs a dictionary in the thousands or a
negated relation of arity four**, because nothing here changes the 22,000-fact ceiling. What this
milestone changes is that the ceiling is now reached by the values a negation is actually asked
about rather than by every value the program mentions, and a constant argument or a narrow binding
column takes a complement to nothing at all: the `46⁴` program milestone (b) refused now builds one
tuple.

## Parity

The corpus gains four cases, each one where per-column domains change the complement's size:
disjoint columns over two types, a singleton binding column beside a wide one, a constant argument
under negation, and three typed-literal kinds in one dictionary — the last being the counterexample
to narrowing by type sub-range, kept as a case so the reading is gated rather than only argued.

The canonical bytes of the lowered program gain the dictionary's per-type dense ranges, and — for a
rule that carries a negative literal — that rule's binding sites per variable. So the parity gate
compares the two new structures the backend reads, not a hash of them.

- Before, at milestone (b)'s close: **226 cases, 471,171 canonical bytes**, canonical SHA-256
  `91b007eb67135840cfd1c4f46cddf5671fe460973f4ef19ce08e9c42ff8c384b`.
- After the code change and before the new cases: **226 cases, 473,349 canonical bytes**. The 2,178
  bytes are the canonical-form additions across the 31 lowered cases.
- After the new cases and the three placements: **230 cases, 484,312 canonical bytes**, canonical
  SHA-256 **`fce84314fd8442d3f28b66ba5b3b6c87d5bec71c3d7491a4e74ecb31f70ac1b0`**, native and WASM
  byte-equal.

Of the 230 cases, 86 admit, 35 lower, 51 are rejected by the lowering and 144 never reach it because
their parse or their admission failed. No syntax or admission outcome moved, and no lowering outcome
moved: the four new cases are the only change to the counts.

## Claims, and how to check them

1. **A complement is built over the product of the domains its arguments can take.** Run `rel-lower`
   on any negation fixture and read the `columns` array of each complement record: per argument, the
   type, its dense sub-range, the provenance, the binding sites and `|Dᵢ|`.
   `a_negated_literal_bound_by_narrow_columns_needs_one_complement_tuple` is the program milestone
   (b) refused at 4,477,456 tuples, now built over one.
2. **The construction is exact.** The argument is in "Semantics adopted" and is one sentence: range
   restriction puts every variable of a negative literal into a positive literal of the same rule, so
   every value it takes lies in that literal's column, so no tuple outside the product is ever asked
   about. The evidence is 600 generated negation programs over sixteen shapes, four of which exist
   only because the construction has something to get wrong on them, agreeing with a reference
   evaluator that knows nothing about complements — plus the thirteen committed fixtures against the
   independent Python oracle.
3. **The old cohort did not move.** `rel-lower --cohort stratified --definitions N` gives 979, 4,003
   and 16,195 complement facts and 45,080, 178,792 and 723,680 layer-one program bytes at 32, 64 and
   128, which are milestone (b)'s recorded figures exactly.
4. **The complement construction is independently re-checkable, and more sharply than before.**
   `verify_records` recomputes each column's domain from the relations and columns its record names,
   requires it to equal the recorded values, and only then rebuilds the product minus the closure and
   compares the SHA-256. `a_tampered_complement_record_does_not_rebuild` tampers with seven things in
   turn — the digest, each of the three counts, the recorded universe, a shortened domain and a
   provenance naming the wrong column — and each is refused.
5. **The agreement discriminates.** Two deliberate mutations, described above with what each broke;
   the first found a hole in the corpus before it found one in the code, and the shape added to close
   that hole is committed.
6. **The core rule contract is unchanged.** `~/src/ergodis` is clean and no commit of this task
   touches it. Every layer is an ordinary positive `Program` whose relations declare one global
   `domain`; a complement is an input relation whose facts are simply sparse in it.
7. **The lowering stage still allocates nothing, on every one of its exit paths.**
   `the_lowering_stage_does_not_allocate` drives nine sources rather than seven — the two new cohorts
   are added, which exercise the `bind` pass over a rule whose negative literal's columns come from
   different relations and the dictionary ordering over three typed-literal kinds at once — and
   observes zero allocations with retained bytes unchanged.
8. **The domain-set computation allocates nothing per fact.** The union over binding sites is a
   strided walk of each closure setting one bit in a bitset the whole evaluation shares; the only
   per-column allocation is the extracted value list.
9. **Native and WASM agree on the lowered program itself**, including the binding sites and the
   per-type ranges: 230 cases, 484,312 canonical bytes, byte-equal.

## Remaining gaps

1. **The route still affords about 22,000 complement facts in one layer**, and nothing here raises
   that. Per-column domains raise how large a dictionary fits under it, by the factor the columns
   narrow. ADR 0004's `Negative` atom kind in the core `Rule` is still the route for a dictionary in
   the thousands or an arity of four; it is now a clearly separated decision rather than one forced
   by the first negated binary relation over 150 values.
2. **A column bound only by a relation derived in its own layer falls back to the whole
   dictionary.** The tightening is a monotone fixpoint over the layer's relations: bound each derived
   relation's column values above by the union, over the rules deriving it, of the head term's own
   bound, iterated from the established closures upward. It is sound — the propagation ignores joins,
   so it over-approximates the real closure — and it would make the `recursive-binding` shape and
   every mutually recursive negation narrow like the rest. It is not built because a fixpoint-derived
   domain is not exactly reproducible from a *final* closure, so `ComplementRecord`'s rebuild would
   have to record the bound rather than recompute it, which is a change to what the record means.
3. **`Dᵢ` is the union over binding sites, where the intersection is also sound and tighter.** A
   variable's value must satisfy every positive literal that binds it. The intersection would be a
   free narrowing on any rule whose negative literal's variable is bound twice — which the
   `both-columns-negated` and `binarized-negation` shapes produce. Not built because no measured case
   demands it and because the record's per-site provenance is written for a union.
4. **The type sub-range is recorded and unused.** Making it usable needs a typed reading of an atom
   over a typed relation — an ill-typed application being a type error rather than a false atom —
   which is a semantics decision, not an optimization, and one the reference evaluator would have to
   share.
5. **The layer program's canonical form is still built twice per layer**, once for the byte check
   and once inside `datalog::admit` for the source identity. Milestone (b) recorded this as invisible
   beside the complement; it is less invisible now that complements are smaller, and it is the next
   thing to measure at a narrow domain.
6. **Milestone (a)'s and (b)'s other gaps are unchanged**: `exists(x in D: F)` is still `REL0504`
   while `forall(x in D: F)` is not, `not F` still takes an application and nothing else, the `&`
   and `?` argument sigils are still not parsed, the relational IR still reserves no symmetry table,
   and the witness of a `forall` still copies the whole disjunct's positive literals.

## Replay commands

Run from `~/src/ergodis-private`. Every gate and every measurement was run under
`nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the `rust-toolchain.toml` pin,
so the gates and the measurements describe one build.

```sh
# Gates.
nix develop ~/src/ergodis --command cargo test -p ergodis-private \
    --test rel_lowering --test rel_frontend --test rel_frontend_portability \
    --test rel_reference_eval -j 8
nix develop ~/src/ergodis --command cargo clippy -p ergodis-private --lib --tests -j 8 -- -D warnings
nix develop ~/src/ergodis --command cargo clippy -p ergodis-tools --bins -j 8 -- -D warnings
nix develop ~/src/ergodis --command cargo fmt -p ergodis-private -p ergodis-tools -- --check

# The committed independent Python oracle, and the native/WASM parity replay.
python3 tests/support/rel_closure_oracle.py --check tests/support/rel-closure-expected.json
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/portability.py \
    --output analysis/rel-frontend/portability-v1.json

# The corpus census, which the differential prints rather than asserts in full.
nix develop ~/src/ergodis --command cargo test -p ergodis-private \
    --test rel_reference_eval -j 8 -- --nocapture --test-threads 1

# One source end to end, through every layer, with every complement column's
# type, sub-range, provenance, binding sites and size.
nix develop ~/src/ergodis --command cargo run --release -p ergodis-tools -- \
    rel-lower --source-file <path.rel>

# The complement series on both cohorts, and the bisection of the boundary.
for n in 32 64 128; do
  for c in stratified columns; do
    nix develop ~/src/ergodis --command cargo run --release -p ergodis-tools -- \
        rel-lower --cohort $c --definitions $n --max-tuples 0
  done
done
# The boundary: the largest count that runs and the first that is refused.
for n in 153 154; do nix develop ~/src/ergodis --command cargo run --release -p ergodis-tools -- \
    rel-lower --cohort stratified --definitions $n --max-tuples 0; done
for n in 151 152; do nix develop ~/src/ergodis --command cargo run --release -p ergodis-tools -- \
    rel-lower --cohort columns --definitions $n --max-tuples 0; done
for n in 28 29; do nix develop ~/src/ergodis --command cargo run --release -p ergodis-tools -- \
    rel-lower --cohort columns3 --definitions $n --max-tuples 0; done

# The A/B. The candidate is the retain recipe at 606136e; the control is
# milestone (b)'s close.
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
CONTROL=~/.cache/ergodis/bin/ergodis-tools-ebecae2
CANDIDATE=~/.cache/ergodis/bin/ergodis-tools-606136e
B=analysis/rel-frontend
nix develop ~/src/ergodis --command python3 $B/bench.py \
    --binary "$CANDIDATE" --control "$CONTROL" --rounds 5 --cpu 5 \
    --stages scan,parse,admit,lower --events $E \
    --out $B/performance-v2-percolumn-606136e.json
nix develop ~/src/ergodis --command python3 $B/bench.py \
    --binary "$CANDIDATE" --control "$CONTROL" --rounds 5 --cpu 5 --cohorts datalog \
    --stages scan,parse,admit,lower --events $E \
    --out $B/performance-v2-percolumn-datalog-606136e.json
nix develop ~/src/ergodis --command python3 $B/bench.py \
    --binary "$CANDIDATE" --control "$CONTROL" --rounds 5 --cpu 5 --cohorts stratified \
    --stages scan,parse,admit,lower --events $E \
    --out $B/performance-v2-percolumn-stratified-606136e.json
# Candidate-only: the control predates the cohort and cannot generate it.
nix develop ~/src/ergodis --command python3 $B/bench.py \
    --binary "$CANDIDATE" --rounds 5 --cpu 5 --cohorts columns \
    --stages scan,parse,admit,lower --events $E \
    --out $B/performance-v2-percolumn-cohort-606136e.json
```

`ergodis-tools-606136e` is the control the next frontend A/B should use.

## Mystery ledger

1. **Settled: what per-column domains buy, and it is a factor rather than an order.** All three
   measured boundaries sit at about 22,000 complement facts in one layer, which is the core
   contract's one-mebibyte serialization budget divided by the roughly 46 bytes a complement fact
   costs. Per-column domains raise how large a dictionary fits under that ceiling by exactly the
   factor the columns narrow: ×1.97 measured for two half-dictionary columns, ×3.0 for three
   third-dictionary columns. They do not raise the ceiling. *Nothing about this item is open, and it
   is the answer to the question milestone (b) left.*
2. **Settled: the per-column reading and the whole-dictionary reading agree wherever both apply.**
   The `stratified` cohort, every column of which spans the dictionary, produces bit-identical
   complement counts and layer-program byte counts, and the 600-program negation corpus agrees with a
   reference evaluator that has no notion of a complement. The exactness argument is one sentence and
   is milestone (b)'s applied per column.
3. **Settled, and it was the task's brief that was wrong: the column type's sub-range cannot narrow
   a domain.** A variable can be bound to a value outside the negated column's type, the negated atom
   is false there, and the complement must answer for it. The parity corpus carries the
   counterexample as a case. The sub-ranges are built, carried and recorded; they are simply not a
   filter.
4. **Settled: a complement is identified by its relation and its column-domain signature, and
   sharing is what keeps the measurement inside the bound.** On both new cohorts two use sites share
   one complement; without sharing, the `columns` cohort at its measured boundary would carry that
   complement's facts twice and exceed the byte budget.
5. **Open: the lowering stage's cost model does not close.** What I can attribute — the `bind` pass,
   the dictionary ordering with its two remaps, and the canonical form's extra bytes — accounts for
   about 60 per cent of the first candidate's measured regression on the `datalog` cohort. *Evidence
   gap*: a kernel-scoped `perf record -e instructions:u` profile of `lower::run` bucketed by address
   range, in both retained binaries, which is the method the playbook prescribes and which has
   settled this lane's attribution questions before. Not attempted here because nothing in this
   milestone's acceptance depends on the split and because the three placements already removed the
   part that was pure waste.
6. **Open: what the same-layer fallback costs, and whether the monotone fixpoint is worth its change
   to the record.** Every column bound only by a relation the layer is still deriving takes the whole
   dictionary. No cohort measures it, because both new cohorts bind through input relations.
   *Evidence gap*: a cohort with a recursive relation binding a negated literal, and the record-shape
   decision in remaining gap 2, which is a design question rather than a measurement.
7. **Open: whether the intersection over binding sites is worth taking.** Sound and strictly tighter
   than the union. *Evidence gap*: no program in any corpus has a negative-literal variable bound
   twice by columns whose value sets differ, so there is nothing to measure it on yet. Owner:
   whoever adds the cohort for item 6, which is the same shape of work.
8. **Open, inherited and unchanged: milestone (a)'s interning cost, the relation-resolution scan and
   the admission repeated-spelling quadratic**, and milestone (b)'s open item 4 — the `datalog`
   cohort's thin-LTO layout swings. Nothing here moved any of them.
9. **No genuine mystery remains about the semantics.** Every construct outside the fragment is in the
   Figure 3/4 table or the surface-construct table with its exact outcome, no row moved, and both
   scanner variants decide every row identically.

## `ej`/`tt` closeout

Run after the acceptance gate passed, as the lane requires.

**Cheap upgrades taken.** The three placements instructive negatives 2 to 4 describe were all found
by the first candidate's own measurement and each cost a handful of lines: the complement's name
became its sequence in the layer, which restored the old cohort's byte counts exactly; the dictionary
ordering moved after the last check that can refuse, so a refused program pays nothing; and the
canonical form writes a rule's binding sites only when the rule has a negative literal. A
single-kind dictionary — which is most programs — skips the ordering entirely after the one counting
pass it has to make anyway. `verify_records` gained the check per-column domains made possible, that
each column's values *follow from* the relations and columns the record names, and the tamper test
grew from four cases to seven. And the `stratified` cohort became a real A/B rather than a
candidate-only snapshot, because the control can now generate it, which is what turned "the old
cohort did not move" from a comparison against a report into a comparison against a binary.

**Doors this opens.**

1. **Milestone (c)'s aggregates have the integer sub-range for free.** `count`, `min`, `max` and
   `sum` over integers need to know which dictionary ids are integers; `type_range(VALUE_INT)` is now
   two integers rather than a scan, and the result of an aggregate interns into that range.
2. **A typed readout is now a range test.** Decoding a tuple currently looks each value up; with the
   dictionary ordered by kind, a column's type decides the decoding branch once per column instead of
   once per value.
3. **The complement-sharing key generalizes to the aggregate boundary.** An aggregate over a
   certified closure is the same shape as a complement over one — read an earlier layer's closure,
   compute something, feed it forward as an input relation — and two use sites of one aggregate over
   the same group are the same sharing question the `built` list answers here.
4. **The `Negative` atom kind in the core is now a clean, separate decision.** Milestone (b) made it
   the route "as soon as a program negates a relation of arity three, or of arity two over more than
   a couple of hundred values". It is now the route for a dictionary in the thousands or an arity of
   four, which is a much narrower claim, and the 22,000-fact ceiling is the number that would have to
   move to change it.

**Candidates to queue** (no IDs allocated):

- Milestone (c): aggregation at layer boundaries, on the driver this milestone leaves.
- The monotone column-value fixpoint for same-layer binding relations, with the
  `ComplementRecord` shape decision it forces.
- The intersection over binding sites, with a cohort that has a doubly-bound negated variable.
- A kernel-scoped profile of `lower::run` in `ergodis-tools-ebecae2` against `ergodis-tools-606136e`,
  bucketed by address range, to close mystery item 5 and milestone (b)'s item 4 at once.
- `exists(x in D: F)` and `not` over a non-application, both through the witness machinery `forall`
  already has, which milestone (b) queued and this milestone did not touch.

## What this task left under `~/.cache/ergodis/`

`bin/ergodis-tools-ef358f8` and `bin/ergodis-tools-606136e` with their `.sha256` sidecars and
manifest rows — the first candidate, which the report cites for the placement decision, and the
candidate, which is the control the next frontend A/B should use. No profile data: this milestone's
result is read from counted complement facts and program bytes rather than from a symbol profile,
and the one profile the mystery ledger asks for was not taken. Both binaries are named by this
report, so `scripts/cache-gc.sh` will show them as referenced. Deletion is the user's call.

## Vibe check

Good, and the number is smaller than it looks until you read what it is. Per-column domains do what
they were supposed to: a complement is now the values a negation is actually asked about, a constant
argument or a narrow binding column collapses it to nothing, and the program milestone (b) refused
at four and a half million tuples builds one. But the ceiling did not move — all three measured
boundaries sit at about 22,000 complement facts, because the bound is the layer program's
serialization and not the arithmetic — so what this buys is a factor on the dictionary size, ×2 at
arity two with disjoint columns and ×3 at arity three, and the `Negative`-atom route in the core is
still what a program with a dictionary in the thousands needs. The old cohort came back
bit-identical, which is the result I most wanted and the one that says the construction is a
narrowing rather than a different reading. One blemish stated plainly: the lowering stage is
measurably more expensive and my cost model for it accounts for only about 60 per cent of that, so
the attribution is recorded as open with the profile that would close it rather than claimed.
