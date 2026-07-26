# C636 quadratic-hull avoidance formalization

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** COMPLETE AT THE FINITE LINEAR-ALGEBRA BOUNDARY.

## Result

The existing module `RelativeConicArcs.EvaluationDichotomy` already
kernel-checks the exact Hilbert/Veronese core used by C628:

- at most `q` nonzero evaluation functionals have a common nonzero avoidance
  vector;
- the `q+1` plane cover is sharp;
- the distinct-hyperplane complement has the lower bound
  \[
  (q-1)q^{r-2}(q+1-m);
  \]
- `evaluation_avoidance_iff` expresses the kernel/forced-hit dichotomy; and
- `feature_evaluation_avoidance_iff` expresses the same theorem through the
  span of arbitrary feature vectors, hence through every Veronese degree.

The new module `RelativeConicArcs.GoodFormAvoidance` formalizes the additional
`ej`/`dof` count.  Its public terminals are:

```text
RelativeConicArcs.exists_outside_hyperplanes_not_mem_of_cubic_bound
RelativeConicArcs.exists_ne_zero_apply_ne_zero_not_mem_of_cubic_bound
```

Let `W` have dimension `r>=2` over a field of cardinality `q>=5`.  For a
nonempty family of at most `q-3` proper hyperplanes and an exceptional finset
of cardinality at most `3*q^(r-1)`, Lean proves that some vector lies outside
every hyperplane and outside the exceptional set.  In functional form the
vector is nonzero, avoids the exceptional set, and evaluates nontrivially
under every selected functional.

The proof imports the exact distinct-hyperplane count and kernel-dimension
theorem from `EvaluationDichotomy`.  The only new arithmetic step is
\[
 3q^{r-1}
 <
 (q-1)q^{r-2}(q+1-m)
\]
for `q>=5`, `m<=q-3`, and `r>=2`.  Mapping the selected functionals to their
kernel finset automatically quotients duplicate hyperplanes.

## Formal boundary

The theorem supplies the finite counting implication needed after a cubic
zero bound has been established.  It does not identify the exceptional
finset with the zero locus of the ternary-conic discriminant, nor does it
formalize the geometric equivalence between a nonsingular quadratic through
`U` and the absence of a collinear triple in `U`.

Those statements require a new bridge between:

1. the coefficient space of ternary quadratic forms and its discriminant
   cubic;
2. restriction of that cubic to the subspace `I(U)_2`; and
3. the existing orbit-based structure
   `RelativeConicArcs.Conic.NonsingularConic`.

The current conic API contains no such coefficient/discriminant bridge.
Rather than introduce an axiom or silently identify the two models, the Lean
theorem takes the exact cardinal bound on the exceptional finset as a
hypothesis.  No manuscript claim or proof-audit boundary was changed.

## Verification

Direct source elaboration:

```bash
cd lean
scripts/guarded-lean RelativeConicArcs/GoodFormAvoidance.lean
```

The final run completed without a Lean warning or error.

Dedicated gate:

```bash
cd lean
scripts/lean-build-queue.py run RelativeConicArcs.Gates.QuadraticHull \
  --profile single --threads 1 --cores 20-23
```

Run directory:

```text
/home/tavis/.cache/othello-lean-build/run-20260726-024010-4def241d
```

The target passed in `5.78s` with maximum resident set size `1,257,836 KiB`.
The queue then passed its trace-only aggregate gate and exact-target
`lake build --no-build` replay.

The dedicated gate
`RelativeConicArcs.Gates.QuadraticHull` prints the axioms of both public
terminals.  Each depends on exactly:

```text
propext
Classical.choice
Quot.sound
```

There is no `sorry`, project axiom, native decision, generated certificate, or
external computation in the new dependency.

## `ej` + `tt` closeout

The image-of-kernels formulation is stronger than a direct indexed union:
repeated evaluation kernels cost nothing in the count.  This is the correct
formal analogue of counting distinct selected projective hyperplanes.

The highest-value further formalization is not more cardinal arithmetic.  It
is the missing coefficient-space bridge: define the universal ternary
quadratic, prove that its discriminant is a nonzero cubic after restriction
whenever the kernel contains one nonsingular conic, apply Mathlib's
Schwartz--Zippel theorem, and identify discriminant nonvanishing with the
orbit model `Conic.NonsingularConic`.  This changes the conic API and was not
assumed as a cheap extension.

## Mystery ledger

- **Settled:** the exact `q-3` arithmetic margin over a cubic-size exceptional
  set is kernel-checked.
- **Settled:** duplicate evaluation kernels are quotient-safe through the
  kernel image finset.
- **Settled:** both terminals use only the standard Lean axioms listed above.
- **Open:** the conic discriminant zero count has not been connected to
  `I(U)_2` in Lean.  The missing evidence is an explicit polynomial
  restriction theorem and a nonsingular-conic model equivalence.
- **Open:** the no-collinear-triple characterization remains analytic.  It
  should be formalized only with the same coefficient/projective bridge, not
  as a detached incidence axiom.
