# Arcs paper reviewer dossier

**Task:** `C900`  
**Lane:** `relconic`  
**Date:** 2026-08-09  
**Scope:** likely human-proof and mathematical referees for *Arcs complete
outside a conic: a prescribed-hole defect identity and matching-design
rigidity*. Formalization, software, certificate, and artifact-trust review are
deliberately out of scope.

> **REVIEW-SUB-AGENT MATERIAL ONLY.** Do not list, link, or load this dossier
> in the `relconic` handoff, startup context, named-expert routing table,
> ordinary Arcs-paper work, or any Lean task. A parent agent may pass one
> selected packet directly to an Arcs-paper cold-review sub-agent. The
> sub-agent must read that packet before reading the manuscript. Do not give a
> persona the other packets, earlier reviews, the proof audit, or another
> persona's report.

## Bottom line

For a JCTA submission, the most natural board-level routes are **Gábor P.
Nagy**, **Simeon Ball**, or **Maria Montanucci**, with Michel Lavrauw as
editor-in-chief. Nagy is a coauthor of the closest 2024 prior result; Ball's
work supplies the classical small-complete-arc comparison; Montanucci works on
arcs and algebraic curves and coauthored the hyperfocused-arc source that
creates the most important adjacent terminology. A handling editor is not an
anonymous referee.

The highest-value independent cold-read personas are:

1. **Tamás Szőnyi** — priority and theorem-boundary read against the closest
   algebraic uncovered-locus result, plus conic and even-characteristic
   conventions;
2. **Simeon Ball** — adversarial full-paper read of the exact secant identity,
   the claimed improvement over classical moment counts, and the significance
   of the resulting lower bound;
3. **Maria Montanucci** or **Massimo Giulietti** — conic geometry,
   hyperfocused/affine completeness, nucleus cases, tangent language, and the
   upper-branch equality contradiction;
4. **Ian Wanless** or **Brian Alspach** — matching-design conventions,
   simplicity, the one-block-short leave argument, and the partial-geometry
   translation;
5. **Daniele Bartoli** — exact small values, projective classification,
   canonical augmentation, and whether the human account states a credible
   completeness argument without asking the referee to audit code;
6. **Zoltán L. Nagy** — a focused significance read connecting the defect
   count to saturating-set and covering methods while enforcing the arc versus
   saturating-set distinction.

Use one named persona at a time. In particular, do not blend the Ball and
Szőnyi reads or the Alspach and Bartoli reads: their likely objections come
from different standards of evidence. This is a forecast, not inside
information; conflicts, availability, and editorial judgment can change the
actual assignment.

## Editorial assignment and plausible critics

### Editorial route

- **Michel Lavrauw** is JCTA's current editor-in-chief and a finite geometer.
- **Gábor P. Nagy** is the closest subject fit on the current board: finite
  geometry, algebraic curves over finite fields, coding theory, and designs.
  Because he coauthored Korchmáros--Nagy--Szőnyi 2024, he may instead decline
  to handle or referee on proximity grounds.
- **Simeon Ball** is a natural alternate for complete arcs, finite geometry,
  and codes. His 1997 paper is the cleanest classical baseline for what
  "small complete arc" readers already regard as standard.
- **Maria Montanucci** is a natural alternate for finite geometry, algebraic
  curves, and the even-characteristic/hyperfocused boundary.
- **Ian Wanless** or **Marco Buratti** is a plausible second board-level read
  if the editor treats matching-design rigidity as the main combinatorial
  contribution.

Current board and journal standard:
<https://www.sciencedirect.com/journal/journal-of-combinatorial-theory-series-a/about/editorial-board>
and
<https://www.sciencedirect.com/journal/journal-of-combinatorial-theory-series-a>.
JCTA expressly applies a higher significance threshold to very long papers;
that makes theorem hierarchy and compression part of the likely editorial
critique, not merely presentation polish.

### Tier A — plausible primary mathematical referees

#### Tamás Szőnyi

Szőnyi is a coauthor of the nearest prior source, Korchmáros--Nagy--Szőnyi,
*Algebraic approach to the completeness problem for \((k,n)\)-arcs in
planes over finite fields* (2024). That paper uses algebraic curves,
function-field extensions, Galois groups, and Hasse--Weil estimates to locate
uncovered points of special arcs. Its Theorem 7.5 is the exact result an expert
may initially suspect has already done the manuscript's localization work.

Expected critical questions:

- State in one sentence why Theorem 7.5 is not the prescribed-hole theorem.
- Is the new identity valid for every 2-arc in an arbitrary finite projective
  plane, or only after specializing to a Desarguesian conic?
- Which part is genuinely local information about a prescribed hole set, as
  opposed to a repackaging of the first two classical secant moments?
- Are the hypotheses and terminology for a \((k,n)\)-arc, an ordinary
  2-arc, and relative completeness kept separate throughout?
- Does the even-characteristic equality classification accidentally use an
  odd-characteristic conic fact, especially in its tangent/involution step?
- Is the prior-art paragraph strong enough that a reader cannot mistake the
  paper's novelty for the already-known fact that a special arc's uncovered
  locus lies on a curve?

#### Simeon Ball

Ball's *On small complete arcs in a finite plane* begins from the classical
secant distribution and the dual blocking-set interpretation. It records the
elementary square-root lower-bound scale and obtains stronger lower bounds in
important Desarguesian cases by polynomial and blocking-set methods. He is
also a coauthor of the standard modern survey on arcs in finite projective
spaces.

Expected critical questions:

- After summing the local factorization, do the manuscript's identities reduce
  to known moment equations? If so, what survives that could not be recovered
  from the aggregate count?
- The leading term \(\sqrt{2q}\) is classical. Is the claimed contribution
  accurately described as an additive improvement plus equality/stability
  structure, rather than as a new square-root bound?
- Does every invocation of "tangent" distinguish a line meeting the arc once
  from a tangent to the ambient conic?
- Does the proof use only finite-plane axioms before the conic specialization,
  and only field coordinates afterward?
- Are the equality cases and exact small values central enough to justify the
  manuscript's length, or should computational and inverse material be
  shortened or separated?
- Can a reader reconstruct the main proof spine without visiting an appendix
  or trusting a verification statement?

#### Maria Montanucci / Massimo Giulietti

Giulietti--Montanucci, *On hyperfocused arcs in \(PG(2,q)\)*, is the
closest adjacent source for completeness outside a deleted line and for
secants controlled by a small external blocking set. It also brings in
translation arcs and one-factorization language. Either author is positioned
to catch geometric convention errors that a design specialist will not.

Expected critical questions:

- Does "complete outside" mean nonextendible in the complement of the hole,
  and is it never allowed to slide into the global maximal-arc meaning?
- Is the deleted-conic problem genuinely distinct from hyperfocused or
  generalized-hyperfocused secant blocking?
- In characteristic two, are the nucleus, tangent pencil, and conic
  parametrization normalized consistently in every branch?
- Is the induced involution on the conic defined at exceptional points and
  proved to preserve the relevant maximum-index set?
- In the upper equality branch, is the sign contradiction intrinsic, or an
  artifact of a coordinate choice, an orientation, or a hidden division by
  zero?
- Are projective equivalence and field-automorphism equivalence distinguished?

### Tier B — high-value specialist referees

#### Ian Wanless / Brian Alspach

Alspach--Heinrich, *Matching Designs*, is the source of the notation
\(\operatorname{MATCH}(n,k,\lambda)\). Wanless is a current JCTA design
editor and is a more plausible active board route; Alspach is the sharper
intellectual-source persona. The paper's equality statement lives or dies on
using their convention exactly.

Expected critical questions:

- The source permits repeated blocks. Where does \(\lambda=1\) force the
  manuscript's block collection to be simple?
- Is a block a \(k\)-matching, with every pair of independent edges in
  exactly \(\lambda\) blocks, or has it silently become a design on
  vertices?
- In the perfect-matching case, is "hyperfactorization" used or avoided in a
  way consistent with the source?
- Does the one-block-short nonexistence proof establish positive leave degree,
  its divisibility, the forced complete component, and the final integrality
  obstruction in the correct order?
- In translating a matching design to a partial geometry, does the manuscript
  state which parameter convention it uses?
- Is abstract matching-design classification cleanly separated from
  projective realization by secants of an arc?

#### Daniele Bartoli

Bartoli's work repeatedly uses projective equivalence and exhaustive search to
construct or classify small complete arcs and saturating sets. This is the
persona most likely to accept a computational classification in principle but
reject a human explanation that fails to expose the search space, group
quotient, pruning invariant, and completeness criterion.

Expected critical questions:

- For each exact value, what is mathematical proof, what is finite exhaustive
  classification, and what is merely an exhibited witness?
- Is the action used for equivalence \(PGL\), \(P\Gamma L\), or a
  conic stabilizer, and is that same action used in the orbit count?
- Does canonical augmentation enumerate every orbit once, or is that only
  asserted after presenting implementation details?
- Is the connection from classified representatives to the claimed lower
  bound stated in ordinary mathematical language?
- Does the q=16 discussion clearly distinguish the known 2633 projective
  classes of 8-arcs from the stronger new assertion that none has the required
  conic-relative avoidance property?
- Can a human referee judge the theorem without installing Lean or rerunning
  the classifier?

#### Zoltán L. Nagy

Nagy's *Saturating sets in projective planes and hypergraph covers* treats
arbitrary finite planes using probabilistic and transversal methods. It is
adjacent to the uncovered-point problem but does not require the selected set
to be an arc. This persona should test the conceptual value of the defect and
stability statements, not the coordinate calculations.

Expected critical questions:

- Is the local defect a useful obstruction or stability measure, or only a
  restatement of how many outside points are not saturated?
- Which conclusions depend on the no-three-collinear arc hypothesis?
- Is the distinction between a saturating set and a complete arc stated before
  any coding or covering analogy?
- Do the edge- and vertex-stability bounds say something structurally sharper
  than a global count?
- Does the paper identify a route by which the identity could improve the
  remaining polylogarithmic gap, or does it honestly present this as open?

### Tier C — useful alternate or editorial personas

- **Gábor P. Nagy**: closest-source/editorial persona for algebraic curves and
  finite geometry. Use only if the Szőnyi persona is not used in the same
  batch; their priority priors are too correlated.
- **Gábor Korchmáros**: senior conic and arc persona, especially for the exact
  boundary of the 2024 algebraic source and historical attribution.
- **Sam Adriaensen**: active finite-geometry/coding-theory reader well suited
  to arc/MDS conventions, projective equivalence, and exposition accessible
  to a broad JCTA audience.
- **Marco Buratti**: board-level design persona for whether matching rigidity
  earns the paper's prominence and whether the design terminology is standard.
- **Ferdinand Ihringer**: finite-geometry/spectral persona for whether the
  incidence-counting and stability claims are conceptually well positioned.

## Cross-persona criticals, ranked

These are hypotheses to test, not findings. A persona report should locate an
exact passage before promoting one to a defect.

1. **Novelty of the exact remainder.** The manuscript must show why the local
   factorization contains information absent from the classical aggregate
   secant moments and use that information in a nontrivial downstream theorem.
2. **Nearest-prior boundary.** Korchmáros--Nagy--Szőnyi Theorem 7.5 localizes
   uncovered points of a specially constructed \((k,q+1)\)-arc in an
   extension plane. The manuscript treats arbitrary 2-arcs and an arbitrary
   prescribed hole set before specializing. That distinction must be visible
   in the abstract and introduction, not reconstructed by the referee.
3. **Significance and architecture.** For a long JCTA paper, the arbitrary-hole
   identity, matching-design rigidity, and stability should be the causal
   spine. Exact small fields, the inverse coda, and verification details must
   not obscure it.
4. **Classical scale.** The \(\sqrt{2q}\) lower-bound scale is old. The new
   statement is an additive refinement tied to structural equality and a
   two-unit gap; the prose must not imply otherwise.
5. **Matching-design convention.** `MATCH` permits repeated blocks in the
   source. Simplicity at \(\lambda=1\), independence of the edge pair,
   perfect versus nonperfect matchings, and the one-block-short leave must all
   be explicit.
6. **Abstract versus geometric realization.** A classified abstract matching
   design need not be realized by secants in \(PG(2,q)\). The rank-three
   classification must separate external classification, internal
   projective-realizability reasoning, and any finite computation.
7. **Partial-geometry parameters.** Reichard--Woldar use
   \(pg(K,R,T)\) for line size, point degree, and anti-flag connector
   count, while the common \(pg(s,t,\alpha)\) convention subtracts one
   from the first two. Thus their \(pg(5,7,3)\) is commonly
   \(pg(4,6,3)\). A silent convention switch will look like an error.
8. **Even-characteristic equality.** The nucleus-in/nucleus-out split,
   tangent geometry, induced involutions, maximum-index invariance, and the
   final sign contradiction are the likeliest human-proof seam.
9. **Adjacent-object terminology.** Hyperfocused arcs, saturating sets, and
   complete exterior sets solve differently directed incidence conditions.
   None may be used as a synonym or casual precedent for relative conic
   completeness.
10. **Finite exact values.** A human referee needs a crisp proof contract:
    search universe, equivalence group, coverage, and consequence. The review
    is not a software or Lean audit, but the paper cannot substitute a tool
    status for a mathematical completeness statement.
11. **Coding conventions.** A planar arc can be the columns of a generator
    matrix for a three-dimensional MDS code or of a parity-check matrix for a
    codimension-three MDS code. Dimensions and distances change accordingly;
    both conventions occur in the literature.
12. **Low-cost transfer.** The complete-arc upper-bound transfer is an
    averaging argument. It should be useful and clearly stated, but not sold as
    comparable in depth to the defect identity.

## Prerequisite extracts for review sub-agents

These are compact convention and theorem-boundary extracts, not substitutes
for the cited sources. The cache identifiers make the exact local source
recoverable. Any quotation used in a report must be checked against the
source, not copied from this paraphrase.

### Extract B1 — classical complete arcs and the lower-bound baseline

Ball, *On small complete arcs in a finite plane* (1997), starts with a
\(k\)-arc as \(k\) points with no three collinear and calls it complete
when it is not contained in a larger arc. Completeness is equivalently the
coverage of every outside point by a secant. The classical line-intersection
distribution supplies first and second moments; duality turns the secant
picture into a blocking-set problem. The elementary counting scale is
\(k\gtrsim\sqrt{2q}\), while stronger Desarguesian results use polynomial
or blocking-set structure.

What to carry into the review:

- A new local identity must be compared with, not merely derived after, the
  classical moments.
- "Complete" without a modifier means globally maximal in the standard arc
  literature.
- A bound with the same leading square-root term needs an additive,
  structural, or equality contribution to be significant.
- Ball's exact ordinary complete 8-arcs at q=13 do not themselves decide
  completeness outside a fixed conic.

Authoritative copy:
<https://web.mat.upc.edu/people/simeon.michael.ball/complete.pdf>.

### Extract B2 — modern arc, equivalence, tangent, and code conventions

Ball--Lavrauw, *Arcs in finite projective spaces* (survey), defines an arc in
\(PG(k-1,F)\) by the spanning condition on every \(k\) points; in the
plane this is the no-three-collinear condition. Its default projective
equivalence is \(PGL\), not automatically semilinear equivalence. A tangent
to an arc is a combinatorial line meeting the arc in exactly one point, which
must not be confused with a tangent to a curve containing some of the points.
The generator-matrix arc correspondence gives a \([n,k,n-k+1]_q\) MDS
code; a parity-check presentation gives the dual convention.

Cached full text: `arXiv:1908.10772`, SHA-256
`00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`.

Review test: mark every unqualified use of equivalence, tangent, and code
dimension, and demand that the intended convention be recoverable locally.

### Extract K1 — the nearest uncovered-locus theorem

Korchmáros--Nagy--Szőnyi study \((k,n)\)-arcs and construct examples from
algebraic curves. Their completeness method attaches an algebraic curve to the
secant problem and uses function-field/Galois and Hasse--Weil arguments. In
Theorem 7.5, for a rational BKS curve in a suitable extension plane, the
uncovered points of the resulting \((k,q+1)\)-arc are exactly a specified
base-plane locus.

Boundary to preserve:

- their theorem concerns a specially constructed higher-multiplicity arc and
  an algebraically controlled extension setting;
- it is a localization theorem for that construction;
- it does not state the manuscript's exact pointwise defect factorization for
  every ordinary 2-arc and arbitrary prescribed set of allowed holes in an
  arbitrary finite projective plane;
- it nevertheless makes any broad claim such as "the first localization of
  uncovered points" untenable.

Cached full text: `arXiv:2302.10162`, SHA-256
`32cfd5b1cb4f28c171418f61d467fc0accee8adc269ae9cf36a517158917b6b7`.
Official record: <https://arxiv.org/abs/2302.10162>.

### Extract M1 — matching-design conventions and existence boundary

Alspach--Heinrich, *Matching Designs*, defines
\(\operatorname{MATCH}(n,k,\lambda)\) as a collection of
\(k\)-matchings of \(K_n\), with repetitions allowed, such that every
pair of independent edges occurs in exactly \(\lambda\) members. In the
perfect-matching case the object is called a hyperfactorization. Their
"nontrivial" qualifier means that the design is not simply every
\(k\)-matching with a common multiplicity.

The paper records the sharp small existence facts used at the manuscript's
rank-three boundary: no \(MATCH(8,4,1)\), no
\(MATCH(12,6,1)\), exactly two nonisomorphic
\(MATCH(10,5,1)\), and no \(MATCH(7,3,1)\).

Consequences that the manuscript must prove rather than assume:

- At \(\lambda=1\), duplicating a block containing a pair of independent
  edges would overcount that pair; for matchings of size at least two, this
  forces simplicity.
- A classification of abstract blocks is not a classification of their
  projective secant realizations.
- Any leave argument must count blocks through edges and independent edge
  pairs in the source's matching-based incidence structure.

Cached scan: DOI/DBLP key `dblp:journals/ajc/AlspachH90`, SHA-256
`1a9dd6fb3f004d30fd24b6f531e8cd47c950b491768ec3d29b580c01761fedbb`.
Authoritative scan:
<https://ajc.maths.uq.edu.au/pdf/2/ocr-ajc-v2-p39.pdf>.

### Extract M2 — the partial-geometry translation

Reichard--Woldar use \(pg(K,R,T)\), where a line contains \(K\)
points, a point lies on \(R\) lines, and an anti-flag has \(T\)
connectors. Much of the partial-geometry literature instead writes
\(pg(s,t,\alpha)\), with line size \(s+1\) and point degree
\(t+1\). Their \(pg(5,7,3)\) is therefore
\(pg(4,6,3)\) in the common convention. Their source also distinguishes
the two abstract geometries from questions about realization in a particular
projective setting.

Review test: require the manuscript to give the dictionary once, then keep one
notation. Check that every numerical parameter is translated, not merely the
name of the geometry.

### Extract H1 — hyperfocused arcs and a deleted-line convention

Giulietti--Montanucci define a hyperfocused \(k\)-arc in even-order
\(PG(2,q)\) by requiring all its secants to meet an external line in only
\(k-1\) points. The generalized version uses a minimum blocking set of
the secants of size \(k-1\). Their phrase "complete in
\(PG(2,q)\setminus\ell_\infty\)" means that no affine point can extend
the arc. Thus it is a genuine relative-completeness precedent for a deleted
line, but hyperfocusedness is an additional focusing/blocking condition, not a
synonym for relative completeness.

Cached full text: `arXiv:math/0601488`, SHA-256
`feb9f148d51c22df3f9ba35867137a0870ca220b1b233c03b0319de720c263f9`.

Review test: if the manuscript mentions hyperfocused arcs, ask separately (i)
what the allowed extension locus is and (ii) where its secants are focused.

### Extract E1 — complete exterior sets have the opposite containment

Blokhuis--Seress--Wilbrink call a set of \((q+1)/2\) exterior points to a
conic a complete exterior set when every join of two selected exterior points
misses the conic. In uncovered-locus notation this gives
\(C(\mathbb F_q)\subseteq U(A)\): the conic is kept uncovered. The Arcs
paper's relative completeness condition is
\(U(A)\subseteq C(\mathbb F_q)\): all points outside the conic are
covered. The containments face opposite directions.

The source uses the conic stabilizer, the identification of exterior points
with pairs of tangents, passants, and a square/nonsquare cross-ratio test. Its
odd-characteristic classifications are useful background, but its object must
not be cited as if it solved the prescribed-hole problem.

Authoritative page scans and checksums:
`/tmp/persistent/tavis/lit-search/bsw-1992/`. Use the reconstructed OCR only
for search; verify formulas and quotations against the scans.

### Extract S1 — saturating sets are not necessarily arcs

Z. L. Nagy, *Saturating sets in projective planes and hypergraph covers*,
works in arbitrary finite projective planes. A saturating set requires every
outside point to lie on a line through two selected points. The selected set
need not be an arc, so it can have three or more collinear points. The paper's
probabilistic and hypergraph-transversal upper bounds address economical
coverage, not the rigidity imposed by simultaneous saturation and the arc
condition.

Official repository: <https://real.mtak.hu/83892/>.

Review test: every analogy with saturating sets should identify whether the
step uses only coverage or also uses no three collinear.

### Extract C1 — finite classifications and q=16

Al-Seraji--Al-Ogali classify 8-arcs in \(PG(2,16)\) up to projective
equivalence using GAP. They report 2633 projectively distinct classes and no
globally complete ordinary 8-arc, because every representative has an
uncovered point. The Arcs manuscript independently meets the same orbit count
but asks the stronger and differently directed question whether the uncovered
set can lie inside one fixed conic.

Authoritative PDF:
<https://mjs.uomustansiriyah.edu.iq/index.php/MJS/article/download/184/pdf/2715>.

Bartoli and collaborators' small-arc and saturating-set classifications supply
the standard referee expectation: name the equivalence group; reduce by it;
state the extension or coverage test; explain why pruning preserves at least
one representative of every orbit; report enough aggregate counts to make the
search auditable. A paper may rely on finite computation, but the theorem and
the exhaustion argument must still be stated in mathematical prose.

## Reading packets

### Packet B — Ball / classical complete-arc referee

Read Extracts B1, B2, and K1 first. Then read:

1. Ball 1997, especially the opening secant equations, elementary bound, and
   dual blocking-set setup.
2. Ball--Lavrauw, the definitions and code/equivalence conventions.
3. Korchmáros--Nagy--Szőnyi, Introduction and Theorem 7.5 only.

Then read the manuscript abstract through the end of the conic specialization,
followed by the conclusion. Do not read the proof audit or verification
sections. Reconstruct exactly which conclusion uses the pointwise
factorization rather than only its sum. End with a recommendation on JCTA
significance and theorem architecture.

### Packet S — Szőnyi / nearest-prior referee

Read Extracts K1, B1, and H1 first. Then read Korchmáros--Nagy--Szőnyi,
Introduction, its definition of \((k,n)\)-arc and completeness, the
algebraic completeness method, and Theorem 7.5 with all hypotheses.

Then read the manuscript abstract, introduction, exact-defect section, conic
specialization, and conclusion. Give a line-level novelty boundary. Separately
audit the even-characteristic equality proof, with attention to every use of
field parity, conic tangency, and involution. Do not inspect formal or
computational evidence.

### Packet G — Montanucci or Giulietti / conic-geometry referee

Read Extracts H1, E1, B2, and K1 first. Then read Giulietti--Montanucci's
definitions, translation-arc examples, and completeness statements; inspect
the BSW scans only where the manuscript makes a nearby exterior/passant claim.

Read the manuscript conic specialization and equality classifications in full,
including the nucleus section. Require a coordinate-free explanation of each
case before checking its coordinates. Report the earliest parity, tangent, or
normalization step that cannot be reconstructed.

### Packet M — Wanless or Alspach / matching-design referee

Read Extracts M1 and M2 first. Then read Alspach--Heinrich's definitions,
parameter equations, small nonexistence results, and the two
\(MATCH(10,5,1)\) cases. Read Reichard--Woldar's parameter definitions and
classification statement.

Then read only the manuscript's exact-defect equality, concurrency designs,
one-block-short stability, and rank-three equality classification. Ignore
conics, finite-field witnesses, and verification prose. Check every division
and divisibility condition, including degenerate small parameters. Demand a
clean separation between abstract design, partial geometry, and projective
realization.

### Packet C — Bartoli / finite-classification referee

Read Extracts C1, B2, and S1 first. Then sample one Bartoli small-arc
classification for its equivalence and exhaustive-search proof contract, and
read the q=16 classification's theorem and enumeration method.

Read the manuscript finite-field examples and finite-field witness sections,
plus only those earlier statements needed to understand their consequence.
Do not run code or Lean and do not inspect the repository's certificates. Judge
whether the paper itself states a complete human-readable classification
argument and accurately labels every trust boundary.

### Packet N — Z. L. Nagy / significance and stability referee

Read Extracts S1, B1, and K1 first. Then read Nagy's definitions and
hypergraph-cover formulation.

Read the manuscript introduction, exact-defect section, edge/vertex stability,
upper-bound transfer, and conclusion. Ignore exact small-field computations.
Ask whether the defect is a reusable local invariant, whether stability is
quantitatively meaningful, and whether the open asymptotic gap is framed
honestly.

## Cold-read protocol

Each persona receives only the current PDF, one packet above, and this neutral
question set. It does **not** receive this dossier's other packets, the proof
audit, repository state, formal declarations, trust manifests, earlier
reviews, or another persona's response.

1. State the strongest theorem you believe the manuscript proves.
2. Reconstruct its causal proof spine without following appendices or
   verification cross-references.
3. State in one sentence what is new relative to your packet. If that cannot
   be done, explain the overlap precisely.
4. Identify the earliest mathematical implication you cannot independently
   justify from the manuscript and packet.
5. Classify each finding as `FALSE`, `GAP`, `MISSING CITATION`, `CONVENTION`,
   `SIGNIFICANCE`, or `EXPOSITION`.
6. For a proof concern, name the exact hypotheses and the smallest repair that
   would make the implication checkable. Do not ask for a Lean theorem or a
   rerun unless the human statement itself is inherently computational.
7. Give `GO`, `MINOR`, or `MAJOR`, with at most five findings ranked by effect
   on the headline theorem.
8. Name one paragraph, lemma, or section that should be shortened or moved if
   the paper is mathematically sound but overlong.

Freeze all first-round reports before synthesis. Do not allow one persona to
answer another. In synthesis, promote a concern when two independent personas
find the same seam, or when the relevant specialist gives a precise
counterexample or missing hypothesis. Mere difference in taste is not a
mathematical defect.

## Existing internal evidence, withheld from the personas

The manuscript has a separate proof audit recording ordinary-proof boundaries,
external classifications, finite exhaustive computations, kernel-checked
witnesses, and formalized statements. It also records that the q=16 lower
classification has a stronger verification story than the q=13,17,19 lower
classifications, and that formal status is not a substitute for the written
proof.

Do not show that audit to a first-round persona. These facts are priors for
selecting the Bartoli and Ball reads, not evidence in favor of the manuscript.
If a persona independently identifies the same trust or exposition seam, test
the current paper passage directly. The planned reviews concern human proofs
and exposition; artifact trust deserves a separate, explicitly commissioned
review if later wanted.

### Quarantined comparison baseline — initial unpersoned ChatGPT cold read

> **SYNTHESIS ONLY.** This feedback arrived before the persona reviews. Do not
> include it in a persona packet, prompt, manuscript context, or first-round
> report. Compare it with frozen independent reports only during synthesis.

The reader correctly identified the paper's hierarchy as follows:

- the conceptual center is the universal prescribed-hole identity, valid for
  an arbitrary arc and hole set in an arbitrary finite projective plane;
- its value is the pointwise nonnegative remainder and the simultaneous
  equality, gap, stability, and matching-design consequences, rather than a
  new scalar secant-moment inequality;
- the conic problem is the principal specialization, entering through the
  incidence term, equality geometry, and finite applications;
- zero defect gives a simple `MATCH(k,floor(k/2),1)` design and, after duality
  in the Desarguesian case, a rank-three realization;
- the remainder provides both Kneser-edge and vertex-deletion stability;
- the universal q+1-hole bound yields the additive asymptotic lower bound
  `liminf (rho_C(q)-sqrt(2q)) >= 3/2`, while the paper explains why improving
  only the conic-incidence term cannot improve that constant;
- the characteristic-two equality theory was viewed as sharp, with the odd
  case described by an oval whose nucleus lies on the conic and the even case
  reduced to `k=q+2`, followed by the tangent-involution sign contradiction;
- the six-, seven-, and ten-point realization results were recognized as
  substantial secondary results rather than part of the principal spine;
- the exact values at q=13,16,17,19 were understood with their materially
  different trust boundaries;
- the inverse uncovered-locus reconstruction theorem and sharp F5 four-frame
  example were understood as a separate coda.

The reader ranked the current paper at **93--94**, below Paper II (94) and
above Paper I (92), and described the comparison as: the Arcs paper is more
elegant and general, while Paper II is deeper and harder. Component scores
were: correctness 95, novelty 94, theorem strength 93, conceptual elegance 97,
technical depth 91, breadth 96, exposition 92, auditability 93.

The central reservation was not correctness. It was that the identity is
**elementary once found**, being a sharp linear combination of the classical
first and second moments. The reader therefore placed unusual weight on the
novelty boundary, downstream consequences, and the strength of the extremal
problem resolved. This is the most important baseline proposition for the Ball
and Szőnyi personas to test independently.

Recommended changes, in the reader's order:

1. Lead the abstract, introduction, and possibly title with the universal
   prescribed-hole theorem and its matching-design/stability consequences;
   present the conic problem as the principal application.
2. Strengthen the explicit novelty boundary against classical complete-arc
   counts, hyperfocused/affine completeness, prescribed constructions, and
   matching-design theory.
3. Add independent certificate replay or a second implementation for the
   q=17 and q=19 lower classifications, or reduce their equal rhetorical
   prominence beside the kernel-checked q=16 result.
4. Treat an infinite-family `O(sqrt(q))` upper construction as the largest
   possible mathematical upgrade; it would close the present polylogarithmic
   order gap.
5. Strengthen stability from deletion of bad concurrence structure to
   proximity to a particular zero-defect matching design or geometric model.
6. Consider moving some of the ten-point classification, upper-bound transfer,
   inverse reconstruction coda, and verification contracts to supplementary
   material, while preserving the characteristic-two equality theory and
   q=16 material near the main spine.

Comparison tags for synthesis:

- `BASELINE-HEADLINE`: universal theorem should lead;
- `BASELINE-NOVELTY`: elementary identity creates a high literature burden;
- `BASELINE-TRUST`: q=17,19 need stronger certification or less prominence;
- `BASELINE-UPPER`: an `O(sqrt(q))` construction changes the paper's category;
- `BASELINE-STABILITY`: model-level stability would materially deepen it;
- `BASELINE-LENGTH`: secondary classifications and inverse coda may dilute the
  main argument.

## Recommendation

Run four independent first-round reads:

1. Ball persona: full conceptual spine and significance;
2. Szőnyi persona: nearest-prior boundary plus even-characteristic equality;
3. Wanless/Alspach persona: matching rigidity, stability, and rank-three
   realization;
4. Montanucci/Giulietti persona: conic geometry and nucleus cases.

Then run Bartoli as a focused finite-classification read and Z. L. Nagy as a
focused significance/stability read. The acceptance target is not unanimous
`GO`. It is: no two independent readers find the same unresolved major seam;
the Szőnyi reader can state a clean novelty boundary; the matching reader can
rederive the equality and leave arguments under the source convention; the
conic reader can reconstruct every characteristic-two branch; and the Ball
reader agrees that the result clears the significance threshold after any
recommended compression.
