# C1133 — source and literature closeout

**Date:** 2026-09-10. **Lane:** `cubic-threefolds`.
**Status:** bounded continuation complete; the complete C1133 literature gate
has not passed. Exact remaining access and companion-source obligations are below.
**Current continuation:** `2026-09-10-c1133-citation-followup.md` recovers
the twelve S2 seed sets (59 memberships, 39 distinct works), adds nine
source records and resolves the withdrawn Verra lead. Current register: 88.
The counts and service failures below describe the earlier pass.

**External sources read at full text: eight — six papers and two source scripts.**
Read depths and access records live in `2026-09-09-c1133-literature-sources.json`.
Earlier dated access failures remain historical records, not current source statuses.

## Original polarization-finiteness source

Narasimhan–Nori, *Polarisations on an abelian variety*, published 1981,
DOI `10.1007/BF02837283`, is now **full text**: all four original scanned pages
125–128 were read visually, including the proof and references. The successful
repository request was `https://repository.ias.ac.in/36463/1/36463.pdf`.
Cache key: `10.1007/BF02837283`; PDF SHA-256:
`2710fad133c91c6e57f16b6e842d2db875a76b057e9551ccf9b2de8de303410b`.
The text extraction is empty; the read was from rendered facsimile pages,
not an OCR reconstruction or the search excerpt.

Theorem 1.1 asserts finitely many automorphism orbits of Néron–Severi
classes of each fixed nonzero degree over an algebraically closed field.
Section 1.6 defines degree through the associated homomorphism to the dual
abelian variety. In particular, the paragraph immediately after Theorem 1.1
explicitly gives finitely many principal polarizations up to automorphism.
This is exactly the finiteness input needed after fixing a geometric
intermediate Jacobian. It asserts neither a bound on twists over the original
field nor effectiveness. The proof reduces to arithmetic-group orbit
finiteness using the Rosati involution and closed orbits in a semisimple
algebra; its cited foundational theorems were not independently re-proved.

**Disposition:** the original-source access gap in A1/D is closed. The
arithmetic deduction and its field/degree/geometric-class quantifiers stay
as in `2026-09-09-c1133-arithmetic-audit.md`.

## Two closest quantum comparisons, now fully read

- Cai, `arXiv:2608.01577v1`, **full text**, all 592 extracted lines,
  eight pages including references. Theorem 1 concerns symplectic
  irrationality of the cubic threefold itself. Sections 3–5 explicitly use
  the cubic exponents, big-parameter transport, curve comparison and integer
  powers in blowup comparison. These are substantial direct precedents.
  The paper does not state a one-stabilization theorem. Its coefficient ring
  permits unbounded negative z-orders across bulk coefficients (Section 2);
  reading it does not establish the present original/canonical-lattice
  contract. No correctness verdict on that different contract is inferred.
- Benedetti–Fay–Guéré–Manivel–Perrin, `arXiv:2607.26718v1`, **full text**,
  all 772 extracted lines, seven pages including references. Theorem 4.1
  requires a Fano hyperplane fourfold with b1=b3=0, the stated vanishing
  cohomology inequality and Hodge generality. Corollary 5.3 also obstructs
  birationality between two fourfold families; attribution must include this
  comparison result, not describe the paper as only an irrationality test.
  Remark 4.2 explicitly distinguishes center-relative evaluation maps from
  unrestricted center evaluations. Thus the center-specialization issue is
  recognized prior work. These results do not directly cover the proposed
  detected threefold products, whose H3 is nonzero.

Both comparisons are auditor conclusions about the fully read pinned versions,
not a claim to have reverified every proof or excluded future revisions.

## Search and access record

Discovery queries on 2026-09-10, verbatim:

```text
"Categorical base loci and spectral gaps" pdf
"Interpretations of spectra" "pdf"
"Polarisations on an abelian variety" pdf
Katzarkov Liu base loci 01473
Katzarkov Lee Svoboda Petkov Interpretations spectra 2023
Narasimhan Nori Polarisations 1981 36463
```

Screened fields: tool-returned titles, URLs and snippets. These are discovery
searches, not exhaustive sets or negatives. Individually promoted sources
already have entries in the source register. Unrelated returned hits were
not used as mathematical sources.

Direct requests, timestamps, status, bytes and SHA-256 are in
`2026-09-10-c1133-source-access.json`. Browser extraction and page screenshots
of the NN PDF failed, but the direct repository GET succeeded. INSPIRE's
record for the categorical-base-loci chapter was also retrieved directly;
it supplies the DOI but no document URL. The Springer chapter landing page
still exposes subscription metadata, not the chapter body.

## Process note

The initial handoff display exceeded the output bound. It was replaced by
five explicit line-range reads, completing the handoff. Subsequent source
reading used pinned files and bounded ranges. No source reading is inferred
from cache presence, and no Lean replay or manuscript theorem promotion is
part of this source pass.

## Stronger equivariant predecessor credit

Cavenaghi–Katzarkov–Kontsevich, *Atoms meet symbols*,
`arXiv:2509.15831v4`, remains **partial**. The additional read covered extracted
lines 1–295, 321–351, 1518–1598, 1739–1810 and 2228–2297. These include
Theorems E/F/H, Examples 2.14/2.19 and Theorem 3.7 at their body locations.

The paper explicitly uses doubling of atomic content under a P¹ product to
obstruct equivariant linearization of a cubic surface product and of a rational
threefold product. It also refines an equivariant threefold invariant by the
isogeny class of a curve Jacobian. These are direct predecessors for the broad
ideas of stabilization via atoms and retaining isogeny information. They are
not just metadata-adjacent titles. Crucially, those passages belong to the
ordinary equivariant-atom sections 2–3; the quantum Chen–Ruan blowup
conjectures are introduced for the separate construction in Section 4.
The earlier checkpoint's conditional Chen–Ruan qualification must not be used
to dismiss E/F/H. This is a distinction of source statements and dependencies,
not an independent correctness certification of all their proofs.

The exact candidate B here concerns **nonequivariant** one-stable birationality
of any two of nine Fano families and their entire rational H³. The inspected
E/F/H statements have finite-group linearization or fixed-locus hypotheses and
different conclusions. They neither supply B verbatim nor license firstness
for a Hodge/isogeny refinement of atomic invariants. The owning novelty ledger
has been updated before any manuscript attribution change.

KKPY v2, **partial**, was additionally read at lines 1–205 and 6710–6805.
Its Example 6.21 explicitly treats the cubic zero atom and ordinary
irrationality via a Serre enhancement. This is credited as a source statement;
its displayed Serre polynomial is not imported into the rank-two proof.

## Remaining mirror leads

Przyjalkowski, `arXiv:2510.23143v1`, is now **partial**, lines 1–205:
Theorem 1.2 counts noncentral ordinary-double-point fibers of Givental-type
Landau–Ginzburg models for Fano complete intersections. It is not a claimed
stabilized-birational classification. Its sole retrieved citing record leads
to `arXiv:2601.16497v1`, now **partial**, lines 1–200, including Theorem 1.5,
Corollary 1.6 and Conjecture 1.13. The latter treats all seventeen Picard-rank-one
families but counts isolated mirror singularities and compares exceptional
collections. Its family enumeration is not the proposed nine/eight rationality
partition. These are statement-level comparisons, not full-paper negatives.
Both original arXiv PDFs are cached with hashes in the source register.

The author-hosted spectra chapter remains **partial at the thesis level**.
The previously omitted lines 18146–18159 and 18596–19054 have now been read,
completing the previously recorded contiguous chapter-body interval
16870–18760 and reading further thesis material/references. The published
Springer version remains unmatched; no full-thesis reading is claimed.

## Citation identity and screened sets

`2026-09-10-c1133-final-source-probe.py` records 13 arXiv landing-page
lookups, 48 independent graph requests and three body probes. Replay with
`python3 notes/2026-09-10-c1133-final-source-probe.py` verifies cached hashes;
`--refresh` is an explicit new network run. Every query URL, UTC timestamp,
status, raw-cache location and SHA-256 is in its adjacent JSON. The earlier
Voisin/Orr and published mirror-note sets retain their recorded coverage.

| Pinned source | OpenAlex | Crossref | Semantic Scholar |
|---|---:|---:|---:|
| arXiv 2307.13555, 2307.03696, 2604.10028, 2508.05105, 2605.29143, 2608.01577, 2606.17884, 2509.15831, 2607.26718, 2607.22074, 2510.21222 (each queried independently) | 0 each | 404 each | 429 each |
| arXiv 2411.02266 | 404 | 404 | 429 |
| arXiv 2510.23143 | 0 | 404 | 1 |
| 10.1007/978-3-031-17859-7_20 | 0 | 0 | 404 |
| 10.1090/pspum/088/01473 | 2 | 2 | 404 |

404 is an unresolved identifier; 429 is rate limitation. Neither is a zero.
The arXiv landing pages supplied no publication DOI except for the framing
source. Absence of that metadata is not proof that no publication exists.

**Rejected alias:** the framing source's arXiv metadata lists
`10.1142/q0592`. OpenAlex and Crossref resolve it to the edited-volume title,
while Semantic Scholar resolves it to the individual paper. The numerical
0/0/1 results therefore compare different objects. The two volume zeros
cannot be reported as paper-level coverage. The precise resolved titles are
retained in the JSON; no title-search substitution was made.

`2026-09-10-c1133-followup-access.json` pins these three complete retrieved
sets, whose returned titles were all read:

- Framing-paper Semantic Scholar: one record, no next token, the already
  registered product-QDM paper. Title and abstract read; no new body exclusion.
- Mirror complete-intersection paper Semantic Scholar: one record, no next
  token, the Picard-rank-one exceptional-collection paper read above. Title and
  abstract read, then primary statement locations inspected.
- Categorical-base-loci OpenAlex: two records, response `meta.count=2`:
  the Newton–Okounkov complexity paper and *Interpretations of spectra*.
  Title screen only; the latter was already a promoted source. The former is
  covered only as a screened-set member, not individually characterized from
  its unseen text.

Verbatim discriminator: “Promote quantum/atomic invariants, stabilization,
Fano rationality, Hodge/isogeny conservation, or ambiguity about those topics;
retain a merely related title without a content-level exclusion.” These sets
are the largest retrieved sets for these probes. Their missing service or
publication-identity coverage remains explicit; no citation-tree closure is
asserted. The one-layer mirror follow-up stops at the inspected theorem
statements rather than opening another recursive citation sweep.

## Final source dispositions and exact blockers

| Item | Disposition |
|---|---|
| A–D imported mathematical statements | Retain the acceptance map's deductions and all F0–A1/G1–G9 hypotheses. The original NN source gap is now closed. No new formal-coverage claim. |
| Core source attribution | Credit the older cubic exponents, KKPY/Cai, Guéré, Iritani/Iritani–Koto, the mirror program, and the ordinary equivariant stabilization/isogeny precedents above at their actual scope. |
| Local sharpness theorem | Statement/version verified again: source commit `f879abf243ac2c02ffd16117e25b075b16e0339d`, TeX SHA-256 `ec0509629e3978b5f728dcfc8b00563d87b036c43723a026e68a54197dba7274`. `thm:two-variable` requires a rational point and stably permutation geometric Picard lattice over a characteristic-zero field. `thm:cubic-level`/`cor:cubics` cover the two displayed TZ series. Partial read of lines 80–174; not a fresh proof/certificate review. |
| Packet §§30–31 pencil | **Withhold from unconditional promotion.** No identified companion source establishes the displayed pencil's toric-rank profile, generic-surface hypotheses or special isogeny theorem. The deduction conditional on those inputs stays valid. Exact path/link requested from the author; neither the two explicit TZ cubics nor ambient generic Torelli substitutes for it. |
| Published spectra chapter | **Access/version gap.** Publisher PDF route returns subscription HTML, not PDF. The cached author chapter is usable at its own identity, but cannot certify the published chapter's exact text. |
| Categorical-base-loci chapter | **Body access gap.** INSPIRE/DOI and publisher landing page resolve; guessed chapter PDF is 404, linked full-book PDF returns a non-PDF access response. The publisher endmatter PDF was cached separately and is not chapter access. |
| Citation graphs | **Coverage gaps remain**, as above; successful sparse counts cannot override errors or mismatched identities. |
| MathSciNet / Google Scholar | **NOT COVERED**; prior recorded authentication/automated-access failures are retained, not negatives. |
| A–D exact priority | **Undecided.** No comprehensive “first” or “no predecessor” claim is licensed by this pass. |

Additional discovery queries: `"Katzarkov" "Liu" "base loci" filetype:pdf`,
`"Categorical base loci" site:math.bas.bg`, and
`"Categorical base loci" site:ams.org`. Only titles/URLs/snippets were screened;
the thesis search hit was not promoted to an individually read source.
The direct follow-up URLs and their bytes are pinned in the followup/secondary
access JSONs. The AMS endmatter is cache key `10.1090/pspum/088#endmatter`,
SHA-256 `a49ff637bbe8110bf573b0f98765853fdafe02f29ec63fd76179597214c918b9`.

## Reviewable hierarchy, without manuscript promotion

The mathematical hierarchy remains A (numerical all-family classification),
then B (whole rational H³ conservation), with C (very-general same-family
cancellation) and D (bounded-degree geometric partner finiteness) as independent
consequences of B plus their respective classical inputs. Numerical A does
not depend on B–D, rank three, odd cubics, motives, or the special pencil.
The strongest supported editorial option is to retain this order, credit the
broader methods as above, and omit the unverified pencil applications.
This is a concrete proposal for the later author review, not approval to
rewrite the manuscript or bypass the remaining literature gate.

## EJ+TT closeout and Mystery ledger

The completed acceptance gate for this chunk is source verification and
traceable attribution, not global novelty closure. The explicit EJ+TT pass
made the following cheap improvements:

- **Settled:** geometric principal-polarization finiteness is directly in NN;
  the secondary-access qualification can be removed without changing D.
- **Settled:** the ordinary equivariant stabilization and isogeny refinements
  in *Atoms meet symbols* must not inherit the separate Chen–Ruan caveat.
- **Settled:** an arXiv-listed DOI may identify a volume, not its chapter.
  Object identity is checked before interpreting citation counts.
- **Open evidence gaps, not mathematical mysteries:** the exact special-pencil
  companion, two published chapter bodies/version match, and graph/service
  coverage. C1133 retains these obligations. No genuine new mathematical
  mystery was exposed by this source-only pass; no incidental discovery was
  promoted or assigned a new C-ID.

## Repeating surfaces and validation

Updated: source register, owning novelty ledger, mathematical acceptance map,
arithmetic report's current source pointer, task card and lane handoff. The
2026-09-09 literature report preserves historical searches with a current pointer.
Not updated: manuscript TeX/bibliography, framed companion exposition, README,
reviewer guide, summary/verification tables, blueprint, formal claim registry,
PDFs, standalone mirrors and releases. Their later actions are enumerated in
the existing literature audit's repeating-surface inventory. No public firstness
sentence was introduced. No Lean/build/export/push/outreach occurred.

Validation: read-depth vocabulary and full-text count; new PDF/raw-response
SHA-256 checks; exact source identities and set cardinalities; scoped
`git diff --check`; cached probe replay. The first accepted source bundle is
commit `50cd50f8b`; the following source/attribution bundle is committed with
this report. C1133 remains ACTIVE; none of the author-retained tasks is closed.
