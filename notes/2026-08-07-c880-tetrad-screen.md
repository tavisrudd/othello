# C880 — vanishing-tetrad screen

**Task:** C880 (`clebsch`), work item 6 extension, run before item 7 drafting.
**Scope:** one bounded body of work — vanishing tetrads and the quartet tests
built on them — which the completed audit
(`notes/2026-08-07-c880-literature-audit.md`) did not name among its five
bodies. Everything that audit settled stands; nothing here reopens it.

**Read-depth summary: no source here was read at full text.** One was read at
`partial` depth, one at `secondary only`, and the rest at `abstract/metadata
only`. Every verdict below is qualified accordingly, and the coverage statement
names what could not be reached.

## Verdicts

**1. Pre-emption of the query-complexity claims: none located.** No screened
source states a minimum number of four-variable tests needed to determine a
structure, an optimality claim for such a family, or a lower bound of any kind on
that count. The one paper that counts four-set tests at all — Kummerfeld and
Ramsey — counts them as a worst-case algorithmic cost, \(\binom n4\) quartets,
with no claim that fewer suffice and no lower bound. This does not license
"first": the screen is shallow, and its negative is bounded by the coverage
statement below.

**2. The setting item 8 asks for exists, and it is this one.** Item 8 asks
whether any real setting has a four-set indicator as its primitive observation.
It does. In the FindOneFactorClusters algorithm the primitive observation is one
yes/no bit per quartet of observed variables — whether all three of its vanishing
tetrad constraints hold — and the reported worst-case cost is exactly a count of
those bits: *"FindPureClusters dominates the algorithm's complexity, which in the
worst case requires testing n choose 4 sets of variables, and each quartet
requires testing 2 of the 3 possible vanishing tetrad constraints"* (Kummerfeld
and Ramsey, section 3). Each bit is a statistical hypothesis test on sampled
data, so its cost is real rather than notional.

That is a genre match, not a decoder comparison, and the difference has to be
kept visible. The object recovered there is a clustering of observed variables
under a one-factor measurement model, not a two-graph; the bit reports vanishing
of covariance minors, not coherence of triple signs; and no result there is
stated in units that our \(3n^2-23n+45\) could be measured against. **The
matched-units comparison item 8 requires is therefore not available from this
body of work, and no speedup may be claimed against it.** What may be said is
narrower and still worth saying: a four-set indicator oracle is not an invention
of Paper III, and one deployed algorithm pays per query in samples.

**3. "Redundant" is an occupied word here, and the report's use of it must be
disambiguated.** Confirmatory tetrad analysis has an established notion of
*nonredundant* vanishing tetrads: *"For many models some of the vanishing
tetrads are redundant... one must select a set of nonredundant tetrads in order
to be able to calculate the inverse of the asymptotic covariance matrix"*
(Bauldry and Bollen, describing Bollen and Ting). That is rank-redundancy inside
the constraints a *fixed* model implies, selected so a test statistic exists. Our
redundancy — that the anchor's own test can be dropped from the manuscript's
selected family without losing separation — is a different relation: a family
either does or does not separate every pair of two-graphs. A reader from that
field will read the word the other way unless the sentence says which is meant.

**4. Counting tests as the complexity measure is an established genre in
structure learning, so it cannot be framed as new.** Franquesa Monés, Zhang and
Uhler give an algorithm using \(p^{O(s)}\) conditional-independence tests and
prove that any constraint-based algorithm needs at least \(2^{\Omega(s)}\) of
them, "establishing that our proposed algorithm achieves exponent-optimality up
to a logarithmic factor in terms of the number of conditional independence tests
needed" (abstract). Their oracle is not ours and their bound says nothing about
four-set tests, but the shape of the claim — upper bound, matching lower bound,
both measured in tests — is exactly the shape C880 is producing. Any manuscript
sentence must position the contribution as query complexity *for the alignment
oracle*, not as bringing query counting to structure learning.

**5. A structural analogy, recorded as this task's own inference and not as
anyone's claim.** A vanishing tetrad \(\sigma_{ij}\sigma_{kl} -
\sigma_{ik}\sigma_{jl}\) is unchanged in its vanishing by rescaling each variable
\(x_i \mapsto c_i x_i\), because every term acquires the same factor \(c_ic_jc_kc_l\);
so the tetrad bit, like the alignment bit, is one bit per four-set that is blind
to a diagonal gauge. Alignment is blind to diagonal sign switching, the tetrad to
diagonal positive scaling. No screened source states this comparison, and it is
formal rather than mathematical: the tetrad bit reports a rank condition on a
two-by-two minor of a covariance matrix, the alignment bit a coherence condition
on four triple signs, and neither determines the other. It belongs in a report,
not in the manuscript.

## Consequences for item 7 drafting

These constrain the drafting; they do not draft it.

- Any sentence claiming the four-set alignment test as an unusual or novel
  observation model is unsupported. Cite Kummerfeld and Ramsey for a four-set
  indicator in use, and keep the restriction explicit: theirs decides vanishing
  of covariance minors, ours decides coherence of triple signs.
- The word "redundant", where the report means "removable without losing
  separation", says so in full the first time.
- No applications paragraph derives from this body of work. Item 8's acceptance
  condition — a named baseline, its cost and this decoder's cost in the same
  units — is not met by it, and the report says so rather than reaching for the
  analogy.
- Positioning of the complexity result names the existing query-counting genre in
  structure learning, so a referee does not read the framing as a claim to have
  introduced it.

## Sources

| source | identifier | read depth | record |
|---|---|---|---|
| Kummerfeld, E., and Ramsey, J. *Causal clustering for 1-factor measurement models.* KDD 2016 | DOI `10.1145/2939672.2939838`; PMID 27766182 | partial | Open-access PubMed Central copy `PMC5066593`, read through an automated extraction of the article HTML; sections 2 (trek separation) and 3 (algorithm and complexity) relied on, with the complexity sentence returned verbatim and quoted above. Not obtained as the published ACM version. |
| Bauldry, S., and Bollen, K. A. *tetrad: A Set of Stata Commands for Confirmatory Tetrad Analysis.* Structural Equation Modeling 23(6):921–930, 2016 | DOI `10.1080/10705511.2016.1202771` | partial | Open-access PubMed Central copy `PMC6663104`, read through an automated extraction; the definition and nonredundancy passages quoted above are verbatim from it. |
| Bollen, K. A., and Ting, K.-F. *Confirmatory tetrad analysis.* Sociological Methodology 23:147–175, 1993 | none obtained | secondary only | Characterised entirely through Bauldry and Bollen above, whose own depth is `partial`; the bibliographic line is theirs, not ours. Two companion papers they cite — Bollen and Ting, Sociological Methods & Research 27:77–102, 1998, and Psychological Methods 5:3–22, 2000 — were not consulted at all. |
| *Learning the Structure of Linear Latent Variable Models.* Journal of Machine Learning Research 7:191–246, 2006; first author Ricardo Silva | JMLR volume-7 abstract page | abstract/metadata only | The abstract page reports no test count, no subset selection of tetrads, and no complexity claim; the paper's body, which is where a count would live, was not read. Two automated extractions of the same listing returned the second author's surname differently ("Schiene", "Scheine"), so the full author list is not pinned here and must be taken from the paper before it is cited. |
| Franquesa Monés, M., Zhang, J., and Uhler, C. *On the Number of Conditional Independence Tests in Constraint-based Causal Discovery.* arXiv:2603.21844, 23 March 2026 | arXiv:2603.21844 | abstract/metadata only | Abstract retrieved verbatim from the arXiv listing page and quoted above. No four-variable or tetrad test appears in it. |
| *A generalized tetrad constraint for testing conditional independence given a latent variable* | arXiv:2504.14173 | abstract/metadata only | Retrieved as a search result and screened on title and snippet only: it generalizes the tetrad constraint to nonlinear and nonparametric models and carries no counting claim. Promoted no further. |

## Screened sets

Three search-result sets, each screened on title and returned snippet only, with
the discriminator *"does this source count four-variable tests, bound their
number, or select a minimal family of them?"*:

- eight results for `vanishing tetrad constraints latent variable structure
  learning number of tetrad tests required`;
- seven results for `Bollen Ting confirmatory tetrad analysis nonredundant
  vanishing tetrads basis number`;
- eight results for `FOFC scalable reduce number of tetrad tests O(n^4)
  computational complexity latent clustering Kummerfeld Ramsey`;
- nine results for `"tetrad" constraints minimum number of tests needed identify
  structure lower bound query complexity algebraic statistics quartet indicator`.

Members promoted out of these sets for individual treatment appear in the source
table with their own read depth. The remainder — Stata and R package pages, the
Tetrad Java library javadocs, triad-constraint papers for non-Gaussian latent
discovery, group-testing and property-testing papers, and mixed-data causal
discovery comparisons — were screened out on the discriminator and are covered by
this set record.

## Coverage statement

**Searched and found nothing** — the four query sets above, over web search
results, for a minimum number of four-variable tests, an optimality claim, or a
lower bound in the tetrad literature.

**Could not access, and carried forward as open gaps.** Each of these licenses
nothing:

- MathSciNet: not reachable from this session; recorded NOT COVERED, so "to our
  knowledge" stays on every claim it would have gated.
- zbMATH Open: reachable in principle, not queried in this screen.
- Spearman's original tetrad-difference papers: not obtained at any depth.
- The tetrad representation theorem of Spirtes, Glymour and Scheines, and the
  generalization by Shafer, Kogan and Spirtes: known to exist from secondary
  mention, not obtained. This is the most likely place for a statement about
  *which* tetrads suffice, which is the closest thing in this literature to a
  separating-family question, and it is unread.
- No forward-citation enumeration was run for any seed, in any of OpenAlex,
  Crossref or Semantic Scholar; one Semantic Scholar API call returned HTTP 429
  and was not retried. **No verdict here rests on an enumerated citing set**, so
  the three-service requirement of `notes/literature-audit-conventions.md` is not
  triggered — but for the same reason this screen cannot be upgraded to a
  pre-emption verdict without that work.
- Nothing was added to the shared literature cache: no source was fetched as a
  document, only as extracted page text.

## Where this goes

Novelty wording for Paper III lives in the row of its claim–proof–novelty ledger
that owns the complexity claim, and C816 owns writing it. This report is an input
to that row, not a second home for it.
