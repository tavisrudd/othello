# C973 checkpoint — paper-successor integration map

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** draft interface
for a separately allocated manuscript successor; no paper files edited

## Editorial outcome

If independent review accepts the simultaneous-marker theorem, the paper
should no longer present arbitrary redundancy as a conditional theorem plus
fixed R8--R10 discharges.  Its spine becomes:

1. exact reduced recursive carrier geometry;
2. one degree-six simultaneous-marker selector;
3. the exact R5 split-member count with all retained roots charged at once;
4. unconditional arbitrary-`r` split-free containment; and
5. a separate radius gate and Lucas-carrier arithmetic.

This is a unification, not an added chapter.  The old stagewise packages are
replaced by a shorter argument, while their fixed-level exceptional arithmetic
survives only where it gives genuinely stronger small-field information.

## 1. Replacement for the main theorem (`thm:main`, currently Theorem 1.1)

Proposed statement:

> **Theorem (simultaneous-marker obstruction and deep holes).**  Let
> `r>=6`, let `q` be a prime power, and put
> `Q*_r=6r-16+floor(2 sqrt(6r-18))`.  If `q>=Q*_r`, every split-free
> redundancy-`r` syndrome belongs to
> `P_r union M^max_(r,p)`, where
> `M^max_(r,p)=P<e_j: binom(r-2,j)=binom(r-2,j-1)=0 mod p>`.
> In characteristic two the same conclusion holds under
> `q>=6r-22+floor(2 sqrt(6r-24))`.
>
> If `p>r-1`, the modular term is empty; the covering radius is `r-1`, and
> the projective deep holes are exactly the persistent tangent and
> conjugate-secant families.  Their total cardinality is `q(q+1)^2/2`, with
> orbit law `T/T^(r-1)` modulo inversion and coefficient Frobenius and tangent
> cocycle `z -> z+(r-1)u`.
>
> At R6--R10 the general integer thresholds are `28,35,42,50,56`; the next
> prime powers are `29,37,43,53,59`, exactly the existing fixed-level entry
> fields.  The current exact small-field statements remain separate clauses.

Delete every phrase making this theorem conditional on one-step lower
packages.  Retain the split-free/radius distinction explicitly.

Suggested stable semantic label: `thm:simultaneous-marker-main`; keep
`thm:main` as an alias only if the annotation/export machinery supports an
intentional compatibility alias without duplicating a theorem.

## 2. Replacement for the polar escape theorem

The current `thm:induction` (the task card's current Theorem 5.14 target) is a
valid finite-depth abstraction but is no longer load-bearing.  Replace its
main-paper role by two results.

### Composite contraction

> For `R in Sym^m(E^vee)`, define
> `<iota_R f,g>=<f,Rg>`.  Then
> `g in W_(iota_R f)` iff `Rg in W_f`.  If `R` is completely split and
> squarefree, the lift is squarefree exactly when `g` is squarefree and avoids
> every root of `R`.

Suggested label: `thm:composite-contraction`.

### Simultaneous-marker escape

> Outside `P_r union M^max_(r,p)`, one characteristic-wise terminal-carrier
> equation pulls back to a nonzero selector of degree at most six in every
> ordered marker.  The Vandermonde grid lemma supplies distinct rational
> markers when `q>=r+1`.  The terminal R5 pencil has more than `r-5` split
> members under the displayed main threshold, so one avoids all markers and
> lifts directly.

Include the pointed version with `s` additional forbidden roots as a lemma,
not another theorem: marker selection needs `q>d+m-1+s`, and the terminal
count replaces `m` by `m+s`.

After the existence proof, add at most one corollary or remark: successive
specialization of the explicit nonzero selector finds the markers with at
most `(r-5)q` symbolic partial-substitution/zero tests, followed by `q+1`
terminal pencil tests.  State this only for fixed `r`, with explicit
coefficient access; dense selector size is exponential in `r`, so this is not
a uniform polynomial-time decoder theorem.  Software adoption belongs to the
classifier successor and is not a prerequisite for the paper.  The concrete
handoff is `c973-2026-08-26-software-leverage.md`: it separates a locator-
certificate fast negative path from the new registry and verifier required for
positive R11+ deep-hole verdicts.

Suggested labels: `thm:simultaneous-marker-escape` and
`lem:pointed-simultaneous-marker`.

The old finite-depth theorem can be deleted if no surviving fixed-level proof
cites it.  Otherwise move it to a short historical/general-purpose remark or
appendix proposition after the new theorem; it must not remain the route to
the headline.

## 3. Replacement for the recursive-carrier consequence

The current `thm:recursive-carrier` (the task card's current Theorem 6.4
target) should become an unconditional composition theorem:

> C820's reduced component converse makes the terminal selector nonzero off
> `P_r union M^max_(r,p)`.  The Vandermonde lemma and exact R5 count then give
> the main threshold and direct locator.  No lower-package hypothesis occurs.

The carrier theorem itself remains unchanged: it is fibrewise and reduced,
and it does not claim that every Lucas-carrier point is split-free.  The
sentence separating geometric containment from Lucas arithmetic becomes more
important, not less.

Immediately after it, insert the digit-stripping exact sequences from
`c973-2026-08-26-digit-stripping-exact-sequence.md`.  They identify the
filtered `GL_2`-module structure of every maximal Lucas carrier and Pascal
nucleus from the base-`p` digits of `r-2`.  Use the one-carry standard-module
theorem and the characteristic-seven R11--R13 closure as one worked
corollary; do not add separate R11, R12, and R13 subsections.

Suggested label: `cor:recursive-carrier-unconditional`, or merge this result
into the proof of the main theorem if a separate statement would merely
repeat it.

## 4. Deletion and retention map

### Delete or compress

- The main-text definition of a one-step lower package and the repeated prose
  explaining why it is assumed at every level.
- Stage-by-stage parameter selection in the general theorem.
- The general old-marker accumulation and the `3r-5` parameter-budget
  comparison as headline inputs.
- R8/R9 pointed-package proofs insofar as they exist only to discharge the
  former general hypothesis.
- The R10 five-stage transverse budget and repeated statement that every
  retained marker survives each stage.
- Overview, reading-map, provenance, and theorem-map rows describing the
  arbitrary-`r` result as conditional.

### Retain

- The exact R5 count, branch budgets `12/6`, and R5 prior-art attribution.
- C820's fibrewise reduced terminal decomposition, row-space converse, and
  maximal Lucas carrier.
- Composite contraction/base-change algebra and the infinity convention.
- Fixed R5--R7 complete classifications and their finite exceptional tables.
- R8/R9/R10 arithmetic that proves sharper small-field, modular, or finite-
  certificate statements independently of stagewise general escape.
- The complete first higher binary Lucas-carrier theorem and its final-pair
  trace criterion.
- Characteristic-seven R9/R10 slice arithmetic, now also reusable for the R11
  pointed lift.
- The digit-stripping carrier/nucleus exact sequences, the closed digit
  dimension formula, and the length-neutral one-carry corollary.
- The seven q=49 pointed locator certificates, in the supplement only, which
  close the five quadratic and two standard-module orbit representatives.
- The Seroussi--Roth--Dür radius gate as a visibly separate proposition.
- All trust, imported-literature, certificate, and formalization boundaries.

### Recast fixed levels

R6--R10 should be presented as:

1. numerical calibrations showing that the uniform theorem recovers their
   asymptotic thresholds exactly after rounding to prime powers;
2. exact small-field completions and orbit laws; and
3. Lucas-carrier arithmetic beyond what the general containment decides.

They should no longer look like five necessary rungs in the proof of the
arbitrary-level theorem.

## 5. Quantitative witness theorem

Add one corollary after simultaneous escape:

> For fixed `r` and `f` outside the carrier, the number of projective split
> squarefree members of `W_f` is at least
> `q^(r-4)/(r-2)! - O_r(q^(r-9/2))`, with the explicit finite lower bound from
> the selector-zero count and exact R5 member count.

This is a lower bound, not an asymptotic equality.  It should replace any
impression that the R5 Chebotarev count is isolated: R5 is the terminal count,
and the factorial is the marker/terminal-root partition multiplicity.  Mention
the classifier only as a potential sampling consequence; do not broaden the
software theorem registry until its own task adopts the new theorem.

Suggested label: `cor:split-witness-abundance`.

## 6. Frontmatter and map updates

The paper successor should update:

- **Abstract:** lead with unconditional arbitrary-redundancy containment and
  exact large-characteristic classification; mention the degree-six
  simultaneous selector, not stagewise packages.
- **Introduction:** replace “two logical layers” by carrier geometry plus
  simultaneous arithmetic escape; retain the independent radius layer.
- **Reading map:** use three rows: terminal R5 count, recursive carrier,
  simultaneous selector/direct lift.
- **Overview table:** mark arbitrary-`r` containment unconditional at `Q*_r`;
  keep all-characteristic exactness open on the maximal Lucas carrier.
- **Scope/open problems:** replace “prove every intermediate lower package” by
  “transport pointed abundance through the digit-stripping module
  extensions”; cite the R11/R12 characteristic-seven orbit closure only after
  independent review.
- **Theorem/claim map:** add composite contraction, selector, pointed selector,
  abundance, and revised main theorem; retire conditional-package dependency
  edges.
- **Formalization ledger:** do not claim kernel coverage for the geometric
  selector converse.  Existing contraction and arithmetic terminals may be
  reused only after exact statement comparison.
- **Evidence registry:** no computation supports the arbitrary-`r` escape or
  digit-stripping theorems.  Register the q=49 locator bundle only for the
  finite characteristic-seven pointed corollary; distinguish its structural
  orbit reduction from its seven computational existence witnesses.
- **Verification boundary:** add a fail-closed check that no headline theorem
  still contains the removed package hypothesis and that the strict threshold
  arithmetic is reconciled.

## 7. Page budget

Target the rewrite to remove more than it adds:

- add roughly 2--3 proof pages for composite contraction, the selector, the
  Vandermonde lemma, terminal subtraction, and abundance;
- delete or demote roughly 5--8 pages of general stagewise-package definitions,
  repeated marker budgets, and fixed-level discharge prose; and
- retain the genuinely arithmetic appendices and finite records unchanged.

Expected net change: **2--5 pages shorter**, with a stronger main theorem.
The successor must verify this against both canonical and TIT renders rather
than treating the estimate as a gate.

## 8. Successor gates

Before manuscript adoption:

1. independent geometry review of the C820 component converse as used by the
   degree-six selector;
2. independent arithmetic review of the Vandermonde lemma, R5 subtraction,
   and strict integer thresholds;
3. coding review of the improved threshold against the radius range;
4. focused review of the R11 characteristic-seven fixed-root resultant;
5. current literature delta before any novelty sentence;
6. statement-map, annotation, evidence, and formal-boundary reconciliation;
7. both manuscript builds, complete verifier, and clean standalone export;
8. cold specialist and generalist reads of the compressed architecture.

The seam reconstruction sharpens Gate 1: the external reader must check
C536's coherent-Fano identity, the projected-Veronese no-line property,
C597's wild-cone ruling calculation, the terminal cyclic/inseparable
classification, and the exact R5 count/branch budgets against their original
proofs.  The remaining selector, density, positive-gcd, and monodromy
reductions are now standalone in the C973 report.

The manuscript successor requires a newly reserved C ID.  C973 does not edit
the paper, mirror, release metadata, or software.
