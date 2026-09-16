# Ergodis Datalog programme review and next-step allocation

**Lane**: `ergodis`
**Date**: 2026-09-16
**Scope**: where the rule-contract programme (`2026-09-12-ergodis-rule-contract-programme.md`)
stands after C1160–C1191, measured against its stated goal, and which next steps were allocated.

## The goal, restated

Recursive exact optimization with a declarative rule input, a termination guarantee and a
certificate, targetable by an external compiler, measurably faster than the tools that
compiler's author would otherwise use.

## What is delivered

| Programme piece | State | Evidence |
|---|---|---|
| Contract, stability, Lean convergence, Lean oracle, generic carrier (steps 1–3b, 6–7) | complete | C1160–C1168, C1174, C1172–C1177 |
| Demand-driven Boolean evaluator, certificates, two checkers on direct stores, presence bitmap | complete | C1182–C1184, C1186 |
| Speed on hand-built two-atom Boolean rules | 0.11–0.20 of compiled Soufflé wall at large N, with a certificate Soufflé lacks | C1182 |
| Certificate size: format decided, not implemented | measured | C1185 |
| Owned Rel frontend: scan, parse, admit, diagnostics, native/WASM parity | complete, micro-optimization paused by Tavis | C1170 |
| Lowering end to end: positive fragment, stratified negation and `forall`, per-column domains, `count`/`min`/`max`/`sum`, comparisons | complete and audited | C1190 milestones (a)–(c) |
| Differential oracle | complete | C1189 |
| Direct constructor, encoding ceiling removed | complete and audited | C1191 |

## What the goal still lacks, in EV order

1. **Reach.** The direct-addressed join index caps every binary relation at a domain of 4,096 and
   every ternary one at 256 (`MAX_INDEX_KEYS`), whatever the relation's size; it now also decides
   the negation reach on half of C1191's cohorts. No real workload fits under it. → **C1192**.
2. **Join engine (programme step 4).** Bodies are two atoms; the lowering materializes every
   longer body through auxiliaries. Soufflé plans n-ary joins. → **C1193**.
3. **Optimization from source.** The Rel path reaches only the Boolean carrier; term-level
   arithmetic is refused and the min-plus carrier is "structurally deferred". The optimization half
   of the goal is unreachable from a program. → **C1194**.
4. **The product-path claim (programme step 5).** The only comparison is on hand-built programs fed
   to the evaluator directly; nothing measures source → certificate on negation/aggregation programs
   beyond the old ceiling. → **C1195**, after C1192; min-plus rows after C1194.
5. **Certificate bytes.** JSON certificates are 5–25× the output; C1185's decided encoding is
   unimplemented, and it is a measured row of the suite. → **C1196**.

Queued and unchanged: C1188 (derivation-loop `memmove`), C1148 (certificate interoperability),
C1180/C1181, C1156/C1157. Unallocated and deliberately left so: the `lower::run` kernel profile
(two unattributed swings), the layer memory model (C1191 gap 4), the coverage rows
(`exists(x in D: F)`, `not (F and G)`), the key-indexed rank structure, the bit-parallel dense
closure kernel, the C1176 decisions that are Tavis's (identity/ownership redesign, evaluator
policy, `Invariance` ABI code), and the Macready-gated workload reshaping.

## Two hygiene notes

- The queue row for C1170 still reads `[IN PROGRESS]` while the lane handoff records the frontend
  closed with micro-optimization paused; it should be closed through the lifecycle conventions or
  its row retagged to name the paused candidates. Left for Tavis's call.
- The programme table's steps 4 and 5 are now C1192/C1193 and C1195 and are marked so.

## Recommended order

C1192 → C1193 and C1194 in either order (independent) → C1195 → C1196 whenever a build window
allows; C1188 can be folded into C1192's derivation-loop work if the same loop is open.
