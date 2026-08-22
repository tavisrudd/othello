# C910 full-claim and anti-smuggling audit

## Scope and standard

This audit covers all 53 manuscript claim rows in
`papers/cubic-stabilization-m1/lean/verification/claims.json`, with
special attention to the 22 fragmentary and now 26 conditional rows.  Code
provenance is not treated as evidence: every reviewer-facing terminal was
checked against its Lean type, proof body or immediate application theorem,
manuscript statement, and scope caution.

A row fails the anti-smuggling test if any of the following occurs:

1. a theorem conclusion, or a proposition definitionally equivalent to it, is
   stored in an input structure and copied out;
2. a premise stronger than the cited mathematical input silently does the
   substantive work;
3. an unused hypothesis appears only to make an abstract theorem look like the
   manuscript statement;
4. a manuscript clause is absent from every mapped public terminal;
5. an old atom or packet interface is presented as if it were a specialization
   of the new occurrence-indexed categorical spine.

Explicit imported mathematical comparisons are allowed only when their exact
strength is visible in the theorem type and the formal conclusion is a genuine
deduction from them.  A row whose manuscript geometry is not represented is a
fragment, even when the represented algebraic composition is complete.

## Repairs forced by the audit

1. `thm:every-cubic-conditional` now exposes all three clauses: marker four on
   the cubic stabilization, marker zero on every rational smooth projective
   fourfold, and irrationality.
2. `prop:A5-nonseparated` now exposes its second sentence by composing the
   separated-variable exclusion with fibrewise universal `CH₀`-triviality.
   Its existence direction is constructed from a parameter, model, moduli-point
   equality, separated-form proof, and projective-equivalence proof; the
   existential conclusion is no longer stored in the input record.
3. `thm:separation-family` no longer takes `isNonIsotrivial fibre` itself as a
   field.  It takes a typed period map, an explicit pair of distinct period
   values, and the imported implication from period-map nonconstancy to
   non-isotriviality.
4. The three separation applications now use the direct rank-two residue
   context, not the legacy ordinary Hodge-atom ledger.
5. The genus-eight corollary now has two literal specializations of the common
   categorical spine: direct residue transport for irrationality and framed
   marker transport for `ν₆(V)=2`.
6. `cor:voisin-separation` was downgraded from conditional deduction to
   fragment.  Lean proves the fibrewise separation composition, but the
   countable union and codimension-three locus are not represented at all.
7. `prop:qdm-operation-ledgers` now formalizes the exact categorical adapter
   from a multiplicity-preserving matching of transported block components to
   the two folded operation formulas.  Pairwise singleton-fold preservation is
   explicit; the cited QDM comparisons must still construct the matching.

## Row-by-row verdict

| # | Manuscript label | Coverage after audit | Verdict |
|---:|---|---|---|
| 1 | `thm:every-cubic` | conditional | Pass after repair: exact stabilized marker and irrationality are exposed through the direct occurrence-indexed context. |
| 2 | `thm:every-cubic-conditional` | conditional | Pass after repair: all three manuscript clauses are returned; rationality enters only through birational comparison with projective four-space. |
| 3 | `cor:voisin-separation` | fragment | Honest after downgrade: fibrewise composition is checked, but the moduli locus and codimension bound are absent. |
| 4 | `cor:fermat-separation` | conditional | Pass: Lean proves the Fermat separated-variable decomposition and composes the cited criterion with the direct residue obstruction. |
| 5 | `cor:coprime-separation` | conditional | Pass: degree persistence and the coprime-degree criterion are explicit; Lean proves `Coprime 2 3` and uses the direct residue obstruction. |
| 6 | `thm:separation-family` | conditional | Pass after repair: non-isotriviality is derived from typed period-map nonconstancy, irrationality uses the direct categorical spine, and separated-variable existence is built from primitive witness data. |
| 7 | `lem:six-point-hearts` | fragment | Honest fragment: concrete modules and commutants are proved; the geometric axis identification is not claimed. |
| 8 | `prop:six-axis-polarization` | fragment | Honest fragment: Gram spectrum and Smith reduction are proved; the geometric isogeny/polarization realization is absent. |
| 9 | `lem:relative-six-axis` | fragment | Honest fragment: integral lattice and primary-coordinate consequences are checked from visibly supplied relative geometry. |
| 10 | `prop:principal-gluing-packet` | fragment | Honest fragment: finite-field packet algebra is proved; geometric labels, kernels, and family realization remain explicit omissions. |
| 11 | `lem:graph-coefficient-lattice` | fragment | Honest fragment: coefficient and depth identities are proved; the geometric graph-lattice input is not manufactured. |
| 12 | `lem:dvr-rank-one` | complete | Pass: the stated DVR rank-one equivalence is represented and proved without imported geometric premises. |
| 13 | `thm:all-degree-graph-saturation` | fragment | Honest fragment: square-zero assembly and descent are checked; geometric realization and divided-power compatibility remain supplied. |
| 14 | `lem:six-axis-local-chart` | fragment | Honest fragment: local Gram, splitting, and slope calculations are explicit; geometric chart identification is absent. |
| 15 | `thm:six-axis-divided-powers` | fragment | Honest fragment: the algebraic local-global implication is proved; the manuscript's geometric realization is not. |
| 16 | `cor:universal-ch0` | conditional | Pass: algebraicity and Voisin's equivalence are separate visible inputs; universal `CH₀`-triviality is their logical consequence. |
| 17 | `lem:eckardt-rank` | fragment | Honest fragment: the bordered-matrix criterion is proved; no cubic or Eckardt geometry is constructed. |
| 18 | `lem:eckardt-involution` | absent | Honest absent row. |
| 19 | `prop:eckardt-reflection-group` | absent | Honest absent row. |
| 20 | `prop:A5-not-coprime` | absent | Honest absent row. |
| 21 | `lem:pencil-loci-coordinates` | absent | Honest absent row; the registered CAS evidence is not mislabeled as Lean. |
| 22 | `prop:no-elliptic-product` | fragment | Honest fragment: only the two-primary linear-algebra obstructions are proved. |
| 23 | `prop:A5-nonseparated` | conditional | Pass after repair: both the exact locus and the universal-`CH₀` statement off it are public conclusions, and the existence half is constructed rather than projected from an equivalent existential premise. |
| 24 | `prop:cubic-block-data` | fragment | Honest fragment: the displayed matrices, residue, gauge coefficients, and indicial polynomial are checked; their QDM origin is imported. |
| 25 | `lem:A0preserve` | conditional | Pass: preservation of the nilpotent line is derived from explicit coefficient and horizontality equations, not assumed. |
| 26 | `prop:rank2-rigidity` | conditional | Pass: regularity, the Lax equation, and discriminant constancy are derived from typed flatness/horizontality identities. |
| 27 | `prop:residue-discriminant-exponents` | fragment | Honest fragment: the squared eigenvalue-separation identity is proved; exponent/monodromy realization is absent. |
| 28 | `def:framed-sixth-multiplicity` | fragment | Honest fragment: the matrix invariant is defined exactly; no geometric framed monodromy is constructed. |
| 29 | `lem:exact-low-degree-shifts` | fragment | Honest fragment: scalar-twist and divisor-substitution matrix consequences are proved; the geometric comparison is not. |
| 30 | `lem:numerical-base-change` | fragment | Honest fragment: completed coefficient algebra and finite-support identities are checked; GW and analytic inputs are absent. |
| 31 | `prop:ranktwo-framed-germ` | fragment | Honest fragment: persistence and characteristic-polynomial rigidity are proved in a formal matrix model; geometric identification is not. |
| 32 | `prop:framed-operations` | conditional | Pass: multiplicity formulas follow from stronger, explicitly supplied characteristic-polynomial factorizations; the marker formulas themselves are not input fields. |
| 33 | `def:strict-novikov-admissible` | fragment | Honest fragment: this is a certificate type for the algebraic core, not a claim to construct geometric specializations. |
| 34 | `prop:direct-specialized-lowdim` | conditional | Pass: nilpotence and vanishing are derived from explicit spectral/characteristic-polynomial premises; the geometric QDM identifications are disclosed. |
| 35 | `lem:divisor-tagging` | conditional | Pass with strong caution: two final common-field polynomial equalities remain explicit premises, but equality of multiplicities and vanishing are derived from them rather than stored as fields. |
| 36 | `prop:low-dimensional-vanishing` | conditional | Pass: classification witnesses plus seed, bundle, blowup, and specialization rules are explicit; induction produces the vanishing. |
| 37 | `thm:nu6-birational-invariance` | conditional | Pass: fixed-dimension occurrence nullity feeds the generic telescope; the one-`P¹` consequence cancels exactly one factor two. |
| 38 | `lem:simple-euler-block` | fragment | Honest fragment: scalar formal-series consequences are proved; the LT block and monodromy identification are not. |
| 39 | `prop:projective-product-nu` | conditional | Pass: the characteristic-polynomial power is an explicit imported tensor-decomposition consequence; multiplicity scaling is proved from it. |
| 40 | `cor:p3-nu6` | conditional | Pass: point involutivity and the product formula are explicit; projective-space vanishing is deduced. |
| 41 | `prop:cubic-packet` | conditional | Pass: the charpoly comparison is explicit; root identities and exact primitive-sixth multiplicity two are proved. |
| 42 | `cor:cubic-formal-germ` | conditional | Pass: factorization and exponent-polynomial rigidity are visible premises; constancy of multiplicity two is a genuine polynomial deduction. |
| 43 | `cor:cubic-product-nu` | conditional | Pass: the strict `m=1` product formula and cubic value give exactly four; no higher stabilization conclusion is exposed. |
| 44 | `cor:v14-one-step` | conditional | Pass after repair: direct irrationality and framed value two both run through occurrence-indexed categorical contexts. |
| 45 | `def:monomial-specialization` | fragment | Honest fragment: the consumer-facing leading-term certificate is defined; no associated graded Novikov ring is constructed. |
| 46 | `lem:hirzebruch-euler-spectrum` | fragment | Honest fragment: the quartic discriminants and splitting are checked; identification with Euler multiplication is absent. |
| 47 | `lem:ruled-degeneracy-dichotomy` | conditional | Pass: degeneracy, root multiplicity, and block shape are derived for a supplied matrix/charpoly model; geometric Euler identification is explicit input. |
| 48 | `lem:center-specialization-nondegenerate` | conditional | Pass: valuation and leading-term laws imply the nondegeneracy statements; monomiality of geometric center maps is not assumed proved. |
| 49 | `prop:hirzebruch-specialized-vanishing` | conditional | Pass: simple spectrum plus the supplied LT implication yields unipotent framed characteristic polynomial and zero multiplicity. |
| 50 | `lem:center-maps-monomial` | fragment | Honest fragment: after an additive exponent map is supplied, Lean proves the coefficient-one monomial law and linear independence in the target monoid algebra. No geometric specialization or associated-graded identification is constructed. |
| 51 | `thm:marker-ledger` | conditional | Pass: the effective fold, occurrence-indexed telescope, and quotient descent are proved; factorization and QDM operation providers are explicit data. |
| 52 | `prop:qdm-operation-ledgers` | conditional | Pass after repair: a multiplicity-preserving matching of transported components, with singleton fold values preserved pairwise, yields both folded operation formulas. The matching itself remains the exact external QDM-comparison input. |
| 53 | `prop:atomic-lowdim` | conditional | Pass: classification induction produces intrinsic nullity and then actual occurrence nullity through an explicit source-center comparison. |

## Bottom line

No remaining reviewer-facing terminal proves a manuscript result merely by
projecting that result from an input structure.  The strongest external
premises are the comparison/formula statements that genuinely belong at the
formalization boundary, and each is named in the corresponding claim caution.
The one row whose missing geometric clause could not be represented honestly,
`cor:voisin-separation`, is now graded as a fragment.

The audit remains strictly `m=1`: no terminal, claim row, or repair asserts an
`m=2` or all-stabilizations consequence.

## `ej` + `tt` closeout

The extra-juice pass found one cheap structural gain beyond the original
repair list: the genus-eight corollary could be made a much cleaner test of the
new architecture.  Its direct conclusion now transports the residue-marker
obstruction across Kuznetsov's two projectivizations, while its framed
conclusion applies the framed context to those same total spaces and cancels
the common rank-two factor.  This is stronger evidence that the categorical
spine is genuinely reusable than merely routing the cubic headline through it.

The Tao-style pass asked where a skeptical reader could still confuse a formal
boundary with a proof.  That exposed the Voisin row: the terminal had no object
representing a codimension-three countable union, so no collection of caveats
could make the whole corollary a conditional deduction.  Downgrading it to a
fragment is the honest resolution.  The same pass caught the type-level prose
error “cancelling two in `Z`”; the formal target is `N`, and the manuscript now
says so.

## Mystery ledger

| Feature | Status | Exact remaining gap or owner |
|---|---|---|
| Why the common proof needs an effective monoid rather than a group completion | Settled | Boolean and natural-valued folds need not survive group completion; the free effective fold is formalized and no cancellation is used in categorical descent. |
| Why the one-`P¹` framed consequence can cancel while the generic theorem cannot | Settled | The application fold lands in `N`, where equality of two doubled values cancels; this is a specialization after descent, not a cancellation assumption on the generic target. |
| Whether the arbitrary ambient-dimension telescope smuggles an all-stabilizations theorem | Settled | Ambient dimension `d` indexes weak factorization only. Every application and every product statement remains the single `m=1` stabilization; no iteration terminal exists. |
| The codimension-three Voisin locus | Open, honestly graded | No moduli-space or codimension object occurs in Lean. The row is now a fragment; closure would require a separate formal model of the cited locus, not another logical wrapper. |
| Actual Iritani/Iritani--Koto QDM comparison construction | Open at the declared trust boundary | The categorical passage from a fold-compatible block matching to both operation formulas is now formalized. The exact comparison constructions, regularity/parity adapters, and occurrence-specialization maps producing that matching remain external. |
| Monomiality of the geometric center maps | Open at the declared trust boundary | The row is now a fragment: the algebra after a supplied exponent map is formalized, but the geometric center specialization and associated-graded Novikov identification are not. |
| Whether the valuation-zero exceptional variable invalidates the graded-monomial proof | Settled | The completed degree-zero coefficients can exceed `C[u,u^{-1}]`, so the proof no longer claims that Laurent monomials span the whole associated graded. It proves the needed finite `C`-linear independence of the coefficient-one leading monomials and extends that set to a Hamel basis. |
| Whether splitting the reviewer interface can hide or duplicate a terminal | Settled | The claim inventory names every semantic facade, the checker requires the public aggregator to import each one, and the union contains exactly the same 311 declaration/proof blocks and terminal digests as the former monolith. |
| Whether the facade split also shrinks incremental rebuild closures | Settled | Section-local imports replace the common umbrella. The proof-bearing facades now reach 69, 69, 80, 73, and 103 local modules, versus 164 through the former shared surface; coefficient-tower, formal-connection, and residue-pairing machinery reach 78, 66, and 91 modules instead of one 116-module closure, and the declaration-free synthesis reaches none. |
| Four `A₅`/Eckardt geometric rows | Open cycle/moduli work | `lem:eckardt-involution`, `prop:eckardt-reflection-group`, `prop:A5-not-coprime`, and `lem:pencil-loci-coordinates` remain absent; the last has registered CAS evidence but no Lean certificate. |

No unexplained numerical coincidence remains in the categorical proof itself.
The open items are explicit formalization boundaries or separately named
geometric claims, not hidden premises of the `m=1` argument.
