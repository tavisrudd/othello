# C80 — the C496 factorization recursion-stability probe

**Lane:** `cap` (C80 spine). **Date:** 2026-07-23. C447/C496 artifacts are read-only, hashed inputs.

**Verdict:** `NOT recursion-stable (degenerate, not violated).` The C496 factorization
`value = 1_live ⊗ χ(u)` is a **depth-0 base fact**; relative to the fixed frame edge it does not
recur, and the frozen q=11 cloud packet bottoms out too shallow (≤ 3 exchanges) to host a genuine
recursion. C80(b) does **not** collapse onto the proven C80(c) drain measure via the static `χ`
overlay as-is.

## What the probe tested

C496 proved, on the frozen q=11 C447/C460 cloud packet at the seed P-position: an opponent move `x`
admits a winning **packet** reply iff

```text
value(x) = 1_live(x) ∧ [χ(u(x)) = −1],
```

with `1_live(x) = "x has a legal packet reply"`, `u(x)` the fixed frame-edge quotient `XZ/Y²`, and
`χ = Legendre mod 11`. C496 flagged this as **depth-1 only** — it does not show the factorization
survives the game recursion (the "preserving P/N recursion" clause = C80(b)). The handoff pegged the
recursion-stability probe as the highest-EV C80 move: if the law recurs, C80(b) reduces to the
already-proven C80(c) live-conic drain (`|live conic|` drops per move) with `χ` a static side-condition.

The probe descends the **complete** P-subtree from the seed under opponent-arbitrary /
responder-any-winning play (the P-nodes the descent must survive) and checks, at every P-node and
every opponent move, whether the same fixed law — same edge, same character `χ`, same 5-cell packet —
holds. Exhaustive and deterministic; `--check` re-derives the committed certificate.

## Findings

**1. Depth-1 reproduces C496 exactly** (reconstruction validated against the frozen certificate):
`u=8 → winning packet reply (χ=−1, P)`, `u=9 → none (χ=+1, N)`, 12 killed (`u ∈ {0,1,∞}`).
`χ` separates value with zero violations on the 10 live moves.

**2. The subtree is an endgame, not a recursion.** From the 4-cap seed the whole game is ≤ 3
exchanges:

| depth | P-nodes | cap size | terminal P-nodes |
|------:|--------:|---------:|-----------------:|
| 0 | 1 | 4 | 0 |
| 1 | 41 | 6 | 26 |
| 2 | 15 | 8 | 0 |
| 3 | 1 | 10 | 1 |

26 of 41 depth-1 P-nodes are **terminal maximal caps** (P by free parity, no `χ` content). There is
almost no recursion to observe.

**3. The `χ`-straddle is a depth-0-only event.** Opponent-move `u`-distribution vs the fixed frame edge:

```text
depth 0:  u=8(χ=−1):5   u=9(χ=+1):5   u=1(χ=+1):5   u=0:1   u=∞:6
depth 1:  u=1(χ=+1):50  u=∞:10
depth 2:  u=1(χ=+1):25  u=∞:5
```

The live packet class and the `{8,9}` square/nonsquare straddle — the entire engine of the
factorization — exist **only at depth 0**. At every deeper P-node every opponent move collapses to
`u ∈ {1, ∞}` (`χ=+1`/none). So the fixed-edge law has **zero live rows** to govern past depth 0: its
apparent "stability" is vacuous, and the phenomenon it describes never recurs.

**4. The value-carrying replies live off the conic.** 4 of the 5 packet cells are off-conic
intruders (only `(6,2)` is on-conic). The C496 winning replies are predominantly **intruder** moves,
whereas the proven C80(c) drain measure `|live conic|` tracks **on-conic** moves. Even at depth 0,
`χ(u)=−1` does not imply a winning on-conic reply (2 of 5 do, 3 do not). The value sort and the drain
sort are on different move types — a second obstruction to the clean "collapse onto C80(c)."

## Bearing on C80

- The C496 depth-1 caveat is **confirmed and sharpened**: the factorization is a base-case knife-edge
  fact tied to the seed's frame edge, not a descent law. C80(b) is untouched.
- **Why it does not recur:** `u`, the packet, and the `χ`-straddle are all defined against the seed's
  fixed frame edge, which is the correct coordinate only for the seed's first response. To make the
  factorization a descent law one must **re-derive the `(edge, packet, χ-straddle)` triple at each
  P-node** — a level-indexed object C496 did not build. This is the corrected next deliverable.
- **The frozen q=11 packet cannot be the test bed.** It is a 4-cap endgame that terminates in 1–3
  plies; recursion-stability is not observable there in principle. A real test needs a deeper
  instance — a mid-game bulk position (e.g. the q17 `Y_NK0` 8-cap members with plies remaining) or a
  larger `q` residual game — where multi-ply descent actually happens. The handoff's expectation that
  this frozen structure would be "decisive either way" on recursion is met only in the negative sense:
  it is decisively too shallow.

## Mystery ledger (ej closeout)

- **Settled — the factorization is depth-0.** The `{8,9}` straddle and the live packet appear only at
  the seed; past depth 0 all moves are `u ∈ {1,∞}`, `χ=+1`. Measured exhaustively over the full
  58-node P-subtree.
- **Settled — the "collapse onto C80(c)" is blocked twice over:** (i) no `χ`-live rows recur; (ii) the
  value-carrying replies are off-conic intruders while the drain measure is on-conic.
- **Open — the recursive object.** Whether a level-indexed `(edge, packet, χ-straddle)` re-derivation
  restores a descent law is the reshaped C80(b) question. Not built here. Owner: C80.
- **Open — the deeper-instance test.** What governs value at the depth-≥1 (post-straddle) regime? Here
  it is mostly terminal parity, but that is an endgame artifact; the general-`q` bulk regime is
  unprobed. Candidate test bed: q17 `Y_NK0` members. Not allocated.
- No manufactured mystery: the negative is clean and the reason is geometric (fixed-edge coordinate
  does not transport).

## Reproduction

Run from `/home/tavis/src/othello`:

```bash
python3 rust/scripts/c496_recursion_stability_probe.py --write   # regenerate certificate
python3 rust/scripts/c496_recursion_stability_probe.py --check   # verify (PASS)
```

Python 3.13. The probe reuses the committed frozen constructors in
`rust/scripts/c80_c447_cloud_packet.py` (seed / packet / frame edge / `edge_quotient_u`) and the
shared residual-grid game engine `notes/2026-07-08-intrusion-census.py` (`PrimeGridGame`, exact
memoized minimax `value`). It reconstructs the seed P-position and the 5-cell packet, exhaustively
walks the P-subtree with mask memoization, and asserts the depth-1 histogram matches C496 before
recording the per-depth `u`/`χ`/liveness/win-kind table into the canonical certificate.

Trust boundary: exact `F_11` arithmetic; the game engine and the frozen C447/C460 constructors are
the shared frozen inputs (same boundary as the C496 bundle — the value recursion is the shared
engine). No independent second implementation: the primary is itself an **exhaustive** walk of the
complete game subtree over an exact solver, and `--check` pins byte-for-byte determinism. No
general-`q`, novelty, or priority claim is made.

### Artifact hashes

| artifact | SHA-256 |
|:--|:--|
| probe `.py` | `062c0f421987e9fcbd377854e73143e5df5e7c3d591a5f72e27bd7cee9f341ed` |
| certificate JSON | `1752b1030eba10f0a1baeb3b07f0be8258b2fdf1e2fc872296dc80aa87367615` |

### Load-bearing inputs (hashed)

| input | SHA-256 |
|:--|:--|
| `rust/scripts/c80_c447_cloud_packet.py` | `308a3b6c3ff6476e0ac6ec7a7902c19edffd97a59c9f0eda94593a7518ae6721` |
| `notes/2026-07-08-intrusion-census.py` | `6f1f7e1e36ff3a3ed5d5f0c410b8d6bacb5be23a73503e669489e4cf06f14c83` |
| `notes/2026-07-21-c447-cap-knife-edge.json` | `8c1e22da244ef2879273d3c0aeefc590e645386f70270e329d030fe48a5906c7` |
