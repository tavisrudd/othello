# C927 — literature audit of the determinantal node-count proof

**Lane:** `clebsch` (Paper V, `papers/chordal-conference-reconstruction/`)
**Date:** 2026-08-20
**Governs:** `notes/2026-08-20-c927-determinantal-node-count.md`
**Conventions:** `notes/literature-audit-conventions.md`

## Summary

**No source was read at full text.** Eight sources are named below; six were read
`partial` from cached PDF text extractions with the sections named, and two carry
`abstract/metadata only`. One further source, C. Segre's original memoirs, is
`secondary only` through Hassett–Tschinkel. Verdicts that rest on the exact
wording of a proposition quote that wording from the extraction.

The headline verdict is negative for us on the mechanism and open on the
construction:

- The proof mechanism of C927 — a six-nodal cubic threefold is a three-by-three
  determinant, its singular locus is the rank-one locus, and that locus is a
  linear section of the Segre fourfold cut in six points — is **pre-empted and
  classical**. It is C. Segre's determinantal construction, restated as
  Proposition 8 and proved as Propositions 10 and 19 of Hassett–Tschinkel.
- The **equivariant construction of the matrix from the two eigenspaces of a
  conference matrix was not located**, and nothing connecting two-graphs,
  conference matrices, or Seidel matrices to determinantal cubic threefolds was
  located. That negative rests on keyword search plus one screened citing set,
  not on an exhaustive reading, and MathSciNet was not reachable.

Nothing here changes a released manuscript, and no manuscript sentence currently
depends on any of it.

## Claims audited

| # | Claim as C927 states or implies it | Verdict |
|---|---|---|
| C1 | The conference triangle cubic is \(\det M\) for the canonical \(A_5\)-equivariant matrix \(M(x)=\sum_i x_i\,\ell_i\otimes m_i\) assembled from the \(\pm\sqrt5\) eigenspaces of the conference matrix | **not located**; no predecessor found, coverage as stated below |
| C2 | Its singular locus is exactly six reduced ordinary nodes in every characteristic outside \(\{2,3,5\}\) in which five is a square, with no transversality hypothesis | **partly pre-empted**; the statement over \(\mathbf C\) with a genericity or transversality hypothesis is classical, and no positive-characteristic treatment was located |
| C3 | The two members of the invariant pencil are separated by which rank-one variety their \(\PP^4\) meets — the Segre fourfold in six points against the Veronese surface in a quartic curve | **pre-empted in both halves**; the determinantal side is Segre and Hassett–Tschinkel, the symmetric Hankel side is the classical catalecticant description of the secant variety of the rational normal quartic |
| C4 | The mechanism itself: determinantal presentation implies exactly six nodes, via the rank-one locus and the degree of the Segre variety | **pre-empted**, see below |

### C4 in detail, since it is the load-bearing pre-emption

Hassett–Tschinkel state, verbatim from the cached extraction:

> "Proposition 8. Let \(Y\subset\mathbf P^4\) be a generic cubic hypersurface
> realized as the determinant of a \(3\times3\) matrix of linear forms. Then
> \(Y\) has six ordinary double points, in linear general position. Conversely,
> any cubic hypersurface with six ordinary double point in linear general
> position is determinantal."

They attribute it to "C. Segre [35, §12-14]" and say "For completeness, we will
provide an argument in Propositions 10 and 19." Their argument is the one C927
reconstructs, again verbatim:

> "\(Y:=\mathbf P(\Lambda^\perp)\cap\Sigma_2\subset\mathbf P(\Lambda^\perp)\simeq
> \mathbf P^4\) is a determinantal cubic threefold. It is necessarily singular
> along the points of \(\mathbf P(\Lambda^\perp)\cap\Sigma_1\). If
> \(\mathbf P(\Lambda^\perp)\) intersects \(\Sigma_1\) and the smooth points of
> \(\Sigma_2\) transversely then the Bezout theorem implies that the singular
> locus of \(Y\) is \(\{p_1,\dots,p_6\}:=\Sigma_1\cap\mathbf P(\Lambda^\perp)\).
> Note that these give a sextuple of points in
> \(\mathbf P(V)\times\mathbf P(V^\vee)\simeq\mathbf P^2\times\mathbf P^2\)".

That is C927's items 3 and 4 with the same \(\Sigma_1\), the same Segre
identification, and the same Bézout step. The C927 report must not present the
mechanism as new, and its first draft's phrase about novelty being merely
"unestablished" understates this: the mechanism is established prior art.

**What survives as ours.** Two things, both narrow. First, Hassett–Tschinkel
carry an explicit transversality hypothesis — "If \(\mathbf P(\Lambda^\perp)\)
intersects \(\Sigma_1\) and the smooth points of \(\Sigma_2\) transversely" —
whereas C927 proves the corresponding statement for this particular
\(\Lambda^\perp\) unconditionally, by the maximum-distance-separable lemma and
the absence of a size-six icosahedral orbit on \(\PP^1\). This is the same gap
Paper I identified when it wrote that the cited proposition "assumes six nodes"
and proved completeness independently. Second, the construction of the matrix
itself from the conference matrix's eigenspaces (C1). Neither is a theorem about
cubic threefolds that the literature lacks; both are statements about this
specific equivariant object.

## Sources

Every entry carries its read depth. Cached bytes are keyed in the shared
literature cache at `/tmp/persistent/tavis/lit-search/`; the SHA-256 is the
manifest value for that key.

| source | version read | depth | access |
|---|---|---|---|
| Hassett, Tschinkel, *Flops on holomorphic symplectic fourfolds and determinantal cubic hypersurfaces* | arXiv preprint 0805.4162 (30 pp.); the published J. Inst. Math. Jussieu version was **not** read, so every characterisation here is of the preprint | `partial` — the determinantal section: Proposition 8 and its attribution, the \(\mathrm{Gr}(n,W)\)/trace-pairing setup, the \(\Sigma_1,\Sigma_2\) passage, Proposition 10, and the Proposition 19 heading | cache key `arXiv:0805.4162`, sha256 `89ca37f2a5908c3355fda20bda6e8e469d22ffcc5f93232de88a60a7f700f885` |
| C. Segre, determinantal representations of cubic threefolds, §12–14 of the memoir cited as [35] by Hassett–Tschinkel | not read; no edition consulted | `secondary only` — through Hassett–Tschinkel above, whose own depth is `partial`; their Proposition 8 and its attribution line are the entire basis | not obtained |
| Dolgachev, *Corrado Segre and nodal cubic threefolds* | arXiv 1501.06432 (18 pp.) | `partial` — the determinantal-representation passage on projective generation and the Hassett–Tschinkel deduction, plus a keyword screen of the whole text for two-graph, conference, Seidel, icosahedral, \(A_5\), \(S_5\), which returned nothing | cache key `arXiv:1501.06432`, sha256 `98a898303e06a395bad95888a826e677a955d4b8fc88914c6ede54e31406601e` |
| Cheltsov, Marquand, Tschinkel, Zhang, *Equivariant geometry of singular cubic threefolds* | arXiv 2401.10974v2 (67 pp.); this is the work Paper I cites as CTZ2025, confirmed against Paper I's bibliography entry | `partial` — §7: the six-nodal setup, equation (7.4), Proposition 7.3 and its statement of the \(S_6\)-action, equation (7.5), plus a whole-text keyword screen for "determinantal", which returns exactly one hit, in the bibliography, pointing at Hassett–Tschinkel | cache key `arXiv:2401.10974`, sha256 `5fb44374d4a2c1790c6246a522e12df32afc7c9a81c9ca8bcd1ade62215df089` |
| Cheltsov, Marquand, Tschinkel, Zhang, *Equivariant geometry of singular cubic threefolds, II* | arXiv 2405.02744v2 (53 pp.) | `partial` — its own §7, which treats \(2A_2+2A_1\) singularities and is not the six-nodal section; screened for six-nodal and determinantal content | cache key `arXiv:2405.02744`, sha256 `30b5afc9fc5e04ca2c73fe36adb0b466261c639fc72484c3350878a23d9af493` |
| Cheltsov et al., *Equivariant geometry of cubic threefolds with non-isolated singularities* | arXiv 2505.03986v1 (18 pp.) | `abstract/metadata only` — title and first lines from the cached extraction, plus a whole-text keyword screen for "determinantal", zero hits | cache key `arXiv:2505.03986`, sha256 `7c16be3cdd2f21c99da9631de6e11e1b92cc128144b2c57249aeb8f196ed8861` |
| *\(A_5\)-equivariant geometry of quadric threefolds* | arXiv 2508.11496v1 (54 pp.) | `abstract/metadata only` — title and first lines, plus a whole-text keyword screen for "determinantal", zero hits; dismissed as quadrics, not cubics | cache key `arXiv:2508.11496`, sha256 `c0279ed450210aaba183f45eabae9b56a716032b2d7e7323879f1e4c9cb1b976` |
| Cheltsov, Shramov, *Five embeddings of one simple group* | arXiv 0910.1783v6 (36 pp.) | `abstract/metadata only` — abstract and a keyword screen for six-nodal, determinant, nodal cubic; its determinantal material concerns a quartic threefold, so it was dismissed | cache key `arXiv:0910.1783`, sha256 `feddd98638dca0eb233f7982a2bb1c4fee2daf76a7454d15c0bd9a4451ce5856`, fetched for this audit from `https://arxiv.org/pdf/0910.1783` |
| Hitchin, *Vector bundles and the icosahedron* | arXiv 0906.4208 (23 pp.) | `abstract/metadata only` — keyword screen for six-nodal, determinant, nodal cubic; the determinantal material is about plane curves and vector bundles, so it was dismissed | cache key `arXiv:0906.4208`, sha256 `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722` |

Attribution notes, marked as required. The reading that Hassett–Tschinkel's
Propositions 8 and 10 pre-empt C927's mechanism is my own inference from their
stated proposition and argument, not their framing; they present the material as
a classical theorem of C. Segre being reproved for completeness. The
characterisation of Segre's original memoir is entirely theirs and is unverified
against Segre. No bibliographic detail above is asserted from background
knowledge: page counts and titles come from the cache manifest, the Cheltsov
et al. numbering from the cached extractions, and Paper I's identification of
CTZ2025 with arXiv:2401.10974v2 from Paper I's own bibliography entry, which
also records `doi:10.1017/fms.2024.148`.

## Screened set

One screened set backs the C1 negative.

- **Set:** works citing Hassett–Tschinkel, retrieved from the Semantic Scholar
  Graph API for paper id `00cd061b85fa2c413c562c66d9d9a18c6f93d602`, endpoint
  `/graph/v1/paper/<id>/citations?fields=title,year&limit=100`.
- **Size:** 39 records returned, matching that service's reported
  `citationCount` of 39.
- **Fields screened:** title and year only. No abstracts were retrieved.
- **Discriminator, verbatim:** the Python regular expression
  `determinant|nodal|cubic|equivariant|two-graph|conference|Seidel|icosahed|A_?5|characteristic`,
  case-insensitive, applied to the title.
- **Outcome:** 10 of 39 titles matched. None concerns conference matrices,
  two-graphs, Seidel matrices, equivariant determinantal presentations, or
  positive characteristic. The nearest are *Corrado Segre and nodal cubic
  threefolds* and *Equivariant geometry of singular cubic threefolds, II*, both
  already read `partial` above, and *Moduli spaces of Pfaffian representations of
  cubic threefolds*, which concerns Pfaffian representations of smooth cubic
  threefolds and was dismissed on its title. The remaining 29 titles are covered
  by this set record, not individually read.

## Citation-graph counts

Required width, recorded separately rather than aggregated. Seed resolved by
pinned identifier, not by title search at verdict time: OpenAlex work
`W2162997268`, DOI `10.1017/s1474748009000140`, Semantic Scholar paper
`00cd061b85fa2c413c562c66d9d9a18c6f93d602`, arXiv `0805.4162`.

| service | query | count |
|---|---|---|
| OpenAlex | `https://api.openalex.org/works?filter=title.search:Flops on holomorphic symplectic fourfolds determinantal cubic` | 32 citing works on the journal record `W2162997268`, and a separate arXiv record `W2949462952` carrying 2 more |
| Crossref | `https://api.crossref.org/works/10.1017/s1474748009000140` | `is-referenced-by-count` 20 |
| Semantic Scholar | `https://api.semanticscholar.org/graph/v1/paper/DOI:10.1017/s1474748009000140?fields=title,year,citationCount` | 39 |

**The three disagree by nearly a factor of two, which is itself the reportable
finding**: Crossref 20, OpenAlex 32 plus 2 on a duplicate record, Semantic
Scholar 39. The largest set was the one screened. An initial OpenAlex and
Crossref lookup under the DOI `10.1017/S1474748009000188`, guessed rather than
resolved, returned a paper on subconvexity bounds for automorphic L-functions;
that is precisely the mis-resolution the conventions warn about, it was caught by
checking the returned title, and the DOI above was then obtained from OpenAlex by
title search before being used as a key.

Empty versus error was distinguished as follows. OpenAlex and Crossref return
JSON with an explicit result list, and both answered with populated records.
Semantic Scholar returned HTTP 429 with a rate-limit message on first contact,
which was retried after a pause and then answered; a 429 was never treated as a
zero. zbMATH Open returns a status object in which an empty result is
`{"status_code":404,"internal_code":"successful access. No results found."}`,
distinct from a transport error.

## Other services queried

- **zbMATH Open**, free-text document search: `conference matrix cubic
  threefold`, `two-graph determinantal cubic`, and `determinantal cubic threefold
  six nodes` each returned the explicit no-results status above. A control query
  `nodal cubic threefold determinantal` returned one record, *Spherical harmonics
  and the icosahedron*, which is evidently mis-ranked rather than responsive. The
  service is answering, but its free-text relevance on these strings is poor, so
  I treat zbMATH as weak corroboration rather than a strong negative.
- **Web search**, five queries, each screened on titles and result snippets only:
  `conference matrix "cubic threefold" determinantal six nodes two-graph`;
  `"six-nodal cubic threefold" determinantal representation icosahedral A_5
  equivariant`; `"two-graph" OR "Seidel matrix" cubic form "triangle" invariant
  singular points determinant eigenspaces`; `"equivariant" determinantal
  representation "cubic threefold" six nodes group action linear forms
  eigenspaces`; `Segre "determinantal" cubic threefold six nodes "characteristic
  p" positive characteristic proof`; and `"regular two-graph" OR "Paley
  conference matrix" associated "cubic form" OR "cubic hypersurface" singular
  locus nodes`. The determinantal-cubic results were uniformly the sources
  already named. The two-graph and conference-matrix results were uniformly
  combinatorics with no algebraic-geometry connection. No result linked the two
  literatures.

## Coverage

- **MathSciNet: NOT COVERED.** It requires institutional authentication and was
  not reachable from this session. Every negative above must keep "to our
  knowledge" phrasing for as long as this stands.
- **Google Scholar: NOT COVERED**, blocks automated access.
- **C. Segre's original memoir: NOT OBTAINED.** The classical attribution is
  carried entirely by Hassett–Tschinkel. Anything said here about what Segre
  himself proved is secondary.
- **The published version of Hassett–Tschinkel: NOT READ.** Only the arXiv
  preprint was consulted, and proposition numbering may differ in print. Paper I
  already cites the published version as "§3, Proposition 10"; that pinpoint was
  not verified against print here.
- **Searched and found nothing** — this licenses the C1 negative at the stated
  strength: the six web queries, the four zbMATH queries, the whole-text keyword
  screens of the six cached algebraic-geometry sources, and the 39-record citing
  set.

## Novelty text has one home

No claim–proof–novelty ledger row exists for any of C1–C4, and no manuscript
sentence asserts any of them; Paper V's manuscript was not edited. Before any
novelty or priority sentence appears anywhere — manuscript, README, summary index,
or dossier — the owning row must be written first and every other surface must
quote it.

Surfaces that currently characterise this material, checked rather than recalled:

1. `notes/2026-08-20-c927-determinantal-node-count.md` — carried a caution that
   novelty was "unestablished"; **updated** by this audit to record the
   pre-emption of the mechanism.
2. `notes/clebsch-tasks/c927-determinantal-node-count.md` — describes the result
   without a novelty claim; **left as is**, no claim to correct.
3. `notes/2026-08-20-c926-conference-node-completeness.md` — describes the same
   mechanism in its closeout section without a novelty claim; **left as is**.
4. `notes/2026-07-07-codex-task-queue-archive.md`, the C927 row — states the
   result, not its novelty; **left as is**.
5. `notes/handoffs/2026-07-13-clebsch-lane.md` — routing only; **left as is**.
6. `papers/chordal-conference-reconstruction/` manuscript and
   `verification/README.md` — no novelty sentence about the determinantal
   presentation; **left as is**.

## Consequence for the mathematics

None. The C927 proof stands exactly as written; what changes is how it must be
described. Its correct framing is a specific equivariant instance of Segre's
classical determinantal picture, in which the transversality that
Hassett–Tschinkel assume is proved outright for this cubic, and which happens to
work in positive characteristic. If the proof ever enters a manuscript, it should
cite Hassett–Tschinkel's Proposition 8 with the attribution to C. Segre, and
Paper I's existing citation of that same proposition is the model to follow.
