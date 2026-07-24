# C546 — solve the H3 pentad-orientation LU mystery

**Lane:** `crowns`

**Date:** 2026-07-23

**Status:** queued after C397's exact local-Clifford stabilizer gate

## Decision question

C402 proves that the indexed four-party marginal moments of the integral H3 AME state recover a
classical one-factorization pentad with party stabilizer `S5`. The marked projective symmetry is
the even `A5` half. The complete q=19 trace-word rank function for all 32,768 subsets of the
commuting marginals still has `S5` symmetry, so that entire invariant family forgets the
index-two orientation.

C546 must decide the actual orbit question:

> Does an odd element of the pentad `S5` lift to a party permutation followed by arbitrary local
> unitaries of the H3 AME tensor?

This is not a request to try one more statistic. The task closes only with a proof of one of the
two complete alternatives below.

## Acceptance alternatives

### A. Orientation is LU-forgettable

Construct an odd pentad permutation and exact local unitaries carrying the H3 state to itself.
Classify the full odd-coset lift set up to the even stabilizer and local scalar gauge, and state
every arithmetic exception across the odd good reductions. Verify the tensor equality directly;
a numerical optimizer, an LC witness in one field, or equality of coarse invariants is not enough.

### B. Orientation is LU-intrinsic

Prove that no odd pentad permutation admits a local-unitary lift. Supply an explicit finite
arbitrary-LU invariant that changes across the two orientations and prove its covariance under
party permutation. Determine the least contraction degree or a sharp certified upper bound when
accessible, and state every arithmetic exception. A failure to find a lift or a collision-free
finite search is not enough.

## Required attack portfolio

The attacks are staged but none is individually the task.

### 0. Prove and package the scalar-only tangent lemma

C402's `ej3` pass gives the hand proof: distance four kills every off-diagonal infinitesimal local
generator, and additive Fourier support on the six distinct coordinate-functional lines kills
every nonconstant diagonal generator. Reprove this in C546's exact tensor conventions and package
it first in the portable form `d(C)>=3`, `d(C^perp)>=3`, then specialize:

```text
Lie(Stab_LU(Psi_H3)) / Lie(local scalar gauge) = 0.
```

This makes the projective LU stabilizer finite and rules out a positive-dimensional lift family.
It does not identify the finite components or imply LU=`LC`; those remain the decision problem.

### 1. Consume the Clifford gate

Use C397's exact party-permuting local-Clifford stabilizer as the first falsifier.

- An odd LC lift immediately proves Alternative A in that field and supplies a candidate integral
  or arithmetic family to classify.
- No odd LC lift does **not** prove Alternative B; it only forces the non-Clifford branches below.
- Reuse C397's logical and operator-pushing data rather than recomputing it.

### 2. Classify the arbitrary-LU lift equations

Write the exact tensor equation for an odd pentad permutation

```text
(U_1 tensor ... tensor U_6) pi|Psi_H3> = lambda|Psi_H3>.
```

Quotient local scalar gauge and the known even stabilizer. Use the minimal-support/critical-state
constraints, the six `3|3` unitary flattenings, and support-intersection algebra to reduce the
unitary equations to the finite components left by Gate 0. Acceptable routes include:

- a proof that every lift is monomial or Clifford in a canonically recovered local basis;
- exact elimination of the unitary/tensor equations with a compact certificate;
- a rigidity theorem from simultaneous flattening intertwiners; or
- an exact component decomposition of the resulting zero-dimensional real-algebraic unitary
  locus.

Do not assume LU=`LC`, use Pauli labels as an LU invariant, or infer nonexistence from optimizer
failure.

### 3. Constructive odd-lift attacks

In parallel with the obstruction route, attempt exact lifts from:

- the exotic `S5` action on the recovered Sylvester pentad;
- the q=5 `PGL_2(5)` boundary and deformation/lifting away from the GRS fibre;
- cut-to-cut Fourier/flattening transports; and
- C395's characteristic-17/31 symmetry controls, compared only within the same local dimension.

Every candidate is checked by literal tensor equality and then classified up to the known gauges.

### 4. General LU-invariant attacks

If no lift emerges, leave the commuting-marginal algebra. Test at least:

1. general multi-copy permutation contractions, with independent `sigma_i in S_m` at each party;
2. closed networks of partially transposed or realigned marginal projectors with consistent
   `U`/`conj(U)` covariance; and
3. oriented holonomy spectra formed from several `3|3` flattenings.

Search contraction degree only with canonical quotienting by simultaneous relabelling, cyclic
trace symmetries, conjugation, and the known pentad action. A passing detector must be proved
arbitrary-LU covariant and evaluated exactly on both orientations. If invariant theory supplies a
finite separating-degree bound, certify the complete bounded search; otherwise an explicit
separator suffices once the no-lift theorem is independently proved.

### 5. Arithmetic closure

Start with q=11, where C374/C397 fix the tensor conventions, and use q=19 as C402's exact
non-Clifford marginal-word control. Then determine the integral or residue-field law:

- split and inert primes of `Z[tau]`;
- the characteristic-5 GRS collapse;
- characteristic two, which is outside C402's odd theorem; and
- any exact exceptional ideals arising from the lift or obstruction equations.

Never compare LU classes across different local dimensions. A finite prime list becomes an
all-field statement only after the relevant integral obstruction ideals or symbolic identities
are factored.

## Completion and stop rules

- Success is Alternative A or B with the arithmetic boundary closed.
- Failure of LC, marginal traces, partial transpose, one contraction degree, or one elimination
  order does not close the task; move to the next attack family.
- Do not launch an unbounded continuous-unitary search. Gate 0 proves that any apparent
  positive-dimensional projective unitary component is an error or an unremoved scalar gauge.
- If all planned exact attacks reduce the question to one explicit unresolved finite
  zero-dimensional real-algebraic scheme, C546 remains open with that scheme as its sole blocker;
  it is not reported as a bounded negative.

## Evidence and literature gates

Any paper-facing computation uses a committed report/script/canonical-certificate/checksum bundle
with direct tensor replay and an independent invariant or elimination check. A positive lift
records exact matrices and gauges. A negative result records the complete searched algebraic
domain and the theorem making it complete.

Before novelty wording, audit:

- polynomial LU invariants and complete multi-copy contraction families;
- LU equivalence and automorphism groups of minimal-support AME/stabilizer states;
- six-point Gale/self-associated configurations and the Sylvester pentad; and
- unitary tensor automorphisms and perfect-tensor flattening holonomies.

C402's audit already fixes the classical boundary: the pentad, exotic `S5`, and even `A5` core
are not new. C546 can own only the arbitrary-LU lift classification, the minimal detector, and
their arithmetic law.

## Frozen inputs and ownership

- C402 owns `60+b(A,A*)`, the exact `70>66` H3/GRS separator, the LU-readable pentad, and the q=19
  full commuting-marginal no-go.
- C397 owns the local-Clifford/logical/operator-pushing gate and is consumed, not duplicated.
- C374 owns the q=11 tensor convention and general marginal-moment covariance.
- C395 owns the characteristic-17/31 same-field control towers.
- C546 owns the complete arbitrary-LU orientation dichotomy and does not broaden to arbitrary
  non-GRS AME classification.
