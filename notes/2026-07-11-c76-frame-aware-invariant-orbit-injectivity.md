# C76 — the C75 twins split under frame-relative characters (orbit-injectivity recovered), but no monotone selector

**2026-07-11 (Claude, lane C / Cluster-2, follow-on to C75).** Answers C75's named design
target — "any winning value-blind selector needs a strictly finer PGL-invariant coordinate; the
witness pairs are the concrete separation target." No re-solve: reuses the C75 detail TSVs
`s4-dumps/2026-07-11/c75/q{13,17,19}-detail2.tsv`. Scripts:
`rust/scripts/c76_invariant_hunt.py`, `rust/scripts/c76_directional_search.py`.

## The gap C75 left

C75 proved the C61/C62/C63 feature space `{geom, live, comp, xor_zero, Ψ, ΔΨ, χ, polar, rays}`
collapses winning onto losing replies: **48 losing (N) replies are byte-identical to a winning
(P) reply** at 19 root-frame obligations across q=13/17/19. C75 point (3): "the feature map is
not orbit-injective … a winning selector requires a strictly finer PGL-invariant coordinate."

**The structural reason the space collapses:** every C75/C61/C62/C63 feature is a function of the
**pair `(x, z)`** — opponent cell and reply cell — or of the reply alone. **None references the
frame conic points** `Φ = {1,2,3,4}` (the burned 5-arc `{(t, t⁻¹)}` on the conic `xy=1`). The
selector is blind to how the reply sits relative to the frame.

## Result 1 — frame-relative characters split all 48 twins (orbit-injectivity recovered)

Add value-blind, Stab(F∪{x})-invariant (sorted ⇒ symmetric in Φ, character-valued ⇒ PGL-invariant)
frame-relative coordinates of a reply `z=(r,c)` on the conic `xy=1`:

| coordinate (sorted profile over the frame) | twins split |
|:--|--:|
| **polar-at-frame** — `χ(c·f + r·f⁻¹ − 2)` for `f ∈ Φ` (z's polar line `cX+rY=2` vs each frame point) | 39 / 48 |
| **frame-chord-at-z** — `χ(r + f·f′·c − (f+f′))` over frame pairs (z vs each frame secant `X+ff′Y=f+f′`) | 38 / 48 |
| polar-at-frame **+** frame-chord-at-z jointly | **47 / 48** |
| **+ frame×z-tangent cross-ratio** — `χ(CR(f,f′; u,v))`, `{u,v}` = z's tangent params, over frame pairs | **48 / 48** |

The one survivor of polar+chord (q=17, opp `5,8`: P `15,10` vs N `10,7`) is split by the tangent
cross-ratio profile. **All 48 P/N feature-twins separate** once frame-relative characters are added
— the augmented feature space is **orbit-injective on the witness set**. This *is* the "strictly
finer PGL-invariant coordinate" C75 asked for: it is exactly the class the program's selector
features omitted (frame-awareness), and it is decisive.

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

This is the same wall as C55/C64/C69 (no static config→value law) and C75 (feature-completeness),
now located precisely: **the missing coordinate is separation (orbit-injectivity, recovered here);
the residual obstruction is monotonicity (a value *direction*), which is dynamical, not static.**
A pointwise value-blind selector over any static invariant enrichment cannot exist, because the
winning side of a fully-separated twin is not a monotone function of the geometry.

## Consequence for the (ON) route

This confirms and sharpens C75's re-weighting toward the **amortized/ledger potential**:

- **The invariant prong is answered, both ways.** The finer coordinate C75 named exists and is
  concrete (frame-relative characters, 48/48). But it buys *separation*, not *selection* — so it
  does not by itself close (ON). Enriching the invariants further will not produce a pointwise
  selector; the direction is not static.
- **The ledger is the remaining lever.** Because the value is a *non-monotone* function of the
  (now orbit-injective) geometry, the second player must be allowed to accept `ΔΨ ≥ 0` at a
  separated twin and repay it later — i.e. a **bank/amortized potential** `Ψ` tolerating local
  increases against a global budget, selecting on the frame-aware orbit rather than a scalar. The
  48 separated twins are the exact positions where a pointwise rule fails and the bank must carry
  the charge.

## Caveats (skeptic pass)

- **Orbit-injectivity is verified on the 48 known twins**, not globally. C75's own cheap follow-up
  (dump every reply at *all* fail-out obligations, not just root-frame ones) would test whether the
  augmented space is globally orbit-injective. Even if it is, Result 2 says it yields no selector.
- **"No monotone scalar" is over the tested reductions** (~14). The structural argument (a
  monotone static selector would contradict C55/C64/C69) is the stronger reason; the scalar sweep
  is the direct evidence.
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
```
The `[profile closure]` block at the end of `c76_directional_search.py` prints the 39/48, 38/48,
47/48, 48/48 separation counts for the sorted frame-relative character profiles.
