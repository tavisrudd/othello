# C597 R10 integral bad scheme and SC(11)

**Lane:** `reed-solomon`

**Status:** partial after specialist review; bottom elimination closed,
marker transport open

## Objective

Continue from C595's uniform exclusion of the cyclic/wild branch.  Construct
the complete non-cyclic recursively pointed R10 bad scheme as an integral
finite-type model, prove its chart gluing and saturation equivalence, and
test the resulting coherent-Fano ideal for \(\mathrm{SC}(11)\).

## Required inputs

- `notes/2026-07-24-c595-stable-component-fano-elimination.md`;
- C512's pointed-contraction functor and lower-package definitions;
- C519/C525's residual discriminant and ordered-Hessian models;
- C516/C532 only for the frozen R9/R10 component and arithmetic boundaries;
- C536's integral secant and Lucas coherent-Fano identities.

## Construction

1. inventory every non-cyclic R10 bad stratum with its integral equations,
   auxiliary variables, chart overlaps, and declared saturation factor;
2. distinguish the closed bad scheme from arithmetic deletion divisors and
   from the allowed persistent/Lucas loci;
3. form the universal R11 polar-line coefficient ideal componentwise;
4. saturate in the documented order by rank, persistent, modular,
   fixed-factor, marker-diagonal, collision, and chart-boundary ideals;
5. produce a cleared-denominator certificate if the generic residual is
   empty, or identify the first surviving component/failed equivalence.

## Deliverables

- dated mathematical report and mystery ledger;
- exact generator/checker and compact certificate if a computation carries
  a conclusion;
- explicit R10 chart/gluing ledger;
- an honest verdict on \(\mathrm{SC}(11)\) and paper value.

## Allowed paths

- `notes/2026-07-24-c597-*`;
- this task card;
- the `reed-solomon` handoff, task queue/archive, and discovery track.

The C545 submission manuscript, Lean tree, and all other lanes remain frozen.

## Stop rules

- Do not infer a scheme equality from a high-field rational-point theorem.
- Do not eliminate auxiliary variables before proving that the chosen open
  charts cover the intended recursively pointed functor.
- Stop at the first surviving non-cyclic component or failed chart/saturation
  equivalence; arbitrary higher-level continuation requires another task.

## Outcome

`notes/2026-07-24-c597-r10-integral-bad-scheme-sc11.md` constructs the
integral ordered-root incidence over the cubic-pencil Grassmannian, proves
the corrected symmetric/exchanged/anti-invariant factorization trichotomy,
and gives a
minimal-denominator-\(3\) bridge from the noncollision Pluecker ideal to
C595's cyclic syndrome ideal.  Minimality is specific to this elimination
presentation, not an intrinsic invariant.  The factor \(2\) enters only in the
C525/C595 vertical-fibre step, so the combined integer remains \(6\).
The vertical fibres are exactly the C525/C595
modular and rank/fixed-factor cases.

The original conclusion \(\mathrm{SC}(j)\) for all \(j\geq6\) is withdrawn.
Substitution preserves bottom identities on syndrome--marker space but does
not eliminate retained markers to obtain a condition on the upper syndrome.
The repair gate is to prove that the closure of attainable bottom syndromes is
the projectivized rowspace of the \((j-4)\times5\) catalecticant of \(f\),
then classify its containment in each irreducible level-five bad component.
The characteristic-two cyclic-plane equations recover \(N_3\) at \(j=6\),
\([e_3]\) at \(j=7\), and become empty from \(j=8\) onward; this is the
required regression target, not yet a promoted manuscript theorem.
