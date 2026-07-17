# Relative-conic discovery track

**Date opened:** 2026-07-16
**Lane:** `relconic`
**Mode:** append-only companion under the repository-wide
[discovery-track conventions](discovery-track-conventions.md).

This log is for incidental observations and musings encountered while doing relconic proof/math
work: things the active task was not trying to establish. Planned construction signals, rejected
mechanisms, proof routes, validation, and closure results belong in their C-item reports and the
live handoff, not here. An entry is a lead rather than a lane obligation and cannot expand scope by
itself.

## Log

- **2026-07-17 — Singular `minAssGTZ` returned a wrong decomposition over `GF(2)` (`CHECKED`,
  bounded).** While decomposing the C210 a=0 residue system, `minAssGTZ` on the stripped
  cross-determinant ideal claimed minimal prime `V(delta+p)`, but direct `reduce` shows none of
  the three generators is divisible by `delta+p`; a GF(8) census agrees with the direct result.
  Small-characteristic primary decomposition (GTZ general-position assumptions) is not trustworthy
  here. **Lead:** any relconic/baer step that leans on `primdec.lib` over small fields should
  re-derive its component list by exact division/resultants/gcds, as the committed
  `analyze_c210_a_zero_artin_schreier_divisor.py` now does. **Disposition:** tooling caution only.
