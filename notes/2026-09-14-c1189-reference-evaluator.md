# C1189 — reference evaluator for the lowered Rel fragment

**Lane**: `ergodis`
**Date**: 2026-09-14
**Status**: QUEUED, gated on the start of Rel lowering (the C1170 successor). Grows with it.

## Goal

A test-only, naive, set-based evaluator for exactly the fragment the lowering accepts, used as
a differential oracle against the lowered Ergodis rules and against the demand-driven
evaluator's certificates on shared inputs. It turns each "semantics adopted" prose contract in
the C1170 reports (module visibility, module parameters as binders, arity, free names admitted
as external base relations) into executable tests. It is outside the performance contract.

## Contract

The published formal semantics: Aref et al., *Rel: A Programming Language for Relational
Data*, arXiv:2504.10323 (literature cache key `arxiv:2504.10323`, sha256
`6e1371160602b1df77d9e5a647369bcd747aec3e8a97e36d2e99f04c219194b6`), Addendum A.

- **Figure 2** gives the core grammar: `Expr`, `Formula`, `Argument` (`_`, `_...`, `ID...`,
  `?{Expr}`, `&{Expr}`), `RelDef ::= def ID {Expr}`, `RelProgram`. It is far smaller than the
  surface syntax the frontend parses: no modules, annotations, entities, strings or doc strings.
- **Figure 3** gives expression denotations over an environment: constants, identifiers,
  tuple variables, wildcards over `Values` and `Tuples1`, union `;`, product `,`, `where`,
  the binder forms `[{x}]:`, `[c]:`, `[x]:`, `[x in r]:`, `[x...]:`, application by `_`,
  `_...`, `x...`, `?{Expr}` and `&{Expr}`, and `reduce`.
- **Figure 4** gives formula denotations: `{}`, `{()}`, application, `and`/`or`/`not`,
  `exists`/`forall` over first-order bindings, and the `reduce` formula form.
- Data model: `Values`, first-order tuples and relations, second-order tuples and relations
  (`Rels2 ⊇ Rels1`); programs may compute in `Rels2` but output only `Rels1`; relations may
  mix arities.
- `?` and `&` disambiguate first-order from higher-order arguments; an application that both
  readings accept is an error, not a union.

## What the paper leaves open

Program semantics is sketched only: "much like recursive Datalog", a dependency graph
stratified by non-monotonic operators, consistent with stratified Datalog, and non-stratified
programs are allowed without a stated construction. The evaluator must record the choice the
lowering makes here (which programs are admitted, which fixed point) as its own stated
contract, not as a paper claim.

`Values` and the `[x]:` / `_` quantifications are infinite. The evaluator computes on a finite
active domain and states range restriction as its safety condition; an expression that is not
range-restricted is rejected, not approximated.

## Deliverables

- The evaluator, its fixtures, and the differential harness (lowered rules and demand-driven
  certificates versus the evaluator on shared inputs).
- A table mapping each Figure 3/4 equation to its test.
- A recorded list of surface constructs outside Figure 2 and how the lowering desugars or
  rejects each one.
- The frontend coverage manifest gains the paper as a reference beside the pinned editor
  grammar.

## Not in scope

PLT Redex, tree-sitter, any Rel conformance claim, any performance claim.

## Origin

Tavis, 2026-09-14, during the C1170 syntax-gap work; the paper pointer followed the
allocation.
