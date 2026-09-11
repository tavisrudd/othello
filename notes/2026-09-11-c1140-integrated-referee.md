# C1140 — independent integrated-manuscript referee report

**External works read in full in this review: 0.** The complete present
manuscript, including its generated mathematical tables, was read. External
reading was confined to the source passages recorded below. In particular,
neither companion obstruction theorem received an independent proof audit.

**Lane:** cubic-threefolds. **Date:** 2026-09-11.

**Manuscript:** *Two-Variable Rationalization and Sharp Stabilization of Cubic
Threefolds*, September 2026, authority
`papers/cubic-stabilization-irrationality/cubic_stabilization_irrationality.tex`.
The initial source hash was
`f50ed4ee9250171bc22e6ff2b44af8dcee4b1a83eb9284f5ddc125a96cae68e0`.
The corrected source inspected at closeout has SHA-256
`bad5493e24c2e117f1195341162d06c85723f59622fc2939f792829a23de3af1`.

This is a fresh journal-style mathematical read. No previous referee report,
packet draft, or task audit was opened. Required repository routing material
was read; its assertions of earlier acceptance were not used as evidence.
The parent supplied the locations of original SGA pages, which were then
read directly. No manuscript edits, builds, Lean commands, commits, or pushes
were performed by this referee. Rendered-page inspection and computational
replay belong to the parent task and are not claimed here.

## Summary and contribution

The paper proves a two-variable rationalization theorem for smooth quartic
del Pezzo surfaces with a rational point and stably permutation geometric
Picard module. Its main construction takes a saturated rank-three subtorus
of the projective Cox model. Four selected weight spaces have unimodular
weight differences; a suitable tangent linear section meets a general orbit
in exactly one point. Birational tangent projection makes this section
rational. An equivariant trivialization of the universal torsor identifies
the same quotient with the surface times a two-dimensional torus.

The paper applies this construction to a three-parameter family of smooth
cubic threefolds. A calculation on a generic quartic del Pezzo surface places
the actual signed Picard action inside the known type I3 group without
assuming that the specialized coefficients retain generic monodromy.
Combined with the companion one-stabilization irrationality theorem, this
gives exact stabilization level two after every extension of the
characteristic-zero ground field.

An explicit rational pencil provides the second principal contribution. Its
intermediate Jacobian is geometrically isogenous to a product of five
elliptic curves. Their potential reduction types give a local toric-rank
formula with values zero, one, and three. This separates all distinct
positive squarefree integral parameters prime to six. The companion Hodge
conservation theorem then gives pairwise nonbirational irrational first
stabilizations, each rational after one further projective-line factor.

## Significance and scope

The surface bound is a substantial strengthening of the cited general
eleven-variable bound. Its reusable quotient criterion and explicit
saturation argument explain why the stronger bound is possible; the paper
does more than improve a numerical constant by opaque calculation.

The arithmetic result gives an intelligible distinction between the first
and second stabilizations on an explicitly described positive-density set.
The use of potential toric rank is especially effective: it avoids any need
to classify isogenies among the five individual elliptic factors.

The hierarchy is appropriately limited. The upper bounds and arithmetic
Jacobian separation are independent of the companion obstruction proofs.
Exact cubic level and the nonbirationality of the fourfolds respectively
import one-step irrationality and rational Hodge conservation. The results
do not establish cancellation throughout cubic moduli, a product principal
polarization, a general algorithm for birationality, or an implemented
S-unit solver. The finite-index and rank-four appendices state conclusions
at the level of the particular quotient criterion. These limitations agree
with the proofs.

This review does not certify priority. I checked the identified load-bearing
interfaces, not the absence of other related work.

## Correctness

I found no demonstrated fatal or major error in the mathematical arguments
of the present paper. One explicit coordinate substitution error was found,
reported immediately, and corrected during the review; see the minor comment
below. The following were the principal stress tests.

1. **Quotient and descent.** The cofactor ratios solve the orbit incidence
   equations uniquely because the weight differences form an integral basis.
   Uniqueness, together with descent of the selected sum, boundary sum and
   section, makes the corrected point Galois equivariant even when individual
   weight spaces are not defined over the ground field. The hypothesis that
   the section meets the tangent-projection isomorphism open is essential
   and is actually supplied. The proof does not assume that an arbitrary
   component of a linear section is rational.

2. **Existence of a descended section.** The evaluation map is constructed
   over the splitting field, with invariant rank and freeness conditions.
   The ground-field step uses the scalar evaluation functional
   `lambda -> lambda(x)` on the descended four-dimensional space. It does
   not identify the four split coordinate functionals individually with
   ground-field coordinates. The relative tangent-projection construction
   provides one open in the space of pairs, so intersecting it with the
   evaluation open is legitimate. Zariski density supplies the two rational
   points in succession. Nonempty geometric witness opens are used only to
   prove nonemptiness, not asserted to contain the printed witnesses over k.

3. **Surface rationalization.** Stable permutation of the torus character
   lattice implies its first cohomology vanishes over every extension by
   adding quasi-trivial tori. The resulting generic torsor section gives a
   T-equivariant birational trivialization. Taking first the scalar quotient
   and then the rank-three quotient is therefore justified. The remaining
   rank-two torus is an actual quotient torus, and its rationality is the
   stated classical input. The nonminimal reduction contracts disjoint
   exceptional curves and reaches degree at least five with a rational point.

4. **Geometry-to-Picard interface in the new family.** The determinant
   pencil has five distinct roots: the odd valuations of `(a^2+3)^3` at
   its simple zeros exclude its being `16 beta^2`, also after extension of
   constants. The direction calculation at P excludes all geometric
   exceptional lines through P, not just F-rational ones. Thus blowing up P
   gives the smooth cubic surface needed for the conic-bundle/ruling
   dictionary in TZ Section 4. The three cyclic root differences and the
   product relation for the other two component square roots impose exactly
   the displayed signed-action containment. This agrees with the action at
   the end of TZ Proposition 5.3. Restriction of a stably permutation lattice
   to a subgroup preserves the required property. There is no hidden
   assumption that the cubic root polynomial is irreducible.

5. **Field quantifiers and moduli dimension.** Upper rationality is proved
   over the base function field and descends to a purely transcendental
   extension over k; it is not inferred from rational special fibres. The
   lower bound uses a finitely generated coefficient field containing the
   variety and both inverse rational maps. Such a field embeds in C even
   when the original field does not. Smoothness persists under the faithful
   field extension. The rank increase from 25 to 28 at a smooth seed has
   the stated moduli interpretation: the infinitesimal projective orbit
   removes the same directions as the affine GL5 orbit, including scalar
   multiplication of the cubic form. The precise rank values remain
   computer-assisted inputs, not independently replayed in this read.

6. **Prym-to-arithmetic interface.** The discriminant is a smooth cubic
   plus a transverse conic for the rational parameters under consideration,
   so CMZ Theorem 2.9 applies. The component cover of the cubic is the
   transposition quotient construction from the S3 Galois closure. The
   sign and standard isotypic parts each have abelian dimension two, giving
   `J(W) ~ J(C_t) x E_t^2`; quotienting by the pulled-back elliptic curve
   leaves the claimed three-dimensional factor. The two genus-two quotient
   pairs have independent differential pullbacks and account for all four
   remaining elliptic factors. These are isogenies of unpolarized abelian
   varieties; the text does not silently cancel principal polarizations.
   The arithmetic twists are explicitly separated from geometric isogeny.

7. **Reduction and separation.** SGA IX.2.2.6/2.2.7 gives isogeny
   invariance of toric rank; IX.3.3 preserves the identity components after
   semistability under the field extensions used here. It has no tame
   restriction. The warning following that corollary concerns the whole
   Neron model, not the invariant used in this paper. If `v_p(c)<0`, the
   two roots of `Z^2-4cZ+6912c` have valuations `v_p(c)` and zero for
   p at least five. Together with E2 this accounts for the coefficient two
   in the rank formula. Primes of the numerator and discriminant yield
   ranks one and three respectively; denominator primes yield zero. A
   complex isogeny descends to a finite number field, so these local
   invariants genuinely obstruct geometric isogeny. The positive squarefree
   restriction guarantees a prime dividing exactly one of two parameters.
   The density calculation includes the coprimality-to-six restriction and
   has the stated `3/pi^2` constant.

8. **Additional conclusions.** In the rational-pencil finiteness argument,
   both S-unit factors are units outside the finite set of potentially bad
   primes, including the denominator-prime case. The conjugate-pair group
   has rank `1+|S_L|`; Beukers--Schlickewei gives the displayed coarse bound.
   The exclusion `x != y` makes the inverse parameter formula defined.
   The additional rank-one actions have the nonbirational fourfolds as
   invariant fields, and one added invariant variable rationalizes that
   field with one remaining primitive torus coordinate. The finite-index
   theorem separately proves dominance of the rational component and
   obtains divisibility of its degree from a constant finite torsor after
   algebraic closure. The zero-cycle argument uses moving, pullback and
   pushforward over arbitrary extension fields. None of these deductions
   requires unjustified birational cancellation.

## Exposition and organization

The introduction successfully separates the surface theorem, exact cubic
level, and arithmetic separation. The two descriptions of `Z/T3` provide a
good conceptual summary. The explanation of the nonsaturated lattice is
particularly useful: it tells a reader exactly why a spurious degree two
would arise. The relative evaluation construction is longer than a routine
linear-algebra lemma should be, but its length is justified by the genuine
descent and simultaneous-openness issues it resolves.

The arithmetic section has a clear stopping point: the reader needs the
five elliptic invariants and the local rank formula, not a classification
of their pairwise isogenies. Placing the S-unit finiteness and rational-action
consequences in appendices preserves this emphasis. The verification section
correctly distinguishes geometric proofs, cited inputs, exact symbolic
execution, and absent formalization. I would retain that distinction.

## Major comments

There is no outstanding major correction to the present manuscript at the
reviewed dependency boundary. The editorial qualification is substantial
but external: the companion one-stabilization and Hodge-conservation
theorems are major research results, and the claims using them require their
separate mathematical assessment. This review verifies that their stated
hypotheses and conclusions match the present applications; it does not
independently validate their proofs. A successful computation in this paper
cannot discharge that obligation.

The symbolic moduli rank and all-parameter witness cover likewise retain
their disclosed computational trust boundaries. I read their mathematical
use and the printed certificate description, but did not rerun or
independently reimplement the calculations. No claim of complete external
source verification should be inferred from this report.

## Minor comments and repair disposition

1. **Required and repaired:** immediately before `eq:pencil-elliptic`, the
   original substitution `[-12ty:36tx:z]` produces
   `Y^2 Z = X^3 - 27 X^2 Z + 1728 t^2 Z^3`, rather than the printed
   short Weierstrass model. The corrected substitution
   `[-12ty-9z:36tx:z]` produces exactly the displayed model. I checked the
   corrected line. The discriminant and subsequent j-invariants are
   unchanged.

2. **Optional clarification:** in the first theorem, “the smooth members
   have a three-dimensional image in complex cubic moduli” refers to the
   parameter family after base change to C, rather than to the set of
   k-valued parameter points for an arbitrary k. Writing “the complex
   parameter family has moduli image of dimension three” would remove that
   slight quantifier ambiguity. The proof already establishes this meaning;
   no mathematical change is needed.

## Editorial recommendation

I recommend acceptance of the present manuscript at its explicitly stated
dependency boundary. The one required local formula correction has been
made, and I found no remaining demonstrated major defect. The construction
and arithmetic application are coherent, substantial, and sufficiently
explained for specialist review. Acceptance of the headline exact-level and
fourfold-separation claims still requires the editor to accept the two
companion theorems through their own review process; this report must not
be represented as that independent review.

## Source access and actual reading depth

All accesses below were on 2026-09-11. “Partial” means precisely the named
passages, not a full-text proof audit. Cached hashes were recomputed for TZ,
CMZ, EGFS and SGA. The full-read count remains zero.

| Work | Version/access and actual reading depth | SHA-256 when cached |
|---|---|---|
| Tschinkel--Zhang, *Universal torsors over quartic del Pezzo surfaces and stable rationality* | arXiv:2608.20029v2, cached 25-page PDF/text, partial: Lemma 2.1, Remark 2.2, Theorem 2.4 and its proof; Lemma 3.2, Theorem 3.4, Corollary 3.5; Section 4 ruling dictionary, Proposition 4.1, Lemma 4.2 and Corollary 4.3; selected Proposition 5.1/5.3 passages including the final signed I3 action. Source: https://arxiv.org/pdf/2608.20029v2 | `4856b5b45325b56917df9c6d8c4a9341f13d7b9bf2628562c9fda0784ca07453` |
| Casalaina-Martin--Marquand--Zhang, *The moduli space of cubic threefolds with a non-Eckardt type involution via intermediate Jacobians* | arXiv:2210.14397v2, cached 27-page PDF/text; partial: end of Proposition 2.8, Theorem 2.9 and proof, immediately following cover description. Web abstract also opened. Source: https://arxiv.org/pdf/2210.14397v2 | `6a8ce41af47def059a90f987f65cdda22c9540357d23ba80bdccc2dc8b351874` |
| Engel--de Gaay Fortman--Schreieder, *Matroids and the integral Hodge conjecture for abelian varieties* | arXiv:2507.15704v3, cache key unversioned but PDF header explicitly v3, 27 March 2026; partial: opening pages through Theorem 1.3, Corollary 1.4 and surrounding scope. No proof audit. Source: https://arxiv.org/pdf/2507.15704v3 | `f0284c8249c07ab5e3d9e5e49504662fad26de205563ab5a48aea27e742741ee` |
| Rudd, *One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds* | September 2026 local authority: complete `sections/01-introduction.tex`, especially `thm:every-cubic` and `thm:hodge-conservation`; theorem-statement/interface check only, no independent companion proof audit. | Introduction source: `9e200b5f425159d34ebf74ed053147c7dc7715995161aebd8de8591a321bd3c2` |
| Grothendieck, SGA 7 I, Expose IX | 1972 original French scan, partial original-page image reading: one-based PDF pages 338--339 (printed 333--334), 352--354 (347--349), 356 (351); IX.2.2.6/2.2.7, IX.3.2/3.3, warning 3.3.2, semistable-reduction existence IX.3.6. Source: https://library.slmath.org/nonmsri/sga/sga/pdf/sga7-1.pdf . Web PDF retrieval failed for size; local cached scan/page images supplied access. | PDF: `17286b0f0bec451068e0a5fa2c39e93de28e7c1ecee6739487cfac11c03c8dab` |
| Snowden, *Lecture 8: Elliptic curves over DVRs* | 2013 course-note webpage; partial: reduction definitions, behavior under finite extensions, semistable reduction and integral-j criterion, through the first torsion discussion. https://websites.umich.edu/~asnowden/teaching/2013/679/L08.html | No cache/hash claimed. |
| Beukers--Schlickewei, *The equation x+y=1 in finitely generated groups* | Author PDF dated 8 January 2007; partial: first-page definitions and Theorem 1.1, exact bound `2^(8r+8)`. https://webspace.science.uu.nl/~beuke106/s-units.pdf | Web PDF; no local cache/hash claimed. |

The remaining named bibliography entries have reading depth **secondary
only, via the fully read manuscript** and were **not opened as external
works** in this review: Auel--Colliot-Thelene--Parimala (arXiv:1310.6705,
author version); Beauville--Colliot-Thelene--Sansuc--Swinnerton-Dyer (1985);
Ciliberto--Mella--Russo (2004); Colliot-Thelene--Coray (1979); Manin (1966);
Roulleau (arXiv:1001.4855v2); van Geemen--Yamauchi (arXiv:1506.05346v3);
Shepherd-Barron (2004); Kuznetsov (arXiv:math/0303037v1/published 2004);
Varilly-Alvarado (2013); Voskresenskii (1967); Popov
(arXiv:1110.2410v4); Chatzistamatiou--Levine (arXiv:1605.01913v3).
Their manuscript citations and uses were read. Classical facts were treated
as imported facts; the report does not claim source-level re-verification
of this unread list. No cache/hash or exact-version access is claimed for it.

SGA original-page image hashes, in PDF-page order:

```text
338 134adb522e9ee4e5767d4c4430b4442ad57ee6cf94ae5421a9a78a99cad9f03a
339 5a6a79e5319eecf3773f5aaca850cfc7c6b754aac9b74e09fa83ed668d7e7288
352 20360b1452da55ef9a61e8f86e91d7450a3d3a5d10a03a391073b0da17611c54
353 ce72d016da5e0990853dc3be06c7a2b8ca5149354cc22c23b2cac33f6037974b
354 fee9447fa01c662ce259d3adda4d52eadcf9a9cb58e694d5a8e08710f2d87fb5
356 d0a414d432f595602c79d4af9909673051b6549a1611962be33d7278af7c3032
```

## Mystery ledger: explicit ej + tt closeout

The closing pass asked whether the review exposed a cheap strengthening or
an unexplained premise at the geometric/arithmetic boundary. It settled
the tempting ambiguity about two elliptic factors above a discriminant
prime: the quadratic equation for their j-invariants gives exactly one
negative valuation; E2 supplies the other contribution. No pairwise
nonisogeny hypothesis is needed. It also confirmed that squarefree positive
parameters, rather than arbitrary integer parameters, are what convert
distinctness into different prime supports. The paper makes that restriction.

No genuine unresolved mathematical mystery was exposed within the scoped
arguments. Independent validation of the companion proofs and computational
replay are evidence boundaries assigned to the owning task, not unexplained
geometric steps. No additional theorem or scope expansion is proposed.

## Process note

The first full live-handoff output exceeded the repository's output limit;
it was not treated as a completed read. A subsequent batch of bounded
chunks also exceeded the outer output budget. These command-shaping failures
were corrected by dedicated bounded chunk reads before the manuscript review.
They did not authorize broad searches or reliance on the truncated content.
This report is intentionally left uncommitted for the parent-owned coherent
C1140 commit, as requested. The disclosure text was read and not edited.

## Targeted final wording disposition

The final clarification pass was checked against authority source SHA-256
`0b5d704016979a6406bb06331cbc5eaedd6a7c12c82e1bd9433bd7fd2b3dc271`.
This was a targeted follow-up, not another full read, proof audit, or
computational rerun. No external reading depth is promoted.

- The first theorem now says, “The family over C has a three-dimensional
  image in cubic moduli.” This resolves minor comment 2 without changing
  the parameter-family assertion proved by the seed rank calculation.
- The introduction defines Z, T0 and T3 before displaying the two quotient
  descriptions and gives the dimension identity `7-3=4=2+(5-3)`. These
  definitions agree with the later Cox construction and clarify the
  mechanism without altering its hypotheses or conclusion.
- The appendix roadmap now distinguishes optional Appendices A--D from
  Appendix E's load-bearing finite nonemptiness calculation and Appendix
  F's verification scope. Postponing E's coordinate details on a first
  reading does not make its mathematical input optional. This is the
  correct dependency distinction.
- Removal of the `CHARACTER_GENERATORS` implementation-name sentence from
  the main body leaves the character basis, its dual cocharacter basis,
  the saturated lattice and the displayed action matrices intact. No
  mathematical premise was removed.
- The corrected Weierstrass substitution `[-12ty-9z:36tx:z]` remains in
  place.

There is no new defect from these changes. Both local comments are now
resolved, and the editorial recommendation and companion-proof boundary
remain unchanged. This report remains owned by the parent's coherent
C1140 commit; no separate commit was made by the referee.
