# C398 — non-GRS six-arcs with conic deepest-syndrome locus

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `ALL-FIELD EXACT CLASSIFICATION; FOUR SEMILINEAR CLASSES; UNIQUE FULL-CONIC CLASS IS CLASSICAL`

**Literature depth:** three sources were read at full text, one at partial text, and two at
abstract/metadata or secondary-only depth.  The load-bearing 1992 scan passages were checked against
the authoritative page images.

## The theorem

Let `A` be a six-arc in `PG(2,q)`, let `H_A` be a `3 x 6` matrix of representative
columns, and let

```text
U(A) = PG(2,q) \ union_{a != b in A} line(a,b).
```

Thus `U(A)` is exactly the complete projective locus of weight-three syndromes of the
`[6,3,4]_q` code `ker H_A`.  Suppose that the parent is non-GRS, `U(A)` is nonempty, and
`U(A)` is contained in the rational point set of a nonsingular conic.  Up to
`PGammaL_3(q)`, exactly four classes occur:

| `q` | classes | `|U(A)|` | nonsingular conics containing `U(A)` | semilinear stabilizer | full conic? |
|---:|---:|---:|---:|---:|:---:|
| 8 | 1 | 4 | 6 | 12 | no |
| 9 | 1 | 6 | 1 | 6 | no |
| 9 | 1 | 7 | 1 | 6 | no |
| 11 | 1 | 12 | 1 | 60 | yes |

There are no classes over any other finite field.  In particular, the deepest-syndrome locus is
the full conic exactly for the unique q=11 class.  For every row, the projective code whose
generator columns are `U(A)` is respectively a GRS

```text
[4,3,2]_8, [6,3,4]_9, [7,3,5]_9, or [12,3,10]_11
```

code.  Every `u in U(A)` also gives a one-column `[7,4,4]_q` MDS extension of the parent.
These are two different uses of the locus: the GRS child is the code supported on all of `U(A)`;
the individual seven-column extensions need not be GRS.

## Why the classification is finite

A nonsingular conic has `q+1` points, so `PG(2,q)` has exactly `q^2` off-conic points.  If
`U(A)` is contained in the conic, all off-conic points are covered by the fifteen secants of `A`.
Each projective line contains only `q+1` points, hence

```text
q^2 <= 15(q+1).
```

This forces `q<=15`.  Orders two and three admit no six-arc, so the complete residual list of
prime powers is

```text
q = 4,5,7,8,9,11,13.
```

This is a theorem-level field reduction, not a search cutoff.  The arithmetic tail is formalized as
`ConicDeepHole.fieldOrder_le_fifteen` in
`lean/RelativeConicArcs/ClebschGatewayConicDeepHole.lean`.

In the full-conic case every one of the fifteen secants misses the conic.  The q=11 row is therefore
the classical noncollinear complete exterior six-set.  A direct concurrency count also explains its
Clebsch signature.  Away from the six arc points, at most three pair-secants can concur because their
edges form a matching in `K_6`; if `t` is the number of triple concurrences, then

```text
q^2 = 15q - 54 + t,       0 <= t <= 15.
```

At q=11 this gives `t=10`, the ten classical triple points.  This count is explanatory; the exact
all-field classification uses the sharper general bound followed by the certified finite quotient.

## Canonical representatives

Integers encode polynomial-basis field elements: `F_8=F_2[x]/(x^3+x+1)` and
`F_9=F_3[x]/(x^2+1)`, with least-significant coefficient first.  Prime fields use ordinary residues.
Every representative begins with the standard frame

```text
(0,0,1), (0,1,0), (1,0,0), (1,1,1).
```

The remaining points and one containing conic form
`aX^2+bY^2+cZ^2+dXY+eXZ+fYZ=0` are:

| `q` | fifth and sixth points | conic form `(a,b,c,d,e,f)` |
|---:|:---|:---|
| 8 | `(1,2,3), (1,3,5)` | `(0,0,0,1,7,6)` |
| 9 | `(1,2,3), (1,3,2)` | `(1,2,2,5,5,4)` |
| 9 | `(1,2,3), (1,4,2)` | `(1,2,3,5,3,7)` |
| 11 | `(1,3,4), (1,4,5)` | `(1,1,9,6,7,7)` |

The q=8 four-set belongs to a pencil with exactly six nonsingular members.  Each q=9 locus has at
least five points and hence determines its displayed nonsingular conic uniquely.  The q=11 locus is
all twelve points of its conic and is projectively equivalent to C368's `H3/A5` fibre.

## Exact census and checks

The certificate normalizes every ordered projective frame to
`e_1,e_2,e_3,(1,1,1)`, closes under all Frobenius powers, and takes the least normalized six-set.
It does not assume a catalogue of arcs.  The complete quotient ledger is:

| `q` | normalized frame presentations | semilinear arc orbits | GRS | non-GRS | surviving non-GRS |
|---:|---:|---:|---:|---:|---:|
| 4 | 1 | 1 | 0 | 1 | 0 |
| 5 | 3 | 1 | 1 | 0 | 0 |
| 7 | 70 | 3 | 1 | 2 | 0 |
| 8 | 195 | 3 | 1 | 2 | 1 |
| 9 | 441 | 6 | 2 | 4 | 2 |
| 11 | 1,548 | 15 | 4 | 11 | 1 |
| 13 | 4,015 | 26 | 5 | 21 | 0 |

For every orbit, the checker independently computes its semilinear stabilizer and requires

```text
(normalized presentation orbit size) * (stabilizer order)
    = 360 * [F_q:F_p].
```

For every survivor it then:

1. checks all twenty source determinants and proves the parent is an arc;
2. excludes every nonsingular conic through the parent, hence proves non-GRS status;
3. computes `U(A)` both as the complement of the fifteen secants and by a direct minimum-support
   test on every projective syndrome;
4. solves the exact quadratic evaluation nullspace, enumerates every projective form in it, and
   tests nonsingularity by simultaneous vanishing of the form and all three formal derivatives;
5. checks that the chosen conic has exactly `q+1` points, contains all of `U(A)`, and that `U(A)` is
   itself an arc; and
6. records exact representatives, stabilizers, locus sizes, conic multiplicities, and the full-conic
   flag in canonical JSON.

The frame quotient and its orbit--stabilizer ledger certify exhaustion; the direct support
calculation is an independent definition-level replay of the deep-hole locus.  No randomized search,
floating point, external algebra package, or supplied q=11 model enters the computation.

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-20-c398-conic-deep-hole-classification.py --check
sha256sum -c notes/2026-07-20-c398-conic-deep-hole-classification.sha256
```

The Python checker uses only the standard library.  Its trusted boundary is Python integer
arithmetic, the displayed irreducible polynomial models, the short canonicalizer, and the standard
arc--MDS/conic--GRS dictionary.  The Lean module proves the universal arithmetic reduction and
kernel-checks the compact profile interface; it deliberately does not pretend to internalize the
coordinate census.  The import-only exit is
`RelativeConicArcs.Gates.ClebschGatewayConicDeepHole`.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 17,444 | `e01fc095bb51dd561d5b71c91d0f775b24ec1d97c8909d7879f3bd7fa499dcfc` |
| certificate `.json` | 8,713 | `e68bd03d88afd2c6c05a76fe9ef9b4254cb614c3b2f9f4c252c60222289e6f68` |
| Lean interface | 2,571 | `a30e341de6dc5310c052098ae87430d729262c969f8c84662d00f1eaae056827` |
| Lean gate | 297 | `66e67502e7c18e083cb2b7f717ba8dc3e8d0eef895713c5749cb8294fc756f11` |

## Literature and claim boundary

The full-conic q=11 row is prior art in finite-geometry language.  Blokhuis--Seress--Wilbrink define
a complete exterior set as `(q+1)/2` exterior points whose pair-joins miss a fixed conic.  Their
introduction constructs the q=11 conic plus six exterior points, and their final remarks record that
the noncollinear q=11 example is a six-arc, previously found by Korchmaros.  Van de Voorde repeats
the exterior-set definition, the q=7/q=11 construction, and the claim that the q=11 noncollinear
complete exterior set is the last known arc example.  C398 therefore makes no novelty or priority
claim for the Clebsch/full-conic object, its `A5` stabilizer, or the associated GRS child.

Kaipa proves the deep-hole--one-column-MDS-extension equivalence for GRS parents and classifies the
redundancy-three GRS case.  That is the mandatory parent boundary, not a classification of arbitrary
non-GRS six-arcs.  Recent work on ESGRS and twisted families supplies non-GRS deep-hole examples but
does not classify conic-contained complete syndrome loci.  As a direct check, the displayed
`[6,3,4]_11` ESGRS example of Li--Lu--Ling--Lam has 21 projective weight-three syndromes and no
containing conic, so it is not one of the C398 rows.

The surviving contribution is consequently narrow and exact: the universal `q<=15` reduction, the
four-class full semilinear quotient including the previously unrecorded q=8/q=9 partial-locus
profiles, and the code/extension translation in one theorem.  It is a portable classification, but
not the intended new flagship because its unique full-conic crown is classical.

### Read-depth ledger

- **Blokhuis, Seress, Wilbrink, _Characterization of complete exterior sets of conics_, DOI
  `10.1007/BF01204717`: `full text`.** All five pages were read through the user-supplied OCR
  reconstruction (`sha256 2ae26684...c7c4`).  The definition/q=11 construction on page 143 and the
  q=11 six-arc/Korchmaros statement on page 146 were checked against the authoritative images
  (`577c6d65...aad4`, `fa3b6a47...0892`).
- **Kaipa, _Deep holes and MDS extensions of Reed--Solomon codes_, arXiv:1612.05447v1, DOI
  `10.1109/TIT.2017.2706677`: `full text`.** All fourteen pages were read from cache key
  `arXiv:1612.05447`, sha256
  `1fe8de83c0b8cd3938e1a450fd49f376de795d7a317f099a730c63ab968178a4`.
- **Van de Voorde, _On sets without tangents and exterior sets of a conic_, arXiv:1201.0484v1,
  DOI `10.1016/j.disc.2011.07.010`: `full text`.** All twelve pages were read from cache key
  `arXiv:1201.0484`, sha256
  `45891ed7688d6ab3677a57060ac69c876007104b7479944744724e69fc46f9a7`.
- **Li, Lu, Ling, Lam, _A framework for constructing non-GRS MDS-NMDS codes from deep holes and
  its application_, arXiv:2605.12133v1: `partial`.** Read the abstract and introduction, the
  theorem/remark block and Examples 2--3 on pages 18--21, and the conclusion from cache key
  `arXiv:2605.12133`, sha256
  `8f854dcb3ad549b8bfdcaac6f585edc9d9516c7ea9674e970f54020657c0fa7d`.
- **Cheng, Wu, Zhou, _On deep holes of non-Reed-Solomon codes_, DOI
  `10.1016/j.ffa.2026.102882`: `abstract/metadata only`.** ScienceDirect abstract and section
  preview were read; the paper concerns the specified skipped-monomial evaluation family, not
  arbitrary projective six-arcs.  Full text was not available in the cache.
- **Korchmaros, q=7/q=11 chain-of-circles construction: `secondary only`.** The only statement
  used is BSW page 146's attribution of the q=11 six-arc; the 1981 primary paper was not obtained.

### Forward and direct-search coverage

Pinned forward counts for BSW were OpenAlex `9` (`W2001379196`), Crossref `3`, and Semantic
Scholar `11` (`d209da813a28b5de09f12e535e9c6b2bb78f92fe`); all 11 Semantic Scholar records were
screened over title and abstract.  The only directly relevant successor was Van de Voorde, read in
full.  Pinned forward counts for Kaipa were OpenAlex `20` (`W2563545890`), Crossref `16`, and
Semantic Scholar `28` (`72dd1f6925426b6983d72235c8bb44001a771fa2`); all 28 Semantic Scholar
records were screened over title and abstract.  The non-GRS candidates promoted for individual
discussion were checked at the read depths above.

Load-bearing web queries, run 2026-07-20, were:

```text
Kaipa redundancy three Reed Solomon deep holes MDS extensions conic
site:arxiv.org non-GRS MDS code deep holes conic projective plane six arc
six arc PG(2,q) uncovered points contained in conic classification
"complete exterior sets" conics finite geometry
"6-arc" "PG(2,11)" conic exterior
"deep hole" "non-GRS" six arc conic
"uncovered locus" arc conic finite projective plane
site:arxiv.org "non-GRS" "conic" "deep holes" MDS
```

The three citation services returned successful JSON records for the pinned DOI seeds; zero/error
ambiguity did not arise.  zbMATH Open title/author searches resolved BSW as `Zbl 0761.51006` and
Kaipa as `Zbl 1372.94456`.  MathSciNet and Google Scholar were not covered.  This licenses only the
narrow statement that no predecessor for the q=8/q=9 partial-locus profiles or the exact four-row
semilinear synthesis was located; every priority formulation must retain “to our knowledge.”

## Hand-back

- C368 keeps ownership of the integral `H3/A5` arithmetic phase and its q=11 coordinate bridge.
- BSW/Korchmaros own the classical full-conic q=11 exterior six-arc.
- Kaipa owns the GRS-parent redundancy-three deep-hole boundary.
- C398 closes with the all-field reduction, four-row quotient, and sharply delimited prior-art
  verdict.  The paper-promotion rule is not triggered: move to C399.
