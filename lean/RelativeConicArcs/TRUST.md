# Trust manifest — arcs complete outside a conic

This directory is the standalone Lean formalization of
`papers/arcs_complete_outside_conic/`.  It is one-way coupled to the existing `ProjectiveCap`
library: it may import general projective infrastructure, but no existing project imports this
spinoff.

## Machine-checked theorem map

| Layer | Main declarations | Status |
|---|---|---|
| incidence and relative completeness | `Arc`, `CompleteOutside`, `rho`, `ProjectiveBridge.arc_iff_projectiveCap` | defined/proved in Lean |
| moments and defect | `pointIndex_le_half_card`, `first_secant_moment`, `second_secant_moment`, defect/coverage/stability theorems in `Defect.lean` | proved in Lean |
| conic and finite bounds | `mem_standardConic_iff_onConic`, `NonsingularConic.finite_lower_bound`, `L1_le_L2`, `L2_le_rho` | proved in Lean |
| asymptotics | `parityFreeNecessary`, explicit additive lower bound, Big-O and liminf wrappers in `Asymptotic.lean` | proved in Lean |
| averaging | projective disjoint-translate theorem, `rhoC_le_t2`, `rhoC_le_of_kimVuBound` | proved in Lean; Kim--Vu remains an explicit theorem parameter |
| characteristic two | hyperoval/nucleus/tangent classification and nucleus-in/out inequalities in `Nucleus.lean` | proved in Lean under `(2 : K) = 0` |
| certificate bridge | `Certificate.check_sound`, `Certificate.rhoC_le_length_of_check` | proved in Lean for every finite field |
| finite examples | `Examples.rhoC_GF8`, `rhoC_GF9`, `rhoC_ZMod11`, `rhoC_GF16_bounds` | kernel-checked |

The four exact arithmetic thresholds are also explicit theorems:
`L2_eight = 6`, `L2_nine = 6`, `L2_eleven = 6`, and `L2_sixteen = 8`.

## Certificate contract

`Certificate.check` is a rules-only Boolean checker.  It checks:

1. every listed vector is off `XZ = Y²`;
2. every projectively distinct listed triple has nonzero determinant; and
3. every canonical projective representative `[1:y:z]`, `[0:1:z]`, or `[0:0:1]` is on the
   conic, represents a listed point, or lies on a secant of two projectively distinct listed
   points.

`check_sound` proves that acceptance implies `CompleteOutside` for the corresponding projective
point set.  The normalization proof is generic and shows that these `q²+q+1` representatives
cover every projective point.  The accepted list need not be normalized, duplicate-free, or use a
unique representative per projective point.

The checker and all concrete field laws use Lean's kernel-reduced `decide`.  No theorem uses
`native_decide` or an external evaluator.  The `q=16` proof is split into independent field-law,
arc, disjointness, and canonical-coverage leaves solely to bound build memory; the aggregate
theorem composes their checked propositions.

## Frozen witness provenance

Source verifier:
`papers/arcs_complete_outside_conic/verify_relative_conic_arcs.py`

SHA-256:
`e9508958d604e68c6c3d09fd3afadfaa8a3126508a51f1dfa993e7a7aed5d36a`

The coordinate lists in `Examples.lean` are copied verbatim from that verifier:

- `q=8`: six points over `F₂[a]/(a³+a+1)`, binary polynomial-basis encoding;
- `q=9`: six points over `F₃[a]/(a²+1)`, encoding `a₀+3a₁`;
- `q=11`: six points over `ZMod 11`;
- `q=16`: nine points over `F₂[a]/(a⁴+a+1)`, binary polynomial-basis encoding.

The verifier's frozen report is:

```text
q=8  k=6 points=73  conic_points=9  secants=15 required_points=58  I_C=16 L2=6
q=9  k=6 points=91  conic_points=10 secants=15 required_points=75  I_C=13 L2=6
q=11 k=6 points=133 conic_points=12 secants=15 required_points=115 I_C=0  L2=6
q=16 k=9 points=273 conic_points=17 secants=36 required_points=247 I_C=32 L2=8
```

The Python verifier is provenance and an independent cross-check, not part of the Lean proof.

## Axiom audit

`#print axioms` for `Certificate.check_sound`, `rhoC_le_length_of_check`, all four `L2` theorems,
and all four final finite-example theorems reports exactly:

```text
[propext, Classical.choice, Quot.sound]
```

These are the accepted Mathlib foundations used throughout the projective quotient development.
There is no `sorryAx`, custom axiom, `admit`, or `native_decide` dependency.

## Explicit external boundary

The only deep paper input intentionally not reproved is the Kim--Vu complete-arc estimate.  It is
represented by the named hypothesis `KimVuBound` and appears in theorem signatures; it is not a
global axiom and is not used by the four finite-example results.
