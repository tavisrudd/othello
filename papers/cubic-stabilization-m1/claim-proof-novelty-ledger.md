# Claim, proof, and novelty ledger

This repository-wide ledger is the owning surface for novelty and priority
statements in the primary one-stabilization paper and its two companion
manuscripts.  Each manuscript uses restrained related-work prose and does not
make an uncaveated “first” claim.

The paper proves irrationality after one stabilization for every smooth cubic
threefold unconditionally, through intrinsic rank-two counts and their blowup and projective-bundle
formulas. The nonzero canonical-discriminant count also detects the resonant
degree-two del Pezzo case.  The unconditional equations
`nu_6(X) = 2` and `nu_6(X x P^1) = 4` belong to the framed-monodromy companion;
the cycle-theoretic universal-`CH_0`-triviality results belong to the
six-axis-pencil companion.  Hypotheses R and T occur only in the framed
companion, and T is used there only for surface centers that are neither
minimal nor geometrically ruled.  Each row below carries
the status of its own claim family; a priority posture is recorded
independently of whether the claim is conditional.

| Claim family | Proof status | Literature posture | Manuscript action |
|---|---|---|---|
| Irrationality of `X x P^1` for every smooth complex cubic threefold | **STATUS: UNCONDITIONAL.** The occurrence-indexed categorical QDM ledger transports additive block markers through Iritani's blowup comparison and Iritani--Koto's projective-bundle comparison.  Its rank-two formal-exponent fold has value one on the Beauville-derived cubic zero block, vanishes for every actual point, curve, or surface center occurrence, doubles on `X x P^1`, and vanishes on `P^4`.  The framed fold is developed separately under Hypothesis R and the residual part of T | Beauville supplies the cubic quantum products; Iritani and Iritani--Koto supply the QDM comparisons. The author-hosted *Interpretations of spectra* chapter already displays the cubic exponent representatives; Cai gives a corroborating cubic formal-monodromy calculation. See the 2026-09-09 audit update below for the exact older-source access boundary. No inspected source states the one-stabilization theorem. A 2020 MathOverflow question records the problem as then open. Current absence claim remains “no predecessor located” pending the audit breadth recorded below | lead theorem `thm:every-cubic`; present the categorical ledger as the reusable mechanism and keep the framed count in its companion manuscript |
| Non-isotrivial family with `X` universally `CH_0`-trivial while `X x P^1` is irrational | **STATUS: UNCONDITIONAL on both halves.** The universal `CH_0`-triviality proof rests only on the printed six-axis geometric realization and the cited Voisin criterion; the irrationality half is now the unconditional one-stabilization theorem | Voisin gives the exact minimal-class criterion; Hartlieb identifies the one-dimensional special period locus; Roulleau supplies the Fano-surface configuration. **Pre-empted as an existence statement:** Yang--Yu--Zhu (arXiv:2508.03623, August 2025) give a two-dimensional family of smooth cubic threefolds with unirational parametrizations of degrees two and three, state that such parametrizations force universal `CH_0`-triviality, and extend the parametrizations to `X x P^m`. With `thm:every-cubic` their family separates the two properties on a larger locus than the `A_5`-pencil, which is one-dimensional in coarse moduli. **Pre-empted earlier still:** Voisin's own Theorem 4.5 with Lemma 4.6 gives components of codimension at most three in the moduli space along which `theta^4/4!` is algebraic, and Colliot-Thélène summarizes that theorem as producing explicit universally `CH_0`-trivial cubic threefolds including the Fermat hypersurface (arXiv:1607.05673, page 1). The pencil itself contains the Fermat cubic threefold: Hartlieb's Lemma 5.5, already cited in the introduction, records that the two `A_5`-components meet exactly in the Fermat cubic and one further member, and C914 re-derives it from the induced-character description of `W_5`. That member is also covered by Colliot-Thélène's almost-diagonal theorem and by the degree-three parametrization of Yang--Yu--Zhu Remark 3.6. **What is not pre-empted** is the separation itself: no prior source knew that `X x P^1` is irrational, so `thm:every-cubic` is what converts every one of these `CH_0`-loci into a separation locus, which is the content of `cor:voisin-separation`, `cor:fermat-separation`, and `cor:coprime-separation`. Also not pre-empted is the mechanism: algebraicity of the primitive minimal class along the whole pencil, proved from the six-axis lattice rather than from a decomposition of the diagonal or an odd-degree isogeny to a curve Jacobian. **Position of the pencil, settled 2026-08-18 (C914):** all but finitely many of its moduli points lie outside the explicit family of Yang--Yu--Zhu Theorem 3.3, by the Eckardt criterion `lem:eckardt-rank` together with the registered computation (`prop:A5-not-coprime`); their own Question 1.3 leaves open whether that family exhausts the coprime-degree locus, so no larger claim is made. Its intermediate Jacobian receives no odd-degree isogeny from a product of five elliptic curves, with no condition imposed on the pulled-back polarization, and none from a product of factors of dimension at most three under which the polarization pulls back to an odd multiple of the product polarization (`prop:no-elliptic-product`), so Voisin's construction does not reach the pencil that way. Whether the pencil lies in one of her components is open along exactly two routes: the four-dimensional factor being the Jacobian of an irreducible genus-four curve, or the intermediate Jacobian being odd-degree isogenous to the Jacobian of an irreducible genus-five curve | second theorem `thm:separation-family`; cite Yang--Yu--Zhu in the introduction, present the family as a separate mechanism, and make no existence-priority claim |
| Exact cubic packet `nu_6(X) = 2` for every smooth cubic threefold | **STATUS: UNCONDITIONAL — `nu_6(X) = 2`.** Complete internal derivation: Beauville's products give the small-even matrix; the integral-`z` block reduction, the indicial polynomial `rho^2 + rho + 5/36`, its roots `-1/6` and `-5/6`, the two unramified rank-one blocks, and the nonresonant Frobenius recursion are then carried out in the paper; now Proposition `prop:cubic-packet` | Beauville is the input for the matrix. The author-hosted *Interpretations of spectra* chapter, printed p. 285, already gives the cubic exponent representatives −1/6 and −5/6. No priority is claimed for these values or their immediate primitive-sixth eigenvalues. Cai is a further corroborating computation. The manuscript supplies its own integral-lattice reduction and stated multiplicity derivation; the older chapter is not yet version-matched to the published 2023 chapter | printed with an explicit sentence that the proposition uses neither Hypothesis 5.7R nor 5.7T, and with the Beauville derivation before the comparison to Cai |
| All-degree marked finite-etale graph saturation | **STATUS: UNCONDITIONAL.** Complete standalone proof, now Theorem `thm:all-degree-graph-saturation`. The theorem retains the marked elliptic ruling, orthogonal depth blocks, `B^{-1}`-self-adjoint graph slopes, exact cross ideals, signed rank-one straightening, square-zero realization, and faithful-flat descent | no exact predecessor was located in the bounded literature search. Classical tropical midpoint inequalities, unweighted integral Pluecker straightening, rational divisor generation, and divided-power/Fourier technology are credited only at their actual ranges. MathSciNet and a full citation-graph closure remain uncovered | printed without “first” or unqualified “to our knowledge” language |
| Full integral Hodge/product saturation for the non-CM six-axis packet | not a claim of this paper | prior six-axis and period-locus sources supply the geometry, not the repeated-root weighted Pluecker calculation or `Hdg^{2k}=P^k` in all degrees | omitted from the manuscript and its theorem inventory |
| Exact distinct-root rank-five middle defect | not a claim of this paper | the neighboring calculation is a weighted graph-lattice statement, not a novelty claim for unweighted Pluecker theory | omitted from the manuscript and its theorem inventory |
| Birational invariance of `nu_6` through dimension four and one-`P^1` invariance for threefolds | **STATUS: CONDITIONAL — depends on Hypothesis 5.7R, and on Hypothesis 5.7T only for surface centers that are neither minimal nor geometrically ruled**, which the framed operation provider and divisor-tagging specialization assume. It is the second fold of the categorical marker theorem, followed by cancellation in `Z`; now Theorem `thm:nu6-birational-invariance` | formal corollary/application of the common ledger, not a freestanding priority claim | printed with its dimension bound and the exact one-stabilization consequence |
| Specialized primitive-sixth vanishing for rational geometrically ruled centers | **STATUS: PROVED without Hypothesis 5.7T**, for the quadric surface through the Gromov--Witten product formula and for every index at least one through the rank-four Euler quartic and its discriminant, the latter for `F_1` on the graded-monomial specializations that every blowup center satisfies; now Proposition `prop:hirzebruch-specialized-vanishing`, with the spectrum in Lemma `lem:hirzebruch-euler-spectrum` and the certificate `hirzebruch-euler-spectrum` | the two quantum presentations of the Hirzebruch surfaces, and the transport that yields them, are Cotti, Theorems 9.3.1 and 9.3.3, and are cited as such; no priority is claimed for them. What is claimed is the specialized statement: the truncation identifying the presented algebra with the ring specialized along a strictly Novikov-admissible map, the degeneracy dichotomy, and the valuation and symbol arithmetic excluding the degeneracy locus at every center specialization of index at least one. Posture on the Euler quartic itself: no prior art located, but only Cotti's Chapter 9 was read, and whether the unspecialized spectrum or its collision locus is already recorded in the Frobenius-manifold and Dubrovin-conjecture literature on these surfaces has not been searched | printed with the derivation kept as an explicit second route, the source credited at the point of agreement, and the residual scope of 5.7T restated wherever it appears |
| Every smooth `V_14` has small-even `nu_6=2`, and `V_14 x P^1` is irrational | **STATUS: MIXED — irrationality of `V_14 x P^1` UNCONDITIONAL; the count `nu_6(V)=2` CONDITIONAL on Hypothesis 5.7R and on Hypothesis 5.7T for surface centers that are neither minimal nor geometrically ruled.** Both conclusions run through Kuznetsov's all-smooth flop between genuine rank-two projective bundles: irrationality from the unconditional one-stabilization theorem, and the count from the exact cubic count through the conditional projective-bundle operation formula; now Corollary `cor:v14-one-step` | the classical `V_14`--cubic birationality is not claimed. The bounded source/citation audit and the 200-row Scholar screen located no earlier all-smooth one-step irrationality theorem. MathSciNet remains uncovered | printed as the sole noncubic quantum application, with the flop attributed to Kuznetsov and the invariant conclusion proved locally |
| No elliptic-product route into Voisin's components | **STATUS: UNCONDITIONAL given the paper's own packet proposition and the non-CM generic elliptic factor.** Lattice proof at the prime two: the exotic two-primary gluing kernel forces every summand of an odd-index orthogonal splitting to be an `F_4`-subspace of the coefficient heart, every `F_4`-line is its own perpendicular for the trace-determinant pairing, so the only product shape is one plus four, and that shape is realized at odd index by every axis. The five-elliptic-factor conclusion drops the polarization hypothesis: no product of five elliptic curves admits an odd-degree isogeny onto the intermediate Jacobian, even though that Jacobian is isogenous to `E^5`; now `prop:no-elliptic-product` | closest neighbour is Hartlieb's Remark 5.8 with its footnote, where van Geemen and Yamauchi split the intermediate Jacobian of a cubic threefold with an automorphism of order five as an elliptic curve times the square of an abelian surface up to isogeny; that is an isogeny statement without polarization control, and the obstruction here is about realizing such a splitting by an odd-degree isogeny. For a product of principally polarized factors under which the polarization pulls back to an odd multiple of the product polarization, only the shapes one and one-plus-four survive, which already rules out every factor having dimension at most three; for a product of five elliptic curves nothing beyond odd degree is assumed. No bounded literature search for a predecessor of the obstruction has been run, so no absence claim is made | supporting proposition in Section 2, cited from the introduction's cycle-side paragraph; no novelty adjective, and the open residual question is stated in the same place |
| Six-axis polarization and principal gluing packet | complete manuscript derivation from Roulleau’s intersections, reduced-norm Riemann--Roch, the `F_4` heart, and strong Torelli; the proof uses only scalarity of the three-primary block | constituent ingredients are credited to Roulleau, Grieve, Hartlieb, and classical Torelli; the exact packet synthesis was not located in inspected sources | supporting geometric theorem; no global novelty adjective. The unused `Gamma_0(3)` selection clause has been removed |

## Index-two application

The primary paper now proves that one stabilization preserves rationality for
smooth complex Picard-rank-one index-two Fano threefolds. Przyjalkowski supplies
the degree-one and degree-two counting matrices; Kuznetsov and Prokhorov supply
the classification and the rational degree-four and degree-five cases. The
unified residue calculation is printed, and its arithmetic has two exact
replays. The degree-two obstruction additionally uses canonical-lattice
preservation throughout the comparison argument. This is a stated application,
with no global priority or literature-exhaustion claim.

## Proposed seventeen-family upgrade: audit update, 2026-09-09

This section records candidate additions under mathematical and literature
audit; it does not change the manuscript's current theorem hierarchy or formal
coverage. The detailed scope is in
[`2026-09-09-c1133-acceptance-map.md`](../../notes/2026-09-09-c1133-acceptance-map.md).
The complete literature audit is still open. Its source register currently has
73 entries; only five external sources (three papers and two source scripts)
are read in full. Every other entry records its actual partial or metadata
scope. The earlier bounded absence statements above must be read with this
expanded, still incomplete coverage boundary.

| Candidate | Mathematical audit status | Literature and attribution boundary |
|---|---|---|
| A: one stabilization preserves rationality for all seventeen smooth complex Picard-rank-one Fano threefold families | Exact seventeen-matrix arithmetic, geometric input normalization, all-member rational controls and the source-level family exhaustion have been checked. Written operation, persistence and center-vanishing arguments remain explicit dependencies; Lean only covers specified algebraic portions | Ordinary irrationality, quantum spectral methods and much of the underlying Fano data are prior work. Lee–Przyjalkowski's published mirror note addresses ordinary rationality for general Fanos. No global priority verdict on the all-member one-stabilization classification |
| B: among the nine detected families, one-stable birationality implies isomorphism of rational Hodge structures H³ | Written full-fiber equivariance and faithful Hodge-fixed-base adaptation; the exact coefficient-domain and common-field hypotheses must be retained. No replacement of the fiber by its invariant vectors | Hodge atoms and equivariant quantum comparisons are established precursors, including KKPY and Iritani. A claim to originate Hodge-enhanced spectral localization is excluded. Exact conservation statement comparison remains open |
| C: very-general cubic/quartic source, arbitrary smooth same-family target, one-stable birationality implies isomorphism | Deduction from B and Voisin's precise rational generic Torelli statement; source quantifiers checked | Credit Voisin for the rational/unpolarized Torelli input. The cancellation application is a candidate consequence, not a new Torelli theorem; no final novelty verdict |
| D: bounded-degree extensions of a fixed finitely generated characteristic-zero field yield finitely many geometric cubic partner classes | Written deduction from B, Orr v4, arithmetic intermediate Jacobians, finite kernels, polarization finiteness and Torelli. Original Narasimhan–Nori access remains a source gap, with secondary statement corroboration | Credit those finiteness and Torelli inputs. This is geometric-class finiteness, not finiteness of twists or an effective bound. Earlier arithmetic-spectrum rationality criteria have a different inspected conclusion; comprehensive comparison remains open |

**Concrete older precursor.** A primary author-hosted DSc thesis contains
*Interpretations of spectra*: printed p. 285 displays the cubic connection
and exponent representatives −1/6 and −5/6; Sections 2.1–2.4 develop the
quantum/noncommutative spectrum and ordinary-irrationality applications.
The same-title Springer chapter is by Katzarkov–Lee–Svoboda–Petkov (2023,
DOI 10.1007/978-3-031-17859-7_20), but the accessible thesis text has not been
version-matched to that publication. The exact read scopes, PDF hash and access
URL are recorded under `Katzarkov-DSciThesis-v2` in the
[source register](../../notes/2026-09-09-c1133-literature-sources.json).
Do not claim that the cubic exponent values first appeared in the present
paper or Cai's work. The chapter's cubic quantity δ=5/3 is its asymptotic
dimension, not the squared residue gap 4/9 used here.

The chapter attributes its birational splitting theorem and several detailed
arguments to *Blow up formulae*, reference [142], in preparation. This is an
exact source-level dependency to investigate, not grounds to erase the prior
explicit computation or to certify the entire chapter. Its inspected
arithmetic examples concern nonrationality over nonclosed fields with cycle
restrictions. No full-chapter negative or pre-emption decision on A–D is made.

**Formal boundary.** Exact rank-two modified-residue conjugacy now follows in
Lean from regular horizontal comparisons and inverse comparisons, including
resonance. The parameterized four-dimensional finite reduction and the four
rational discriminants are also checked. Scalar-even odd vanishing and polynomial transfer to the whole algebra are
also checked. The public audit has 324 terminals, with the five additions
registered as machinery. No manuscript claim has
been promoted: geometric QDM identification, the complete parameterized gauge
bridge, all seventeen certificates, super-primary selectors, rank-three
cluster persistence and faithful fixed-base constructions remain separately
listed obligations.

**Repeating surfaces.** The primary introduction's related-work paragraph and
the framed companion's exponent discussion need the older-source attribution
at the later manuscript review. The public README and theorem statements need
scope changes only if A–D are accepted for inclusion. The current ledger is
updated now; manuscript TeX, public exports and external summaries are not
silently upgraded. The detailed surface inventory is in the audit report.

## Current audit boundary

The paper-specific bounded search on 2026-08-11 queried exact and nearby
phrases for cubic-threefold one-step stabilization, stable irrationality,
universal `CH_0`-trivial cubic threefolds, and algebraic intermediate-Jacobian
minimal classes. It recovered Cai, KKPYY, Voisin, the classical
Clemens--Griffiths line, nearby intermediate-Jacobian and automorphism work,
and the 2020 MathOverflow question. It located no exact predecessor for either
headline conjunction.

A follow-up search on 2026-08-14, prompted by an external reader, queried
"cubic threefolds unirational parametrizations coprime degrees" and
"nonrational varieties unirational parametrizations coprime degrees" on the
open web and recovered Yang--Yu--Zhu, arXiv:2508.03623 (v1 5 August 2025,
v2 7 August 2025). The full text was fetched into the shared literature cache
and read at Theorems 1.1, 1.2, 3.1, 3.3, Corollary 3.5, Remarks 3.4--3.8, and
the closing paragraph of the introduction. The 2026-08-11 search missed it
because every query on that date was phrased in `CH_0` or stable-rationality
vocabulary, and the Yang--Yu--Zhu title and abstract use neither. This is a
recorded gap in the earlier search, not a metadata failure of the source.

The cycle and quantum literature searches were bounded to the exact queries,
screened sets, and source depths used for the statements above.  A separate
forward-citation check was made for the \(V_{14}\) consequence.

The forward-citation sweep of 2026-08-14 closes most of that gap. It resolved
eight seeds to pinned identifiers, took each forward tree from Semantic
Scholar, Crossref, and OpenAlex separately, screened the largest set with a
recorded discriminator, ran four OpenAlex topical searches and four zbMATH
Open API queries, and found no construction of universally `CH_0`-trivial
smooth cubic threefolds beyond Voisin, Colliot-Thélène, and Yang--Yu--Zhu, and
no statement about a cubic threefold times a projective space. Full search
record, including the three services' disagreement on the Voisin count of 71,
27, and 9: `../../notes/2026-08-14-c912-forward-citation-sweep.md`.

What remains uncovered: MathSciNet, which needs institutional authentication;
the zbMATH web interface, which refuses automated fetches; Google Scholar; and
the 2019 survey chapter *Birational Invariants and Decomposition of the
Diagonal*, which is paywalled and is exactly the kind of source that could
carry a construction the citation graph hides. Until those are covered, public
prose should say only what is proved and should avoid “first,” “new,” or “to
our knowledge.”

The positioning pass begun on 2026-08-18 added recent sources and the
classical comparison the introduction had left implicit. Web search on
"Guere cubic threefold irrationality Hodge quantum cohomology" recovered
Guere, arXiv:2603.04518v1, and Benedetti--Fay--Guere--Manivel--Perrin,
arXiv:2607.26718v1. Neither pre-empts anything in this paper: Guere states a
necessary Hodge condition for *rational cubic fourfolds*, and the joint
criterion assumes `b_1 = b_3 = 0` with a large vanishing middle `H^4`, which
`X x P^1` fails on both counts (`b_3 = 10`, middle `H^4` Tate). Their
existence does, however, bound the novelty posture: the joint paper derives
irrationality from atoms, monodromy, and Hodge theory without explicit
quantum-cohomology computations, so this paper claims no novelty for the
broad idea of localizing Hodge data into quantum spectral packets, nor for
"the first atomic refinement of a classical Hodge obstruction."  KKPY's
Example 6.21 already recovers the irrationality of every smooth cubic
threefold from the zero spectral piece enhanced by Serre/formal-monodromy
data.  The invariant claimed here is instead the rank-two formal-exponent
marker: after the canonical elementary modification, it requires the two
residue eigenvalues to be distinct modulo the integers.  A merely nonzero
residue discriminant is insufficient for that exponent-class marker. The
stronger lattice count now used for quartic double solids instead relies on
regular comparison maps and inverses preserving the canonical modification.
The contribution is localized to the uniform one-stabilization theorem, the
faithful specialization of individual center summands, vanishing for every
point, curve, and surface center, and the projective-bundle comparison used
for stabilization.

The same pass records the classical comparison now printed in the
introduction: after one stabilization the direct Clemens--Griffiths mechanism
gives no contradiction, because `H^3(X x P^1) = H^3(X)` is already the `H^1`
of the Fano surface up to twist and the middle `H^4` is Tate. This is a
statement about the standard intermediate-Jacobian and blowup bookkeeping
only; it does not assert that the Fano surface occurs as a blowup center, nor
that every classical Hodge-theoretic obstruction fails.

## Read depth for principal sources

- Jiaji Cai, *The cubic threefold is symplectically irrational*,
  arXiv:2608.01577v1. **Read depth: full text.**
- Ludmil Katzarkov, Maxim Kontsevich, Tony Pantev, and Tony Yue Yu,
  *Birational Invariants from Hodge Structures and Quantum Multiplication*,
  arXiv:2508.05105v2. **Read depth: partial.** Read Theorems 4.1, 4.5,
  4.11; Definitions 5.10, 5.16, 5.21; Propositions 5.17, 5.22; Claim 6.15;
  Example 6.21 and the surrounding proofs.
- Claire Voisin, *On the universal CH_0 group of cubic hypersurfaces*,
  published JEMS version and arXiv:1407.7261. **Read depth: partial.** Read
  Corollary 4.4 and its criterion setup, and on 2026-08-14 Theorem 4.5 with
  its proof and Lemma 4.6, which give the codimension-at-most-three
  components and the explicit order-three-invariant example.
- Jean-Louis Colliot-Thélène, *CH_0-trivialité universelle d'hypersurfaces
  cubiques presque diagonales*, Algebraic Geometry 4 (2017), 597--602;
  arXiv:1607.05673. **Read depth: partial.** Read the introduction, including
  its summary of Voisin's Theorem 4.5 and the separated-variable hypothesis
  of the main statement.
- Martin Hartlieb, *Special subvarieties in the locus of intermediate
  Jacobians of cubic threefolds*, published/author preprint corresponding to
  arXiv:2304.03214. **Read depth: partial.** Read Proposition 5.7, the
  `A_5` component, and the period-map setup.
- Clemens--Griffiths, Roulleau, Grieve, and Beckmann--de Gaay Fortman were
  checked at the theorem loci used in the manuscript.
- MathOverflow question 379287, “Is the product of a cubic threefold and the
  projective line irrational?” **Read depth: full page.** Accessed on
  2026-08-11; it records only the state of knowledge asserted in December
  2020 and is not a primary theorem source.
- Song Yang, Xun Yu, and Zigang Zhu, *Nonrational varieties with unirational
  parametrizations of coprime degrees*, arXiv:2508.03623v2. **Read depth:
  partial.** Read Theorems 1.1, 1.2, 3.1, 3.3; Corollary 3.5; Remarks
  3.4--3.8; and the universal `CH_0`-triviality paragraph preceding
  Question 1.3. The Noether--Cremona quotient computations in Sections 2 and
  3 were not verified line by line.
- Jeremy Guere, *On the irrationality of cubic fourfolds*,
  arXiv:2603.04518v1. **Read depth: partial.** Read the abstract,
  Section 0 including the statement of Theorem 56 and the remark recording
  that Hodge atoms are not used while the evaluation maps are closely related
  to them, and the opening of Section 1.
- Vladimiro Benedetti, Aideen Fay, Jeremy Guere, Laurent Manivel, and
  Nicolas Perrin, *An atomic criterion for irrationality without quantum
  computations*, arXiv:2607.26718v1. **Read depth: partial.** Read the
  abstract, the introduction, and the statement of Theorem 4.1 with its
  three hypotheses; Remark 4.2's maximal-spectrum subtlety was noted but is
  not used here, since Section 4 does not use their evaluation argument.
- Alexander Kuznetsov, *Derived categories of cubic and `V_14`
  threefolds*, arXiv:math/0303037v1. **Read depth: full text.** Section 2,
  especially Theorems 2.2 and 2.17--2.18 and Remark 2.19, is load-bearing.
