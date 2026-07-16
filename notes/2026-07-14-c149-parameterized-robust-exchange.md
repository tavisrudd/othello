# C149 — parameterized robust equivariant exchange

**Lane**: `alt-orbit-repair`

**Date:** 2026-07-15
**Status:** REPORTED — exact phase diagram, semantic theorem, independent scan, trust audit, and
manuscript/PDF gates passed

## Goal

Generalize alternate-orbit repair from deletion `10→8` to deletion `(k+2)→k`, with a quantitative
range that is genuinely geometric rather than only the tautology that many extensions give many
replacements.

## Phase-diagram result

For a remainder profile `k=f+2e`, the existing exact obstruction count simplifies to

```text
M(k,f,e) = f*e + e*(e-1) = e*(k-e-1).
```

Its exact maximum over all parity-compatible profiles is

```text
W(k) = floor((k-1)^2 / 4).
```

Let `N(s)=s(s-1)/2`. One empty fixed carrier therefore gives at least `N(s)-W(k)` legal
conjugate-pair extensions uniformly over the profile, and deletion of the erased orbit leaves at
least

```text
R(s,k) = N(s) - W(k) - 1
```

alternatives, with natural-number truncation understood. More generally, the clean multiplicity
condition

```text
W(k) + r + 1 ≤ N(s)
```

gives at least `r` alternate repairs after arbitrary selected-orbit deletion.

This is a nontrivial family: the largest useful `k` is asymptotic to `sqrt(2)*s`, not a fixed arc
size. For example, the largest remainder sizes guaranteeing at least one alternative for
`s=5,6,7,8,9,10` are `6,8,9,11,12,14`.

## Empty-carrier range

The completed-square identity already proved in `BaerArithmetic.lean` is

```text
2*occupied = (s+1)^2 + k - (f-s-1)^2.
```

For `s≥3` and `k≤2s+1`, it implies at least one empty fixed carrier. The exact multiplicity
condition above lies inside this carrier-friendly range. A simpler rectangular corollary
`1≤k≤s+1` holds for `s≥4` and gives a large quadratic number of repairs, but the main theorem
retains the exact `W(k)+r+1≤N(s)` boundary. The lower-order restriction is real:
`(s,k)=(3,4)` misses the one-alternate condition by exactly one candidate.

## Formal result

`AlternateOrbitRepairPhaseDiagram.lean` proves:

- `M(k,f,e)=e(k-e-1)` and `M(k,f,e)≤W(k)` for every compatible profile;
- exactness of `W(k)`: the bound is attained by `f=0` for even `k` and `f=1` for odd `k`;
- the phase inequality itself implies `k≤2s+1`, hence `k<s²+1` for `s≥3`;
- the completed-square identity then supplies an empty fixed carrier without a separate geometric
  assumption;
- `phase_profile_product_lowerBound`, the profile-uniform `r+1` legal-pair arithmetic bound; and
- the clean rectangle `s≥4`, `k≤s+1`, `r=1`.

`ParameterizedAlternateOrbitRepair.lean` proves the semantic API:

- `delete_selected_nonfixed_orbit_of_card_add_two`, the invariant `(k+2)→k` deletion theorem;
- `add_one_le_card_globalLegalPairs_of_phase`, which transports the phase bound to the semantic
  global legal-pair finset; and
- `card_alternateLegalPairs_ge_of_phase`, the paper-facing robust exchange theorem: under
  `W(k)+r+1≤N(s)`, arbitrary selected-orbit deletion leaves at least `r` different legal conjugate
  pairs.

The ten-to-eight theorems remain unchanged as compatibility-specialized public declarations.

## Independent check

`notes/2026-07-15-c149-phase-diagram-check.py` verifies through `k=2000` that `W(k)` is the exact
profile maximum and through `s=1000` that the multiplicity condition lies inside the stated
empty-carrier range and every compatible profile has a positive carrier count. The scan is a
mutation guard; the completed-square identity and the concave-quadratic maximum are independently
proved in Lean. Runtime was 57.19 seconds on one pinned core with 11,840 kB peak RSS.

## Incidental discovery track

The first rectangular claim was one unit too broad at the smallest base order. The independent
checker found that `(s,k)=(3,4)` has `W(k)+2=4>N(3)=3`; all `s≥4`, `k≤s+1` satisfy the condition.
The final Lean theorem records the sharp `s≥4` threshold rather than hiding the exception. This
does not affect the exact phase theorem, which already excludes `(3,4)` through its own hypothesis.

The more interesting structural point is that the multiplicity inequality automatically forces
the empty-carrier hypothesis needed by the geometric count. Thus the final theorem is not an
abstract “many completions imply many replacements” tautology: one numerical phase condition both
creates a carrier and leaves the prescribed surplus after the worst profile obstruction.

## Validation

- `RelativeConicArcs.AlternateOrbitRepairPhaseDiagram`: 3,010 jobs, 7.56 seconds wall,
  1,887,452 kB peak RSS.
- `RelativeConicArcs.ParameterizedAlternateOrbitRepair`: 3,285 jobs, 4.00 seconds wall,
  1,935,816 kB peak RSS after the final arithmetic dependency change.
- `lake build --no-build RelativeConicArcs.ParameterizedAlternateOrbitRepair`: all 3,285 targets
  up to date, 2.29 seconds wall, 493,472 kB peak RSS.
- Forbidden-declaration scan: no `sorry`, `admit`, custom `axiom`, `unsafe`, or `native_decide`.
- Declaration-level audit of the exact-envelope, carrier, rectangle, semantic-count, and final
  repair theorems: exactly `[propext, Classical.choice, Quot.sound]`.
- Manuscript rebuilt successfully with no TeX box/reference warnings; synchronized PDF size
  109.69 KiB.

Final SHA-256 checkpoints:

```text
208f4edb8cbad8791479053f5411d24675662be0c7c9e86dbb529f1adf8acfc3  AlternateOrbitRepairPhaseDiagram.lean
2892a5d89971ca9be5f5e9bc555c25458a22e3a5b8d0fddcd6faa8c06dc91db3  ParameterizedAlternateOrbitRepair.lean
c60698bcd73740f1bc93ccdab5df14b9b8db0c868664793ce260863261ca8d51  AlternateOrbitRepairPhaseDiagram.olean
390302d4fe183c51838c81275e2f5f8be2edcaaa981fa4bbef99ec3955bafac2  AlternateOrbitRepairPhaseDiagram.trace
e5a100b536be950d08d31f23e2c145d4b365f857b0f924a436aa1e3fe04e9c8a  ParameterizedAlternateOrbitRepair.olean
9d6d2ac5cac4f847bd737362b3a0d1aa5713075f950352baf6a616886398e977  ParameterizedAlternateOrbitRepair.trace
2e84cff7438002cf433fd8cfd7a8454edb54ba5eabede41f9309b2a7b3e3252b  phase-diagram-check.py
5c83162e4f5b4eee899cb7d0467e38691ae163ceb057c52811dad7611c23c463  frobenius_pair_extension.tex
b9b023e6a4e93e580f0c488d5e590eb0dfecb059ba23dd9abaa03eba4548b387  frobenius_pair_extension.pdf
```

The exactness claim concerns the uniform first-order obstruction envelope `W(k)`, not the attained
minimum of the true semantic legal-pair count.
