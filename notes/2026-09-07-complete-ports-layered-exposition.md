# Complete-ports layered exposition and motivation

Date: 2026-09-07. Lane: complete-ports.

The user requested improvement of layering, motivation and positioning, followed
by resumed cold-reader feedback. The existing GPT-6 Astra referee was resumed;
this was a source follow-up, not a fresh independent cold read. Its journal-style
exposition assessment is `2026-09-07-complete-ports-layered-astra-followup.md`.

## Revision

The first page now starts from a failed symbol with several recovery choices.
One binary model supplies the running example: target u and helpers u,u,v,u+v.
Its minimal family is {1},{2},{3,4}. Locality records only one, and keeping all
minimum-cardinality repairs still loses the repair needed after failures of
helpers 1 and 2. Under the stated per-request unit-load model, the three
minimal repairs support three concurrent requests, while the singleton-only
family supports at most two. Equal costs for supplying u and v also do not
make those functionals interchangeable in an outer equation.

The later callbacks develop different aspects of this same example:

- Three helper coefficient vectors have the same generator image, so their
  differences lie in the helper kernel: the reason for the nested quotient.
- Its dual distance is two. For the full outer code L^N, the exact equation
  threshold is 1+2=3, but every minimal support stays local at every radius.
  This illustrates the zero sector; the separate F2/F4 representation example
  remains responsible for nonzero-sector alignment.
- At helper radius two, weighted repair costs are min(p1,p2,p3+p4).
  The same family gives the availability event. Independent survival 1/2
  yields 13/16, while summing the three individual repair probabilities gives
  5/4. This separates physical availability events from recovery witnesses.

The introductory contextual discussion is shorter and subordinate to the two
transfer statements and composition law. It explicitly compares numerical
states including the zero-sector cost. The literature narrative is grouped by
local recovery/workloads, what passes through concatenation, and which future
questions require different interface information. Existing citations are
retained; this is an exposition improvement, not a new literature or novelty
audit.

The reading route now identifies the different mechanisms: zero/nonzero-label
split, independent block lifting, and deleting external coefficients. It asks
a first-pass reader to retain the relative-weight definitions and statements,
and permits deferral of the numerical context normal form and separator proof.
The elementary all-rank corollary, unchanged in statement and proof, was moved
before the optional contextual subsection. The optimizer explicitly marks its
generated-span reduction as an optional use of the bounded outer-test theorem;
its elementary recurrence remains independent of that refinement.

## Resumed referee feedback and disposition

Astra finds that the example gives a usable common route through quotient
costs, the difference between equation and operational transfer, and resource
choices. It confirms the example calculations and regards the exposition pass
as ready for rendered review, without requiring another substantial structural
rewrite. It finds the three-part literature organization more informative than
the earlier sequence of comparisons.

All actionable local points were addressed: explicit per-request capacity
charging, distinct proof mechanisms, moving the all-rank corollary out of the
safe-skip subsection, retaining the zero-sector data in the contextual state,
and reading definitions as well as statements on the abbreviated route.
The probability callback and its radius-two scope were also made explicit.
The separate nonzero-alignment and genuine support-overlap results remain;
the small running example does not purport to replace them.

## Validation boundary

The paper still has 32 registered statements and four unchanged Lean terminals.
No statement, proof, annotation, or terminal of the moved all-rank corollary
was changed. The numerical page pin tracks the revised typesetting; the
warning, annotation, source-inventory and deterministic-PDF checks are unchanged.
No Lean or benchmark execution was performed.

The prior 43-page baseline is authority `2f4f82de5`, PDF SHA-256
`ab3b881acc1fce532f9414d1c6e1ff84fb3f02f5eb06adee9e78a449513d3df9`.
The main theorem remains on page 2. Final build, rendering and mirror identities
are recorded below after the gate completes. This does not close C325/C953 or
constitute the independent primary/adjacent-reader comparison required before
submission.

## Closeout: ej + tt

The cheap gain was to use the same example for the probability boundary:
disjoint helper supports still have overlapping success events. No extra
example or theorem was required. The referee also exposed the accidental
placement of an elementary all-rank consequence within an optional technical
subsection; moving the unchanged result makes the reading route truthful.

Mystery ledger: no mathematical uncertainty remains in the running example.
Its limitations are explicit: rank-one target, a zero-sector confinement
example, and pairwise disjoint minimal supports. The separate alignment,
higher-rank, and overlap results retain their independent roles. Broader
novelty and aggregate submission readiness remain outside this exposition pass.

Final authority gate: PASS, 44 pages, warning-free, 32 claims and four unchanged
Lean terminals; fresh deterministic comparison passes. Final PDF SHA-256:
`b1e1de15e8e7a3874c0cf11a372423a7992f33af0a6ec2ca751750dd61ac7363`.
Rendered inspection covered the opening and reading routes, quotient callback,
confinement callback, relocated all-rank consequence, related-work groups, and
price/reliability callbacks (pages 1–4, 6, 12, 15, 22, 28–29). Before/after
PDFs are frozen in `~/.cache/complete-ports-layered/`.
