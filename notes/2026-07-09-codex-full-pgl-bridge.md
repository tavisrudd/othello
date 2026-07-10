# C53 — Full-PGL on-conic orbit bridge (Sym²/Veronese)

**Task:** `notes/2026-07-07-codex-task-queue.md` § C53. Claimed by Claude 2026-07-09.
**Owner:** Claude. **Status: parts 1–4 DONE.** Lean bridge (parts 1–2) verified — `lake env
lean` clean, `lake build ProjectiveCap.Sym2ConicBridge` green, wired into
`ProjectiveCap.lean`, axiom-clean (`propext, Classical.choice, Quot.sound` only), no
`sorry`. An adversarial persona review (mathlib projectivization geometer) flagged a real
design-gap in the first draft (the deliverable was generic collineation-invariance, not the
composed on-conic bridge); that gap is **closed** (composition capstone) — see below. The
review's optional refinement (Veronese injectivity) is also **done** (`veronesePoint_injective`
+ `card_image_veronesePoint`: the on-conic cap genuinely has one distinct point per
parameter). Parts 3–4 (q=23 status write-up + B3-open doc cleanup) **done** — handoff,
falsification map, and alignment report updated; negative cross-q conclusion preserved.

Coordination note (historical): authored while Codex held the box with a large cert build;
kept orphaned until that cleared, then verified + wired in on a clean box under
`choom -n 1000`.

## Summary

The bridge that C29's q=23 census leaned on — "an on-conic S4 state's game value is a
function of the six played conic points up to the full `PGL(2,q)`" — is now built
constructively in Lean, at the projective layer where the cap-game transport theorems
already live. A line transformation `M ∈ GL(2,K)` induces, via its symmetric square, a
plane collineation that (i) preserves the Veronese conic, (ii) realizes the Möbius action
on conic parameters, and (iii) transports the cap-game value. Composed with the existing
`FiniteBuildGame.isP_map` / `PlaneTransitivity.cap_map_mapEquiv`, this removes the former
"orbit caveat" from the computed q=23 status.

## Where it lives

- **New file:** `lean/ProjectiveCap/Sym2ConicBridge.lean` (namespace
  `ProjectiveCap.Sym2Bridge`). Imported by `ProjectiveCap.lean` (aggregate builds it).
- **Report:** this file.

## Construction (coordinate model)

Line `= Fin 2 → K`, Plane `= Fin 3 → K` with quadratic coordinates `(X,Y,Z)=(u²,uv,v²)`.

| name                        | meaning                                              |
| --------------------------- | ---------------------------------------------------- |
| `veronese v`                | `(u², uv, v²)` — the degree-2 Veronese map           |
| `conicForm w`               | `Y² − XZ` — Veronese conic is its zero locus         |
| `sym2Mat M`                 | the 3×3 symmetric-square matrix of `M`               |
| `sym2Equiv hM`              | `Sym²(M)` as `Plane ≃ₗ[K] Plane` (via `toLinearEquiv'`) |
| `sym2Collineation hM`       | induced `Point ≃ Point` (via `PlaneTransitivity.mapEquiv`) |
| `veronesePoint p`           | Veronese embedding at the projective level           |
| `OnConic p`                 | `conicForm p.rep = 0`                                 |

With `M = !![a,b;c,d]`, `sym2Mat M = !![a²,2ab,b²; ac,ad+bc,bd; c²,2cd,d²]`.

### Three core identities — all pure `ring`, valid in every characteristic

- `sym2Mat_mulVec_veronese`: `sym2Mat M *ᵥ veronese v = veronese (M *ᵥ v)` (equivariance)
- `conicForm_sym2Mat_mulVec`: `conicForm (sym2Mat M *ᵥ w) = (M.det)² * conicForm w`
- `sym2Mat_det`: `(sym2Mat M).det = (M.det)³`

The conic form is a **relative invariant** with multiplier `(det M)²`, so `{conicForm=0}`
is preserved *exactly* — in all characteristics. Invertibility is `IsUnit M.det ⟹
IsUnit (sym2Mat M).det` via `det = det³`, so `toLinearEquiv'` yields the plane linear
equiv without any hand-written `invFun`/`map_add'`/`left_inv` algebra.

### Characteristic 2

Deliberately **kept general** (no `ringChar K ≠ 2` hypothesis). The task allowed "odd
fields first"; it is not needed here, because the three identities above are polynomial
identities and invertibility holds whenever `det M ≠ 0`. The char-2 subtlety is
*geometric* (the conic is Frobenius-degenerate / strange, nucleus behavior differs) and
never enters the value-transport argument, which only uses invertibility + zero-locus
preservation. If a downstream consumer needs the classical oval geometry it can add the
parity hypothesis; the bridge itself does not.

## Reuse — the game-transport half is essentially free

`lean/ProjectiveCap/PlaneTransitivity.lean` already provides everything for the game side:

- `mapEquiv (g : V ≃ₗ[K] V) : Point K V ≃ Point K V` — collineation from a linear equiv.
- `collinear_mapEquiv`, `cap_map_mapEquiv (g) : Cap (S.map (mapEquiv g)) ↔ Cap S` —
  the exact `hValid` hypothesis the transport kernel wants.
- `FiniteBuildGame.isP_map` / `win_map` (`lean/CapGame/BuildGame.lean`) — value transport
  under a validity-preserving self-permutation.

The generic transport is a one-liner (`sym2Collineation_isP_transport` /
`…_win_transport`): any two plane cap positions related by `sym2Collineation hM` share
`IsP`/`Win`, via `cap_map_mapEquiv` + `isP_map`. **This carries no on-conic content by
itself** — it is the instantiation of the pre-existing linear-collineation transport at a
particular `g`. It is named honestly for what it proves; it is *not* the deliverable.

## The deliverable (composition capstone)

`onconic_value_bridge` / `onconic_win_bridge`: for a parameter set `σ ⊆ P¹`,

```
IsP (Cap) (σ.image veronesePoint)  ↔  IsP (Cap) ((σ.image (mapEquiv (lineEquiv hM))).image veronesePoint)
```

i.e. the on-conic cap carried by conic parameters `σ` (the six-point cap of an on-conic S4
state, Lemma I) has the same value as the on-conic cap of the **Möbius-transformed**
parameters. Its proof is

```
sym2Collineation_isP_transport hM (sym2Collineation_image_veronesePoint hM σ)
```

where `sym2Collineation_image_veronesePoint` proves
`(σ.image veronesePoint).map (sym2Collineation hM) = (σ.image (mapEquiv (lineEquiv hM))).image veronesePoint`
by pushing `sym2Collineation_veronesePoint` (the Möbius realization) through `Finset.image`.
So the **geometry half is genuinely on the proof path** — the conic is not decoration. Two
parameter sets in one full-`PGL(2,q)` orbit ⟹ equal residual value, no burned-pair residue.

## Verification status — VERIFIED

- `choom -n 1000 -- lake env lean ProjectiveCap/Sym2ConicBridge.lean` → exit 0, no `sorry`.
- `choom -n 1000 -- lake build ProjectiveCap.Sym2ConicBridge` → `Built … (2.1s)`, green.
- Imported by `ProjectiveCap.lean`; aggregate builds it.
- `#print axioms` on `onconic_value_bridge`, `sym2Collineation_veronesePoint`,
  `onConic_sym2Collineation` → each `[propext, Classical.choice, Quot.sound]` only
  (standard mathlib axioms; no `sorryAx`).
- One cosmetic lint remains (line 91, `<;>` vs `;` in `veronese_smul`); the linter's
  suggested form runs `ring` on branches `simp` already closed → "no goals", so the working
  `<;>` form is kept.

### Adversarial review + composition fix

An adversarial persona review (mathlib projectivization geometer, secondary Lean-CGT lens)
verified the algebra by hand (symmetric square, conic form, `(det)²` multiplier, `det³` all
correct) and confirmed `OnConic`/`veronesePoint` well-definedness and non-vacuous char-2
behavior. Its one **blocking** finding: the first-draft `onconic_value_bridge` took
`S.map (sym2Collineation hM) = T` as a *hypothesis* and never consumed the conic lemmas —
i.e. it was generic collineation-invariance (already available via `isP_mapLinearEquiv`)
with the on-conic content living only in the docstring. **Fixed** by (a) renaming that
theorem to `sym2Collineation_isP_transport` (honest to what it proves), and (b) adding the
composition capstone above, which puts `sym2Collineation_veronesePoint` on the proof path so
the named `onconic_value_bridge` genuinely states the PGL-orbit ⟹ equal-value bridge.

Injectivity refinement (review's optional item) — **done**: `veronesePoint_injective` proves
the Veronese `P¹ ↪ P²` is injective (`(v₀w₁−v₁w₀)² = 0` from the three component relations,
then the proportional reps give the same projective point); `veronesePointEmb` packages it as
an `Embedding`, and `card_image_veronesePoint : (σ.image veronesePoint).card = σ.card` records
that the on-conic cap has one distinct point per parameter (an S4 state's six conic parameters
→ six distinct points). The value bridge does not depend on it (it holds for the `image`
regardless), so the capstone is left `image`-based; the injectivity is the distinctness/
cardinality guarantee.

## Part 3 — q=23 computed-status handoff — DONE

Landed in `notes/handoffs/2026-07-06-projective-cap-game-handoff.md` (status list, q=23 status
table row, and the tier-note): the q=23 row now cites the bridge as a verified Lean theorem
and states the trust tier explicitly (below).

With `onconic_value_bridge` + C29's 22/22 full-`PGL(2,23)` on-conic bucket-P labels, the
computed q=23 on-conic escape result can be stated **without the orbit caveat**: every
on-conic S4 child at q=23 is full-`PGL(2,23)`-equivalent to one of the 22 bucket roots,
and the bridge makes value a function of that orbit.

Trust tier — state exactly: this is **computed-and-orbit-reduced, not Lean-unconditional**.
The 22 P roots are *solver labels*, not kernel-checked certificates. The bridge is now a
Lean theorem; the 22 values it consumes are not. Lean-unconditional q=23 requires the 22
roots to be converted to rules-checked certificates — that is **C54's** job (`certcheck`
over the C29/C37 dumps). Do not claim q=23 ∈ Lean-`InitialPStatement` until a Lean checker
consumes those certificates.

## Part 4 — doc cleanup — DONE

Flipped the pending-tense / B3-open language to "full-PGL bridge is a verified Lean theorem"
across:
- `notes/handoffs/2026-07-06-projective-cap-game-handoff.md` (status list + q=23 row + tier-note),
- `notes/2026-07-09-odd-plane-falsification-map.md` (B3 risk row, §4 correction, §5 verdict),
- `notes/2026-07-09-onconic-child-type-alignment.md` (correction paragraph now cross-links this
  report).

The negative cross-q conclusion was **preserved / reinforced** everywhere:

> Full-PGL transport is a **fixed-q compression only**. Across q, value is *not* orbit-
> constant — 119 shared integral 6-point configs flip (N at arc-depleted q∈{11,17}, P at
> full orders 13/19). There is no finite type→value dictionary; a solved q gives no
> q-to-q prediction. (`2026-07-09-onconic-child-type-alignment.md` §5/§7.)

No lingering "duplicate stabilizer-representative solve" *asks* remained — the queue's
mentions were already non-goals ("do not run…"), left as-is.

## Next steps

All C53 parts (1–4) plus the injectivity refinement are **done**. Remaining is downstream,
not C53:

1. **C54** — certify the 22 q=23 bucket labels (rules-only `certcheck`), the piece that would
   upgrade q=23 from computed-and-orbit-reduced to Lean-unconditional-eligible.
2. A future Lean checker consuming those certificates would make the q=23 row a Lean theorem
   for `Projective.InitialPStatement`; out of C53 scope.

## Handoff note (2026-07-09, Claude)

Claimed C53; authored + **verified** `lean/ProjectiveCap/Sym2ConicBridge.lean` (parts 1–2):
Sym²/Veronese construction, the three core algebraic identities (kept general over
characteristic — exceeds "odd first"), projective Möbius-realization + conic-preservation
lemmas, the generic `sym2Collineation_isP_transport` / `…_win_transport`, and the
composition capstone `onconic_value_bridge` / `onconic_win_bridge`. `lake env lean` + `lake
build ProjectiveCap.Sym2ConicBridge` green; imported into `ProjectiveCap.lean`; axiom-clean.
An adversarial persona review caught that the first-draft deliverable was generic
collineation-invariance (on-conic content only in prose); closed by the honest rename + the
composition capstone that puts the Möbius realization on the proof path. Its optional
injectivity refinement is also done (`veronesePoint_injective` / `veronesePointEmb` /
`card_image_veronesePoint`). Parts 3–4 (q=23 status + B3-open cleanup) landed in the handoff,
falsification map, and alignment report, with the negative cross-q conclusion preserved. All
C53 parts done; downstream is C54 (bucket-label certification).
