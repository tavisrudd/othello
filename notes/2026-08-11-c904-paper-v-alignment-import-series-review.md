# C904 Paper V alignment-import series review

**Verdict: MINOR**

## Review object and scope

- Frozen artifact: `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`
- Verified SHA-256:
  `4a53b2c415f38bf401216be7492b78aab9255715a55706073662cadea36ee92c`
- Reviewed source commit:
  `5b11e0b923ad9501950b09b9e3895a670b775414`
  (`papers: import six-point alignment recognition into Paper V`)
- Rendered length: 21 pages.  The new lemma is Lemma 3.4 on p. 9; its
  abstract, introduction, and conclusion appearances are on pp. 1, 3, and
  20.
- Comparison surface: Paper III's introduction, aligned-design subsection,
  verification boundary, and conclusion, only as needed to identify the
  series seam.  I did not read old reports, scripts, or certificates.

## Executive assessment

The pair-defect identity is correct.  It gives a clean intrinsic
characterization of the distinguished empty-alignment fibre at the sharp
six-point boundary of Paper III's aligned-design theorem:

\[
 16|A(\Delta)|=\sum_{\{x,y\}}m(xy)^2,
 \qquad A(\Delta)=\varnothing\iff S^2=5I.
\]

This is a genuine mathematical Paper-III connection.  It is not, however,
the mechanism of Paper V's marked round trip.  The identity recognizes the
whole labeled conference locus; the recovered (A_5)-action selects its
opposite fixed pair, and the selected chordal line plus the outer-difference
operator selects and returns the orientation.  Paper V's proof architecture
continues to respect that hierarchy.

The import therefore does not materially duplicate or dilute the round trip.
It supplies a short, independent recognition theorem between the recovered
six-set and the outer-difference section.  The remaining defects are that the
direct relationship to Paper III is left implicit, and that the abstract does
not itself state the marked-versus-unmarked limitation as clearly as the
introduction does.

## Findings

### M1. Name the exact Paper-III seam

The introduction calls the result a second intrinsic description and explains
that it is weaker than the recovered (A_5)-marking, but neither that
paragraph nor Lemma 3.4 says what it resolves in Paper III.  A reader must
independently notice that Paper III proves:

- aligned four-sets are faithful from seven vertices onward;
- seven is sharp because the Ramsey anchor can fail on six vertices; and
- the new lemma identifies the empty-anchor fibre at six vertices exactly as
  the conference locus.

Add one sentence, with the Paper-III citation, after the new introduction
paragraph or immediately before Lemma 3.4.  For example:

> This identifies the distinguished empty fibre at the sharp six-point
> boundary of Paper III's aligned-design faithfulness theorem; it does not
> extend that theorem to arbitrary six-point alignment data.

That last qualification matters: Lemma 3.4 classifies the empty-alignment
fibre, not every nonfaithful fibre at order six.  With this sentence the import
becomes visibly series-causal rather than merely a reuse of Paper III's
vocabulary.

### M2. State the unmarked limitation in the abstract

The introduction is honest and precise: it says that the criterion is weaker
than the recovered (A_5)-marking, records the twelve labeled conference
switching classes, and explains that the marking selects the invariant
opposite pair.  The conclusion also preserves the right order: empty
alignment recognizes the conference locus, while outer difference returns the
conference orientation.

The abstract's new paragraph stops one clause too early.  “The conference
switching classes are exactly the six-point shadows invisible to the
four-point alignment test” is true, but it can be read as if the alignment
datum had already recovered Paper V's marked companion.  Append a compact
boundary sentence, such as:

> This recognizes the unmarked conference locus; it does not select the
> (A_5)-fixed opposite pair or its orientation.

No theorem statement or proof needs to change.

### M3. Complete one new bibliography entry

The two new attributions support the claims assigned to them:

- Gillespie, arXiv:1809.05739v3, Section 4.1, explicitly studies coherent and
  incoherent four-set counts in regular two-graphs.  The cached full text has
  SHA-256
  `3d8e2103efefaf7c24a75129584acb9c968248b53e307989f62c7cf4e6c1fa75`.
- Iranmanesh--Askari Farsangi, Theorem 2.4, proves for every power
  \(\alpha\ge2\) that equality in the Seidel spectral-power bound holds
  exactly for conference graphs; \(\alpha=4\) supports the manuscript's
  “fourth-power equality criterion” description.

The latter bibliography item is incomplete: “published article (2015)” should
be replaced by the journal data
*Journal of Applied Mathematics and Informatics* **33** (2015), no. 5--6,
627--633, with the existing DOI `10.14317/jami.2015.627`.  This is a citation
quality repair, not a change in attribution or priority.

## Proof and architecture checks

- The indicator identity in Lemma 3.4 is correct.  Since
  \(\alpha\beta\gamma=1\),
  \((1+\alpha)(1+\beta)(1+\gamma)/8) equals
  \((1+\alpha+\beta+\gamma)/4\).  Summing first over the three outside
  vertices and then over triples counts each aligned four-set four times and
  yields the displayed factor 16.
- The relation (m(xy)=S_{xy}(S^2)_{xy}) is correct for a zero-diagonal sign
  matrix, and every diagonal entry of (S^2) is five.  Over the integer-valued
  defects, a zero sum of squares is equivalent to all off-diagonal entries of
  (S^2) vanishing.
- The claim about the (A_5)-fixed opposite pair follows from Lemma 3.3 once
  the whole empty-alignment locus is identified with the conference locus.
- Lemma 3.4 is not used in Proposition 4.2 (strict rigidity), and it should not
  be: the marked inverse still depends on the recovered (A_5)-action,
  selected chordal line, normalization, and outer difference.  The manuscript
  correctly calls the alignment route a “second intrinsic description.”
- The rendered insertion is visually clean on p. 9.  It neither strands a
  heading nor obscures the transition to the outer-difference construction.

## Acceptance gate

After M1--M3, this is **GO** for series unity.  No mathematical correction,
new computation, broader literature search, or reorganization of the
round-trip proof is needed.

## EJ + Tao closeout and mystery ledger

The cheap extra-value check is the exact boundary interpretation: Paper III's
Ramsey argument says that seven points force an aligned anchor, while the new
identity says that the maximally invisible six-point objects are precisely
conference two-graphs.  This makes the order-six exception structural rather
than an omitted base case.

No genuine mathematical mystery remains in the imported lemma.  The only open
items are the three editorial gates above: explicitly name the Paper-III seam,
state the abstract's unmarked boundary, and complete the journal metadata.
