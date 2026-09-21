# C1196 — rank runs and the round-block certificate encoding in core

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: QUEUED. Ranked fifth among the Datalog programme's next steps
(`2026-09-16-ergodis-datalog-programme-review.md`); independent of the others, becomes urgent
for C1195 because certificate emission and size are measured rows there.
**From the C1204 review (C1208 triage, 2026-09-21)**: (1) the product route is the prepared one,
which has no wire form until C1205 milestone a; build the encodings on that byte form, not on the
`rel_lowering::project` route nothing produces; (2) both checkers index the certificates' flat
`Vec<u32>` fields arithmetically and `premise_stride` floors at two with a zero sentinel, so a
layout change moves the stride rule, the sentinel meaning and every direct index together, and
checking from the compact form means a checker rewrite, not a decode step; (3) the Portability
bullet presupposes an ABI for the Datalog path, decided 2026-09-21 and proposed as its own task
(triage report decision 8) — that bullet waits for it; (4) if the certificate format opens, the
checker identity field (core F13; triage report decision 4) rides with it.

## Why

C1185 measured eight encodings and decided: ranks as runs are a free strict win on the existing
format (`O(rounds)` bytes instead of `O(tuples)`, the listing is in non-decreasing rank order);
the binary round-block form (rank runs, each run's tuples as LEB128 key gaps or a universe bitmap,
whichever is smaller) reaches 0.25–1.06 bytes per derived tuple against 11.5 for the JSON the
core emits (17× on the largest row). C1182 measured the JSON certificate at 5–25× the output
relation (384 MB for 15.7 M tuples). Neither format change was implemented.

## Deliverable

- Core: rank runs in the existing ranked certificate with the producer obligation stated in the
  format contract; the round-block binary encoding as a new wire format with its decoder and
  checker path, versioned, alongside JSON (no existing certificate changes identity or meaning).
- Checkers: verify from the round-block form without expanding to the JSON shape; presence bitmap
  and direct stores (C1184/C1186) unchanged.
- Portability: native and WASM decode the same bytes; the C ABI carries the format tag.

## Acceptance

- Bytes per derived tuple on C1185's table rows reproduced within its measured range; checker
  time per derivation not worse than the JSON path's; allocation regression on the decoder;
  fuzz/negative cases (truncated block, non-monotone run, out-of-universe key) refused with named
  errors.
- Lean audit gate (C1172 root target) still passes; export lint absorbs the new format.
- Report with Mystery ledger; audit.

## Out of scope

Key-indexed rank structure for fully bound probes (C1185 successor, unallocated); certificate
interoperability (C1148).
