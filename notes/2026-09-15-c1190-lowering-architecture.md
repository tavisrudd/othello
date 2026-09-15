# C1190 — lowering architecture: a relational IR between Rel and the rule contract

**Lane**: `ergodis`
**Date**: 2026-09-15
**Status**: adopted design for C1190 (Tavis: take the card's recommendations, plan ahead
architecturally). Decision record: private `docs/adr/0004-rel-lowering-ir.md`. Task card:
`2026-09-15-c1190-rel-lowering.md`.

## The constraint the design answers

The core rule contract (`ergodis_verify::rule_contract`, schema `finite-min-plus-rules.v1`) is
narrow on purpose: rules with one or two positive body atoms, variables over one declared finite
`u32` domain, Boolean or bounded min-plus carrier, symmetries, grounding budgets, and a
source-bound certificate the checker replays. The demand-driven evaluator (`crates/rules/demand`)
takes that same `Program`, direct-addresses `domain^k` indexes, and derives with a certificate.
Rel is not that: typed literals, n-ary conjunctions, disjunction, existentials, negation,
aggregation, arithmetic, modules. If the lowering targets the contract directly, every later
feature reopens it. So the lowering targets an owned intermediate form, and the contract is one
backend projection of it.

## Three layers

```text
admitted node pool (rel_frontend::admit)      -- C1170, unchanged
        |  lower::build            zero-allocation, pools sized from Admission counts
Relational IR (RIR)                           -- private, compact, typed, stratum-aware
        |  passes (in place)       flatten, distribute, project, range-check, stratify, binarize, close domain
RIR, normalized
        |  backend::rule_contract  the one allocating boundary: Program, dictionary, readout map
rule_contract::Program  ->  Demand::new  ->  Evaluation + certificate  ->  verify
```

### Relational IR

Plain `#[repr(C)]` pooled records with asserted strides, indices not pointers, presized from the
`Admission` counts (definitions, modules, base relations, binders, references, applications) plus
a bounded expansion factor for distribution and binarization that the workspace `Limits` declare.

- **Relation**: spelling span, flattened name id (module chain joined, see passes), arity `u8`,
  kind (`Input`, `Derived`, `Auxiliary`), stratum `u16` (filled by stratification), column type
  vector index. Column types exist from day one even though backend v1 collapses them into one
  domain; they are what per-column domains and typed readout will consume.
- **Rule**: head literal, body literal range `[first, last)`, origin definition node, disjunct
  index (which `;` branch produced it), stratum.
- **Literal**: relation id, term range, `sign`: `Positive`, `Negative`, `Comparison(op)`,
  `Aggregate(slot)`. Milestone (a) emits only `Positive`; the other three are represented, checked
  by the range-restriction pass, and rejected by backend v1 with `REL05xx`. They are not stubs: the
  stratifier already treats `Negative` and `Aggregate` as non-monotone edges.
- **Term**: `Var(u16)` (rule-local variable index), `Const(dict id)`, `Wild`. Variables are
  numbered per rule after projection; the binder pool of admission gives the initial numbering.
- **Value dictionary**: typed literal table (`Int(i64)`, `String(span)`, `Entity(span)`, later
  `Float`, `Date`) → dense id, with a per-type sub-range so a column type can later select its own
  domain. Interned by hash into a presized open-addressed table, the same shape as admission's
  symbol probe.

### Passes, each a bounded in-place traversal

1. **Flatten modules.** A definition owned by module chain `M:N` becomes relation `M:N:x`; module
   parameters become leading columns of every relation the module owns, and a member reference
   `M[a]:x` becomes an atom with `a` in the parameter column. This is where the two shadowing
   directions that admission cannot distinguish (2026-09-15 audit) become distinguishable, and
   the fixture the audit could not build lives here.
2. **Distribute disjunction.** `;` inside a body becomes one rule per disjunct, disjunct index
   recorded for diagnostics. Nested `;` under `,` distributes with a declared expansion bound;
   exceeding it is `REL05xx Budget`, not an approximation.
3. **Project existentials.** Anonymous and `exists`-bound variables that appear only in the body
   stay body-local; the pass verifies each is bound by a positive literal.
4. **Range restriction.** Every head variable, and every variable in a `Negative`, `Comparison`
   or `Aggregate` literal, must be bound by a positive literal of the same rule. Violation names
   the variable and its span (`REL0501`).
5. **Stratify.** Dependency graph over relations, edges signed by literal sign; Tarjan SCCs with
   the explicit stack the traversal already owns; a non-monotone edge inside an SCC is
   `REL0502 NotStratifiable`; otherwise strata are the SCC condensation order. In milestone (a)
   every edge is positive and the result is one stratum, but the pass is complete now.
6. **Binarize.** A body with more than two positive literals becomes a chain through `Auxiliary`
   relations (`x_1 = L1 ⋈ L2`, `x_2 = x_1 ⋈ L3`, …), each auxiliary carrying exactly the variables
   live in the remaining chain. Join order: left-deep by the variable-sharing heuristic
   (bound-variable count, then smaller relation first when the arity is known); recorded per rule
   so a later cost-based order is a policy swap, not a rewrite. Auxiliary relations belong to the
   head's stratum.
7. **Close the domain.** The dictionary size becomes `Program.domain`; a rule that references a
   constant is checked against it; input relations gain their facts from the dictionary-encoded
   source facts. The backend's `MAX_SCALARS`, `MAX_PRODUCTS` and direct-addressed `domain^k` budgets
   are checked here and reported as `REL0503 Budget` with the numbers, before anything is built.

### Backend v1: the rule contract

The only allocating step: build `rule_contract::Program` (schema `finite-min-plus-rules.v1`,
carrier `boolean` unless the source declares min-plus, `stability 0`, no symmetries) from the
normalized RIR, plus a **readout map** (relation name id and dictionary) that decodes derived
tuples to typed values. `Demand::new` then evaluates; the derivation certificate goes through the
core checker; the differential harness (C1189) compares the decoded closure. Auxiliary relations
are filtered from readout but kept in the certificate, since they are part of what was proved.

A later direct constructor from RIR into `Demand`'s prepared form, skipping the serde `Program`,
is the planned removal of the boundary allocation; it is not milestone (a) work.

## How the later milestones land without reopening this

- **Stratified negation (milestone b).** Planned route: per-stratum projection. Stratum `i`'s
  closure is materialized; a `Negative` literal over relation `R` in stratum `i+1` becomes a
  positive literal over the complement relation `R̄`, whose facts are the finite-domain complement
  of `R`'s closure restricted to the range-restricting positive literals' columns (the range
  restriction pass already guarantees those columns are bound). Each stratum is one contract
  `Program` with its own certificate; the chain of certificates plus the complement construction
  is the evidence. This keeps the core contract and the Lean-audited convergence bound untouched.
  The alternative, a `Negative` atom kind in the core `Rule` with a stratum order, is recorded as
  the route to take if complement facts are measured too large; the RIR is the same for both.
- **Aggregation and arithmetic (milestone c).** `Aggregate(slot)` literals are also stratum
  boundaries; the aggregate is computed over the materialized closure into a new input relation
  with the result value interned into the dictionary. `count`, `min`, `max` and `sum` over ints
  need no new carrier on this route; min-plus costs are the one aggregate the core evaluates
  natively and the backend selects that carrier when the source's aggregate is a min over sums.
  Arithmetic comparisons on bound variables are evaluated at binarization time as a filter
  literal between chain links; unbounded arithmetic in heads stays rejected.
- **Per-column domains.** The RIR carries column types now; backend v1 uses one global domain.
  When the `domain^k` addressing becomes the budget that binds, the core extension is per-column
  domains in `Relation`, and only the closing pass and the backend change.
- **Symmetries.** The contract's declared permutations are unused by v1; the RIR reserves a
  symmetry table per program so source-declared or discovered symmetries can be forwarded later.

## Diagnostics

`REL05xx` is the lowering family: `0501` unbound variable (range restriction), `0502` not
stratifiable, `0503` backend budget with the numbers, `0504` construct outside the backend's
fragment (negation, aggregation, arithmetic, higher-order application), `0505` disjunction
expansion bound. Every rejection carries the primary span (the literal or variable) and the
secondary span (the definition head), through the existing `SemanticFailure` path, and the
error-only reparse renders it. Nothing is approximated; a rejected program is not lowered.

## Performance contract

Lowering is its own measured stage after `admit` in the driver, with allocation-count regression,
kernel-scoped call-free profile, presized pools from `Admission` plus declared expansion bounds,
and an A/B against `ergodis-tools-e8b4c7c` showing parse and admission unchanged. Fermi before
code: the census's per-visit and per-reference costs bound the traversal passes; binarization is
priced per body literal. The backend boundary is measured separately and reported as the
allocating step it is.

## Milestone (a) acceptance

Source → parse → admit → lower → `Demand` → certificate → verify on native and WASM; positive
Rel fragment (conjunction, disjunction, existentials, constants, modules, free names as inputs);
every out-of-fragment construct rejected with its `REL05xx`; C1189's evaluator agrees on the
shared inputs; parity corpus carries the lowered program hash per case; stage cost measured;
the per-equation fixture table for Figures 3–4 of arXiv:2504.10323 covers the fragment.
