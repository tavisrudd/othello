# C412 — relative-cubic to depth-plane naturality obstruction

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `BOUNDED NEGATIVE; THE BINARY FLAG IS INTRINSIC, BUT COMMON COVARIANCE DOES NOT SELECT A SOURCE-TO-TARGET MAP`

## Executive conclusion

C411's compressed binary cubic has a basis-independent doubled-line/residual-line flag, but that
flag does not lift to a natural map from C406's three-dimensional relative-cubic space.

Let `R` be the `PSL_2(11)`-fixed, outer-odd subspace of `Sym^3(W)` and let `P` be the two-dimensional
depth-profile plane.  Exact reconstruction gives

```text
dim R = 3,       PSL_2(11)|R = 1,       J|R = -1,
dim P = 2,       A4|P = 1,              J|P = -1.
```

Thus the largest symmetry visibly shared by source and target acts on them as three and two copies
of the same sign character.  Consequently

```text
Hom_(A4 semidirect <J>)(R,P) = Hom_F11(R,P) ~= Mat_(2x3)(F_11).
```

Every `2 x 3` matrix makes the covariance square commute.  There are `1,755,600` rank-two maps,
their kernels run through all `133` projective lines of `R`, and each fixed kernel occurs for
exactly `|GL_2(11)|=13,200` such maps.  In particular neither covariance nor the signed moment line
selects a rank-one kernel.

The full group cannot repair the ambiguity.  C411's six depth fibres are not a
`PSL_2(11)` block system: the first frozen generator sends matching indices `2,16`, which share one
depth profile, to indices `5,19` in two different depth fibres.  Hence no action on the six profiles,
and therefore no full-group action on their plane compatible with the depth quotient, makes the
depth map equivariant.

This is the task's mandatory negative stop.  A rank-two fitted matrix can always be written, but
its kernel is arbitrary.  Hessian, catalecticant, and apolar constructions operate only after a
binary target form has already been supplied, so using them to manufacture the missing map is
circular.

## The intrinsic target flag

In C411's depth-plane basis `e_1=v_2,e_2=v_3`, the compressed cubic is

```text
f(x,y) = x^3+7x^2y+5xy^2+9y^3 = (x-y)^2(x-2y).
```

With the ordinary unscaled monomial coefficients, its Hessian determinant is

```text
Hess(f) = 7x^2+8xy+7y^2 = 7(x-y)^2.
```

Therefore the divisor of `f` intrinsically consists of a doubled line `L` and a residual simple
line `R_0`, while its Hessian recovers `2L`.  This statement is basis-independent: a change of
basis transports the factorization divisor and Hessian covariantly.  The first catalecticant has
matrix

```text
[[3,3,5],
 [7,10,5]]
```

and rank two over `F_11`.  It is nondegenerate as a first-polar map, but like the Hessian it is an
operator internal to the binary target `P`; it supplies no input leg from `R`.

## The covariance obstruction

The primary checker reconstructs the ten-dimensional H3 quotient module `W`, its 220-dimensional
symmetric cube, and the three-dimensional relative space `R` from the frozen C406 geometry.  On
the computed basis of `R`, each of three `PSL_2(11)` generators acts by `I_3`, and an outer element
acts by `-I_3`.

On the target, scalar `A4` fixes each oriented depth coordinate and `J` negates every profile, so
its matrices are `I_2` and `-I_2`.  For an arbitrary matrix `A in Mat_(2x3)(F_11)`, the only
available square is therefore

```text
R  --A-->  P
|          |
chi(g)I_3  chi(g)I_2
|          |
R  --A-->  P,
```

which commutes for every `A`.  This is covariance without naturality: it imposes zero equations on
the six coefficients of `A`.

The enumeration sharpens that statement.  A rank-two `2 x 3` matrix has one projective kernel
line.  Direct enumeration of all `11^6` matrices gives

```text
# rank-two maps = (11^3-1)(11^3-11) = 1,755,600,
# kernel lines  = 11^2+11+1          = 133,
# maps per line = |GL_2(11)|         = 13,200.
```

The signed sheet moment has projective coordinates `[1:1:8]` in the checker's relative-space basis.
It is geometrically distinguished by C406's signed moment construction, but the common group acts
scalarly on all of `R`; `GL_3(11)=Aut_(A4 semidirect <J>)(R)` is transitive on its 133 lines.  Making
the signed line the kernel is possible in exactly 13,200 ways and is not characterized by the
covariance data.

## Failure of full-group descent

A stronger commutative square would require the depth quotient itself to be equivariant under
`PSL_2(11)`.  Equivariance through a six-element quotient requires the six fibres to form a block
system: two matchings with one profile must always have images with one profile.

The exact counterexample is:

```text
same source fibre:             matching indices 2,16
first PSL generator images:   matching indices 5,19
image fibre labels:           2,5
```

Thus the six-profile quotient does not admit a descended `PSL_2(11)` action.  The profile plane is
a canonical scalar-`A4` depth object, not a `PSL_2(11)` quotient representation.  There is no
full-group covariance square to constrain a map `R -> P`.

## Hessian, apolarity, and the signed line

The classical binary constructions answer the task's candidate tests negatively:

- the Hessian sends a binary cubic to a binary quadratic and recovers the doubled target line;
- the first polar/catalecticant sends a target vector or covector to a target quadratic;
- apolarity pairs binary forms only after both have been placed in compatible binary form spaces.

None accepts the ten-variable source tensor, or its three-dimensional relative-invariant subspace,
without an antecedent map into a binary form space.  Precomposing any of them with a fitted
`R -> P`, `R -> Sym^3(P)`, or dual map assumes precisely the bridge C412 was required to derive.
The target flag is therefore an exact output-side constraint, not the image or apolar shadow of a
natural source covariant in the frozen category.

## Claim-specific literature gate

This report inherits the C406 priority audit's **six full-text sources** and C411's recorded
double-coset/Hecke source boundary.  It adds **zero newly full-read sources**, one source at partial
depth, and one at abstract/metadata depth.  The result does not depend on an absence-of-prior-work
claim: it stops on an exact internal naturality obstruction.  No forward-citation negative is used.

- Abraham Broer and Jianjun Chuai, *Modules of covariants in modular invariant theory*,
  arXiv:0709.0703v3: **partial**; cached arXiv PDF, Abstract, Introduction, Section 1.1, and the
  opening of Section 1.2 read.  Cache key `arXiv:0709.0703`, SHA-256
  `e8b7e4504c1acfe005fc2087259c93de95e987d8a6d24bd7dc78eff82309ac7e`.  It defines a module of
  covariants as `(k[V] tensor M)^G`, identifies semi-invariants as one-dimensional covariant types,
  and emphasizes the modular/nonmodular boundary.  It supports the category used here but does not
  discuss the C406/C411 representations.
- Peter J. Olver, *Classical Invariant Theory*, Chapter 2, DOI
  `10.1017/CBO9780511623660.003`: **abstract/metadata only**; official Cambridge chapter page,
  bibliographic metadata and publisher summary read.  The summary explicitly places binary cubics,
  Hessians, resultants, discriminants, invariants, covariants, and syzygies in the chapter's
  classical scope.  The full chapter was paywalled and was not read, so no internal negative rests
  on it.

Four exact OpenAlex searches were run over title/metadata, screening every returned title when the
count was at most ten and the first ten otherwise:

| exact query | total | screened | disposition |
|:---|---:|---:|:---|
| `modular PSL2 relative invariant covariant` | 9 | 9 | relevance failure; no matching modular finite-group construction |
| `binary cubic Hessian apolar covariant` | 19 | 10 | classical apolar/covariant records; no C406/C411 interface |
| `association scheme eigenspace covariant invariant theory` | 74 | 10 | relevance failure dominated by unrelated modular/physics uses |
| `PSL(2,11) symmetric cube characteristic 11 invariant` | 4 | 4 | no matching relative-space/depth-plane construction |

The first ten titles of a broad result set do not license a global negative.  MathSciNet and Google
Scholar were not accessible, and zbMATH was not closed claim-by-claim.  Those gaps are recorded but
do not qualify the exact obstruction theorem.  The safe literature disposition is positive and
limited: modular covariant modules and binary Hessian/apolar machinery are classical; C412 does not
claim a new general invariant-theory theorem.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-20-c412-relative-cubic-depth-plane.py --check
python3 notes/2026-07-20-c412-relative-cubic-depth-plane-replay.py
sha256sum -c notes/2026-07-20-c412-relative-cubic-depth-plane.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-20-c412-relative-cubic-depth-plane.py --write
```

The primary checker reconstructs the H3 quotient module, relative cubic space, restricted actions,
signed moment line, scalar-`A4` stabilizer, outer involution, depth fibres, and explicit non-descent
witness from the frozen C406/C411 inputs.  It also checks the binary factorization, Hessian,
catalecticant rank, and exact map counts.  The independent replay uses a separate direct
`11^6` matrix enumeration to recover all rank-two maps and kernel-line multiplicities and separately
recomputes the binary factorization and Hessian.

The trusted boundary is exact Python integer/`F_11` arithmetic, the frozen C406 matching-module and
C411 double-coset certificates, the standard definition of a descended group action on a quotient,
and the classical functorial meanings of Hessian, polar/catalecticant, and apolar constructions.
The bundle does not classify nonlinear maps, maps after adding extra matching coordinates, twisted
Fourier targets, or affine-cocycle-valued bridges; those belong, if pursued, to C416/C417 rather than
to this stopped rank-drop task.

| load-bearing artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker | 13,753 | `fd34b26f1e30a931912312aee9f029be83861b89f1587b92a1ed09f7413d94f2` |
| independent replay | 2,640 | `9fd6cd7460d870a82dd282558166560a551e1a005debe4629ebea92616a87b4d` |
| canonical JSON | 4,593 | `38447c52625437159842b1e32c7083b3824721a5ee7fec7491d94cafb6cd6d2f` |

## Disposition

C412 closes at its mandatory stop.  The doubled Hessian line and residual line are intrinsic
covariants of the compressed target cubic.  They neither select nor characterize a map from the
three-dimensional relative source: common covariance permits every matrix and every kernel, while
full `PSL_2(11)` covariance is unavailable because the depth fibres do not descend.  No fitted map,
apolar relabelling, manuscript edit, or successor allocation is authorized by this result.
