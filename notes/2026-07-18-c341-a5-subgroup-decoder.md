# C341 — all-field `A5/D5` orbit MDS code and syndrome association scheme

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `THEOREM; EXACT CHARACTERISTIC-5 GRS BOUNDARY; RANK-8 DECODER SCHEME`

## Theorem

Put `O=Z[tau]`, where `tau^2=tau+1`, and take the six fivefold points of the standard
projectivized `H3` arrangement in the ordered normalization

```text
(0,1,1-tau), (0,1,tau-1),
(1,1-tau,0), (1,tau-1,0),
(1,0,-tau),  (1,0,tau).
```

Let `P` be any odd prime ideal of `O`, let `k=O/P`, and use these six reduced columns as a
parity-check matrix. Then:

1. the columns are the transitive `A5/D5` orbit of the faithful projective `A5` supplied by
   C346, every three columns are independent, and their kernel is an `[6,3,4]_|k|` MDS code;
2. in the quadratic monomial order `X^2,Y^2,Z^2,XY,XZ,YZ`, the six-by-six evaluation
   determinant is exactly

   ```text
   16(3*tau-4),             Norm = -1280 = -2^8*5;
   ```

3. among odd lattice-good reductions, the code is GRS exactly in characteristic five and is
   non-GRS in every other characteristic; and
4. at an inert rational prime `p congruent to +/-2 mod 5`, this is an orbit code over
   `F_(p^2)`, not over `F_p`. Frobenius sends `tau` to `1-tau` and does not preserve the displayed
   six-set: already on the `X=0` pair, preservation would force `tau=1-tau`, hence characteristic
   five. More invariantly, C346 proves that `PGL_3(F_p)` has no subgroup of order divisible by
   five, so the marked faithful `A5` orbit has no `A5`-equivariant prime-field descent. This does
   not rule out forgetting the action and seeking an unrelated twisted descent of the unmarked
   code.

The MDS assertion is integral: the twenty three-by-three minors have norm `+/-4`, ten of each.
Thus they survive every odd prime ideal. The orbit has size six, so its point stabilizer in `A5`
has order ten and is `D5`.

For a six-arc in `PG(2,k)`, the corresponding dimension-three MDS code is GRS precisely when the
six points lie on a nonsingular conic. The displayed determinant is the conic-incidence test.
Its only odd prime-ideal divisor lies over five. At that ramified prime `tau=3`; the determinant
vanishes, and the resulting quadric cannot split into two lines because a six-arc meets each line
in at most two points. It is therefore a nonsingular conic. Away from `(2)` and the prime over
five, the determinant is nonzero and no conic contains the orbit. C346 is essential here:
characteristic five is lattice- and group-good, so this GRS collapse is a code boundary rather
than bad reduction.

## Exact subgroup dictionary

The four distinguished projective `A5` sets are not merely cardinality matches:

| geometry/code object | transitive `A5` set | stabilizer | size |
|:---|:---|:---|---:|
| six parity-check columns / fivefold axes | `A5/D5` | `D5` | 6 |
| ten Brianchon triple-ambiguity points | `A5/S3` | `S3` | 10 |
| fifteen secants / reflections | `A5/V4` | `V4=C_A5(t)` for an involution `t` | 15 |
| twelve projective deep-hole directions | `A5/C5` | `C5` | 12 |

An involution belongs to exactly two of the six `D5` normalizers; these are the endpoints of its
secant. Each `D5` contains five involutions, giving the five secants through a column. An `S3`
contains three involutions, and their three secants concur at the corresponding triple point.
The incidence counts are `6*5=15*2` and `10*3=15*2`, so the containments recover every endpoint
and triple-concurrence incidence. The complement of the fifteen secants is the `A5/C5` orbit at
`q=11`, agreeing with C339's deep-hole interpretation.

The induced `A5` action on the twenty three-subsets of the six columns has exactly two orbits of
size ten. Thus the **marked** subgroup geometry recovers the unordered support-chirality torsor.
It does not canonically name one of the two classes, and this report does not claim C207's stronger
unmarked-code obstruction theorem.

## The q=11 syndrome association scheme

Let `V=F_11^3` be the affine syndrome space and

```text
H = F_11^* x A5 <= GL(V),        |H|=600.
```

The scalar closure is the linear syndrome action induced by the code's monomial automorphisms.
Its orbits on `V` are, in the certificate's fixed order,

| relation class | valency | point stabilizer in `H` |
|:---|---:|:---|
| zero | 1 | `H` |
| column | 60 | `D5` |
| triple ambiguity | 100 | `S3` |
| deep hole | 120 | `C5` |
| double ambiguity | 150 | `V4` |
| ordinary single-secant I | 300 | `C2` |
| ordinary single-secant II | 300 | `C2` |
| ordinary single-secant III | 300 | `C2` |

The stabilizer identifications are certified by their complete element-order distributions, not
inferred from orbit sizes. For example the order-ten stabilizer has distribution
`1^1,2^5,5^4`, while the order-six stabilizer has `1^1,2^3,3^2`.

For each orbit `O_i`, define a relation on `V` by

```text
R_i = {(x,y) : y-x in O_i}.
```

Translation by `V` and the action of `H` make these the orbitals of `V semidirect H`. Since
`-1 in H`, all eight relations are symmetric. Direct enumeration proves that they form a
commutative rank-eight association scheme. The JSON certificate records every intersection
number

```text
p_ij^k = |{z : z-x in O_i, y-z in O_j}|,   y-x in O_k,
```

as eight `8 x 8` matrices, verifies independence from the chosen `(x,y)`, checks all valency
identities, and checks the full associativity identities. This is the promised coherent
configuration, in the stronger homogeneous form of an association scheme.

### Orbit-compressed decoder

For a received word, compute its syndrome `s`. A precomputed transporter in `H` sends `s` to the
fixed representative of one of the eight classes. The corresponding monomial code automorphism
transforms the received symbol likelihoods (coordinate permutation plus field-symbol relabelling),
so an exact hard, list, or soft decoder for that one representative pulls back to an exact decoder
for `s`. Only eight representative decoder templates are needed, rather than 1,331 syndrome
templates. This is an equivalence reduction, not a claim that maximum-likelihood decoding itself
has constant cost.

The intersection algebra adds a second compression unavailable from the old `H3` multiplicity
census: any class-invariant error distribution or iterative syndrome transition can be convolved
in the eight-dimensional Bose--Mesner algebra using the certified `p_ij^k`, without returning to
all 1,331 states. The three 300-point relations refine the identical unique-nearest-leader stratum,
so the scheme retains symmetry information that the classical arrangement ambiguity count loses.

### Separability boundary

This report does **not** prove that the scheme is separable, i.e. uniquely determined up to
isomorphism by its intersection numbers. The Chen--Ponomarenko TI-stabilizer criterion does not
apply because nonzero syndrome stabilizers are nontrivial, and the Hirasaka--Kim--Ponomarenko
quasiregular criterion does not apply to this affine action. The exact tensor is now a compact
input for a future algebraic-isomorphism classification, but computing it is not itself a
separability proof.

## Cyclic/Krylov falsifier

At `q=11`, the checker tests all `6!=720` orderings. For each ordering it constructs the unique
projectivity carrying the first four points to the next four and tests the fifth transition.
Exactly zero orderings are length-six projective Krylov orbit segments.

This does not say that non-GRS MDS orbit codes cannot be cyclic in general. Li--Yuan classify
single-operator Krylov segments and prove that their GRS locus is the symmetric-power `PGL_2`
locus. C341's set is instead the full transitive orbit of the nonabelian group `A5` on `A5/D5`;
the zero test certifies that this example lies genuinely outside their cyclic construction.

## Reproduction and trusted boundary

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-18-c341-a5-subgroup-decoder.py --check
sha256sum -c notes/2026-07-18-c341-a5-subgroup-decoder.sha256
```

The standard-library-only checker uses exact `Z[tau]` arithmetic for all minors and the conic
determinant. At `q=11` it constructs the same projective group independently (a) from the fifteen
reflections and (b) by testing all 720 permutations of the six-arc, and requires the two 60-element
matrix sets to agree. It then exhausts all 1,331 affine syndromes and every entry of the
intersection tensor. A separate `F_9` calculation checks all twenty arc minors and the failure of
Frobenius preservation in the first inert case.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 16,801 | `4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be` |
| certificate `.json` | 10,557 | `f14e3cafbb2d51df7d3595c4ba4193786cef1eaa046029af36613f775fabcc6e` |

The trusted boundary is Python 3 integer arithmetic, exhaustive finite enumeration, the elementary
prime-ideal norm argument, and C346's independently certified all-odd-prime lattice/group theorem.
The artifact does not formalize the result in Lean, classify twisted descent of the unmarked inert
code, prove separability, or benchmark a decoder implementation.

## Source-level literature matrix

| source | exact overlap | C341 boundary and verdict |
|:---|:---|:---|
| Li--Yuan, [*Cyclic Projective Orbits on Rational Normal Curves and MDS Codes*](https://arxiv.org/abs/2607.12761) | Classifies when a single-operator MDS Krylov segment lies on a rational normal curve and gives split/nonsplit/unipotent finite-field GRS families. | `SURVIVES`: C341 is a nonabelian full-group orbit, has zero Krylov orderings, and proves its GRS boundary by a different orbit determinant. The arc--MDS and conic--GRS dictionaries are credited. |
| Edge, Dye, Calvo, and the C211 audit | Own the icosahedral six axes, fifteen mirrors, `6_5,10_3,15_2` lattice, and characteristic-zero `A5/H3` geometry. | `NARROW`: none of the `6,10,15,12` relabelling is new. The surviving result is the all-field orbit-code boundary plus the syndrome transition algebra. |
| Jurrius--Pellikaan, as audited by C211 | Derived arrangements already determine syndrome weight and list/coset-leader multiplicities for planar MDS codes. | `NARROW`: C341 does not claim the arrangement--decoder dictionary. Its new decoder data are the three ordinary-orbit refinement and all 512 transition numbers. |
| Tranchida, [*Triples of involutions in `PGL(2,q)` and their incidence geometries*](https://arxiv.org/abs/2411.10299) | Relates triples of involutions in conic-stabilizing `PGL_2` to rank-three coset geometries and hypertopes. | `SURVIVES WITH SEPARATION`: it neither constructs this six-column `A5/D5` MDS orbit nor the affine syndrome association scheme. The involution/incidence language is prior art. |
| Lu--Zhou, [*On the equivalence of NMDS codes*](https://arxiv.org/abs/2509.25645) | Uses stabilizer orbits of arcs/hyperovals to decide monomial equivalence of added-point NMDS constructions. | `SURVIVES`: C341 concerns an MDS parent and exact syndrome-orbit transitions, not equivalence classes of NMDS point extensions. Stabilizer-orbit methodology is credited. |
| Li--Huang, [*Polar Orbit Decoding*](https://arxiv.org/abs/2601.11373) | Uses binary code automorphism orbits to run parallel soft decoders after polar transformation. | `SURVIVES WITH APPLICATION NARROWING`: automorphism-aided soft decoding is not new. C341 supplies a nonbinary exact eight-template syndrome quotient and its Bose--Mesner transition algebra; no latency or error-rate advantage is claimed without implementation. |
| Chen--Ponomarenko and Hirasaka--Kim--Ponomarenko separability programmes | Give separability results under TI or quasiregular hypotheses. | `OPEN BOUNDARY`: their stated hypotheses do not cover this scheme, so C341 records no separability claim. |

Full texts read from the verified cache:

```text
arXiv:2607.12761  sha256 62cbc8862c21c2bc2fb2fb6c07f36862e0122a23a4731a8ef01f5648cce07c81
arXiv:2411.10299  sha256 3cf7c453735ab0c6be28e074a4be85d4a3ae4e03d0fc408e7e7d77966aa62656
arXiv:2509.25645  sha256 556af2d909c7c927ef6bef986fce7353d1ede087b0d2974ce0104814eeebf176
arXiv:2601.11373  sha256 ddf833e0921817ecc42d44cc86c225424e121846efc85e31607b3ea2674feaa7
```

Targeted current searches found no collision with the exact determinant boundary or the rank-eight
syndrome intersection algebra. This is a bounded source audit, not a universal priority claim.

## Ownership and hand-back

- C346 remains the owner of arithmetic good reduction; C341 consumes its theorem unchanged.
- C339 remains the owner of the `H3` complement transform and inverse code theorem.
- C207 remains the owner of intrinsic chirality from the unmarked code. C341 hands back only the
  marked `A5` two-orbit torsor.
- The Clebsch manuscripts and checkers remain read-only.
