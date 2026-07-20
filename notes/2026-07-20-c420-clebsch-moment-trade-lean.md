# C420 / F1 — Lean signed moment / trade foundation

**Lane:** `clebsch`

**Date:** 2026-07-20

**Verdict:** `DONE — kernel-checked symbolic foundation; standard-axioms-only; no Clebsch tables`

The mathematical content is elementary and classical: C409 itself grades the shared filtration a
`CLASSICAL/FORMAL NORMALIZATION, NOT A NEW FLAGSHIP`. F1 adds kernel backing and a reusable Lean
interface, nothing more; it makes no novelty, priority, or absence claim, and the genuinely
geometric inputs (which specific cubic survives, which sheets are balanced) stay downstream.

## Result in one line

The generic C409 signed-feature moment filtration actually consumed by the replacement-spine
campaign is now kernel-formalized over an explicit commutative-ring / module interface: the
binomial affine-covariance master identity and its first-survival corollary, antipodal
even-moment cancellation, degree-one weighted-barycentre cancellation, an elementary cubic witness
of exact strength two, and a small functional-shadow vector layer — all with no symmetric-tensor
library and no Clebsch coordinate tables.

## Owned Lean surface

| module | role |
|:---|:---|
| `lean/RelativeConicArcs/ClebschMomentTrade.lean` | content leaf (all terminals below) |
| `lean/RelativeConicArcs/Gates/ClebschMomentTrade.lean` | import-only F1 validation gate |

Namespace `RelativeConicArcs.ClebschMomentTrade`. Imports Mathlib finite sums / binomial / linear
maps only; no project module is imported, so this leaf is a genuine campaign root (matches the
dependency graph in the formalization plan, where F1 has no upstream project dependency).

## Formalized terminals

For `[CommRing R]`, `[Fintype ι]`, a signed weight `ε : ι → R`, and a scalar feature `φ : ι → R`,

```text
signedMoment ε φ j = ∑_i ε i · φ i ^ j          (the j-th signed power sum M_j).
```

- **`signedMoment_affine`** — binomial master identity:
  `M_n(ε, a·φ + b) = ∑_{k≤n} C(n,k) · a^k · b^(n-k) · M_k(ε, φ)`.
- **`signedMoment_affine_vanish`** — if `M_k = 0` for all `k ≤ n`, then `M_n(ε, a·φ + b) = 0`.
- **`signedMoment_affine_succ`** — affine covariance / first survival at general strength `s`: if
  `M_k = 0` for all `k ≤ s`, then `M_{s+1}(ε, a·φ + b) = a^(s+1) · M_{s+1}(ε, φ)`. The base point
  `b` drops out; a scalar rescale `a` acts by `a^(s+1)` on the first surviving moment. (The general
  `s` is the cheaper statement; downstream slices specialize to `s = 2`.)
- **`signedMoment_antipodal_even`** — a fixed-point-free involution `J` with `ε ∘ J = -ε` and
  `φ ∘ J = -φ` forces `M_n = 0` for every even `n`. All fixed-point-free and sign/feature-reversing
  hypotheses are explicit arguments (mirror-strategy discipline: the involution argument uses
  nothing beyond what is stated).
- **`signedMoment_one_translate`** — `M_1(ε, φ - b) = M_1(ε, φ) - b · M_0(ε, φ)`.
- **`signedMoment_barycentre_cancel`** — if `b · M_0 = M_1` (a weighted barycentre), then
  `M_1(ε, φ - b) = 0`.
- **cubic witness / sharpness** — `witnessWeight = ![-1, 2, -2, 1]`, `witnessValue = ![1, 2, 4, 5]`
  over `ℤ` (the elementary C408 depth ledger `-x + 2x² - 2x⁴ + x⁵ = x(x-1)³(x+1)`). Terminals
  `witness_moment_zero/one/two/three` give `M_0 = M_1 = M_2 = 0`, `M_3 = 12`; the aggregate
  `witness_exact_strength_two` records `M_0 = M_1 = M_2 = 0 ∧ M_3 ≠ 0`. Degree three is the first
  surviving power sum, so exact strength two is attained (sharp).

Vector layer (feature `φ : ι → V`, `[Module R V]`), modelling the j-th vector moment as a
multilinear evaluation against `j` linear functionals rather than a tensor power:

- **`vectorMomentForm`** — `∑_i ε i · ∏_{k<j} ℓ_k (φ i)`.
- **`vectorMomentForm_diagonal`** — one functional in all slots recovers the scalar shadow power
  sum: `vectorMomentForm ε φ (fun _ => ℓ) = signedMoment ε (ℓ ∘ φ) j`.
- **`vectorMomentForm_ne_zero_of_shadow`** — a nonzero scalar shadow witnesses a nonzero vector
  moment. (No single `ℓ` is guaranteed to detect it — an unlucky functional annihilates the
  shadow, which is exactly why C406 retains the vector datum.)
- **`signedMoment_shadow_affine`** — vector affine covariance through shadows: for linear `A` and
  translation `c`, each scalar shadow of `A·φ + c` is the scalar-affine transform of the shadow of
  `A·φ`. This is the coordinate-shadow form of the `A^{⊗n}` covariance, with no tensor library.

## Correspondence to C409

`notes/2026-07-20-c409-cubic-first-memory-principle.md` states the unified filtration
`M_j(ε, φ) = ∑ ε(ω) φ(ω)^{⊗ j}`, its affine covariance lemma, and the Pasch / C408 sharpness
family. F1 formalizes the shadow-level content each downstream slice actually consumes:

- C409 affine covariance lemma → `signedMoment_affine{,_vanish,_succ}` and, at the vector level,
  `signedMoment_shadow_affine`. C406 reference-independence of `M_3` is the `a = 1` case of
  `signedMoment_affine_succ`.
- `signedMoment_antipodal_even` and `signedMoment_barycentre_cancel` are the abstract *sufficient
  conditions* for even-moment and degree-one cancellation. C409 attributes C406's actual
  `M_1 = M_2 = 0` to its exact certificate (and `M_0 = 0` to equal sheet sizes); whether the C406
  sheets satisfy these lemmas' antipodal/barycentre hypotheses is a concrete C424/C425 fact, not
  established here. "Retaining the full tensor is load-bearing" → `vectorMomentForm_ne_zero_of_shadow`
  (a nonzero cube of one frozen functional witnesses `μ_3 ≠ 0`), the exact primitive C423/C424 freeze.
- C409 cubic sharpness (C408 ledger / Pasch trade) → the `witnessSign/witnessDepth` witness.

The C409 incidence-trade specialization (tensor coordinate = signed block-containment count) is a
separate F2/F9 concern and is not formalized here; the classical **unsigned** arc/line index
moments in `RelativeConicArcs.Moments` share the namespace but not this content, so nothing there
is reused.

## Verification

- Guarded single-file elaboration is clean (no errors, no linter warnings). Because the module
  imports only the pinned Mathlib, this elaboration is authoritative, not merely a smoke test:

  ```sh
  cd /home/tavis/src/othello
  lean/scripts/guarded-lean RelativeConicArcs/ClebschMomentTrade.lean
  ```

- Both targets build trace-current through the unattended queue (`single` profile), and the
  trace-only aggregate gate passes:

  ```sh
  lean/scripts/lean-build-queue.py run \
    RelativeConicArcs.ClebschMomentTrade RelativeConicArcs.Gates.ClebschMomentTrade \
    --profile single --threads 1 --cores 20-23
  ```

- Axiom audit — every terminal depends only on the standard Mathlib axioms; no `sorryAx`,
  no `Lean.ofReduceBool` (the witnesses use `decide`, not `native_decide`), no project-local axiom.
  Reproduce by adding `#print axioms <name>` for each terminal and re-running `guarded-lean`:

  ```text
  signedMoment_affine / _affine_vanish / _affine_succ    : [propext, Classical.choice, Quot.sound]
  signedMoment_one_translate / _barycentre_cancel        : [propext, Quot.sound]
  signedMoment_antipodal_even                            : [propext, Classical.choice, Quot.sound]
  witness_moment_three / witness_exact_strength_two      : [propext, Classical.choice, Quot.sound]
  vectorMomentForm_diagonal / _ne_zero_of_shadow         : [propext, Classical.choice, Quot.sound]
  signedMoment_shadow_affine                             : [propext, Classical.choice, Quot.sound]
  ```

## Trusted boundary — what F1 does not prove

- The nonvanishing of any specific Clebsch cubic (`μ_3 ≠ 0` for the actual A3/B3/H3 quotient
  data) is not proved here; F1 supplies only the abstract "nonzero scalar shadow ⇒ nonzero vector
  moment" implication that C423/C424 will discharge against frozen coordinates.
- Balanced-half uniqueness, the index-two sign action, the double-coset depth profiles, and every
  finite exhaustion remain downstream (C424–C425).
- The vector moment is modelled by its functional evaluations, not as an element of a
  symmetric-tensor power; vanishing of the vector moment is "every functional evaluation vanishes,"
  which is the coordinate-free statement but is not tied to a Mathlib tensor object.
- `signedMoment` sums over a full `Fintype`; a consumer that needs a signed configuration on a
  proper subset instantiates `ι` at the subtype.

## Artifacts

| file | bytes | SHA-256 |
|:---|---:|:---|
| `lean/RelativeConicArcs/ClebschMomentTrade.lean` | 12023 | `6873d542e9a5e7894fb4d0a15156881801419ee2ca1f4602f407d4ae44838976` |
| `lean/RelativeConicArcs/Gates/ClebschMomentTrade.lean` | 452 | `9fcf52697e5db82e044306da48f179c32b44d36e19d57cfd14eb650bb0771a77` |

No generated data (`.py/.json/.sha256`) is expected or produced for F1: the leaf is symbolic and
its load-bearing artifacts are the git-tracked Lean sources above. The Lean sources are deliberately
self-contained — no internal task IDs, campaign names, or note paths — since they are the
externally reviewed artifacts; all internal provenance lives in this report and the queue archive.

## Hand-back

F1 is complete and green. It is the campaign root: F5 (`signedMoment_affine_succ`,
`signedMoment_barycentre_cancel`, `signedMoment_antipodal_even`) and F4/F6
(`vectorMomentForm_ne_zero_of_shadow`) import these terminals directly. The spine gate
`RelativeConicArcs.Gates.ClebschReplacementSpine` (F8) will import the F1 gate among the F1–F8
terminals. F2 may proceed independently.
