# C566 — admitted-pencil local-Clifford classification interface

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Verdict:** `COMPLETE; THE ALGEBRAIC QUOTIENT IS PROVED AND EVERY UNFORMALIZED CLASSIFICATION INPUT IS AN EXPLICIT HYPOTHESIS`

## Formal package

`RelativeConicArcs.AMELU.PencilClassification` now defines:

- the ordered six-point family `nonGRSPencil t`;
- the conic-boundary quartic `pencilGRSQuartic`;
- the complementary-bracket products `pencilA` and `pencilB`;
- the quotient coordinates `pencilY` and `pencilZ`; and
- the exact five-factor predicate `IsAdmittedNonGRSParameter`.

The module proves that admission makes every required factor nonzero, proves

```text
A(t) = -4 t^2 y(t),
B(t) = t^2 (y(t)^2 - 1),
z(t) = (y(t) - y(t)^-1)^2 / 16,
```

and closes the algebraic fibre calculation in
`pencilZ_eq_iff_samePencilYOrbit`:

```text
z(t) = z(u)
  iff
y(u) in {y(t), -y(t), y(t)^-1, -y(t)^-1}
```

for admitted parameters over every odd-characteristic field.

## Hypothesis boundary and classification theorem

`PencilClassificationInputs` exposes four results that this package does
not prove:

1. every admitted member is a six-arc;
2. equal `z` values are realized by a projectivity, party permutation, and
   column scalings;
3. projective equivalence preserves `z` through the complementary-bracket
   invariant; and
4. local-Clifford equivalence preserves `z` through the holonomy
   classification.

The structure also records the odd-characteristic hypothesis.  There is no
opaque axiom or declaration whose name conceals any of these inputs.

From this structure and the already proved dictionary,
`admitted_nonGRS_pencil_classified_by_z` derives, for admitted `t,u`, all
three equivalences

```text
nonGRSPencil t ~projective nonGRSPencil u  iff z(t)=z(u),
ker H_t ~monomial ker H_u                     iff z(t)=z(u),
Psi_t ~LC Psi_u                               iff z(t)=z(u).
```

The projective-to-monomial and monomial-to-local-Clifford directions are
the kernel-checked theorems in
`RelativeConicArcs.AMELU.Dictionary`; the converse directions use only the
named fields above.  Thus the formal statement has the manuscript's exact
domain and action conventions without claiming that the geometric bracket
or holonomy arguments themselves have been formalized.

The import-only terminal is
`RelativeConicArcs.Gates.AMELUPencilClassification`.  The adjacent
`AMELUPencilClassificationAxioms` terminal audits the two algebraic
quotient results and the classification theorem.

## Validation and trust

The source passed warning-free guarded elaboration.  The measured `single`
profile queue then built, in order,

```text
RelativeConicArcs.AMELU.PencilClassification
RelativeConicArcs.Gates.AMELUPencilClassification
RelativeConicArcs.Gates.AMELUPencilClassificationAxioms
```

and passed its final trace-only aggregate gate and exact no-build probes.
Peak resident memory was 1,844,680 KiB.  The final `#print axioms` audit
reported exactly

```text
propext
Classical.choice
Quot.sound
```

for `pencilZ_eq_pencilZFromY`,
`pencilZFromY_eq_of_sameOrbit`,
`samePencilYOrbit_iff_pencilZFromY_eq`,
`pencilZ_eq_iff_samePencilYOrbit`, and
`admitted_nonGRS_pencil_classified_by_z`.

There is no `sorry`, project-specific axiom, native or unsafe evaluation,
generated source, external certificate, or trusted computation.

## `ej` / Tao closeout and mystery ledger

The closeout pass promoted one cheap improvement into the formal API:
instead of asking a consumer to compose the `z=z(y)` identity with the
four-branch orbit lemma, `pencilZ_eq_iff_samePencilYOrbit` now states the
manuscript's exact parameter-fibre theorem directly.

No genuine mathematical mystery remains inside the proved algebraic
interface.  The only evidence gaps are the four fields of
`PencilClassificationInputs`; they are deliberate formalization boundaries,
not unexplained behaviour.  C570 owns the aggregate declaration-level
manuscript reconciliation after the remaining theorem packages close.

The discovery-track review found no incidental observation: the quotient
factorization, hypothesis boundary, and direct fibre theorem were all
deliverables sought by C566.
