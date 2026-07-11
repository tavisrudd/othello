# Codex task queue — delegated by Fable (2026-07-07)

**What this is:** the live task registry for the projective-cap / odd-plane program. It holds only
the current-state map — the priority view plus the genuinely-open tasks as one-line entries. Full
write-ups of completed tasks, the original ranking, and the Fable Nth-pass amendment trail were moved
to the companion log
[`2026-07-07-codex-task-queue-archive.md`](2026-07-07-codex-task-queue-archive.md) on 2026-07-11.

**Task-ID protocol:** one global monotonic `CNN` sequence (see CLAUDE.md). Each task names a report
file; Codex does the work, writes findings there (verbatim commands/outputs for machine checks), and
marks the entry `[REPORTED <date>]`. Never renumber or reuse an allocated ID. **Max allocated: C77.**

**Box:** compute up to ~8 GB / multi-core is fine; q ≥ 23 grid-cap campaigns and n=20 queens runs
still require an explicit user gate.

## CURRENT TOP OF QUEUE (updated 2026-07-11)

The (ON) odd-plane kernel — "every legal size-3 residual position has a P-valued on-conic size-4
child" — is the active mathematics. The config→value **mechanism sweep is closed-negative** (Cluster 1),
so the two live proof lanes are **A5 arc-depletion arithmetic** and the **Cluster-2 game-semantic
ledger/certificate**. C75/C76 close the current pointwise selector/invariant spaces; C77 closes the
pure geometric bank bound but shows that game-semantic certificate content is still missing.

1. **Cluster 2 — the open core** (game-semantic ledger/certificate + existential q-varying selector).
   PRIMARY per C65's route verdict. Every constituent probe is REPORTED (archived C61–C63, C70, C71);
   the lane itself is open. C75 explains the selector wall; C76 answered the invariant prong
   (frame-relative characters cut collisions 48→1 but leave a residual hard twin, no monotone scalar,
   and no uniform linear selector ⇒ separation not selection). C77 now proves the reservoir-free
   DROP ledger is uniformly peak-bounded, but also shows that this geometric bound has no game-value
   content by itself; the sole surviving lever is a **game-semantic ledger/reply-book closure**.
2. **A5 lane — arc-depletion arithmetic.** Sole surviving (ON) mechanism route. Open: prove
   `maxonN(q) ≤ q−5` for all depleted q. Min-witness bound holds through q=25; depleted set still
   `{11,17}`. Gated compute: the next-depleted-order census (q=29, ~16 GB / ~15–25 h — user gate).
3. **C74 residue** — a game-value N-absorption bound for the explicit one-intruder pencil (report §5);
   the q=11 knife-edge 4P/2N pencil pattern is the base obstruction.
4. **Independent lanes** — C30 (q17/q19 Lean cert assembly, long-running, gated) pulls in parallel.

## Open tasks

**Proof lanes (open; constituent probes archived as REPORTED):**

- **C76 [REPORTED 2026-07-11 — invariant prong answered; ledger is the surviving lever]** —
  frame-relative characters (polar-at-frame, frame-chord, frame×tangent cross-ratio profiles) — the
  frame-awareness the (x,z)-local selector space omitted — cut the C75 collisions **48→1**: they split
  47/48 enumerated twins (polar+chord) and separate the winner/loser classes almost everywhere. **But
  the augmented space is NOT orbit-injective** (1 residual hard twin, q=17 axis points P `11,0`/N
  `16,0`), **no scalar reduction is monotone** (39/48 and 38/48 separators are direction-MIXED), and
  **no uniform linear selector exists** (C77-selector-test LP infeasible over d=37). So it buys
  separation, not selection — routing (ON) to a **game-semantic ledger/reply-book closure**. Report:
  [`2026-07-11-c76-frame-aware-invariant-orbit-injectivity.md`](2026-07-11-c76-frame-aware-invariant-orbit-injectivity.md);
  scripts `rust/scripts/c76_invariant_hunt.py`, `c76_directional_search.py`, `c77_augmented_selector.py`.
- **C77 [REPORTED 2026-07-11 — DROP peak theorem proved; game-semantic certificate residue OPEN]** —
  C63's growing Ψ debt is entirely the loose `reservoir_slack` term. After deleting it, the pure
  conic ledger `DROP = 6·defect − 4·intruders − 2·[xor=0]` satisfies the **all-depth theorem**
  `DROP(S) ≤ DROP(root)=6(q−5)−2` for every odd q: an intruder pays `−4`; without intruders a proper
  descendant has at most `q−6` live conic vertices; the root's `q−5` isolates have xor zero. The q23
  solve is no longer needed for bank capacity or full-depth DROP debt. The `q−5` cross-lane check is
  **negative**: A5's `maxonN` is a class-extremal P/N count, while `defect_components` is a
  value-blind graph count fixed at `q−5` at the root; identifying them assumes the desired P witness.
  **Open residue:** a peak bound is not a P-certificate. Add genuine game-semantic/reply-book closure;
  do not spend more compute on the DROP envelope. Reports:
  [`2026-07-11-c77-ledger-bank-probe.md`](2026-07-11-c77-ledger-bank-probe.md),
  [`2026-07-11-c77-ledger-spike-structure.md`](2026-07-11-c77-ledger-spike-structure.md) (§6–9); modes
  `s4ledger`/`s4spike` in `notes/2026-07-06-grid-cap-solver.rs`.
- **A5 arithmetic proof** (open lane, no single ID) — `maxonN(q) ≤ q−5` for all arc-depleted q, plus
  the q=29 next-depleted-order census (gated compute). Anchor context:
  [`2026-07-09-codex-depletion-fraction.md`](2026-07-09-codex-depletion-fraction.md),
  [`2026-07-10-codex-a5-nbucket-density.md`](2026-07-10-codex-a5-nbucket-density.md),
  [`2026-07-10-a5-symmetric-completion-anchor.md`](2026-07-10-a5-symmetric-completion-anchor.md).
- **C74 residue** — one-intruder pencil N-absorption bound (see archived C74 body §5;
  [`2026-07-10-codex-c74-capacity-family.md`](2026-07-10-codex-c74-capacity-family.md)).

**Independent / engineering:**

- **C30 [REPORTED 2026-07-10 — certcheck PASS; open engineering tail]** — generated-checker refactor →
  q17/q19 Lean assembly. The v5 full q17 canonical build projects above 21.5 h sequential, tripping the
  task's ~10 h user-launch gate; do not launch implicitly. Next = an explicit launch decision or a
  build-shape reduction, then q19 sizing.
- **C13 [OPEN]** — q=9 intrusion-structure probe (the next odd-plane Lean target; the q=9 Lean
  kernel/certificate is still open per the handoff Status Table). Report target
  `notes/2026-07-07-codex-q9-intrusion-probe.md`.
- **C16 [OPEN — dormant]** — sum-free Tactic 2, induction on `r` (`Z3^r × Z_p` is N iff r=1); a
  separate work stream, dormant unless resumed. Report target
  `notes/2026-07-07-codex-sumfree-induction-r.md`.
- **C56 [CLOSED-GATED — do not start]** — group-indexed cross-q type alignment; gated on a C55
  positive, and C55 is NEGATIVE, so it stays closed.

**Reported this pass:**

- **C76 [REPORTED 2026-07-11]** — frame-relative characters cut the C75 collisions 48→1 but leave a
  residual hard twin and no uniform selector (linear LP infeasible); invariant prong answered, ledger
  is the surviving lever. Report:
  [`2026-07-11-c76-frame-aware-invariant-orbit-injectivity.md`](2026-07-11-c76-frame-aware-invariant-orbit-injectivity.md);
  scripts `rust/scripts/c76_invariant_hunt.py`, `rust/scripts/c76_directional_search.py`.
- **C75 [REPORTED 2026-07-11]** — value-blind reply-selector impossibility. 19 of 108 hard obligations
  hold a P and an N reply that are byte-identical on all 17 program features → the wall is
  feature-completeness, not coordinate choice, and the deficit grows with q (6% → 7% → 39%). Names the
  C76 invariant hunt and re-weights (ON) toward the amortized/ledger potential. Report:
  [`2026-07-11-c75-value-blind-selector-impossibility.md`](2026-07-11-c75-value-blind-selector-impossibility.md);
  script `rust/scripts/c75_linear_selector_lp.py`; solver `gridcap-c75`.

**Opportunistic / diagnostics (no priority; pull as diagnostics — full specs in the archive):**
C23 / C40 (winline viz lanes), C49 (piece nimber tables), C57 (zone quasi-randomness), C60
(Singer-model probe), C66 (grid-terminal spectrum), C67 (coupling-defect spectroscopy).

## Settled lanes (one-line pointers; full task bodies in the archive)

- **Cluster 1 — config→value mechanism sweep: CLOSED, no static dictionary found (de-prioritized in
  favor of A5, not proven impossible).** C55 group-side
  [`2026-07-09-codex-d-lattice-side-switch.md`](2026-07-09-codex-d-lattice-side-switch.md), C64
  extremal poset [`2026-07-09-codex-completion-poset.md`](2026-07-09-codex-completion-poset.md), C69
  algebraic envelope [`2026-07-10-codex-envelope-invariants.md`](2026-07-10-codex-envelope-invariants.md),
  and the Ψ dynamic probe [`2026-07-10-psi-dynamic-flip-probe.md`](2026-07-10-psi-dynamic-flip-probe.md)
  all NEGATIVE. Re-entry conditions in the archived Cluster-1 status note.
- **A5 depletion evidence — all REPORTED; q=25 non-depleted (28/28 P), depleted set still {11,17}.**
  C68 `D(q)` + C68b ν(q) (links above), C72 f_q decomposition
  [`2026-07-10-codex-c72-fq-decomposition.md`](2026-07-10-codex-c72-fq-decomposition.md), C73 secant
  packet [`2026-07-10-codex-c73-secant-packet.md`](2026-07-10-codex-c73-secant-packet.md), q=25 census
  C43/C44 [`2026-07-09-codex-q25-baer-census.md`](2026-07-09-codex-q25-baer-census.md), order-9 planes
  C58 [`2026-07-09-codex-order9-planes.md`](2026-07-09-codex-order9-planes.md), arc-stability C59
  [`2026-07-10-codex-arc-stability-import.md`](2026-07-10-codex-arc-stability-import.md), round-1/round-2
  theorem frontier
  [`2026-07-10-codex-odd-plane-round1-report.md`](2026-07-10-codex-odd-plane-round1-report.md),
  [`2026-07-10-codex-odd-plane-round2-report.md`](2026-07-10-codex-odd-plane-round2-report.md).
- **Selector / potential probes — all REPORTED; the wall is explained by C75.** C61 reply automaton,
  C62 selector scoring, C63 potential LP/dual, C70 collision charge
  [`2026-07-10-codex-c70-collision-charge.md`](2026-07-10-codex-c70-collision-charge.md), C71
  third-intruder transition
  [`2026-07-10-codex-c71-third-intruder.md`](2026-07-10-codex-c71-third-intruder.md).
- **C50 [REPORTED 2026-07-10 — tiny PASS / literal-scale NO-GO]** — reflected Grundy-book cert format
  in Lean; replace linear literal lookup before a C35 adapter.
  [`2026-07-09-codex-grundy-cert-format.md`](2026-07-09-codex-grundy-cert-format.md).

---

The remaining history — the verbose priority-ordering snapshots, the original ranking + Fable
Nth-pass amendment trail, and every REPORTED / NEGATIVE / NO-GO / DONE task body (C1–C74, plus the
untagged bodies C14/C15/C22 subsumed by later work) — was moved verbatim on 2026-07-11 to
[`2026-07-07-codex-task-queue-archive.md`](2026-07-07-codex-task-queue-archive.md).
