# C75 — the value-blind reply selector is impossible in the program feature space

**2026-07-11 (Claude, lane C / Cluster-2, Codex asleep).** A structural impossibility result
that explains and sharpens Codex's C61/C62/C63 "every selector family is uniform-negative" wall.

Script: `rust/scripts/c75_linear_selector_lp.py`. Solver: `gridcap-c75` (built from
`notes/2026-07-06-grid-cap-solver.rs` after the `root_replies` per-reply dump was extended to
carry `chi`/`polar` — see Provenance). No re-solve: reuses the on-disk exact Grundy dumps
`s4-dumps/2026-07-09/c35/q{13,17,19}-root-1234.grundy.raw`.

## The question

The (ON) proof route needs the second player to have a **value-blind** (Grundy-oracle-free,
PGL/Stab-invariant) deterministic reply selector σ that, with the C63 potential Ψ, certifies P at
every on-conic escape at every odd q. Codex has a good Ψ (clean at q=13/17, existence-transfers at
q=19) but no uniform σ: every tested family (`live_min`, `zero_xor_live_min`,
`zero_live_ray_lex_max`, the ρ-refinements, `rect_char_*`, `polar_internal`, …) is **local
positive / uniform negative** — it fixes one order's hard rows but selects an N (losing) reply at
some other root.

Codex tested these families **one hand-picked scalar coordinate at a time**. The untested question
is whether the failure is a *coordinate-choice* problem (some better function of the features works)
or a *feature-completeness* problem (the features themselves cannot separate winning from losing
replies). C75 settles this.

## Method

`s4selectors … --fail-out` dumps, for each hard obligation, every legal reply with its full
value-blind feature vector and its Grundy value (ground truth): `g` (g0 = P/winning reply,
g≠0 = N/losing), `dpsi` (ΔΨ), geometry ∈ {ext, int, on}, `live`, `comp` (defect components),
`xor_zero`, `psi`, `chi` (rectangle/quadratic character), `polar` (polar-internal flag), and the
7-value sorted zone-conflict ray profile. Every field except `g` is a function of the invariant
board geometry, so a selector over them is a legal q-blind strategy.

**Test A — exact feature-twin check (decisive).** Within a single obligation, does a winning reply
(g0, ΔΨ<0) share its *entire* value-blind feature vector with a losing reply (g≠0)? One such twin
means **no** value-blind selector — linear or nonlinear — can pick the winner at that obligation.

**Test B — linear-separability LP (corroboration).** Fix the deepest-descent winning reply as
target; ask HiGHS for one linear functional ranking every losing reply above it, pooled across
orders.

## Result

Over the 108 hard root-frame obligations dumped for the q=13/17/19 root `[1,2,3,4]` DAGs:

| order | hard obligations | with a P/N feature-twin | rate |
|------:|-----------------:|------------------------:|-----:|
| q=13  | 16               | 1                       | 6%   |
| q=17  | 56               | 4                       | 7%   |
| q=19  | 36               | 14                      | 39%  |
| **total** | **108**      | **19** (48 colliding N-replies) | |

**Verified witness** (raw, `q13-detail` opponent `11,0`, both cells legal replies to the same move):

```
6,6 : g0 dpsi-66 ext live0 comp0 xor01 psi-6 chi1 polar0 rays0,0,1,1,2,2,3   ← P (winning)
12,3: g2 dpsi-66 ext live0 comp0 xor01 psi-6 chi1 polar0 rays0,0,1,1,2,2,3   ← N (losing)
```

Identical on all 17 features; only the Grundy value differs. Test B's LP is infeasible, as a
feature-twin forces the constraint `⟨w, 0⟩ ≥ 1`.

## What this means

1. **The wall is feature-completeness, not coordinate-choice.** Codex's uniform-negative result is
   not "the right scalar coordinate wasn't found." The program's feature space
   `{geom, live, comp, xor_zero, Ψ, ΔΨ, χ, polar, ray-profile}` — a **superset** of every C61/C62/C63
   selector family — provably does not separate winning from losing replies: 19 concrete P/N pairs
   are feature-identical. No function of these features (linear or not) is a winning selector.

2. **An order-sensitive rule does not escape it either.** Every twin is *within a single order*
   (both replies at the same q). So even a q-indexed selector σ(features, q) sees identical inputs
   for the two replies and cannot separate them. This closes the "next attempt needs an
   order-sensitive realization rule" hope Codex left open (C61 note) — the deficit is intrinsic to
   the feature reduction, not to its q-uniformity.

3. **The feature map is not orbit-injective.** The two twins have different Grundy values, so they
   lie in different Stab(frame)-orbits; the Ψ/selector feature vector is a Stab-invariant but not a
   *complete* one — it collapses a P-orbit onto an N-orbit. A winning selector requires a strictly
   finer PGL-invariant coordinate.

4. **The deficit grows with q (6% → 7% → 39%).** Feature-twins proliferate with order, so this is
   structural and worsening, not a small-field artifact — the opposite of the "it dissolves at
   larger q" pattern that killed the C64/C69 near-hits. More of the same features will not help.

**Necessary next step (named, with a design target).** Any value-blind winning selector must
introduce a genuinely new PGL-invariant coordinate that distinguishes these feature-twins. The 19
witness pairs (`rust/s4-dumps/2026-07-11/c75/q{13,17,19}-detail2.tsv`, filter by the collision
signatures the script prints) are the minimal, concrete separation target: find the geometric
difference between `6,6` and `12,3` after opponent `11,0` at the q=13 root that the current
invariants miss. This also re-weights the program toward the amortized/ledger form of the potential
(a bank that tolerates ΔΨ≥0), since a *pointwise* winning selector over the present invariants is
now ruled out.

## Scope / caveats (skeptic pass)

- **Impossibility is over the emitted feature space**, which is exactly the C61/C62/C63 program
  space (every family is a function of these). It is "enrich the invariants or fail," not "no
  value-blind selector exists in the absolute." Stated precisely, that is the useful form.
- **Obligation slice.** `root_replies` is dumped only at root-frame hard obligations
  (`occ.len()==root_occ.len()` in the fail-out path) — not all obligations. One verified twin
  already gives impossibility; the 19-across-three-orders count and the growth trend are robust, but
  the global twin density over all plies is unmeasured (a cheap follow-up: dump replies at all
  fail-out obligations).
- **Orthogonal to the A5 anchor.** A5 selects *which root escape child* to certify (works,
  value-blind). C75 is about *deep reply selection inside* the certificate; the two are different
  layers and do not conflict.

## Provenance / reproduction

The stock `root_replies` dump omitted `chi`/`polar` (they were emitted only in the `best_p`
columns). Before patching, a naive twin check reported 82 false collisions; with `chi`/`polar`
added the count drops to the true 19 — the correctness fix was load-bearing, so the result is stated
only against the complete emitted space.

```bash
# solver patched at notes/2026-07-06-grid-cap-solver.rs root_replies emitter (+chi,+polar)
rustc -O -C target-cpu=native notes/2026-07-06-grid-cap-solver.rs -o rust/target/gridcap-c75
cd rust
for q in 13 17 19; do
  ./target/gridcap-c75 s4selectors $q 1,2,3,4 \
    --grundy s4-dumps/2026-07-09/c35/q${q}-root-1234.grundy.raw \
    --fail-out s4-dumps/2026-07-11/c75/q${q}-detail2.tsv
done
uv run --with scipy --with numpy python3 scripts/c75_linear_selector_lp.py \
  q13=s4-dumps/2026-07-11/c75/q13-detail2.tsv \
  q17=s4-dumps/2026-07-11/c75/q17-detail2.tsv \
  q19=s4-dumps/2026-07-11/c75/q19-detail2.tsv
```
