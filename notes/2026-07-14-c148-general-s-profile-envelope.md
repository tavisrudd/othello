# C148 — exact general-`s` profile envelope

**Lane**: `alt-orbit-repair`

**Date:** 2026-07-14
**Status:** REPORTED — exact envelope, semantic 319-pair bound, 318-repair theorem, and manuscript
gates passed

## Goal

Kernel-check the exact first-order legal-pair lower bound for each invariant eight-arc profile,
identify the profile minimizing the five certified bounds as `s` varies, and derive the uniform
corollary that deletion leaves at least 318 alternative repairs for every base order `s ≥ 7`.

This is a lower-bound envelope.  It is not an assertion that the bound is attained or equals the
true minimum number of legal pairs.

## Arithmetic target

Let `N(s)=(s²-s)/2`.  Expanding the checked empty-carrier and noninvariant-secant-orbit formulas
gives total legal-pair lower bounds:

| `(f,e)` | `E_f(s)` | `M_f` | `L_f(s)=E_f(s)(N(s)-M_f)` |
|---:|---:|---:|---:|
| `(0,4)` | `s²+s-3` | `12` | `(s²+s-3)(N-12)` |
| `(2,3)` | `s²-s-3` | `12` | `(s²-s-3)(N-12)` |
| `(4,2)` | `s²-3s+1` | `10` | `(s²-3s+1)(N-10)` |
| `(6,1)` | `s²-5s+9` | `6` | `(s²-5s+9)(N-6)` |
| `(8,0)` | `s²-7s+21` | `0` | `(s²-7s+21)N` |

Direct arithmetic gives the candidate minimizing profile:

- `f=4` at `s=7`;
- `f=6` at `s=8,9`; and
- `f=8` for `s ≥ 10`.

At `s=7`, the five values are `477,351,319,345,441`; subtracting the erased orbit gives the
uniform candidate `318`.  The boundary vectors are `1104,848,738,726,812` at `s=8` and
`2088,1656,1430,1350,1404` at `s=9`, so the envelope rises immediately to 726 and then 1350.

## Formal plan

1. Define the profile-specialized lower bounds directly from `baerEmptyLineCount` and
   `baerNonInvariantSecantOrbits`.
2. Prove the five closed forms under `7 ≤ s`, eliminating all truncated-subtraction ambiguity.
3. Prove the pairwise crossover inequalities and the piecewise envelope.
4. Compose the envelope with `quadratic_global_pair_lowerBound` and
   `pred_le_card_alternateLegalPairs`.
5. Expose both the strong piecewise theorem and the simple paper-facing uniform `318` corollary.

## Paper-facing consequence

The uniform theorem strengthens C142's deliberately coarse eight-alternative statement to 318
without a new geometric or finite certificate: it retains the exact number of empty fixed carriers
instead of discarding that factor after proving one carrier exists.  The clean headline is therefore
an exact lower-bound envelope plus a robust corollary, not a claim that some arc has exactly 318
repairs.

Recommended wording after the Lean gate:

> For every prime-power base order `s≥7`, deleting any selected nonfixed Frobenius orbit from an
> invariant ten-arc in `PG(2,s²)` leaves at least 318 different legal conjugate orbits.  More
> precisely, the certified first-order lower envelope is minimized by the four-fixed profile at
> `s=7`, the six-fixed profile at `s=8,9`, and the eight-fixed profile for `s≥10`.

## Formal result

`AlternateOrbitRepairProfileEnvelope.lean` defines the five raw profile bounds and their pointwise
minimum. Lean proves:

- the five closed forms in the table above;
- the exact value vectors at `s=7,8,9`;
- `profileEnvelope 7 = profileFour 7 = 319`;
- `profileEnvelope 8 = profileSix 8 = 726`;
- `profileEnvelope 9 = profileSix 9 = 1350`;
- `profileEnvelope s = profileEight s` for every `s≥10`; and
- `319 ≤ profileEnvelope s`, hence `318 ≤ profileEnvelope s - 1`, for every `s≥7`.

The infinite crossover branch identifies twice each natural lower bound with an integer quartic.
After writing `s=t+10`, the four differences against the `f=8` quartic have nonnegative
coefficients. The independent uniform proof bounds every carrier and candidate factor from its
`s=7` value, so the 319 floor does not depend on the crossover classification.

`AlternateOrbitRepairProfileEnvelopeResult.lean` exposes the semantic comparison
`profileEnvelope_le_card_globalLegalPairs_of_card_eight`, proves at least 319 semantic legal pairs
for every invariant eight-arc over a base of order at least seven, and removes the erased orbit to
prove `three_hundred_eighteen_le_alternateLegalPairs_of_seven_le`.

## Independent arithmetic check

`notes/2026-07-14-c148-profile-envelope-check.py` checks the defining formulas against the five
expanded quartics through `s=1000`, verifies the three boundary vectors, and independently checks
the nonnegative-coefficient certificates for both the infinite crossover and every forward
difference from `s=7`. It exits successfully in 0.03 seconds with 12,064 kB peak RSS.

Verifier SHA-256:
`1398d5a60c07e1d845577dcffb44d24dc021077f8d42f27e32f2cf2961a69fa9`.

## Lean validation and trust

Both targets were built with `LEAN_NUM_THREADS=1`, `choom -n 1000`, and core 20 reserved:

| Target | Wall time | Peak RSS | Result |
|---|---:|---:|---|
| `RelativeConicArcs.AlternateOrbitRepairProfileEnvelope` | 11.17 s | 1,953,292 kB | pass |
| `RelativeConicArcs.AlternateOrbitRepairProfileEnvelopeResult` | 4.32 s | 1,932,152 kB | pass |
| result target, `lake build --no-build` | 2.11 s | 492,912 kB | all 3,284 jobs up to date; zero writes |

The scoped forbidden-token scan is clean. Declaration-level `#check` and `#print axioms` cover the
infinite crossover, exact semantic envelope comparison, 319-pair theorem, and 318-repair theorem;
each reports exactly `[propext, Classical.choice, Quot.sound]`.

Final hashes:

| Artifact | SHA-256 |
|---|---|
| `AlternateOrbitRepairProfileEnvelope.lean` | `2fe0b276c4702373ec63b403066ec56eb166a5ecd3e52b145ffd0114943472bd` |
| `AlternateOrbitRepairProfileEnvelopeResult.lean` | `0eef852866d90c99b5526083c61fe8d11e37ad810e2493d587f493857598eddf` |
| arithmetic `.olean` | `65ad98b77f924d7ade7fb18e9d047a544f0db74768d56339654fdd0675d73ca5` |
| arithmetic `.trace` | `a9e4342d47ba08a8c30b6d180040c39cee341cdedc3f45cfe530d9d02781ead3` |
| result `.olean` | `b2635962571d303dc6a20db702f20c1ef89ede105ac40a9eed6237fa6239c7d0` |
| result `.trace` | `e023252a4c0a062d2737d94143ae54b9478ae74c377322dc1be941db01f5e036` |

## Manuscript gate

The paper now states the five-profile envelope, piecewise minimizing profile, semantic 319-pair
bound, and 318-alternate-repair corollary. Tectonic and BibTeX complete without document warnings,
unresolved references, or box warnings.

| Artifact | SHA-256 |
|---|---|
| `frobenius_pair_extension.tex` | `000eb2aa0d127e7a2ddea1c6602b18b69354a6787ef379b5ff2d656c885e9d0d` |
| `frobenius_pair_extension.pdf` | `ea4547ab470e989c289735713e080f8bb430673eeaa8d81d0645f6f89dac0e69` |
