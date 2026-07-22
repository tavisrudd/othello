# Clebsch factorization-memory paper: abstract and outline

**Lane:** `clebsch`

**Date:** 2026-07-21

**Status:** copy-ready planning draft for the selected C406+C411 replacement spine.  This file
contains exposition architecture, not a manuscript edit.  The exact result allocation is governed
by `2026-07-20-clebsch-paper-planning.md` and
`2026-07-21-clebsch-weil-roof-results-ledger.md`.

## Working title

**Factorization memory in the Clebsch hexagon code**

Possible descriptive subtitle, if the target journal permits one:

**Forgetting, cubic orientation, and parent reconstruction**

The title should not advertise the Weil roof, quantum states, perfect codes, or a sequel.  Those
are consequences and boundary tests, not the central theorem.

## Draft abstract

We study when the maximum-distance syndrome geometry of a projective MDS code remembers the
projective system that produced it.  Among six-arcs of `PG(2,11)`, conic containment of the
projective deep-hole locus characterizes the Clebsch hexagon and recovers its `A5` stabilizer.  We
place this rigidity theorem in the complete rank-three Coxeter family `A3`, `B3`, `H3`: for Coxeter
number `h`, the reflection-complement code has an exact distance law, and at `q=h+1` its support is
the full rational conic.

The conic child nevertheless forgets how its points were paired into secants.  Differences of
canonically scaled secant products are divisible by the conic equation and define quotient
configurations of ranks `3`, `6`, and `10`.  For `B3` and `H3`, the two factorization sheets are the
unique complementary halves with equal first and second tensor moments.  Their signed moments
vanish in degrees one and two, while the first surviving moment is cubic and realizes the outer
orientation character.  In the `H3` case, `A4\PGL_2(11)/A5` yields six depth profiles of sizes
`1,4,6 / 1,4,6`; the singleton profiles recover the matching and hence the Clebsch parent.  An
all-degree parity identity and the projective cover `P(1)` explain the cubic threshold and the
rank-two depth quotient.

We finally determine which natural passages retain this bit and which erase it.  Cross-sheet
designs yield certified quadratic-residue and perfect-code shadows, and golden reduction obeys an
exact visible/fused law modulo `40`, whereas theta parity and quantum local-unitary equivalence do
not distinguish the sheets.  The structural proofs are Lean-formalized, and the finite claims have
deterministic certificates and independent replay.

## Opening guided tour

The introduction states the reconstruction question, Theorems A--D below, the classical-credit
boundary, and the verification model.  It is followed by a proof-free guided tour of at most five
pages.  The tour has three graphics.

### Figure 1: the main reconstruction arc

```text
Clebsch parent + secant matching
  -- conic restriction forgets pairing/orientation --> full-conic GRS child
  -- divide factorization differences by Q --------> 22 quotient points
  -- balanced first/second moments ----------------> unique unordered 11+11 sheets
  -- first nonzero signed cubic moment ------------> oriented sheet bit
  -- A4 double-coset depth map --------------------> six profiles 1,4,6 / 1,4,6
  -- singleton profile + matching -----------------> Clebsch parent recovered.
```

Every arrow carries a theorem label.  The four visual verbs are **forgets**, **recovers
unordered**, **orients**, and **reconstructs**.  The figure uses grayscale-safe line styles:
solid for Paper-1 theorems, blocked for proved non-identifications, and one dashed exit for the
sequel question.

### Figure 2: the complete rank-three frame

| type | Coxeter number | conic phase | projective matching behaviour | bit carrier |
|:---|---:|---:|:---|:---|
| A3 | 4 | `F_5` | antipodal marker fused | fused control; companion `C2` torsor is a sequel pointer |
| B3 | 6 | `F_7` | two `PSL_2(7)` sheets | silver reduction and cubic sign |
| H3 | 10 | `F_11` | two `PSL_2(11)` sheets | golden matching, cubic sign, arithmetic gluing |

The body proves only the rows needed for the common Coxeter phase and Paper-1 close.  The full
torsor and quaternion mechanisms are sequel pointers.

### Figure 3: survival and erasure

```text
retains orientation:       signed cubic; decorated singleton profile
retains unordered pair:    first/second quotient moments
retains a shadow:          QR design; perfect-code span; ambient Weyl restriction
conditionally fuses:       golden reduction, by the mod-40 law
erases orientation:        unmarked conic child; theta/Arf; fixed-party quantum LU
```

This figure prevents the closing synthesis from being read as a claim that every carrier is
canonically the same object.

## Headline theorem hierarchy

### Theorem A: rigidity and Coxeter phase

1. Conic containment of the full projective deep-hole locus characterizes the Clebsch six-arc and
   recovers `A5`.
2. For `A3/B3/H3`, the reflection-complement code has the exact common length and distance law.
3. At `q=h+1` the complement is the full rational conic and the child is extended GRS.
4. The Coxeter square generates the split maximal torus and its moving blocks are the Legendre
   cosets.

Sources: retained manuscript, C399, C449.

### Theorem B: factorization forgetting and balanced recovery

1. Conic restriction makes all perfect-matching secant products equal.
2. Dividing their differences by the conic equation gives exact quotient ranks `3,6,10`.
3. In B3/H3, the two sheets are the unique complementary halves with equal first and second
   moments.

Sources: C403, C406, C421--C424, C430.

### Theorem C: cubic orientation and compressed depth

1. Every even signed moment vanishes and the weighted barycentre kills degree one.
2. Degree three is the first surviving signed tensor moment and realizes the outer character.
3. `A4\PGL_2(11)/A5` has the two `1,4,6` triples and yields the six exact depth profiles.
4. The depth map has rank two and four-dimensional linear kernel while separating all six labels.
5. The projective cover `P(1)` explains the rank drop; the relative-cubic Tate plane remains
   canonically distinct from the depth plane.

Sources: C406, C411, C412, C420, C423--C425.

### Theorem D: reconstruction and arithmetic gluing

1. The singleton depth profiles recover the unordered golden matching pair and, with decoration,
   the Clebsch parent.
2. Across A3/B3/H3, the projective matching datum respectively fuses, splits into silver sheets,
   and splits into the two golden H3 sheets.
3. In H3 the two `A5` stabilizers meet in `A4`, generate `PSL_2(11)`, and are exchanged through
   the rational `S4/A4` hinge by the reduction of the spinor-norm-2 rotation `Rz`.

Sources: C379, C444, C445, C460.

## Section-by-section outline

### 1. Introduction

- State the parent-reconstruction question in syndrome and arc language.
- State Theorems A--D without coordinates.
- Separate the classical Clebsch, Edge/Dye, one-factorization, matching-design, and conic-group
  layers from the new transport and reconstruction claims.
- Give the mixed-verification policy in one paragraph.
- End with a short roadmap; do not preview every survival/forgetting consequence in prose.

### 2. A guided tour of forgetting and memory

- Print Figures 1--3.
- Walk once through the entire mechanism with one frozen matching as the running object.
- Explain `22 -> 6 -> 2 -> 1` as an information lattice, not as a sequence of unrelated orbit
  counts.
- State explicitly that Paper 1 is complete without the dashed Weil-roof question.

### 3. The Clebsch parent and its syndrome conic

- Establish the projective-code dictionary and the quadratic distance oracle.
- State the `A5` point-orbit decomposition and identify the conic orbit.
- Prove the symmetry-free rigidity theorem and stabilizer recovery.
- Keep the sharp gap and perturbation result in a compact subsection.
- Move long census output to the certificate supplement.

### 4. Why the conic phase is rank-three and why `q=11`

- Prove the A3/B3/H3 complement length, nonmirror maximum, and distance formula.
- Establish the common `q=h+1` conic phase and the B3 root-length defect.
- Add the split-Coxeter-torus proposition from C449.
- Integrate the all-field Clebsch uncovered formula and the classification-free isolation of 11.
- State the `4 <= k <= 7` classification compactly; place its finite leaves in an appendix if the
  target length requires it.

### 5. What conic restriction forgets

- Introduce canonically scaled secant products.
- Prove equality on the conic and divisibility by `Q` via the switch identity.
- State the exact boundary: the unmarked GRS child retains no matching, parent, or orientation.
- Define the factorization-difference quotient used thereafter.

### 6. Harmonic images and balanced sheets

- Develop the conic Laplacian and harmonic/radial decomposition.
- Prove image ranks `3,6,10` uniformly.
- Prove the radical--Hadamard balanced-half theorem and uniqueness of the B3/H3 sheets.
- Keep representation decompositions subordinate to the recovery theorem.

### 7. Cubic-first orientation

- Prove all-degree antipodal cancellation and the weighted degree-one relation.
- Prove the nonzero cubic witness and exact outer stabilizer statement.
- State minimality only for signed tensor moments and their linear functionals.
- Include the primitive `1:4:6` dependence; defer the full relative-cubic Tate construction to an
  appendix.

### 8. Six depth profiles and parent reconstruction

- Derive the `A4` marks and the two `1,4,6` orbit decompositions.
- Compute one canonical secant-incidence representative per double coset.
- Prove the profile plane, rank-two map, four-dimensional kernel, and set separation.
- Explain the rank drop as `P(1)^A4 / soc(P(1))`.
- Recover the singleton matchings and invoke the decorated parent-recovery theorem.
- Return explicitly to the unmarked Clebsch hexagon and its intrinsic support bipartition.

### 9. Rank-three arithmetic gluing

- State the A3 fused, B3 silver-split, and H3 golden-split matching theorem.
- For H3, prove the two `11`-sheet orbit halves, `A5` intersection/generation, and `S4/A4` hinge.
- State the rational spinor-norm-2 transporter and its outer reduction.
- Point to quaternion maximal-order reduction and companion torsors as sequel mechanisms; do not
  reproduce C457/C462/C463.

### 10. The survival/forgetting ledger

- Present one theorem table, not a sequence of mini-papers.
- Retain the QR/Barker and perfect-code certificates as the positive design/code shadow.
- State the exact mod-40 visible/fused law; cite the sequel-level Dickson mechanism without proving
  it here.
- State theta/Arf and quantum LU as erasure theorems.
- State the ambient Weil-Weyl restriction with its `rho(w)=iF` normalization and immediately record
  the no-module boundary.
- End the section with the exact advice statement: choosing a parent is one bit of geometric
  decoration, not an unlabeled or fixed-party quantum invariant.

### 11. Verification and trust architecture

- Give a claim-by-claim table: conceptual proof, Lean theorem/gate, finite certificate, replay, and
  classical cited input.
- Print only the adequacy appendix needed for headline statements.
- Pin the shared Lean commit and the immutable artifact DOI.
- State the AI/provenance disclosure and the exact external-certificate boundary.

### 12. Conclusion: the scoped roof question

- Reprise the solid reconstruction chain in one paragraph.
- State the mod-40 law and the scoped ambient Weil-Weyl fact as evidence, not identification.
- Mention that the literal small Weil module, theta detector, Klein-five-space map, and quantum LU
  detector have been ruled out.
- Point once to the sequel mechanisms: quaternion reduction, rational descent, torsors, Dickson
  fusion, and Klein-cubic zeta.
- End with one precise metaplectic/arithmetic question; add no second conclusion after it.

## Appendices and supplements

- **Appendix A:** relative-cubic Tate plane, its two constructions, and its proved
  non-identification with the depth plane.
- **Appendix B:** compressed low-degree, perturbation, and small-arc finite classifications if they
  cannot remain in Sections 3--4 within the target length.
- **Appendix C:** printed theorem adequacy and trust-boundary table.
- **Artifact supplement:** generators, canonical JSON certificates, hashes, independent replay,
  complete census data, and the verify-all entry point.  Do not reproduce raw tables in the paper.

## Drafting constraints

1. The abstract and opening figures lead with the reconstruction mechanism, not the catalogue of
   exceptional objects.
2. `5/14/22`, raw one-factorizations, matching-design status, coarse Hadamard orbitals, and the
   individual conic configurations receive explicit classical credit.
3. “Cubic is minimal” is qualified to signed tensor moments and their linear functionals.
4. “Chirality” is disambiguated at first use and never identified with quantum LU inequivalence or
   chiral-polytope terminology.
5. The conic child, the relative-cubic Tate plane, and the depth plane are not conflated.
6. Every negative gate is stated where it prevents the corresponding overreading, not collected as
   a history of failed attempts.
7. The main paper targets one proof spine.  The sequel mechanisms remain pointers even when their
   certificates are complete.
