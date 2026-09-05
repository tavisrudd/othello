# C1062 probe 8: the unrolled sequential window, and what a non-idempotent vocabulary actually buys

**Lane**: `complete-ports`
**Task**: C1062, probe 8
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: probe 1a section 4 for the signature collapse and section 5 item 4 for the claim this
probe tests; probe 1 for the caveat that its separating words were pins in word shape; probe 2 for
the structural timing result.
**Code**: `ergodis-private` `691eba8` (`src/causal_sequential.rs`,
`tasks/tools/src/causal_sequential_report.rs`)
**Replay**: `cd ~/src/ergodis-private && cargo run --release --package ergodis-tools --
causal-sequential-report`
**Evidence**: `ergodis-private` `evidence/2026-09-05-causal-sequential-repaired.txt`, the output of
that command after the review repairs. No evidence was retained when this report was written.
**Reviewed**: `2026-09-05-c1062-probe8-review.md`. Corrections are marked **[corrected]** below and
the original reasoning is kept wherever it explains how a number was reached.
**Predeclared threshold**: word closure non-vacuous, measured. **[corrected]** that threshold is met
by any nonzero outcome and could not have failed; the fixture is also a three-state machine where the
plan says two, which is an improvement and was undisclosed.
**Verdict**: **met, and sharply.** Under the cyclic-cursor vocabulary no generator is idempotent, no
generator pair commutes, some edit states need a word longer than the window, and every one of the
34 separating certificates of length two or more is order-essential — a permutation of the same
multiset fails to separate the pair. The hard-pin control reproduces the collapse exactly: all
generators idempotent, no separator longer than one step, no order-essential separation. The
economics are unchanged from probe 2 and were predeclared as a loss: the ratio is 1.00x in every
vocabulary.

**[corrected]** the verdict originally closed "What a richer vocabulary buys is not speed. It is that
the direct route is complete only up to the word length it enumerated, while the compiled machine
answers every word." That is false against this probe's own oracle — see § 5. What the measurements
do establish is narrower and still valuable: under a non-idempotent, non-commuting vocabulary the
separating **certificate** is a genuine word whose order and repetitions carry information no pin set
carries, and the hard-pin control turns probe 1's caveat about word-shaped pins from an argument
into a measurement. Two further corrections below: "all 34 order-essential" is a property of the
emitted certificates and holds for **7** of the 34 pairs; and the economics `1.00x` is an identity
that could not have come out otherwise.

## 1. The window

A bounded window of a finite deterministic machine, unrolled: three machine states, a binary input
per step, a saturating advance (input 0 holds, input 1 advances and stops at the top), four steps,
observing the final machine state. The exogenous context is the input word, so there are 16
contexts. Three declared edit vocabularies over the same window, with the carrier `(u, E)` and every
generator a total map on it:

- **hard-pin**, the control: `do(X_{t+1} := s)`. Twelve generators.
- **unit-shift**: `do(X_{t+1} += 1)`, and only the unit step is declared, so a shift of two needs the
  same generator twice. Four generators.
- **cyclic-cursor**: bind one of four declared mechanism edits — skip, freeze, reset, bump — to the
  step the cursor is on, then advance the cursor, wrapping at the end of the window. Four generators.

The cursor is not a trick chosen to produce non-commutativity. It is the shape a staged intervention
vocabulary has in the applied targets probe 8 exists to decide on: inject the next fault, apply the
next repair, drive the next test vector.

## 2. Carrier, quotient, and the oracle gate

| vocabulary         | edit states | generators | carrier | compiled | oracle | agree |
|--------------------|-------------|------------|---------|----------|--------|-------|
| hard-pin (control) | 256         | 12         | 4,096   | 11       | 11     | yes   |
| unit-shift         | 81          | 4          | 1,296   | 16       | 16     | yes   |
| cyclic-cursor      | 1,024       | 4          | 16,384  | 16       | 16     | yes   |

The oracle enumerates reachable edit states directly rather than as generator words, so a misreading
shared between the model and the compiler cannot manufacture agreement. All three agree.

**Both non-idempotent vocabularies drive the quotient to the identity.** Hard pins leave 11 classes
on 16 contexts; the unit shift and the cursor both resolve every context. Anyone declaring a
sequential vocabulary for the sake of compression is declaring the wrong thing.

**[corrected]** this paragraph originally led with "A richer vocabulary is a finer quotient … a
monotone slide toward the identity". There is no such dial, and the table above refutes it: the unit
shift has four generators against the hard pin's twelve, 81 reachable edit states against 256, and
all six of its generator pairs commute — and it gives the **finer** quotient. The mechanism is the
one § 6 identifies: the machine's saturation is what loses information and a *modular* shift undoes
it, because state two plus one wraps to zero. The right generalization is about whether the
vocabulary can invert what the natural run discards, not about how much vocabulary there is. The
practical advice survives; the reason given for it does not. See
`2026-09-05-c1062-probe8-review.md` § 2.3.

## 3. The collapse, measured

| vocabulary         | idempotent generators | commuting pairs | reachable edit states | deepest minimal word | longer than the window |
|--------------------|-----------------------|-----------------|------------------------|----------------------|------------------------|
| hard-pin (control) | 12 of 12              | 54 of 66        | 256                    | 4                    | no                     |
| unit-shift         | 0 of 4                | 6 of 6          | 81                     | 8                    | yes                    |
| cyclic-cursor      | 0 of 4                | 0 of 6          | 1,024                  | 7                    | yes                    |

Three things in this table settle probe 1a's section 5 item 4.

**The control collapses exactly as predicted.** Every hard-pin generator is idempotent, and the
deepest edit state is reached by a word of length four, one pin per step and no more. So under hard
pins a word never needs to repeat a generator, which is the operational content of "the word reduces
to the partial assignment it ends at".

**The hard-pin control is not commutative, and that was never the point.** Twelve of its 66 generator
pairs fail to commute — exactly the pairs writing the same step with different values, where the last
write wins. Probe 1a said "commutative on distinct variables" and that is what holds. Commutation is
therefore the wrong discriminator, and the deepest-word column is the right one.

**Words longer than the window are not redundant.** The unit shift needs eight applications to put
every step at the top of its cycle, and the cursor needs seven to bind all four steps and land the
cursor where it must. Both exceed the four-step window. This is the sharp form of non-vacuity: a word
longer than the number of editable steps still reaches an edit state that no shorter word reaches, so
the word is not a pin set in disguise.

## 4. Separating certificates, and whether their order carries weight

Over all separated context pairs, the length of the shortest separating word, searched shortest
first up to length four.

| vocabulary         | separated pairs | length 0 | length 1 | length >= 2 | unbounded | order essential (certificate) | order essential (pair) |
|--------------------|-----------------|----------|----------|-------------|-----------|-------------------------------|------------------------|
| hard-pin (control) | 112             | 59       | 53       | 0           | 0         | 0                             | 0                      |
| unit-shift         | 120             | 59       | 48       | 13          | 0         | 0                             | 0                      |
| cyclic-cursor      | 120             | 59       | 27       | 34          | 0         | 34                            | **7**                  |

**[corrected] "all 34 order-essential" is a property of the certificates, not of the pairs.** The
report tool takes **one** word per pair — whatever the shortest-first search returns first — and
tests that word's permutations. Enumerating instead *every* minimal-length separating word per pair,
only **7** of the 34 cursor pairs have the property that every minimal separator needs its order;
for the other 27 some minimal separator can be permuted freely and still separates. The
certificate-level claim stands and is what a caller replaying that certificate must respect; the
pair-level claim is the one the wording reads as. The `34` itself is complete: the cursor quotient is
the identity, and `59 + 27 + 34 = 120` accounts for every pair inside the search bound.

**[corrected] the `unbounded` column is new and the old code could not have shown a nonzero one.** A
pair with no separator inside `--max-word` was folded into the **length 0** column by an
`unwrap_or_default` — the column that means "separated before any intervention". At `--max-word 1`
that inflated the cursor's length-zero count from 59 to 93. The tool now counts such pairs
separately and fails rather than printing a prettier table.

**[added]** every minimal separator here has length two or three — 24 and 10 for the cursor, 12 and
1 for the unit shift — so **no separating certificate exceeds the window**, even though some edit
states need words of length seven or eight to reach. The overlong-word result of § 3 is about
edit-state reachability, not about separation, and the two sit close enough together to read as one.

**This is the result probe 1 could not have.** Probe 1's wide-conjunction certificate read
`do(V0:=1) do(V1:=1) do(V2:=1)`, and its report flagged the caveat that must not be glossed: by the
signature collapse that word is equivalent to one simultaneous arity-three pin, so it was a
word-shaped presentation of a pin rather than evidence that word structure matters. Here, under hard
pins, **no** separated pair needs a word of length two or more — the control confirms the caveat
directly. Under the cursor, 34 pairs need one, and all 34 are order-essential: at least one
permutation of the same generator multiset fails to separate the pair. One of them, printed by the
report: contexts 1 and 2 are separated by `apply(skip) apply(skip) apply(freeze)`, and reordering
those three applications loses the separation.

The unit shift sits in between and is instructive: 13 pairs need length two or more, because the same
generator has to be applied twice, but **zero** are order-essential, because its generators all
commute. Repetition and order are separate axes, and only the cursor has both.

## 5. Economics, predeclared as a loss

| vocabulary         | carrier solves | direct-oracle solves | ratio |
|--------------------|----------------|----------------------|-------|
| hard-pin (control) | 4,096          | 4,096                | 1.00x |
| unit-shift         | 1,296          | 1,296                | 1.00x |
| cyclic-cursor      | 16,384         | 16,384               | 1.00x |

Predeclared as a loss before the run, and it loses. The compiled route solves the model once per
carrier state and the direct route once per reachable edit state, and every edit state is reachable
in all three vocabularies, so the ratio is exactly one. Probe 2's structural finding recurs
unchanged.

**[corrected] this is an identity, not a measurement, and it could not have come out otherwise.**
Neither column is timed and neither is a solve count taken from a run: both are combinatorial counts,
the ratio is exactly `encoded edit states / reachable edit states`, the context factor cancels, and
it is bounded below by one because the reachable set is a subset of the encoding. The predeclared
verdict was "a loss", and the only outcomes available were `1.00x` or worse — the arm could not have
been won. The columns are relabelled `encoded states` and `reachable states` in the tool. The gate
that would break the identity, correctly named in § 8, is a vocabulary whose reachable edit set is a
strict subset of its declared encoding; none is built here.

**[corrected] compilation does not buy completeness here.** The paragraph below argued "when the edit
monoid is the free monoid on the cursor alphabet, enumerating edit states means enumerating words,
and the enumeration is complete only up to the length it reached". The antecedent is false in all
three vocabularies: the edit-state space is finite — 81, 256, 1,024 — and `reachable_with_depth`
closes it by breadth-first search in at most eight steps, so the direct oracle already answers every
word of every length. The experiment § 8 asked for settles it against the claim: drawing 20,000
uniform random length-twenty words per vocabulary, **zero** land outside the set the oracle had
already enumerated, and necessarily zero, since the reachable set is closed under every generator.
The claim would hold against a direct route that enumerates words to a bound; no such route exists
in this repository, and the plan explicitly forbade it. See
`2026-09-05-c1062-probe8-review.md` § 2.1. The original paragraph follows.

**What changes is completeness, not cost.** The direct route enumerates edit states; when the edit
monoid is the free monoid on the cursor alphabet, enumerating edit states means enumerating words,
and the enumeration is complete only up to the length it reached. The compiled machine is a finite
automaton over the edit alphabet and answers every word, of any length, from a fixed table. That is
the defensible statement of what compilation buys in this regime, and it is a different claim from
speed.

## 6. The protected-tail lever, tested and closed

I expected the identity quotient in section 2 to be an artifact of a vocabulary that can write the
observed variable directly, and the obvious lever is to protect the last step so no edit can touch
it. Built and measured: with three of four steps editable, the carrier falls to a quarter, a third and
three sixteenths respectively (hard-pin 4,096 to 1,024; unit-shift 1,296 to 432; cursor 16,384 to
3,072 — **[corrected]** from "drops by roughly a third", which is right for one of the three) and
**every quotient and every separator count is identical** — 11, 16, 16 classes, and the same 0, 13,
34 length-two-or-more separator counts with the same 0, 0, 34 certificate-level order-essential
counts and the same 0, 0, 7 pair-level ones.

The reason is specific and worth keeping: the machine's saturation is what loses information, and a
*modular* shift undoes it, because state two plus one wraps to zero. So three editable steps probe
every context exactly as four do. **The lever is closed as a measured negative**, and the general
statement it leaves behind is that protecting a step can only coarsen the quotient or leave it alone
— which is gated as an invariant in the tests — but is not guaranteed to coarsen it.

**[corrected]** the test gates the class **count**, not the partition, and the reason given
("protecting a step removes generators") does not apply to the cursor, where `with_editable` changes
the cursor's wrap modulus rather than removing generators. The invariant is nonetheless true, for a
different reason: the protected model's observations are a sub-vector of the open model's, since the
protected semantics coincide with the open ones at every edit state whose tail binding is the
identity. See `2026-09-05-c1062-probe8-review.md` § 6.

## 7. What this decides about the time-indexed applications

Probe 8's second job was to decide whether the highest-ranked application targets — electronic design
automation and debug, incident root-cause analysis, breach accountability, fault injection, all
time-indexed — are one sentence away from scope or genuinely out. **They are in, by bounded
unrolling, and the sentence is now written rather than assumed.** An acyclic unrolling of a bounded
window is an ordinary finite model, the staged edit vocabulary is a declared total action on the
`(u, E)` carrier, and the compiled object is the finite automaton over that alphabet. The scope
condition that excluded them in revision one of the plan was excluding a case that works.

Two conditions attach, and both are measured rather than asserted. The window must be bounded and
declared, because the carrier is `contexts x edit states` and the edit-state count grows as
`|G|^(editable steps)` for the cursor. And the vocabulary must be chosen for what it should be able to
reach, not for compression, because on this fixture the sequential vocabularies drive the quotient to
the identity.

## 8. Mystery ledger

- **Why does the quotient go to the identity under both non-idempotent vocabularies, and stay there
  when the tail is protected?** Settled by section 6: the modular shift undoes the machine's
  saturation, so information the natural run loses is recoverable by probing. Not a mystery any
  longer, and the closure is a measured negative rather than an argument.
- **Repetition and order are independent, and only one vocabulary has both.** Measured, and the unit
  shift is the separating example: 13 length-two separators, zero order-essential. No open question,
  but it is the fact that makes "non-idempotent" too coarse a label to plan with.
- **The economics ratio is exactly 1.00x in all three vocabularies, at every size tried.** Expected
  from probe 2 and predeclared. **[corrected]** not "three independent confirmations": the three
  share one construction and one formula, and the ratio is an identity given full reachability rather
  than a measurement. **Open, with a named gate**: a vocabulary
  whose reachable edit set is a strict subset of the declared edit-state encoding would break the
  identity, because the compiled route pays for the encoding and the direct route pays only for what
  is reachable. Every vocabulary here has full reachability by construction. Whether a natural one
  does not is untested.
- **The compiled machine answers words of unbounded length and the direct route does not.**
  **[corrected] closed in the negative.** The length-20 experiment named here was run: 20,000 uniform
  random length-twenty words per vocabulary, and zero land outside the set the direct oracle had
  already enumerated. The direct route closes a finite edit-state space by breadth-first search
  rather than enumerating words to a bound, so it answers every word of every length exactly as the
  compiled machine does. The claim is false in this regime; § 5 carries the repair. The original text
  follows: "Stated in section 5 and true by construction, but not *measured* — there is no fixture
  here where a query of length beyond the enumerated bound is actually asked and answered."

## 9. Next

Probe 8 closes the surviving structural question from probe 2. The remaining planned probes are 4
(level-3 counterfactual and the observation precondition), 5 (Evolve proposes, separator refutes), 6
(k-ary experiment design), and 9 (the gated end-to-end demonstration). Of these, probe 4 is the only
one whose deliverable is a correctness statement with a stated precondition and a demonstrated
negative, which is the shape that has paid best in this task so far.
