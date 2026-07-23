# C524 — the `capOVER` core closes by depth-2 descent into `Y_NK`

**Lane:** `cap`. **Task:** C524 (reserved 2026-07-23, `[cap]`). **Owner spine:** C80.
**Predecessors:** [C522](2026-07-23-c522-ynk0-descent-completeness.md) (`Y_NK0` incomplete),
[C523](2026-07-23-c523-ynk-full-graph-guard.md) (`Y_NK` guard → q17 99.3% coverage, 349 residual).

## The certificate

C523 left a residual of **349 q17 three-intruder children** whose every winning reply is `capOVER`
(a capacity-2 line with ≥3 legal points), so no reply is `Y_NK`-certifiable at depth 0. C524 tests a
**bounded-depth** certificate that needs no minimax, only the proven `Y_NK ⟹ P`:

> A residual child `C` (N, responder to move) is **depth-2 certified** if the responder has a reply
> `r` into `G = C∪{r}` such that **every** opponent move `o` from `G` admits a responder reply `p`
> with `G∪{o,p} ∈ Y_NK`. Then every opponent move from `G` loses (the responder answers into a
> proven-P `Y_NK` state), so `G` is P, so `C` is N via `r`.

This is a self-contained two-ply Node-Kayles strategy: `Y_NK` at depth 0 where available, else one
`capOVER` step into `G` followed by `Y_NK` on every opponent continuation.

## Result — the q17 three-intruder domain is fully certified

| q  | children | `Y_NK` depth-0 | `capOVER` residual | depth-2 certified | uncertified |
|----|----------|----------------|--------------------|-------------------|-------------|
| 13 | 1,287    | 1,287 (100%)   | 0                  | 0                 | **0**       |
| 17 | 50,517   | 50,168         | 349                | **349**           | **0**       |

**Every child in the frozen q17 three-intruder domain has a certified responder winning reply** —
`Y_NK` at depth 0 (99.3%) or a depth-2 descent into `Y_NK` (the 349 `capOVER` core). q13 was already
closed at depth 0. The 349 witness replies are recorded by digest
(`40c0e80c…` for q17) and reproduce deterministically.

Combined with C523, this is a **complete Node-Kayles descent certificate for the q17 three-intruder
domain**: the responder never leaves the guard family — where `Y_NK` does not apply directly, one
`capOVER` step reaches a position all of whose opponent continuations are answered into `Y_NK`.

## Reading

C80(b) asks for bulk descent into a proven-P packet. At q17 that is now delivered as a two-tier
Node-Kayles strategy (`Y_NK` + a depth-2 `capOVER` bridge), with **zero states left to minimax**. The
`Y_NK ⟹ P` law does all the certifying; the two-ply lookahead only routes the `capOVER` states into
it. This does not by itself prove the odd-`q` crown — it is q17-specific (and q13) over the frozen
reachable domain — but it removes the last computational unknown at q17 and turns C80(b) into a
purely structural object: a guard (`Y_NK`) plus a bounded-depth routing lemma.

## Reproduction

- **Script:** `rust/scripts/c524_capover_core_depth2.py` (structural certificate; reuses the frozen
  inputs and the committed helpers `c80_response_fibre_census.py`, `2026-07-08-zone-repair-geometry.py`).
- **Certificate:** `notes/2026-07-23-c524-capover-core-depth2.json`.
- **Input:** `notes/data/c20-q13-q17-states.jsonl.gz`
  (sha256 `952f189cc37bac36026238d75bccffb7feb560644582bf8c6373789a98f43f4d`, 654,965 bytes).
- **Replay:** `python3 rust/scripts/c524_capover_core_depth2.py --check` → PASS.

The certificate is minimax-free (only structural `Y_NK` checks); embedded minimax assertions merely
guard the `Y_NK ⟹ P` dependency (every residual child verified N, every witness reply verified P).

## Mystery ledger

- **Settled (ej):** *Does the `capOVER` core need its own P-law?* No. Depth-2 lookahead routes every
  `capOVER` residual into `Y_NK`; no separate guard for the triple-semantics core is required at q17.
- **Settled (ej):** *Is depth-2 tight, or would depth-1 do?* Depth-1 fails by construction (these are
  exactly the `Y_NK0`/`Y_NK`-uncovered children); depth-2 suffices for all 349. Whether some deeper
  order is ever needed at larger `q` is the uniform-`q` question below.
- **Open — owner: C80 uniform-`q` crown.** Does the two-tier certificate (`Y_NK` + bounded-depth
  `capOVER` bridge) generalize to all odd `q`? The residual `capOVER` core must be shown bounded-depth
  routable uniformly — the successor to this q17 closure. (q13/q17 give depth ≤ 2.)
- **Open — owner: formalization lane.** Lean statements of `capOK ⇒ P iff full-graph Grundy 0` (C523)
  and the depth-2 routing lemma (C524).
- **Open — owner: C82.** Countability of the two-tier strategy for abundance.

## Vibe

This is the q17 finish line for C80(b): the descent gap went 9.3% → 0.7% (C523) → **0** (C524) across
this session, and the responder now has a fully certified, minimax-free winning strategy from every
three-intruder child at q17, entirely inside the Node-Kayles guard family. The odd-`q` crown is still
open — this is one prime, over the frozen domain — but C80(b) has gone from "prove bulk descent" to
"generalize a clean, closed q17 certificate," which is a categorically better place to stand.