# C363 — backward/forward citation audit for alternate-orbit-repair priority language

**Lane**: `alt-orbit-repair`

**Date:** 2026-07-19
**Status:** REPORTED — the residual diligence named at the end of
[`C143`](2026-07-14-c143-literature-positioning.md) § "Publication recommendation" is discharged
for zbMATH, OpenAlex, Semantic Scholar, Crossref and arXiv. MathSciNet remains **NOT COVERED**.

This report extends C143, which was a broad targeted web search of primary papers and explicitly
not a citation-tree audit. All four claims below carry a verdict. No claim is pre-empted; two
gain a sharper stated boundary.

## Scope and method

### Databases queried

| Database          | Endpoint                                    | Reached | Role in this audit                                  |
|-------------------|---------------------------------------------|---------|-----------------------------------------------------|
| zbMATH Open       | `https://api.zbmath.org/v1/document/_search` | yes     | MSC-scoped subject sweep; reviewer text             |
| OpenAlex          | `https://api.openalex.org/works`             | yes     | forward citations (`filter=cites:`), backward refs  |
| Semantic Scholar  | `https://api.semanticscholar.org/graph/v1/`  | yes     | forward citations where OpenAlex under-indexes      |
| Crossref          | `https://api.crossref.org/works/<doi>`       | yes     | third independent cited-by count                    |
| arXiv             | `http://export.arxiv.org/api/query`          | yes     | preprint title/abstract phrase search               |
| **MathSciNet**    | `https://mathscinet.ams.org/`                | **no**  | **NOT COVERED** — see § coverage statement          |

### Exact query forms

Forward citations, per seed, OpenAlex:

```
https://api.openalex.org/works?filter=cites:<OPENALEX_ID>&per-page=200&page=<N>
    &select=id,title,publication_year,doi&mailto=<mail>
```

Backward references, per seed: the `referenced_works` array of
`https://api.openalex.org/works/<OPENALEX_ID>`, each resolved individually.

zbMATH subject sweep — the following search strings verbatim. A `404` from this API is an
**empty result set**, confirmed during the audit by perturbing a 404-ing query into a near
neighbour that returned hits:

```
cc:51E21 & ti:"PG(2,25)"                                   ->  2 hits
cc:51E21 & any:"Frobenius" & any:"arc"                     ->  2 hits
cc:51E21 & any:"Baer subplane" & any:"arc"                 ->  7 hits
cc:51E21 & any:"involution"                                ->  8 hits
cc:51E21 & any:"Baer involution"                           ->  0 hits
cc:51E21 & any:"orbit" & any:"extension"                   ->  0 hits
cc:51E21 & any:"prescribed symmetry"                       ->  0 hits
cc:51E21 & any:"invariant" & any:"orbits" & any:"complete arc"  ->  0 hits
any:"PG(2, 25)" & cc:51E                                   ->  1 hit
```

arXiv phrase searches, all returning zero results:

```
all:"Frobenius-invariant arc"
abs:"invariant arc" AND abs:"projective plane"
abs:arc AND abs:"Baer subplane" AND abs:extension
abs:"complete arc" AND abs:"Baer"
abs:arc AND abs:"conjugate points" AND abs:"finite field"
```

### Reproducibility

```
cd /home/tavis/src/othello
python3 notes/2026-07-19-c363-alt-orbit-repair-citation-audit.py          # regenerate snapshot
python3 notes/2026-07-19-c363-alt-orbit-repair-citation-audit.py --check  # drift report
```

| Artifact                                                | SHA-256                                                            | Bytes  |
|---------------------------------------------------------|--------------------------------------------------------------------|--------|
| `notes/2026-07-19-c363-alt-orbit-repair-citation-audit.py`   | `b7c9c436f337f736be20664ee90e9a6005674f01a91eff4ea2633ac8b248a611` | 10089  |
| `notes/2026-07-19-c363-alt-orbit-repair-citation-audit.json` | `d7cc5448fadd7209399954a1fd1d4dcb5f2c960d78105864f2ca61de852bece6` | 80126  |

The JSON certifies **what the named databases returned on 2026-07-19** for the pinned seed set and
the verbatim zbMATH queries. It does not certify that the databases are complete, and it is a
snapshot of live services: citation counts grow. `--check` therefore reports drift rather than
asserting byte-equality, and fails only on schema drift or on a *decrease* in a recorded count,
which would mean a query no longer denotes what it denoted. Semantic Scholar rate-limits
unauthenticated callers; a `null` count in the JSON means "not retrieved on this run", never zero.

Seed OpenAlex ids are **pinned** in the generator rather than resolved by title search. This is
load-bearing: during the audit, resolving the Ball–Lavrauw survey by the DOI initially assumed for
it returned `10.4171/emss/28`, which is Proudfoot's Kazhdan–Lusztig–Stanley survey, not an arcs
paper. The correct Ball–Lavrauw DOI is **`10.4171/emss/33`**. Any earlier note carrying
`10.4171/emss/28` for this survey is wrong.

### Coverage statement — what was NOT reachable

- **MathSciNet: NOT COVERED.** `https://mathscinet.ams.org/mathscinet/search/publications.html`
  returns HTTP 302 to institutional authentication. No MathSciNet query was executed and none is
  implied anywhere in this report. Its review corpus and its `MR` citation graph remain unchecked.
- **Google Scholar: NOT COVERED.** Not attempted; it blocks automated access.
- **Full text of Coolsaet–Sticker (2009), `10.1002/jcd.20211`: NOT OBTAINED** (Wiley paywall). Its
  content is characterised here from the zbMATH review plus the corresponding chapters of the
  Sticker thesis, which contains the same classification. Findings resting on it are marked.
- **Full text of Alderson (2026), `10.1007/s10623-026-01807-z`: NOT OBTAINED** (Springer paywall).
  Characterised from its zbMATH review, which states the theorem explicitly. Marked provisional.
- OpenAlex **under-indexes** the Ball–Lavrauw survey: it reports 0 citing works where Crossref
  reports 21 and Semantic Scholar 49. Forward citations for that seed were taken from Semantic
  Scholar. This is a demonstrated coverage gap, not a null result, and it is why three independent
  cited-by counts are recorded per seed.

### Sources newly obtained

H. Sticker's PhD thesis was fetched and added to the shared cache, keyed
`UGent-2012-Sticker-ArcClassification`
(sha256 `a4fb0e2014551520f61e55fe1f3ce479ed6cf4c665d51cd7912110f9ce372201`, 234 pp.), from
`https://cage.ugent.be/geometry/Theses/57/PhDHeideSticker.pdf`. It was read in full text for the
sections cited below. This is the single most consequential source located by this audit.

## Per-claim verdicts

### Claim 1 — main theorem (orbit-valued extension count; arbitrary selected-orbit deletion and different replacement)

**Verdict: SURVIVES**, with one boundary sharpened.

Evidence:

- **The forward citation tree of Baker–Wantz is empty.** OpenAlex, Crossref and Semantic Scholar
  independently report **zero** citing works for `10.2140/iig.2005.2.83`. The closest geometric
  predecessor identified by C143 has, on the evidence of three citation graphs, no successors at
  all — so no descendant of the paired-extension maneuver exists to be checked.
- Its six backward references are Hughes-plane and unital papers (Baker–Ebert on unitals,
  Hughes 1957 on non-Desarguesian planes, Segre-sharpness, Hermitian spreads). None concerns
  counting extensions of an invariant arc. There is no earlier field-theoretic invariant-arc
  extension strand behind Baker–Wantz to trace.
- zbMATH `cc:51E21 & any:"Frobenius" & any:"arc"` returns exactly **two** documents: Baker–Wantz
  itself and Giulietti–Pambianco–Torres, *On complete arcs arising from plane curves*
  (`10.1023/A:1014979211916`). The intersection of "Frobenius" with arcs in the arc/oval MSC class
  is essentially empty.
- `cc:51E21 & any:"Baer involution"` returns **zero**. arXiv has no abstract containing
  "invariant arc" together with "projective plane", and none containing "Frobenius-invariant arc".
- The 49 Semantic Scholar citations of the Ball–Lavrauw survey were screened. The only
  extension-theoretic successor is Alderson (2026), below; the only orbit-theoretic one is
  Li–Yuan, *Cyclic Projective Orbits on Rational Normal Curves and MDS Codes* (arXiv:2607.12761),
  where "Frobenius descent" is a counting tool for GRS polynomials and the orbits are of a cyclic
  operator on a rational normal curve — not conjugate-pair extension of an invariant plane arc.

**Boundary now sharper, and it should be stated.** Extension counting per se is not new, and the
audit found the standard form of it in two places:

1. Sticker's thesis uses `n(T)` = "the number of points of the plane that can be added to `T` to
   create a new arc" as the core of its double-counting consistency check (§ 4.5, p. 95, thesis
   text lines 4961–4962). This is exactly the single-point legal-extension count, computed for
   every arc generated, for all `q ≤ 27`.
2. Ughi, *Small almost complete arcs* (`10.1016/S0012-365X(01)00412-5`), studies arcs for which the
   ratio of points not on a secant — i.e. legal extension points — to the plane's points tends to
   zero. Bounding the legal-extension count is a named research object there. **Provisional:
   characterised from the zbMATH review, not from Ughi's full text, which was not obtained. The
   "named research object" reading is an inference from the review rather than a quotation of the
   paper's own framing; verify against the paper before this sentence carries weight in print.**

Neither is orbit-valued, neither is equivariant, neither carries a deletion quantifier. But the
paper should not present "counting legal extensions" as itself novel; the novelty is the
conjugate-pair simultaneity, the orbit valuation, and the arbitrary-erased-orbit quantifier.
C143 already anticipated this for D-AOR1 ("the counting mechanism alone should not be advertised as
deep novelty"); the same caveat now has a citable predecessor and should be attached to the main
theorem too.

Recommended publication language (unchanged from C143, now backed by citation-graph evidence):

> To our knowledge, previous work does not give an orbit-valued extension count, nor an
> arbitrary-orbit deletion-and-replacement theorem, for arcs invariant under the quadratic field
> Frobenius.

"To our knowledge" should be **retained**, on account of the MathSciNet gap alone.

### Claim 2 — D-AOR1, profile-minimized multiplicity bound

**Verdict: SURVIVES** — no predecessor, and the existing cautious phrasing is right.

Evidence:

- zbMATH `cc:51E21 & any:"orbit" & any:"extension"` returns **zero** documents. There is no
  orbit-valued extension bound in the arcs MSC class.
- `cc:51E21 & any:"prescribed symmetry"` also returns **zero**, which additionally shows that the
  Lisoněk–Marcugini–Pambianco line is not indexed under that class by phrase; its six OpenAlex
  citing works are all complete-arc-size upper-bound papers (Bartoli/Davydov/Marcugini/Pambianco
  and co-authors, 2009–2015). None states a multiplicity or carrier bound.
- Screening the 12 Alderson-MDS citing works and the 28 mmp-pg225 citing works surfaced no
  `E(N-M)`-type carrier count and no profile minimisation.

The existing rule — say **"profile-minimized first-order carrier bound"**, never "sharp minimum" —
stands. The audit found nothing that would let it be strengthened, and nothing that pre-empts it.
Note this is a distinct question from claim 4: `318` remains a non-attained lower bound at `s=7`,
whereas `32` at `q=25` is separately proved attained.

### Claim 3 — D-AOR2, orbit-replacement reconfiguration graph

**Verdict: SURVIVES**, and the negative is now much stronger than C143 could state.

Evidence:

- The three reconfiguration/switching seeds — Ito et al. (260 citing works), Maurer (103),
  Östergård (25) — yield **388 citing works, of which none is a finite-geometry arc
  reconfiguration paper.** Keyword screening over the full citing set for
  `arc|projective|finite geometr|galois|MDS|conic|oval|Frobenius|PG\(|cap|Baer|collineation`
  returned three candidates, all false positives on inspection: one is TS-reconfiguration of
  dominating sets in *circular-arc graphs* (a graph class, not projective arcs), and two are
  Östergård-lineage counts of Latin hypercubes and MDS codes, which switch codeword subsets rather
  than projective columns. The reconfiguration literature has not reached plane arcs.
- The Grassmann-graph line was traced forward. Its successors — *The graphs of non-degenerate
  linear codes* (`10.1016/j.jcta.2022.105720`), *Grassmannians of codes*
  (`10.1016/j.ffa.2023.102342`), *On the graph of non-degenerate linear `[n,2]_2` codes*
  (`10.1016/j.ffa.2023.102282`), *On maximal cliques in the graph of simplex codes*
  (`10.1007/s00022-023-00709-y`), and Kwiatkowski et al. (`10.1016/j.ffa.2025.102784`) — keep
  **codimension-one intersection** as the adjacency throughout. In *Grassmannians of codes* the
  points are `[n,k]` codes of dual distance `≥ t+1` and `X ~ Y` iff `X ∩ Y` is an `[n,k-1]` code of
  dual distance `≥ t+1`. That is not deletion-and-insertion of a conjugate column pair, and no
  successor in this line changes the adjacency.
- Dye's graph remains the genuine finite-projective configuration-graph predecessor. Dye's 13
  citing works are the `A_6`/`A_7`/sextic-curve sequence and the conic-binary-code line; none
  defines a reconfiguration graph on arcs.

C143's rules stand verbatim: say **"quadratic-Frobenius orbit-replacement graph"** and **"local
degree bound"**, distinguish the adjacency from Dye's shared-triangle graph, and make no
connectivity, expansion, rapid-mixing or historical-first claim. The audit adds positive support
for the first-of-its-kind flavour of the *adjacency*, while the fibering-by-fixed-subset caveat is
a mathematical limitation that no literature search can lift.

### Claim 4 — the Q25 exact minimum (32; five residual orbits, 1600 configurations)

**Verdict: SURVIVES** — but this claim is much closer to existing computational work than C143's
"unaffected" note suggested, and the report must position it explicitly against Sticker.

This claim was previously unpositioned. Full attention given; here is what exists.

**The relevant universe is small and was enumerated exhaustively.** zbMATH `any:"PG(2,25)"` over
the whole database returns six documents; restricted to `cc:51E`, exactly one. Only two papers in
the literature classify arcs in `PG(2,25)`:

1. Marcugini, Milani & Pambianco (2007), `10.1016/j.disc.2005.11.094`. Per its zbMATH review
   (Zbl 1114.51005): exhaustive computer search establishing that the **smallest complete arc in
   `PG(2,25)` has size 12**, that complete 19- and 20-arcs do not exist, and classifying the
   smallest complete arcs — **606** inequivalent complete 12-arcs, each with its automorphism group.
2. Coolsaet & Sticker (2009), `10.1002/jcd.20211`, and in full the Sticker thesis (2012).

**What Sticker actually establishes, and why it does not pre-empt.** The thesis is the strongest
existing result in claim 4's domain and states its own scope at p. 2 (text lines 401–404):

> Our methods can also be used to classify the full set of `(k,2)`-arcs and `(k,3)`-arcs, i.e., not
> necessarily only those that are complete, and in that case we think we are the first to obtain a
> full classification of the `(k,2)`-arcs for `q = 23, 25, 27, 29`.

Its § 5.3 table (p. 121) records the number of **PGL-inequivalent** `k`-arcs in `PG(2,q)`,
including incomplete ones. For `q = 25, k = 8` the entry is **419385**. So a published count of
8-arcs in `PG(2,25)` up to projective equivalence exists.

Three separations keep claim 4 intact, and all three are checkable in the source:

- **Wrong equivalence and wrong stratification.** The count is up to `PGL`, not `PΓL`, and the
  incomplete-arc tables are broken down **by size only** — plus, for `(k,2)`-arcs, by the type of
  algebraic curve the arc embeds into (thesis p. 2, lines 236–243). The automorphism-group
  breakdown is given **only for complete arcs**. Since the smallest complete arc in `PG(2,25)` has
  size 12, **no 8-arc in `PG(2,25)` appears anywhere in an automorphism-group-stratified table.**
  There is consequently no published count of Frobenius-invariant 8-arcs in `PG(2,25)`, and a
  fortiori none of those with exactly two fixed points.
- **Wrong quantity.** The thesis computes `n(S)`, the number of single points extending `S`, and
  uses it only inside a double-counting consistency check (§ 4.5, p. 95). It is never minimised,
  never reported per arc, never restricted to conjugate pairs, and never restricted to an invariant
  subclass. Claim 4's quantity — legal **nonfixed conjugate-pair** extensions of a
  Frobenius-invariant arc — does not appear.
- **No extremal statement.** Neither paper states a minimum extension count over any class, and
  neither classifies equality cases of such a minimum. The value `32`, the five residual orbits and
  the `1600` extremal configurations appear in no located source.

Also checked and cleared for this claim:

- Kéri, *Types of superregular matrices and the number of `n`-arcs and complete `n`-arcs in
  `PG(2,q)`* (`10.1002/jcd.20091`), which counts arcs via MDS-code machinery. Per Sticker p. 2
  (lines 390–392), Kéri classifies arcs of size `k ≥ q-8`; for `q = 25` that is `k ≥ 17`, far above
  8. Provisional: characterised from Sticker's description, Kéri's full text not obtained.
- Pace, *On small complete arcs and transitive `A_5`-invariant arcs in `PG(2,q)`*
  (`10.1002/jcd.21372`, Zbl 1310.51009): `G`-invariant **30**-arcs for `G = A_5`, existence for
  `q ≥ 41` and completeness at `q ∈ {109,121,125}`. Group-invariant arcs by computer, but `A_5` is
  a linear collineation group, the arcs are 30-arcs, and the results are existence/completeness —
  not an extension count, not a minimum, not the semilinear Frobenius involution.
- Giulietti & Ughi, *A small complete arc in `PG(2,q)`, `q = p²`, `p ≡ 3 (mod 4)`*
  (`10.1016/S0012-365X(99)00079-5`): a square-order-plane construction from two related conics that
  exploits arc automorphisms to shrink a completeness check. Closest in *setting* (`q = p²`,
  subfield structure, symmetry-reduced computation) of anything located. It does not apply to
  `q = 25` — `p = 5 ≡ 1 (mod 4)` — and produces a construction, not an extension-count minimum.
- Alderson (2026), `10.1007/s10623-026-01807-z`. Per its zbMATH review, it proves that an
  `(n, k+s-1)`-arc in `PG(k-1,q)` of size `n = (s+1)(q+1)+k-3` admits a **unique** extension to a
  maximal arc when `s+2 | q` and `s < q-2`. A Barlotti-type uniqueness result for large arcs in the
  near-maximal regime — the opposite end from an 8-arc in a plane of order 25, and a uniqueness
  statement rather than a count. Provisional: review-based, full text paywalled.

Recommended publication language for claim 4:

> The smallest complete arc in `PG(2,25)` has size 12 [Marcugini–Milani–Pambianco 2007], and the
> `(k,2)`-arcs of `PG(2,25)` have been classified up to projective equivalence [Coolsaet–Sticker
> 2009; Sticker 2012]. Those classifications stratify incomplete arcs by size alone and report
> automorphism groups only for complete arcs; to our knowledge the minimum number of legal nonfixed
> conjugate-pair extensions of a Frobenius-invariant eight-arc with exactly two fixed points, and
> the classification of its extremal configurations, have not previously been determined.

The paper **should cite Sticker explicitly and state the 419385 figure** rather than leave the
adjacency implicit. A reader who knows that classification exists will otherwise assume the result
is a corollary of it; saying plainly which stratification is missing from it is what makes the
claim defensible.

## Closest predecessors found

New in this audit (not in C143):

- **H. Sticker**, *Classification of arcs in small Desarguesian projective planes*, PhD thesis,
  Ghent University, 2012. `https://cage.ugent.be/geometry/Theses/57/PhDHeideSticker.pdf`;
  cached as `UGent-2012-Sticker-ArcClassification`, sha256
  `a4fb0e2014551520f61e55fe1f3ce479ed6cf4c665d51cd7912110f9ce372201`.
  **§ 5.3, p. 121**: table of PGL-inequivalent `k`-arcs, not necessarily complete, `q ≤ 29`; the
  `(q,k) = (25,8)` entry is `419385`. **p. 2, lines 401–404**: the claim to first full
  classification of the `(k,2)`-arcs for `q = 23,25,27,29`. **p. 2, lines 236–243**: complete arcs
  stratified by automorphism group; incomplete arcs by size and embeddable-curve type only.
  **§ 4.5, p. 95**: `n(T)` = number of points extending `T`, used for double-counting validation.
- **K. Coolsaet, H. Sticker**, *A full classification of the complete `k`-arcs of `PG(2,23)` and
  `PG(2,25)`*, J. Combin. Des. **17** (2009), 459–477, `10.1002/jcd.20211`, Zbl 1196.51006.
  Complete arcs listed by size and automorphism-group type. Full text not obtained; characterised
  from the zbMATH review and the corresponding thesis chapters.
- **G. Kéri**, *Types of superregular matrices and the number of `n`-arcs and complete `n`-arcs in
  `PG(2,q)`*, J. Combin. Des. **14** (2006), `10.1002/jcd.20091`, with a published *Correction*,
  J. Combin. Des. (2008), `10.1002/jcd.20181`. Classification of arcs of size `k ≥ q-8`.
  Provisional, via Sticker p. 2; neither the original nor the correction was obtained, so any use
  of Kéri's counts must consult the correction first.
- **N. Pace**, *On small complete arcs and transitive `A_5`-invariant arcs in the projective plane
  `PG(2,q)`*, J. Combin. Des. (2014), `10.1002/jcd.21372`, Zbl 1310.51009. `A_5`-invariant 30-arcs
  by computer; the closest group-invariant-arc classification located.
  **Read depth: zbMATH review only**, plus OpenAlex title/author/year/venue metadata. Full text not
  obtained, not cached. The `q ≥ 41` existence range and the `q ∈ {109,121,125}` completeness cases
  are quoted from the reviewer's summary and were not verified against the paper. Provisional.
- **M. Giulietti, E. Ughi**, *A small complete arc in `PG(2,q)`, `q = p²`, `p ≡ 3 (mod 4)`*,
  Discrete Math. (1999), `10.1016/S0012-365X(99)00079-5`, Zbl 0943.51009.
  Square-order-plane construction from two conics with symmetry-reduced completeness checking.
  **Read depth: zbMATH review only.** Full text not obtained, not cached. The two-conics
  construction, the arc size `k = 4(√q - 1)`, and the computer-verified completeness range are from
  the reviewer's summary. Provisional. The volume was given as "208/209" in the first version of
  this report; that came from background rather than from any source consulted here and has been
  removed, leaving the DOI and Zbl number, which were checked.
- **E. Ughi**, *Small almost complete arcs*, Discrete Math. (2002),
  `10.1016/S0012-365X(01)00412-5`, Zbl 1027.51012. Arcs whose legal-extension points are an
  asymptotically vanishing fraction of the plane.
  **Read depth: zbMATH review only.** Full text not obtained, not cached. The review states that
  for the constructed arcs "the ratio of the number of points not on a secant of the `k`-arc to the
  total number of points in the plane, goes to 0", and separately that an arc is complete iff every
  point of the plane lies on a secant of it. Identifying "points not on a secant" with legal
  extension points follows from those two review sentences. **The further gloss — that bounding the
  legal-extension count is a named research object in this paper — is mine, inferred from the
  review and not verified against Ughi's own framing. Provisional; carried into Claim 1.**
- **T. Alderson**, *When arcs extend uniquely: a higher-dimensional generalization of Barlotti's
  result*, Des. Codes Cryptogr. (2026), `10.1007/s10623-026-01807-z`. Unique extension to a maximal
  arc for `(n,k+s-1)`-arcs of size `n = (s+1)(q+1)+k-3` when `s+2 | q`, `s < q-2`. Provisional,
  review-based.
- **Y. Li, P. Yuan**, *Cyclic Projective Orbits on Rational Normal Curves and MDS Codes*,
  arXiv:2607.12761 (2026). Frobenius descent as a GRS-counting device; orbits of a cyclic operator.
  Checked and cleared — not conjugate-pair extension of an invariant plane arc.
  **Read depth: abstract/metadata only**, and specifically a model-summarised rendering of the
  arXiv `/abs/` landing page rather than the verbatim abstract. PDF not downloaded, full text not
  obtained, not cached. The dismissal rests on the abstract's stated subject matter alone.
  Provisional.

Corrected from C143: the Ball–Lavrauw survey *Arcs in finite projective spaces* is
**`10.4171/emss/33`** (EMS Surv. Math. Sci., 2020). C143 cites it only by arXiv link
(`arXiv:1908.10772`), which is correct; the DOI is recorded here because the neighbouring
`10.4171/emss/28` is a different paper entirely and is an easy mis-resolution.

Predecessors from C143 re-checked and unchanged: Baker–Wantz Lemma 3.1 and Prop. 3.3;
Dye Theorem 8, Prop. 1 and Theorem 7; Blokhuis–Seress–Wilbrink pp. 144–146; Maurer's
single-element exchange; Ito et al. token jumping. Their forward trees were traced and none
produced a nearer successor.

## What this audit does not establish

- **MathSciNet was not consulted.** Its reviews and `MR` citation graph are unchecked. This alone
  is sufficient reason to retain "to our knowledge" on every claim, and no statement here should be
  read as a historical-first finding.
- **Citation graphs are not the literature.** OpenAlex, Crossref and Semantic Scholar disagree with
  each other on every seed in this snapshot; OpenAlex reported 0 citing works for the Ball–Lavrauw
  survey where Crossref reported 21 and Semantic Scholar 49. Older, non-DOI'd, non-English and
  book-chapter work is systematically under-represented in all three. A zero-citation result — even
  the triple-confirmed zero for Baker–Wantz — bounds what these indexes know, not what exists.
- **Two load-bearing sources were characterised from reviews, not full text**: Coolsaet–Sticker
  (2009) and Alderson (2026). For Coolsaet–Sticker the risk is mitigated because the Sticker thesis
  contains the same classification and *was* read in full; for Alderson the zbMATH review states the
  theorem explicitly, but the paper's own remarks on adjacent cases are unread. Kéri's paper was not
  obtained at all and is characterised from Sticker's description of it.
- **Sticker's thesis is the only source in this report read at full text.** Every other predecessor
  entry now carries an explicit read-depth marker in § "Closest predecessors found". Three of the
  dismissals — Pace, Giulietti–Ughi, Ughi — rest on zbMATH reviews alone, and one, Li–Yuan, rests on
  a model-summarised arXiv abstract page. Nothing in the four verdicts depends on those four
  sources: each was consulted to rule a candidate out, and ruling out on an abstract is sound when
  the abstract's stated subject matter is plainly a different object. But none of the four is
  verified at the level Sticker is, and a reader wanting to rely on how any of them is
  *characterised* here should obtain the paper.
- **Absence of a search hit is not absence of a result.** The zero-hit zbMATH queries bound the
  MSC-51E21-indexed, phrase-matching literature. A predecessor phrased in coding-theoretic language,
  filed under a different MSC class, or describing the Frobenius involution as a Baer collineation
  without using either phrase, would not have been caught by them.
- The audit checked **priority**, not **correctness**. Nothing here bears on whether `32`, the five
  orbits or the `1600` count are right; that rests on the C151 kernel-checked evidence and its own
  stated boundary.
- No adjacent-gap extraction was performed and none is warranted, since no claim was pre-empted.

## Recommended language changes

C143's § "Publication recommendation" needs three amendments. These are recommendations for the
lane owner; **this task did not edit the C143 report.**

1. **Add to the main-theorem bullet.** After "distinguish Baker–Wantz's paired-extension maneuver
   explicitly", append: *Do not present legal-extension counting as itself novel — the single-point
   count `n(S)` is standard in arc-classification algorithms (Sticker 2012, § 4.5) and bounding it
   is the subject of Ughi's almost-complete arcs. Claim novelty for the orbit valuation, the
   conjugate-pair simultaneity, and the arbitrary-erased-orbit quantifier.*

2. **Replace the final residual-diligence bullet**, which this task discharges. Current text:

   > - Before priority language, run MathSciNet/zbMATH and backward/forward citation searches from
   >   Baker–Wantz, the Ball–Lavrauw survey, and the MDS Grassmann-graph paper.

   Recommended replacement:

   > - Citation audit discharged in `notes/2026-07-19-c363-alt-orbit-repair-citation-audit.md`
   >   for zbMATH, OpenAlex, Semantic Scholar, Crossref and arXiv; all four claims survive.
   >   **MathSciNet remains unchecked**, so "to our knowledge" stays on every claim.

3. **Add a Q25 positioning bullet**, which C143 lacks entirely — it recorded only that the C151
   claim was "unaffected":

   > - For the Q25 exact minimum, cite Marcugini–Milani–Pambianco (2007) for the size-12 complete-arc
   >   floor and Coolsaet–Sticker (2009)/Sticker (2012) for the `(k,2)`-arc classification, and state
   >   the `419385` PGL-inequivalent 8-arcs figure. Say plainly that those classifications stratify
   >   incomplete arcs by size alone and give automorphism groups only for complete arcs, so no
   >   Frobenius-invariant 8-arc stratum exists in the literature to compare against.

The D-AOR1 and D-AOR2 bullets need no change. "Profile-minimized first-order carrier bound",
"quadratic-Frobenius orbit-replacement graph" and "local degree bound" all survive the audit as
written, and the prohibition on connectivity, expansion, rapid-mixing and historical-first claims
stands.
