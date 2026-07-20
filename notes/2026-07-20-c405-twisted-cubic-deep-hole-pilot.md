# C405 — twisted-cubic deepest-syndrome pilot

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `BOUNDED NEGATIVE FOR THE TWISTED-CUBIC TARGET; POSITIVE HERMITIAN–CAYLEY-OCTAD FREE UPGRADE`

**Literature depth:** one source was read in full, nine at stated partial depth, and two at
abstract/metadata depth.  This report makes no novelty or priority claim.

## The bounded theorem

Let `A` be a seven-arc in `PG(3,q)`, represented by the columns of a `4 x 7` matrix, and let

```text
U(A) = PG(3,q) \ union_{B in binom(A,3)} plane(B).
```

Thus `U(A)` is exactly the projective locus of weight-four syndromes of the codimension-four
projective MDS code with parity-check system `A`.  Equivalently, its points are precisely the
one-column MDS extensions of `A`.

Suppose that `A` is non-GRS, `U(A)` is nonempty, and `U(A)` is contained in the rational point set
of a twisted cubic.  Then no such `A` exists over any finite field.

This is an exact theorem for the first possible non-GRS parent length, not a claim for parent lengths
eight or larger.  It does not classify arbitrary codimension-four deep holes, arbitrary varieties in
`PG(3,q)`, or simultaneous multi-column extensions.

## Why length seven and all fields reduce to a finite search

Ball--Lavrauw Lemma 5 states that, when `|F|>=k+1`, every `(k+2)`-arc in `PG(k-1,F)` lies on a
unique normal rational curve.  Taking `k=4`, every six-arc in `PG(3,q)` for `q>=5` is therefore GRS.
Hence seven is the first parent length at which a non-GRS example can occur.

If `U(A)` is contained in a twisted cubic `T`, every point outside `T` is covered by one of the
`binom(7,3)=35` triple planes of `A`.  Since

```text
|PG(3,q) \ T| = q^3+q^2
```

and a plane has `q^2+q+1` points, necessarily

```text
q^3+q^2 <= 35(q^2+q+1).
```

The inequality fails for every integer `q>=36`, so `q<=35`.  The complete prime-power list compatible
with a seven-arc is therefore

```text
q = 5,7,8,9,11,13,16,17,19,23,25,27,29,31,32.
```

This is a theorem-level bound, not a computational cutoff.

## The finite quotient

Deleting any point of a seven-arc leaves a six-arc on a unique twisted cubic.  Normalize that cubic
to

```text
(x:z) |-> (x^3:x^2 z:x z^2:z^3)
```

and quotient its six-point subsets by `PGammaL_2(q)`.  Fixing `0,1,infinity` leaves exactly
`binom(q-2,3)` normalized presentations; canonicalization over all 120 ordered parameter frames and
all Frobenius powers is exhaustive.  Across the fifteen fields this gives 17,854 presentations and
202 semilinear six-set classes.

For each class the checker enumerates exactly the points `y` outside its twenty triple planes.  These
are precisely the seventh points for which `A+y` remains an arc.  For each of the fifteen old pairs,
the points are grouped by their common plane through that pair; bitset union then computes

```text
U(A+y) = U(A) \ union_{a,b in A} plane(a,b,y).
```

The filters are necessary and exact, in this order:

1. `U(A+y)` is nonempty and has at most `q+1` points;
2. it is in linear general position through rank four;
3. the seven-point parent is non-GRS; and
4. the locus lies on one twisted cubic.

The last two tests use Gale duality and ordinary GRS duality: a seven-arc in `PG(3,q)` is GRS exactly
when its three-dimensional Gale transform is a seven-arc on a nonsingular conic in `PG(2,q)`.  Six
linearly general points determine a unique twisted cubic, so for a longer locus it is enough to test
the first six together with every remaining point by the same Gale-conic criterion.

## Exact census

| `q` | six-set classes | seventh-point tests | nonempty locus | `|U|<=q+1` | linearly general | non-GRS at final curve gate | survivors |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 5 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| 7 | 1 | 2 | 2 | 2 | 2 | 0 | 0 |
| 8 | 1 | 10 | 3 | 3 | 3 | 0 | 0 |
| 9 | 2 | 64 | 64 | 64 | 16 | 8 | 0 |
| 11 | 4 | 490 | 490 | 481 | 0 | 0 | 0 |
| 13 | 5 | 1,648 | 1,648 | 0 | 0 | 0 | 0 |
| 16 | 4 | 3,802 | 3,802 | 0 | 0 | 0 | 0 |
| 17 | 10 | 12,682 | 12,682 | 0 | 0 | 0 | 0 |
| 19 | 13 | 27,264 | 27,264 | 0 | 0 | 0 | 0 |
| 23 | 22 | 103,768 | 103,768 | 0 | 0 | 0 | 0 |
| 25 | 19 | 125,462 | 125,462 | 0 | 0 | 0 | 0 |
| 27 | 14 | 125,108 | 125,108 | 0 | 0 | 0 | 0 |
| 29 | 42 | 494,184 | 494,184 | 0 | 0 | 0 | 0 |
| 31 | 51 | 772,138 | 772,138 | 0 | 0 | 0 | 0 |
| 32 | 13 | 221,590 | 221,590 | 0 | 0 | 0 | 0 |
| **total** | **202** | **1,888,212** |  |  |  |  | **0** |

The unique near-miss orbit occurs over `F_9`.  Its parent/locus pair has semilinear stabilizer order
42 and its eight-point deepest locus is linearly general, but neither of the two seven-subsets
formed from a fixed six-point base lies on a twisted cubic.  Thus this is a sharp curve-containment
failure, not a size or parent-GRS rejection.

## Free upgrade: the near miss is a Hermitian Cayley octad

The requested alternate-attack pass turns that failure into an exact positive structure theorem.
For the unique `F_9` orbit, let `X=U(A)`.  Direct quadratic evaluation has rank seven, so the
quadrics through `X` form a three-dimensional net, and their common `F_9`-rational projective locus
is **exactly** `X`.  Independently, the weighted self-duality calculation below makes the regular
octad Gale-self-dual, so the classical equivalence in van Bommel et al. proves that `X` is a Cayley
octad over the algebraic closure.  It is also a complete eight-arc: applying the same deepest-locus
transform again gives `U(X)=empty`.

In coefficient order

```text
x0^2,x1^2,x2^2,x3^2,x0x1,x0x2,x0x3,x1x2,x1x3,x2x3,
```

one exact basis of the quadric net is

```text
(8,4,7,0,2,7,0,1,0,0)
(1,2,0,6,8,0,7,0,1,0)
(1,0,2,3,0,8,1,0,0,1).
```

The determinant of its symmetric matrix pencil is the following six-term quartic, recorded
canonically by exponent triple to avoid field-encoding ambiguity:

```text
((0,1,3),8), ((0,3,1),5), ((1,0,3),6),
((1,3,0),3), ((3,0,1),3), ((3,1,0),6).
```

Writing this as `(x^3,y^3,z^3) H (x,y,z)^T`, its matrix is

```text
H = ((0,6,3),(3,0,5),(6,8,0)).
```

The checker proves `H=H^(3T)` and `det(H)=2`, so this is a nonsingular Hermitian quartic over
`F_9`, not merely a quartic with the same point count.  It has exactly 28 rational points.  The 91
rational quadrics in the net split into 28 rank-three singular quadrics and 63 rank-four quadrics,
with none of rank at most two.  Classical Cayley-octad theory identifies the 28 pairs of octad
points with the quartic's 28 bitangents; the matching count of 28 singular net members gives the
natural next incidence dictionary to test.

The code-side upgrade is equally rigid.  The ten equations

```text
G diag(w) G^T = 0
```

have a one-dimensional kernel, represented in the certificate by a full-support vector all of
whose entries are squares in `F_9`.  Thus the diagonal weight class is unique up to overall scalar,
and column rescaling makes the non-GRS `[8,4,5]_9` MDS code Euclidean self-dual; choices of square
roots differ by coordinate signs.  This is the coordinate form of the classical Gale-self-duality
criterion for Cayley octads.

Finally, `X` has projective stabilizer 168 and semilinear stabilizer 336, while the marked
parent/locus pair has semilinear stabilizer 42.  Orbit-stabilizer gives exactly eight conjugate
parent decorations above the same octad.  The numerical identity `6048/168=36` is consistent with
the Hermitian quartic's unitary group and the classical 36 determinantal representations of a
smooth quartic, but transitivity is not claimed here without a dedicated group-action proof.

### Alternate attacks assessed

- **Quadric net + discriminant:** succeeds and yields the Hermitian carrier, 28 singular quadrics,
  and the bitangent route above.
- **Gale duality:** succeeds twice: it remains the exact GRS gate, and classical Gale self-duality
  conceptually explains the octad/self-dual-code certificate.
- **Automorphism/orbit-stabilizer:** succeeds, replacing an isolated near miss by an exact
  eightfold parent-decoration fiber with a 168-element projective symmetry group.
- **C403 coboundary/adjoint machinery:** useful for symbolic complement counts at later lengths,
  but it is not a free replacement for this census.  The intersection lattice of the 35 triple
  planes is realization-dependent, so computing its characteristic/coboundary polynomial would
  repackage rather than eliminate the small-field classification.
- **Hermitian/bitangent and AME routes:** genuinely opened.  The focused next experiment is the
  28 singular-quadric/28-pair incidence and recovery of the eight parent decorations; the
  self-dual `[8,4,5]_9` code also supplies a linear stabilizer `AME(8,9)` candidate.  Neither route
  is promoted to a novelty claim by C405.

There is an independent current-literature control.  The explicit q=11 non-GRS `[7,4,4]` projective
system in Li--Lu--Ling--Lam Example 2 has a ten-point deepest locus.  Direct evaluation of its 35
triple planes confirms that the parent is an arc and non-GRS, but the locus is not linearly general
and hence is not contained in a twisted cubic.

## Exact evidence and replay

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-20-c405-twisted-cubic-deep-hole-pilot.py --check
sha256sum -c notes/2026-07-20-c405-twisted-cubic-deep-hole-pilot.sha256
```

The checker uses only the Python standard library.  Its deterministic polynomial-basis fields are
recorded in the source, and initialization verifies a multiplicative inverse for every nonzero
element.  Projective points use first-nonzero-coordinate normalization; unordered objects are sorted;
the JSON has a fixed schema and canonical serialization.

The bitset calculation has a definition-level independent replay: for one seventh-point extension
in every nonempty six-set class, the checker separately scans all 35 triple planes across all of
`PG(3,q)` and requires the same locus.  This gives 201 direct replays; the q=5 class has no extension
to replay.  The q=9 near miss and q=11 published fixture also use the direct implementation.

The trusted boundary is Python integer arithmetic, the displayed finite-field models, the
six-arc/normal-rational-curve theorem, standard GRS duality, and the short Gale-conic rank test.  The
certificate proves exhaustion only for the stated length-seven, `q<=35` domain.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 28,516 | `0c13485dfd9483b840934c273e09f0a0860de4f6984c164518949256cd47586f` |
| certificate `.json` | 12,741 | `c1d9a0e11b7890c415a18c49a989301101784ae3b4d9931be59a15820c5df692` |

## Literature boundary

The source audit was claim-specific and does not support priority wording.

- **Ball--Lavrauw, _Arcs in finite projective spaces_, arXiv:1908.10772v1: `partial`.** Read the
  normal-rational-curve setup and Lemmas 3--6, including the proof that a `(k+2)`-arc determines a
  unique normal rational curve.  Cache SHA-256
  `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`.
- **Zhang--Wan--Kaipa, _Deep Holes of Projective Reed--Solomon Codes_, arXiv:1901.05445v2:
  `full text`.** All twelve pages were read from cache.  It completely classifies redundancy-four
  PRS deep holes by tangent points and quadratic-conjugate secants for the full twisted-cubic GRS
  parent; it does not classify arbitrary non-GRS seven-point parents.  Cache SHA-256
  `5c2b9e2508c7200428c441b7a41da1596b1c9b0851f5632e2297cdbed41caf24`.
- **Blokhuis--Pellikaan--Szonyi, _The extended coset leader weight enumerator of a twisted cubic
  code_, arXiv:2103.16904v2: `partial`.** Read pages 1--5, covering the introduction, code/projective
  dictionary, and problem statement.  The paper treats the full `[q+1,q-3,5]_q` GRS code and its
  scalar extensions, not a non-GRS parent with a curve-valued complete extension locus.  Cache
  SHA-256 `b406b2170b883eaa427649f93b92965dcac1cfbbaa537bef201bcd7a7bca8297`.
- **Wu--Ding--Chen, _Extended codes and deep holes of MDS codes_, arXiv:2312.05534v1: `partial`.**
  Read the abstract/introduction, Section III, Section VI.A, and Section VII.  Theorem 6 supplies the
  general deep-hole/MDS-extension dictionary; it does not impose twisted-cubic containment.  Cache
  SHA-256 `9fe6878668bafce0ba1eb759f9fee16ab10f77b5520b47eb1c4626aec5f76000`.
- **Li--Lu--Ling--Lam, _A framework for constructing non-GRS MDS-NMDS codes from deep holes and its
  application_, arXiv:2605.12133v1: `partial`.** Read the abstract/introduction, Section III.A,
  Section IV.A, Examples 2--3, and the conclusion.  Its explicit q=11 `[7,4,4]` Example 2 is the
  independently checked negative fixture above.  Cache SHA-256
  `8f854dcb3ad549b8bfdcaac6f585edc9d9516c7ea9674e970f54020657c0fa7d`.
- **Li--Ezerman--Lao--Ling, _Properties and Decoding of Twisted GRS Codes and Their Extensions_,
  arXiv:2508.02382v1: `partial`.** Read the abstract/introduction, the non-GRS MDS results in Section
  III through the stated Schur-square tests, and the conclusion.  Its deep-hole results are
  family-specific and do not classify complete projective syndrome loci.  Cache SHA-256
  `e916bf5d61ce6cf21391ab81e65fd22ad149cec513a6922c6bca2d58f2268b06`.
- **Elsenhans--Jahnel, _On plane quartics with a Galois invariant Cayley octad_,
  arXiv:1710.07279v1: `partial`.** Read Definition 2.3, Remarks 2.4, and Proposition 2.5.  These give
  the unique-net definition and the pair-of-octad-points/28-bitangents correspondence over general
  characteristic not two.  Cache SHA-256
  `37f6dcbeb9f0af668720d44502f004b06705b0b4202ecac487cf10c8bcd07bab`.
- **Plaumann--Sturmfels--Vinzant, _Quartic Curves and Their Bitangents_, arXiv:1008.4104v1:
  `partial`.** Read Section 3 through Proposition 3.3 and the opening of Section 7 through
  Proposition 7.1.  It supplies the symmetric-determinantal/Cayley-octad construction, 28
  bitangents, 36 representation classes, and the fact that seven general octad points determine the
  eighth.  Cache SHA-256
  `2361eabf304218b410bdf5fe7b98f1f5e8a3676ddc2c49e284580123c6310744`.
- **van Bommel--Docking--Dokchitser--Lercier--Lorenzo García, _Reduction of Plane Quartics and
  Cayley Octads_, arXiv:2309.17381v2: `partial`.** Read Section 3.1 through Theorem 3.3.  Its regular
  octad definition and equivalence of Cayley-octad and Gale-self-duality conditions provide the
  conceptual bridge to the self-dual MDS certificate.  Cache SHA-256
  `1ca4b91e0e9daf15527ee922f90a2754d9a7a087f4873a35fc62826f6b12d925`.
- **Ivrissimtzis--Singerman--Strudwick, _From Farey fractions to the Klein quartic and beyond_,
  arXiv:1909.08568v1: `partial`.** Read the abstract and introduction for the characteristic-zero
  Klein quartic and its `PSL(2,7)` automorphism group.  It is context only: C405's determinant is
  proved directly to be Hermitian in characteristic three, and no Klein identification is made.
  Cache SHA-256 `19add730b6811a80b15575c66060e587eee11a6916319f32320bea247740aeef`.
- **Davydov--Marcugini--Pambianco, _Orbits and incidence matrices for points, planes and lines
  regarding the twisted cubic in PG(3,q), q=2,3,4_, arXiv:2604.14628v1:
  `abstract/metadata only`.** The stated fields cannot contain a seven-arc and are outside the
  surviving C405 field list.
- **Wang--Liu--Luo, _New Constructions of Non-GRS MDS Codes, Recovery and Determination Algorithms
  for GRS Codes_, arXiv:2512.02325v1: `abstract/metadata only`.** The abstract concerns construction
  and GRS recognition, not a complete twisted-cubic syndrome-locus classification.

The load-bearing web queries, run 2026-07-20, were:

```text
site:arxiv.org non-GRS MDS codimension four deep holes twisted cubic
site:arxiv.org seven arc PG(3,q) twisted cubic extension MDS deep hole
site:arxiv.org "deep holes" "twisted GRS" MDS
site:arxiv.org "twisted cubic" "deep hole" code
"8-arc" "PG(3,9)"
"complete 8-arc" "PG(3,9)"
"Cayley octad" "F_9"
"[8,4,5]" "GF(9)" code
"PGU(3,3)" "Cayley octad"
"Hermitian quartic" "Cayley octad"
```

No unrestricted absence conclusion is drawn from those searches.  MathSciNet and Google Scholar
were not covered, and no forward-citation closure was attempted because the deliverable is an exact
bounded negative rather than a novelty claim.

## Stop and hand-back

C405 closes the mandated twisted-cubic pilot: the field bound is small, the quotient is complete,
and the target exception list is empty.  The free-upgrade pass found a real but sharply delimited
door—one Hermitian Cayley octad over `F_9`, its eight parent decorations, and its self-dual non-GRS
code—not a reason to launch an unrestricted length-eight or arbitrary-variety census.  Preserve that
door for a focused quadric/bitangent or `AME(8,9)` successor after the existing crowns order; return
now to the crowns lane and continue with C418.
