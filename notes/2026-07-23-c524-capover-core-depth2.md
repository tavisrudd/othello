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

## `ej` — q19 confirms uniform depth-2, and corrects the Weil intuition

Extending the same certificate to the frozen q19 census (`c20-q19-states.jsonl.gz`, separate committed
cert `2026-07-23-c524-capover-core-depth2-q19.json`):

| q  | children  | `Y_NK` depth-0 | depth-0 coverage | `capOVER` residual | depth-2 certified | uncertified |
|----|-----------|----------------|------------------|--------------------|-------------------|-------------|
| 13 | 1,287     | 1,287          | 100%             | 0                  | 0                 | 0           |
| 17 | 50,517    | 50,168         | 99.3%            | 349                | 349               | 0           |
| 19 | 1,136,630 | 1,088,546      | 95.8%            | 48,084             | 48,084            | **0**       |

**Depth ≤ 2 closes 100% at all three orders** — including q19, a non-depleted all-P order with over a
million children. This is the first real evidence the depth bound is **uniform (2)**, not growing —
the load-bearing support for gap-1 (the `capOK`-absorbing induction) of the uniform-`q` program.

**Correction to the earlier Weil read.** The residual `capOVER` fraction **grows** with `q`
(0% → 0.69% → 4.23%), not shrinks — so descent closure is **not** a "generic + finitely many base
cases" phenomenon. The depth-2 bridge is load-bearing and increasingly so, yet closes every child. So
Weil / finite-exceptions belongs to the **(ON) abundance / P-child depletion** layer (the sporadic
{11,17}), a different quantity; the **descent** piece looks like a clean, uniform combinatorial
depth-2 theorem (guard + bounded-depth bridge), needing no character/counting input. Caveat: three
orders, and the q19 domain is a denser census than q17 — the fraction trend is directional, not an
established asymptotic.

Replay: `python3 rust/scripts/c524_capover_core_depth2.py --rows notes/data/c20-q19-states.jsonl.gz
--q 19 --output notes/2026-07-23-c524-capover-core-depth2-q19.json` (add `--check` to verify).
Input `c20-q19-states.jsonl.gz` sha256 `5ddea78f59898c194b2fdedda9871d7787dac577bef0aa44e5483e5109589e8a`.

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
  `capOVER` bridge) generalize to all odd `q`? q13/q17/q19 all close at depth ≤ 2 (the `ej` addendum),
  so the target is a **uniform depth-2 routing theorem** — the residual `capOVER` core is
  bounded-depth routable for all odd `q`. This is a combinatorial statement (no Weil), unlike the
  (ON)-abundance layer.
- **Open — owner: formalization lane.** Lean statements of `capOK ⇒ P iff full-graph Grundy 0` (C523)
  and the depth-2 routing lemma (C524).
- **Open — owner: C82.** Countability of the two-tier strategy for abundance.

## Vibe

This is the finish line for C80(b) at every tested order: the descent gap went 9.3% → 0.7% (C523) →
**0** (C524), and the same minimax-free depth-2 certificate closes q13, q17, **and q19** (1.1M
children) — 0 uncertified everywhere, depth ≤ 2 throughout. The odd-`q` crown is still open — three
primes over the frozen domain — but C80(b) has gone from "prove bulk descent" to "prove a uniform
depth-2 routing theorem," a clean combinatorial target with no arithmetic input, which is a
categorically better place to stand.