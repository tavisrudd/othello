# Proposal: Stage 1 of "DRAT for game solving" — Lean-certified queens nimbers (V3 pilot)

**Date**: 2026-07-02
**Status**: PROPOSED (plan only; no code yet — box owned by the G(17) run)
**Parent**: [solver-theory targets](2026-07-02-solver-theory-targets.md) §7 V1/V3 — the staged
recommendation: pilot = Lean-certified nimbers (this doc), then the general checker/format
paper (V1), then a certified n=18. Companion thread: the CGT survey's mirror+exceptions
certificate idea ([cgt-adjacent-targets](2026-07-02-cgt-adjacent-targets.md)) shares this
checker.
**Existing assets**: `lean/NodeKayles/` (win recurrence, `win_iso`, `win_emb`,
`buildPred_correct`, `mex`/`grundy`, `win_iff_grundy_ne_zero`, `grundy_iso`, `grundy_sum` —
kernel-complete, mathlib axioms only); the `NimberSum` heap-sum engine (G(14..16) computed,
G(17) in flight); the production solver + TT.

## Goal

A machine-checked certificate chain whose end statement is, in Lean:
`grundy (queensGraph n) = g` for n = 12..16 (stretch: 17), with trust reducing to the Lean
kernel (+ compiled-checker caveat where scale demands it, stated explicitly). First
deliverable class: no solver-scale game-value computation has ever been machine-checked.

## Why this is well-posed here

1. **No GHI / no history**: placement games have no repetition; the position DAG is a true
   DAG and every TT value is context-free. The soundness conditions that make checkers hard
   for chess-like games (draw-by-repetition poisoning) do not exist in this domain.
2. **The sharing problem is already solved in Lean**: the solver's node identity is
   iso-canonical (D4 + graph iso). A certificate edge that reuses a proven node under a
   relabelling is discharged by the EXISTING `win_iso`/`win_emb` theorems — the checker
   just applies the permutation carried on the edge. This is the piece that would be a
   multi-month formalization from scratch; we have it.
3. **Nimber claims reduce to boolean claims compositionally**: `G(board) = k` ⟺ the sum
   `board ⊔ Nim-heap(k)` is a P-position (our engine's own definition of the computation),
   and `grundy_sum` + mathlib's `Nim` already machine-check the sum principle. So ONE
   certificate format (boolean win/loss witness DAG) certifies both outcomes and nimbers.

## Certificate format v0 (design sketch)

Topologically-sorted node records over canonical position keys:
- **WIN node**: the one winning move (child index + relabelling permutation into an
  already-proven node, or an inline leaf).
- **LOSS node**: the full child list, each a reference to a proven-WIN node (+ permutation)
  or an inline leaf.
- **Leaf** (`pc ≤ L`, L ≈ 8): the explicit ≤L-vertex graph; the checker recomputes its
  value by direct `mex`/`win` recursion (per-leaf cost is trivial at L = 8; no W-table trust).
- **Root record**: board size n, the claim (`win`/`loss` of the sum game with heap k), and
  the derived nimber statement.

Size driver: proof-DAG nodes ≈ win-nodes (1 child each) + loss-nodes (all children) over the
*distinct* DAG — the perfectly-ordered search footprint, strictly smaller than the search's
expansion count. **Unknown until measured** (probe below).

## Phases

- **A. Kernel-only baseline (pure Lean, no engine)** — define `queensGraph n` in Lean;
  bridge to the abstract `Graph k`; get `decide`-scale results: exact `grundy` for the
  largest n the kernel can chew (expect single digits; establishes the definitional core +
  the first machine-checked nonzero queens nimbers). Risk: none. Effort: small.
- **B. Proof-DAG probe (engine, cheap, after the box frees)** — instrument a solve to count
  proof-DAG nodes + serialized size at n = 8..14 (win-nodes contribute 1 child, loss-nodes
  all children, over canonical keys). Decides the kernel-vs-compiled question with data, and
  sizes the emitter. Effort: small (a counting pass; no correctness surface).
- **C. Checker in Lean + soundness theorem** — `checkCert : Cert → Bool` with
  `checkCert c = true → grundy (queensGraph c.n) = c.g`. Sharing via `win_iso`/`win_emb`
  instances; leaves via the recurrence; sum claims via `grundy_sum` + mathlib `Nim`.
  This is the core new Lean work. Effort: the bulk of stage 1.
- **D. Emitter (Rust)** — post-solve proof re-derivation pass: walk the claim DAG, at each
  WIN node re-find one winning child by probing values (warm TT), at each LOSS node
  enumerate children; emit records topologically. n ≤ 14 comfortably in RAM; n = 15/16 needs
  the value-complete DAG retained (12 GB TT is value-complete at n=16's ~8% fill — verify).
  Effort: moderate; zero impact on production paths (separate pass).
- **E. Run the ladder** — certify n = 12 kernel-or-compiled; then G(14) = 0, G(15) = 1,
  G(16) = 0 (the A344227 terms) at compiled-checker scale; stretch G(17) once its value
  lands. Publish: ITP/CPP paper + OEIS annotation ("terms machine-verified").

## Decision points (resolve with data, in order)

1. **Kernel ceiling** (after A): largest n where `decide` finishes — sets the "zero-caveat"
   claim boundary.
2. **Compiled-checker trust wording** (after B): if n = 14 certs are ~10⁶–10⁷ records, the
   checker runs compiled (Lean→C), not in-kernel — the SAT community's accepted posture
   (verified checker, compiled execution); document as the one added trust assumption.
3. **Leaf ceiling L**: cert size vs per-leaf recompute cost; start L = 8 (matches W8, whose
   completeness argument the checker never needs — it recomputes).
4. **n = 16 emitter memory**: if the value-complete DAG doesn't fit alongside the solve,
   emit from a re-solve at 12 GB TT (fill ~8% makes eviction loss unlikely — measure).

## Risks

- **Scale surprise**: proof-DAG at n = 16 could exceed compiled-checker patience — fallback
  is the V1 hybrid (certified spot-check + verified recompute), which is itself the
  research contribution; n ≤ 14 remains fully certifiable regardless.
- **Scoop**: Takizawa's certificate line (arXiv 2411.01029) is adjacent and active; the
  CQD paper explicitly invites a Lean encoding. Mitigation: our differentiators are the
  verified checker + iso-sharing + a new-result payload; move A/B/C promptly.
- **Lean toolchain**: mathlib drift (the game-theory extraction noted in the paper §7.3);
  the checker needs only our self-contained grundy layer + `Nat` xor — low exposure.

## Immediate next actions (this session/next)

1. [ ] Commit this plan; get user sign-off on the staged scope.
2. [ ] After G(17) lands and the box frees: the Phase-B probe (proof-DAG counting pass) —
   cheap, and its numbers decide everything downstream.
3. [ ] Phase A can start in parallel with G(18) rounds (Lean work is box-light; only
   `lake build` memory needs watching against a 17 GB TT run).
