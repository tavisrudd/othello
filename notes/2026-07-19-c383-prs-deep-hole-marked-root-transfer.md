# C383 — projective Reed--Solomon deep holes via marked extension geometry

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** active; first live redundancy-six gate is positive and exactly certified

**Verdict so far:** `BOUNDED POSITIVE; THE FACTORIZATION-COLORED APOLAR PLANE COMPLETELY
CLASSIFIES THE 20 PGL2(7) DEEP-HOLE ORBITS OF PRS_7(2)`

## Question and corrected target

Can C379/C381's governing idea—retain the intrinsic decoration that makes a lossy extension
transform reversible—become a coordinate-free invariant for projective Reed--Solomon deep holes?
The literal marked-`E8` object is planar and does not transfer.  The surviving replacement is the
apolar linear system of the syndrome binary form, decorated by its finite-field factorization
strata.

The original redundancy-four target is pre-empted.  Zhang--Wan--Kaipa completely classify it by
tangent points and quadratic-conjugate secants.  In apolar language these are precisely the
repeated-linear and irreducible-quadratic kernels; the squarefree split quadratic is the ordinary
rational secant and hence is not deep.  A 2023 survey further reports redundancy five as completely
solved in an in-preparation work, but that primary source was not located.  The first live target
supported by accessible sources is therefore redundancy six, beginning with `PRS_7(2)`.

## Exact q=7 theorem

Write a projective syndrome as `v=(v_0:...:v_5)` in `PG(5,7)` and define its apolar plane

```text
A_v = P ker [[v_0,v_1,v_2,v_3,v_4],
             [v_1,v_2,v_3,v_4,v_5]] <= P(Sym^4(F_7^2)).
```

Colour each of the 57 points of `A_v ~= PG(2,7)` by the complete factorization type over `F_7` of
its homogeneous binary quartic.  Then retain the multiset of colour histograms on the 57 projective
lines of `A_v`.  On the complete projective syndrome space:

- `PG(5,7)` has 19,608 points;
- the union of the spans of four distinct points of the eight-point normal rational curve has
  14,232 points;
- the remaining 5,376 points are exactly the deep-hole syndromes of `PRS_7(2)`;
- direct four-secant enumeration agrees point-for-point with the criterion that `A_v` contains no
  squarefree completely split quartic;
- the 5,376 deep syndromes form 20 `PGL_2(7)` orbits, of sizes
  `56,112,168,168,168,168,168` and thirteen copies of `336`;
- the coarse rational-root histogram gives nine invariant classes;
- the complete quartic-factorization histogram gives eighteen classes; and
- the factorization-coloured plane incidence profile gives exactly twenty classes, each equal to
  one `PGL_2(7)` orbit.

Thus the coloured apolar plane is a complete coordinate-free orbit invariant for this first live
finite case.  The result does not yet classify an all-field family, prove novelty, settle the PRS
covering-radius/MDS conjecture, or provide closed formulas for the twenty orbits.

## Exact evidence

Run from the repository root:

```text
python3 notes/2026-07-19-c383-prs-deep-hole-marked-root-transfer.py --check
```

The deterministic generator uses the prime field `F_7`, the normal rational curve
`c_6(t)=(1,t,...,t^5)` plus `c_6(infinity)`, first-nonzero-coordinate projective normalization, and
the fifth symmetric-power action of `PGL_2(7)`.  It checks independently that direct four-point-span
coverage equals the apolar split-quartic test; it also verifies the group order `336`, preservation
of the curve and deep set, constancy of every profile on each group orbit, and equality of the
twenty coloured-plane profiles with the twenty exact orbits.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-19-c383-prs-deep-hole-marked-root-transfer.py` | 14,111 | `0eb2fddbd55a2bfd58f7d8b2482f82129b9ee3a899a7653bf551deb3c9c882a8` |
| `notes/2026-07-19-c383-prs-deep-hole-marked-root-transfer.json` | 13,829 | `239b5ad43e59775ccf9952759b067d31ae24c4def1b50254c27c1dbbfb8b6f48` |

The adjacent checksum manifest is authoritative.

## Pre-emption and bounded adjacent extraction

The exact pre-emption is the published redundancy-four classification, strengthened by a secondary
report that redundancy five is also closed.  Four candidates were retained from the bounded pass:

1. **Factorization-coloured apolar linear system — passes the q=7 gate.**  It completely recovers
   the twenty deep-hole orbits after the line-incidence refinement.
2. **Literal C381 marked-root/`E8` transport — red.**  The target lies in `PG(5,q)` and has no
   natural plane-blow-up Picard lattice; equal `E8` vocabulary would be a category error.
3. **Uncoloured apolar factorization histogram — near miss.**  It gives eighteen classes but merges
   two pairs of `PGL_2(7)` orbits.
4. **Second-kind extended-code reformulation — pre-empted as a general dictionary.**  Wu--Ding--Chen
   already characterize MDS preservation by the dual covering radius and deep-hole condition.

No successor ID is allocated: the positive apolar continuation remains inside C383.  C384 and C385
are independent famous-problem probes, not extraction descendants.

## Literature record and boundary

Two sources were read at full text, one partially, and one only through accessible metadata/snippets.
No novelty or priority claim is made, and no forward-citation closure has yet been attempted.

- Krishna Kaipa, *Deep holes and MDS extensions of Reed--Solomon codes*, arXiv:1612.05447v1.
  **Read depth: full text**, cached PDF/text key `arXiv:1612.05447`, SHA-256
  `1fe8de83c0b8cd3938e1a450fd49f376de795d7a317f099a730c63ab968178a4`; relied on Sections I--V
  for the conditional extension equivalence, covering-radius caveat, and complete redundancy-three
  classification.
- Jun Zhang, Daqing Wan, Krishna Kaipa, *Deep Holes of Projective Reed--Solomon Codes*,
  arXiv:1901.05445v2. **Read depth: full text**, cached PDF/text key `arXiv:1901.05445`, SHA-256
  `5c2b9e2508c7200428c441b7a41da1596b1c9b0851f5632e2297cdbed41caf24`; relied on Sections I--IV
  for the redundancy-four tangent/conjugate-secant classification, exact orbit counts, and stated
  `q-4` continuation.
- Yansheng Wu, Cunsheng Ding, Tingfang Chen, *Extended codes and deep holes of MDS codes*,
  arXiv:2312.05534v1. **Read depth: partial**, cached PDF/text key `arXiv:2312.05534`, SHA-256
  `9fe6878668bafce0ba1eb759f9fee16ab10f77b5520b47eb1c4626aec5f76000`; read Sections I, III,
  VI.A, and VII for the second-kind extension theorem and the PRS covering-radius boundary.
- Jun Zhang and Haiyan Zhou, *The deep hole problem of generalized Reed--Solomon codes*, DOI
  `10.1360/SSM-2023-0118`. **Read depth: abstract/metadata and search-extracted snippets only**;
  the publisher PDF returned HTTP 418 and could not be cached.  Notes 3.5--3.6, as exposed by the
  search index, report `PRS(q-4)` solved in an in-preparation work and state the remaining problem
  as `k<=q-5`.  The underlying preparation is **NOT COVERED**, so this report treats redundancy
  five as a routing warning rather than a verified theorem.

## Next gate

Before any larger-field census, close primary literature on apolarity/Waring-rank treatments of PRS
deep holes and search specifically for a q=7 orbit classification.  If the coloured apolar plane is
not already standard, prove its presentation independence symbolically and identify the minimal
refinement that separates the two pairs missed by the uncoloured factorization histogram.  Only then
test transport to a second field.
