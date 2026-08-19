# C910 — the normalized Sylvester gauge, formalized

**Date:** 2026-08-19 · **Lane:** `cubic-threefolds` · **Task:** C910

## What this pass changes

Two places in the epilogue invoke the same mechanism and neither had formal
content for it. The small-even cubic block reduction
(`prop:cubic-block-data`) asserts that a constant change of basis followed by *a
unique normalized block-off-diagonal gauge* puts the horizontal system into three
blocks; the gluing of a separated spectral factor (`lem:factor-glue`) fixes the
splitting by imposing the same normalization and concludes that *a normalized
splitting, if chosen, is unique*. Both proofs justify this by the same sentence:
at each order the unknown off-diagonal coefficient is determined by a Sylvester
operator `X ↦ U_i X - X U_j`, invertible because the scalar parts of `U_i` and
`U_j` differ by a unit and the rest is nilpotent.

Before this pass the Lean package verified the two *exhibited* gauge
coefficients of the cubic system by direct computation and said so in the claim
map: the row's recorded limitation was that Lean "verifies the supplied gauge
coefficients rather than proving existence and uniqueness of the normalized gauge
by the Sylvester recursion." The gluing row had no formal content for the
normalization at all. This pass proves the mechanism and connects it to both
places.

## What is proved

Four new modules, all under
`papers/cubic-stabilization-epilogue/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/`.

**`Quantum/SylvesterOperator.lean` — the operator is invertible.** Over a
commutative ring, left multiplication by a square matrix and right
multiplication by another are commuting endomorphisms of the rectangular
matrices, each nilpotent when its matrix is. Writing `U = λ + N` and
`V = μ + M`, the Sylvester operator `X ↦ U X - X V` is the sum of the scalar
`λ - μ` with a nilpotent endomorphism, so it is a unit as soon as `λ - μ` is:
the equation `U X - X V = Y` then has exactly one solution for every `Y`. The
statement is over a commutative ring, not a field, and for rectangular blocks.

**`Quantum/BlockSylvesterSolvability.lean` — the block form.** A splitting of
the coordinates is a labelling; a matrix is block diagonal when it vanishes off
the labelled blocks and block off-diagonal when it vanishes on them. For a
block-diagonal leading operator `U` whose blocks have separated spectra — the
scalars attached to distinct labels differ by units, and `U` differs from the
diagonal matrix of those scalars by a nilpotent matrix — every block
off-diagonal `Y` is the commutator of `U` with exactly one block off-diagonal
`X`.

The proof avoids restricting the adjoint operator to a submodule. It extends it
to `Ψ = ad U ∘ P + Q` on all matrices, `P` and `Q` being the two projections;
because `ad U` preserves both parts, invertibility of `Ψ` is exactly unique
solvability on the block off-diagonal part. `Ψ` splits as `ad D ∘ P + Q`, whose
inverse multiplies each off-diagonal entry by the inverse of the difference of
the two scalars, plus the nilpotent `ad (U - D) ∘ P`; the two commute because
the diagonal matrix of label scalars commutes with every block-diagonal matrix.

**`Quantum/NormalizedSylvesterGauge.lean` — the gauge exists and is unique.**
The system `z² ∂_z S = M(z) S` is the family of coefficients of `M`; a gauge acts
by `S = A(z) S̃`, and the transformed system satisfies the inverse-free identity

```
A(z) * M̃(z) + z ^ 2 * A'(z) = M(z) * A(z),
```

recorded coefficient by coefficient. The gauge is normalized when `A₀ = 1` and
every positive coefficient is block off-diagonal; the transformed system is
reduced when every coefficient is block diagonal. If the leading coefficient of
the system is block diagonal with separated blocks, a normalized gauge reducing
the system exists, and any two normalized gauges agree at every order, as do
their reduced systems.

At order `n ≥ 1` the identity is `M̃ₙ + (Aₙ M₀ - M₀ Aₙ) = Rₙ` with a residual
built from strictly earlier data; its block-diagonal part is `M̃ₙ` and its block
off-diagonal part determines `Aₙ` through the block Sylvester equation.
Uniqueness is strong induction on the order through that single-order statement;
existence is a recursion on the prefix of coefficients already determined, with
the residual proved to depend only on strictly earlier orders.

**`Quantum/CubicSeparatedBlockGauge.lean` — the cubic instance.** The separated
small even system is the separated Euler matrix at order zero and the separated
grading matrix at order one. Partitioning the four coordinates as the two simple
Euler eigenvalues and the rank-two zero block, Lean proves the separated Euler
matrix is block diagonal for that partition, that its three eigenvalues
`6r, -6r, 0` have unit pairwise differences for `r ≠ 0`, and that it differs from
their diagonal matrix by a square-zero matrix. The general theorem therefore
applies: the separated cubic system has a normalized gauge, unique at every
order. Moreover, for *every* normalized gauge of that system the first two gauge
coefficients are the two matrices the block reduction exhibits and the first two
coefficients of the reduced system are the exhibited block-diagonal ones, whose
rank-two blocks are the displayed `D₀` and `E₀`. The exhibited data are
therefore not one admissible choice among many: they are the coefficients of the
normalized gauge.

## Coefficient ring, not coefficient field

The whole development is over a commutative ring, with the separation stated as
invertibility of a difference rather than distinctness of eigenvalues. This is
what the manuscript's integrality remark needs: the recursion never inverts the
loop coordinate and never leaves the coefficient ring, so the gauge and the
reduced system have coefficients in the ring the system came with — the source
of the manuscript's sentence that the gauge and its inverse use only integral
powers of `z`. Nothing in the argument needs `2` to be invertible either, unlike
the rank-two rigidity argument next to it.

## Manuscript-side integration

Six reviewer terminals were added to `PaperInterface` and audited:

- `sylvesterEquation_unique_solution_of_separated_spectra`
- `blockSylvesterEquation_unique_blockOffDiagonal_solution`
- `exists_normalizedBlockGauge_of_separated_blocks`
- `normalizedBlockGauge_unique_of_separated_blocks`
- `cubicSmallEven_normalizedGauge_exists_and_unique`
- `cubicSmallEven_normalizedGauge_coefficients`

The first four are registered on `lem:factor-glue`, whose recorded formal content
was previously only the invariance of the residue discriminant under a
block-diagonal change of frame; the last two on `prop:cubic-block-data`. Both
rows stay `fragment`: no `F`-bundle, spectral cover, connection, or analytic
splitting is constructed, and for the cubic row the identification of the two
displayed matrices with the small even quantum connection remains the imported
datum. What changed is the recorded limitation. The cubic row no longer says
that existence and uniqueness of the normalized gauge are unproved, and says
instead that the reduction is carried only to the second order, the order the
residue needs. The gluing row now records the algebra of its uniqueness argument
as proved, with the analytic splittings and the overlaps still imported.

## Validation

- Each of the four modules elaborates through the guarded single-file entry
  point with no errors and no warnings, and each builds through the guarded
  queue.
- The reviewer interface and the axiom audit build; the axiom log records all
  274 reviewer terminals, and each of the six new ones depends on exactly
  `propext`, `Classical.choice`, `Quot.sound`.
- The package's source-only correspondence check could not be run to completion:
  a concurrent session holds uncommitted edits to the statement of
  `lem:ruled-degeneracy-dichotomy` in Section 5 whose claim-map digest it has not
  yet refreshed, and the checker stops at the first stale digest. This task's own
  additions were verified instead by running the checker's own functions over
  every row: the terminal partition is exact at 274 with no duplicate and no
  unregistered terminal, every terminal has an expected-axiom row and every
  expected-axiom row a terminal, the manuscript annotations of
  `prop:cubic-block-data`, `lem:factor-glue` and `prop:rank2-rigidity` agree with
  the claim map, and those three rows' statement and terminal digests are
  current. The only stale row is the concurrent session's.
- The concurrent session's hunks in `lean/README.md` and
  `lean/verification/claims.json` were left unstaged; only this task's hunks were
  committed.

## Mystery ledger

- **Uniqueness needs less than existence.** Existence of the normalized gauge
  needs the Sylvester operator to be invertible, hence unit differences of the
  block scalars; uniqueness needs only injectivity, which holds whenever the
  differences are regular elements. The `ej`+`tt` pass settled that this costs
  nothing here: both manuscript uses are over a field, where a nonzero difference
  is a unit, so the weaker hypothesis would buy no case. Left as recorded, not as
  an open gap.
- **Characteristic two.** The gauge argument needs no inverse of `2`, while the
  rank-two rigidity argument beside it does, at the step where a trace-free
  matrix commuting with the leading operator is identified as its multiple.
  Settled as understood, not a defect: the two arguments use different
  mechanisms, and the manuscript works in characteristic zero throughout.
- **Higher coefficients of the cubic gauge.** The unique normalized gauge of the
  separated cubic system exists at every order, but only its first two
  coefficients are identified with exhibited matrices, because only those are
  needed for the residue. Computing further coefficients is possible and is not
  required by any manuscript statement; no successor task is allocated.
- **Formal versus analytic uniqueness.** The uniqueness proved is that of formal
  coefficient families. The manuscript's gluing compares analytic splittings
  supplied by an imported source and then argues that the normalization pins them
  down. Bridging the two needs the analytic input to be formalized, which is the
  standing boundary of this row and is recorded in its limitations. No genuine
  mystery remains beyond that boundary.

New modules and changed files, all under
`papers/cubic-stabilization-epilogue/`:

* `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/Quantum/SylvesterOperator.lean`
* `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/Quantum/BlockSylvesterSolvability.lean`
* `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/Quantum/NormalizedSylvesterGauge.lean`
* `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/Quantum/CubicSeparatedBlockGauge.lean`
* `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/PaperInterface.lean`
* `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/Verification/AxiomAudit.lean`
* `lean/verification/claims.json`, `lean/verification/expected_axioms.txt`
* `lean/lakefile.toml`, `lean/README.md`, `verification/README.md`
* `sections/04-atomic-one-step.tex`
