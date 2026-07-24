# C545 cold-review revision

Date: 2026-07-24

## Result

The manuscript-local response to the new cold review is complete.  The
paper remains one integrated work for the release candidate; no split,
external upload, DOI request, or repository publication was attempted.
The revised PDF is a clean 40-page build.

## Changes

- Rewrote the abstract opening so the all-field redundancy-five
  classification is unmistakably the headline result.
- Replaced the dense five-column overview table by two coordinated,
  readable tables.  The first isolates mathematical dependencies and
  imported inputs; the second isolates conclusions, electronic
  evidence, radius gates, and scope boundaries.  Neither table is
  compressed to script-size type.
- Added a compact referee roadmap immediately after the tables.  It
  gives the shortest R5 proof chain, identifies the later recursive
  dependencies, marks the independently readable characteristic-two
  sections, and says exactly which finite claims require the
  supplement.
- Corrected the stale overview descriptions of R8 and R9: both are
  unconditional classifications in their stated high-field ranges,
  not conditional targets.
- Added a coding-consequences and recognition subsection.  It explains
  the one-column MDS-extension payoff, exact projective counts, the
  fixed-redundancy recognition procedure, its linear-algebra cost, and
  the boundary between recognition and general decoding.
- Sharpened the complexity statement: the displayed cubic bound counts
  online field operations at the fixed redundancies in the paper,
  treats bounded-degree factorization and frozen orbit tables as
  fixed-degree work, excludes preprocessing and field construction,
  and is not a uniform arbitrary-redundancy decoder bound.
- Printed all 17 sporadic redundancy-five syndrome representatives,
  orbit sizes, stabilizers, and nontrivial Frobenius fusions.
- Added an independent-total table comparing direct syndrome
  enumeration, orbit--stabilizer sums, and the theoretical
  nonsporadic-plus-sporadic decomposition.
- Expanded the claim-specific PRS/MDS literature from 15 to 19 entries
  with explicit-family, generalized-projective, even-characteristic,
  and recent MDS-extension work.  The literature audit records the read
  depth and cache evidence for the additions.
- Completed the arXiv metadata for the recent preprints used for
  novelty and imported inputs, including stable URLs and exact version
  dates; journal metadata remains in place where the work is published.
- Reduced the main-text verification apparatus: removed the redundant
  trust-route diagram, moved the statement-adequacy appendix out of the
  printed paper, and condensed the Lean discussion to its exact
  mathematical/nonformal boundary.  Detailed declarations remain in
  the supplement.

## Validation

From `papers/beyond4_prs/`:

```text
make check
exit=0

python3 supplement/verify.py
verified 56 bundled evidence artifacts
classification records: PASS
verified classification-record hashes
```

The rendered review checked both dependency tables, the referee
roadmap, the exceptional representative inventory, and the final two
pages.  Nothing clips or escapes the page.  Small bibliography type
compresses the formerly sparse final reference page without shrinking
Table 2.  The canonical PDF has 40 pages, 287415 bytes, and SHA-256
`0556a9a22767f3216125588b5398e2eb2d1cc414dbd48532e9c8771b6c86db92`.

## Submission architecture

The cold review makes a two-paper split plausible but does not make it
automatic.  The current recommendation is:

1. retain the integrated manuscript for the immutable preprint/DOI,
   because it records the full dependency chain and priority boundary;
2. obtain the two independent mathematical audits already required for
   release;
3. decide the journal architecture after those audits and the target
   venue are known.

If split for journal submission, the clean boundary is a coding paper
through redundancy six or seven and a geometric paper on coherent polar
induction, R8/R9, and characteristic-dependent carriers.  The papers
must have disjoint theorem payloads and explicit provenance back to the
integrated preprint; this is an author/venue decision, not an editorial
change to infer during C545.

## Post-DOI queue

1. C531 then C532: remaining degree-nine Lucas strata and redundancy-ten
   synthesis.
2. C535 then C536: Hessian--Arf functoriality and the first plausible
   uniform contained-component/Fano theorem.
3. C533: sharpen the ordered-Hessian threshold and deletion constants.
4. Separate feasibility gates for bounded R8/R9 completion and the
   small-field R7 covering-radius premise.
5. A coding-recognition implementation only after the theorem-level
   orbit normalizers are frozen; the paper now states the mathematical
   algorithm but does not ship a production decoder.

## Extra-juice and Tao closeout

The closeout asked what an expert referee would still be forced to
reconstruct.  The cheap task-owned answers were the dependency map,
canonical sporadic representatives, independent count equalities, and
the recognition boundary; all are now printed and validated.  The
remaining pressure is not another explanatory diagram.  It is
independent verification of the component exhaustions and a release
artifact that a referee can actually cite.

### Mystery ledger

- **Why did successive reviews still call the proof hard to audit?**
  Settled editorially: the previous article had the facts but dispersed
  them across theorem maps, certificates, and supplement prose.  The
  printed dependency map and representative table now expose the two
  missing local interfaces.
- **One paper or two?**  Open strategic choice.  Independent audits and
  venue selection own the evidence needed to decide; C545 does not
  silently split the theorem chain.
- **Uniform contained-component theorem:** open mathematics, owned by
  C536 after C535.  Current induction remains correctly level-specific.
- **Remaining degree-nine Lucas strata and redundancy ten:** open,
  owned by C531 and C532.
- **Threshold sharpness:** open but nonblocking, owned by C533.
- **Bounded R8/R9 fields and small R7 radius cases:** open completion
  problems requiring separate feasibility gates; no field census is
  authorized here.
- **Artifact citability and correctness confidence:** still release
  gates.  C542--C544, two independent mathematical readers, full clean
  export/replay, immutable identifiers, and author confirmation remain
  required.
- **Bibliography breadth:** improved from 15 to 19 claim-specific
  sources, and the recent preprints now have stable identifiers,
  version dates, and URLs.  A venue-specific final pass remains
  appropriate.  No negative novelty claim is licensed beyond the
  recorded search boundary.

## Vibe check

Good and materially less fragile: the paper now presents its evidence
at the same granularity a skeptical referee will inspect, and the
highest-value overview material is visually easy to scan.  The dominant
risk has shifted to independent audit and release discipline, with the
one-paper/two-paper choice a strategic upside rather than a manuscript
defect.

## Fable follow-up

The next review produced four safe manuscript changes and three new
computational programmes.

- The abstract and introduction now lead with the classification and
  exact projective counts of one-column MDS extensions, while retaining
  the syndrome formulation used by the proofs.
- Section 5 contains a fully worked redundancy-six example over
  `F_29`: it computes the Hankel kernel, rules out a persistent common
  factor, contracts at the marker zero, factors the lower cubic, checks
  marker avoidance, and lifts a squarefree quartic.
- The former long R8 lower-package proof is split into named bottom
  strata, monodromy/deletion, two-marker selection, and outer-marker
  selection lemmas.  The proposition statement and all numerical
  budgets are unchanged, so the concurrently owned C542 formalization target is
  not strengthened.
- The open-boundary section lists every unclassified R8 and R9 field
  and quantifies the census scale.  At the upper missing endpoints a
  direct scan has `199623130728` and `33925283289801` projective
  directions; even division by the maximum `PGL_2` orbit size leaves
  at least `2898130` and `288480301` representatives.
- A stable-polar conjecture predicts a quadratic field threshold for
  disappearance of transverse exceptions.  It explicitly retains
  nonshallow Lucas-kernel components, since the known binary nucleus
  families make a persistent-only conjecture false.

The finite completions were not started inside C545.  They require
separate, resource-bounded tasks:

1. finish the separately owned C542 R8 Lean gate without manuscript or
   ledger overlap;
2. compute the covering radii of `PRS(q-6)` at `q=7,8,9`, with an
   independent replay;
3. build and benchmark a canonical-orbit R8 enumerator, starting at
   the smallest missing fields and stopping before any unmeasured
   large run; only then open the analogous R9 pilot;
4. independently reimplement the R5 bridge in a different CAS or
   finite-field stack.

The requested Proposition 7.9 budget arithmetic is already within the
paper's stated Lean boundary: the four-marker integer budgets are
formalized, while geometric integrality and point existence remain
printed inputs.  The aggregate trust task should audit that
correspondence rather than silently enlarge it.

The integrated manuscript remains the correct immutable preprint.
Whether Sections 8--9 become a companion journal paper remains a
post-audit venue decision; removing them during the DOI freeze would
erase the current theorem/provenance boundary.

The follow-up build passes `make check` and the supplement verifier.
The rendered example, named-lemma sequence, scope boundary, appendix,
and two-column bibliography were inspected.  The canonical PDF now
has 42 pages.

## Prior-version review reconciliation

The older eight-point revision plan now has the following status.

1. **Classification matrix — closed.**  Tables 2 and 3 separate
   mathematical dependencies from conclusions, evidence, radius
   gates, and scope boundaries.
2. **Frozen public certificate repository — external release gate.**
   The complete local bundle, locks, hashes, schemas, records, and
   one-command verifier exist; immutable publication identifiers do
   not yet exist and are not claimed.
3. **Completeness pressure points — closed editorially.**  The five
   named proof transitions were expanded, the R8 exhaustiveness table
   was added, and the longest R8 package is now four named lemmas.
4. **Detailed example — closed.**  Example 5.2 traces an explicit
   `q=29`, redundancy-six syndrome through the complete marked
   contraction and lift.
5. **Sections 8--9 decision — closed for the preprint.**  They remain
   in the integrated DOI record; a companion-paper split is a
   post-audit venue decision.
6. **Coding corollaries — closed.**  The article now leads with
   one-column MDS extensions and states exact projective counts and
   the fixed-redundancy recognition procedure.
7. **Reusable polar-induction theorem — closed.**  The theorem now lists its three
   reusable inputs, produces a rational marked flag and squarefree
   witness, states the split-free inclusion as a corollary, and
   isolates the two genuinely level-specific inputs.
8. **Independent specialist audits — open external gate.**  One
   finite-field/algebraic-geometric reader and one
   coding/computational reader are still required.

After the theorem recast, `make check` and the supplement verifier
still pass.  The rendered theorem was inspected on page 14.  The
canonical PDF has 42 pages, 302474 bytes, and SHA-256
`5a5ecc732ec223ffca78afaed77f63ab42d589196cc13d920ac20ff56491e37d`.

## Extra-juice consistency audit

The hostile metadata pass found one real reproducibility defect:
`supplement/RELEASE-MANIFEST.md` still named an older local PDF hash and
byte count even though the evidence verifier passed.  This happened
because the release manifest is deliberately outside the evidence
manifest's hash closure, avoiding a circular self-reference.

The defect is now closed in two ways:

- the release manifest records the current PDF, evidence-manifest,
  evidence-row, bundle-builder, and verifier hashes and byte counts;
- `supplement/verify.py` now compares those local release-manifest rows
  against the actual files, so a future manuscript rebuild produces a
  hard failure until the local release row is refreshed.

The same audit removed operative-document drift: the README now says
42 pages and recognizes C539--C542 as complete; the theorem map no
longer describes a fifteen-page announcement and records the
witness-producing induction output; the release checklist names only
C543--C544 as remaining formal gates; and the claim/proof ledger points
to the completed polar, R6/R7, and R8 terminals instead of calling them
planned.  Historical second-draft and adversarial-review reports remain
historical and were not rewritten.

The abstract was tightened to the checklist's compact range without
weakening the MDS-extension lead.  `make check` passes, the supplement
verifier now additionally prints
`verified release-manifest local artifact rows`, and the canonical PDF
has 42 pages.

### C542 integration

The completed redundancy-eight formal package is now integrated into
every paper-facing trust surface:

- Section 10 records the three-marker affine/infinity contractions,
  adjacent swaps, geometric-`S_3` slice interface, exact budgets
  `30` and `14`, integer-42/prime-power-43 threshold passage,
  conditional synthesis, persistent cardinality, orbit pairs, tangent
  cocycle, and bounded characteristic-seven statement.
- `theorem-map.md` separates C513's printed geometric theorem from
  C542's conditional formal boundary.
- `supplement/LEAN-STATEMENTS.md` lists the import and axiom-audit
  gates and reproduces the exact numerical and synthesis signatures.
- The claim/proof ledger records the R8 synthesis as L3 at its explicit
  hypothesis boundary, without claiming formalized integrality, group
  actions, coding identification, or covering radius.

The C542 audit reports only `propext`, `Classical.choice`, and
`Quot.sound`; its finite orbit-arithmetic terminals are axiom-free.
The exact integer cutoff is `42`, while `43` is the first prime-power
field order, and the characteristic-seven interface deliberately does
not promote rootlessness beyond the proved `q=7,49` boundary.

The full supplement replay was then run, not only the quick manifest
check.  R5, R6, R6 normal forms, R7, R8, R9, Hessian, Lucas, `e_7`,
and the compiled R9-49 comparison all passed.  After the final PDF
build and C542 reconciliation, the canonical PDF has 42 pages, 302857
bytes, and SHA-256
`cecd0b248c3a3a1b2264472f5f8818fb4c51fa4717b2d19cbcc0ccf78ddacc41`.

### Extra-juice mystery ledger

- **Could the quick verifier pass with a stale release claim?**  Yes;
  this was reproduced and is now mechanically prevented for every
  local artifact row printed in the release manifest.
- **Did the induction recast accidentally strengthen the geometric
  input?**  No.  The proof constructs exactly the marked witness
  already used contrapositively; the new statement exposes that output
  while retaining the lower package, $b,c$ bounds, and level-specific
  `CC(n,j)` as inputs.
- **Is the persistent-only high-field conjecture viable?**  No; the
  infinite binary nucleus families are counterexamples.  The printed
  stable-polar conjecture correctly retains nonshallow Lucas-kernel
  components.
- **What still cannot be closed locally?**  Immutable public
  repository/archive identifiers, the clean public replay, author
  confirmation, and the two independent specialist audits.

### Final C542 reconciliation

C542's post-integration closeout added two public terminals.  The first
computes affine three-marker contraction as
\[
a_{i+3}-(r+s+t)a_{i+2}+(rs+rt+st)a_{i+1}-rst\,a_i,
\]
so it factors through the monic marker cubic rather than only through
adjacent-swap invariance.  The second discharges the prime-power
premise directly from a finite-field structure.  Section 7 now prints
the marker-cubic factorization at the point where the ordered
geometric-\(S_3\) cover first appears; Section 10, the theorem map, and
the Lean statement inventory record both final terminals.

The extra-juice check found no new mathematical gap.  It did expose a
useful explanatory distinction: contraction is symmetric in the
markers, while the lower cover remains ordered because its monodromy
and deletion argument use labelled roots.  The new displayed formula
makes that distinction auditable without another diagram.  The
remaining mysteries and release gates are unchanged.  The rebuilt
canonical PDF has 42 pages, 303273 bytes, and SHA-256
`4362e132a6ce79955dd3325dca6c93317cab3818c58fe9ba1a092fd3e6a925a0`.

### Conceptual-framing cold review

A further cold review asked that the coherent polar flag stand beside
the complete R5 theorem as a principal contribution, that the
split-free/radius/deep-hole distinction become visually unavoidable,
and that the R5-to-R6 propagation and stable conjecture carry more of
the exposition.  The revision implements those points:

- the first paragraph now names the R5 classification and coherent
  polar flags as the two principal contributions;
- the introduction's advance glossary is removed, with notation moved
  to the Hankel dictionary and carrier terminology introduced only in
  the polar-induction section;
- a boxed implication and a five-row status table separate split-free
  geometry, covering-radius promotion, deep-hole/MDS conclusions, and
  the remaining gap at each redundancy;
- the marked-root loss is explained as forgetting the removed point of
  \(\PP^1\), whose reintroduction creates a double point when the lower
  divisor passes through it;
- Example~\ref{ex:q29-r6} now prints the entire contracted R5 cubic
  pencil, its selected split member, marker avoidance, and the
  squarefree lift back to R6; and
- the stable-polar conjecture now opens the scope section as the
  synthesis suggested by the fixed-level theorems, before the exact
  gap ledger.

The compact public verification map and the printed R5 representative
and sanity tables remain in the article.  Moving them would conflict
with the earlier referee requirement that the finite bridge be locally
identifiable and independently auditable; exhaustive filenames,
hashes, and machine records are already confined to the supplement.

The extra-juice pass found that the marked-root explanation and the
worked example are two forms of the same missing bridge: the former
states why naïve contraction fails, while the latter shows the datum
surviving through an actual R5 pencil.  No new theorem hypothesis or
scope claim was introduced.  The canonical PDF now has 43 pages,
305365 bytes, and SHA-256
`eff414eae618484fa195c0dfaa3163949ae8b67b6296c4be7048a081ab0994d6`.
