# C421 / F2 — Lean conic pairing-forgetting quotient

**Lane:** `clebsch`

**Date:** 2026-07-20

**Verdict:** `GREEN — reusable pairing-forgetting quotient API formalized in Lean; six exit families
kernel-backed; switch connectivity formalized at the "purely finite" base generator with the general
2n-endpoint case reduced to it by a declared standard induction. Axiom audit clean.`

## What this task formalizes

F2 of the replacement-spine Lean campaign
([`notes/2026-07-20-clebsch-lean-formalization-plan.md`](2026-07-20-clebsch-lean-formalization-plan.md)).
It Lean-formalizes C403's standard-conic pairing-forgetting quotient
([`notes/2026-07-20-c403-arrangement-complement-distance.md`](2026-07-20-c403-arrangement-complement-distance.md),
§ *Pairing-forgetting quotient and factorization kernel*), the structural input consumed by the
C406 harmonic quotient
([`notes/2026-07-20-c406-matching-module.md`](2026-07-20-c406-matching-module.md)).

Work on the standard conic `C : XZ − Y² = 0` with Veronese `ν(s,t) = [s² : st : t²]`.  For distinct
conic points `ν(sᵢ,tᵢ), ν(sⱼ,tⱼ)` the canonically scaled secant is
`L_ij = tᵢtⱼ X − (sᵢtⱼ + tᵢsⱼ) Y + sᵢsⱼ Z`.

## Owned modules

| module | role |
|:---|:---|
| `lean/RelativeConicArcs/ClebschConicMatchingQuotient.lean` | the quotient API (all content) |
| `lean/RelativeConicArcs/Gates/ClebschConicMatchingQuotient.lean` | import-only validation gate |

No generated matching census: the module is symbolic, consistent with the F2 plan slice
("reusable quotient API plus a light paper-facing theorem; no generated matching census").  It
imports the existing conic/projective API (`RelativeConicArcs.Conic`) and `Mathlib`.

## Exit theorems (one namespace `RelativeConicArcs.ConicMatchingQuotient`)

Over the weakest ring (any `CommRing R`):

- **Secant pullback** — `secant_veronese`:
  `ν*(L_ij) = (tᵢs − sᵢt)(tⱼs − sⱼt)`, plus `conicForm_veronese : Q(s²,st,t²) = 0`.
- **Four-endpoint switch identity** — `secant_switch`:
  `L_ab L_cd − L_ac L_bd = [a,d][b,c]·(XZ − Y²)`, `[i,j] = sᵢtⱼ − tᵢsⱼ`.  This is the plane lift of
  the matching switch `{ab,cd} ↦ {ac,bd}`.  The bracket pairing `[a,d][b,c]` is the unique correct
  one (checked symbolically; the three alternative pairings fail).
- **Quotient divisibility** — `conicForm_dvd_secant_switch`: the switch difference is an explicit
  multiple of `conicForm X Y Z`, so every switch difference lies in the conic ideal.

Parent forgetting (matchings as lists of endpoint pairs, `CommRing R`):

- `matchingProduct_veronese`: the Veronese pullback of a matching's secant product equals the product
  of the Veronese linear factors over the flattened endpoint list.
- **Parent forgetting** — `matchingProduct_veronese_congr`: two matchings whose endpoint lists agree
  up to permutation — in particular any two perfect matchings of the same endpoint set — have equal
  pullbacks; the factorization map forgets the parent matching.

Augmentation kernel (free space `ι → K` on the matchings, `Field K`, `Fintype ι`):

- `sumFunctional`, `augmentation`, `mem_augmentation`: the augmentation hyperplane `{a : ∑ᵢ aᵢ = 0}`.
- **Restriction kernel = augmentation** — `ker_restriction`: since all matchings restrict to the
  common nonzero section `F`, the restriction map `a ↦ (∑ᵢ aᵢ)·F` has kernel exactly the augmentation.
- **Augmentation dimension** — `finrank_augmentation`: `dim = card ι − 1` (`= (2r−1)!! − 1`).

Full-rational-evaluation boundary (finite field, `Field K`, `Fintype K`):

- **Boundary vanishing** — `boundaryForm_eq_zero`: at `2r = q + 1` the section `s^q t − s t^q`
  vanishes at every rational point (`a^q = a`), so the boundary word is zero.
- **Sub-boundary zero set / nonvanishing** — `prod_veroneseFactor_eq_zero_iff`,
  `prod_veroneseFactor_ne_zero`: below the boundary the section `∏_{i∈S}(tᵢ s − sᵢ t)` vanishes at a
  rational point iff that point is projectively one of the endpoints, so the zero set is exactly `S`
  (distinct endpoint sets give distinct words, of weight `q + 1 − 2r`).

Switch connectivity (matchings as fixed-point-free involutions on `Fin m`):

- **Switch reversibility (any size)** — `isSwitch_symm`: a four-endpoint switch is undone by a
  four-endpoint switch, so switch adjacency is symmetric.  Depends on no axioms.
- **Base four-endpoint generator** — `base_switch_triangle`: the three matchings of a `4`-set are
  pairwise single switches (a complete switch triangle).
- **Base connectivity** — `base_switchConnected`: every perfect matching of a `4`-set is
  switch-connected (`Relation.ReflTransGen` of switch adjacency) to the base matching `{01,23}`.

### Scope of switch connectivity (declared boundary)

The plan slices switch connectivity as "purely finite."  Formalized in-kernel here are the general
switch reversibility and the base four-endpoint generator with its complete connectivity — the atomic
generator on which the paper's argument rests.  The general `2n`-endpoint connectivity ("force one
desired edge by one switch and induct on the remaining endpoints", C403) reduces to this generator by
the standard finite induction; that induction is not brought fully in-kernel (it needs sub-involution
restriction bookkeeping disproportionate to the light-theorem slice, per the campaign stop rule for
finite claims that would require a monolithic case tree).  The augmentation kernel is instead
computed directly (`finrank_augmentation`) rather than via "switches generate", so no exit depends on
the general connectivity being in-kernel.

## Symbolic cross-check of the load-bearing identities

The two polynomial identities were verified independently with `sympy` before formalization:
`secant_veronese`, `secant_switch` (with the unique bracket pairing `[a,d][b,c]`), and the conic
pullback.  The Lean proofs of both are by `ring` after unfolding, so the checker boundary is Lean's
kernel plus `ring`.

## Validation

- Guarded single-file elaboration: `lean/scripts/guarded-lean
  RelativeConicArcs/ClebschConicMatchingQuotient.lean` — clean (no warnings, no errors).
- Gate build + exact-target `--no-build` aggregate confirmation through the unattended queue:
  `lean/scripts/lean-build-queue.py run RelativeConicArcs.Gates.ClebschConicMatchingQuotient
  --profile single --threads 1 --cores 20-23`.
- **Axiom audit** (`#print axioms` on every terminal, in the module): each depends only on the
  standard `[propext, Classical.choice, Quot.sound]` (or fewer; `isSwitch_symm` depends on none).  No
  `sorryAx`, no project-local axiom.

## Verification map delta

All six F2 exit families are kernel-backed over the stated rings/fields, with switch connectivity at
the declared purely-finite generator boundary above.  No `ClebschGateway*.lean` module or
`ReflectionArrangementDecoding.lean` was edited; the task adds two new modules only.  This leaf is a
consumer terminal for F3 (`C422`, harmonic quotient) and is imported nowhere else yet.

## Source artifacts

| file | bytes | SHA-256 |
|:---|---:|:---|
| `lean/RelativeConicArcs/ClebschConicMatchingQuotient.lean` | 15,859 | `86ead26c40f22f1a4876a17b451bc3c28d0052aa68f88b413b5a821b10658a61` |
| `lean/RelativeConicArcs/Gates/ClebschConicMatchingQuotient.lean` | 612 | `c3d6d82ef348ad7c91adc0711dea6399758667e726713b460d7b95aa5b994c63` |

Hashes are for the committed sources; regenerate with `sha256sum` from `lean/`.
