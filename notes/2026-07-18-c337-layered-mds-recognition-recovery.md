# C337: expected-linear recognition of the layered non-GRS MDS family

**Lane:** `crowns`

**Date:** 2026-07-18

**Status:** complete on the three-distinct-carrier C329 subfamily. The unlabelled projective system
recovers the three carriers, the hidden split of the doubled carrier, the common additive action,
and the gauge-free C314 coordinates. Projective and semilinear equivalence reduce to a finite action
on three recovered scalars. The algorithm is Las Vegas expected-linear; the available deterministic
fallback is polynomial but not linear.

## Theorem

Let `F=GF(Q)`, where `Q=2^m`, `m` is odd, and `Q>=2^45`, let `E=GF(Q^2)`, and put
`N=4Q`. Let `A subset PG(2,E)` be a member of the three-distinct-carrier C329 family selected in
C336. Thus `A` is an arc and has a presentation

```text
A=A_0 disjoint_union A_1 disjoint_union A_2,
|A_0|=2Q,                 |A_1|=|A_2|=Q,
A_i subset K_i,
```

where the nonsingular conics `K_0,K_1,K_2` are distinct members of one common-point,
common-tangent pencil. The doubled support `A_0` is the union of C329's two repair layers and the
two `Q`-supports are its seed layers.

Given either a `3 x N` generator matrix for the `[N,3,N-2]_E` code or a `3 x N` parity-check
matrix for its `[N,N-3,4]_E` dual, with arbitrary row basis, nonzero column multipliers, and column
permutation, there is a Las Vegas algorithm that:

1. recovers `K_0,K_1,K_2` and their supports of sizes `2Q,Q,Q`;
2. splits `A_0` intrinsically into its two `Q`-point repair layers;
3. recovers the simultaneous `F^+` action and the four full projective orbits;
4. returns the complete gauge-free C314 invariant

   ```text
   I(A)=[rho; {a,b}],
   ```

   modulo seed interchange and

   ```text
   (rho,a,b) -> (rho^-1,a/rho^2,b/rho^2)                 (1)
   ```

   under repair interchange;
5. decides projective/monomial equivalence by equality under these two finite actions, and decides
   semilinear equivalence by additionally applying the `2m` automorphisms of `E`; and
6. certifies that both the dimension-three code and its dual are non-GRS.

The expected number of `E`-field operations is `O(N)`. This counts a field element, a projective
point, a conic equation, and a relative-Frobenius/subfield operation as constant-size algebraic-RAM
objects. With bit-level finite-field arithmetic substituted, multiply by the implementation's usual
field-operation cost. No deterministic linear-time algorithm is asserted.

The theorem is a promise-family recovery theorem. On arbitrary input, the algorithm rejects unless
the heavy-conic and four-coset fingerprint below passes. Acceptance certifies membership in the
intrinsic collision-free C314-E4 layered family containing the C329 outputs; it does not reconstruct
which Chebotarev skeleton or factor-type witness was used historically to prove that the input exists.

## Why the carriers are intrinsic

Any conic `L` different from all three `K_i` meets each `K_i` in at most four geometric points, so

```text
|L cap A| <= 12.                                          (2)
```

On the other hand the three carrier supports have sizes `2Q,Q,Q`, all greater than 12. Hence they
are exactly the conics containing more than twelve columns. Their support sizes distinguish the
repair carrier from the unordered seed pair. This is stronger than merely finding three convenient
conics: it proves that every projectivity of the unmarked code preserves `K_0` and either preserves
or swaps `K_1,K_2`.

Five points of an arc determine a unique nonsingular conic. A trial chooses five distinct currently
uncovered columns, solves the constant-size `5 x 6` conic system, scans the columns, and accepts the
candidate exactly when its support exceeds twelve. A specified seed carrier is hit from the original
set with probability

```text
p_Q = binom(Q,5)/binom(4Q,5) -> 4^-5.                    (3)
```

Sampling from the uncovered set only improves this bound. For example, before any deletion the
probability of hitting some carrier is

```text
[binom(2Q,5)+2 binom(Q,5)]/binom(4Q,5) -> 17/512.        (4)
```

Every accepted candidate is genuine by (2), so this is Las Vegas rather than Monte Carlo. The
expected number of scans needed for all three carriers is at most `3/p_Q`, uniformly bounded on
the admitted tower, and every scan costs `O(N)`. Lexicographically enumerating five-subsets and
scanning their conics gives a deterministic `O(N^6)` fallback. It is deliberately reported as a
fallback, not disguised as efficient deterministic recognition.

## Intrinsic split and normal form

The three recovered conics have one common point `P_infinity` and one common tangent. Constant-size
linear algebra puts their pencil into

```text
K_h: XZ+Y^2+hX^2=0,
P(x,h)=[1:x:x^2+h].                                     (5)
```

The coherent parameter `x` in (5) is unique up to

```text
x -> lambda*x+mu,       h -> lambda^2*h+nu,             (6)
```

with `lambda!=0`. Let `D_1,D_2` be the parameter sets on the two seed conics. For an admitted input
they are equal affine cosets of one additive line. Choose `s in D_1` and put

```text
L=D_1-s=D_2-s.
```

The recognition check verifies `|L|=Q`, additivity, and `L=lF` for one (hence every) `l in L^*`.
This can be done in `O(Q)` operations by hashing `L` and enumerating `lF`. The doubled support is
then exactly two cosets of `L`; hashing one translated copy of `L` splits it in another `O(Q)`
operations.

For representatives `r_1,r_2` of the two repair cosets, define

```text
e_i=Tr_{E/F}((r_i-s)/l) in F^*.                         (7)
```

Changing `l` to `lf`, `f in F^*`, changes `e_i` to `e_i/f`, so `l e_1` and
`rho=e_2/e_1` are independent of `l`. Normalize by

```text
x'=(x-s)/(l e_1),       h'=(h-h_0)/(l e_1)^2.           (8)
```

Writing the two normalized seed-carrier parameters as `a,b`, the point set becomes

```text
{P(t,a):t in F} union {P(t,b):t in F}
 union {P(omega+t,0):t in F} union {P(rho*omega+t,0):t in F},       (9)
```

where `omega^2+omega+1=0`; replacing `omega` by `omega+1` changes no coset. Formula (9) proves both
recovery and completeness of `I(A)`. Choosing the other repair coset for `e_1` gives exactly (1),
and choosing the other seed order swaps `a,b`. Conversely, equality under those actions makes the
normal forms identical and therefore constructs a projectivity. No search through `PGL(3,E)` is
needed.

In C314's coordinates this is precisely the coincidence/E4 specialization

```text
c=1,       K=1,       B=0,       p=1+rho,       w in {0,1},         (10)
```

with `a,b` the two seed heights relative to the repair carrier. The common height removed in (8)
is C314's surviving `C`/prescribed-conic marking. C314 already proved that the prescribed empty
conic is not recoverable from the unmarked selected set. Thus the marked coordinate `C` does not
descend, while the quotient `I(A)` does; this is the exact meaning of “gauge-free C314 invariants”
and not a claim to recover a lost marking.

## Projective and semilinear equivalence

Every projectivity between admitted point sets preserves the unique `2Q` carrier, permutes the two
`Q` carriers, fixes their common point and tangent, and hence has the affine form (6) in coherent
pencil coordinates. The common seed coset and the two repair cosets then force exactly the
normalization (8). This proves

```text
A projectively equivalent to A'
iff I(A)=I(A') after seed swap and/or (1).                (11)
```

Column multipliers disappear when columns are projectivized, row operations act by `PGL(3,E)`, and
column permutations forget the ordering, so (11) is also the monomial-equivalence test for either
matrix convention in the theorem.

Every automorphism of `E` preserves its unique subfield `F`. Therefore

```text
A semilinearly equivalent to A'
iff sigma(I(A))=I(A')                                   (12)
```

for one of the `2m` Frobenius powers `sigma`, again followed by the two finite relabelings. The
normalization through relative trace in (7) is Frobenius-equivariant, so no hidden conjugation sheet
is discarded. After recovery, (11) takes constant many scalar comparisons and (12) takes `O(m)`;
both are negligible beside `N=4Q`.

## The additive orbit-union code

For `mu in F`, let

```text
T_mu[X:Y:Z]=[X:Y+mu X:Z+mu^2 X].                        (13)
```

Then `T_mu P(x,h)=P(x+mu,h)`. The subgroup

```text
H={T_mu:mu in F} isomorphic to F^+
```

acts freely on affine points, preserves every conic in (5), and has exactly the four selected
orbits displayed in (9). Thus the matrix is a four-full-orbit projective group-orbit MDS code, and
`F^+` acts simultaneously as a projective code-automorphism group on the four coordinate blocks.

This suggests the following careful extension of the cyclic/Krylov language. For
`G <= PGL(r,k)` and seeds `z_1,...,z_s`, call the parity-check system formed from
`union_i G[z_i]` an `s`-seed orbit-union code when the orbits are disjoint and full. A Krylov segment
is a one-seed ordered segment of one cyclic operator; (9) is instead a four-seed union of complete
orbits of the elementary-abelian group `F^+`. The term is a formulation for the proved structure,
not a claim that group-orbit codes in general are new.

## Non-GRS certificate

A dimension-three GRS projective system lies on one nonsingular conic. If a conic contained all of
`A`, its `2Q>4` intersections with `K_0` would force it to equal `K_0`; its `Q>4` intersections with
`K_1` would then force `K_1=K_0`, a contradiction. Hence the `[N,3,N-2]` code is non-GRS, and so is
its dual because the dual of a GRS code is GRS.

C336 supplies an independent algebraic distinguisher. The Schur square of the dimension-three code
is the degree-two evaluation code and has dimension six, because quadratic evaluation on `A` is
injective. A dimension-three GRS code of length at least five has Schur-square dimension five. Thus

```text
dim(C star C)=6 rather than 5                              (14)
```

is a basis-free, monomial-invariant non-GRS certificate computable from the input matrix in linear
time for fixed dimension. It distinguishes GRS from this family but, unlike the heavy-conic
fingerprint, does not reconstruct the layers.

## Recognition algorithm and exact output

```text
LayeredRecover(M):
  projectivize the N nonzero columns
  find and verify all conics with support >12 by the five-point sampler
  require support multiset {2Q,Q,Q} and the common-point/common-tangent pencil
  put the pencil in coherent form (5)
  require the two seed parameter sets to be one common affine F-line
  split the doubled support into exactly two cosets of that line
  normalize by (7)--(8), verify (9), and return I(A), the layers, H, and (14)
```

Malformed columns, repeated projective points, wrong support sizes, a fourth heavy conic, failure of
the pencil condition, unequal seed domains, a non-`F` additive line, or failure of the two-coset split
is a rejection certificate. When MDS status is not promised, checking all `3 x 3` minors would be
cubic; the recognizer instead verifies the family fingerprint and may separately consume an MDS
certificate. C329's theorem supplies MDS status for the admitted promise family.

## Source-level literature matrix

The two named 2025--2026 papers were read in full from the shared cache. Exact-title, forward-
citation, non-GRS recognition, Schur-square, structured-code recovery, and code-equivalence searches
were run on 2026-07-18. The four-day-old Li--Yuan paper has no meaningful forward-citation window.
No exhaustive MathSciNet/zbMATH subscription closure was available, so this report makes no global
priority claim for the phrase “orbit-union code.”

| source | exact overlap and boundary | C337 verdict |
|---|---|---|
| Wang--Liu--Luo, [*New Constructions of Non-GRS MDS Codes, Recovery and Determination Algorithms for GRS Codes*](https://arxiv.org/abs/2512.02325), arXiv v1, cached SHA-256 `3cba91d...d40720` | Section 6 recovers GRS locators and multipliers from an echelon generator and tests GRS identity in `O(nk+n)` after row reduction. Its construction uses Cauchy-matrix conditions and lengths near half the alphabet; it neither recognizes a union of three conic supports nor recovers C314 invariants. | `SURVIVES`, narrowly: expected-linear family-specific recovery is not novelty of linear-time GRS testing. |
| Li--Yuan, [*Cyclic Projective Orbits on Rational Normal Curves and MDS Codes*](https://arxiv.org/abs/2607.12761), v2, cached SHA-256 `62cbc886...07c81` | A Krylov parity-check matrix is one ordered orbit segment of one cyclic operator. Their rigidity theorem characterizes when it lies on a rational normal curve, and they explicitly separate operator-cyclic from coordinate-cyclic codes. C337 uses four complete orbits of the noncyclic elementary-abelian group `F^+` and proves that their union is not on a conic. | `NARROW`: the exact four-orbit theorem survives; “group-orbit codes” or orbit language itself is not claimed new. |
| Bouyukliev--Bouyuklieva, [*About Code Equivalence -- a Geometric Approach*](https://arxiv.org/abs/2202.02086), and Kreuzer, [*Code Equivalence, Point Set Equivalence, and Polynomial Isomorphism*](https://arxiv.org/abs/2511.06843) | These establish the general code/projective-point-set equivalence viewpoint and general equivalence algorithms/reductions. They do not use a heavy-conic fingerprint or reduce this family to three scalars. | `SURVIVES` for the exact intrinsic reduction; `STOP` for novelty of translating code equivalence into projective equivalence. |
| Sidelnikov--Shestakov and later Schur-square/structured-code cryptanalysis, as summarized and compared in Wang--Liu--Luo Section 6 | GRS structure can be recovered and low Schur-square dimension is a classical distinguisher. | `STOP` for generic GRS distinguishing; `SURVIVES` for the six-dimensional square as an independent certificate attached to the recovered C329 geometry. |

No searched source contained the exact `2Q,Q,Q` heavy-conic signature, its split into four common
`F^+` orbits, or the invariant (1). Search absence is not the proof of novelty: the defensible result
is the exact theorem above, conditional on the new C329 family, with the general projective-system,
GRS, Schur-square, and orbit-code mechanisms credited separately.

## Evidence and trusted boundary

This is a proof-only recognition theorem. Its load-bearing facts are Bezout's four-point conic
intersection bound, the five-point conic theorem for arcs, the affine stabilizer of a common-tangent
conic pencil, elementary arithmetic of the unique quadratic extension `E/F`, and C314/C329/C336.
There is no generated census, random sample, timing claim, or untracked computational artifact.
The sampler analysis proves an exact Las Vegas expectation; it does not claim a measured runtime.

The trusted input boundary is important. The algorithm reconstructs and verifies the intrinsic
layered normal form. It does not infer the deleted prescribed conic, recover C329's historical
Chebotarev witness, certify a paper-wide novelty claim, or give a deterministic expected-linear
replacement for random five-point sampling.

## Vibe check

Strong and clean: the conspicuous `2Q,Q,Q` low-degree fingerprint turns an unlabelled matrix into a
complete three-scalar equivalence invariant, and the doubled carrier really does split intrinsically
into two additive orbits. The only losses are honest ones—the prescribed-conic height is genuine
marking data, and deterministic linear recognition remains open.
