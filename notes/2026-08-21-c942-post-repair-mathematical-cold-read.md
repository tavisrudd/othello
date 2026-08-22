# C942 post-repair mathematical cold read

**Target:** commit `7e85d942c`  
**Surface:** `papers/cubic-stabilization-m1/REVIEWER_GUIDE.md` and its prominent
link from `README.md`  
**Review mode:** fresh mathematical cold read.  No earlier C942 review or report
was consulted.

## Verdict

**Unconditional accept.**  Confidence: **0.97**.

The guide is a faithful, compact referee route through the unconditional
`m=1` proof.  It neither promotes partial formal coverage into a proof nor
imports hypotheses from the conditional all-stabilization companion.  I found
no fatal, major, or minor defect.

## Findings

- **Fatal:** none.
- **Major:** none.
- **Minor:** none.
- **Exact remaining findings:** none.

## Mathematical cold read

The six numbered steps reproduce the manuscript's causal chain accurately:

1. `prop:generic-spectral-connection-splitting` turns separated generalized
   Euler eigenspaces into formal connection blocks, and `thm:marker-ledger`
   converts an additive, occurrence-indexed center-null marker into a
   birational invariant by weak factorization.
2. `lem:faithful-center-base-change` supplies the missing faithfulness of the
   center coefficient map by divisor characters, and
   `prop:qdm-operation-ledgers` supplies the projective-bundle and blowup
   formulas after the manuscript's explicit coefficient, parity, regularity,
   grading, and occurrence checks.
3. `lem:A0preserve` removes the only new pole produced by the elementary
   modification; `prop:rank2-rigidity` makes the modified residue conjugacy
   invariant; and `prop:residue-discriminant-exponents` identifies its residue
   eigenvalues modulo integers with formal exponent classes.
4. `prop:cubic-block-data` obtains the cubic zero block from Beauville's three
   quantum products.  The residue polynomial is
   `(T+1/6)(T+5/6)`, so the exponent-class separation is `2/3` and the cubic
   contributes exactly one.
5. `prop:atomic-lowdim` kills points, curves, and all smooth projective
   surfaces, with the surface classification split exactly as the guide says:
   nef canonical class, projective plane, ruled surfaces, and point blowups.
6. The projective-bundle formula gives value two on
   `X x P^1`; generic semisimplicity gives value zero on `P^4`; center nullity
   and the occurrence-indexed ledger then yield the contradiction proving
   `thm:every-cubic`.

The guide's warning that a nonzero residue discriminant is insufficient is
mathematically important and correct: unequal residue eigenvalues can still
differ by an integer and hence define the same exponent class.  The actual
fold tests inequality in the quotient by `Z`.

## Strongest passage and first friction

**Strongest passage:** Step 3, “The marker.”  It gives the shortest honest
account of where regularity is won, why conjugacy is the correct invariance,
and why the tempting discriminant-only substitute fails.  That paragraph
transfers the proof mechanism rather than merely listing dependencies.

**First friction:** Step 2 is necessarily the first place where a cold reader
must slow down.  “Common coefficient fields” compresses the manuscript's
common image rings, fixed algebraically closed generic overfield, divisor
characters, and independent unit-coordinate separation into one prompt.  The
prompt is accurate and points to the right proposition; the ensuing manuscript
paragraphs resolve the issue.  This is intrinsic mathematical density, not a
defect in the guide.

## Label and dependency audit

Every semantic label named by the guide exists in the cited primary section
and has the stated role:

- ledger: `prop:generic-spectral-connection-splitting`,
  `thm:marker-ledger`;
- operation providers: `lem:faithful-center-base-change`,
  `prop:qdm-operation-ledgers`;
- marker: `lem:A0preserve`, `prop:rank2-rigidity`,
  `prop:residue-discriminant-exponents`;
- cubic and centers: `prop:cubic-block-data`, `prop:atomic-lowdim`;
- endpoint: `thm:every-cubic`.

The dependency order is honest.  In particular, the ledger theorem is stated
abstractly before its QDM operation providers, while the final use is licensed
only after those providers and center nullity have been established.  The
guide does not imply that the Lean companion supplies any geometric provider.

The primary-paper registry contains exactly fifteen claims: five
`fragment`, nine `conditional_deduction`, and one `absent`; the absent label is
exactly `lem:faithful-center-base-change`.  There is no `complete` primary
claim.  This matches the guide word for word.  The final terminology is also
accurate: it is this repository's Lean 4 companion built against Mathlib, not
part of Mathlib.  The six cited external input families have source pinpoints
and recorded convention matches in `verification/imported-sources.json`.

## Formatting and navigation usability

The README places the reviewer-guide link immediately below the PDF link and
separates the primary theorem from both companion papers.  The guide is short
enough to scan, gives one first-pass reading route, uses six parallel semantic
steps, and ends with an explicit proof/evidence boundary.  All linked targets
exist at the reviewed commit.  The semantic labels are exact and searchable;
the optional applications section is safely identified as skippable.  The
formatting and navigation are referee-usable without qualification.

## Trust-boundary verdict

The headline theorem is presented as mathematically unconditional for the
right reason: its remaining inputs are cited theorems and written geometric
arguments, not conjectural reconstruction hypotheses.  The guide correctly
states that the headline uses no computational evidence bundle.  It also
states, without euphemism, what the Lean companion does not formalize and that
`make check` does not build Lean or replay an axiom audit.  The correction in
`7e85d942c` removes the only plausible terminology ambiguity about Mathlib.

## EJ + TT closeout and mystery ledger

The closeout pass tested the two places most likely to conceal an overclaim:
whether the exponent marker had been weakened to a discriminant test, and
whether the partial Lean interface had been described as complete or as part
of Mathlib.  Both are stated correctly.  It also checked the less visible
dependency from actual center occurrences through faithful base change into
low-dimensional nullity; the guide preserves that dependency.

**Mystery ledger:** no genuine mystery remains.  There is no unresolved
evidence gap, unowned qualification, or hidden conditional dependency in the
reviewed guide.
