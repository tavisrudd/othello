# C383 — projective Reed--Solomon deep holes via marked extension geometry

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** complete; literature gate, symbolic invariance, minimal refinement, and second-field gate
all closed

**Verdict:** `BOUNDED POSITIVE — THE FACTORIZATION-COLOURED APOLAR PLANE CLASSIFIES ALL
20 PGL_2(7) DEEP-SYNDROME ORBITS OF PRS_7(2); A MINIMAL ONE-BIT REFINEMENT SUFFICES, AND
THE INVARIANT PASSES THE REDUNDANCY-SIX q=11 TRANSFER TEST`

## Question and corrected target

Can C379/C381's governing idea—retain the intrinsic decoration that makes a lossy extension
transform reversible—become a coordinate-free invariant for projective Reed--Solomon deep holes?
The literal marked-`E8` object is planar and does not transfer. The surviving replacement is the
apolar linear system of the syndrome binary form, decorated by finite-field factorization strata.

The original redundancy-four target is pre-empted. Zhang--Wan--Kaipa completely classify it by
tangent points and quadratic-conjugate secants. In apolar language these are the repeated-linear and
irreducible-quadratic kernels; the squarefree split quadratic is the ordinary rational secant and is
not deep. A 2023 survey reports redundancy five as solved in an in-preparation work, but the named
primary source could not be located. The first live target supported by accessible primary sources
is therefore redundancy six, beginning with `PRS_7(2)`.

## Exact q=7 theorem

Write a projective syndrome as `v=(v_0:...:v_5)` in `PG(5,7)` and define its apolar plane

```text
A_v = P ker [[v_0,v_1,v_2,v_3,v_4],
             [v_1,v_2,v_3,v_4,v_5]] <= P(Sym^4(F_7^2)).
```

Colour each of the 57 points of `A_v ~= PG(2,7)` by the complete factorization type over `F_7` of
its homogeneous binary quartic. Retain the multiset of colour histograms on the 57 projective lines
of `A_v`. On the complete projective syndrome space:

- `PG(5,7)` has 19,608 points;
- the union of the spans of four distinct points of the eight-point normal rational curve has
  14,232 points;
- the union of five-point spans is all 19,608 points, so the covering radius is exactly five;
- the remaining 5,376 points are exactly the deep-hole syndromes of `PRS_7(2)`;
- direct four-secant enumeration agrees point-for-point with the criterion that `A_v` contains no
  squarefree completely split quartic;
- the 5,376 deep syndromes form 20 `PGL_2(7)` orbits, of sizes
  `56,112,168,168,168,168,168` and thirteen copies of `336`;
- the coarse rational-root histogram gives nine invariant classes;
- the complete quartic-factorization histogram gives eighteen classes; and
- the factorization-coloured plane incidence profile gives exactly twenty classes, each equal to
  one `PGL_2(7)` orbit.

This is an exact finite theorem, not a sample. It does not classify an all-field family, settle the
PRS covering-radius/MDS conjecture, or supply closed formulas for the twenty orbits.

## Minimal refinement

The eighteen factorization-histogram classes have exactly two double collisions; all four members
are orbits of size 336. Both collisions are split by the single Boolean invariant

```text
tau(v) = 1 iff the points of A_v coloured 1^2+2^1 contain a projective collinear triad.
```

Here `1^2+2^1` means a repeated rational linear factor times an irreducible quadratic. The checker
evaluates `tau` independently in two ways: it scans all projective lines of `A_v`, and it scans all
unordered triples of points of that colour for a vanishing `3 x 3` determinant. The answers agree
for every one of the 5,376 deep syndromes. The pair `(factorization histogram, tau)` has twenty
values, one per exact orbit.

Minimality is literal in the stated refinement model. Eighteen unrefined values cannot distinguish
twenty orbits, so at least one additional bit is necessary; `tau` is one bit and suffices. The full
line-colour profile remains the natural coordinate-free object, while `tau` is its minimal extracted
certificate for this finite classification.

## Presentation independence

Let `V` be two-dimensional and write the quintic syndrome in divided-power coordinates. Contraction
gives the intrinsic catalecticant

```text
C_v : Sym^4(V*) -> D_1(V),       h |-> h contraction v.
```

The displayed Hankel matrix is only the matrix of `C_v` in the standard divided-power bases.
Contraction is `GL(V)`-equivariant, hence `ker C_(g v) = g(ker C_v)` with the corresponding
contragredient action on quartics. Scaling `v` does not change the kernel. A different basis of the
three-dimensional kernel only applies an element of `PGL_3` to its projective plane.

Linear substitution preserves degrees and multiplicities of irreducible factors over the base
field, and projective linear maps preserve lines and collinearity. Consequently the factorization
histogram, the full coloured-line profile, and `tau` depend only on the projective `PGL_2(q)` orbit of
`v`, not on the syndrome representative, binary variables, or chosen basis of `ker C_v`. Ishitsuka's
coordinate-free apolar ideal supplies an independent standard framework for the contraction and
Waring-type language; the coloured quartic-plane incidence construction is the new bounded object
tested here.

## Required second-field pass

The same redundancy-six construction was enumerated over `F_11`, where the code is `PRS_11(6)`.
Exact four-secant coverage and exact `PGL_2(11)` action give:

- 177,156 points in `PG(5,11)`;
- 175,572 points in the union of four-point spans of the twelve-point normal rational curve;
- all 177,156 points in the union of five-point spans, proving covering radius five rather than
  assuming it;
- 1,584 deep syndromes;
- four `PGL_2(11)` orbits, of sizes `132,132,660,660`; and
- four distinct factorization histograms, four distinct histogram-plus-`tau` values, and four
  distinct full coloured-line profiles.

Thus the richer q=7 invariant transfers without alteration. At q=11 the coarser factorization
histogram happens already to be complete; this does not weaken the q=7 one-bit minimality statement.
Only one canonical representative per exact q=11 orbit is profile-evaluated, because the symbolic
equivariance proof above establishes constancy on the orbit.

## Exact evidence and replay

Run from the repository root:

```text
python3 notes/2026-07-19-c383-prs-deep-hole-marked-root-transfer.py --q 7 --check
python3 notes/2026-07-19-c383-prs-deep-hole-marked-root-transfer.py --q 11 --check
sha256sum -c notes/2026-07-19-c383-prs-deep-hole-marked-root-transfer.sha256
```

The deterministic generator uses first-nonzero-coordinate projective normalization and the fifth
symmetric-power action of `PGL_2(q)`. At both fields it verifies five-span coverage of the full
syndrome space. At q=7 it also verifies four-span coverage against the independent apolar
split-quartic test, group order and curve preservation, constancy of profiles on every orbit, and
both implementations of `tau`. At q=11 it exhausts the syndrome space, four-secant union, group,
and exact orbits before evaluating each canonical representative.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-19-c383-prs-deep-hole-marked-root-transfer.py` | 21,940 | `e82d372cfa81a2930213d76e74cd944ebe4c3e9cd393928f95de3453f5654bc2` |
| `notes/2026-07-19-c383-prs-deep-hole-marked-root-transfer.json` | 15,602 | `a148c7ac9744e46ac5cc57d6454af8b961f11b2fa484fbd4665a7367102f285d` |
| `notes/2026-07-19-c383-prs-deep-hole-second-field.json` | 3,983 | `be0af87809a600464ea944ced8031722da8cb57f5f7a3597e3ee508de19c45b9` |

The adjacent checksum manifest is authoritative.

## Pre-emption and bounded adjacent extraction

The exact pre-emption is the published redundancy-four classification, strengthened only by a
secondary report that redundancy five is also closed. Four candidates were retained from the
bounded pass:

1. **Factorization-coloured apolar linear system — passes.** It completely recovers the twenty q=7
   deep-hole orbits and passes q=11.
2. **Literal C381 marked-root/`E8` transport — red.** The target lies in `PG(5,q)` and has no natural
   plane-blow-up Picard lattice; equal `E8` vocabulary would be a category error.
3. **Uncoloured apolar factorization histogram — near miss at q=7.** It gives eighteen classes but
   merges two pairs; the intrinsic bit `tau` is the minimal repair.
4. **Second-kind extended-code reformulation — pre-empted as a general dictionary.** Wu--Ding--Chen
   already characterize MDS preservation by the dual covering radius and deep-hole condition.

No successor ID is allocated. A general-q classification would require a new governing theorem,
not merely a larger census, and the two-field evidence here is not sufficient to open that task.

## Literature audit

The audit read three sources in full text, two partially, and one through metadata/search-extracted
publisher text. No predecessor for the q=7 apolar-plane invariant was located in the covered sources
or forward graphs. This is not a novelty or priority claim: MathSciNet and Google Scholar were not
covered, and the reported redundancy-five primary remains unavailable.

### Sources and read depth

- Krishna Kaipa, *Deep holes and MDS extensions of Reed--Solomon codes*, arXiv:1612.05447v1.
  **Read depth: full text.** Cache key `arXiv:1612.05447`, SHA-256
  `1fe8de83c0b8cd3938e1a450fd49f376de795d7a317f099a730c63ab968178a4`; Sections I--V support
  the conditional extension equivalence, covering-radius caveat, and redundancy-three result.
- Jun Zhang, Daqing Wan, Krishna Kaipa, *Deep Holes of Projective Reed--Solomon Codes*,
  arXiv:1901.05445v2 / DOI `10.1109/TIT.2019.2940962`. **Read depth: full text.** Cache key
  `arXiv:1901.05445`, SHA-256
  `5c2b9e2508c7200428c441b7a41da1596b1c9b0851f5632e2297cdbed41caf24`; Sections I--IV support
  the redundancy-four tangent/conjugate-secant classification and its orbit counts.
- Yasuhiro Ishitsuka, *Exponential sums over singular binary quintics*, arXiv:2605.04935v1.
  **Read depth: full text.** Cache key `arXiv:2605.04935`, SHA-256
  `428a5cec77fed9d0a07f941c12f68e05dcbcb3c61d5d91e682a9776ec74a03a0`; all 16 pages were read.
  It gives the characteristic-free apolar ideal and generalized Waring decomposition of binary
  quintics, including the cubic minimal apolar generator in the generic rank-three case. It studies
  exponential sums and quadrics whose squares are apolar, not the projective plane of apolar
  quartics or its factorization-coloured line profile.
- Krishna Kaipa, Nupur Patanker, Puspendu Pradhan, *On the PGL_2(q)-orbits of lines of PG(3,q) and
  binary quartic forms*, arXiv:2312.07118v3; published record DOI
  `10.1016/j.ffa.2025.102763`. **Read depth: partial.** Cache key `arXiv:2312.07118`, SHA-256
  `2ea8efc04bbf42be0919288e5e3777a4010ae30940bf8fec3a5c32feef789752`; read Sections 1--3 and
  5.1--5.3. It supplies coordinate-free divided-power actions, polarity, the apolar invariant, and
  individual binary-quartic orbit/factorization classifications. It does not treat syndrome-indexed
  planes of quartics in binary-quintic apolar ideals.
- Yansheng Wu, Cunsheng Ding, Tingfang Chen, *Extended codes and deep holes of MDS codes*,
  arXiv:2312.05534v1. **Read depth: partial.** Cache key `arXiv:2312.05534`, SHA-256
  `9fe6878668bafce0ba1eb759f9fee16ab10f77b5520b47eb1c4626aec5f76000`; read Sections I, III,
  VI.A, and VII for the second-kind extension theorem and PRS covering-radius boundary.
- Jun Zhang and Haiyan Zhou, *The deep hole problem of generalized Reed--Solomon codes*, DOI
  `10.1360/SSM-2023-0118`. **Read depth: abstract/metadata only, plus search-extracted publisher
  text.** The publisher PDF returned HTTP 418 and could not be cached. Search-exposed Notes
  3.5--3.6 and their footnote name “Kaipa K, Wan D Q, Zhang J. New results on deep holes of
  projective Reed--Solomon codes. 2023, in preparation” and report the `k=q-4` case as solved.
  Exact-title searches located no preprint or publication; that primary is **NOT COVERED**.

### Search and forward-citation closure

The arXiv API title/abstract corpus was queried verbatim as follows:

```text
all:"projective Reed-Solomon" AND (all:apolarity OR all:apolar OR all:Waring)  -> 0
all:"projective Reed-Solomon" AND all:"q=7"                                  -> 0
all:"binary quintic" AND (all:PGL2 OR all:"finite field")                    -> 0
all:"normal rational curve" AND all:"PG(5,7)"                               -> 0
all:"projective Reed-Solomon"                                                 -> 8 screened
all:"binary quintic"                                                          -> 8 screened
all:"normal rational curve"                                                   -> 18 screened
```

The broad sets were screened in full by title and abstract. Ishitsuka was the only new source
promoted to full text. Full-text searches of the cached Kaipa, Zhang--Wan--Kaipa, and
Wu--Ding--Chen texts found no occurrence of `apolar`, `Waring`, or `catalecticant`.

The central forward seed was pinned as DOI `10.1109/TIT.2019.2940962`, OpenAlex work
`W2973880421`, and Semantic Scholar paper `95c13c755dafef5a058afd031eaba41a6655c5f5`.
Counts on 2026-07-19 disagreed: OpenAlex 21, Crossref 19, Semantic Scholar 24. The largest set was
obtained from the Semantic Scholar `/citations?limit=100&fields=title,year,abstract,externalIds,url`
endpoint; all 24 records were inspected by title/abstract and 21 were promoted by the discriminator
terms `projective Reed`, `deep hole`, `Reed-Solomon`, `normal rational`, `apolar`, `Waring`,
`binary quintic`, `binary quartic`, or `MDS extension`. None claimed the q=7 orbit classification or
a syndrome-dependent factorization-coloured apolar plane.

For the quartic-orbit seed pinned by DOI `10.1016/j.ffa.2025.102763`, counts were OpenAlex 0,
Crossref 0, and Semantic Scholar 4. All four Semantic Scholar citing records were screened; none was
about PRS deep syndromes. For Ishitsuka, pinned by arXiv `2605.04935`, OpenAlex and Semantic Scholar
both returned zero; Crossref returned a genuine 404/not-indexed response rather than an empty citing
set. These two auxiliary graphs did not carry the main negative verdict.

Targeted web and zbMATH Open searches for the survey's exact in-preparation title, for
`PRS_7(2)` plus deep holes, and for `PG(5,7)` plus apolarity located no additional primary. An empty
API result was distinguished from an error by a successful response and reported result count;
the Crossref not-indexed and publisher HTTP 418 outcomes are carried explicitly as gaps.

### Coverage statement

- arXiv API, OpenAlex, Crossref, Semantic Scholar, targeted web search, and zbMATH Open: **searched**;
- the largest central forward-citation set: **screened in full at title/abstract depth**;
- all five fetched PDFs: **cached**, with keys and hashes above;
- survey publisher PDF and its named in-preparation primary: **could not access / NOT COVERED**;
- MathSciNet: **NOT COVERED** because institutional authentication was unavailable;
- Google Scholar: **NOT COVERED** because automated access is blocked.

The supported negative is therefore narrow: no pre-empting q=7 coloured-apolar-plane result was
located under the recorded coverage. Every stronger novelty or priority sentence remains unwarranted.

## Methodological review

The Hirschfeld--Thas--Storme--Ball--Lavrauw projective-arcs dossier determined the quotient: use
projective syndromes, canonical representatives, exact stabilizer/orbit arithmetic, and an intrinsic
incidence object. The Davydov--Marcugini--Pambianco computational-arcs dossier determined the proof
discipline: enumerate the complete bounded geometry, retain replayable certificates, and do not
promote a two-field census to a general-family theorem. Those constraints are reflected in the
normalizations, orbit checks, independent `tau` replays, and the explicit bounded verdict above.
