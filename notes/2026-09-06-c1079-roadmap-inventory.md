# C1079 — existing roadmap and promotion evidence

**Lane**: `ergodis`
**Date**: 2026-09-06
**Scope**: bounded read-only collection; reported historical capabilities are not revalidated here.
Source snapshot: Othello `dcd6f2769e58a7b782285bffd95023c7c7f4cd24` (sources below unchanged
by the subsequent C1079 administrative commit). No builds or new literature searches.

## Findings for synthesis

1. Autonomy is already explicit in the C985 proposal/admission architecture, not a newly added
   ambition. `notes/2026-09-01-c985-evolve-proposal-admission-architecture.md:98` describes a
   standalone built-in proposer and ledger, with interactive steering layered on top; line 232
   calls for autonomous built-in evolution while an LLM thinks. Lines 9–28 separate untrusted
   proposal, normalization, exact replay, role-specific admission, persistent artifact, and
   compiled consumer. Line 607 explicitly identifies feature/theorem proposals as discovery
   beyond parameter tuning. These are architecture statements; inspect code before calling
   the whole sequence implemented.
2. The promotion survey explicitly proposes separate origin labels: `evolved`, `human-fed`,
   and `theorem-derived`, plus scoped typed feature DAGs, version transitions, and replay
   (`notes/2026-09-02-ergodis-private-to-core-promotion-survey.md:82`). Lines 74–76 propose
   counterexample-driven campaign version transitions without mutating frozen presentations.
   Lines 77–81 propose a typed theorem registry with canonical semantics and independent
   reconstruction. These September 2 proposals need comparison with current code.
3. A concrete reason to avoid greedy quotient selection is recorded at survey lines 88–92:
   support size, evaluation cost, scope size, and downstream compatibility require a Pareto
   frontier; the recorded q87 `f110`/`f248` tie motivates it. This is a pointer to existing
   experimental evidence, not an independently checked finding in this collection.
4. The same survey already separates reusable machinery and domain-specific adapters.
   Lines 53–59 identify proof-status contracts, sparse-defect synthesis, symmetric features,
   and blind/planted admission harnesses; lines 96–109 retain Hadamard task modules, adapters,
   registrations, and structural proof spikes privately. Convergence need not mean moving
   all sources into the core; any proposed promotion must obey the existing dependency rule.
5. The roadmap memo records existing niches and theorem composition but missing benchmark
   closure (`notes/2026-09-02-ergodis-roadmap-vs-external-sota-memo.md:31`–36). Lines 64–71
   reiterate proposer nonauthority and reject a generic verified bit. Its blanket statement
   that proposals cannot prune before admission needs explicit qualification by search mode
   in the synthesis: exact negative coverage and heuristic exploration have different
   obligations. This is a potential terminology/scope conflict, not evidence of a code defect.

## Existing queued and closed evidence gates

Lane-scoped queue query at the source snapshot identified C1040 (AlphaEvolve corpus), C1041
(blind FunSearch discovery), C1045 (unchanged cross-instance transfer), and C1046 (composition
from sealed features). All are queued; do not describe these benchmark programmes as completed.
C1045/C1046 point to C1039 as their prerequisite. The exact C1039 archive row at
`notes/2026-07-07-codex-task-queue-archive.md:5530` reports a completed planted admission
experiment (one sound predicate admitted, 620 unsound rejected, 1,120 screened). Those numbers
are the archived report’s claims, not new measurements or a general autonomy result.

## Remaining collection gaps

The core and private inventories own current implementation checks; the C985 research inventory
owns the deeper design/research chronology. This note neither chooses a new architecture nor
closes C1079. The next synthesis must separate origin, validation scope, run mode, and achieved
search result, and must mark each mechanism implemented, experimentally demonstrated, or proposed.
