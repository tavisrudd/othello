# Node classification away from characteristic 2, 3, 5 (Paper I Lean development)

**Lane**: `clebsch` — Paper I Lean development, task C929.

Goal: replace the `[CharZero K]` hypothesis carried through the Golden-cubic node
classification by the true hypothesis — 2, 3, and 5 invertible, i.e. `(30 : K) ≠ 0` for a
field — and instantiate the result at `ZMod 11`, where the golden root `t = 8` satisfies
`t^2 = t + 1`.

## Where the characteristic actually enters

Three separate places, and only three:

1. **Denominators in the elimination certificates.** Every ideal-membership certificate in
   `RelativeConicArcs/GoldenCubicNodeElimination.lean` is a linear combination of the five
   gradient quadrics with *rational* polynomial coefficients. The identity itself is
   integral: clearing denominators by a single integer `N` gives a polynomial identity valid
   over any commutative ring. The only characteristic input is dividing the conclusion back
   by `N`. Every such `N` factors as `2^a * 3^b * 5^c`, which is why 2, 3, 5 are the excluded
   primes and nothing else is.
2. **`Mathlib`'s `ring` normalizer needs `CharZero` to invert numerals.** This is the reason
   the file was written with `[CharZero K]` in the first place: `linear_combination` with a
   coefficient like `(1 / 60 : K)` normalizes the numeral inverse only when a `CharZero`
   instance is found (`Mathlib/Tactic/Ring/Basic.lean`, `Ring.RatCoeff.inv`, which takes
   `czα : Option Q(CharZero $α)`); without it the inverse is treated as an atom and the
   certificate fails to check. Scaling the certificates to integer coefficients removes this
   dependence entirely.
3. **Distinctness of the three roots 1, -5, -1/5 of the eliminant.** The chart case analysis
   in `RelativeConicArcs/GoldenCubicNodes.lean` factors `(x3 - 1)(x3 + 5)(5 x3 + 1)` and
   `(x2 - 1)(x2 + 5)`, and the branch for the root `-1/5` divides by 5.

## What changed, file by file

### `lean/scripts/generate_golden_cubic_elimination.py` (generator)

`RelativeConicArcs/GoldenCubicNodeElimination.lean` is generated, so the change was made in
the generator and the file regenerated; hand-editing the output would have left the
generator emitting the old `[CharZero K]` form. This is the one file touched outside the
task's nominal edit scope, and the reason is exactly that: the generated Lean file cannot be
changed consistently any other way.

New behaviour: each certificate's multiplier vector is cleared by its common denominator
`N` before being printed, so every printed coefficient is an integer. The emitted proof is

```
have hscale : (N : K) ≠ 0 := ...          -- from (30 : K) ≠ 0
have key : (N : K) * (target) = 0 := by
  simp [chartGradient, GoldenCubicNodesBase.gradient] at h0 h1 h2 h3 h4
  linear_combination <integer-coefficient combination>
exact (mul_eq_zero.mp key).resolve_left hscale
```

with a new private helper `two_three_five_ne_zero : (30 : K) ≠ 0 → (2 : K) ≠ 0 ∧ (3 : K) ≠ 0
∧ (5 : K) ≠ 0` and the clearing factor written as `2 ^ a * 3 ^ b * 5 ^ c`. When `N = 1` the
theorem is emitted over `[CommRing K]` with no hypothesis on the base ring at all.

### Which certificates need a characteristic hypothesis, and for what

The clearing factor is the entire story. Per generated theorem:

| theorem | clearing factor | factorization | primes consumed |
|---|---|---|---|
| `x3_factor`                          | 360   | 2^3·3^2·5   | 2, 3, 5 |
| `x2_factor_of_x3_eq_one`             | 720   | 2^4·3^2·5   | 2, 3, 5 |
| `x1_factor_of_x3_x2_eq_one`          | 1     | —           | none    |
| `x0_factor_of_x3_x2_x1_eq_one`       | 3     | 3           | 3       |
| `x1_eq_one_of_x3_one_x2_neg_five`    | 72    | 2^3·3^2     | 2, 3    |
| `x0_eq_one_of_x3_one_x2_neg_five`    | 72    | 2^3·3^2     | 2, 3    |
| `x2_eq_one_of_x3_neg_five`           | 34560 | 2^8·3^3·5   | 2, 3, 5 |
| `x1_eq_one_of_x3_neg_five`           | 34560 | 2^8·3^3·5   | 2, 3, 5 |
| `x0_eq_one_of_x3_neg_five`           | 4320  | 2^5·3^3·5   | 2, 3, 5 |
| `five_x2_add_one_of_five_x3_add_one` | 6912  | 2^8·3^3     | 2, 3    |
| `five_x1_add_one_of_five_x3_add_one` | 6912  | 2^8·3^3     | 2, 3    |
| `five_x0_add_one_of_five_x3_add_one` | 864   | 2^5·3^3     | 2, 3    |
| `x0_eq_one_of_x3_x2_one_x1_neg_five` | 72    | 2^3·3^2     | 2, 3    |
| `boundary_x0_cube` … `boundary_x3_cube` | 225 | 3^2·5^2    | 3, 5    |

No prime beyond 2, 3, 5 occurs in any denominator — the generator now asserts this and
fails if it ever stops holding. `x1_factor_of_x3_x2_eq_one` is genuinely
characteristic-free: its certificate has integer coefficients, so it is now stated over
`[CommRing K]` with no `h30`. All the others keep `[Field K] (h30 : (30 : K) ≠ 0)`, uniform
rather than per-theorem minimal, since a field statement mentioning only some of the three
primes would be an awkward API for a single case analysis that needs all three anyway.

### `RelativeConicArcs/GoldenCubicNodes.lean`

`[CharZero K]` replaced by `(h30 : (30 : K) ≠ 0)` on `chart_classification`,
`gradient_eq_zero_iff_smul_centeredNode`, and
`nonzero_gradient_zero_iff_projective_centeredNode`, threading `h30` into every elimination
call. Two substantive proof changes beyond threading:

- The branch at the root `-1/5` used `field_simp` to solve `x0 = -1 / 5` from
  `5 * x0 + 1 = 0`; `field_simp` needed `(5 : K) ≠ 0`, which it no longer gets from
  `norm_num`. Replaced by `rw [eq_div_iff hfive]; linear_combination hx0`, with
  `hfive : (5 : K) ≠ 0` derived from `h30` at the top of the proof.
- The closing `fin_cases j <;> simp [...]` in that same branch has to check
  `-(1 : K) / 5 * -5 = 1` in the coordinate where the node vector has entry `-5`; a trailing
  `field_simp` discharges it from `hfive`.

`gradient_smul` and `smul_centeredNode_injective` were untouched: the first was already
stated over a commutative ring, and the second is a statement about `ℚ` proved by
`nlinarith`, outside this chain.

### `RelativeConicArcs/SupportOrientationNodes.lean`

`singularPoints_crossGoldenDeterminant_eq_axisClasses` and
`supportCubic_singularLocus_eq_frame` take `(h30 : (30 : K) ≠ 0)` in place of `[CharZero K]`;
both are thin wrappers, so only the hypothesis and the module and theorem docstrings
changed. `derivative_crossGoldenDeterminantLine_eval` was already stated over an arbitrary
commutative ring and needed nothing.

`supportCubic_framePoints_ordinaryNodes` **keeps** `[CharZero K]`. Its second conjunct is
`det_chartHessian_chartNode_ne_zero` from `RelativeConicArcs/GoldenCubicNodeHessians.lean`,
which computes the dehomogenized Hessian determinant as `1296 / 5` at the node whose
exceptional coordinate is the chart denominator and `6480` at the other five. Those numbers
are `2^4·3^4/5` and `2^4·3^4·5`, so they are nonzero under exactly the same `(30 : K) ≠ 0`
hypothesis — but that module is outside this task's edit scope, so the general statement was
left alone and its docstring now says where the restriction comes from.

New `ZMod 11` declarations, all in this module:

- `golden_root_zmod_eleven : (8 : ZMod 11) ^ 2 = 8 + 1`, by `decide`.
- `thirty_ne_zero_zmod_eleven : (30 : ZMod 11) ≠ 0`, by `decide` (`30 = 8` there).
- `singularPoints_crossGoldenDeterminant_eq_axisClasses_zmod_eleven` — the node
  classification in characteristic eleven at the golden root `t = 8`. This is the acceptance
  test: the characteristic-zero form of the theorem could not state it.
- `supportCubic_singularLocus_eq_frame_zmod_eleven` — the same for the gradient cone.
- `supportCubic_framePoints_ordinaryNodes_zmod_eleven` — rank four plus nonvanishing Hessian
  determinant in characteristic eleven, the determinant evaluated by kernel reduction of the
  explicit four-by-four expansion rather than through the characteristic-zero Hessian lemma.

A `Fact (Nat.Prime 11)` instance is declared in the module so that `ZMod 11` is a field.

## The six points in characteristic eleven

The classification is stated as "`x` is a nonzero multiple of some `centeredNode i`", so in
`ZMod 11` the six projective classes are `[1:1:1:1:1]` (from `i = 5`, where the omitted
sixth coordinate carries the exceptional entry) and the five classes with a single `6` among
otherwise equal coordinates, since `-5 = 6` there. Normalizing the class with `6` in the
leading coordinate by multiplying by `6⁻¹ = 2` gives `[1:2:2:2:2]`, so the six normalized
representatives are exactly the ones expected: `(1,1,1,1,1)`, `(1,1,1,1,6)`, `(1,1,1,6,1)`,
`(1,1,6,1,1)`, `(1,6,1,1,1)`, `(1,2,2,2,2)`.

## Two proof-engineering notes worth keeping

- `decide` cannot evaluate `ZMod 11` division. `ZMod.inv` goes through `Nat.gcdA`, which is
  defined by well-founded recursion and does not reduce in the kernel, so a `decide` on any
  expression containing `/` or `⁻¹` in `ZMod 11` fails. The fix used in
  `supportCubic_framePoints_ordinaryNodes_zmod_eleven` is to supply
  `(-5 : ZMod 11)⁻¹ = 2` as a rewrite (proved by `inv_eq_of_mul_eq_one_right (by decide)`,
  which only needs multiplication), after which the whole determinant is division-free and
  `decide` evaluates it.
- The four-by-four determinant is taken through the explicit expansion
  `GoldenMatchingJacobian.detFour` and `detFour_eq_det`, not through `Matrix.det` directly;
  `Matrix.det` sums over `Equiv.Perm (Fin 4)` and does not reduce usefully in the kernel.

## Paper I manuscript drift — no manuscript edit made

`papers/clebsch-rigidity/clebsch_rigidity.tex` says "characteristic zero" about the Lean
classification in three places (near lines 1696, 1740, and 1854 of the current source: the
verification-section sentence, the discussion sentence "the classification of singular
points over any field of characteristic zero containing such a root", and the theorem-listing
sentence "over any field of characteristic zero containing such a root"). Each now
understates what Lean proves: the classification holds over any field in which `30` is
nonzero. No manuscript file was touched; deciding the replacement sentence is the author's
call. The natural replacement phrase is "over any field in which `30` is invertible —
equivalently of characteristic other than `2`, `3`, `5` — containing such a root".

## Out-of-scope items observed, not acted on

- `RelativeConicArcs/GoldenCubicNodeHessians.lean` still carries `[CharZero K]` on
  `centeredNode_four_ne_zero`, `det_chartHessian_chartNode`, and
  `det_chartHessian_chartNode_ne_zero`. All three generalize to `(30 : K) ≠ 0` by the same
  argument — the determinants are `1296 / 5` and `6480` — and doing so would let
  `supportCubic_framePoints_ordinaryNodes` drop `[CharZero K]` too, making the whole
  ordinary-node story uniform instead of splitting into a general characteristic-zero
  statement plus a separate `ZMod 11` computation. This is the obvious successor task.
- `RelativeConicArcs/Gates/GoldenCubicNodes.lean` opens with "This gate audits the exact
  characteristic-zero formalization of the centered Golden triangle cubic", which no longer
  describes what it audits. Gate files were out of scope, so it was left alone; it needs one
  sentence changed.
- `RelativeConicArcs/SupportOrientationNodes.lean` line 217 carries two pre-existing
  `unusedSimpArgs` linter warnings (`Fin.sum_univ_succ` and `Polynomial.derivative_pow` in
  the `derivative_crossGoldenDeterminantLine_eval` proof). They predate this change and were
  left alone rather than perturbing a proof this task did not need to touch.
- A concurrent session is elaborating
  `papers/cubic-stabilization-m1/lean/…/SixPointDuadFactorization.lean` through
  `guarded-lean`; foreign work, not touched.

## Validation

Regeneration of the elimination module:

```
python3 lean/scripts/generate_golden_cubic_elimination.py
```

(`--check` on the same script re-verifies that the tracked file is exactly what the
generator produces.)

Single-file elaborations during development, through the guarded entry point:

```
lean/scripts/guarded-lean RelativeConicArcs/GoldenCubicNodeElimination.lean   # exit 0
lean/scripts/guarded-lean RelativeConicArcs/GoldenCubicNodes.lean            # exit 0
lean/scripts/guarded-lean RelativeConicArcs/SupportOrientationNodes.lean     # exit 0
```

Gate build of the final source, through the build queue:

```
lean/scripts/lean-build-queue.py build \
  RelativeConicArcs.Gates.GoldenCubicNodes RelativeConicArcs.Gates.ClebschRigidityTrust \
  --cores 20-23
```

Result (run `20260820-202321-46526754`):

```
state:   success
  skipped-current  RelativeConicArcs.Gates.GoldenCubicNodes
  cache-restored   <mathlib cache get>  0:07.55 wall, 451188 kB peak
  built            RelativeConicArcs.Gates.ClebschRigidityTrust  10:11.67 wall, 9598848 kB peak
  gate-passed      <aggregate>
```

`RelativeConicArcs.Gates.GoldenCubicNodes` was built green in the immediately preceding run
of the same command and was trace-current here; that earlier run's aggregate failed only
because a docstring in `SupportOrientationNodes.lean` was edited while it was building, which
is the run recorded above being redone.

### Axiom audit

The build log carries 213 `depends on axioms` lines across the two gates. Searching that log
for `sorryAx`, `native_decide`, `ofReduceBool`, and `trustCompiler` returns nothing. Every
declaration in this change reports the same three-axiom base:

```
'RelativeConicArcs.SupportOrientationNodes.singularPoints_crossGoldenDeterminant_eq_axisClasses'
  depends on axioms: [propext, Classical.choice, Quot.sound]
'RelativeConicArcs.SupportOrientationNodes.supportCubic_singularLocus_eq_frame'
  depends on axioms: [propext, Classical.choice, Quot.sound]
'RelativeConicArcs.SupportOrientationNodes.supportCubic_framePoints_ordinaryNodes'
  depends on axioms: [propext, Classical.choice, Quot.sound]
'RelativeConicArcs.SupportOrientationNodes.golden_root_zmod_eleven'
  depends on axioms: [propext, Classical.choice, Quot.sound]
'RelativeConicArcs.SupportOrientationNodes.thirty_ne_zero_zmod_eleven'
  depends on axioms: [propext, Classical.choice, Quot.sound]
'RelativeConicArcs.SupportOrientationNodes.singularPoints_crossGoldenDeterminant_eq_axisClasses_zmod_eleven'
  depends on axioms: [propext, Classical.choice, Quot.sound]
'RelativeConicArcs.SupportOrientationNodes.supportCubic_singularLocus_eq_frame_zmod_eleven'
  depends on axioms: [propext, Classical.choice, Quot.sound]
'RelativeConicArcs.SupportOrientationNodes.supportCubic_framePoints_ordinaryNodes_zmod_eleven'
  depends on axioms: [propext, Classical.choice, Quot.sound]
```

The `ZMod 11` statements are decided by kernel reduction (`decide`), not by native
evaluation, so no compiled-evaluation axiom enters.

## Status

Complete.
