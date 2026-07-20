# C438 postmortem — bridge attack vectors after the fibre obstruction

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** bounded attack-vector search; no successor allocated

**Literature depth:** zero newly consulted sources were read at full text.  The primary sources
below were read at the stated partial or abstract/metadata depth.  This is a route-design report,
not a novelty or priority audit.

## Executive answer

C438 killed the direct identification, but not the programme.  The best repair is to move both
examples into **theta/2-torsion marking geometry** before comparing them.

The q=9 side has a classical parent-specific obstruction object that C438 did not use.  For a
Cayley octad with bitangent matrix `(b_ij)`, marking octad point `i` selects the seven bitangents
`{b_ij:j!=i}`.  They form an Aronhold system, and every Aronhold system uniquely recovers an even
theta characteristic and a marked point of its Cayley octad.  Thus C435's

```text
36 determinantal classes x 8 octad-point marks = 288
```

is exactly the classical 288-Aronhold-system tower.  The frozen q=9 coordinates already compute
this object: the direct forms

```text
b_ij(lambda) = O_i^T (sum_k lambda_k Q_k) O_j
```

give 28 distinct projective linear forms, with eight seven-form rows.

The q=11 side has an equally natural theta host.  Regard the twelve points of `Q(F_11)` as the
branch locus of the genus-five hyperelliptic curve

```text
H_11 : y^2 = x^11-x.
```

Then C390's binary space

```text
{even subsets of Q(F_11)} / <all points>
```

is the standard `J(H_11)[2]` model.  A C379 perfect matching spans a five-dimensional maximal
isotropic subgroup: precisely the classical kind of tractable kernel used for generalized
Richelot isogenies.  The exact pilot also finds that `H_11` has zero `5 x 5` Hasse--Witt matrix;
superspeciality and the geometry of the quotient remain deliberately unclaimed.

This produces a credible common category:

```text
curve / ppav + level-2 data + recoverable theta marking,
```

with genus three and genus five as different specializations.  It is a better bridge target than
forcing the q=9 and q=11 outer involutions to act on the same finite fibre.

## Ranked attack vectors

### 1. Aronhold-to-Richelot theta bridge — highest value

**q=9 input.**  C435 supplies the 36 even-theta/determinantal classes and the eight point marks
over each class.  The Cayley bitangent matrix turns each mark into an Aronhold heptad and recovers
the mark and even theta class from it.

**q=11 input.**  C379 supplies 22 partitions of the twelve branch points into pairs.  C390 already
proves that each matching spans a recoverable Lagrangian five-space; in the hyperelliptic model it
is a maximal 2-Weil-isotropic kernel.

**Shared question.**  Is there one functor on theta-marked principally polarized abelian varieties
whose q=9 fibre is the Aronhold/even-theta recovery map and whose q=11 fibre is quotient by the
matching kernel?  The first useful invariant is not object count but the induced quadratic/Gauss
form and the square of the theta transform.

**Cheap gate.**  Construct the 22 q=11 quotient ppav invariants—at minimum theta-null pattern,
decomposition type, Frobenius polynomial, and the action of `J`—and ask whether the result retains
the parent or its sheet.  Stop if all kernels give one generic matching-isogeny class or if the
quotient ceases to be a Jacobian in a way unrelated to C379's roots.

### 2. Two-stage coset/Hecke tower — cheapest exact theorem route

The correct finite towers are

```text
q=9:   PGU(3,3) > PSL_2(7) > 7:3,    fibres 36 then 8,
q=11:  PGL_2(11) > A5        > D10,   fibres 22 then 6.
```

The local fibres are uniformly Sylow-normalizer spaces:

```text
PSL_2(7)/N(C7),       A5/N(C5).
```

The total marked sets have sizes 288 and 132.  C411's double-coset/Hecke machinery can compute the
up/down incidence operators, their minimal polynomials, radicals in characteristics 3 and 11, and
the defect of applying the marked transform twice.  This route does not promise a geometric
identification; it asks for a portable subgroup-tower theorem explaining when a minimal Sylow
mark repairs a noninjective carrier transform.

**Cheap gate.**  Compute the two flag-incidence algebras and require a common normalized polynomial
identity or radical/quotient mechanism.  Stop on matching ranks or spectra without a shared proof.

### 3. Relative discriminant/Fitting-ideal bridge — best direct algebraic route

Avoid theta moduli and compare the two parent-conditioned incidence maps themselves.

- At q=9, the exact `8 x 8` bitangent matrix and its Aronhold rows are available from the octad and
  quadric net.
- At q=11, the six deletion conics, twelve extension points, secant matching, and root-intersection
  matrix are already exact.

Package each as a two-term presentation matrix over the carrier coordinate ring and compare its
Fitting ideals, rank-drop divisor, and first syzygies.  Resultants, Chow forms, and discriminants
are the classical tools; C383's apolar-plane implementation and C403's weighted-adjoint machinery
provide local code.

**Cheap gate.**  Determine whether the parent decoration is the singular support of one canonical
module in both examples.  Stop if the q=9 Aronhold row is only a chosen submatrix while the q=11
matching is intrinsic to the module.

### 4. Binary quadratic marking objects — robust but more abstract

The q=9 theta characteristics live in the affine quadratic refinements of a six-dimensional
symplectic space.  The q=11 matching lives in the ten-dimensional hyperelliptic 2-torsion space,
where C390 supplies the Lagrangian and quadratic kernel.  One can define a genus-parametrized
category of anisotropic simplices/Aronhold bases and tractable Lagrangians, then compare Fourier or
Gauss transforms rather than the underlying point configurations.

This is supported by C372/C378's exact finite Fourier tools and C430's radical--Hadamard theorem.
It becomes worthwhile only if Attack 1 produces a nontrivial q=11 quotient invariant.

### 5. Canonical lift and octad pictures — legitimate but expensive

The earlier octad-picture advice becomes valid only after choosing and proving independence of a
local-field lift of the Hermitian net.  A Teichmuller or Witt-vector lift of the frozen `F_9`
matrices could produce valuation data, an octad picture, and stable-reduction type.  One could then
compare that degeneration obstruction with a lifted q=11 root degeneration.

This route inherits two serious risks: lift dependence, and the source paper's general
`Sp(6,2)` compatibility being conjectural beyond a single building block.  It ranks below the
intrinsic finite-field theta routes.

### 6. Superspecial/isogeny category — speculative reserve

The Hermitian genus-three quartic is an exceptional finite-field curve with highly constrained
Jacobian, while the q=11 hyperelliptic host has certified Hasse--Witt rank zero.  Their Jacobians
may therefore admit a common description through superspecial ppav or Hermitian modules over a
quaternion order.  This could make the dimensions `3` and `5` parameters in one isogeny theorem.

Do not promote this route until the q=11 Newton/Dieudonne type and the q=9 polarization type are
computed exactly.  Hasse--Witt rank zero alone is not recorded here as a superspeciality theorem.

## One tempting shortcut that is already closed

A q=11 matching has six pairs, so the closest classical q=9 object appears to be one of the 63
Steiner complexes, each likewise a sextuple of bitangent pairs.  But a fixed C405 parent does not
canonically select one.  Exact action on the classical `28+35` Cayley labels gives projective
`7:3` orbit sizes

```text
type V: 7,21;       type II: 7,7,21,
```

and semilinear `7:6` orbit sizes

```text
type V: 7,21;       type II: 14,21.
```

There is no fixed Steiner complex in either category.  The independent replay uses the standard
affine groups `x -> ax+b` on `F_7`, fixing infinity.  Therefore “choose one q=9 Steiner complex and
identify it with the q=11 matching” is not equivariant; any such choice adds precisely the missing
mark.

## Available machinery

Our exact assets are already unusually strong:

- C405/C435: frozen `F_9` octad, quadric net, Hermitian matrix, parent recovery, all three finite
  groups, 36-class action, and Frobenius;
- C379/C381: 22 matchings, 66 secants, two one-factorizations, root-intersection recovery, and the
  complete marked `E8` orbit split;
- C390: the general matching-to-Lagrangian construction and intersection formula;
- C411/C430: double-coset incidence maps, modular radicals, and product-algebra rigidity;
- C383: presentation-independent apolar contraction and factorization strata; and
- the existing deterministic finite-field/projective-frame code, which is enough for the first
  three cheap gates without a new general-purpose package.

The classical assets are Cayley bitangent matrices, Aronhold reconstruction, Steiner complexes,
theta characteristics as quadratic refinements of `J[2]`, hyperelliptic 2-torsion from branch-point
subsets, tractable maximal isotropic kernels, generalized Richelot isogenies, and ordinary
double-coset/Hecke algebras.

## Recommended move order

1. **Aronhold lift:** certify tangency/Aronhold parity for the eight exact q=9 rows and attach the
   row selected by each C435 parent.
2. **Hyperelliptic lift:** construct `H_11`, the 22 maximal isotropic kernels, and cheap quotient
   invariants; this is the decisive bridge gate.
3. **Only after a positive quotient invariant:** compare theta/Gauss transforms and then formulate
   the coset/Hecke theorem.

No new G4/G11 programme follows merely from the 28-form or Hasse--Witt calculations.

## Evidence and replay

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-20-c438-postmortem-bridge-vectors.py --check
sha256sum -c notes/2026-07-20-c438-postmortem-bridge-vectors.sha256
```

The checker uses the frozen C435 code/input, directly constructs all 28 bilinear bitangent forms,
enumerates projective and semilinear parent-stabilizer orbits on all 63 classical Steiner labels,
replays those orbit profiles with independent standard affine groups, and computes the q=11
Hasse--Witt matrix from `(x^11-x)^5`.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 8,191 | `d092600f1299fab09ab983142eb4c82543e5017983b1b860c2a502a5749a981b` |
| certificate `.json` | 3,973 | `6a34aaec76000f2948a4a32eff114e205edae7bcb4663e4c3c8b95b51202255d` |

The trusted boundary is C435's field model and frozen C405 certificate; the classical theorem that
the off-diagonal Cayley matrix forms are bitangents; the standard branch-subset model of
hyperelliptic `J[2]`; and Python integer/finite-field arithmetic.  The checker does not construct a
Richelot quotient, prove the q=11 host superspecial, or prove a cross-genus theta functor.

## Literature boundary

- **Abban--Cheltsov--Park--Shramov, _Double Veronese cones with 28 nodes_: partial.** Read the
  cached/web PDF at Section 7, especially Lemma 7.14 and Corollary 7.16: a marked Cayley-octad
  point gives an Aronhold system, every Aronhold system uniquely recovers the even theta and marked
  point, and `288=36*8`.  Accessed from the authors' University of Edinburgh PDF.
- **Plaumann--Sturmfels--Vinzant, _Quartic Curves and Their Bitangents_, arXiv:1008.4104v1:
  partial.** Reused the cached Section 3 Cayley bitangent matrix and Section 5 Steiner-complex
  construction. Cache SHA-256
  `2361eabf304218b410bdf5fe7b98f1f5e8a3676ddc2c49e284580123c6310744`.
- **Dalla Piazza--Fiorentino--Salvati Manni, _Plane quartics: the matrix of bitangents_,
  arXiv:1409.5032: partial.** Read the Introduction and the Cayley-matrix/Aronhold reconstruction
  passages exposed by the official arXiv HTML.  They explicitly identify each row's seven
  bitangents as an Aronhold system.
- **Smith, _Isogenies and the Discrete Logarithm Problem_, EUROCRYPT 2008: partial.** Read the
  tractable-subgroup definition and branch-pair partition correspondence in Sections 3--4 through
  the IACR proceedings PDF.  Its explicit algorithms are genus three; the elementary maximal
  isotropic construction used here works in genus five, but no genus-five quotient formula is
  attributed to this source.
- **Katsura--Takashima, _Decomposed Richelot isogenies of Jacobian varieties of hyperelliptic
  curves and generalized Howe curves_, arXiv:2108.06936: abstract/metadata and Introduction only.**
  It supplies the any-genus Richelot/decomposition framework, not the proposed C379 specialization.

No claim-specific absence search, forward-citation census, or priority conclusion was attempted.
