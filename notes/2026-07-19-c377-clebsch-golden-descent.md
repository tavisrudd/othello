# C377 — Clebsch golden descent

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `BOUNDED NEGATIVE; EXACT CLEBSCH SPECIALIZATION, BUT ONLY STANDARD A5 QUADRATIC DESCENT SURVIVES`

**Literature depth:** one source was read at full-text depth; three further sources were read
partially at the exact sections stated below.  The generic mechanism is directly pre-empted by
Benson, so this report makes no priority claim for golden Galois descent, its trivial obstruction,
or the split/inert/ramified phase.

## Result

Put

```text
O = Z[tau]/(tau^2-tau-1),       sigma(tau)=1-tau,
```

and order the six columns as

```text
P(tau) = ((0,1,1-tau), (0,1,tau-1),
          (1,1-tau,0), (1,tau-1,0),
          (1,0,-tau), (1,0,tau)).
```

There is an exceptionally small integral conjugate-fibre map

```text
           [ 1  0  0 ]
J(tau) =  [ 0  0 -1 ],          J(x,y,z)=(x,-z,-y),
           [ 0 -1  0 ]
```

with label permutation

```text
pi = (0 1)(2 4)(3 5).
```

More precisely,

```text
J P_i(tau) = lambda_i P_pi(i)(1-tau),
lambda = (tau-1, 1-tau, 1, 1, 1, 1).
```

The matrix is fixed by `sigma`, has determinant `-1`, and satisfies the normalized cocycle
identity

```text
sigma(J) J = I.
```

Exact frame exhaustion over `Q(tau)` gives 60 same-fibre equivalences, all even on the six labels,
and 60 conjugate-fibre equivalences, all odd.  Together they form the order-120 normalizer.  The
outer coset has cycle-type distribution

```text
10 x (2,2,2),       30 x (4,1,1),       20 x (6).
```

Thus there are ten involutive outer label maps; the displayed `J` is one integral datum whose
cocycle is already exactly normalized.  The two `A5` orbits on three-subsets have sizes `10+10`,
and `pi` exchanges them.

For every triple `I={i,j,k}`, the checker proves the exact Pluecker relation

```text
det(J) Delta_I(tau)
  = sign(pi|I) lambda_i lambda_j lambda_k Delta_sort(pi(I))(1-tau).
```

All twenty relations are written to the canonical certificate.  On the cubic surface, `J` acts
on the marked Picard lattice by

```text
H -> H,       E_i -> E_pi(i),       Q_i -> Q_pi(i).
```

It preserves the two rows of the distinguished double-six separately and preserves all 135
intersecting pairs among the 27 lines.  This is not the row-exchanging quintic contraction of
C376.  What agrees with C376 is exactly the nontrivial quotient character in `S5/A5`, not an
identification of the two geometric maps.

The column identity gives a monomial equivalence of the two `[6,3,4]` codes and an equivalence of
their syndrome-direction schemes.  It exchanges the intrinsic `10+10` chirality torsor.  At
`q=11`, reducing `tau` to `8` and `4` gives one of C376's 60 outer cross-fibre projectivities.
At the ramified prime five, `tau=3`, the two fibres coalesce, all six points lie on
`X^2+Y^2+Z^2=0`, and the projective stabilizer grows from `A5` of order 60 to order 120; `J` is
then an internal linear outer element.  At an inert odd prime, `J` followed by Frobenius is a
semilinear involution with the same outer label class.  At a split odd prime, `J` exchanges the
two linear fibres.

## Why the crown gate stops

The preceding identities are exact and useful, but their descent content is not a new mechanism.
Benson's 2024 theorem treats precisely a three-dimensional irreducible `A5` representation over
`Q(sqrt(5))`, Galois conjugation, and an outer involution from `S5`.  Benson constructs the
intertwiner, proves the relevant relative-Brauer invariant is trivial, and obtains an
outer-compatible model by Hilbert 90.  The displayed `J` gives a much cleaner matrix in this
Clebsch six-arc basis, and the Pluecker/double-six/code specialization is not stated there, but the
task's required non-generic descent phase does not survive source comparison.

Accordingly:

- the generic golden intertwiner and `lambda=1` obstruction are prior art;
- split, inert-semilinear, and ramified-linear specialization of that datum is standard quadratic
  descent;
- the exact six-arc, Pluecker, marked-double-six, code, and q=11 identification survive as a
  narrow Clebsch-specific corollary; and
- C377 takes its mandated stop rather than promoting this corollary as Door II or as a paper
  flagship.

## Exact evidence

From `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-19-c377-clebsch-golden-descent.py --check
python3 notes/2026-07-19-c377-clebsch-golden-descent-replay.py
sha256sum -c notes/2026-07-19-c377-clebsch-golden-descent.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-19-c377-clebsch-golden-descent.py --write
```

The primary checker uses exact `Fraction` arithmetic in `Q(tau)`, exhausts all `6!` frame maps,
checks the 20 Pluecker coordinates, the 27-line incidence action, and the q=11/q=5 finite
specializations.  It is deterministic, standard-library-only under Python 3.13.12, and has no
random seed.  The independent replay imports no primary code.  It separately checks the integral
matrix identities and Pluecker ledger, reimplements the finite-field frame exhaustion at q=11 and
q=5, and reconstructs the 27-line incidence count.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker `.py` | 18,635 | `3ade7a69a34f5fcd779f7ee11f3d2bfd040f09c7b74d0e8a5368e6fdd1e419af` |
| independent replay `.py` | 7,158 | `555b88c9c58c97ce2c87a6b981d3ef56c37f73f282fd40c8a8e69e168eb76c0e` |
| canonical certificate `.json` | 10,615 | `f8eceefe8259f684a7264be15ee969aa38cf4f744e582d48ac77a5da9dc85b58` |

The trusted boundary is exact arithmetic, exhaustive finite permutation/frame enumeration, and
the standard blow-up formula for the 27 line classes.  The artifact does not construct a general
cubic-surface model over `O`, formalize descent in Lean, or prove a new representation-theoretic
descent theorem.  The all-prime prose conclusion uses the elementary splitting classification of
`x^2-x-1`; the finite replay samples q=11 and q=5 rather than enumerating all primes.

## Source-level and forward-citation audit

### Direct sources

1. **David J. Benson, “Matrices for finite group representations that respect Galois
   automorphisms,” DOI `10.1007/s00013-023-01963-x`, arXiv `2306.06280`.**
   **Read depth: full text.**  The cached arXiv v1 PDF was read in full, including Theorem 1.1,
   Sections 2--4 on the matrix norm, Brauer invariant, Hilbert 90, and induced representation,
   and Section 5's explicit `A5` example.  Cache key `arXiv:2306.06280`, SHA-256
   `ff4e87f6f718a16c3f757a5add525f8ce0a131419089382e9c8c09491ab17f85`.
   This source directly pre-empts the generic C377 mechanism and proves `lambda(rho)=1` for the
   golden three-dimensional `A5` representation.
2. **Yuri Prokhorov, “Icosahedron in birational geometry,” arXiv `2411.15334v2`, published as
   DOI `10.1134/S1061920824601800`.**  **Read depth: partial.**  The cached preprint Sections
   3.1, 3.1.3, and 3.2 were read: they identify the two three-dimensional representations as
   outer-related and state that the two `A5`-equivariant Clebsch contractions are exchanged by
   `S5-A5`.  Cache key `arXiv:2411.15334`, SHA-256
   `59ce9cc76cbc374371465a1c193140740dee3225fd2a65d8a83dc8d9517c8360`.
   It supplies the classical surface boundary, not the arithmetic specialization.
3. **Barry Monson and Egon Schulte, “Modular Reduction in Abstract Polytopes,” arXiv
   `0805.1479`.**  **Read depth: partial.**  The cached text's golden-ring prime-classification
   passage and the split-conjugate discussion in the `[3,5,3]` reduction section were read.
   Cache SHA-256 `149eeb36d30adc3cba20813bc7dad33d7a42cc0f39de0f3f3b9e6ab501c019ee`.
   It owns the standard `Z[tau]` prime arithmetic in a Coxeter-reduction setting; it does not
   state the Clebsch six-arc/double-six map.

### Forward citations of the pre-empting source

The seed was pinned by DOI `10.1007/s00013-023-01963-x`.  On 2026-07-19 the exact queries were:

```text
https://api.openalex.org/works/doi:10.1007/s00013-023-01963-x
https://api.crossref.org/works/10.1007/s00013-023-01963-x
https://api.semanticscholar.org/graph/v1/paper/DOI:10.1007/s00013-023-01963-x?fields=paperId,title,citationCount,citations.title,citations.year,citations.externalIds
```

OpenAlex resolved the seed to `W4392348291` and reported one citation.  Crossref reported
`is-referenced-by-count=1`.  Semantic Scholar resolved it to
`5f091b40cd50455ffe7d9aeb8a59a8fbf849ba9a` and also reported one citation.  Nonempty JSON with
the pinned title distinguished success from an empty result or service error.  The largest set
therefore had one member, screened over title and full returned metadata:

- **Gabriele Nebe et al., “Unitary discriminants of characters,” arXiv `2411.06235`, DOI
  `10.1016/j.jalgebra.2025.12.008`.**  **Read depth: partial.**  The theorem-9.1 discussion that
  invokes Benson's Proposition 4.2 and main result was read, together with the reference entry.
  Cache key `arXiv:2411.06235`, SHA-256
  `fb5ac37ac10e25983e1ecc57f58c9119edaaf31a09b75a46d8321e861689565b`.
  It uses Benson's general crossed-product/descent result and contains no Clebsch, six-arc,
  double-six, or finite-field specialization.

The load-bearing discovery queries were, verbatim:

```text
A5 three dimensional representations Galois conjugate outer automorphism sqrt 5 paper
Clebsch cubic double six A5 Galois descent golden ratio
icosahedral representation quadratic field semilinear outer automorphism A5
"golden" "double-six" Clebsch cubic
```

Springer metadata and the zbMATH-linked MaRDI record `7826769` were checked at
**abstract/metadata-only** depth for Benson.  Automated Google Scholar access was unavailable.
MathSciNet was not institutionally accessible and is **NOT COVERED**.  The direct pre-emption means
those gaps do not weaken the bounded-negative decision, but they prohibit any “first” or “to our
knowledge” claim for the surviving exact specialization.

## Hand-back

C377 closes Door II at its red off-ramp.  C378 and C379 remain independent bounded falsifiers;
neither may cite C377 as a new arithmetic crown.  C380 may use the displayed integral identity as
a small specialization lemma only if useful, while crediting Benson for the general descent
mechanism and keeping C376's quotient-character theorem as the substantive gateway result.

The unallocated companion
`notes/2026-07-19-c377-frobenius-chirality-companion.md` records the strongest creative question
left by the stop: recover the quadratic Frobenius character intrinsically from the unmarked
code/syndrome graph and compare its `H^1` chirality torsor with Benson's trivial linear obstruction
and the double-six Brauer class.  It does not reopen C377 or alter the C378--C380 order.

The second unallocated companion
`notes/2026-07-19-c377-integral-moduli-companion.md` globalizes that question: construct the integral
orientation cover of the `A5` six-arc locus, determine its normalization, discriminant, bad fibers,
and forgetful descent spectrum, and make the Frobenius law a consequence of one intrinsic moduli
object.  It likewise does not reopen C377 or alter the live order.
