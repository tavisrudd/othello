# C77 — amortized-ledger bank probe: the minimax peak-Ψ debt is bounded (0, 22, 22)

**2026-07-11 (Claude, lane C / Cluster-2).** First measurement for the C77 amortized/ledger route
(the surviving Cluster-2 lever after C75/C76 showed no pointwise value-blind selector). Solver mode
`s4ledger` added to `notes/2026-07-06-grid-cap-solver.rs`; built `rust/target/gridcap-ledger`.

## The instrument

`s4ledger <q> 1,2,3,4 --grundy <dump>` reconstructs the exact P-restricted game DAG from the
on-disk Grundy dump and computes the **minimax peak-Ψ bank**:

```
bank(state) = peak Ψ from state to the end (inclusive), where at an N-position (WE move) we
              MINIMIZE over P-children (g0) and at a P-position (opponent moves) the adversary
              MAXIMIZES over all children.
```

`bank(root)` with the exact min is the **optimal (value-aware) bank ceiling** — the smallest peak Ψ
any correct second-player strategy can guarantee. `debt = bank(root) − Ψ_root` is how far above the
root the opponent can force Ψ, i.e. the capacity an amortized bank must carry. Ψ is the C63 integer
potential (`s4_candidate_psi`). "Value-blind" here = blind to the Grundy label except the
P-restriction (the existential/oracle selector is allowed to know which children are P; the *choice*
among P-children is geometric).

## Result — the debt plateaus, it does not grow with q

| q  | states    | Ψ_root | bank_opt | **debt** | note |
|---:|----------:|-------:|---------:|---------:|:-----|
| 13 | 1,117     | 60     | 60       | **0**    | bank flat — Ψ never rises above root under correct play |
| 17 | 186,466   | 84     | 106      | **22**   | debt nonzero ⇒ no monotone-descent strategy (consistent with C63) |
| 19 | 2,691,979 | 96     | 118      | **22**   | debt **unchanged** from q=17 while Ψ_root grew |

**The excess Ψ the opponent can force above the root is a bounded constant (22 at both q=17 and
q=19), even though Ψ_root itself grows ~linearly (60 → 84 → 96).** This is the signal the amortized
argument needs: a bank of fixed capacity ~22 suffices to absorb the opponent's forced Ψ-rise at
q=17 and q=19; it does not scale with q over this range.

`bank_opt` equals the global Ψ-max in both q=17 (106) and q=19 (118): the opponent's best line runs
through the single highest-Ψ position, which is an early (low-ply) intrusion — Ψ peaks early (high
reservoir slack) and the debt measures how much the opponent's first intrusion lifts it.

**Every scalar-among-P selector achieves the optimal ceiling** (psi_min, live_min, defect_min,
zero_xor_live_min, psi_live_min all report the same bank at every q). So the bank ceiling is a
property of the P-restricted DAG, not the selector choice — the opponent's maximization sets the
peak regardless of which P-reply we pick. None loses (restricting to P-children, a P-reply always
exists), as expected.

## What this establishes / what's next (fresh-session hand-off)

- **Establishes:** on the root `[1,2,3,4]` DAG through q=19, an amortized bank on the C63 potential
  is *bounded by a q-independent constant* (0/22/22). The C77 route is numerically alive — the exact
  obstruction C75/C76 found (no pointwise selector; Ψ must rise) is survivable with a fixed bank.
- **Open, for the next session:**
  1. **More orders.** Add q=11 (the other depleted order) and, if a dump exists, q=23/q=25, to test
     whether the debt stays flat (22) or is the start of slow growth. Depletion does *not* predict it
     so far (q13 non-dep debt 0; q17 dep 22; q19 non-dep 22).
  2. **Is 22 exact-twice a coincidence?** Check whether the debt is set by Ψ granularity / a specific
     early intrusion; dump the argmax line (the state where the peak is hit) at q=17/q=19 and compare.
  3. **Off-root obligations.** This is the root DAG; the (ON) escape proof needs the bound at the
     escape obligations too. Extend `s4ledger` to root the DP at the C75/C76 hard obligations.
  4. **Frame-aware selector.** Port the C76 frame-relative profiles into the `s4ledger` selector set
     (currently scalar-only) — though the current result says the *ceiling* is selector-independent,
     so this matters only for a constructive (not just existential) strategy.
  5. **Turn the bound into a lemma.** If the debt stays constant, the amortized statement is
     "Ψ + bank ≤ Ψ_root + C with C ≈ 22 independent of q"; formalize the repay step.

## Reproduction

```bash
cd rust
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap-ledger
for q in 13 17 19; do
  ./target/gridcap-ledger s4ledger $q 1,2,3,4 --grundy s4-dumps/2026-07-09/c35/q$q-root-1234.grundy.raw
done
```
(q=19 ≈ 52 s / 2.7M states; q=13/17 are seconds.)
