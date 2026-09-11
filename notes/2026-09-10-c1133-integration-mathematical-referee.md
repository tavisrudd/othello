# C1133 integration: independent mathematical referee report

Date: 10 September 2026. Lane: `cubic-threefolds`.

## Summary and contribution

The proposed Hodge section constructs a representation-valued refinement of the numerical quantum-block obstruction. Its essential choices are to restrict parameters to a common Hodge group's fixed locus, retain the full cohomology fiber, and select whole primary factors by their full even rank and, in rank two, their canonical modified residue. Blowup transport and vanishing on surface centers then make this selected representation invariant under birational maps of fourfolds. On the nine specified Fano threefold families, the invariant of the product with the projective line recovers twice the rational third-cohomology representation. Cancellation and rational descent yield the stated rational Hodge conservation theorem.

The replacement argument removes the need for general projective-bundle reconstruction in this deduction. It uses the small product formula at the Fano endpoints, formal continuation in every even bulk direction, and a separate exact mixed-bulk computation on products of curves with the projective line.

## Significance and scope

This is a substantial structural upgrade over a numerical obstruction: equality of dimensions is replaced by an isomorphism of rational Hodge structures. The conclusion is appropriately limited to the nine named families and to one projective-line stabilization. Neither an integral lattice nor a principal polarization is recovered. General-bundle statements require their own comparison input.

This report tests internal correctness, not priority or the complete external theorem chain. Its authoritative scope is the frozen `2026-09-10-c1133-b-body-prototype.tex` and the mathematical arguments in Sections 1–2 of `2026-09-10-c1133-transport-input-reduction.md`, together with the relevant existing numerical proofs in `papers/cubic-stabilization-m1/sections/02-qdm-marker.tex`. I also read the fixed-base proof and Proposition 12.1 of the preserved upgrade packet to resolve their explicit proof dependencies. I did not open previous referee reports or use their conclusions. The routing handoff and reduction note contain review-status metadata; that metadata is not evidence for any verdict here. A handoff read exceeded the output budget; no conclusion relies on the truncated portion.

I have not independently re-established the external blowup comparison, its equivariance and completed-ring realization, weak factorization, or the nine geometric matrix identifications. These remain imported premises. The numerical section was moving during integration; this is not a claim to have read the final assembled manuscript.

## Correctness

### Cyclic persistence, including transverse product directions

The persistence argument withstands the principal attack: a cyclic cluster might conceivably split after leaving the small product locus. The proof does not assume the desired nilpotence in computing the commutant. Nakayama first provides a cyclic vector over the complete local ring, so every commuting leading base coefficient is a polynomial in the centered operator. The power-trace equations from flatness preserve the ideal of the nilpotent locus. The lowest-total-degree argument forces those traces to remain zero in characteristic zero.

For an independent check of the rank-three case actually needed here, set `p2=tr(N^2)` and `p3=tr(N^3)`. Write a centered commuting coefficient as `C=a0 I+a1 N+a2 N^2`, with `a0=-a2 p2/3`. Flatness and the traceless rank-three Cayley–Hamilton identity give

    ∂p2 = -2 a1 p2 - 2 a2 p3,
    ∂p3 = -3 a1 p3 - (a2/2) p2^2.

Both vanish initially; a lowest-degree comparison makes both vanish identically. Cyclicity then gives one nilpotent Jordan block. This verifies the rank-three extension independently of the packet's general power-sum notation. The existing numerical section's rank-two lemma alone is insufficient for this step; Proposition 12.1 supplies the missing general statement and should appear in the integration.

The reasoning applies to mixed bulk directions because it uses flatness in each coordinate of the complete even formal germ. It does not claim that restriction to the small locus is injective. Independence of the fiber Novikov parameter separates opposite projective-line shifts from all endpoint eigenvalues before continuation. Thus no collision is silently crossed.

### Canonical residue and the original lattice

The rank-two construction correctly uses a regular comparison with regular inverse on the original lattice. Such a map carries `im N` to its counterpart and therefore carries the canonical elementary modification to the corresponding modification. In modified frames both directions remain regular, so reduction modulo `z` conjugates residues. This also works in the resonant case. A comparison of exponent classes alone would not prove discriminant invariance, but the text explicitly makes the stronger lattice argument.

The tensor product with a regularly separated rank-one projective-line factor shifts the rank-two residue by a scalar. The discriminant is therefore unchanged. Flatness of the modified base connection then transports its value throughout the even germ. I checked the displayed rank-two pole argument: the possible lower-left base pole has coefficient `k`, and the diagonal flatness equations give `νk=0`, forcing `k=0` because the cyclic nilpotent entry is a unit.

### Fixed-base injection

The proposed injection does not make the invalid inference that restricting an injection to a quotient preserves injectivity. It constructs and tests the reduced fixed-base ring directly. The restrictions needed by the proof are substantive: no free source divisor variables, polynomial unit dependence, bounded homogeneous grading, and independent occurrence divisor coordinates in the target.

Under those conventions, coefficients at a fixed effective numerical class are polynomial in the negative-degree higher parameters. Translation by the fixed degree-zero shifts is therefore legitimate. Restriction of an ambient ample divisor gives finite bounded numerical-degree slices. At the first nonzero slice, the independent target divisor characters distinguish every collision of the raw Novikov map. A one-parameter integral restriction makes the resulting Vandermonde system invertible. Algebraic divisors suffice to separate numerical classes and remain fixed by the Hodge group. This closes the specific possible kernel mechanism.

The argument depends on the stated coordinate and topology properties of the imported comparison. Its correctness should not be inflated into a new independent proof of those properties. Likewise, the invariants telescope as representation multiplicities; no global composition of incompatible Laurent expansions is necessary.

### Full supermodule ranks and low-dimensional vanishing

The distinction between restricting the bulk base and restricting the fiber is maintained. Selection uses full even fiber rank. The retained odd representation is extracted only afterwards. This is necessary and is implemented consistently.

The even-rank-one Frobenius claim is correct. With unit `e`, the product of two odd elements is `ce`; supercommutativity makes its square zero, so `c=0`. Since every even element is scalar, the odd pairing is then zero unless the odd part vanishes. Nondegeneracy supplies the required conclusion. Whole primary factors are algebra factors at the leading level, so their even units and restricted Frobenius pairings are available.

For a nef-canonical minimal surface, centered Euler multiplication raises ordinary cohomological degree, also after restriction to the fixed base. The only potentially retained full even rank is three, hence `b2=1`. A nonzero holomorphic one-form would produce a nonzero square-zero `(1,1)` class, contradicting the ample generator of the one-dimensional second cohomology. Thus the odd contribution vanishes in this case.

I also checked the exceptional elliptic case independently from the supplied potential. The even potential `F=v^2 c/2+vab+cQ` yields `h^2=0`, `hp=h⋆p`, and `p^2=Q(1+ch)`. With `p'=(1-ch/2)p`, one obtains `(p')^2=Q` and centered Euler element `(2-2g)h+2p'`. Hence the centered operator on either rank-two factor is exactly `(2-2g)h` for all mixed bulk values. In genus one it is identically zero, so no illegitimate cyclic-persistence argument is needed. The unused horizontal Novikov variable is correctly retained as a spectator.

Point-center surface factorization proves the ruled-surface reduction before fourfold invariance is invoked. I found no circular use of the desired fourfold statement in the surface-vanishing proof.

### Endpoint Hodge recovery and descent

A common reductive rational Hodge quotient makes the representation groups at different varieties comparable. On the fixed base an equivariant separated projector acts on each multiplicity space by an idempotent, whose rank is constant on the formal germ. Endpoint continuation consequently retains representation multiplicities, not merely total odd dimensions.

The unique repeated factor contains all endpoint odd cohomology, because every complementary even-rank-one factor has zero odd part. The two projective-line factors each contribute the third-cohomology representation, with Tate shifts invisible to the chosen group. This proves the factor of two without assuming a big mixed-bulk tensor formula.

The last descent step is sound. The representation group of a reductive complex group is torsion-free, allowing cancellation. Complex equivariant isomorphism descends here because equivariant Hom commutes with extension and its determinant polynomial is nonzero at some rational point over the infinite field of rational numbers. This avoids assuming descent of individually scalar-labelled factors. Pure weight three then makes the Hodge-circle character determine the full bidegree. No polarization follows from this argument, as the text correctly states.

## Exposition and organization

The prototype has a sensible sequence: common group, faithful comparison, vanishing, endpoint identification, descent. It explains the central distinction between fixed parameters and full fiber at the right time. The opening theorem and final boundary on polarization are clear.

The main exposition risk is dependence on the phrase “the numerical part supplies.” The assembled paper must visibly supply the rank-three persistence proof and the special projective-line lemma, including their all-even-bulk scope. Those are mathematical dependencies, not optional background. The frozen prototype is reasonable as a section prototype; it is not by itself a standalone proof without those preceding results.

## Major comments

1. Integrate the arbitrary-rank cyclic persistence result, or at least its rank-two and rank-three specializations, before the product continuation. The inspected numerical section only stated rank-two persistence. The missing integration is repairable by the packet's valid power-trace proof; it is not a demonstrated flaw in the proposed argument.
2. Keep the completed-ring and actual-lattice hypotheses adjacent to the fixed-base comparison. Replacing them with generic “base change” language would erase the two genuinely delicate interfaces: divisor-character faithfulness and preservation of the canonical residue.
3. Treat the final assembled manuscript and imported every-member geometric inputs as separate acceptance gates. This report accepts the internal deductions under the stated external interfaces; it does not certify all source statements or every family identification.

## Minor comments

1. Explain once that the leading whole-primary projectors are central idempotents of the even Frobenius algebra, so the rank-one superalgebra argument visibly applies to their full fibers.
2. In the projective-line lemma, explicitly state that the generic Novikov field is fixed before the complete bulk germ is formed. This makes the spectral separation and the transverse formal derivatives easy to interpret.
3. Preserve the sentence distinguishing a continued separated projector from continuation through an eigenvalue collision. It prevents a much stronger and unjustified reading of the endpoint argument.

## Recommendation

Accept the tested mathematical reduction for integration, with the concrete proof-placement clarifications above. I found no demonstrated major mathematical flaw in the frozen scope. For journal submission, my recommendation is revision followed by a read of the assembled paper, rather than unconditional acceptance of a manuscript not yet assembled and not fully covered by this review. The substantive new Hodge deduction is coherent under its explicit imported premises.

## EJ + TT closeout and mystery ledger

The closeout attack asked whether the rank-three continuation hides an assumption of nilpotence. The explicit two-equation trace calculation above settles that concern and provides a short optional explanation for readers who do not want the arbitrary-rank proof. It is a task-owned clarification, not a new research claim.

No genuine new mathematical mystery remains within the internal interfaces tested here. The outstanding gates are documentary and external: correct assembly of the prerequisite lemmas, accurate theorem citations and topology conventions, and the separately owned every-member geometric input audit. No conclusion about those gates is supplied by the absence of an internal counterexample.
