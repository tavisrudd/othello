# C1116: cubic pair foundation audit

**Lane:** `cubic-threefolds`
**Date:** 2026-09-07
**Scope:** The interfaces identified in the Astra review, against the current
two authority manuscripts and the actual imported comparison statements.

## Finding

The audit found a coefficient-ring proof that needed repair and a formal
coverage qualification that needed to be explicit. Neither required changing
the headline theorem. The earlier cyclic-centralizer repair is sound under
the stated formal-connection hypotheses. The descended quotient construction
uses the same point for the slice and tangent-projection conditions and an
equivariant generic trivialization, as required.

The faithful-center proof now uses the reduced **graded** ring throughout.
The previous assertion about arbitrary invertible formal translations was
too broad; the source explicitly warns that the corresponding pullback on
the unrestricted formal ring is ill-defined. The proof also no longer
asserts injectivity after truncating the divisor exponentials.

This is a targeted mathematical/source audit, not an external specialist's
acceptance, a full formalization, or a probability-of-correctness estimate.
The source comparisons and local deductions below are the evidence. Existing
finite gates have their narrower scopes. No email was sent.

## Exact source interfaces and local providers

| Interface | Source and required hypotheses | Local provider / disposition |
|---|---|---|
| Graded coefficient ring | Iritani, arXiv:2307.13555v3, Section 2.2 and Remark 2.3: graded completion, combined Novikov/divisor variables, polynomial unit variable | The definition of the generic field now explicitly uses this reduced numerical domain. Odd parameters and odd fibre cohomology are both removed. |
| Raw center substitution | Iritani (5.15), Remark 5.6, and (5.40): ambient pushforward and exceptional exponent; independent divisor coordinates remain in the target | The unrestricted Novikov map can have a kernel. Its restriction to the reduced source is already injective; the proof no longer suggests recovering information after a genuinely noninjective source map. |
| Translated center substitution | Iritani discussion after (5.36), (5.47), and Section 5.8.2: reduced-ring pullback and independent translated coordinates | Well-definedness uses the imported reduced-ring construction. Injectivity is proved separately by the initial-Novikov-degree argument below. |
| Return to blowup coordinates | Iritani Theorem 5.18(7), Section 5.8.2 | The combined bulk coordinate map has an invertible formal Jacobian. This identifies the external direct sum with the original presentation after the stated scalar extension. |
| Regularity and grading | Iritani Theorem 5.18(3), (5.41)--(5.43); Iritani--Koto arXiv:2307.03696v4, Theorem 5.1(3)--(6), Remark 5.3 | Maps and inverses are regular in z in the graded Laurent rings. The displayed loop connections use the intrinsic Euler/grading terms. Absolute degree shifts are recorded separately; they are not permission for arbitrary z-meromorphic gauges. |
| Distinct summands | Both comparison theorems' combined bulk Jacobians | Independent unit parameters translate finite spectra independently. Their resultant is a nonzero polynomial, so distinct summands do not merge at the generic point. |
| Projective-bundle coefficient map | Iritani--Koto Theorem 5.1 and Remarks 1.2, 5.2 | The base curve variable is retained, unlike the potentially collapsing center pushforward. Twisting by a line bundle preserves the projective bundle and the intrinsic base embedding. The same reduced-ring interpretation applies to fixed shifts. |
| Orbit correction | Sharpness Theorem `thm:torus-quotient`: a basis of weight differences and all maximal minors nonzero | Cofactors determine one torus element over the splitting field. Uniqueness and descended incidence data give a ground-field rational retraction. |
| Rationality of that slice | The same theorem requires a point in the projection-isomorphism open | The retraction fixes that point, so its image component meets the open. Dimension n-r and tangent projection then identify it with the linear P^(n-r). |
| Common open and descent | Proposition `prop:tangent-section`: geometrically integral Cox model, relative birational projection, nonempty evaluation open, dense k-points | The two nonempty opens intersect in the integral product. The relative projection and rank conditions descend; density supplies p and then x over k. Individual split witnesses are not asserted to descend. |
| Equivariant generic trivialization | TZ Remark 2.2, Corollary 3.5, Lemma 2.1 | A stably permutation character lattice makes the torus a direct factor of a quasi-trivial torus. Hilbert 90 gives a generic section. Translation by it is equivariant, and both successive torus quotients therefore preserve the product description. |
| Tangent projection after TZ v2 | TZ Theorem 2.4; primary input Ciliberto--Russo Theorem 2.7(ii) and Corollary 4.5(iii) | The Cox model is projective, geometrically integral, and nondegenerate (no linear Cox relations); its one-apparent-double-point property and density are supplied by the cited Cox construction. Global smoothness is not required. |

## The repaired coefficient-ring argument

Choose an integral ample divisor on the ambient variety. Its restriction
is ample on the center, so there are finitely many numerical effective
classes at bounded degree. Consider the first nonzero Novikov degree of a
source element, without truncating divisor coordinates in the target.

At a fixed curve class its other bulk coefficient is polynomial: the graded
completion permits only finitely many homogeneous degrees in an element,
the unit degree is bounded, and every remaining even nondivisor coordinate
has strictly negative degree. This observation is specific to the reduced
source and would be false for an unrestricted ungraded bulk completion.

Only the Novikov-degree-zero part of the fixed shift contributes to the
initial degree. Translation of the polynomial nondivisor/unit coefficients
is injective over the target Laurent field. The divisor shift multiplies
each exponential by a nonzero scalar. Within a finite ambient-monomial
collision fibre, the distinct numerical classes have distinct vectors of
divisor pairings. Restrict to an integral one-parameter direction separating
them and differentiate through one less than the number of terms. The
Vandermonde determinant forces every polynomial coefficient to vanish.
This contradicts the choice of initial degree.

The zero-shift instance proves injection before the translated pullback,
resolving the apparent contradiction about factoring through an image.
There is no claim that a lost source class is resurrected later.

Second-pass checks of the repair: unit dependence must remain polynomial;
homogeneous completion must be specified; divisor exponentials must remain
untruncated; coefficient translations must have nonnegative Novikov order.
These are now explicit or supplied by the exact source construction. The
argument does not use a bound on the center's dimension. It therefore
supports the all-dimensional reading needed for C1117, not just the
surface-center specialization needed by the main lower bound.

## Cyclic persistence and formal coverage

Continue a separated rank-two cluster before assuming that its eigenvalues
coincide. Over the complete bulk ring, a vector v with v,Nv a basis at the
closed point remains a cyclic vector. A commuting matrix is therefore
aI+bN before nilpotence is known. Trace-centering gives C=qN with q regular.
The flatness equation gives a homogeneous linear formal differential system
for N squared, with zero initial value. Characteristic-zero coefficient
recursion forces N squared to vanish. An entry nonzero at the closed point
is a unit, so the rank-one line persists.

The remaining modified-base pole is kE21/z. The diagonal entries of its
flatness equation are plus/minus nu*k with nu a unit, hence k=0; the
constant equation is the residue Lax equation. This reasoning does not use
nilpotence to prove its own persistence. The text now says complementary
spectral clusters rather than the cubic-specific other two eigenvalues.

The `prop:rank2-rigidity` claim-map caution now explicitly excludes this
preliminary continuation/cyclicity/recursion argument from its Lean
terminals. Those terminals assume an adapted square-zero frame and prove
the subsequent regularity and discriminant constancy. The faithful-center
row remains **fragment**: its initial-form hypotheses are inputs to Lean,
not a formal construction of Iritani's geometric rings. No Lean theorem or
axiom audit was changed, and no Lean build is represented as having occurred.

## Consequences for upgrades and for TZ v2

The all-dimensional coefficient argument removes the specific source-map
objection to C1117. Bittner's additive extension and the associated
factorization deductions can now be developed against these clarified
foundations. The exact spectrum-valued extension still needs its own
explicit canonical-lattice transport statement: equality of exponent
classes alone would not preserve a squared gap under separate integer
shifts. Regular lattice isomorphisms and common scalar shifts are the
appropriate stronger inputs. C1119 still owns its finite-index component
and degree arguments; the unimodular proof does not prove them automatically.

Both bibliography entries now cite TZ v2. Sharpness's cubic references are
updated from Propositions 5.1/5.2 to 5.1/5.3, and the newly explicit
projection hypotheses are matched in the manuscript and source registry.
The uniform quotient construction and its finite witnesses do not change.
The existing witness-cover containment is sufficient and remains intact.

The prior full source comparison and bounded primary-source check are in
`2026-09-07-tz-v1-v2-comparison.md` and
`2026-09-07-c1116-tz-friendly-feedback.md`. Their evidence does not show
that v2 incorporated our level-two result or quotient construction. The
friendly email remains held until the planned paper updates are complete;
it will offer thanks and observations, without requesting feedback.

## Validation and release

Both authority `make check` gates passed after the final source edits.
The m1 gate includes its source-only formal artifact/annotation check,
LaTeX build and warning gate. The sharpness gate replays the retained
slice-cover derivation, its separate checker, metadata, and the LaTeX gate.
No finite witness or verification implementation changed. `git diff --check`
passed. The revised coefficient proof's PDF page was visually checked;
the sharpness bibliography's final page was checked by text extraction.

The two simultaneous wrappers chose the same timestamp/command log directory;
their successful exit results were returned separately, but that directory
is not a reliable archive of both runs. Downstream replays use distinct
command names and retain separate logs. Synchronization is pending at this
authority checkpoint.

| Authority PDF | SHA-256 |
|---|---|
| m1 | `fcefda002538db8ed1edb72c119c66701a55e50dcd1ec54bf00751fe5b2403ae` |
| sharpness | `d3166fedba26d16e8d5b584097a466cd358b8e974a823c41c8856aa598b73db5` |

## Mystery ledger — ej + tt closeout

- **Settled:** how an injective center map could factor through a
  noninjective map. The unrestricted map and its reduced-source restriction
  are different maps; the latter already retains the distinguishing divisor
  variables.
- **Settled:** why a fixed bulk translation is legitimate here. The source
  provides well-defined reduced pullbacks; the injectivity proof uses only
  polynomial translations at initial Novikov degree, not an unrestricted
  power-series automorphism.
- **Settled:** whether the common slice point can be chosen over k. A
  descended nonempty relative open and density give the point; displayed
  geometric witnesses need not descend.
- **Open, C1117:** exact spectrum transport must be stated at the canonical
  lattice level before the refinement is promoted.
- **Open, C1119:** finite-index slices require a descended integral component
  and a degree/divisibility proof. Nothing in this audit substitutes for them.
- No incidental discovery-track entry arose: these were the questions
  explicitly assigned to the audit. Independent specialist scrutiny remains
  valuable, but is not claimed by this report.
