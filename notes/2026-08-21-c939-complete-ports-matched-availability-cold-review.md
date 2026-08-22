# C939 matched-availability cold review

Date: 2026-08-21

- Immutable commit: `f50c583cc8d23baacc03b71ade111ec243d91578`
- Tracked PDF: `papers/complete-repair-ports/complete_repair_ports.pdf`
- PDF SHA-256: `2cbb5bd84f65c00d93a4b9e19a711f452468da8d849c918b7f571e03e9203a49`
- Length: 23 pages
- Verdict: **MINOR**

## Exact issue

1. **Page 19, Section 8 (Conclusion), third paragraph: stale central-result
   summary.** The paragraph still says that the field-seven pair persists on
   density-`1/7` classes and calls that the paper's central synthesis. The
   Abstract, Theorem 1.1, and the new Theorem 6.5 instead promote the stronger
   common-field `[10,4,6]_q` construction with matched availability, transversal
   number, minimum-blocker count, and helper degree multiset, transferred to
   density-`1/10` classes. Replace the stale field-seven paragraph with a
   summary of Theorem 6.5 and its two displayed reliability laws. As written,
   the conclusion is internally out of sync with the paper's main theorem and
   leaves the new strengthening unmentioned. This is editorial/theorem-hierarchy
   drift, not a defect in Theorem 6.5.

## Checks passed

- For
  `A={158,026,045,013,478}` and `B={168,237,078,015,124}`, independent
  recomputation gives the common helper degree multiset
  `(1,1,1,1,2,2,2,2,3)`, matching number two, transversal number two, and the
  unique minimum transversals `{0,8}` and `{1,7}` respectively.
- The union-size rows in the page-14 table recompute exactly. Alternating them
  gives
  `5s^3-7s^5-s^6+5s^7-s^9` and
  `5s^3-7s^5-2s^6+8s^7-3s^8`.
- The quotient-plane arrangements realize exactly the five prescribed
  collinear triples: the forced line intersections give the named incidences,
  and the remaining rational choices can avoid the finite set of unwanted
  joining lines.
- In the lift `h_i=(t_i,p_i)`, each unwanted dependence is a proper linear
  condition on the lift parameters. Avoiding their finite union makes every
  helper triple and quadruple independent, while the target-containing
  dependent four-sets are exactly `{x} union A` for the five clutter edges.
- Rational realization followed by reduction modulo one prime avoiding the
  finitely many nonzero determinants preserves both configurations over the
  same finite prime field.
- The resulting rank-four sparse-paving matroids have five
  circuit-hyperplanes through `x` and none avoiding it. Hence Lemma 6.3 gives
  the same pointed rank-triple multiplicity enumerator.
- Maximum hyperplane-section size four gives row-code parameters `[10,4,6]_q`.
  Triple independence plus a target circuit gives dual distance four and
  `mu_x(0)=4`, so `z_x=4+4=8`.
- One common asymptotically good `F_(q^4)`-linear outer family gives both
  concatenations length `10N`, dimension `4K_N`, and distance lower bound
  `6D_N`. Since `3+1<8`, Theorem 4.1 transfers both radius-three ports to
  target classes of density exactly `1/10`.

No correctness defect was found in Theorem 6.5 or its supporting construction.
After correcting the stale Conclusion paragraph, the verdict becomes **GO**.
