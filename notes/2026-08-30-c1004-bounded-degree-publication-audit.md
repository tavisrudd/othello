# C1004 — bounded-degree uncovered-locus publication audit

**Lane:** `clebsch`

**Status:** Complete; placement decided, no manuscript or Ergodis source edits.

## Decision

The smallest honest package is a split forward integration, not a standalone
paper.

1. Put the general bounded-degree theorem, exact root window, odd-order line
   bound, and component envelope in a forward version of
   `papers/arcs_complete_outside_conic/`.  That paper owns the universal
   defect identity, and its inverse coda already studies what the ordinary
   uncovered locus remembers.
2. Put the all-field six-arc cubic tail in
   `papers/clebsch-rigidity/clebsch_rigidity_computational_companion.tex`,
   adjacent to its low-degree census and cross-field uniqueness theorem.
3. Do not edit the main Paper I.  The general result is not Clebsch-specific,
   while the companion already owns the finite `q=11` input needed by the
   cubic tail.
4. Do not open a standalone note from the present packet.  The main estimate
   is a short consequence of the new defect identity and classical point
   bounds, and the closest prior literature already studies minimum-degree
   curves through large finite-plane point sets.  Equality/stability theory or
   an infinite sharpness family would be needed to change that verdict.
5. Do not implement the optional Ergodis adapter now.  The existing
   paper-local low-degree evaluator already covers the finite `q=11` use, and
   a public arc-specific adapter would not strengthen the generic recovery
   engine.  Retain the adapter specification in the C1004 card for a future
   equality census.

No implementation task is allocated until the author accepts this placement;
the two manuscript homes have different owners and must be split explicitly.

## Publication theorem packet

The arcs-paper insertion should present the results in this order.

- **Arbitrary characteristic:** if a degree-`d` form vanishes on the ordinary
  uncovered locus of a `k`-arc, then
  \[
  q^2-(\binom{k}{2}+d-1)q+\beta_k\le 0,
  \qquad
  \beta_k=\binom{k}{2}-k+
  \frac6{\lfloor k/2\rfloor}\binom{k}{4}.
  \]
  State the exact upper root from C1009, not merely the coarse field window.
- **Readable low-degree consequence:** for
  `d <= floor(k/2)-2`, use C1009's parity-linear windows.
- **Minimum vanishing degree:** state the integral bound from C1001 and then
  the stable odd-order improvement
  `delta(A) >= q-binomial(k,2)+3` from C1007.
- **Odd-order factor sensitivity:** state the line-capacity theorem
  `|U(A) intersect ell| <= q-k+1`, then the rational-line and nonlinear
  residual branches from C1007.  The C1010 Aubry--Perret/Bézout formula may
  follow as the factor-sensitive refinement: its linear coefficient is the
  number of rational geometric components, not total degree.

The companion insertion should state one theorem:

> For every prime power `q >= 11`, a six-arc has uncovered locus contained in
> a curve of degree at most three if and only if `q=11` and the arc is the
> Clebsch class; in that class the least vanishing degree is two.

Its proof should use the characteristic-free defect bound to reduce to
`q=11,13`, the factor-sensitive Sziklai argument to exclude `q=13`, and the
existing finite-certificate proposition for `q=11`.  This is stronger and
cleaner than the earlier concurrence-spectrum/golden-root route.

## Priority verdict

The classical inputs are not novel:

- Serre's projective hypersurface inequality supplies `dq+1` in the plane;
- the Homma--Kim resolution of the modified Sziklai conjecture supplies
  `(d-1)q+1` without a rational line component, apart from the unique quartic
  over `F_4`;
- the odd-order focused-direction theorem supplies the line charge; and
- Aubry--Perret plus the conjugate-component Bézout argument supplies the
  component-count refinement.

The closest predecessor located is Aguglia--Giuzzi--Korchmaros, *Algebraic
curves and maximal arcs*.  It asks for the minimum degree of a curve through a
large point set in `PG(2,q)` and treats maximal arcs in depth.  Its elementary
count and component methods overlap the surrounding technology, but its
stated theorems do not specialize the ordinary uncovered locus of a fixed
`k`-arc, do not use a chord-defect lower bound, and do not give the six-arc
cubic tail.  Korchmaros--Nagy--Szonyi later study uncovered points of
high-degree `(k,n)`-arcs arising from curves, but not low-degree containment of
the ordinary uncovered locus of a `2`-arc.

Accordingly, the calibrated claim is:

> No predecessor for the defect-driven uncovered-locus degree obstruction or
> the all-field six-arc cubic tail was located in the searched domain.  The
> result is a new-looking application of classical point bounds, not a new
> point-bound method and not presently a standalone-paper crown.

This is a latent-consequence result: it answers the natural algebraic-
complexity question that the adjacent arc/curve literature located in this
audit does not ask.  Do not use an unqualified “first” claim.

## Literature record

Opening count: **0 sources were read at full-text depth** in this audit.  The
verdict therefore remains explicitly “not located in the searched domain.”

- **Datta--Ghorpade, arXiv:1503.03049v2.** Read depth: `partial`, cached PDF
  and text, key `arXiv:1503.03049`, SHA-256
  `6c6e13b7195e29f8c22fe57c16294adfae83f9fd920c582b8b77646502fb1829`.
  Sections read: abstract, introduction through the statement and sharpness
  range of Serre's inequality, and the reference entry for Serre's 1989
  letter.  Used to verify the arbitrary-hypersurface scope and attribution.
- **Homma--Kim, arXiv:0907.1325v1.** Read depth: `partial`, cached PDF and
  text, key `arXiv:0907.1325`, SHA-256
  `a384aec2f15a8650c6616c0bb5756ca5ac3ef29a2ba2afd954b9af03499a32ac`.
  Sections read: abstract, introduction, modified-conjecture statement, and
  bibliography.  This version proves only the nonsingular branch.
- **Homma--Kim, “Sziklai's conjecture ... III”, DOI
  `10.1016/j.ffa.2010.05.001`.** Read depth: `abstract/metadata only`, from
  ScienceDirect and the Gyeongsang repository record.  Those records say that
  the third paper, together with the previous papers, settles the modified
  conjecture.  The full text was not reachable: ScienceDirect returned HTTP
  403 and the institutional record exposed no file.
- **Aguglia--Giuzzi--Korchmaros, arXiv:math/0702770v3 / DOI
  `10.1007/s10801-008-0122-7`.** Read depth: `partial`, cached PDF and text,
  key `arXiv:math/0702770`, SHA-256
  `6e77ea39de5878d8dba48c90face43c6d3a99e3c1f7fd1517d7c089e6a45732e`.
  Sections read: abstract, introduction, Section 3 setup, Lemma 3.1, Theorems
  3.2 and 3.7, Corollary 3.5, and the associated component decomposition.
- **Giulietti--Montanucci, arXiv:math/0601488v1.** Read depth: `partial`,
  cached PDF and text, key `arXiv:math/0601488`, SHA-256
  `feb9f148d51c22df3f9ba35867137a0870ca220b1b233c03b0319de720c263f9`.
  Sections read: abstract, introduction's odd/even focused-set discussion,
  and references.  It attributes the odd-order minimum to Bichara--Korchmaros
  and the sharply-focused classification to Beutelspacher--Wettl.  The 1982
  Bichara--Korchmaros proceedings paper itself was not reachable in full text.
- **Korchmaros--Nagy--Szonyi, arXiv:2302.10162.** Read depth: `partial`,
  cached PDF and text, key `arXiv:2302.10162`, SHA-256
  `32cfd5b1cb4f28c171418f61d467fc0accee8adc269ae9cf36a517158917b6b7`.
  Sections read: abstract, introduction, and every occurrence of “uncovered”
  leading to the rational-BKS theorem.  Its uncovered set is in a different
  high-degree `(k,n)`-arc setting.

### Search and citation screens

Web searches used the exact queries:

- `finite projective plane arc uncovered points contained algebraic curve secants`
- `k-arc uncovered set polynomial vanishing degree PG(2,q)`
- `finite geometry arc uncovered locus algebraic degree secant union complement`
- `projective arc deep hole syndrome locus vanishing polynomial degree`
- `"uncovered points" "secants" arc algebraic curve`
- `"minimum degree" curve containing "uncovered" arc finite plane`

Two OpenAlex searches were saved, with search strings
`"uncovered points" secants arc curve` and
`minimum degree curve containing point set projective plane arc`.  The first
returned three records, two versions of the 2024
Korchmaros--Nagy--Szonyi paper and one unrelated additive-code preprint.  The
broader minimum-degree query returned 33,198 records; its first 50 title/DOI
records were screened and was too noisy to support an absence claim.  The raw
responses and hashes are below.

For the closest predecessor DOI, citing-work counts disagreed: OpenAlex `4`,
Semantic Scholar `10`, Crossref metadata `4`.  The largest set, all ten
Semantic Scholar records, was screened over title and available abstract with
the discriminator
`uncover|minimum degree|algebraic curve|secant|vanishing|point set`; none was
promoted.  OpenAlex's four records were separately title-screened and all
concern Mathon maximal arcs.  Crossref citing-work enumeration returned HTTP
400 because its works route does not support a `reference` filter; this was an
error, not an empty set.  Consequently the three-graph closure requirement is
not met and the audit does not claim citation-graph exhaustiveness.

Raw responses under `/tmp/persistent/tavis/lit-search/audits/c1004/`:

| file | SHA-256 |
|---|---|
| `crossref-citations.json` | `74305ff2c349a6c5eb9f7e94c502be164d0b78d9e2ff065042273a0636be542b` |
| `crossref-seed.json` | `cadfc5eb250549edf5196b01ef01efda9e8ed791e24e3161f797fae962eaa658` |
| `oa-search-min-degree.json` | `34f5e69de62c9a3eacb89fe9aaa91d0c04cd24cc33719fc42e09d61c1e2b0911` |
| `oa-search-uncovered.json` | `757af4b5879687542ffd0a29373c722633e1c5941bb3b5dce30c5d7166f78092` |
| `openalex-citations.json` | `ac20ca0c650576858350a0cb32288cf08127c457031f487425ff807be1e9583c` |
| `openalex-seed.json` | `70862883023af9ad7615790288e645725b37a5fa55e0a1da5f890d901e41045e` |
| `s2-citations.json` | `5132d108f13a03b6685e7324eea02236e229e09315df76c267f485ce0a0733ce` |
| `s2-seed.json` | `1b26ad5b0d85fd37c623cc4d4a1b98a7bb0a7a2df3e16887d1d940130875e45f` |

Coverage gaps: MathSciNet was not accessible; Google Scholar automated access
was not attempted; zbMATH Open keyword/title results were inspected through
web search but not exhaustively enumerated; the Homma--Kim III and original
Bichara--Korchmaros full texts were not obtained.  These gaps forbid a
categorical priority claim.

## Post-acceptance deliverables

### Arcs-paper owner

- add one algebraic-complexity subsection immediately before the inverse
  uncovered-locus coda;
- add primary citations for Serre, Homma--Kim, the focused-direction input,
  Aubry--Perret, and Aguglia--Giuzzi--Korchmaros;
- add claim--proof--novelty rows for the general obstruction, exact window,
  odd line bound, and component envelope, with novelty wording pointing to
  this audit rather than copied elsewhere;
- map the defect lower bound to its existing Lean theorem, the point bounds to
  cited inputs, and the remaining algebra to human proof; retain C1009's exact
  script/JSON/hash as supplemental evidence if the numerical examples remain;
- update the paper README, evidence map, formal annotations, result snapshot,
  portfolio summary, deterministic PDF/release checks, and then the standalone
  mirror under the export conventions.

### Clebsch-companion owner

- add the all-field cubic-tail theorem and the short `q=13` factor proof;
- reuse the existing `q=11` low-degree certificate rather than create a new
  census;
- add the theorem to the companion claim/evidence/novelty surfaces, and update
  only the companion-facing abstract or conclusion if the theorem is promoted
  to headline status;
- update the result snapshot and public summary by quoting the owning novelty
  ledger row, then run the paper and release gates and synchronize the mirror.

No current manuscript, summary, mirror, release, formal-annotation, or Ergodis
surface has been changed by C1004.

## `ej` + `tt` closeout

The closeout found one free strengthening of the placement decision: the arcs
paper should lead with C1009's exact root and treat the coarse linear window
only as a corollary.  It also found a subtraction: the main Paper I gains
nothing from duplicating a theorem whose natural owner is now the general
arcs paper.

The most valuable later mathematical upgrade is equality/near-equality for
the odd component envelope.  It would have to combine extremal Sziklai curves,
near-minimal chord defect, and the Hilbert function of `U(A)`.  This is not
allocated because current evidence does not show either an attaining family
or a credible short obstruction.

## Mystery ledger

- **Sharpness of `delta(A) >= q-binomial(k,2)+3` — open.**  No attaining
  infinite family was found.  This is the exact gate to reconsidering a
  standalone paper.
- **Even-characteristic component envelope — structurally open.**
  Hyperfocused arcs prevent the odd line charge from transferring unchanged;
  a valid theorem needs an explicit hyperfocused branch.
- **Priority closure — bounded but incomplete.**  The closest predecessor and
  its largest available citing set were screened, but two primary full texts,
  MathSciNet, and three-graph citation enumeration remain uncovered.  The
  wording above is calibrated to that gap.
- **Ergodis adapter — settled for this task.**  No implementation now; revive
  only if a future equality census needs uniform syndrome/Veronese
  certificates.
