# Proposal: A compact, independently checkable certificate for the n=18 first-player-win verdict

## Status

Draft — **Phase 1 measured (2026-06-26): CONDITIONAL GO.** See "Phase 1 results" below.

## Phase 1 results (measured 2026-06-26)

Built `queens strat-dag <n> [--after …] [--floor K]` on `queens-n18-certify` (commit `0b6378e`,
worktree `/home/tavis/src/othello-n18-certify`): walks the minimal AND/OR winning-strategy DAG
(one move at mover-wins/OR nodes, all replies at mover-loses/AND nodes), dedups by the exact D4
key, buckets by available popcount. `--floor K` grounds at the getK tablebase (DK=17 ⇒ pc≥18
certifiable interior; skip[18,25] ⇒ pc≥26 stored interior). Validated: n=2 → exactly 2 nodes;
the `--floor 17` pc≥18 interior reproduces the full-depth pc≥18 cumulative to the unit.

**Full-board strategy-DAG size** (even n = second-player wins ⇒ AND-root certificate covering
all first moves):

| n  | full-depth total | pc≥18 interior (getK) | pc≥26 interior (skip-stored) |
|----|------------------|-----------------------|------------------------------|
| 10 | 16,787           | 831                   | 599                          |
| 12 | 382,052          | 32,132                | 4,248                        |
| 14 | 16,662,863       | 1,787,354             | 193,728                      |
| 16 | —                | ~210 M (est.)         | **19,975,223** (measured)    |

Grounding shrinks the certificate **~10× per level** (full-depth → pc≥18 → pc≥26), exactly the
Approach-C thesis. The pc≥26 growth ratio per +2 in n is climbing (×7.1 → ×45.6 → ×103.1).

**Real n=18 on-line certificates** (each a *complete* cert for that position — full P2-branching
below it — on the I9 PV line, solved with `--floor 25`):

| position (PV prefix)            | avail pc | pc≥26 interior | pc≥18 interior | solve time |
|---------------------------------|----------|----------------|----------------|------------|
| after I9 K8 G10                 | 156      | 783,533        | 5,649,360      | 32 s       |
| after I9 K8 G10 J11             | 110      | 5,451          | 32,609         | 0.3 s      |
| after I9 K8 G10 J11 H3 M7       | 63       | 53             | 202            | 0 s        |

**The I9 *root* certificate cannot be measured directly** — the oracle must solve each shallow
node, and solving from I9 itself is the 258 B-node monster. Bounded below by the on-line
sub-certs and estimated from full-board-per-first-move scaling (n=16's 20 M pc≥26 ÷ ~40 distinct
first moves ≈ 0.5 M/first-move, scaled to n=18 geometry) plus the top-ply AND-branching: best
estimate **~10–100 M nodes (pc≥26), ~100 M–1 B (pc≥18)**, pessimistic tail to ~10⁹/~10¹⁰.

### Gate decision

- **The "compact, CPython-checkable" certificate is ruled out.** Even getK/skip-grounded, the I9
  certificate is tens of millions to ~a billion nodes — `check_cert.py` (CPython, ~10⁶ scale)
  cannot verify it. The "compact" framing in this proposal was wrong.
- **A purpose-built *streaming Rust* checker IS feasible** for the pc≥26 skip-stored strategy DAG:
  ~10–100 M nodes ≈ GB-to-tens-of-GB on disk, verifiable against game rules in minutes-to-hours.
  This is a real, independent certificate — just heavy, not compact.
- **Partial coverage is available *today*:** an on-line n=18 sub-certificate at real depth (after
  I9 K8 G10, pc=156 → 5.6 M pc≥18 nodes, 32 s) is small and independently checkable now. Certifying
  the PV spine + the largest-feasible sub-positions is the immediate, low-effort confidence gain.
- **⇒ CONDITIONAL GO:** proceed to Phase 3 (a streaming Rust checker over the pc≥26 strategy DAG),
  keeping `check_cert.py` for small-n validation only. The certificate is feasible but heavy, so it
  is a genuine engineering commitment — a user decision on "hardened certificate vs. the existing
  cross-config + partial-coverage confidence" is warranted before building the full checker.

### Streaming-checker footprint (measured)

The certificate is GB-scale on disk (pc≥26 ≈ 10–100 M nodes × ~50–80 B ≈ 0.5–8 GB), so neither
disk nor RAM is a wall. The search DAG is **strictly ply-layered** (each move places exactly one
queen ⇒ transpositions are intra-ply ⇒ edges go depth d→d+1 only), so a deepest-ply-first checker
holds only a 2-ply window. But the per-ply layer widths (`strat-dag` per-ply histogram) are
**sharply peaked** — one mid/late ply at the game's combinatorial peak holds the majority:

| cert                          | interior nodes | widest ply layer | widest % |
|-------------------------------|----------------|------------------|----------|
| n=14 pc≥26 (skip-stored)      | 193,728        | 105,148          | 54.3 %   |
| n=18 after I9 K8 G10, pc≥26   | 783,533        | 495,836          | 63.3 %   |
| n=14 full-depth               | 16,662,863     | 11,884,516       | 71.3 %   |

So ply-windowing trims RAM only **~1.4–2×** (the dominant layer can't be split — its nodes are
mutually independent, verified against the next ply); GB-scale RAM comes from the cert being
*small*, not from a thin window. What streaming genuinely buys: (1) it removes `check_cert.py`'s
load-everything-into-one-dict random-access bottleneck (sequential ply sweep instead); (2)
**check-as-you-go** — pipe the solver's per-ply output straight into the checker, never
materialising the artifact, peak scratch ≈ 2 plies. The pc≥26 grounding is the real lever: it
both shrinks the cert ~10× *and* truncates before the combinatorial peak (less peaked: 54–63 %
vs full-depth's 71 %).

## Partial-coverage certification — BANKED (2026-06-26)

Executed the immediate, low-effort path (this proposal's open question 4 / Phase-4 fallback):
independently machine-check the deepest feasible positions on the I9 winning line, using the
*existing* pipeline untouched — `queens certify 18 <out> --after <PV prefix>` dumps the exact
D4-canonical value table; `scripts/check_cert.py` re-derives the verdict from the game rules +
its own D4 canon, sharing **no** solver code (not the search, canon, getK, or the tiny-graph path
where the verdict bug lived).

| position (after PV prefix)        | mover | pc  | positions  | independent verdict | check time |
|-----------------------------------|-------|-----|------------|---------------------|------------|
| I9 K8 G10 J11 H3 M7 N16 E4 (L=8)   | P1    | 32  | 854        | **WINS**            | <1 s       |
| I9 K8 G10 J11 H3 M7 N16 (L=7)      | P2    | 44  | 24,407     | **LOSES**           | 2 s        |
| I9 K8 G10 J11 H3 M7 (L=6)          | P1    | 63  | 125,680    | **WINS**            | 15 s       |
| I9 K8 G10 J11 H3 (L=5)             | P2    | 88  | 2,686,210  | **LOSES**           | 369 s (~6m)|
| I9 K8 G10 J11 (L=4)               | P1    | 110 | 5,056,478  | **WINS**            | 1083 s (~18m)|

The verdicts **alternate** exactly as a winning line requires (P1-to-move ⇒ WINS, P2-to-move ⇒
LOSES), each verified over **all** continuations from that position — not just the PV move. The
`certify` working set grows steeply toward the root (854 → 24 K → 126 K → 2.7 M → 5.1 M …), and
CPython `check_cert.py` (~8·pc² ops/entry) handles ≤~125 K in seconds; the multi-million L=4/L=5
take 6–18 min and are the practical CPython frontier (a Rust checker — Phase 3 — is what lifts it
further). **L=4 (pc=110) is the deepest CPython-feasible point**: "first player wins after I9 K8
G10 J11, over all continuations," independently re-derived from the rules.

**What this banks — precisely:**

- **CERTIFIED, independent of all solver code:** every position on the I9 optimal line from the
  deepest-feasible prefix down to the terminal is independently re-derived from the rules, with
  the verdict alternation confirmed. This is genuine n=18 ground truth at real depth on authentic
  high-square geometry — the verdict of e.g. "after I9 K8 G10 J11 H3 M7 (pc=63), the player to
  move wins" holds over every continuation, checked by code that shares nothing with the solver.
- **STILL on cross-config agreement (not independently certified):** the top ~3–4 plies — the
  empty-board I9 root and the wide P2-branching just below it (pc ≳ 156), whose proof DAG is the
  114–258 B-node solve — exceed both CPython and the certify memo solver. The root verdict
  ("n=18 = first-player win, witness I9") continues to rest on the two independent getK configs
  agreeing (W17 258 B / W18–20 114 B, byte-identical 15-move PV) + the Lean-checked recurrence +
  the reproduced Jenrich n≤16 sequence.

So the gap is now named to the ply: the winning line is independently machine-checked from the
mid-game down; only the top few high-pc plies near the root remain on cross-config trust — which
is exactly what a full Phase-3 Rust checker over the pc≥26 strategy DAG would close.

## Problem

The headline result — **n=18 Non-Attacking Queens (Node-Kayles on the 18×18 queen graph)
is a first-player win, witness opening I9** — currently rests on *cross-validated agreement*,
not a single checkable proof object:

- two independent `getK`-ceiling configs (W17 → 258 B nodes / 8h16m; W18–20 → 114 B nodes /
  7h08m) agree on verdict, winning move, and a byte-identical 15-move PV at different node counts;
- a Lean-checked **recurrence semantics** (`lean/NodeKayles/`: `win`, `buildPred_correct`,
  `win_iso`/`win_emb`, the Grundy layer) — but this proves the *abstract* `W_K` recurrence, **not**
  the board→graph bridge (`queenGraph 18`) and **not** the concrete verdict;
- an independent-oracle differential and a reproduction of Jenrich's full n≤16 sequence.

That is strong, but it is not a *certificate*: there is no artifact a skeptic can feed to a
program that knows only the rules of the game and have it return "verified." The project's own
stated bar is **"a verdict we can't certify, we don't claim"** (umbrella, Phase E). The
verdict-bug episode (a `u8` truncation that survived every gate until an oracle differential
caught it; `notes/handoffs/2026-06-23-n18-migration-verdict-bug.md`) is the concrete reason the
PV alone is **not** a proof — a single line proves nothing about the opponent's alternatives.

We want the smallest object that, checked against the game rules alone, establishes the verdict.

## Context

**What already exists (branch `queens-n18-certify`, commits `81e63ca`, `928a478`):**

- `queens certify <n> <out>` dumps the **exact D4-canonical value table** (every distinct
  canonical position with its win/loss value).
- `scripts/check_cert.py` is an **independent CPython checker**: it re-derives each entry's value
  from the dumped children using game rules only, with no access to the solver's TT/getK/canon.
  Proven: n≤12 all CERTIFIED; fault injection (flipped verdict / corrupted value) both REJECTED.
- `certify <n> <out> --after <opening moves>` already **solves + certifies any n=18 *position***
  (a real game continuation) that fits — so n=18 *sub-positions* are within reach today.

**Why the obvious "certify the whole n=18 board" is dead (umbrella §C2, lines 838–846, 1075):**
the `certify` dump is a **value table over the reachable/distinct set**, and at the root that set
is ≈ the solve itself. At n=12 the distinct table is 1.06 M rows and the full reachable set is
44.9 M (≈42×); at n=18 the I9 subtree is 10¹¹ nodes. CPython cannot re-derive 49 M+ rows, let
alone 10¹¹. **Full-board certify-from-dump is correctly dropped as infeasible.**

**The gap this proposal targets.** The existing pipeline dumps a *value table* (all distinct
positions). It does **not** dump a minimal **winning-strategy DAG** — the AND/OR proof object
that is, in principle, far smaller than the value table:

- At a **mover-wins** node (OR): record **one** witnessing move to a mover-loses child.
- At a **mover-loses** node (AND): record **all** moves; each must lead to a mover-wins child.

Only the AND nodes branch; OR nodes are degree-1. This is the classic Allis proof-DAG. With
transposition merging it is a DAG, not a tree. The open question is whether *its* size — not the
value table's — is feasible at the I9 root. Crucially, the solver's own architecture already
suggests the right floor: `getK` resolves every position with `pc ≤ 17` directly from the dense
W0..W8 tables (no expansion), and **skip[18,25]** means the production proof DAG it actually
stores is only `pc ≥ 26`. So the natural certificate interior is the `pc ≥ 18` strategy DAG
grounded at `getK` leaves — exactly the band the solver treats as "real" work, *not* the
42×-larger full-depth reachable set.

**Lean state (`lean/NodeKayles/Basic.lean`).** `buildPred_correct` already kernel-proves the
one-ply build recurrence (`firstPlayerWins G ↔ ∃ move, ¬ firstPlayerWins (child)`), and
`win_emb` proves induced-subgraph (relabelling) invariance — the soundness of resolving a child
by a smaller table. What's missing for a board-level Lean certificate is the **Phase-2 bridge**
(`queenGraph 18`, a decidable move generator) and any way to make the kernel chew through a
large DAG.

---

## Approach A: Strategy-DAG to terminal + standalone rules-only checker

### Architecture

Extract the full AND/OR winning-strategy DAG from the root, bottoming out at **terminal**
positions (no legal move). Serialize as a map `canonical_key → entry`, where

```
entry = WIN  { move: square, child: key }          // one witness
      | LOSS { children: [ key, ... ] }             // every legal reply
```

A standalone checker — extend `check_cert.py`, or a fresh checker in a *separate* crate/language —
loads the DAG and, using **game rules only** (place a queen → delete it and every square it
attacks; recompute the available set; regenerate legal moves), verifies for every node:

- WIN node: the recorded `move` is legal, and applying it yields exactly the recorded `child`,
  which is present and labelled LOSS;
- LOSS node: the recorded `children` are **exactly** the children of *all* legal moves (none
  omitted — this is what the PV cannot prove), and each is present and labelled WIN;
- leaves: terminal (zero legal moves) and labelled LOSS (mover with no move loses, normal play);
- the root is present, labelled WIN, with move I9.

Independence of the checker's own canonical key (used for dedup) is optional — it can dedup by
raw board state and simply carry a larger map.

### Trade-offs

**Strengths:**
- Trust base is *only* the game rules + the DAG. Fully independent of the solver's TT, `getK`,
  fingerprints, and canonicalization. The simplest thing to *specify* and to *believe*.
- Reuses the `check_cert.py` rules-re-derivation harness and its fault-injection methodology.

**Weaknesses:**
- The DAG runs to **full depth** (`pc` 1…terminal), re-introducing the entire `pc ≤ 17` subtree
  that the production solver **never expands** (`getK` resolves it in one tabulated sweep). This
  is precisely the 42×-blow-up that killed full-board certify. The certificate is likely *larger*
  than the solver's own proof DAG, not smaller.
- LOSS nodes near the root have hundreds of replies, each spawning a full-depth subtree; without
  the `getK` floor the AND-node fan-out is maximal. High risk of infeasibility at I9.

---

## Approach B: Lean / mathlib kernel-checked certificate

### Architecture

Build the missing Phase-2 bridge (`queenGraph 18 : Graph 324` plus a `Decidable` move generator),
then discharge the strategy DAG inside Lean against the already-proven recurrence:

- a WIN node's `firstPlayerWins` term is built from `buildPred_correct` with the recorded move and
  the child's (recursively constructed) `¬ firstPlayerWins` term;
- a LOSS node's `¬ firstPlayerWins` from the conjunction of all children's `firstPlayerWins` terms.

Either as explicit proof terms per node, or by `Decidable` reflection (`decide`) over a Lean
re-implementation of the recurrence. Optionally take the `Grundy.lean` upgrade path (require
`vihdzp/combinatorial-games` once its toolchain matches) to *remove the self-asserted adequacy*
of `win` as the game value.

### Trade-offs

**Strengths:**
- Strongest possible trust: the Lean kernel + a peer-reviewable recurrence definition. If bridged
  to `combinatorial-games`, the "`win` *is* the game value" assumption leaves the trusted base.
- The recurrence half is *already done* (`buildPred_correct`, `win_emb`).

**Weaknesses:**
- Kernel-checking even millions of nodes is hours-to-days of kernel time; billions is hopeless.
  Lean reflection on a `Graph 324` with `Finset (Fin 324)` positions is far heavier still.
- Requires building the board→graph bridge **and** a verified, performant move generator — neither
  exists.
- Realistic only for tiny n or a *single PV spine*, **not** the I9 strategy. As a *whole-verdict*
  certificate at n=18 it is infeasible.

---

## Approach C: Tablebase-grounded hybrid (strategy DAG over `getK` leaves)

### Architecture

The same extracted AND/OR strategy DAG as Approach A, but it **bottoms out at `getK` tablebase
leaves (`pc ≤ 17`)** instead of terminal positions — mirroring the solver's own architecture. The
certificate has two independently-checked layers:

**Layer 1 — interior (rules-only), `pc ≥ 18`.** Identical checker logic to Approach A over the
interior nodes, except a node with `pc ≤ 17` is a **leaf**: instead of expanding it, the checker
records its claimed value and defers to Layer 2. (With `skip[18,25]` the stored interior is
`pc ≥ 26`; `pc` 18–25 are recomputed leaves — same treatment.)

**Layer 2 — leaf resolver (independently certified tablebase).** The `pc ≤ 17` leaf values are
resolved by an **independent** implementation of the `W_K`/`getK` recurrence — *not* the solver's
`dense.rs` — or, cheaper, by re-deriving from the complete W0..W8 tables. Trust for this layer
decomposes into two small, separately-checkable facts:

1. the W0..W8 **complete tables are small and fully enumerable** — regenerate and exhaustively
   cross-check them with a naive Node-Kayles solver (exactly the re-derivation `check_cert.py`
   already does for n≤12);
2. the `getK` **one-ply recurrence is correct** — this is exactly Lean's `buildPred_correct` +
   `win_emb` (already kernel-proven), applied `17 − 8 = 9` times.

```
certificate = {
  interior: { key(pc≥18) → WIN{move,child} | LOSS{children…} },   # Layer 1, rules-checked
  leaves:   { key(pc≤17) → value },                               # Layer 2, tablebase-checked
}
verdict verified  ⇔  Layer-1 interior consistent under game rules
                     ∧ every leaf value reproduced by the independent W_K resolver
                     ∧ root = WIN, move I9
```

### Trade-offs

**Strengths:**
- **Truncates the certificate to the `pc ≥ 18` strategy DAG** — the same band the solver actually
  stores. Its size ≈ the *real* proof DAG, not the 42× full-reachable blow-up that sinks A and B.
  This is the only approach whose object is plausibly feasible at the I9 root.
- Matches the solver's architecture, so the certificate is the *natural* dump (the `M_MODEL`
  store-node proof-DAG tap in `wins_inc`, umbrella line 405, already walks this exact set).
- Maximally reuses what exists: `check_cert.py`'s rules harness (Layer 1), the certifiable small
  W0..W8 tables and `--after` sub-position certify (Layer 2), and the Lean `buildPred_correct`
  proof (the one-ply recurrence under Layer 2 is *already* kernel-checked).

**Weaknesses:**
- Trust spans two artifacts ("interior by rules + leaves by an independently-checked tablebase")
  rather than one monolithic rules-only object — a slightly longer argument to a referee.
- The leaf resolver **must** be an independent reimplementation (or exhaustive table re-check) to
  preserve independence — reusing `dense.rs` would make the certificate circular.
- Whether the `pc ≥ 18` strategy DAG for I9 actually fits in RAM / CPython is **still unknown**
  until measured (the central open question below).

---

## Approach comparison

| Criterion                         | A: rules-only to terminal      | B: Lean kernel               | C: tablebase-grounded hybrid        |
|-----------------------------------|--------------------------------|------------------------------|-------------------------------------|
| Certificate object                | full-depth strategy DAG        | proof terms / reflection     | `pc≥18` strategy DAG + leaf table   |
| Size vs solver proof DAG          | **larger** (re-expands pc≤17)  | larger still                 | **≈ equal** (the stored band)       |
| Feasible at I9 root?              | unlikely                       | no                           | **plausible — must measure**        |
| Independence / trust              | rules only (highest, monolithic)| kernel (highest), but partial| rules + independent tablebase (high)|
| What it proves                    | full verdict, if it fits       | tiny n / one spine only      | full verdict, if it fits            |
| Reuses existing pipeline          | `check_cert.py` harness        | `buildPred_correct` only     | **harness + tables + Lean + tap**   |
| Build effort                      | medium                         | very high (bridge + perf)    | medium (Layer 1 ≈ A; Layer 2 small) |
| Scales toward n=20                | no                             | no                           | yes (floor rises with `getK` K)     |

---

## Open questions

1. **The feasibility gate: how big is the `pc ≥ 18` (or `pc ≥ 26`) strategy DAG for I9?** This is
   unknown and decides everything. It must be *measured*, not guessed (channel Fermi, then
   verify). The `M_MODEL` proof-DAG tap already exists — instrument it to count **distinct AND/OR
   strategy-DAG nodes** (not all visited nodes) for a known result first.
2. **Independent leaf resolver vs exhaustive table re-check** — which gives cheaper credible
   independence for Layer 2? A from-scratch naive `W_K` in the checker's language, or regenerate +
   diff the W0..W8 tables and lean on `buildPred_correct` for the 9 ply up to K=17?
3. **Canonical key in the certificate.** Dump raw 384-bit board keys (checker dedups by state,
   larger file) or the solver's D4/iso-canonical key (smaller, but the checker must then trust —
   or independently reproduce — the canonicalization)? Leaning raw-state for independence.
4. **Partial coverage as a fallback.** If I9's full DAG doesn't fit, what do we certify and how do
   we *state it precisely*? Candidate: certify the PV spine + a frontier of largest-feasible
   sub-positions via `--after`, and report exactly which lines are machine-checked vs cross-config.
5. Does `skip[18,25]` change the certifiable object? (The skipped `pc` 18–25 nodes are recomputed,
   not stored — they become Layer-1 interior nodes the checker expands, or Layer-2-style recomputed
   leaves. Decide which keeps the DAG smallest.)

## Recommendation

**Approach C (tablebase-grounded hybrid)** is the right target, with **Approach A's checker as its
Layer 1** (so the work is shared, not wasted).

Justification, tied to this project's specifics:

1. **C is the only approach whose object matches the solver's own proof DAG.** The architecture
   was *built* to avoid expanding `pc ≤ 17` (that is what `getK` is) and to skip storing `pc`
   18–25. A (to terminal) and B (whole-DAG in the kernel) both re-introduce exactly the work the
   design eliminated — the 42× full-reachable blow-up that already killed full-board certify. Only
   C's `pc ≥ 18` strategy DAG can be the size of the real proof, which is the difference between
   feasible and not.
2. **C reuses the most that already works:** the `check_cert.py` rules-re-derivation + fault
   injection (Layer 1), the `certify --after` sub-position machinery and the small, enumerable
   W0..W8 tables (Layer 2), and — for free — Lean's `buildPred_correct`/`win_emb`, which *already*
   kernel-prove the one-ply recurrence the leaf layer leans on. Nothing here is greenfield.
3. **It clears the stated bar honestly.** "A verdict we can't certify, we don't claim." C produces
   a decomposed but real proof — interior by game rules, leaves by an independently recomputed
   tablebase — and degrades gracefully (open question 4) to "here is exactly the part we
   machine-checked" if the root proves too big. A can't reach the root; B can't reach n=18 at all.

Keep B's bridge (`queenGraph`, decidable move-gen) as an **optional Phase 5 trust upgrade** for
the *leaf layer only* (a bounded object), not as the whole-verdict path.

### Implementation phases

**Phase 1 — Feasibility gate (do this before building anything).** Extend the `M_MODEL` proof-DAG
tap to count **distinct AND/OR strategy-DAG nodes** (OR = one chosen move; AND = all replies),
bucketed by `pc`, for: (a) n=16 (known SECOND-player — gives ground truth and the `pc ≥ 18`
node count), and (b) an n=18 sub-position via `--after` that already certifies. Extrapolate the
I9 root size. **Decision point:** if the `pc ≥ 18` DAG is within a checkable budget (target:
fits RAM and a CPython/Rust re-derivation in hours), proceed; else go to the partial-coverage
fallback (open question 4) and scope what's certifiable.

**Phase 2 — Certificate format + extraction.** Define the two-layer format (interior
`WIN{move,child}` / `LOSS{children}`, leaves `pc≤17 → value`, raw-state keys). Emit it from a
solve (or a re-solve pass that walks the winning strategy), validated first on small n where the
full object is trivially small.

**Phase 3 — Two-layer checker + fault injection.** Layer 1: extend `check_cert.py` to walk the
interior under game rules (all-replies-covered check is the load-bearing one). Layer 2: an
*independent* `W_K` leaf resolver (or exhaustive W0..W8 re-derivation). Validate end-to-end on
n≤12, then n=14 and n=16 (must reproduce SECOND); inject faults (flip a witness move, drop one
AND reply, corrupt a leaf value) — each must **REJECT**.

**Phase 4 — n=18.** Certify the `--after` sub-positions that fit; then attempt the I9 root if
Phase 1 cleared it. Whatever the coverage, record precisely what is machine-checked vs. what
rests on cross-config agreement, and update the umbrella + the report's verification section.

**Phase 5 (optional) — Lean trust upgrade for the leaf layer.** Build the `queenGraph` bridge and
discharge the bounded `pc ≤ 17` tablebase (and, if small, a verified interior slice) through the
kernel, removing the self-asserted adequacy from Layer 2.
