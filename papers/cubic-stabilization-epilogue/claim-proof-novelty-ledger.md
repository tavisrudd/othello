# Claim, proof, and novelty ledger

This ledger is the owning surface for novelty and priority statements in the
geometric epilogue. The manuscript itself uses restrained related-work prose
and does not make an uncaveated “first” claim.

| Claim family | Proof status | Literature posture | Manuscript action |
|---|---|---|---|
| Irrationality of `X x P^1` for every smooth complex cubic threefold | complete manuscript proof from the primitive-sixth-root multiplicity, projective-bundle formula, low-dimensional atom exclusion, and weak factorization | Cai proves symplectic irrationality of `X`; KKPYY prove the atom formalism and already recover irrationality of `X`, but no inspected source states the one-stabilization theorem. A 2020 MathOverflow question records the problem as then open. Current absence claim remains “no predecessor located” pending the audit breadth recorded below | lead theorem `thm:every-cubic`; state as a consequence of Cai plus KKPYY with the paper-local atomicity lemma, not as a freestanding invention of the underlying quantum framework |
| Non-isotrivial family with `X` universally `CH_0`-trivial while `X x P^1` is irrational | complete manuscript proof conditional only on the printed six-axis geometric realization and the cited Voisin criterion | Voisin gives the exact minimal-class criterion; Hartlieb identifies the one-dimensional special period locus; Roulleau supplies the Fano-surface configuration. **Pre-empted as an existence statement:** Yang--Yu--Zhu (arXiv:2508.03623, August 2025) give a two-dimensional family of smooth cubic threefolds with unirational parametrizations of degrees two and three, state that such parametrizations force universal `CH_0`-triviality, and extend the parametrizations to `X x P^m`. With `thm:every-cubic` their family separates the two properties on a larger locus than the `A_5`-pencil, which is one-dimensional in coarse moduli. **Pre-empted earlier still:** Voisin's own Theorem 4.5 with Lemma 4.6 gives components of codimension at most three in the moduli space along which `theta^4/4!` is algebraic, and Colliot-Thélène summarizes that theorem as producing explicit universally `CH_0`-trivial cubic threefolds including the Fermat hypersurface (arXiv:1607.05673, page 1). The pencil itself contains the Fermat cubic threefold, proved in C914; that member is also covered by Colliot-Thélène's almost-diagonal theorem and by the degree-three parametrization of Yang--Yu--Zhu Remark 3.6. What is not pre-empted is the mechanism: algebraicity of the primitive minimal class along the whole pencil, proved from the six-axis lattice rather than from a decomposition of the diagonal or an odd-degree isogeny to a curve Jacobian | second theorem `thm:separation-family`; cite Yang--Yu--Zhu in the introduction, present the family as a separate mechanism, and make no existence-priority claim |
| All-degree marked finite-etale graph saturation | complete human proof, now Theorem `thm:all-degree-graph-saturation`. The theorem retains the marked elliptic ruling, orthogonal depth blocks, `B^{-1}`-self-adjoint graph slopes, exact cross ideals, signed rank-one straightening, square-zero realization, and faithful-flat descent | no exact predecessor was located in the bounded literature search. Classical tropical midpoint inequalities, unweighted integral Pluecker straightening, rational divisor generation, and divided-power/Fourier technology are credited only at their actual ranges. MathSciNet and a full citation-graph closure remain uncovered | printed without “first” or unqualified “to our knowledge” language |
| Full integral Hodge/product saturation for the non-CM six-axis packet | not a claim of this paper | prior six-axis and period-locus sources supply the geometry, not the repeated-root weighted Pluecker calculation or `Hdg^{2k}=P^k` in all degrees | omitted from the manuscript and its theorem inventory |
| Exact distinct-root rank-five middle defect | not a claim of this paper | the neighboring calculation is a weighted graph-lattice statement, not a novelty claim for unweighted Pluecker theory | omitted from the manuscript and its theorem inventory |
| Birational invariance of `nu_6` through dimension four and one-`P^1` invariance for threefolds | complete formal consequence of the printed operation formulas, the dimension-at-most-two vanishing lemma, weak factorization, and cancellation in `Z`; now Theorem `thm:nu6-birational-invariance` | formal corollary/application, not a freestanding priority claim and not a theorem attributed verbatim to KKPYY | printed with its dimension bound and the exact one-stabilization consequence |
| Every smooth `V_14` has small-even `nu_6=2`, and `V_14 x P^1` is irrational | complete from the exact cubic count and Kuznetsov's all-smooth flop between honest rank-two projective bundles; now Corollary `cor:v14-one-step` | the classical `V_14`--cubic birationality is not claimed. The bounded source/citation audit and the 200-row Scholar screen located no earlier all-smooth one-step irrationality theorem. MathSciNet remains uncovered | printed as the sole noncubic quantum application, with the flop attributed to Kuznetsov and the invariant conclusion proved locally |
| Six-axis polarization and principal gluing packet | complete manuscript derivation from Roulleau’s intersections, reduced-norm Riemann--Roch, the `F_4` heart, and strong Torelli; the proof uses only scalarity of the three-primary block | constituent ingredients are credited to Roulleau, Grieve, Hartlieb, and classical Torelli; the exact packet synthesis was not located in inspected sources | supporting geometric theorem; no global novelty adjective. The unused `Gamma_0(3)` selection clause has been removed |

## Current audit boundary

The epilogue-specific bounded search on 2026-08-11 queried exact and nearby
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

This is not yet a final comprehensive priority audit. MathSciNet was not
covered; zbMATH/OpenAlex/Crossref/Semantic Scholar forward trees have not yet
been closed for the two recent quantum sources; and several web results were
abstract/metadata only. Until that audit is completed, public prose should
say only what is proved and should avoid “first,” “new,” or “to our knowledge.”

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
- Alexander Kuznetsov, *Derived categories of cubic and `V_14`
  threefolds*, arXiv:math/0303037v1. **Read depth: full text.** Section 2,
  especially Theorems 2.2 and 2.17--2.18 and Remark 2.19, is load-bearing.
