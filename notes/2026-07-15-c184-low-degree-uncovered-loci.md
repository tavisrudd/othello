# C184 — Low-degree uncovered loci across the Clebsch census

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED.**

## Verdict

The proposed statement “Clebsch is the unique class whose uncovered set is the full rational
point set of an irreducible curve” is false. Three other classes already have exact absolutely
irreducible loci at their minimum vanishing degree:

| class | `|U|` | stabilizer | minimum degree | exact forms at that degree |
|---|---:|---:|---:|---:|
| C02 | 18 | 6 | 4 | 1 absolutely irreducible quartic |
| C04 | 19 | 3 | 5 | 1 absolutely irreducible quintic among 133 projective kernel forms |
| C12 | 22 | 5 | 6 | 16 sextics; the normalized witness below is absolutely irreducible |
| C15 (Clebsch) | 12 | 60 | 2 | 1 nonsingular conic |

The clean positive theorem is sharper and cheaper:

> **Clebsch is the unique projective class among the fifteen whose uncovered set is contained in
> any cubic.**

Every non-Clebsch cubic evaluation matrix has full column rank ten. Clebsch has minimum degree
two, with a one-dimensional quadratic kernel; its degree-three kernel consists of the conic
equation times the three-dimensional space of linear forms. Thus this is a containment theorem,
not merely an exact-locus observation.

The checker also exhausts every relevant projective kernel through degree five. The only exact
rational loci in that range are C02, C04, and C15. It additionally exhausts C12's first nonzero
kernel in degree six. It does **not** claim that another class cannot acquire an exact equation in
degree six: those larger degree-six kernels were not exhausted, and unbounded-degree “some curve”
questions are not a useful uniqueness notion for a finite point set.

There is no sampling hidden in that boundary. C12's degree-six kernel has dimension six, hence
exactly 177,156 projective forms, all of which were tested. Every other nontrivial degree-six kernel
has dimension at least seven (the table records every dimension), starting at 1,948,717 forms; those
kernels were neither exhausted nor sampled for exact-locus counts. Their degree-six status is open,
not a negative result.

## Complete evaluation table

Each `r/n` entry is `rank/nullity` for evaluation of all homogeneous ternary forms of the indicated
degree on `U(A)`. The source dimensions are `3,6,10,15,21,28` in degrees one through six.

| class | `|U|` | d1 | d2 | d3 | d4 | d5 | d6 | minimum d | exact at minimum? |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| C01 | 20 | 3/0 | 6/0 | 10/0 | 15/0 | 19/2 | 20/8 | 5 | no |
| C02 | 18 | 3/0 | 6/0 | 10/0 | 14/1 | 17/4 | 18/10 | 4 | yes, one |
| C03 | 19 | 3/0 | 6/0 | 10/0 | 15/0 | 18/3 | 19/9 | 5 | no |
| C04 | 19 | 3/0 | 6/0 | 10/0 | 15/0 | 18/3 | 19/9 | 5 | yes, one |
| C05 | 20 | 3/0 | 6/0 | 10/0 | 15/0 | 19/2 | 20/8 | 5 | no |
| C06 | 20 | 3/0 | 6/0 | 10/0 | 15/0 | 19/2 | 20/8 | 5 | no |
| C07 | 21 | 3/0 | 6/0 | 10/0 | 15/0 | 20/1 | 21/7 | 5 | no |
| C08 | 20 | 3/0 | 6/0 | 10/0 | 15/0 | 19/2 | 20/8 | 5 | no |
| C09 | 20 | 3/0 | 6/0 | 10/0 | 15/0 | 19/2 | 20/8 | 5 | no |
| C10 | 19 | 3/0 | 6/0 | 10/0 | 15/0 | 18/3 | 19/9 | 5 | no |
| C11 | 16 | 3/0 | 6/0 | 10/0 | 13/2 | 15/6 | 16/12 | 4 | no |
| C12 | 22 | 3/0 | 6/0 | 10/0 | 15/0 | 21/0 | 22/6 | 6 | yes, 16 |
| C13 | 18 | 3/0 | 6/0 | 10/0 | 14/1 | 17/4 | 18/10 | 4 | no |
| C14 | 18 | 3/0 | 6/0 | 10/0 | 14/1 | 17/4 | 18/10 | 4 | no |
| C15 | 12 | 3/0 | 5/1 | 7/3 | 9/6 | 11/10 | 12/16 | 2 | yes, one |

## Normalized equations

Coefficient vectors are scaled so their first nonzero entry is one and use the order

`x^a y^b z^c`, with `a=0,...,d`, `b=0,...,d-a`, and `c=d-a-b`.

The checker prints both these vectors and expanded equations and verifies that their zero masks
among all 133 points of `PG(2,11)` equal the corresponding `U(A)` exactly.

- C15 conic (`d=2`):
  `(1,2,5,2,8,5)`, i.e.
  `z² + 2yz + 5y² + 2xz + 8xy + 5x² = 0`.
- C02 quartic (`d=4`):
  `(1,0,6,5,8,3,4,3,8,6,10,9,10,8,8)`.
- C04 quintic (`d=5`):
  `(1,3,0,5,7,1,5,6,5,8,6,3,7,6,0,0,6,7,9,2,10)`.
- C12 sextic (`d=6`, lexicographically least of the sixteen normalized exact forms):
  `(1,0,4,1,6,4,3,7,4,10,1,9,3,2,5,10,5,9,7,0,7,4,1,4,10,0,6,8)`.

## Exact method and irreducibility

[`check_low_degree_loci.py`](../papers/clebsch-hexagon-code/check_low_degree_loci.py) imports the
existing exact census machinery from `check_global_conic_gap.py`. It regenerates the 1,548
frame-normalized arcs, forms the same fifteen canonical projective-class keys, recomputes each
uncovered mask from secant-line masks, and uses exact Gaussian elimination over `F_11`. No locus,
rank, or representative is loaded as an opaque certificate.

For each small vanishing kernel, it enumerates every normalized nonzero kernel vector and evaluates
the resulting form on all 133 projective points. This proves containment and equality separately.
In particular, a rank deficiency alone is never reported as an exact rational locus. The exhaustive
counts include 177,156 projective quintics for C11's six-dimensional kernel and 177,156 projective
sextics for C12's six-dimensional kernel.

For C02 and C04, the same Python checker tests every one of the 133 projective linear forms and all
177,156 projective quadratic forms as possible polynomial divisors, solving the quotient coefficient
system exactly over `F_11`. A reducible quartic or quintic has a factor of degree at most two, so
zero hits prove irreducibility over `F_11`. C15 similarly has no linear factor and is a nonsingular
conic.

The C02/C04/C12 geometry replay is Git-tracked as
[`check_low_degree_loci.sing`](../papers/clebsch-hexagon-code/check_low_degree_loci.sing),
with the fail-closed wrapper
[`check_low_degree_loci.sh`](../papers/clebsch-hexagon-code/check_low_degree_loci.sh).
Singular 4.4.1 returns only a unit and the degree-six polynomial, each with multiplicity one.

These `F_11`-irreducibility results imply absolute irreducibility here. If an `F_11`-irreducible
plane form of degree `d` split geometrically, Frobenius would act transitively on `r>1` equal-degree
components. Every rational point would lie on every conjugate component. Bézout therefore bounds
the rational locus by the intersection of two components: at most `4` for the possible `2+2`
quartic splitting, at most `1` for the quintic's five conjugate lines, and at most `9` for the
largest possible sextic splitting into two conjugate cubics. The observed counts `18,19,22` exceed
those bounds.

The same tracked replays identify the basic geometry of the companions:

- C02 is a smooth plane quartic, hence has genus three. Its homogeneous Jacobian ideal is
  zero-dimensional at the affine cone vertex and its Milnor-algebra length is `27=(4-1)^3`.
- C04 has one geometric singular point, rational at `(10:3:1)`. In local coordinates
  `x=10+X`, `y=3+Y`, `z=1`, its tangent cone is
  `X^2+4XY+5Y^2`. The discriminant is `7`, a nonsquare in `F_11`, so this is an ordinary nonsplit
  node. The normalization therefore has genus `6-1=5`.
- The displayed C12 witness is a smooth plane sextic, hence has genus ten. Its Milnor-algebra
  length is `125=(6-1)^3`.

The Python checker independently finds the rational singular point and its tangent cone; the
Singular replay establishes geometric smoothness for C02/C12 and projective singular-scheme degree
one for C04.

## Replay

From `papers/clebsch-hexagon-code/`:

```bash
python check_low_degree_loci.py
nix shell nixpkgs#singular -c ./check_low_degree_loci.sh
```

The Python checker exits nonzero on every asserted rank, kernel, equation, zero-locus, count, or
factorization mismatch. The completed run ends with:

```text
C02_linear_factors=0/133 quadratic_factors=0/177156 irreducible_over_F11=True
C04_linear_factors=0/133 quadratic_factors=0/177156 irreducible_over_F11=True
all assertions passed
```

The Singular replay prints:

```text
C12_sextic_irreducible_over_F11=True
C02_smooth_genus=3
C04_unique_geometric_singularity=True
C12_smooth_genus=10
all assertions passed
```

## Manuscript recommendation

This merits a compact census theorem in the current paper if space permits:

1. lead with the unique-cubic theorem, which strengthens the Clebsch rigidity story without
   changing its scope;
2. give the minimum-degree table or a compressed histogram; and
3. record the quartic/quintic/sextic companions as the reason “unique irreducible curve locus” is
   the wrong formulation.

The manuscript adopts the compact disposition: a low-degree algebraic-rigidity proposition after
the main rigidity theorem, the strengthened monomial characterization, and a sharpness remark for
the quartic/quintic companions. The sextic appears only with the explicit no-classification
boundary. The companion curves do not displace the deep-hole theorem. A follow-on can study their
genera, singularities, automorphism actions, and whether their degrees or equations admit a
conceptual derivation from the corresponding arc stabilizers.

No new Lean formalization is warranted for this paper: the reusable evaluation obstruction is
already abstracted in `EvaluationObstruction.lean`, while the new content is the finite
fifteen-class rank certificate and should wait for shared rigidity-census infrastructure.

Post-integration replay on 2026-07-15:

- `uv run python check_low_degree_loci.py`: all rank, kernel, exact-locus, rational-singularity,
  and low-degree factor assertions passed;
- `nix shell nixpkgs#singular -c ./check_low_degree_loci.sh`: all absolute
  irreducibility, smoothness, and singular-scheme assertions passed.
