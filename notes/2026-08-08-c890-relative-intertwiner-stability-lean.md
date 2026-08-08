# C890 — relative intertwiner stability in Lean

**Date:** 2026-08-08

**Lane:** `ame-lu`

**Status:** complete; the exact-base translation is kernel checked, while the
one-state cleaning estimate remains an explicit analytic input

## Verdict

C787's structural claim is now formalized.  Given normalized states `psi` and
`phi`, a unitary product operator `B` that maps the ray of `psi` exactly to the
ray of `phi`, and a product operator `U`, Lean proves that left translation by
`B†` preserves the squared ray defect exactly.  It then transfers any supplied
one-state approximate-symmetry decomposition to a two-state intertwiner
decomposition with the identical threshold and generator-norm coefficient.

The formalization is deliberately conditional at the correct boundary.  It
does **not** prove C833's cleaning radius, the local `8 epsilon` estimate, or
the collective `pi sqrt(q) epsilon` coefficient.  Those analytic results are
still manuscript proofs.  What is kernel checked is that once a one-state
theorem supplies such a threshold and coefficient, an exact base intertwiner
transports them with no loss and no new party-count factor.

## Formal surface

The new module is
`RelativeConicArcs.AMELU.RelativeIntertwinerDecomposition`.  Its public
declarations are:

- `IsRayIntertwiner`, the line-to-line intertwiner predicate;
- `intertwinerDefectSq`, the transition-amplitude form of squared ray defect;
- `rayIntertwiner_eigenvalue`, proving that the scalar of a normalized
  unitary ray intertwiner is unimodular and that the adjoint maps the target
  ray back to the source;
- `intertwinerDefectSq_intertwiner_mul`, the exact defect identity
  `defect(BV; psi -> phi) = defect(V; psi)`;
- `IsRayIntertwiner.mul_symmetry`, the exact-intertwiner torsor composition;
- `IsUnitaryOperator.mul`, closure of system unitarity under multiplication;
- `relative_approximate_decomposition`, the lossless transfer theorem.

The terminal theorem produces an exact unitary product intertwiner `H` and
traceless Hermitian local generators `h_j` with

```
U = H * tensor_j exp(i h_j)
sum_j ||h_j||_F^2 <= coefficient * intertwinerDefectSq(psi, phi, U).
```

Both `coefficient` and the entry `threshold` are fields of the supplied
`ApproximateDecompositionInputs`.  This makes the theorem reusable for C833's
eventual formalization or any later improved one-state estimate without
hard-coding a manuscript constant into an assumption.

## Interface repair

`ApproximateSymmetryDecomposition` previously fixed the conditional
coefficient at `6q/5` and did not expose that its returned exact symmetry is a
product operator.  That was too weak for the relative composition.  Its input
record now carries an arbitrary real `coefficient`, and its conditional
existence field and terminal theorem return `IsProductOperator g` explicitly.
No analytic theorem was strengthened: the module still packages a supplied
decomposition hypothesis and now states its actual algebraic output precisely.

## Gate and trust boundary

The new module is imported by
`RelativeConicArcs.Gates.AMELUTwoUniformRigidity`.  The gate's audit surface
grew from seventeen to twenty-two named quantitative-core declarations.  The
five new audited theorem declarations each report exactly:

```
[propext, Classical.choice, Quot.sound]
```

The extracted gate fact records twenty-two matched terminals, 111 declarations,
no project axioms, and no opaque declarations.  The external trust exports,
portfolio row, graph manifest, verification map, formalization ledger, theorem
map, ownership map, and statement-adequacy map now expose the same conditional
boundary.

The repository-wide trust-spine check is not globally green: it continues to
report the pre-existing missing-fact, unreached-module, and two undeclared
project-axiom findings outside this AME gate.  The scoped gate extraction and
axiom audit used here pass; this report does not relabel the unrelated global
backlog as C890 work.

## Manuscript synchronization

The verification section now lists the exact-base relative reduction as a
kernel-checked algebraic core and says explicitly that the cleaning inputs
remain manuscript proofs.  The dedicated gate count is twenty-two.  A visual
audit also caught and repaired a pre-existing doubled-backslash rendering bug
in the conclusion's `8 epsilon` expression.  Allowing a dedicated float page
keeps the expanded trust table beside Section 6 rather than after the
bibliography.

The resulting manuscript is 37 pages.  The trust table renders cleanly on
page 15 and the corrected conclusion on page 16.

## Validation

- Guarded checking of both touched AME modules passed.
- The required build queue successfully built
  `RelativeConicArcs.AMELU.ApproximateSymmetryDecomposition` and both
  `AMELUTwoUniformRigidity` gate modules.
- The guarded axiom audit passed with the five new terminals using only the
  three standard axioms above.
- The touched Lean sources contain no workflow identifiers, private paths,
  TODOs, or FIXME markers.
- Trust extraction regenerated the AME gate fact and the external exports.
- `make -C papers/ame_lu check` passed warning-free; the tracked PDF is
  312,036 bytes.
- `make -C papers/ame_lu release-check` verified 18 public artifacts at tree
  `9ae1e74ead062363907503869ee682cd8fef9771bc0b149aefa238f081bb85b4`
  and 83 formal artifacts at tree
  `f74c53bf49cf23619609843dd801ccfff0a8a503fe4bbd7852386c0f0713f2de`.
- The immutable export plan and reference audit had zero findings.  The
  standalone mirror passed its warning-free build, public release check, and
  28-file exporter verification.  Its clean unpushed commit is `faf6580`.

Authoritative commits are `5ee60c4a` (Lean source and gate), `372f7a36`
(extracted fact), `2ccb9669` (external trust exports), `d6a38692` (paper and
trust maps), and `77215a55` (release contract).

## EJ + Tao closeout

The cheap decisive abstraction is to parameterize the conditional one-state
decomposition by its threshold and coefficient.  The relative theorem then
contains no numerical AME analysis at all: it is the exact algebra of a
homogeneous space, and future improvements transfer automatically.

The structural question was which part of C787 genuinely needed formal work.
It was not a second stability proof.  It was the exact identity of defect
functions and the closure of the product-intertwiner torsor.  Isolating those
facts prevents a misleading all-or-nothing coverage claim and leaves one
well-defined future target: formalize the C833 analytic cleaning input.

## Mystery ledger

| Question | Resolution | Remaining owner |
|---|---|---|
| Does exact-base translation change the defect or coefficient? | No; Lean proves exact equality and lossless transfer. | none |
| Is the resulting exact intertwiner still a product unitary? | Yes; productness and unitarity are explicit terminal conclusions. | none |
| Are `8 epsilon`, `R_clean`, and `pi sqrt(q) epsilon` kernel checked now? | No; they remain the supplied C833 manuscript input. | future analytic formalization |
| Did the old `6q/5` conditional interface prove that numerical value? | No; it merely assumed it.  The interface now names an arbitrary supplied coefficient. | none |
| Does the broader relconic trust spine pass globally? | No; unrelated legacy findings remain, while the scoped AME gate and fact match. | owning lanes/build-system backlog |

## Vibe check

This is the right-sized closure: the homogeneous-space argument is now fully
kernel checked, and the manuscript's hard analytic constants are neither
smuggled in as formal facts nor obscured.  The formal boundary is sharper than
before and ready for a later C833 cleaning formalization.
