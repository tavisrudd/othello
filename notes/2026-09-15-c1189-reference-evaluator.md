# C1189 — reference evaluator for the lowered Rel fragment

**Lane**: `ergodis`
**Date**: 2026-09-15

## Fermi predictions, written before code

1. **Generated programs.** A seeded generator of programs inside the fragment, with a near-miss
   generator beside it, should reach a few hundred sources before the test binary's budget bites.
   The cost per program is dominated by the demand-driven evaluator, its derivation certificate and
   the independent checker, not by the naive evaluator: the naive side runs over a domain of at most
   four or five values and relations of arity at most three, so its fixed point is a few thousand
   set operations. I predict 150 to 250 accepted programs and 60 to 120 near-misses inside a debug
   `cargo test` of well under a minute, and that the generator, not the evaluator, is what I will
   have to slow down.
2. **Disagreements.** Two independent implementations of a contract written in prose disagree; the
   question is where. I predict one to three genuine disagreements, and that their distribution is
   the interesting part: a disagreement in the *closure* of an accepted program would be the worst
   and I expect none, because the eight committed fixtures already agree with two independent
   evaluators (the committed Python oracle and the 2026-09-15 audit's own). I expect the
   disagreements to sit in the rejection surface and in name resolution, because those are the parts
   the paper does not cover and the module-scope contract states only in prose.
3. **What a disagreement would mean.** A disagreement is not automatically a lowering defect. Three
   dispositions are possible and I have to decide which before touching anything: the lowering
   contradicts the stated contract (fix the lowering, with a fixture); the naive evaluator
   misreads the contract (fix the evaluator); or the contract does not decide the case (record both
   readings, take the one milestone (a) implies, flag it). Before writing any code I read
   `build::qualified` and found one candidate of the first kind by inspection — the module-name
   probe order — so my prior is that at least one real lowering defect exists, of the same family
   as the `resolve_name` defect the C1190 vetting pass fixed.
4. **The equation table.** Fourteen of the 35 Addendum A equations are inside the lowered fragment.
   A reference-evaluator column can only be an outcome for those fourteen plus the handful the
   evaluator rejects for its own reasons; I predict the two columns agree on every row and that the
   work is in saying precisely *why* each out-of-fragment row is out, not in discovering a new
   outcome.

**How they came out.** Prediction 1 was wrong by an order of magnitude in the cheap direction: the
committed corpus runs 1,200 generated programs, 400 near-misses and 120 name-resolution templates,
and the whole test binary takes 1.4 seconds in a debug `cargo test`, so the count is set by taste
rather than by a budget. Prediction 2 was right in number and in location: three genuine
disagreements, all three in the rejection surface or in name resolution, none in the closure of a
program both sides accept. Prediction 3's "at least one real lowering defect" was right, and the
inspection candidate was the first one the differential caught. Prediction 4 was right: the two
columns agree on all 35 rows, and the work was in the *why* column.

## Status

Complete. Every gate below passes, and every disagreement the differential found is either repaired
with a fixture or reported with its minimal repro, its root cause and a named owner.

## What was built

All of it is test-only and outside the performance contract, as the task card requires.

| File | What it is |
|---|---|
| `tests/rel_reference/mod.rs` | the naive, set-based reference evaluator and its stated contract |
| `tests/rel_reference/generate.rs` | the seeded generators: in-fragment, near-miss, name-resolution templates |
| `tests/rel_reference_eval.rs` | the differential harness and every committed table |

**The evaluator** consumes the frontend's parsed and admitted node pool (`Workspace::nodes`) and the
source bytes, and nothing else. It never reads the relational IR, the rule-contract `Program`, the
readout map or `rel_lowering`. Everything the two sides share — the scanner, the parser, semantic
admission — is shared deliberately and is named as a limit below. No visibility change to production
code was needed: the node pool, `Node`, `NodeKind`, `Kind` and `NONE` are already public, and the
evaluator recovers the definition and module node lists by scanning the pool in ascending node id,
which is source order because the parser pushes an item's node after its children and items do not
nest.

It is naive by construction. A relation is a `BTreeSet<Vec<Value>>` over an explicit finite active
domain; a rule body is matched by backtracking over full relation snapshots in source order with no
index of any kind; the fixed point is reached by repeating whole passes until one pass adds nothing.
There is no semi-naive evaluation and no dictionary of dense ids.

**A second evaluation path** enumerates every assignment of a rule's variables over the active domain
and tests each body atom for membership — the most literal reading of Figures 3 and 4 restricted to a
finite domain. For a range-restricted program it must give the same closure as the backtracking join,
and `the_naive_join_and_the_domain_enumeration_agree` asserts that on every fixture and generated
program small enough to enumerate. That is a third independent support for the evaluator itself,
beside the committed Python oracle's agreement on the eight milestone (a) fixtures.

**The generators** emit source text only, so they cannot bias one side: both sides then run the same
scanner, parser and admission over that text. There are three. The in-fragment generator produces
fact sets, one to two derived relations of arity one to three with one to two `def` clauses each,
optional modules with or without parameters, optional free names, `exists` with shadowing,
disjunction in both spellings, conjunction in both spellings, `x in D`, constants, `_`, recursion and
mutual recursion; every program is range-restricted by construction, because each head column — the
module's leading columns included — is placed into its own free argument position of some positive
body atom before the remaining positions are filled. The near-miss generator breaks exactly one
property per program. The name-resolution generator emits six templates in which one spelling is
declared at two owner levels and the closure differs between the two possible readings.

**The harness** runs, for each source, the whole lowering chain (parse, admit, lower, backend v1,
`Demand::new`, evaluation, derivation certificate, the core's independent checker, the ranked
certificate and its checker, and the decoded readout) and the reference evaluator on the same node
pool with the same external facts, and asserts that the verdicts agree, that an accepted program's
readout relations, arities and tuple sets are identical, that both checkers accept and agree with the
evaluator's rows tuple-wise, and that both sides identify the same set of free names.

**External facts.** A free name is an external input relation with no facts of its own. The harness
supplies its facts to both sides: to the evaluator directly, and to the lowered program by appending
`rule_contract::Fact` rows before `Demand::new`. A lowered program's tuples are dictionary ids, so an
external fact may only mention a value the source itself writes; every generated program therefore
emits a `def dom = {…}` fact set that interns the whole domain, and the hand-written fixtures that
read free names do the same. The harness also prunes the supplied externals to the free names a
source actually references and then asserts that the two sides' free-name sets are equal, which is
what catches a source whose free name is not in fact free.

### Commits

| Commit | What |
|---|---|
| `19f9d71` | the two lowering defects the differential found, with closure-shape fixtures and the parity receipt |
| `d3731ae` | the reference evaluator, the seeded generators and the differential harness |
| `20f1009` | the formal-semantics paper pinned in the frontend coverage manifest |
| `97b7b0f` | the surface-construct table, the checker's replay compared tuple-wise, the construct census |
| `bccb4e8` | the ranked checker on every corpus program, the workspace-purity gate, the last two rejection classes |
| `e000d09` | the variable-map fixture's provenance corrected: found by reimplementing the pass, not by the corpus |

## The evaluator's stated contract

Written down as the evaluator's own contract, not as a claim about Rel, for the same reason milestone
(a) wrote its own: the paper defines the denotation of an expression and of a formula but only
sketches the semantics of a *program* ("much like in recursive Datalog programs … propagated in an
iterative fashion until no new facts can be inferred"), and it has no module construct at all.

**Which programs are admitted.** Every top-level item is a `def` or a `module … end`, and every
definition is one of two shapes. A **fact set** is a definition with no parameter list whose body is a
`;`-chain of `,`-tuples of constants of one common width, not inside a parameterized module. A
**rule** is `def r(p, …) = Body` where the body is built from applications, `and` and `,` as
conjunction, `or` and `;` as disjunction, `exists`, parentheses and `()`; an argument is a variable in
scope, `_`, or a constant; a parameter is a name, `_`, or `x in D`. Several `def` clauses may define
one relation and must agree on arity and on whether the relation is a fact set or a rule head. A free
name is an external input relation, global whatever module the use sits in, with its arity fixed by
its first use in the order restrictions-then-body, per definition in source order. Every other
construct is a distinct "outside fragment" rejection.

**Which fixed point is computed.** The least fixed point of the positive rules over the finite active
domain — every value a fact or a rule constant mentions — by full naive iteration. Negation,
comparison and aggregation are represented far enough to be range-restricted and stratified and are
then rejected, exactly as backend v1 rejects them, so the evaluator computes no stratified fixed
point yet. The stratification it does compute exists so that milestone (b) extends an evaluator that
already holds the dependency graph; a non-monotone cycle is a "not stratifiable" rejection and never
an approximation.

**Safety condition.** Range restriction. Every head variable, and every variable of a non-positive
literal, must occur in a positive body literal of the same rule. A rule that fails it is rejected,
never approximated over the infinite `Values` of Figure 3.

**Deliberate readings**, each of which could have gone the other way and each of which is milestone
(a)'s: `,` in a formula position is conjunction; `()` is the true formula and `{}` the false one, and
a false body has no representation so it is rejected; the true formula is absorbed by conjunction,
and a disjunct that is only the true formula has an empty body and is rejected; a body's own
parameter shadows a module parameter of the same spelling; resolution inside a body is innermost
binder first, so an `exists` binder shadows a parameter of one spelling and the parameter is restored
when the quantified formula closes; a bare relation name resolves to the innermost owner in the
module chain that declares it and only then to the top level; a relation name in a term position is
higher-order and rejected.

**Rejection order.** The evaluator applies its checks in the order the lowering applies them —
declaration, body construction, per-rule variable numbering, range restriction, stratification,
binarization's budget, the closing budgets, then what backend v1 refuses — so that a source carrying
two defects agrees on *which* one is reported, not merely that it is rejected.

**Where the two sides are not independent, and why.** One function, `binarization_budget`, mirrors
the lowering's strategy rather than reading the contract. Backend v1 admits at most two body atoms,
so the lowering rewrites a longer positive body into a chain through auxiliary relations, each
carrying the variables still live in the remaining chain, and refuses an auxiliary that is wider than
four columns or empty. Those bounds are properties of binarization, not of the denotation, and cannot
be derived from Figures 3 and 4; the mirror — join-order heuristic included — exists only so that the
two sides agree on every verdict. It never touches the closure of an accepted program. It is also
where the third defect below shows up.

**Recorded limits of the evaluator.** It compares rejection *classes*, not budget names: both sides
say "budget" without agreeing on which of the sixteen budgets. It does not mirror the pool-capacity
budgets, the index-key bound or the tuple-universe bound, because the corpora keep domains at four
values or fewer and those bounds are unreachable there. It has no auxiliary relations, so its readout
is every relation it declares, which is exactly what the lowering's `Readout::visible` exposes —
inputs and fact sets included, which is a stronger comparison than the task card's "exclude the
externals" and is like-for-like because the harness supplies the same external facts to both sides.

## The Figure 3 and Figure 4 equation table

All 35 equations of Addendum A of Aref et al., arXiv:2504.10323 (literature cache key
`arxiv:2504.10323`, sha256 `6e1371160602b1df77d9e5a647369bcd747aec3e8a97e36d2e99f04c219194b6`,
verified against the manifest for this task) are a committed table in `tests/rel_reference_eval.rs`,
in the same order and on the same sources as the lowering's table in `tests/rel_lowering.rs`, so the
two tables are two columns over one input. Each row also records which test exercises the equation,
or why nothing can. The test asserts the reference evaluator's recorded outcome *and* that the
lowering reaches the same verdict on the same source, so a change of coverage on either side fails.

| Equation (Addendum A) | Reference evaluator | Exercised by |
|---|---|---|
| `[[c]] = {<c>}` | evaluated | the constant-argument fixture |
| `[[x]] = mu(x)` | evaluated | every fixture |
| `[[x...]] = mu(x...)` | outside fragment | the table: a tuple variable is outside the fragment |
| `[[_]] = {<v> \| v in Values}` | evaluated | the anonymous-projection fixture |
| `[[_...]] = Tuples1` | outside fragment | the table |
| `[[{E1;E2}]] = union` | evaluated | the generated corpus's `;` disjunctions |
| `[[(E1,E2)]] = product` | evaluated | the generated corpus's `,` conjunctions |
| `[[E where F]]` | not parsed | nothing: the parser has no `where` |
| `[[[{x}]:E]]` higher-order abstraction | admission rejects | nothing: admission rejects it |
| `[[[c]:E]]` constant-headed abstraction | admission rejects | nothing: admission rejects it |
| `[[[x]:E]]` value abstraction | outside fragment | the table |
| `[[[x in r]:E]]` restricted abstraction | evaluated | the domain-restricted fixture, the generated corpus |
| `[[[x...]:E]]` | outside fragment | the table |
| `[[(Bindings):F]] = [[[Bindings]:F]]` | evaluated | the generated corpus's `exists` |
| `[[{E}[_]]]` column projection | outside fragment | the table |
| `[[{E}[_...]]]` | outside fragment | the table |
| `[[{E}[x...]]]` | outside fragment | the table |
| `[[{E1}[?{E2}]]]` first-order application | evaluated | every fixture, on the unannotated spelling |
| `[[{E1}[&{E2}]]]` higher-order application | not parsed | nothing: the scanner has no `&` |
| `[[reduce[&{E1},&{E2}]]]` aggregation | outside fragment | the table, through the surface-aggregation surrogate |
| `[[{()}]] = {<>}` true | evaluated | the true-formula regression |
| `[[{}]] = empty` false | outside fragment | the near-miss corpus's false-body shape |
| `[[{E}(Arg,…,Arg)]]` atom | evaluated | every fixture |
| `[[{E}()]]` nullary application | outside fragment | the rejection table |
| `[[F1 or F2]] = union` | evaluated | the disjunctive fixture, the generated corpus |
| `[[F1 and F2]] = intersection` | evaluated | every multi-atom fixture |
| `[[not F]] = complement` | outside fragment | the rejection table |
| `[[(F)]] = [[F]]` | evaluated | the generated corpus's parenthesized disjuncts |
| `[[exists((x) \| F)]]` | evaluated | the generated corpus |
| `[[exists((x in r) \| F)]]` | outside fragment | the near-miss corpus's restricted-exists shape |
| `[[exists((x...) \| F)]]` | outside fragment | the table |
| `[[forall((x) \| F)]]` | outside fragment | the rejection table |
| `[[forall((x in r) \| F)]]` | outside fragment | the table |
| `[[forall((x...) \| F)]]` | outside fragment | the table |
| `[[reduce(&{E1},&{E2},E3)]]` aggregation formula | outside fragment | the table, through the surrogate |

Fourteen equations are evaluated; seventeen are rejected as outside the fragment; two are rejected by
admission and two are not parsed. That is the same distribution as the lowering's column with the one
expected shift: the lowering records `[[not F]]` as lowered-into-the-IR-and-refused-by-the-backend,
and the reference evaluator, whose subject is the fragment the chain *executes*, records it as
outside the fragment. The three rows the lowering's table decides through a surrogate source rather
than the paper's own spelling — the `?` application and the two `reduce` forms, because the scanner
has no `&` or `?` token — are decided the same way here and are labelled as such, so the surrogate is
recorded rather than hidden.

## Surface constructs outside Figure 2

Figure 2 is `Expr`, `Formula`, `Argument`, `RelDef ::= def ID {Expr}` and `RelProgram`. The frontend
parses a great deal more. Every addition's disposition is a committed table row in
`tests/rel_reference_eval.rs`, decided by both sides, so this table is a test and a change of
treatment fails it.

| Surface construct | Outcome | How it is treated |
|---|---|---|
| `module M … end` | evaluated | flattened: a member becomes one relation whose name parts are the module chain's spellings and its own |
| `module M[k] … end` | evaluated | desugared: each module parameter becomes a leading column of every relation the module owns, bound in every body it owns |
| `M:x`, `M[a]:x`, `M:N:x` spines | evaluated | resolved to the member relation; the base resolves innermost owner first, and `[a]` supplies the leading columns explicitly |
| `M:x` from outside a parameterized module | `REL0501` | nothing supplies the leading columns, so the head carries an unbound variable |
| `x in D` parameter | evaluated | desugared: binds `x` and conjoins the positive literal `D(x)` with every rule of the definition |
| `@annotation` on an item | evaluated | dropped: the parser gives it its own node, which is neither a definition nor a module, so no pass reads it |
| doc string on an item | evaluated | dropped: the parser consumes it and emits no node |
| `value type …` | `REL0301` | rejected at the contextual spelling, before admission |
| `declare …` | `REL0301` | rejected at the contextual spelling |
| `entity`, `bound`, `ic`, `with`, `from` items | `REL0301` | rejected at the keyword |
| `^Entity` reference as a constant | evaluated | interned as a value of entity kind, keyed by its spelling including the caret |
| `def ^Person(x)` entity constructor | evaluated | an ordinary relation whose declaring spelling is the entity reference; the caret is dropped by name mangling |
| string, raw string, character and symbol literals | evaluated | interned as values of text kind, keyed by exact source spelling, so two spellings of one string are two values |
| string interpolation | `REL0504` | an interpolation node is not a constant, and the fragment has no expression evaluation |
| `if … then … else … end` | `REL0504` | rejected at the conditional |
| arithmetic operators | `REL0504` | no arithmetic literal exists in the relational IR |
| `implies`, `iff`, `xor`, override operators | `REL0504` | rejected at the operator |
| `def f[T](x)` specialization header | `REL0504` | rejected at the declared name: a bracketed header is second order |
| surface aggregation `sum[v: …]` | `REL0504` | the IR represents an aggregate literal, but no source form builds one and backend v1 refuses it |
| tuple variables and spreads `x...`, `_...` | `REL0504` | the fragment's tuples have a fixed declared width |
| `not` | `REL0504` | represented in the IR, range-restricted and stratified; backend v1 rejects it, so the gap is a recorded coverage row |
| comparison | `REL0504` | same treatment as negation |
| `forall` | `REL0504` | rejected at the construct |
| `exists(x in D: F)` | `REL0504` | a restriction inside a quantified formula needs its literal conjoined with that formula's body, which only a definition parameter gets |
| the `?` and `&` argument sigils | `REL0101` | the scanner has no token for either; a parser gap, not a lowering one |
| `where` | not parsed | one of the two Figure 3 equations that never reaches the lowering |

The two entries worth naming are the first two "dropped" rows. An annotation and a doc string are
*silently discarded*: the parser represents an annotation as its own node and emits nothing at all
for a doc string, and the lowering iterates the definition and module node lists, so neither is ever
read. That is a deliberate consequence of the node-list design rather than a decision anyone wrote
down, and the reference evaluator reproduces it because it scans the same pool for the same two node
kinds. It is now a recorded row rather than an accident.

## Differential results

**Corpora.** Every source is decided by both sides, and every disagreement is an assertion failure.

| Corpus | Programs | Verdicts |
|---|---|---|
| the eight committed milestone (a) fixtures | 8 | all accepted, and each closure also equals the committed Python oracle's |
| the milestone (a) audit's further programs | 6 | five accepted, one rejected for range restriction |
| the recorded rejection surface | 20 | all rejected, each with the recorded class |
| the Figure 3 and Figure 4 equations | 35 | 14 evaluated, 17 outside fragment, 2 admission, 2 not parsed |
| the surface constructs outside Figure 2 | 26 | as the table above |
| value kinds and formula forms | 12 | all accepted |
| the seeded in-fragment generator | 1,200 | 973 accepted, 227 rejected on a budget, 0 unadmitted |
| the seeded near-miss generator | 400 | all rejected: 248 outside fragment, 109 range restriction, 43 budget |
| the name-resolution templates | 120 | all accepted |
| closure-shape regressions | 5 | as described below |

**Seed and shape mix.** The corpus is a function of the seed `0x000c_1189_0915` alone, through
SplitMix64, so it reproduces across platforms. The in-fragment corpus's program shapes are 291 plain,
285 with a parameterized module, 282 with a free name, 205 with an unparameterized module and 137
with a ternary fact set. Its construct mix, counted on the emitted source text rather than assumed
from the generator's branches and gated against a floor, is `exists(` in 1,110 programs, `) or (` in
587, a wildcard argument in 587, `,`-as-conjunction in 649, `x in dom` in 505, a free name in 365,
`) ; (` in 359, a ternary read in 292, a parameterized member instantiation in 285 and a bare member
spine in 168. The near-miss corpus's shapes are 58 unbound head variables, 58 false bodies, 51
anonymous head columns, 51 nullary definitions, 51 restricted `exists` binders, 48 arity
disagreements, 43 five-column fact sets and 40 relation-names-in-term-position; each shape maps to
exactly one rejection class on both sides, which is why the class totals decompose exactly. The
name-resolution corpus's six templates appear 27, 22, 21, 19, 17 and 14 times.

**Three disagreements, all found, all diagnosed.**

### 1. A qualified spine's base resolved the top level before the module chain — repaired

`build::qualified` probed the top level first and then the module chain from innermost to outermost,
so inside a module a qualified base resolved to a top-level module of the same spelling ahead of the
enclosing module's own nested one. The module-scope contract
(`notes/2026-09-14-c1170-module-scopes.md`, rules 2 and 5) is innermost owner first for every bare
name, and a qualified spine's base is a bare name; semantic admission resolves it that way through
its own scope chain. So the lowering contradicted both the stated contract and the stage before it.
This is the same defect one function away from the `resolve_name` defect the 2026-09-15 vetting pass
of the lowering kernel candidates fixed, and it is the candidate I had found by inspection before
writing any code.

Minimal repro, and what each side said:

```
def e = {(1, 2)}
module N
  def f(x) = e(x, _)
end
module M
  module N
    def f(x) = e(_, x)
  end
  def g(x) = N:f(x)
end
```

The lowering gave `M:g` the closure `{(1)}` — the top-level `N`'s `f`, which projects the first
column — and the reference evaluator gave `{(2)}`, the enclosing module's own `N:f`, which projects
the second. Repaired in `19f9d71` by walking the chain from its innermost entry and probing the top
level last, which is the shape `resolve_name` now has. The fixture
`a_nested_module_shadows_a_top_level_module_inside_the_enclosing_module` in `tests/rel_lowering.rs`
asserts all three closures, and the differential's own
`a_nested_module_shadows_a_top_level_module_of_one_spelling` asserts them on both sides.

### 2. A variables-budget failure left a variable mapping behind — repaired

A rule with more variables than the contract admits exits `passes::project` through the variables
budget. The definition-local-to-rule-local map is a workspace pool that `Rir::clear` does not clear,
and the restore array was exactly as wide as the budget, so the assignment that *overran* the budget
wrote the map without recording the slot. A later lowering on the same workspace then numbered one
variable from the failed lowering's leftover mapping.

This one was found by construction rather than by the corpus, and the distinction is worth keeping
straight: the harness builds a fresh workspace for every source, so it would never have tripped the
leak. It surfaced because the reference evaluator has to reproduce `project`'s per-rule renumbering
to agree on the variables budget, and writing that mirror is what made the one unrestored slot
visible. Reading a pass closely enough to reimplement it is a second thing this task bought, beside
the differential itself.

The consequence is not a wrong closure — the leftover mapping gives one definition-local variable a
different rule-local index without colliding with another, so the program still means the same thing
— but it is a violation of something milestone (a) does claim: the lowering is a canonical function
of its input, and the parity record is the canonical bytes of the lowered program. The two
fingerprints for one source were `808080837157732095` after the failed lowering and
`15497456074870943325` from a fresh workspace.

Minimal repro: lower

```
def e = {(1, 2)}
def bad(a, b) = exists(c, d, f, g, h, i, j:
  e(a, b) and e(c, d) and e(f, g) and e(h, i) and e(j, j))
```

which is nine distinct variables in one rule, and then lower

```
def e = {(1, 2); (2, 3)}
def p(x) = exists(a, b, c, d, f, g, h, i: (e(x, a) and e(a, b) and e(b, c)) or e(x, i))
```

on the same workspace, whose second disjunct uses the ninth definition-local variable.

Repaired in `19f9d71`: the restore array is one slot wider than the budget, and `number` reports how
far the numbering got through a `&mut` so the failing path restores every slot it wrote, not only the
slots a successful path would have. On the success path the loop bound is the same variable count as
before, so no executed instruction on any accepted program changes. The fixture is
`a_variables_budget_failure_leaves_no_state_behind`.

**I then audited every other pool for the same class of leak**, which is the general claim the
one-off fix does not make. Of the pools `Rir::clear` does not clear, the stratifier's `edge_offsets`,
`components`, `component_stack` and `frames` clear or resize themselves at that pass's entry; the
build pass's `tasks` and `results` clear themselves at each definition's formula; the two
open-addressed indexes over values and relations are cleared in place by `Rir::clear` itself; and
`mangled_index` is sized and cleared by the only pass that writes it. The variable map was the one
pool whose restoration was a pass's own responsibility, and it is the one that leaked.
`the_lowering_is_a_function_of_its_input_alone`
(`bccb4e8`) now drives every rejection shape, every surface-construct row and a sample of both
generated corpora through one workspace and checks a nine-binder canary's canonical fingerprint after
each, so a future leak is caught wherever it is introduced.

### 3. Binarization builds an empty auxiliary, and the program is refused — reported, not repaired

A body of three or more positive atoms whose first two joined atoms share no variable with the rest
of the rule makes binarization compute an empty live set, so it declares an auxiliary relation of
arity zero; the contract has no nullary relation, so the closing pass refuses the whole program with
a `REL0503` naming the budget "relation arity" with `found` 0 and `limit` 4, and a span pointing at
the head's own spelling. The source is inside the stated fragment, is range-restricted, and has a
perfectly ordinary closure, which the reference evaluator computes.

Minimal repro and the exact diagnostic:

```
def e = {(1, 1); (2, 3)}
def g = {1; 2}
def p(x) = exists(y, z: g(y) and g(z) and e(x, x))
```

```
error[REL0503]: the lowered program exceeds a budget of the rule backend
  --> line 3, byte column 5
    3 | def p(x) = exists(y, z: g(y) and g(z) and e(x, x))
      |     ^ found `p`
  = note: relation arity: the program needs 0 and the backend admits 4
```

The cause is the join-order heuristic's own tiebreak. `order_positives` prefers the literal sharing
the most already-bound variables, then the one with *fewer* variables, then source order; with nothing
yet bound, the narrowest atoms go first, and joining two atoms whose variables nothing later needs
leaves a live set that the suffix mask empties.

**This is a real defect and not a property of the fragment**, and it is not rare: 227 of the 1,200
generated programs, a fifth of the corpus, are refused for exactly this reason. But repairing it is a
decision I should not take alone, so the disposition is *reported with the repair specified*:

- The narrow, exact repair is to widen an empty live set to one variable of the join —
  `aux(y) :- g(y), g(z)` instead of `aux() :- g(y), g(z)`, with the extra column projected away by
  the next link. It is exact, because the auxiliary is non-empty precisely when the two atoms are
  jointly satisfiable and the next link does not join on the kept column; it changes nothing for any
  rule that currently lowers, so no currently-passing parity case moves; and it is purely additive
  coverage.
- It does not cover the sub-case where *both* joined atoms are fully ground (`dom(1) and dom(2) and
  e(x, x)`), where there is no variable to keep. That conjunct is a nullary truth value the contract
  cannot represent, and the honest code for it is `REL0504` rather than a budget — which is a
  diagnostic decision, not a mechanical one.
- The broader repair — changing `order_positives` so that the tiebreak cannot create an empty
  intermediate — is a join-order policy change. It would move every binarized rule's recorded order
  and therefore the canonical fingerprint and the parity hash, and it sits inside the measured
  lowering stage. That is an architecture choice with downstream shape, so it needs your call and a
  measured A/B.

Meanwhile the reference evaluator mirrors the rejection, in the one function already labelled as
mirroring the lowering's strategy, so the differential stays total rather than carrying an
exception list; and `the_recorded_rejection_surface_agrees` carries the minimal repro, so the day the
repair lands that row changes and says so.

### Two further findings that are not disagreements

**Milestone (a)'s remaining gap 4 is wrong.** It records that "no program the positive fragment
admits can build a non-monotone cycle, so the stratifier's rejection path is exercised by its own
construction and not by a Rel source". A source can: the lowering represents negation,
range-restricts it and stratifies it, and only backend v1 rejects it, so a negative self-loop reaches
the stratifier first. `def e = {1; 2}` with `def p(x) = e(x) and not p(x)` is `REL0502` with the
negated literal as the primary span, and both sides say so; it is now a committed row of the
rejection table. `REL0502` therefore has a source-level fixture today, before milestone (b), and the
claim in the milestone (a) report should be corrected when that report is next touched.

**The `?` sigil row of the equation table has a defence the milestone (a) report did not make.** The
2026-09-15 audit noted that the `[[{E1}[?{E2}]]]` row is exercised by a plain application with no `?`
in it. The paper itself sanctions that: it says the annotations "can be dropped if the engine can
figure out whether the argument should be passed as first-order or as higher-order". The reference
evaluator's table records the row with that justification attached, so the surrogate is documented
rather than silently substituted.

## Gates and replay commands

Run from `~/src/ergodis-private`. Every gate was run under `nix develop ~/src/ergodis`, whose
devShell asserts its rustc equals the `rust-toolchain.toml` pin (1.95.0), so the gates and the code
describe one build.

```sh
# The milestone (a) gates plus the new test binary.
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

# One source end to end, for a minimal repro.
nix develop ~/src/ergodis --command cargo run --release -p ergodis-tools -- \
    rel-lower --source-file <path.rel>
```

Results, verbatim:

```text
rel_lowering:              28 passed; 0 failed
rel_frontend:              28 passed; 0 failed
rel_frontend_portability:   1 passed; 0 failed
rel_reference_eval:        14 passed; 0 failed
cargo clippy -p ergodis-private --lib --tests -- -D warnings:  exit 0
cargo clippy -p ergodis-tools --bins -- -D warnings:           exit 0
cargo fmt -p ergodis-private -p ergodis-tools -- --check:      exit 0
rel_closure_oracle.py:     8 fixtures agree with the committed expectations
portability.py:            213 cases, 433805 canonical bytes, native/WASM exact equality
```

The whole `rel_reference_eval` binary takes 1.4 seconds in a debug `cargo test`.

**Parity hash, before and after.** `04b5ebdd72fb08184f3143e3ca8393d207b9a6109c549e9806e1bfae02bb23b0`
at 213 cases both before and after the two production repairs. Only the receipt's source and library
hashes moved. No parity case has either repaired shape, which is the same situation the
`resolve_name` repair reported.

**Allocation gate.** `the_lowering_stage_does_not_allocate` passes unchanged. Neither repair
allocates: the widened restore array is a stack array of nine `u16`, and `number`'s `next` became a
`&mut` to a stack local.

**No performance A/B was run, and here is why.** Both repaired functions are in the measured lowering
stage, so this needs stating rather than assuming. The variable-numbering repair changes no executed
instruction on any accepted program: the restore loop's bound is the same variable count it was, and
the array is a stack array. The qualified-spine repair changes only the order in which a search loop
probes owners, and the C1190 kernel-candidates profile records `build::qualified` as "hot in
principle, never executed on any bench cohort", because the bench corpus writes its qualified forms
as symbol-keyed tuples rather than module member spines; the analogous `resolve_name` repair, which
*is* on a path the cohorts execute, measured as a wash at 1.00000 on `parse` and `admit` everywhere
and 0.9992 to 1.0001 on the lowering stage. If you want the receipt anyway, the control is
`ergodis-tools-b7c26e5` and the recipe is the milestone (a) replay block; say so and I will run it.

## Claims and how to check them

1. **Two independent implementations of the fragment agree on every source in the corpora.** Run the
   four test targets. `the_generated_corpus_agrees`, `the_near_miss_corpus_agrees` and
   `the_module_shadowing_corpus_agrees` compare verdicts and, for an accepted program, every visible
   relation's spelling, arity and decoded tuple set.
2. **The agreement is evidence about the lowering, not about one implementation compared with
   itself.** The reference evaluator has exactly two `use` lines: the standard library's two maps and
   `ergodis_private::rel_frontend::{Kind, Node, NodeKind, NONE}`. It reads the node pool through
   `Workspace::nodes` and touches no other part of the crate, so
   `rg -n '^use ' tests/rel_reference/mod.rs` is the whole check. The one deliberate exception,
   `binarization_budget`, mirrors the lowering's strategy from the contract's own bounds and is
   documented in place.
3. **The evaluator itself is supported three ways.** The committed Python oracle agrees with it on the
   eight milestone (a) fixtures, which makes those three implementations sharing only the source
   text; its own domain-enumeration path agrees with its join path on every program small enough to
   enumerate; and the 35 Addendum A equations are a committed table.
4. **Every certificate is accepted by both of the core's checkers, and both agree with the
   evaluator's rows tuple-wise.** Milestone (a) ran the ranked checker on the driver's programs only;
   the harness now runs both checkers on every corpus program and compares decoded tuple sets rather
   than counts.
5. **The lowering is a function of its input alone.** `the_lowering_is_a_function_of_its_input_alone`
   drives every rejection shape and a sample of both corpora through one workspace and checks a
   canary's canonical fingerprint after each.
6. **Nothing is approximated on either side.** Every construct outside the fragment is a rejection
   with a class, and the surface-construct and equation tables fail if any outcome moves.

## Mystery ledger

1. **Why does a fifth of the generated corpus hit the empty-auxiliary bound?** *Settled by the
   `ej`/`tt` pass.* It is not a corner case reached by an unlucky generator: the join-order
   heuristic's "fewer variables first" tiebreak actively creates the empty intermediate whenever a
   body has three or more atoms and two of them are narrow and unrelated to the rest, which is a
   common shape. The evidence gap that remains is not about the cause but about the repair, which is
   yours to pick: the narrow widening, or the policy change that moves the parity hash. Owner: a
   successor task in this lane.
2. **Why did the variable-map leak never show up in milestone (a) or its audit?** *Settled, and the
   answer applies to this harness too.* Every existing test and the audit driver use a fresh
   workspace per source, so nothing ever lowered a valid source after a failed one on the same
   workspace — and neither does this differential, which also builds a fresh workspace per side per
   source. Nothing anyone had written would have caught it; it took reading the pass closely enough
   to reimplement its numbering. That is why the repair ships with a gate that reuses one workspace
   deliberately, rather than with a note.
3. **How much does the differential's agreement actually certify?** *Partly settled, and the residue
   is stated rather than closed.* The two sides share the scanner, the parser and semantic admission,
   so a defect in any of those three is invisible to this differential by construction. Those stages
   have their own evidence — the native/WASM parity replay over 213 cases and the 2026-09-15
   admission-chain audit — and this task adds nothing to it. What the differential does certify is
   the lowering, backend v1, the demand-driven evaluator and both checkers.
4. **Which parts of the fragment does the corpus still under-test?** *Open, with the exact gaps
   named.* Relations of arity four, domains larger than four values, module nesting deeper than two,
   more than one module at one level, several `def` clauses of one fact set, and the "not
   stratifiable" and "disjunction bound" classes, which have one fixture each and no generated
   coverage. None of these is hard to add; none was needed to find the three disagreements. Owner:
   whoever extends the corpus, most naturally the milestone (b) task, which will want generated
   negation anyway.
5. **Why do both sides agree on the rejection *class* but not on the budget *name*?** *By design, and
   recorded.* The lowering names one of sixteen budgets; the reference evaluator mirrors only the
   five that the fragment's own bounds imply and reports the rest as one class. Comparing budget
   names would be a stronger test and would have caught the empty-auxiliary case as a *mismatch*
   rather than as a mirrored agreement. Open as a cheap upgrade, not taken here because the mirror
   already makes the verdicts total.

No other feature of the result is surprising or unexplained.

## ej/tt closeout

**Cheap upgrades taken.** The checker's replay is now compared tuple-wise instead of by count. The
ranked certificate and its checker run on every corpus program instead of on the driver's handful.
The one-off variable-map fixture was generalized into a workspace-purity gate after auditing every
pool for the same class of leak. The generated corpus now counts which constructs it
actually writes and gates each against a floor, so a probability that drifts to zero cannot silently
empty part of the corpus. The two rejection classes the table was missing — nine variables in one
rule and the disjunction-expansion bound — are now differential rows. The domain-enumeration
evaluator was added as a second, more literal reading of Figures 3 and 4 and checked against the join
evaluator.

**Doors this opens.**

1. **Milestone (b) gets its acceptance gate for free.** The evaluator already carries negation and
   comparison through range restriction and stratification and rejects them only at the last check,
   the one that mirrors backend v1. Milestone (b) removes that check on both sides, adds per-stratum
   evaluation to the naive side, and turns on generated negation — and then the stratified fixed
   point has a differential oracle from its first commit rather than after the fact. That is the
   highest-value use of this work and it is why the evaluator was structured this way.
2. **The empty-auxiliary finding prices the join-order work.** A fifth of a random in-fragment corpus
   refused is a much stronger argument for revisiting `order_positives` than "the heuristic is
   simple", and it comes with a measurable acceptance-rate target.
3. **The surface-construct table is the coverage manifest's missing companion.** The manifest records
   `parsed`, `admitted`, `lowered`, `executed` and `certified` per construct family; the table
   records *how* each construct outside Figure 2 is desugared, dropped or refused, which is the part
   a reader of the manifest currently has to reconstruct from the code.

**Candidates to queue** (no IDs allocated):

- Repair the empty binarization auxiliary: the narrow widening plus a decision on the fully-ground
  sub-case's code. Needs your call on which repair, and an A/B if the policy route is taken.
- Correct milestone (a)'s remaining gap 4: `REL0502` is reachable from a source and now has a
  fixture.
- Extend the differential to milestone (b) as its acceptance gate, with generated negation and
  stratified evaluation on both sides.
- Compare budget *names* rather than the single budget class, which is the stronger version of the
  verdict comparison.
- Add a parity case for each of the two repaired resolution-order shapes. Both were deliberately left
  out here because adding one moves the canonical parity hash, which should not happen on a repair
  commit.

## Vibe check

Good, and the differential earned its keep on the first run. Three disagreements, three diagnoses,
two repaired with fixtures and a parity hash that did not move, and the third one is a coverage gap
worth a fifth of a random corpus whose repair is specified and waiting on one decision from you. The
one soft spot is that the corpus is broad but shallow in a few named places, and the evaluator
mirrors the lowering's binarization strategy in one function so that the verdicts stay total — both
recorded rather than hidden.
