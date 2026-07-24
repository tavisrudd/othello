# C569 — four-copy transport divisor and characteristic-seven merger

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Verdict:** `COMPLETE; THE REDUCED OPERATOR, CYCLE-POLYNOMIAL FACTORIZATION, QUOTIENT DIVISOR, RANK-EXCESS ARITHMETIC, AND CHARACTERISTIC-SEVEN MERGER ARE FORMALIZED WITH DETERMINANT AND ORBIT-GEOMETRY INPUTS EXPOSED`

## Formal package

`RelativeConicArcs.AMELU.TransportDivisor` defines the systematic
coefficient matrix

```text
[[b+c,b,c],[b+c,c,b],[d,d,d]]
```

and the concrete `9 × 9` block transport operator with blocks
`Q_ik(ρ_i-ρ_(3+k))`.  The three cycle ledgers are explicit polynomials in
`b,c`.  Ordinary kernel-checked ring proofs establish

```text
P_- = AB(3B-2A),
P_+ = AB(3B+2A),
P_2 = A(B^2-2A^2),
```

for `A=(b+c)(c-b)` and `B=bc`.

`TransportCycleCoverInputs` supplies the three six-tuples of copy-quotient
actions and keeps the three actual determinant expansions as named
hypotheses.  The downstream theorems

```text
TransportCycleCoverInputs.negativeSigned_det_factor
TransportCycleCoverInputs.positiveSigned_det_factor
TransportCycleCoverInputs.axial_det_factor
```

derive the localized determinant factors without hiding the cycle-cover
calculation in an axiom or an uninterpreted determinant scalar.

## Divisor and rank bridge

The module proves that the two signed factors multiply to
`9B^2-4A^2`, and hence that the reduced divisor is exactly

```text
(B^2-2A^2)(9B^2-4A^2).
```

Over a field it vanishes exactly on the axial or either signed factor.
Away from `A=0`,
`reducedTransportDivisor_eq_zero_iff_z` identifies its zero set with

```text
((B/A)^2-2)(9(B/A)^2-4)=0.
```

Thus the formal coordinate `z=(B/A)^2` gives precisely
`(z-2)(9z-4)`.

`TransportRankBridgeInputs` exposes the geometric elimination identity

```text
21 - matchingRank = 9 - transportRank
```

and its dimension bounds.  Lean proves that transport ranks `8` and `9`
therefore correspond to matching ranks `20` and `21`.  The elimination
which establishes the displayed equality remains a named input.

`TransportOrbitGeometryInputs` separately records the axial and two signed
party-assignment supports, their exact `96/192/192` cardinalities, and
pairwise disjointness.  Lean derives both characteristic-seven union counts
`96+192=288`.  The double-coset recognition and generic one-dimensional
kernel calculation remain external mathematical/certificate inputs.

## Characteristic seven

The integral scheme identity

```text
(3B-2A)(3B+2A) - 2(B^2-2A^2) = 7B^2
```

is proved over every commutative ring.  In characteristic seven Lean
specializes it to equality of the signed union with twice the axial factor
and proves

```text
reducedTransportDivisor = 2(B^2-2A^2)^2.
```

The closeout theorem
`reducedTransportDivisor_eq_zero_iff_axial_of_charSeven` strengthens this
to equality of zero sets over every field of characteristic seven.

## Validation and trust

Warning-free guarded elaboration passed for
`RelativeConicArcs.AMELU.TransportDivisor`.  The measured `single` profile
queue built

```text
RelativeConicArcs.AMELU.TransportDivisor
RelativeConicArcs.Gates.AMELUTransportDivisor
RelativeConicArcs.Gates.AMELUTransportDivisorAxioms
```

and passed the trace-only aggregate gate and exact no-build checks.  Peak
resident memory was 1,544,444 KiB.  The axiom audit reports only `propext`,
`Classical.choice`, and `Quot.sound`.  There is no `sorry`, native
evaluation, generated source, external certificate declaration, unsafe
execution, or project-specific axiom.

Commits `a7a5fda9` and `1e53c2d0` contain the formal package and the
characteristic-seven closeout strengthening.

## `ej` / Tao closeout and mystery ledger

The closeout added three cheap structural upgrades.  It exposed the
`9 × 9` operator itself rather than accepting three anonymous determinant
scalars, added the exact three-factor zero-locus theorem and the
`20/21 ↔ 8/9` rank arithmetic, and strengthened the modulo-seven polynomial
identity to equality of reduced zero sets.  The Tao stress test separated
what ring normalization proves from what identifies the relative-cover
cells: the former is unconditional, while the latter is visible in the
types as finite support and determinant hypotheses.

| feature | disposition |
|:---|:---|
| Cycle-polynomial factorization | **Settled:** all three identities are kernel-checked over arbitrary commutative rings. |
| Reduced divisor and quotient coordinate | **Settled:** the homogeneous divisor and its `(z-2)(9z-4)` zero set are proved away from `A=0`. |
| Characteristic-seven merger | **Settled:** both the doubled scheme identity and equality of reduced zero sets are proved. |
| Rank `20/21` conversion | **Settled conditionally:** the arithmetic follows from the explicit kernel-excess equality; the systematic elimination proving that equality remains an input. |
| Determinant expansion | **Explicit evidence boundary:** the operators are concrete, but their three signed cycle-cover determinant evaluations are fields of `TransportCycleCoverInputs`. |
| Multiplicities `96/192` | **Explicit geometry boundary:** Lean proves the `288` merger count from support sizes and disjointness; double-coset construction and recognition remain fields of `TransportOrbitGeometryInputs`. |
| Generic one-dimensional kernel | **Open only at the formal-adoption boundary:** it remains a certificate/manuscript input owned by C570 reconciliation, not a missing algebraic lemma in this package. |

The discovery-track review found no incidental observation.  Every item
encountered was part of the requested algebra, rank bridge, trust boundary,
or closeout stress test.

## Vibe check

Strong.  The formal API now says exactly which part of the transport theorem
is polynomial algebra and which part is finite cover geometry, while the
characteristic-seven collision is proved at scheme and zero-set level.
