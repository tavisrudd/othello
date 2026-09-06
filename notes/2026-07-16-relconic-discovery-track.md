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

- **2026-09-06 — Equality structure of the `PG(3,q)` secant-local coverage bound is a small
  exact-cover problem (`DERIVED`, C1071 item 23).** Equality forces the secants of a complete cap
  to split into `binom(k,2)/ρ` concurrent blocks of size `ρ = k-q-2` with secants from different
  blocks skew, and the same-block relation on disjoint edge pairs of `K_k` closed under re-pairing
  (`ab|cd` same block forces `ac|bd` and `ad|bc` same block). The `ρ = 2` case is a Steiner
  system `S(2,4,k)` and the Diophantine side fails for every `q`. **Lead:** for `ρ ≥ 3` and
  `k ≤ 14` the closed block partitions of `E(K_k)` are a symmetric exact-cover instance suited to
  an Ergodis compression run; a nonexistence classification would quantify the forced slack in
  the constant `1/2 + 3/√2`. **Disposition:** promoted to C1072 on the `ergodis` lane.
- **2026-09-06 — Minimum ordinary completion of a `C`-complete arc is independent domination on
  a union of `k` involution matchings (`DERIVED`, C1071 item 7).** `Γ_A` on the uncovered conic
  locus, edges from the chord involutions of the `k` arc points; `i(Γ_A)` is the number of
  conic points needed to complete `A`. **Lead:** small-`q` instances (`q ≤ 19`, the paper's
  attaining arcs) form a structured domination family; a compiled Ergodis rule for `i(Γ_A)` in
  terms of the involution cycle structure would be a concrete test case. **Disposition:** promoted to C1073 on the `ergodis` lane.
- **2026-09-06 — Free-pair literature is the concentration side of the higher-dimensional `c_4`
  program (`LIT`, C1071 Part D).** Farr–Lisoněk (IIG 4, 2006; J. Geom. 85, 2006) and Lisoněk
  (JCD 14, 2006) study caps with many free pairs, i.e. many secants with `T_ℓ = 0`; caps of
  `PG(3,q)` with a free pair have at most `q+3` points. **Lead:** their constructions are the
  natural candidates for caps whose coplanar quadruples concentrate on few secants, the case
  the conditional bound (paper `sec:caps`, last paragraph) must exclude. **Disposition:** promoted to C1074 on the `ergodis` lane;
  reading for whoever takes the `n ≥ 4` problem.
