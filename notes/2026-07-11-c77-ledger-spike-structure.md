# C77 follow-up — the ledger debt is a first-intrusion spike, and its "flatness" does NOT survive past q=19

**2026-07-11 (Claude, lane C / Cluster-2).** Second C77 measurement, extending the first bank probe
([`2026-07-11-c77-ledger-bank-probe.md`](2026-07-11-c77-ledger-bank-probe.md)). Two new instruments
were added to `notes/2026-07-06-grid-cap-solver.rs` and built into `rust/target/gridcap-ledger`:

- `s4ledger … --pv` — reconstructs the optimal-bank **principal variation** (root → peak → end) and
  a **per-ply Ψ-max histogram**, so we can see *where* the bank peak sits.
- `s4spike <q> t1,t2,t3,t4 [--depth D]` — a **solve-free** shallow probe: BFS the root's descendants
  to depth D and report per-ply max Ψ. No Grundy dump, O(q²)–O(q⁴) states, sub-second to seconds. It
  reaches the gated q ≥ 23 orders the full census cannot.

## 1. The debt is a single first-intrusion spike, not an accumulation

The `--pv` trace shows the optimal-bank line has the same shape at every order: Ψ rises **only** on
the opponent's first intrusion (size 5, the move out of the root frame), and is **monotone-decreasing
on every subsequent ply** down to the terminal. So `debt = bank_opt − Ψ_root` is entirely that one
first-move jump.

The per-ply Ψ-max confirms the global Ψ-max is attained at ply 5 (through q=19), so:

```
debt(q) = max(0, maxΨ(size-5 children of root) − Ψ_root)          [exact through q=19]
```

`s4spike` reproduces the full-DAG `s4ledger` debt **exactly** at every solved order (and the identical
argmax-intrusion cell): q17 (8,15), q19 (7,11).

| q  | Ψ_root | ply5 max | debt (s4ledger) | debt (s4spike, solve-free) | root value |
|---:|-------:|---------:|----------------:|---------------------------:|:-----------|
| 9  | 26     | 18       | 0               | 0                          | P |
| 11 | 48     | 36       | 0 (trivial)     | 0                          | **N** (frame `1,2,3,4` is N at q=11) |
| 13 | 60     | 55       | 0               | 0                          | P |
| 17 | 84     | 106      | **22**          | **22**                     | P |
| 19 | 96     | 118      | **22**          | **22**                     | P |

(q=11: the normalized frame `1,2,3,4` is N-valued, so its "debt 0" is trivial — at an N root we move
first and step straight to a P child, no forced Ψ-rise. Not comparable to the P-rooted orders.)

## 2. The first-intrusion spike is genuinely bounded / flat

The solve-free ply5 spike (rigorous: the opponent moves freely from the P-root, so every size-5 state
is reachable and `maxΨ(ply5) − Ψ_root` is an **exact** debt lower bound) stays small and roughly
constant out to q=31:

| q         | 17 | 19 | 23 | 25 | 27 | 29 | 31 |
|-----------|---:|---:|---:|---:|---:|---:|---:|
| ply5 spike| 22 | 22 | 24 | 26 | 25 | 24 | 26 |

**So the first intrusion never lifts Ψ by more than ~26.** That component of the C77 bank is
q-independent, and it is the whole story at q ≤ 19.

## 3. …but the "flat 22" does NOT extrapolate past q=19

The `s4spike` per-ply Ψ-envelope (depth 2–3) reveals that from **q = 23** the envelope peak leaves the
first intrusion, migrates deeper, and climbs — roughly linearly in q:

| q  | ply5 | ply6 | ply7 | envelope peak ply | **raw height above root** |
|---:|-----:|-----:|-----:|:------------------|-------------------------:|
| 17 | 106  | 82   | 64   | ply5              | 22 |
| 19 | 118  | 117  | 90   | ply5              | 22 |
| 23 | 144  | **185** | 151 | ply6            | **65** |
| 25 | 150  | 193  | **195** | ply7+ (rising)  | **71** |
| 27 | 171  | 213  | **244** | ply7+ (rising)  | **≥98** |
| 29 | 180  | 226  | **298** | ply7+ (rising)  | **≥142** |

The first probe's "bounded/flat debt (22 at both q=17 and q=19)" was an **artifact of the two sampled
orders**: they are exactly the orders where the Ψ-envelope happens to peak at the first intrusion.
From q=23 the peak sits at the second/third intrusion and its height above the root grows.

## 4. What is and isn't established

- **Rigorous:** through q=19 the debt is a single ply-5 spike (22); the ply-5 spike alone (an exact
  debt *lower bound*) is bounded ~22–26 through q=31 — the first-intrusion component does not grow.
- **The open gap:** for q ≥ 23 the true debt lies between the exact ply-5 lower bound (~24) and the raw
  envelope upper bound (65, 71, ≥98, ≥142 …). The raw envelope is **not** P-restricted — it counts
  size-6/7 states the defender might avoid. At q=17/q=19 the defender's P-restriction did keep the
  reachable peak at ply5 (e.g. q=19 raw ply6 = 117 came within 1 of ply5 = 118, yet `bank_opt` stayed
  118). Whether that dodge survives the growing deep envelope at q ≥ 23 is the whole question.
- **Cannot be settled on this box.** Resolving it needs the P-restricted root-`1,2,3,4` DAG solved to
  full depth (P/N labels). Sizing from the state growth (q13 1.1k → q17 186k → q19 2.7M, ~0.58
  dlog₁₀/q and rising): **q23 ≈ 6·10⁸ states ≈ 15 GB dump / ~25 GB solve-RAM; q25 ≈ 9·10⁹ ≈ 370 GB.**
  The box has ~12 GB free — a q23 root solve would OOM (and the project's OOM hygiene forbids it). So
  the exact q ≥ 23 debt needs a ≥32 GB box (q23 only; q25 is infeasible by brute force) **or** a
  bounded-depth P-oracle we do not yet have.

## 5. Reading for the lever

The amortized/ledger bank's key premise — a **q-independent** bank capacity — is now in serious doubt.
Either the required capacity grows with q (fatal to a uniform proof via a fixed bank), or the
defender's P-restriction dodges a deep envelope that grows ~linearly (a strong, unproven claim). The
salvageable, proven fact is narrower: **the first intrusion is cheap (spike ≤ ~26, q-independent).**
The lemma target should move to the *second/third* intrusion — either prove the defender can hold the
reachable peak at ply5 (making the raw envelope irrelevant) or accept a q-growing bank and look for a
different repay mechanism.

**Decision for the user:** the one measurement that settles it is the q=23 root-`1,2,3,4` solve
(~25 GB, minutes-to-an-hour on a ≥32 GB box) — much cheaper than the full 42-bucket q29 census, but
still gated and off the current box. Recommend provisioning a ≥32 GB box for that single solve if the
bank lever is to be kept alive; otherwise pivot Cluster-2 to the ply5-hold sublemma.

## Reproduction

```bash
cd rust
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap-ledger
# solve-free spike probe (any prime-power q):
for q in 17 19 23 25 27 29 31; do ./target/gridcap-ledger s4spike $q 1,2,3,4 --depth 3; done
# principal variation + per-ply Ψ-max on a solved order:
./target/gridcap-ledger s4ledger 19 1,2,3,4 --grundy s4-dumps/2026-07-09/c35/q19-root-1234.grundy.raw --pv
```
