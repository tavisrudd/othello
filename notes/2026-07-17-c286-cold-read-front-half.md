# C286 cold read: complete repair ports, front half

**Date:** 2026-07-17
**Scope:** Context-light, paragraph-by-paragraph read of
`papers/complete-repair-ports/complete_repair_ports.tex`, lines 1--305 (front matter through the
opening display of the reliability section).  The only comparison document read was the C188 cold-read
example.  No manuscript source, proof ledger, handoff, prior review, or C285 material was consulted or
edited.

## Sequential read log

- **L1--36, preamble/title block — PASS.** The title is informative and the notation introduced here
  is light enough for the stated scope.
- **L37--42, abstract paragraph 1 — PASS.** The three layers and the bounded complete object are
  introduced economically.
- **L43--51, abstract paragraph 2 — MODERATE.** “Every fixed represented port above this obstruction”
  points in the wrong direction relative to Theorem 3.1, whose admissible range is
  `r+1<z_x(I)`.  A reader will naturally understand “above” as exceeding the obstruction.
- **L53--60, abstract paragraph 3 — PASS.** The two examples are contrasted clearly, with an
  appropriately concrete list of outcomes.
- **L62--70, introduction paragraph 1 — PASS.** The motivation cleanly identifies information lost by
  locality and disjoint availability.
- **L72--78, introduction paragraph 2 — PASS.** Matching, transversal, reliability, and coefficient
  data are related in a readable progression.
- **L80--88, roadmap — PASS.** The six-part structure is easy to follow.
- **L90--96, contribution/trust-boundary paragraph — PASS.** Classical inputs and negative claims are
  delimited unusually well.
- **L98--102, Section 2 setup — PASS.**
- **L103--114, Definition 2.1 (support layer) — PASS.** The complete family and its minimal clutter are
  distinguished explicitly.
- **L116--118, complete family versus clutter — PASS.** This prepares the later monotone invariants.
- **L120--129, Proposition 2.2 (basic invariants) — MODERATE.** The final sentence is automatic from
  the definition, because `w_x\neq0` and
  `supp(w)\setminus\{x\}=R` already imply `|R|=wt(w)-1`.  Worse, its hypothesis
  `r+1<d(C^\perp)` makes the repair hypergraph empty, so the sentence is vacuous.  The proof instead
  appears to be trying to prove uniqueness of normalized coefficients.
- **L131--137, proof of Proposition 2.2 — MODERATE.** The matching/transversal argument is sound, but
  the final sentence proves neither the proposition's stated tautology nor a correctly stated
  uniqueness claim.  For uniqueness, normalize two witnesses to the same target coefficient; their
  difference is supported on at most `r` helpers, so the useful hypothesis is `r<d(C^\perp)`.
- **L139--150, Definition 2.3 (coefficient layer) — BLOCKER.** The ratios
  `(-w_y/w_x)_{y\in R}` are already invariant under rescaling `w`; taking their projective class
  discards the common scalar that is essential to the displayed recovery equation.  A projective
  class does not determine `c_x=\sum_y(-w_y/w_x)c_y`.  The coefficient fiber must consist of ordinary
  normalized tuples, not projective tuples.
- **L152--161, Definition 2.4 (probability layer) — PASS.** The survival event and multivariate
  reliability are precise.
- **L163--166, preservation paragraph — MINOR.** The phrase “all three support-derived layers” is
  grammatically at odds with the five items that follow and with the earlier three-layer division,
  where the coefficient layer is not support-derived.  The mathematical distinction in the second
  sentence is nevertheless clear.
- **L168--185, Section 3 setup and `\Phi_I,\lambda,\mu_x` definitions — PASS.** The quotient weight and
  pointed constraint are introduced with adequate conventions.
- **L187--194, functional dual and weighted cost — PASS.** This is concise and self-contained.
- **L196--217, Theorem 3.1 (exact pointed confinement and transfer) — BLOCKER.** The claimed exact
  minimum does not include the cheapest nonembedded witness in the all-zero functional sector.  The
  zero functional tuple labels both embedded inner-dual witnesses and sums of inner-dual witnesses
  in multiple blocks; merely saying “with the embedded zero tuple removed” cannot distinguish those
  realizations.  If the zero tuple is retained, the displayed separable minimum chooses zero in every
  nontarget block and returns an embedded witness; if it is removed, it loses the nonembedded
  zero-sector witness altogether.  The later quantity `z_x(I)=\mu_x(0)+d(I^\perp)` is exactly the
  missing branch when there is at least one nontarget block; for a one-block outer code that branch
  is absent, another edge case the theorem does not state.  The sufficient conditions remain plausible because
  `\mu_x(0)\ge d(I^\perp)` and pointed costs dominate unpointed weighted costs.
- **L219--229, proof of Theorem 3.1 — BLOCKER.** The proof itself recognizes the missing branch (“a
  pointed inner-dual word ... and a nonzero inner-dual word elsewhere”), but only derives the coarse
  `2d(I^\perp)` bound.  It does not establish the theorem's asserted exact minimum as written.
- **L231--239, field-nine transfer example — MODERATE.** The paragraph is too compressed to make the
  advertised strict separation checkable on a cold read: “Singer-shifted” is not defined, and the
  functional distance five, weighted distance at least six, and exact threshold six are simply
  asserted.  A formal example/proposition, a short calculation, or a forward cross-reference to the
  exact inventory would give this important witness an evidentiary home.
- **L241--252, Section 4 setup and definition of `z_x(I)` — PASS in isolation.** This is the natural
  exact zero-sector cost, though it arrives one section after it is needed in Theorem 3.1.
- **L254--265, Theorem 4.1 (prescribed represented ports) — PASS.** The quantifiers, obstruction
  direction, and density statement are clear.  The theorem also confirms that “above this
  obstruction” in the abstract should be reversed.
- **L267--274, proof of Theorem 4.1 — PASS.** Trace duality eliminates nonzero sectors asymptotically,
  while the fixed zero sector gives both directions of the criterion.
- **L276--297, represented-port caveat and asymptotic regions — PASS.** The representability boundary,
  GV/TVZ hypotheses, parameter scaling, and concrete seed specialization are stated without
  overselling.
- **L299--305, Section 5 heading/setup and opening deletion display — PASS for the assigned range.**
  The display is syntactically incomplete only because the requested range ends mid-definition; no
  judgment is made about the continuation.

## Findings and exact editorial corrections

### BLOCKER

1. **Use normalized coefficient tuples, not projective classes (L139--150).** Replace
   “its coefficient fiber is the set of projective tuples” and the bracketed display by:

   > its coefficient fiber is the set of normalized tuples
   > \[
   > \left\{\left(-\frac{w_y}{w_x}\right)_{y\in R}:
   > w\in C^\perp,\ \operatorname{supp}(w)=R\cup\{x\}\right\}.
   > \]

   Then retain “Each tuple gives the exact recovery equation ...”.  This preserves precisely the
   scalar data the paper says the coefficient layer records.

2. **Put the zero-functional branch into the exact transfer theorem (L196--229).** Either assume
   `|J|\ge2`, move the definition of `z_x(I)` to immediately before Theorem 3.1, and replace the
   theorem's first minimum by

   \[
   \min\!\left\{
     z_x(I),
     \min_{\substack{(\beta_\ell)\in O^{\perp}_{\rm fun}\\
                     (\beta_\ell)\ne0}}
       \left(\mu_x(\beta_j)+\sum_{\ell\ne j}\lambda(\beta_\ell)\right)
   \right\}.
   \]

   or define the first branch to be infinity when `|J|=1`.  Here `O^{\perp}_{\rm fun}` may be replaced
   by the manuscript's preferred notation for the functional dual.  In the proof, treat the nonzero functional tuples by independent fiber
   minimization, and treat the all-zero tuple separately: a nonembedded pointed realization has
   exact minimum `\mu_x(0)+d(I^\perp)=z_x(I)`.  The confinement conclusion should compare `r+1`
   against this full minimum.  The existing `2d(I^\perp)` condition can remain as the convenient
   sufficient lower bound.

### MODERATE

1. **Reverse the abstract's obstruction wording (L43--46).** Replace
   “Every fixed represented port above this obstruction” with
   “Every fixed represented port whose radius lies below this obstruction”.

2. **Make Proposition 2.2 state the uniqueness its proof is aiming at (L120--137).** Replace its final
   sentence by:

   > Moreover, if `r<d(C^\perp)`, then every coefficient fiber of a repair set in
   > `\cH_x^{(\le r)}(C)` is a singleton.

   Replace the last proof sentence by:

   > Normalize two witnesses in the same fiber so that their target coefficients agree.  Their
   > difference is a dual word supported on at most the `r` helper coordinates, so `r<d(C^\perp)`
   > forces the witnesses, and hence their normalized coefficient tuples, to agree.

3. **Give the strict weighted-transfer example a checkable landing point (L231--239).** Promote the
   paragraph to an `example` or `proposition`, define “Singer-shifted” in one clause, and supply either
   the short weight calculation or a precise forward reference to the later exact inventory that
   proves the three numerical thresholds.

### MINOR

1. **Untangle the preservation sentence (L163--166).** Replace “all three support-derived layers” by
   “all support-derived invariants”, leaving the itemized prose and the separate coefficient-fiber
   caveat unchanged.

## Overall flow assessment

The front half has a strong conceptual arc: locality/availability motivate the complete port; its
support, scalar, and probability layers lead naturally to an exact transfer problem; and the
fixed zero-functional obstruction then drives the positive-density theorem.  Definitions are
usually economical, caveats are excellent, and the prescribed-realization section is especially
clean.  The chief problem is not global organization but a seam between Sections 2--4: the scalar
layer is defined with the wrong quotient, Proposition 2.2's statement and proof diverge, and the
zero-sector cost is introduced only after the “exact” theorem that needs it.

The highest-value edits are therefore: (1) retain normalized coefficient tuples; (2) move `z_x(I)`
before Theorem 3.1 and include it as an explicit branch of the exact minimum; (3) restate the basic
invariant as coefficient-fiber uniqueness under `r<d(C^\perp)`; and (4) reverse the abstract's
obstruction direction.  Once those are repaired, the front-half narrative should read as a coherent
and credible route from the complete pointed object to prescribed positive-density realization.

## Resolution verification

Targeted sequential re-read of the revised front half on 2026-07-17; the manuscript was not edited.

1. **PASS — obstruction wording (L43--46).** “Satisfying this obstruction bound” no longer reverses
   the admissible inequality later stated as `r+1<z_x(I)`.
2. **PASS — Proposition 2.2 and proof (L124--137).** The vacuous weight sentence and mismatched proof
   have been removed; the proposition now states and proves only the matching/transversal facts.
3. **PASS — normalized coefficient fibers (L139--150).** The fiber now contains ordinary normalized
   vectors `(-w_y/w_x)`, so it retains the scalar data needed by the recovery equation.
4. **PASS — exact zero-functional branch and the `|J|` edge (L196--246).** The definition of `z_x(I)`
   now precedes Theorem 3.1, the exact minimum explicitly includes that branch, and the theorem assumes
   `|J|\ge2`; the proof treats nonzero and zero functional sectors separately.
5. **PASS — support-derived wording (L163--166).** “All support-derived invariants” is consistent with
   both the ensuing list and the separate coefficient-fiber caveat.
6. **PASS — strict weighted-transfer example (L248--261).** “Singer-shifted” is defined and the finite
   numerical calculation is assigned a precise forward reference to the checked transfer chain.

**New/residual defect — MINOR (L146).** After removing projective classes, “Each representative gives
the exact recovery equation” retains quotient language.  Replace **representative** with **vector**.
No new mathematical, narrative, or trust-boundary defect was found in the targeted range.
