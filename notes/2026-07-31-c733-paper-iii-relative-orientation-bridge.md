# C733 — Paper III relative marked orientation bridge

**Lane:** `clebsch`

**Status:** complete; final context-free referee `GO`

## Result

Paper III now states the strongest bridge proved by the available geometry.
The normalization of the incidence pullback is intrinsic, but its comparison
with the conference and degree-six harmonic signs is relative to a marked
bridge datum.  That datum contains the ordered golden-axis representatives,
representative-lattice orientation, five plane-triple labels, normalized
linear chart lift, and compatible Petersen two-subset labels.  The selected
component does not purport to reconstruct any of them.

The revised theorem attaches
\([C_{\mathfrak m},Z_{\mathfrak m}]_{\rm or}\) to the component selected by
the fixed plane and its negative to the deck-opposite component.  The golden
exchanger identifies this convention with the conjugate configuration only
at \([xyz]\).  The primitive pair-sum map transports the relative sign after
the five labels and lift normalization are fixed.  No varying marking is
propagated from the golden fibre.

The ambiguity ledger is complete:

- axis switching is quotiented and fixes the triangle cubic;
- axis relabelling transports the conference matrix and cubic variables;
- representative-lattice orientation reversal fixes every construction used;
- coordinated five-label relabelling preserves \(\sigma_3\) and is equivariant
  for the Petersen map, while one-sided relabelling changes the marked datum;
- chart scaling is not quotiented, and \(q_1=xyz\) fixes it;
- golden Galois conjugation negates the conference, triangle cubic, and chart
  lift after transport by the exchanger; and
- deck exchange negates the odd generator and the attached relative source.

## Stein-algebra repair

The first fresh referee accepted the marked-orientation disposition but found
that the earlier draft had promoted the quadratic function-field equation to
an equation of the unnormalized pullback without proving the global Stein
algebra.  The manuscript now supplies that proof.  The quadratic involution
splits

\[
 f_*\mathcal O_{\mathcal N}=\mathcal O\oplus\mathcal M.
\]

Normality makes the anti-invariant rank-one summand reflexive.  Projective
space is factorial, so \(\mathcal M\) is a line bundle; the sextic branch
divisor forces \(\mathcal M\simeq\mathcal O(-3)\).  The golden fibre fixes
the multiplication scalar to the square class of \(5\), and rescaling the
generator gives the exact algebra

\[
 \mathcal O\oplus\mathcal O(-3),\qquad z^2=5J_0.
\]

The factorization on the Clebsch chart and the meeting of its unnormalized
branches are therefore scheme-theoretic rather than function-field claims.
The unspecified integral localization remains unchanged.

## Trust and validation

The abstract, main theorem, proof, conclusion, README, artifact boundary,
trust manifest, and generated statement identity all use the relative marked
formulation.  The exact programs continue to audit only the displayed
marking; no computation claims marking independence or scheme normalization.

From `papers/clebsch-passages/`, the ordinary aggregate

```text
python3 verification/verify_release.py
```

passed every evidence bundle, statement/trust identity check, and the
warning-free fifteen-page PDF build.  The same aggregate passed in a fresh
paper-only temporary tree.  Pages 1, 2, 7, 9, and 14 were rendered and
inspected; the marked hypotheses, Stein-algebra proof, ambiguity ledger, and
conclusion are unclipped and legible.

A first context-free full-manuscript referee returned `REVISE` only on the
missing Stein-algebra bridge and explicitly accepted the marked-orientation
trust boundary.  After the proof above was added, a new context-free referee
returned `GO`: it accepted the global double-cover algebra, the chart
factorization before normalization, the complete marking ledger, and the
absence of any sheet-to-marking claim.

## Extra-juice and Tao closeout

The `ej` pass exposed the global Stein algebra as a free upgrade once the
function-field square class and sextic branch divisor were already known.
Adding it removed a hidden trust jump and made the branch-meeting statement
literal.  The `tt` pass tested whether any quotient of the visible ambiguity
group recovered an intrinsic sign.  It did not: the chart lift and the
cross-identification of the two five-labelled systems remain independent
inputs.  The relative theorem is therefore the maximal proved result, not a
temporary weakening.

No incidental observation met the discovery-track discriminator.

## Mystery ledger

| feature | disposition | evidence boundary |
|---|---|---|
| sheet-to-marking canonicality | settled negatively | the sheet selects a normalized component, not the chart lift or cross-labelling |
| switching and relabelling dependence | settled | complete ambiguity ledger in Section 3.4 |
| unnormalized branch intersection | settled | global trace-split Stein algebra and exact chart factorization |
| golden-fibre comparison away from \([xyz]\) | settled negatively | the exchanger calculation is fibre-local; the other-component source is a relative convention |
| exact geometric bad-prime set | open outside C733 | requires an integral incidence model with flatness, normality, and Stein comparison |
| remaining Paper III release work | owned by C680 | immutable artifact locator and author affiliation/contact metadata |

Vibe check: the bridge is now narrower but mathematically solid; the repair
also strengthened the scheme-theoretic spine beyond what the task initially
asked for.
