# C522 — Is `Y_NK0` a complete bulk-descent certificate? (Route 3)

**Lane:** `cap`. **Task:** C522 (reserved 2026-07-23, `[cap]`). **Route:** the cold-start
[C80 alt-attack plan](2026-07-23-c80-alt-attack-plan.md) Route 3 — descent into the proven-P
`Y_NK0` guard. **Owner spine:** C80.

## Question

C80(b) bulk descent asks: from every opponent intrusion the responder has a certified winning
reply into a proven-P packet. The proven-P packet on the table is `Y_NK0` (empty live conic +
every capacity-2 line carries ≤2 legal points + residual conflict graph Grundy-0 ⟹ Node-Kayles
⟹ P). The frozen census
([`c80_response_fibre_census.py`](../rust/scripts/c80_response_fibre_census.py)) reported `Y_NK0`
covering only 2,822 / 59,153 q17 *primitive-`Y_0`* transitions and rejecting 108 `clean_empty`
members (104 P, 4 N). That census restricts to **primitive off-conic `Y_0` replies**. The real
descent question is over **all legal replies**.

**C522 asks:** over the frozen q13/q17 three-intruder domain, does every `child` (one intruder
opponent move from a recorded C20 P reply state) admit *some* legal reply — of any kind — landing
in a `Y_NK0` state?

## Result — `Y_NK0` alone is NOT a complete descent certificate

`Y_NK0`-reply existence checked structurally (no minimax) over **all** legal replies; the gap
children then classified by minimax.

| q | unique 3-intruder children | ≥1 `Y_NK0` reply | no `Y_NK0` reply | gap % |
|----|---------------------------|------------------|------------------|-------|
| 13 | 1,287                     | 1,283            | 4                | 0.31% |
| 17 | 50,517                    | 45,820           | 4,697            | 9.29% |

**Every gap child is N (responder-to-move wins)** — 4/4 at q13, 4,697/4,697 at q17 — a clean
consistency check (all children arise from an opponent move out of a P reply state, so all must be
N; zero P children, zero "responder-win with no P reply" bugs). So the responder always *has* a
winning reply; it simply need not land in `Y_NK0`.

Winning-reply kinds at the q17 gap children:

| winning-reply kinds available | children |
|-------------------------------|----------|
| intruder only                 | 2,967 (63%) |
| conic + intruder              | 1,528 (33%) |
| conic only                    | 202 (4%)  |

A conic winning reply exists at **1,730 / 4,697 (37%)**; the other **2,967 (63%)** need a
non-`Y_NK0` intruder reply.

## Where the gap targets live — the companion guard cannot be empty-conic

Classifying every winning-reply target grandchild of the q17 gap children by
`(live-conic size, capacity-2 guard)`:

| gap children by min live-conic over their winning replies | q17 |
|-----------------------------------------------------------|-----|
| min_live = 0 (can reach an empty-conic P target)          | 504 (10.7%) |
| min_live = 1                                              | 3,817 |
| min_live = 2                                              | 329 |
| min_live = 3                                              | 45  |
| min_live = 4                                              | 2   |

**Only 504 / 4,697 (10.7%) of the gap can descend to an empty conic in one winning reply** — and
even those land in `empty_capOVER` (an overloaded capacity-2 line, the 104-`clean_empty`-reject
style), never a clean empty-conic Node-Kayles base. **4,193 / 4,697 (89.3%) are forced to keep the
conic live.** The easiest winning reply per gap child is `live1_capOK` (a single live conic
parameter, capacity-2 lines fine) for **3,593** of them.

So a second *empty-conic* Node-Kayles packet cannot close the gap. The recurring companion object
is the **single-live-parameter state** — precisely the "one live conic parameter before the reply"
structure the cap handoff already isolated for the q17 score-9 stratum, now shown to be the
**generic** obstruction across the entire q17 three-intruder domain, not a score-9 artifact.

## Reading

The literal Route 3 target — "bulk descent into `Y_NK0`" — is **incomplete even with all legal
replies allowed**, and the incompleteness is not a primitivity artifact (this probe drops the
primitive-`Y_0` restriction entirely). q13 is a near-miss (4 gap children); q17 is a genuine 9.3%.
The gap splits into a conic-reply branch (37%) and a non-`Y_NK0` intruder-repair branch (63%), but
the sharper cut is by residual conic content: **89% of the gap never reaches an empty conic in one
move.** The bulk-descent theorem C80(b) therefore needs a **single-live-parameter P-guard** as its
companion packet, not a second empty-conic guard. That guard is the queued successor.

## Reproduction

- **Script:** `rust/scripts/c522_ynk0_descent_completeness.py` (reuses the frozen inputs and the
  committed census helpers `c80_response_fibre_census.py`, `2026-07-08-zone-repair-geometry.py`).
- **Certificate:** `notes/2026-07-23-c522-ynk0-descent-completeness.json`.
- **Input:** `notes/data/c20-q13-q17-states.jsonl.gz`
  (sha256 `952f189cc37bac36026238d75bccffb7feb560644582bf8c6373789a98f43f4d`, 654,965 bytes).
- **Replay:** `python3 rust/scripts/c522_ynk0_descent_completeness.py --check` → PASS.

`Y_NK0`-reply existence is a structural predicate (no minimax); every gap child is then verified N
by exact minimax, with a guarded `responder_win_with_no_p_reply == 0` consistency assertion (0 at
both q).

## Mystery ledger

- **Settled (ej):** *Why does the primitive-`Y_0` census undercount the descent gap?* Because the
  responder's winning reply is frequently non-primitive or conic — dropping the primitivity filter
  raises `Y_NK0`-covered children from the census's 2,822 primitive transitions to 45,820 unique
  children, but the residual 4,697 gap is real and survives all legal replies.
- **Settled (ej):** *Is the gap an empty-conic-guard tuning problem?* No. 89% of the q17 gap cannot
  reach an empty conic in one winning reply; the companion guard must handle live-conic states.
- **Open — owner: successor guard task (queued).** *Is `live1_capOK` (single live conic parameter,
  capacity-2 lines ≤2) a P-certifiable family, and does it admit its own descent?* The 3,593
  easiest-reply targets suggest yes, but this is unverified — it is the next companion-guard build,
  not a C522 claim.
- **Open — owner: C82.** Whether the two-branch responder strategy (`Y_NK0` on 90.7% of children +
  a single-live-parameter guard on the rest) is countable for abundance.

## Vibe

A clean, decisive negative that converts a vague "or add a companion guarded packet" into a
precisely specified target: the companion packet is the single-live-parameter state, and any hope
of closing C80(b) with a second *empty-conic* Node-Kayles guard is off the table (89% counterexample
mass). Route 3 did its job — it didn't yield the descent lemma, but it killed the wrong shape and
named the right one.
