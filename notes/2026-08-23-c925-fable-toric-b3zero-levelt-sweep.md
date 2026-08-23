# Toric Fano threefolds: Jordan structure of c1* and Levelt exponent classes

**Lane**: `cubic-threefolds`
**Task**: C925
**Date**: 2026-08-23

## Verdict

For all 18 smooth toric Fano threefolds the small quantum multiplication operator `c1 *`
on `H^even`, evaluated at the canonical small point (every Novikov variable set to 1), is
**diagonalizable**. There is no nontrivial Jordan block anywhere in the family, hence no
Levelt exponent class to compute and in particular **no marked block of class {1/6, 5/6}**
(delta-sharp 4/9). Stronger: in all 18 cases the whole algebra `QH^*(X)|_{q=1}` is etale
(its trace form is nondegenerate), so it is a product of fields and every element of it —
not just `c1` — acts semisimply.

## Method

**Fans.** The 18 fans are not taken from a table; they are enumerated from scratch. A
smooth Fano threefold's fan is a smooth complete simplicial fan in which every maximal cone
is the cone over a facet of the convex hull of the rays. Fixing `cone(e1,e2,e3)` as one
maximal cone (legitimate up to `GL(3,Z)`), the fan is completed one open wall at a time:
across a wall of `cone(u,v,w)` smoothness of both cones forces the new generator to be
`x = -u + a v + b w`, and strict convexity of the anticanonical polytope forces `a + b <= 1`.
Casagrande's bound (a smooth Fano `d`-polytope has at most `3d` vertices, `3d - 1` for odd
`d`) caps the number of rays at 8. Completed fans are re-verified against the facet
condition and then reduced modulo `GL(3,Z)`. The enumeration returns exactly 18 classes,
with Picard-rank distribution 1, 4, 7, 4, 2 for ranks 1 through 5, matching the
Batyrev / Watanabe–Watanabe classification.

**Quantum ring.** Batyrev's presentation (a theorem for smooth toric Fano varieties, via
Givental's mirror theorem) gives
`QH^*(X) = C[x_rho] / (linear relations + quantum Stanley–Reisner relations)`, with the
linear relations `sum_rho <m, v_rho> x_rho` for `m` in the dual lattice, and, for every
primitive collection `P = {rho_1,...,rho_k}` with primitive relation
`sum_i v_{rho_i} = sum_j c_j v_{sigma_j}`, the relation
`x_{rho_1} ... x_{rho_k} = q^{beta(P)} prod_j x_{sigma_j}^{c_j}`. Every `beta(P)` is checked
to be positive, which is exactly Batyrev's Fano criterion. Setting all Novikov variables to
1 is the canonical point; the anticanonical cocharacter conjugation
`q^mu (c1*_q) q^{-mu} = q (c1*_{q=1})` makes the Jordan type independent of this
normalization. The linear relations are used to eliminate three of the ray variables, and
the quotient is computed by a grevlex Groebner basis in the remaining `b2` variables.

**Jordan decisions are exact.** No floating point enters any structural decision. The
characteristic polynomial of `c1 *` is factored into `Q`-irreducibles; for each irreducible
factor `f` of degree `d` the block sizes are read off from the ranks of `f(U)^k` over `Q`,
which handles the entire Galois orbit of `f` at once and needs no splitting field. The
block sizes are cross-checked against the algebraic multiplicity.

**Validation battery (all assertions run inside the script).**

1. Per variety, the dimension of the classical quotient ring and of the quantum quotient
   ring each equal the number of maximal cones of the fan; the classical monomials lift to
   a basis of the quantum ring (the transition matrix is inverted exactly).
2. All torus-fixed-point classes agree, and `c1 *` respects the quantum degree bound
   (an entry from complex degree `e` to degree `d` can be nonzero only if `d <= e + 1`).
3. `P^3` reproduces `charpoly = L^4 - 256`, i.e. the four simple eigenvalues `4 i^k`.
4. The 18 anticanonical degrees `(-K)^3` match the classification multiset
   36, 36, 40, 42, 44, 44, 46, 46, 48, 48, 50, 50, 52, 54, 54, 56, 62, 64; the products
   `S x P^1` match `6 K_S^2` and `Bl_pt P^3` matches `64 - 8`.
5. **Independent spectrum check.** For each variety the critical values of the mirror
   Landau–Ginzburg potential `W = sum_rho z^{v_rho}` on `(C^*)^3` are computed in the
   Jacobian ring built directly from `z_i dW/dz_i` (saturated at `z1 z2 z3 != 0`), a code
   path sharing no step with the Batyrev construction — no primitive collections, no linear
   relations, different variables. Both characteristic polynomials agree in all 18 cases.
6. **Positive control on the Levelt tool.** The exponent machinery, ported from
   `notes/cubic-threefolds-tasks/c925-fable-levelt-exponent-tool.py`, is run on the smooth
   cubic threefold, where it must return exponents `-1/6, -5/6` and delta-sharp `4/9`, and
   on a rational curve summand, where it must return `{1/2, 1/2}` and delta-sharp `0`. Both
   are asserted. So the sweep would have detected a marked block had one occurred.

## The 18 varieties

`b2` is the Picard rank, `chi` the topological Euler characteristic (= number of maximal
cones), `deg` is `(-K)^3`. Names come from structural detection run by the script itself
(products, projectivized bundles with their twist, equivariant blow-down chains); the ray
data is the primary record. Every row is semisimple, so the "nontrivial blocks" column is
empty throughout and no exponent class exists.

| #   | name                                      | b2 | chi | deg | rays                                                                    | distinct eigenvalues | eigenvalue multiplicities | Jordan type | nontrivial blocks |
|-----|-------------------------------------------|----|-----|-----|-------------------------------------------------------------------------|----------------------|---------------------------|-------------|-------------------|
| X01 | `P^3`                                     | 1  | 4   | 64  | `(1,0,0) (0,1,0) (0,0,1) (-1,-1,-1)`                                    | 4                    | 1,1,1,1                   | 4 blocks of size 1  | none |
| X02 | `P(O + O(2)) -> P^2`                      | 2  | 6   | 62  | `(1,0,0) (0,1,0) (0,0,1) (-2,-1,-1) (-1,0,0)`                           | 6                    | all 1                     | 6 blocks of size 1  | none |
| X03 | `P^2`-bundle over `P^1`                   | 2  | 6   | 54  | `(1,0,0) (0,1,0) (0,0,1) (-1,-1,-1) (-1,-1,0)`                          | 6                    | all 1                     | 6 blocks of size 1  | none |
| X04 | `P(O + O(1)) -> P^2 = Bl_pt P^3`          | 2  | 6   | 56  | `(1,0,0) (0,1,0) (0,0,1) (-1,-1,-1) (-1,0,0)`                           | 6                    | all 1                     | 6 blocks of size 1  | none |
| X05 | `P^2 x P^1`                               | 2  | 6   | 54  | `(1,0,0) (0,1,0) (0,0,1) (-1,0,-1) (0,-1,0)`                            | 6                    | all 1                     | 6 blocks of size 1  | none |
| X06 | `Bl_curve(P(O + O(2)) -> P^2)`            | 3  | 8   | 50  | `(1,0,0) (0,1,0) (0,0,1) (-2,1,-1) (1,-1,0) (-1,1,0)`                   | 8                    | all 1                     | 8 blocks of size 1  | none |
| X07 | `P^1`-bundle over `F_1`, twist `[0,0,-1,-1]` | 3 | 8 | 50  | `(1,0,0) (0,1,0) (0,0,1) (-1,-1,-1) (-1,-1,0) (-1,0,0)`                 | 8                    | all 1                     | 8 blocks of size 1  | none |
| X08 | `Bl_curve(P(O + O(1)) -> P^2)`            | 3  | 8   | 46  | `(1,0,0) (0,1,0) (0,0,1) (-1,0,-1) (0,-1,0) (-1,-1,-1)`                 | 8                    | all 1                     | 8 blocks of size 1  | none |
| X09 | `P(O + O(1,1)) -> P^1 x P^1`              | 3  | 8   | 52  | `(1,0,0) (0,1,0) (0,0,1) (-1,0,-1) (-1,-1,0) (-1,0,0)`                  | 6                    | 2,2,1,1,1,1               | 8 blocks of size 1  | none |
| X10 | `F_1 x P^1`                               | 3  | 8   | 48  | `(1,0,0) (0,1,0) (0,0,1) (-1,0,-1) (0,-1,0) (-1,0,0)`                   | 8                    | all 1                     | 8 blocks of size 1  | none |
| X11 | `P(O + O(1,-1)) -> P^1 x P^1`             | 3  | 8   | 44  | `(1,0,0) (0,1,0) (0,0,1) (-1,0,-1) (1,-1,0) (-1,0,0)`                   | 6                    | 2,2,1,1,1,1               | 8 blocks of size 1  | none |
| X12 | `P^1 x P^1 x P^1`                         | 3  | 8   | 48  | `(1,0,0) (0,1,0) (0,0,1) (0,0,-1) (0,-1,0) (-1,0,0)`                    | 4                    | 3,3,1,1                   | 8 blocks of size 1  | none |
| X13 | `Bl_curve(P^1`-bundle over `F_1`, twist `[0,0,-1,-1])` | 4 | 10 | 46 | `(1,0,0) (0,1,0) (0,0,1) (-1,-1,-1) (0,-1,0) (-1,0,0) (-1,-1,0)` | 8            | 2,2,1,1,1,1,1,1           | 10 blocks of size 1 | none |
| X14 | `Bl_curve(P(O + O(1,1)) -> P^1 x P^1)`    | 4  | 10  | 44  | `(1,0,0) (0,1,0) (0,0,1) (-1,0,-1) (0,-1,0) (-1,0,0) (-1,-1,0)`         | 10                   | all 1                     | 10 blocks of size 1 | none |
| X15 | `dP7 x P^1`                               | 4  | 10  | 42  | `(1,0,0) (0,1,0) (0,0,1) (0,0,-1) (0,-1,0) (-1,0,0) (-1,-1,0)`          | 8                    | 2,2,1,1,1,1,1,1           | 10 blocks of size 1 | none |
| X16 | `Bl_curve(P^1`-bundle over `F_1`, twist `[0,0,-1,0])` | 4 | 10 | 40 | `(1,0,0) (0,1,0) (0,0,1) (-1,0,-1) (1,-1,0) (-1,0,0) (0,-1,0)`   | 10                   | all 1                     | 10 blocks of size 1 | none |
| X17 | `Bl_curve(Bl_curve(P^1`-bundle over `F_1`, twist `[0,0,-1,0]))` | 5 | 12 | 36 | `(1,0,0) (0,1,0) (0,0,1) (-1,0,-1) (1,-1,0) (-1,1,0) (0,-1,0) (-1,0,0)` | 10 | 2,2,1,1,1,1,1,1,1,1 | 12 blocks of size 1 | none |
| X18 | `dP6 x P^1`                               | 5  | 12  | 36  | `(1,0,0) (0,1,0) (0,0,1) (0,0,-1) (1,-1,0) (-1,1,0) (0,-1,0) (-1,0,0)`  | 6                    | 3,3,2,2,1,1               | 12 blocks of size 1 | none |

Characteristic polynomials for each row are in the output file. Coalescence of eigenvalues
is common — `P^1 x P^1 x P^1` has only four distinct eigenvalues `{6, 2, -2, -6}` with
multiplicities `1, 3, 3, 1`, and `dP6 x P^1` has six distinct eigenvalues including `0` with
multiplicity 3 — but in every such case the operator stays diagonalizable, which is the
property that matters.

## What this means for the b3 = 0 tail

These 18 varieties are the toric part of the `b3 = 0` carrier tail, and they carry no
nontrivial Jordan block at all, so they contribute no exponent class of any kind, marked or
unmarked. The prediction that the marked class `{1/6, 5/6}` never appears on a `b3 = 0`
carrier survives on all of them, but it survives vacuously: the reason is the stronger fact
that these quantum cohomologies are etale at the canonical point, not any property of the
exponents. As evidence for the claim this is confirmatory but weak — it eliminates a whole
family of potential counterexamples without testing the exponent mechanism itself. A sharper
test needs `b3 = 0` carriers whose `c1 *` is genuinely non-semisimple at the canonical point.

## Trust boundary

- Single implementation of the Batyrev construction, with one genuinely independent
  cross-check of the spectrum (the Landau–Ginzburg Jacobian ring), which agrees on all 18.
- All Jordan-structure decisions use exact rational arithmetic in sympy — factorization of
  the characteristic polynomial over `Q` plus exact matrix ranks. No numerical eigenvalue
  computation is used for any structural conclusion.
- The quotient-ring dimension equals the number of maximal cones for every variety, in both
  the classical and the quantum ring, and the enumeration reproduces the known count 18 and
  the known Picard-rank distribution and anticanonical-degree multiset. That the enumeration
  is complete relies on Casagrande's vertex bound and on the ray-coordinate box used for
  pruning (`|coordinate| <= 4`, wall coefficients in `[-5,5]`); the box is not proved
  sufficient inside the script, but the enumeration reproducing exactly the classification's
  18 classes and rank distribution is the check on it.
- **Not verified, and it did not need to be.** The monomial basis of Batyrev's presentation
  is not the classical cohomology basis: the two differ by degree-lowering Novikov
  corrections, which shows up concretely as the classical Poincare pairing failing to be
  graded on monomials for some of these varieties. The Jordan type of `c1 *` is an invariant
  of the operator and so is unaffected, which is why the verdict above is basis-free. But the
  grading operator `mu = diag((deg - 3)/2)` is diagonal only in the true classical basis, so
  a Levelt exponent computation on a block would first have to pin down that splitting —
  extra Gromov–Witten input the Batyrev presentation alone does not supply. Since no block
  occurs on any of the 18, the exponent question never arises. If this sweep is later
  extended to a carrier that is non-semisimple, that splitting must be fixed before the
  exponent numbers can be trusted.
- The common names are structural identifications computed by the script (product
  decompositions, projectivized-bundle structure with twist, blow-down chains). They are
  labels; nothing in the computation depends on them. The ray data is authoritative.

## Reproduction

```
cd notes/cubic-threefolds-tasks
uv run --with sympy python3 c925-fable-toric-fano-levelt-sweep.py
```

Runtime about 10 seconds. The script exits nonzero if any assertion in the validation
battery fails.

| file                                                                     | sha256                                                             |
|--------------------------------------------------------------------------|--------------------------------------------------------------------|
| `notes/cubic-threefolds-tasks/c925-fable-toric-fano-levelt-sweep.py`       | `792fd68517370c9891a3fbbf7dfa2f1be5b3567c6a6c7d42a876237a7e158447` |
| `notes/cubic-threefolds-tasks/c925-fable-toric-fano-levelt-sweep-output.txt` | `d18351ecbb553f5b0b2bae3c537e88204198e24ed27354add8846f35d0f9f14f` |
