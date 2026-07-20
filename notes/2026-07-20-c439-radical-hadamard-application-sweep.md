# C439 radical--Hadamard application sweep

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** `QUEUED`

## Goal

Apply C430's restriction/radical/product-algebra test across the crowns problems for which it is a
genuine structural pretest. Export a theorem, a sharp obstruction, or an exact rank-defect locus to
each owning task; do not replace those tasks with a field-by-field census.

The common input is

```text
sheet restrictions = zero-sum hyperplanes
+ one-dimensional separating second-moment radical
=> degree-two evaluation algebra = equal-sheet-sum hyperplane
=> signed-trade kernel = sheet-sign line.
```

For H3, also consume the proved identification

```text
affine radical = soc(P(1)_+) direct_sum soc(P(1)_-),
outer-odd radical line = C412 depth socle = C430 trade line.
```

## Sweep order and gates

1. **C418/C419 trade and moduli pretest.** Apply the three C430 hypotheses to every named
   seven/eight-point generator family before generating trades. A passing family closes at the
   rigidity theorem. A failing family exports only its exact restriction-rank defect, radical
   level partition, and quotient trade kernel to C418/C419; search nowhere else.
2. **C433 modular seam.** Treat the `P(1)` socle placement and the `6 -> 2` depth-kernel
   identification as solved inputs. Determine whether the odd Fourier block and profile map fit a
   canonical exact sequence through the C430 odd socle. Stop if only decomposition multiplicities
   or another rank computation survive.
3. **C429 arithmetic seam.** Lift the radical separator to the integral `Z[tau]` model, compute its
   Smith/Fitting data, and test Frobenius on the resulting line in split, inert, and ramified
   fibres. Continue only if one datum controls the already-certified arc/code/scheme chiralities;
   stop on a q=11-only reconstruction.
4. **C434 information lattice.** Formulate the coordinatewise-product construction functorially
   on the relevant `K\G/H` permutation modules. Require the radical-to-sheet-to-sign chain to imply
   decorated inversion or another recovery statement. Abstract subgroup bookkeeping is a negative
   stop.

## Boundaries

- C424 consumes the abstract lemma and small certificates but remains `clebsch`-owned; this sweep
  does not edit Lean or claim its release gate.
- C406's classical matching/design ownership and bounded priority verdict are unchanged.
- C430 proves a conditional portable theorem and the exact B3/H3 hypotheses, not an unconditional
  theorem for every index-two orbit.
- Do not broaden fields, enumerate arbitrary arrangements, or launch a general modular character
  census after a failed named gate.

## Deliverable

Commit one same-stem report/script/JSON/checksum bundle recording the hypothesis matrix for every
tested target, exact checked counts and conventions, direct replay, and per-target export/stop
verdicts. Update each owning problem card with only its durable consequence; a target that receives
no theorem or obstruction remains unchanged.

Primary inputs:

- `notes/2026-07-20-c430-conceptual-balanced-half-rigidity.md`
- `notes/2026-07-20-c412-relative-cubic-depth-plane.md`
- `notes/2026-07-20-c418-c419-c410-successors.md`
- `notes/2026-07-20-clebsch-lean-formalization-plan-fable-review.md`
