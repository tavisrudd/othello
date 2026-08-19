# C910 — the epilogue gate re-run, and the absent claim rows taken

**Date:** 2026-08-19
**Lane:** `cubic-threefolds`
**Task:** C910 (Lean companion for `papers/cubic-stabilization-epilogue/`)

## What this pass did

Two things. First, it re-ran the complete epilogue gate at the commit where a
concurrent session's Section 5 edits landed, which the previous C910 pass could
not do: that session held uncommitted edits whose claim-map digest was stale, so
the correspondence checker stopped at the first stale row. Second, it took the
absent rows of the claim map that are within the companion's scope, moving six
of the nine absent rows to a recorded coverage strength.

## The gate, re-run in full

At `b991d168d` (the concurrent session's commit, C922, repairing the audit
findings on the C920 manuscript edits), every part of the aggregate gate was run
here rather than taken on report:

| gate stage | command | result |
|---|---|---|
| prose lint | `make lint` | 7 files, check OK |
| correspondence, source only | `make formal-static` | PASS, 134 sources, 274 terminals, 59 claims, 46 machinery, 19 imported sources, 2 evidence bundles |
| deterministic manuscript | `make manuscript warnings` | exit 0, warning free, tracked PDF current |
| Lean library and audit | guarded queue, `CubicStabilizationEpilogue` and `Verification.AxiomAudit` | both built |
| axiom transcript | `make formal-audit AXIOM_LOG=<captured audit stdout>` | PASS over all 274 terminals |

Coverage at that commit was 9 absent, 24 fragmentary, 25 conditional
deductions, 1 complete.

One practical note for anyone repeating this. The guarded queue's per-target
`.log` file is the wrapper's summary, not the elaboration transcript; the
`#print axioms` output that the audit gate consumes is in the run directory's
`<target>.quiet/<run>/<invocation>/stdout.log`. Passing the summary file to
`make formal-audit` fails with a spurious mismatch naming every terminal.

## The absent rows taken

Coverage after this pass is 3 absent, 27 fragmentary, 28 conditional deductions,
1 complete, over 283 reviewer terminals. Every added terminal depends on exactly
`propext`, `Classical.choice`, `Quot.sound`.

### The three separation corollaries, now conditional deductions

`cor:voisin-separation`, `cor:fermat-separation` and `cor:coprime-separation` say
that a cubic threefold is universally `CH₀`-trivial while its product with a
projective line is irrational, for three independent reasons on the cycle side.
All three have the same shape, and
`Applications/UniversalCH0Separation.lean` records that shape once: universal
`CH₀`-triviality of the threefold passes to the product by a supplied
projective-bundle premise, and the product is irrational through the atomic
route's terminal `cubicAtom_oneStepStabilization_not_rational`, which is the
formal counterpart of `thm:every-cubic`. The three corollaries are then three
instantiations differing only in where universal `CH₀`-triviality comes from.

Two of the three carry content that Lean proves rather than assumes.

For the Fermat corollary, the hypothesis of Colliot-Thélène's criterion is
discharged. `Applications/SeparatedVariableCubicForms.lean` defines what it means
for a polynomial to split into pairwise disjoint groups of at most a given number
of variables, and proves that the sum of the cubes of the five variables splits
into singletons, hence into groups of at most three. So the corollary's premise
is the criterion itself, applied to a hypothesis Lean checked.

For the coprime-degree corollary, coprimality is proved. The parametrization
degrees two and three persist on the product by the supplied reading of
Yang–Yu–Zhu's Corollary 3.5, and `Nat.Coprime 2 3` is decided in Lean, so the
universal `CH₀`-triviality of the fourfold comes from the criterion applied to a
pair of degrees whose coprimality is not assumed.

For the Voisin corollary, there are two terminals: the statement for every member
of the family, and its existential form under a supplied nonemptiness assumption
on the parameter space. Voisin's construction of the locus, its nonemptiness and
its codimension bound are the imported inputs; codimension is not represented at
all, since the parameter type carries no dimension.

Three imported-source registry entries were added for these rows — Voisin's
Theorem 4.5 with Corollary 4.4 and Lemma 4.6, Colliot-Thélène's Théorème 2.8,
and Yang–Yu–Zhu's Theorem 3.3 with Corollary 3.5 — each with the conventions
whose violation would invalidate the use. Colliot-Thélène's pinpoint was checked
against the cached arXiv text (arXiv:1607.05673v3): the criterion is announced in
the introduction and stated as Théorème 2.8, not as a numbered Theorem 1.1.

### The two low-degree bulk shifts, now a fragment

`lem:exact-low-degree-shifts` says that shifting the bulk point by a multiple of
the identity class, or by a divisor class, leaves the framed formal monodromy
eigenvalues unchanged. `Quantum/BulkShiftFramedInvariance.lean` proves the
algebra of each clause.

For the identity shift, the string equation makes the shifted connection differ
by the scalar irregular twist, which is single-valued on the original loop disc.
Lean proves the corresponding statement about frames: if the turn — a ring
automorphism of an abstract commutative solution algebra — fixes an invertible
scalar, then multiplying an invertible solution frame by it leaves the monodromy
matrix of that frame unchanged, given that the constants embed injectively.

For the divisor shift, the divisor equation makes the shifted connection the
image of the original under the coefficient substitution on Novikov monomials,
so the shifted framed characteristic polynomial is the image of the original one,
which the package already had. What was missing is the last step, added here: an
injective coefficient substitution preserves the algebraic multiplicity of every
root it fixes, so one fixing the complex numbers preserves the primitive-sixth
multiplicity.

The row is recorded as a fragment, not a conditional deduction, because no
quantum connection, bulk point, Euler field, string or divisor equation, or
Novikov coefficient ring exists in the package: both clauses are about surrogate
objects, and single-valuedness and the comparison of the two monodromy matrices
are hypotheses rather than derived facts.

### The Eckardt rank criterion, now a fragment

`lem:eckardt-rank` says that the tangent hyperplane section at a point of a
smooth cubic threefold is a cone with that point as vertex exactly when the
Hessian of the defining form there has rank at most two.
`Applications/EckardtHessianRank.lean` proves the linear algebra of that
criterion, as an equivalence rather than one implication.

In adapted coordinates the form reads `x₀²L + x₀Q + C` and the Hessian is the
bordered symmetric matrix with zero distinguished entry, the coefficient vector
of `L` as border, and the matrix of `Q` as block. Over a field in which two is
invertible, for a nonzero border and a symmetric block, that matrix has rank at
most two exactly when the block is the symmetrized outer product of the border
with a single vector — the matrix form of `Q` being a multiple of `L`.

Sufficiency is the observation that every value of the associated map lies in the
span of two fixed vectors. Necessity is the coordinate-free version of the
manuscript's argument: if the block carried some vector annihilated by the border
outside the line the border spans, then the images of three explicit vectors
would be independent and the rank would be at least three; the correcting vector
is then the block applied to a vector paired to one with the border, less half of
a diagonal value, which is where invertibility of two enters.

The row stays a fragment: no projective space, cubic form, hypersurface, tangent
hyperplane section, cone, or Eckardt point is constructed, the passage to the
adapted normal form is not carried out, and the lemma's second assertion — that
every smooth cubic threefold in the separated-variable class and in the
coprime-degree family carries such a point — is not formalized.

### The elliptic-product exclusion, now a fragment

`prop:no-elliptic-product` was first left absent here, on the reading that the
lattice description behind it was about to be corrected. That reading was wrong,
and the C921 session established why: the proposition quantifies over an isogeny
from a product of principally polarized abelian varieties with the polarization
pulling back to an odd multiple of the product polarization, so the principal
polarization of the four-dimensional factor is part of the shape being
quantified over, not an assertion about the canonical factor of the intermediate
Jacobian. Nothing in the statement or its proof quotes lattice invariants. The
statement needs no repair, so the row was taken.

`GraphLattices/HeartOrthogonalLines.lean` covers the two steps of the proof that
live entirely in the two-primary coefficient heart, modelled concretely as a
two-dimensional space over the four-element field with the trace-determinant
pairing to the two-element field.

The first is that the pattern of one-dimensional summands is impossible. A line
over the four-element field is totally isotropic, because the determinant of a
vector against itself vanishes and the scalars come out of the determinant. If
the lines spanned by two vectors are orthogonal, then the determinant of those
two vectors is killed by the trace of every multiple of it, and the trace form
of the four-element field over the two-element field is nondegenerate, so that
determinant vanishes and the second vector is a multiple of the first. Two
orthogonal lines therefore coincide and are never complementary.

The second is the parity step behind the last assertion: a subspace over the
four-element field with at most two elements is trivial, since a nonzero one
contains the four multiples of any of its nonzero elements. That is the formal
content of "cyclic, killed by two, and stable under the four-element field,
hence zero".

The row is a fragment. The classification of the isogeny shape is not
formalized: not the passage from an odd-degree isogeny to an orthogonal
decomposition of the heart, not the generator count bounding the dimension of
the summand that carries it, not the realization of the two-factor case by an
axis, and not the final contradiction with the order of the heart. Nothing
registered asserts a polarization on any factor of the intermediate Jacobian or
any lattice invariant of it.

Two manuscript sentences are worth the author's attention here, raised by the
C921 session and not touched in this pass: the sentences in the introduction and
in the envelope section saying that the four-dimensional factor of the second
case may be the Jacobian of an irreducible curve of genus four. Which principal
polarization is meant is a genuine choice among six, corresponding to the six
order-five subgroups of the five-torsion of the elliptic factor, all of them
fixed by the axis stabilizer. No claim-map row leans on either sentence.

## The three rows left absent, and why

- `prop:A5-not-coprime` and `prop:A5-nonseparated` rest on projective equivalence
  over a coarse moduli image and on the registered Eckardt evidence bundle. The
  companion constructs no moduli space and gives the evidence bundle no formal
  semantics, so a Lean row here would restate the computation rather than check
  it.
- `lem:center-maps-monomial` needs a completed monoid ring and its associated
  graded, which the package does not build; the C922 session recorded that
  reasoning in `lean/README.md` in the same pass that added the row.

## Mystery ledger

- **The two obstructions are formally independent, not just informally.** In the
  separation composition the premises of the cycle branch and of the atom branch
  share no hypothesis: universal `CH₀`-triviality enters through its own
  predicate and its own criterion, irrationality through the atom ledger, and the
  only object they share is the variety. The `ej`+`tt` pass settled that this is
  what the theorem type shows and nothing weaker; no shared premise is hiding in
  the ledger. Nothing open.
- **The Eckardt criterion is not special to threefolds.** It is proved for an
  arbitrary finite index type over any field in which two is invertible, so it
  covers cubic hypersurfaces of every dimension, and the separated-variable
  notion is likewise proved for any number of variables over any nontrivial
  commutative ring. This was free. The open part is not the algebra but the
  geometry: nothing here produces the adapted coordinates from a smooth point.
- **Characteristic two is a real obstruction, not a technical hypothesis.** The
  symmetrized outer product has zero diagonal in characteristic two, so the
  necessity direction fails there rather than merely resisting this proof.
  Settled; recorded as a restriction on the coefficient field.
- **A strengthening of the divisor-shift terminal is available and not taken.**
  The terminal assumes the substitution fixes each primitive sixth root, which is
  what "fixes the complex numbers" gives. But an injective field endomorphism of
  the complex numbers permutes the two roots of `x² - x + 1`, and the framed
  multiplicity is the sum of their two multiplicities, so the conclusion survives
  a substitution that merely permutes them. Taking it needs the roots of that
  quadratic identified with the two primitive sixth roots. Left open, with no
  gate depending on it: the manuscript's own hypothesis is the stronger one.
- **Why five variables never appear.** None of the three separation corollaries
  uses the dimension of the ambient projective space; the Fermat row fixes five
  variables only because the manuscript's equation has five. The atom ledger
  carries the dimension condition instead, through `cubicDimension`. No mystery
  remains here, but it is worth knowing that the separation module would accept a
  cubic of another dimension and give a false statement if the atom input were
  supplied wrongly — the dimension guard lives in `CubicAtomOneStepInput`, not in
  these rows.

## Replay

From `papers/cubic-stabilization-epilogue/`:

```text
make lint formal-static
make manuscript warnings
lean/scripts/lean-build-queue.py build CubicStabilizationEpilogue \
  TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Verification.AxiomAudit \
  --lean-root <repository>/papers/cubic-stabilization-epilogue/lean --cores 20-23
make formal-audit AXIOM_LOG=<run directory>/logs/<audit target>.quiet/<run>/<invocation>/stdout.log
```

The last command's argument is the elaboration transcript, not the wrapper
summary of the same name without the `.quiet` path.

## Commits

- `d76daafc6` — the three separation corollaries as conditional deductions.
- `8833c76e2` — the two low-degree bulk shifts covered by their framed invariance
  algebra.
- `d7e38e503` — the rank criterion behind the Eckardt condition.
- `f10ace199` — the two-primary heart steps of the elliptic-product exclusion.
