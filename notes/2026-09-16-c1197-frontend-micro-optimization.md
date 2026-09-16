# C1197 — Rel frontend micro-optimization follow-up

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: QUEUED — LATER. C1170 follow-up; paused by Tavis on 2026-09-14 in favour of
end-to-end features. Resume only when explicitly selected.

## Candidates, priced in the C1170 reports

All against the frontend control current at resumption (as of allocation `ergodis-tools-e0e7331`,
rustc 1.95.0; retain a fresh control first if the pin or the tree has moved).

1. `admit::insert`'s repeated-spelling shadow-flagging walk (about 35 instructions per symbol,
   half the module-scope admission cost; the only remaining quadratic in the frontend, half the
   composed stage on `datalog`) — `2026-09-14-c1170-module-scopes.md`,
   `2026-09-15-c1190-lowering-kernel-candidates.md`.
2. The `Apply`-site spills of the inlined `admit::reference`, and pricing `is_builtin`'s
   out-of-line first-sight call — `2026-09-14-c1170-inline-reference.md`.
3. The source bounds check inside the spelling hash and comparison loops; `same()`'s bounds
   checks; the pop's field loads; the nine-store `Value` push; `qualified`'s linear module scan —
   kernel-candidates and inline reports.
4. The larger untaken lever: a feature-presence prepass that monomorphizes the scanner on the
   lexical features a source contains (no per-token interpolation guard on sources without
   interpolation) — `2026-09-14-c1170-syntax-gaps.md`.
5. The outstanding evidence gap, not a speed item: a bench corpus variant with shadowed spellings
   and member spines, so the level-aware resolution paths execute on a cohort and not only in the
   parity cases — `2026-09-14-c1170-module-scopes.md`.

## Method

Per `PERFORMANCE.md` and the playbook: Fermi from the compiled loop, census where a per-unit model
exists (`2026-09-14-c1170-admission-census-db47ee1.md`), interleaved A/B with the non-multiplexing
event set, parity hash unchanged, keep-or-revert by commit, report with Mystery ledger.
