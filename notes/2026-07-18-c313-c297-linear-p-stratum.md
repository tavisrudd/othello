# C313: exact arithmetic of the C297 linear-p stratum

**Lane**: `relconic`

**Status:** queued; phase A is parallel-ready, final seed-legality clause consumes C312's template.

## Objective

Resolve the possible linear repair-pair-sum stratum isolated by C297. Determine exactly when it
exists over the odd tower, parameterize its projective/semilinear classes, and decide whether its
members can pass the seed--repair arc gate. This is algebraic classification, not coefficient
mining.

## Required startup reading

Read:

1. [`2026-07-18-post-c297-theory-program.md`](2026-07-18-post-c297-theory-program.md);
2. the subsection “A second omitted stratum” and the quotient/gauge sections of
   [`2026-07-18-c297-c210-normal-form-moduli.md`](2026-07-18-c297-c210-normal-form-moduli.md);
3. C312's determinant lemma once committed; phase A below does not wait for it.

No C210 census or `q=64` classification is an input.

## Exact phase-A system

After C297's projective translation places the pole at `s=0`, the stratum is governed by

    U_2=c,
    U_1=d*L*(z+omega),
    U_0=d^2*z^2,

with `c,L in F^*`, and

    1+L*(z^2+z+1)+c=0,
    Tr((c+L)/L^2)=1,
    Tr(c*(1+L)/L^2)=1.

Eliminate `c` first. Reduce both trace classes using characteristic-two identities and determine
their dependence on the odd scalar degree. Separate algebraic solutions from open conditions
`c*L*d!=0` and from any pole/parameterization degeneration.

## Required theorem package

1. Necessary and sufficient existence conditions for `(c,L,z)` over every odd-degree `F`.
2. A rational or Artin--Schreier parametrization of every solution component, or a proof that no
   component exists.
3. Exact behavior under projective scaling/translation, repair reversal, relative conjugation,
   and Frobenius.
4. Reconstruction of the corresponding repair coefficients `(A_i,B_i,C_i)` with all internal and
   cross-repair legality hypotheses checked.
5. After C312 supplies the general determinant template, a seed--repair legality classification
   for the linear-p family.
6. A consumer-ready statement saying whether the stratum contributes components to C315/C316.

## Proof strategy

- Work in the quotient ring of trace classes modulo `g^2+g`; prove every reduction.
- Use the Artin--Schreier exact sequence and the fact that the scalar degree is odd, rather than
  testing degrees individually.
- Treat `z` as a parameter only after verifying whether it lies in `F` or represents an `E/F`
  direction in C297's derivation.
- Prove equivalence under the exact C297 actions. Frobenius is semilinear, not projective.
- If the solution locus is a curve, identify its constant field and genus before invoking rational
  point existence.

## Non-goals and safety

- No finite-field sweep and no inference from a small-field sample.
- No coverage or completeness theorem before seed legality is known.
- Do not silently fold the linear-p stratum into the constant-p coordinates.
- Do not reopen C210's failed linear-p branch: C297 explains why the larger parameter `c` changes
  its trace class.

## First productive session

1. Substitute `c=1+L*(z^2+z+1)` into both trace conditions.
2. Reduce their sum and difference to the smallest set of independent trace equations.
3. Classify the zero/pole cases of `L`, `c`, and `1+L` before division.
4. Determine the geometric dimension of the remaining solution scheme.
5. Write the coefficient reconstruction map back to the two repair graphs.

## Exit gate

C313 closes with a uniform theorem over the odd tower and an exact seed-legality verdict. If the
seed clause is temporarily blocked on C312, phase A may land as a coherent theorem, but the task
remains live with that single explicit gate.
