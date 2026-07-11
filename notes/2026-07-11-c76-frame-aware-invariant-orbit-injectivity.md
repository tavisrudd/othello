# C76 — frame-relative characters split almost all C75 twins, but leave a residual hard twin and no uniform selector → ledger

**2026-07-11 (Claude, lane C / Cluster-2, follow-on to C75).** Answers C75's named design
target — "any winning value-blind selector needs a strictly finer PGL-invariant coordinate; the
witness pairs are the concrete separation target." No re-solve: reuses the C75 detail TSVs
`s4-dumps/2026-07-11/c75/q{13,17,19}-detail2.tsv`. Scripts:
`rust/scripts/c76_invariant_hunt.py`, `rust/scripts/c76_directional_search.py`,
`rust/scripts/c77_augmented_selector.py`.

**Bottom line up front.** Frame-relative characters — the coordinate class C75's feature space
entirely omits — resolve almost all of the C75 collisions (47/48 enumerated twins under two
profiles). But they do **not** restore orbit-injectivity: a full within-obligation rescan leaves
**one residual hard twin** (q=17, axis points where the tangent coordinate degenerates), and an LP
shows **no uniform linear selector** exists even in the augmented space. So the invariant route
makes major progress but does not by itself yield a pointwise selector — the amortized/ledger bank
is the surviving lever, as C75 anticipated.

## The gap C75 left

C75 proved the C61/C62/C63 feature space `{geom, live, comp, xor_zero, Ψ, ΔΨ, χ, polar, rays}`
collapses winning onto losing replies: **48 losing (N) replies are byte-identical to a winning
(P) reply** at 19 root-frame obligations across q=13/17/19. C75 point (3): "the feature map is
not orbit-injective … a winning selector requires a strictly finer PGL-invariant coordinate."

**The structural reason the space collapses:** every C75/C61/C62/C63 feature is a function of the
**pair `(x, z)`** — opponent cell and reply cell — or of the reply alone. **None references the
frame conic points** `Φ = {1,2,3,4}` (the burned 5-arc `{(t, t⁻¹)}` on the conic `xy=1`). The
selector is blind to how the reply sits relative to the frame.

## Result 1 — frame-relative characters split almost all twins (but not orbit-injective)

Add value-blind, Stab(F∪{x})-invariant (sorted ⇒ symmetric in Φ, character-valued ⇒ PGL-invariant)
frame-relative coordinates of a reply `z=(r,c)` on the conic `xy=1`:

| coordinate (sorted profile over the frame) | enumerated twins split |
|:--|--:|
| **polar-at-frame** — `χ(c·f + r·f⁻¹ − 2)` for `f ∈ Φ` (z's polar line `cX+rY=2` vs each frame point) | 39 / 48 |
| **frame-chord-at-z** — `χ(r + f·f′·c − (f+f′))` over frame pairs (z vs each frame secant `X+ff′Y=f+f′`) | 38 / 48 |
| polar-at-frame **+** frame-chord-at-z jointly | **47 / 48** |

Over the 48 *enumerated* C75 twin pairs, polar+chord split 47/48 and the tangent cross-ratio
profile `χ(CR(f,f′; u,v))` (`{u,v}` = z's tangent params) splits the last one (q=17, opp `5,8`:
P `15,10` vs N `10,7`). This is exactly the coordinate class the program's selector features
omitted — frame-awareness — and it is where the missing separation lives.

**But it is not orbit-injective (correction to the first-pass claim).** The C75 enumeration keys
winners by feature tuple, collapsing several same-base winners onto one representative, so it
*undercounts* the collisions. A full within-obligation rescan of every (winner, loser) pair in the
augmented space (base + all four profiles, `c77_augmented_selector.py [A_local]`) leaves **1
residual hard twin**: q=17, opp `5,8`, **P `11,0` (g0) vs N `16,0` (g5), byte-identical on every
augmented coordinate**. Both lie on the `c=0` axis, where the conic tangent line is the axis itself
(one finite tangent param, not two), so the tangent cross-ratio profile degenerates to `na` and the
polar/chord/involution profiles coincide. Two natural extensions (single-tangent cross-ratio with
the infinite tangent point; involution-partner character profile) also fail to split this pair. So
the profile set resolves the collisions down from 48 to 1, but the augmented space **is still not
orbit-injective** on axis (degenerate-tangent) replies. Since the two replies have different Grundy
values they are genuinely different orbits, so a separating invariant exists — the profile set is
merely incomplete on the axis stratum — but Result 3 makes this residual immaterial to the selector
question.

The polar/tangent geometry matches the solver verbatim: `geometry_label_for_root` classifies a
point by the tangent test `f·c + f⁻¹·r − 2 = 0` (`two = 1+1`), identical to the polar-at-frame
atom above; the conic is `xy=1`, frame = `{(t, t⁻¹) : t ∈ Φ}`.

## Result 2 — but the separation is non-monotone: no pointwise selector

Distinguishing the orbits is **necessary but not sufficient** for a value-blind selector: an
argmin/argmax selector needs the P reply strictly on **one** side of its N twin at **every**
obligation. Over ~14 scalar reductions of the frame-aware invariants (`c76_directional_search.py`),
the two that separate the most twins are **direction-MIXED**:

| scalar | twins split | P below N | P above N |
|:--|--:|--:|--:|
| `sum_χ(polar-at-frame)` | 39 | 15 | 24 |
| `sum_χ(frame-chord-at-z)` | 38 | 20 | 18 |
| `sum_χ(f − involution-partner)` | 32 | 14 | 18 |

The **only** clean-directional scalar, `sum_χ(tangent-quadratic at frame)`, is defined only for
external replies with two finite tangents, so it splits just 12/48 and is undefined on 33. Every
high-separation coordinate flips sign: **which side is P depends on the rest of the position.**

This is the same wall as C55/C64/C69 (no static config→value law) and C75 (feature-completeness):
even where the frame-aware coordinates *separate* the twins, no scalar reduction of them selects,
because the winning side is not a monotone function of the geometry.

## Result 3 — no uniform selector even in the augmented space (the decisive test)

Result 1 lifts C75's *specific* pointwise-impossibility for 47/48 twins, so the real question
reopens: does the frame-augmented space admit a **uniform value-blind selector** that picks a P &
Ψ-descending reply at every obligation? Tested over all 108 hard root-frame obligations
(the entire hard set — all have full reply dumps), `c77_augmented_selector.py`:

- **`[A_local]` residual hard twin: 1.** As above (q=17, P `11,0` vs N `16,0`, identical augmented
  vector). One within-obligation collision ⇒ **no selector, linear or nonlinear, over this feature
  set** picks the winner there — the C75 impossibility *survives* the augmentation (just once).
- **`[A_same_q]` context clashes: 5 at q=17** (0 at q=13/q=19). An augmented vector that is a
  *winning* reply at one obligation is a *losing* reply at another (same q). A context-free
  classifier of replies fails; a contextual selector is not killed by this alone, but —
- **`[B_linear]` LP INFEASIBLE.** Over 4260 margin constraints in the d=37 augmented feature space
  (base + all four frame profiles), there is **no single linear functional** whose per-obligation
  argmin is a winning reply everywhere across q=13/17/19, with the deepest-descent target rule.

So the frame-augmentation cuts collisions 48→1 and separates the winner/loser *classes* almost
everywhere, yet it yields **no uniform pointwise selector** — one residual hard twin plus no linear
selector. The invariant route has gone as far as it structurally can.

## Consequence for the (ON) route

This confirms and sharpens C75's re-weighting toward the **amortized/ledger potential**:

- **The invariant prong is answered.** The finer coordinate class C75 named exists and is concrete
  (frame-relative characters, 48→1 collisions). It buys *separation*, not *selection*: no scalar is
  monotone (Result 2) and no uniform linear selector exists (Result 3), and a residual hard twin
  survives (Result 1). Enriching static invariants further will not produce a pointwise selector.
- **The ledger is the remaining lever.** Because the value is a *non-monotone* function of the
  (near-orbit-injective) geometry, the second player must be allowed to accept `ΔΨ ≥ 0` at a hard
  twin and repay it later — a **bank/amortized potential** `Ψ` tolerating local increases against a
  global budget, selecting on the frame-aware orbit rather than a scalar. The residual/near-twin
  positions are exactly where a pointwise rule fails and the bank must carry the charge. This is
  the open C77 construction.

## Caveats (skeptic pass)

- **The augmented space is *not* orbit-injective** — 1 residual hard twin on the axis stratum
  (Result 1). The first-pass "48/48" claim was an artifact of the winner-keyed enumeration; the
  full rescan is the accurate count. The residual is immaterial only because Result 3 already denies
  a selector.
- **`[B_linear]` infeasibility is for the linear class with the deepest-descent target rule** — a
  different per-obligation target could feasibilize a linear selector, and nonlinear selectors are
  not swept. But the residual `[A_local]` twin is a *conclusive* impossibility (linear or not) for
  this feature set, and the structural argument (a monotone static selector would contradict
  C55/C64/C69) backs it.
- **Hard-obligation slice.** All 108 dumped obligations are at the root-frame layer (`root_replies`
  populated only when `occ.len()==root_occ.len()`); deeper-ply obligations are not dumped. A cheap
  follow-up (dump replies at *all* fail-out obligations) would extend the test, but Results 1+3
  already settle the selector question at the layer where the C75 collisions live.
- **Value-blind means geometry-only**; the Grundy label is never used to build the coordinates, so
  the separation is a legal q-blind statement.

## Reproduction

```bash
cd rust
python3 scripts/c76_invariant_hunt.py \
  s4-dumps/2026-07-11/c75/q13-detail2.tsv \
  s4-dumps/2026-07-11/c75/q17-detail2.tsv \
  s4-dumps/2026-07-11/c75/q19-detail2.tsv       # per-twin tangent-incidence table
python3 scripts/c76_directional_search.py <same three TSVs>   # directional scalar sweep +
                                                             # profile-closure (39/38/47/48)
uv run --with scipy --with numpy python3 scripts/c77_augmented_selector.py <same three TSVs>
                                                             # A_local(=1) / A_same_q / B_linear
```
`c76_directional_search.py`'s `[profile closure]` block prints the 47/48 (polar+chord) and 48/48
(over the enumerated pairs) counts; `c77_augmented_selector.py`'s `[A_local]` prints the corrected
full-rescan count of **1** residual within-obligation twin, and `[B_linear]` the LP infeasibility.
