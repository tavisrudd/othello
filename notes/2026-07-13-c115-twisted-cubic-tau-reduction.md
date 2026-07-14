# C115 — external-point τ-spectrum of the twisted cubic: projection reduction + axis cap-set law

**Date**: 2026-07-13
**Task**: C115 (opt-b) — the projection→plane-cubic reduction of the external-point transversal
spectrum `ρ(x)=τ` (completion §6.5), targeting per-orbit closed forms.
**Handoff**: [twisted-cubic transversal-spectrum](handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md)
**Repro**: [`2026-07-13-c115-tau-reduction.py`](2026-07-13-c115-tau-reduction.py) (full q=9 + rep-based
q=27), [`2026-07-13-c115-axis-capset-check.py`](2026-07-13-c115-axis-capset-check.py) (independent
q=9/27/81 axis confirmation). `uv run --with galois --with numpy --with pulp`.

## Result

For an external point `x ∈ PG(3,q) \ C` of the twisted cubic `C = {(1:t:t²:t³)} ∪ {(0:0:0:1)}`
(char 3), with `ρ(x)=τ` = min transversal of the 3-secant-plane hypergraph through `x`:

1. **Reduction (rigorous).** `τ(x) = (q+1) − M(x)`, where `M(x)` is the maximum subset of `C`
   with no three points coplanar with `x`. Projecting from `x` (the quotient `PG(3,q)/⟨x⟩ ≅ PG(2,q)`)
   sends `C` to a plane cubic `π_x(C)`, and `{P,Q,R}` is coplanar with `x` **iff**
   `det[P,Q,R,x]=0` **iff** `π_x(P),π_x(Q),π_x(R)` are collinear. So `M(x)` is a **max no-3-collinear
   ("cap") subset of the plane cubic** `π_x(C)`, and `τ = min transversal` is its complement. This
   is a tautology of the quotient, hence holds over any field.

2. **Axis closed form (rigorous, confirmed q=9,27,81).**
   ```
        τ_axis(q) = q − r₃(h)          (q = 3ʰ)
   ```
   where `r₃(h)` is the maximum cap (3-term-AP-free set) in `AG(h,3)`. Projection from any axis
   point sends `C` to the **cuspidal** cubic `v²=u³`; its smooth locus is `(𝔽_q,+)` under the
   additive coordinate `φ(t)=1/t` (with `φ(∞)=0`), the cusp is `t=0`. Three smooth points are
   collinear **iff** `1/t₁+1/t₂+1/t₃ = 0`, which in char 3 is the 3-AP / cap condition; the cusp
   lies on no 3-point line so it is always addable. Hence `M_axis = r₃(h)+1` and
   `τ_axis = (q+1)−(r₃(h)+1) = q − r₃(h)`.

   **This reduces §6.5's axis orbit exactly to the cap-set problem** — the same object as the nofil
   sum-free lane and the already-formalized `zeroSumCapNumber`.

## Verification data

The four external orbits (verified: full PG(3,9) enumeration → exactly these 4 classes; q=27
rep-based). Incidence = #3-secant planes through `x`; type = the projected plane cubic; `#img` =
distinct images of `C` under `π_x`.

| orbit | incidence      | projected cubic         | #img | τ(q=9) | τ(q=27) | M(q=9) | M(q=27) |
|-------|----------------|-------------------------|------|--------|---------|--------|---------|
| TO    | `q(q−3)/6`     | smooth (elliptic, #=q+1)| q+1  | 3      | 15      | 7      | 13      |
| RC    | `q(q−1)/6`     | smooth (elliptic, #=q+1)| q+1  | 4      | 14      | 6      | 14      |
| IC    | `q(q+1)/6`     | nodal (rational node)   | q    | 4      | 14      | 6      | 14      |
| axis  | `q(q−1)/6`     | cuspidal `v²=u³`        | q+1  | 5      | 18      | 5      | 10      |

Axis check (independent of the φ-model, direct 3×3 det): at q=9,27,81 the coplanar-triple set
equals **exactly** the `1/t`-sum-zero triples, count `= q(q−1)/6` (12, 117, 1080), cusp `t=0` in no
edge. Confirms `M_axis = r₃(h)+1`: q=9 → 4+1=5, q=27 → 9+1=10, q=81 → 20+1=21.
Predictions: **τ_axis(81)=61, τ_axis(243)=243−45=198**.

## Per-orbit structure (the group-law form of the reduction)

Three points of the plane cubic are collinear iff they sum to a fixed class `c₀` in the smooth-point
group; the singular point (node/cusp), when present, is on no 3-point line, so it is always addable.

- **axis → `(𝔽_q,+)`, `c₀=0`.** `M = r₃(h)+1`. **Closed** (above).
- **IC → nodal**, split rational node, smooth locus `≅ 𝔽_q^×` (cyclic order `q−1`), plus the node
  (+1 addable). `M = (max no-3-sum-c₀ subset of 𝔽_q^×) + 1`.
- **TO, RC → smooth elliptic**, `#E(𝔽_q)=q+1`, no singular point. `M = max no-3-sum-c₀ subset of
  E(𝔽_q)`. TO and RC share the group order `q+1` but differ in the collinear-sum constant `c₀`
  (equivalently, presence/absence of a rational flex): the collinear-triple counts differ (q=9:
  9 vs 12; for `Z_{10}` the `c₀=O` count is 12, matching RC). This is why their τ split despite
  equal incidence-adjacent data.

The IC/TO/RC extremal numbers ("caps in `𝔽_q^×` / `E(𝔽_q)`") are **not** closed-form from two
orders — this is the genuinely open piece, deferred to **C116** (ILP at q=81, 243; guard the axis
prediction τ=61, 198 there too).

## Lean cert (done — strict-trust)

`RepairCodes/ProjectiveTwistedCubicTransversalSpectrum.lean` kernel-proves the axis-orbit result at
the nucleus:

```
projectiveTwistedCubicSecantTransversal_infinity :
  transversalNumber (projectiveTwistedCubicSecantHypergraph (Sum.inr Unit.unit))
    = Fintype.card 𝔽 - zeroSumCapNumber 𝔽
```

Both this and the structural bridge `projectiveTwistedCubicSecantHypergraph_infinity_eq_embed`
build with the standard axiom profile `[propext, Classical.choice, Quot.sound]`. The proof
recognizes that the §6.5 secant hypergraph at the nucleus is the cubic-only part of the axis repair
clutter (`axisCubicRepairComponent`), lifts it to the projective cubic via the existing
`minimalProjectiveAxisInfinityRepair_eq_embedAffine` (cubic-∞ isolated), and closes with the
existing `transversalNumber_zeroSumTripleHypergraph = q − zeroSumCapNumber`. Orbit constancy extends
it to every axis point via `projectiveShiftInvIndexEquiv` (available, not yet packaged).

## Lean path detail (reuses existing infra)

`FiniteGeom/ZeroSumTriple.lean` already provides:
- `zeroSumTripleHypergraph A` — 3-element zero-sum subsets of a finite additive group (the char-3
  affine lines);
- `zeroSumCapNumber A` — its independence number (max cap);
- `transversalNumber (zeroSumTripleHypergraph A) = Fintype.card A − zeroSumCapNumber A`;
- `independenceNumber (zeroSumTripleHypergraphAvoidingZero F) = zeroSumCapNumber F + 1` and
  `transversalNumber (…AvoidingZero) = card F − 1 − zeroSumCapNumber F` (the isolated-vertex "+1").

The axis τ-cert is therefore: prove the axis external-point coplanarity hypergraph on `C`, minus its
isolated cusp, is `relabelHypergraph` of `zeroSumTripleHypergraph 𝔽_q` via `φ(t)=1/t`, then apply
the transversal-number theorem to conclude `τ_axis = q − zeroSumCapNumber 𝔽_q`. The one new
obligation is the elementary bridge lemma: **`{P(t₁),P(t₂),P(t₃)}` coplanar with an axis point ⟺
`1/t₁+1/t₂+1/t₃ = 0`** (a 4×4 determinant identity). The projective cubic + axis are already defined
in `FiniteGeom/ProjectiveAxisTwistedCubic{,Circuits}.lean`.

## Status

- Reduction + axis closed form: **done and confirmed**; ties §6.5 axis orbit to the cap-set problem.
- Axis Lean cert: **done, strict-trust** (`projectiveTwistedCubicSecantTransversal_infinity`,
  standard axioms). §6.5 paper promotion pending user review.
- TO/RC/IC exact forms: reduced to caps in `𝔽_q^× / E(𝔽_q)`; **open → C116**.
