# C985 Ergodis campaign-control spike

**Date:** 2026-08-30. **Lane:** complete-ports. **Status:** experimental v0
implemented and exercised; no solver-authoritative rule promoted.

## Outcome

The optional theorem-campaign vertical slice is now real. Ordinary Ergodis
library and CLI solves do not link or enter it. Enabling `control-plane` adds
separate `ergodis-campaign` and `ergodisctl` binaries, a presized feature-batch
representation, a bounded typed postfix VM, per-run Unix-socket isolation,
epoch-atomic diagnostic-plan activation, a file-backed attack ledger, compact
agent briefs, localized file traces, batched/evolutionary proposal evaluation,
exceptional-state ranking, exact feature-sufficiency ceilings, and a bounded
decision-tree proposer. Author plans now have an SMT-LIB-inspired typed prefix
tree that lowers to the same validated postfix VM; the explicit postfix form
remains the stable replay/debug IR. Executable hashes exclude display names, so
renaming an attack cannot manufacture a distinct replay identity.

The first live-adapter boundary is also present: a constant-size unchanged
`pulse` is polled only at a solver safe point; a changed epoch returns bounded
plan identities, and each lowered plan can be fetched only against that exact
epoch. Activation and deactivation are epoch-atomic. A solver can therefore
compile into an inactive preallocated arena and swap at a later safe point,
without socket checks, JSON, or allocation in the node loop. No domain solver
consumes this boundary yet. A real C880 socket exercise observed unchanged
epoch 0, activated the exact 11/11 marginal-saving predicate at epoch 1,
fetched its lowered plan against epoch 1, rejected a misspelled plan identity,
deactivated it at epoch 2, and returned an empty changed snapshot.

Implementation commits are `07cc0ebe2`, `b1c4dd052`, and `3a30a24e6` plus the
current follow-up. Operator documentation is in
`papers/complete-repair-ports/ergodis/docs/CAMPAIGNS.md`.

## Architecture after real use

The first monolithic control module became unwieldy during the same session,
confirming the anticipated refactor pressure. It is now a subtree:

```text
src/control/mod.rs          controller, ledger, bounded query model
src/control/vm.rs           feature batch, typed bytecode, evaluator
src/control/synthesis.rs    iterative bounded decision-tree proposer
src/bin/ergodis_campaign.rs isolated campaign process
src/bin/ergodisctl.rs       human/agent CLI and unattended batch/evolve loop
```

Transport and ledger extraction are the next structural refactors if their
surfaces continue to grow. The core solver modules remain independent.

## C80 results

The existing q11/q13 K_Omega admission scout gained an opt-in streamed feature
sidecar. Re-running the full retained protocols produced 37,292 q11 and 33,596
q13 reply rows (70,888 total, about 5.7 MB JSONL) while both original aggregate
certificates remained byte-identical at their retained SHA-256 hashes.

The first two hand predicates were not perfect on the mixed labels. A bounded
three-generation run tested 192 mutations but found only 24 distinct truth
vectors. Its best rule was

```text
next_defect_rank == 0 && omega_drop > 0
```

with 70,728/70,888 correct, zero false positives, and 160 false negatives. The
first exact miss was q13 with next defect rank 6, support surplus 20, and Omega
drop 102. The obvious support-surplus disjunction repaired all misses but added
21,782 false positives.

The exact feature-ceiling query found 993 distinct feature vectors, no
opposite-label collisions, and therefore zero unavoidable errors from this
feature vocabulary. A direct obstruction-led proposal then found the sampled
identity

```text
survivor reply
iff
Omega descends and next defect rank is 0 or 6.
```

It agrees with all 70,888 retained rows: separately 37,292/37,292 at q11 and
33,596/33,596 at q13, with 23,000 and 10,428 positive replies. This is a new
diagnostic hypothesis, not a uniform theorem. A first q17 hostile extension was
inconclusive rather than confirmatory: 30 sampled states and 3,001 complete
exchanges produced no new-defect rows and no sampled state in `K_Omega`, so the
feature sidecar contained only its header. The `{0,6}` shape therefore remains
supported exactly on q11/q13 and wholly untested at q17; the next q17 probe must
target the rare survivor stratum instead of increasing an unguided sample.

The bounded tree proposer gave 27 nodes/66 VM operations and 70,746 correct on
the combined corpus. Holdout made its status clearer: training only on q11
learns the 3-node rank-zero rule, which is exact on all q11 rows and misses the
same 160 q13 positives. A q13-trained 41-node tree remains perfect on q11 but
has 140 q13 false negatives. The direct obstruction-led `{0,6}` rule is both
smaller and exact on the retained corpus, illustrating why the agent remains a
useful proposer above automated search.

## C880 and small controls

The C880 adapter compiles eleven retained marginal attachment instances into a
mixed strict-saving task. The exact rule `marginal_cost < naive_cost` classifies
all eleven; grouped output shows equality for new-point counts one/two and
strict savings for the sampled counts three through five. The feature ceiling
is exact, and a three-node tree recovers the same split. An exceptional hardness
score identifies the 224,947,066-node `(m,k,j)=(7,2,5)` instance first, followed
by the 16,204,232-node `(8,4,4)` instance. These are workflow controls, not new
C880 mathematics.

Small tests cover malformed and ill-sorted bytecode, source-expression
lowering, simultaneous isolated campaigns and cross-run rejection, the
disjunctive C80 shape, and zero allocation across 10,000 compiled-VM row
evaluations. The full pre-existing C80 certificates are the independent domain
replay gates. The prefix source spelling of the `{0,6}` shape lowers client-side
and reproduces the same exact 70,888/70,888 grouped result.

## Token and evidence economics

The live C80 session required short summaries rather than raw rows:

- 111 syntactic candidates collapsed to 8 output classes in the aggregate
  experiment;
- 192 mixed-label candidates collapsed to 24 classes;
- each decisive obstruction was one bounded row;
- one rigid equality profile was selected with multiplicity 234 and traced in
  five VM records / 456 bytes;
- the complete 70,888-row corpus stayed file-backed.

This is already substantially more token-efficient than repeated ad hoc script
edits and transcript inspection. The controller can run batch/evolve/synthesis
unattended and an agent reconnects at a feature collision, first obstruction,
new best class, or exhausted gate.

## Debt-ledger boundary

Debt coordinates fit as typed domain features, not controller prose. A live
adapter should update compact thread-local debt state and expose only bounded
safe-point summaries. `exceptional` ranks top-K debt/rigidity states; `trace`
opens one exact row. The C80 overload/Tutte bank is retained as a hostile
lesson: filtered deficiency two was recursive certificate debt, not game debt.
All v0 plan roles are diagnostic or ordering, preventing such a coordinate
from silently becoming a proof-authoritative prune.

## Next gates

1. Construct or import q17 `K_Omega` survivor states, then replay the `{0,6}`
   rule and extract its first mismatch if any; unguided random states do not
   reach the relevant stratum at useful density.
2. Consume the pulse/snapshot protocol from one genuinely long C80 or C880
   search; the transport boundary alone does not test mid-search steering.
3. Persist controller checkpoints so restart preserves the last validated
   epoch and active plan hashes.
4. Split transport and ledger modules after the next surface change, not before
   it earns the boundary.
5. Add proof handles and hostile-corpus gates before any necessary/sufficient
   role exists.

## Vibe

The spike crossed the line from dashboard design to a useful theorem-search
instrument. Its strongest output is not the socket; it is the fast loop from a
160-row obstruction class to a perfect 11-operation sampled law, with exact
mixed-field replay and essentially no conversational data exhaust.
