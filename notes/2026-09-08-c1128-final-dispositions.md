# C1128: final audit and inclusion recommendations

Date: 2026-09-08. Lane: `cubic-threefolds`.

## Decision-ready result

The audit supports the comparison/rigidity repairs, a stronger canonical-lattice
count, a unified calculation covering degrees one through three, and concise
torus/descent explanations. These form a coherent upgrade to the two existing
papers. The additional arithmetic and structural deductions pass but should
remain subordinate. Putting the full proposed collection into the manuscripts
would dilute their main arguments.

The explicit three-dimensional cubic family also survives the mathematical
audit, with the corrections recorded in the family report. Its genus-two
3-torsion construction has a predecessor. Intrinsic recovery of the markings,
the relation to the actual period curve, degrees of the moduli maps, and
novelty of the cubic locus remain gates for a separate follow-on project.
The audit does not license a claim that a novel follow-on paper is complete.

C1128's bounded audit and recommendation deliverable is complete: every
proposal below is accepted under named inputs, corrected, already covered,
or deferred behind an explicit gate. This closes the audit task, not the
mathematical questions it identifies. **No manuscript inclusion decision has
been taken.** That decision remains with the author, as explicitly requested.

## Evidence map

| Report | What was established within its stated boundary |
|---|---|
| `2026-09-08-c1128-comparison-rigidity-audit.md` | Reduced-source comparison, regular lattices, persistence, residue conjugacy and low-dimensional vanishing; local identities and negative controls. |
| `2026-09-08-c1128-proposed-proof-presentation.md` | Concrete first-reading and proof-hypothesis repairs ready for author review. |
| `2026-09-08-c1128-fano-audit.md` | Rational universal calculation, independent recurrences/Fraction check, primary quantum normalizations and classical classification inputs. |
| `2026-09-08-c1128-torus-audit.md` | Character lattices, orbit correction, residual torus and Popov attribution; independent finite checks and C958 overlap. |
| `2026-09-08-c1128-family-audit.md` | Family geometry/Galois action, exact and independent modular checks, moduli dimensions, specialization, torsion prior art and distinct period curve. |
| `2026-09-08-c1128-structural-audit.md` | Rational coefficient spectrum, architecture ceiling, bounds, diagonal torsion, spreading, Cai normalization and algorithmic-source identification. |

These reports record primary-source passages and versions. **Zero external
papers were read cover to cover in this audit**; the reads were targeted,
partial source audits. Both supplied Python checkers were replayed, and the
finite results have independent checks with recorded boundaries. No full
repository verification suite, Lean kernel, independent specialist review or
external-review certification was performed by C1128. Earlier repository
verification remains earlier evidence and is not a new result of this task.

## Editorial A–H: disposition and implementation priority

| Request | Disposition | Recommendation |
|---|---|---|
| A. Intrinsic scalar outline before abstract apparatus | Accept. The operation formulas already exist later. | Priority 1, Paper 1: lead with values 1, 2, 0 and the surface-center argument; relocate rather than duplicate the monoid/diagrams. |
| B. Faithful-center hypothesis table and toy model | Accept with the graded-completion repair. An ordinary C[z] tensor-extension description is too literal. | Priority 1: name source, common target, maps, derivations, ramification, inverse regularity and allowed scalar shifts together. |
| C. Separate persistence from residue conjugacy | Accept with explicit separated formal-germ and nonzero cyclic hypotheses. | Priority 1: prove persistence before choosing the persistent nilpotent frame; then state regularity and the Lax equation. |
| D. Rational universal block calculation | Accept; all three quantum normalizations checked. | Priority 2: replace the main radical calculation; keep its independent check in an appendix/certificate. |
| E. Distinct residue values versus distinct exponent classes | Accept; genuinely different tests. | Priority 2: share eligibility and transport proofs, name I_exp and I_lat separately, and state the lattice commitment visibly. |
| F. Intrinsic selected torus and three-ratio correction | Accept with character-basis and splitting-field conventions. | Priority 1, Paper 2: explain the simplex, display the correction and descend the corrected point by uniqueness. |
| G. Three stages of tangent-section proof | Accept as clarification of existing geometry. | Priority 1: geometric coverage for every smooth parameter, intersection with the relative isomorphism locus, then density/descent. Move the dimension identity once. |
| H. Effective existence versus executable maps; residual_actions | Accept and deduplicate. The matrices are computed but not returned by the existing generator. | Priority 1 supporting material: retain them in the certificate with basis convention; identify remaining map inputs. C958 keeps ownership of complete number-field maps. |

The sharpness certificate's complete smooth-locus coverage is an existing
claim supported by the repository and supplied review. C1128 inspected its
geometric role and related lattice data; it did not newly replay all eight
localized ideals or all four printed minors. The requested presentation edit
must preserve that scope instead of calling a geometric witness a k-point.

## Extension dispositions

| Proposal | Mathematical disposition | Recommended destination / gate |
|---|---|---|
| Count all eligible nonzero canonical discriminants; stronger spectrum | Supported by audited regular-lattice comparisons, persistence and surface vanishing. No nonresonance is needed there. The historical cubic-fourfold fragment was not a whole-primary counterexample. | Paper 1, after the comparison statement is made explicit. Retain specialist scrutiny of those geometric inputs. |
| Universal matrix and first-jet Sylvester recipe | Accepted with stated diagonal-gauge normalization and derivative term accounted for. | Replace the cubic-only derivation; certificate supplies independent checks. |
| Degree-one obstruction | Accepted from the audited quantum matrix and I_exp. | Compact Fano table and application in Paper 1. |
| Quartic-double-solid obstruction | Accepted under I_lat's audited geometric inputs; resonant discriminant 1 cannot be promoted using exponent classes alone. | Same application; the comparison/lattice theorem remains its decisive review target. |
| Complete Picard-rank-one index-two classification after one stabilization | Accepted over C using the degree 1–3 obstructions and classical rationality for degrees 4–5. | Main payoff of the Fano upgrade. Do not assert that every degree-4/5 form over an arbitrary field is rational. |
| Characteristic-zero forms of the negative results | Accepted by finitely generated descent of a hypothetical rationalization and inverse. | Brief corollary; does not require the entire ground field to embed in C. |
| Cross-degree nonbirationality after P1; same exponents but different discriminants | Accepted using the stronger spectrum; degree 1 versus 3 explains the extra information. | One example/corollary beside the Fano table. |
| Polynomial spectrum in Q[T], operation identities and algebraic-degree bound | Accepted after explicitly constructing the rational coefficient model and proving constants/descent. | Optional short arithmetic proposition or appendix; not needed for the main obstruction. |
| Acting torus as Res_(E4/k) Gm/Gm; finite-index isogeny | Accepted from the augmentation character lattice. Rationality of the torus alone does not prove rationality of its quotient. | Explain the existing slice criterion, not a separate torus treatise. |
| Residual cubic norm-one torus and exact sequence | Accepted. The algebras share a quadratic quotient for full I3; the residual cubic is not the ordinary quartic resolvent. | Brief structural interpretation and certificate matrices. Reuse C958 coordinates. |
| SL3 Cayley construction as a ground-field chart | Conditional: the cited displayed construction uses roots of unity; descent cannot be assumed. | C958 retains the actual ground-field chart and complete-map gate. |
| Exact linearization thresholds, rank-one restrictions, finite-subgroup rational quotients, general rank-r principle | Accepted as rational-action field-theoretic deductions from exact stabilization levels, with Popov attribution. Existence of nonlinearizable rank-two actions was already known. | At most one compact corollary/remark in Paper 2; detailed generalization in supporting notes. No regular polynomial-action claim. |
| Additive-method ceiling | Accepted; blowup formula alone suffices. | Short remark/proposition replacing redundant dimension-five discussion. |
| Stably rational residual-factor bound | Accepted for finite certified levels and geometrically integral factors. | General-method note / C963–C966 continuation, not needed for the current surface theorem. |
| Finite-index slices bound diagonal torsion | Accepted as localization of the existing universal A0 bound; torsion order divides the gcd, not necessarily equals it. | One paragraph after the zero-cycle corollary, with attribution. |
| Product/power stabilization bound | Accepted. Powers cannot increase finite stabilization depth by this construction. | Research roadmap note; not another manuscript subsection. |
| Almost-all-prime spreading of fixed upper bounds | Accepted existentially for rationalizations over Q; no explicit excluded-prime set without the maps. | Defer arithmetic implementation to C958; do not spread the lower bound or exactness. |
| Certified symmetry-reduction component | Plausible program; the Duff et al. primary source confirms related scaling/SNF methods. No performance advantage established. | Existing C963/C965/C966 scope, after C958 maps; no commercial pitch in either paper. |
| Exact quantum-residue library and Fano survey | Finite-jet recipe is supported; full certified connection input and generic eligibility remain necessary. Quantum periods alone are insufficient input. | Separate research-infrastructure proposal, requiring scope/allocation before implementation. |

## Family and higher-ceiling proposals

| Proposal | Disposition and precise gate |
|---|---|
| Every smooth X_B has exact level two, over all characteristic-zero extensions | Accepted using both manuscripts. Corrections: work with the point blowup when discussing five conic fibers, verify the point is off lines, and use component charts valid even when rho=a. |
| Three-dimensional unirational cubic locus and dominant generically finite genus-two map | Accepted via independent smoothness/rank certificates and the group-action interpretation. No moduli-map degree or birationality computed. |
| Smooth points in the locus closure have exact level two | Accepted using the geometric generic rationalization and the cited specialization theorem. Density of individually rational closed fibers alone is insufficient. |
| Rational nonzero genus-two 3-torsion and finite correspondence | Mathematics accepted on the smooth sextic open. The square-plus-cube construction is already in Bruin–Flynn–Testa. A single torsion class does not supply their full (3,3)-isogeny data. |
| Intrinsic genus-two/level-structure recovery and period description | Open gate. The marked elliptic projection explains C_B, but the involution literature gives a different explicit genus-two period curve. Their relationship, marking recovery and finite ambiguities are unproved. |
| Three-dimensional collection of nonconjugate tori and common stabilization | Accepted over C via the family, invariant fields and the cited cubic birational-Torelli consequence. Parameter duplication remains possible; these are rational actions. |
| A new separate moduli paper | Deferred: accepted family mathematics is insufficient to assert novelty of the cubic locus or an intrinsic correspondence. No global novelty/forward-citation closure was performed. |
| Cubic finite levels always two, or an example of level at least three | Open research question; neither conclusion was proved. Additive ceiling and product bound constrain methods only. |
| Universally CH0-trivial but stably irrational cubic | Open target; no example or new stable-irrationality proof here. |
| Explicit weak factorization and spectral carrier centers | Deferred construction gate: complete a rationalization, then extract and audit its factorization. Numerical spectral balance does not identify geometric centers. |

The family report already performed the bounded adjacent extraction required
after identifying the 3-torsion predecessor. It verified marked-projection
and conic-cover identities and retained the unproved intrinsic relationship
as a gate. This closeout does not launch another search or allocate a paper.

## Publication case and accessibility

Recommend the coordinated two-paper structure. Paper 1's central question is
the obstruction to one stabilization, with the full index-two application
as its compact new payoff. Paper 2's central result remains the constructive
surface theorem and exact cubic sharpness; the torus interpretation explains
how its existing construction works.

Do not add every accepted deduction merely because it is short. The arithmetic
spectrum, torsion-order wording and action corollary should each earn a place
by clarifying the main result. Move technical detail to appendices or notes;
replace duplicated formal apparatus before adding material. The family/moduli
package belongs outside both current proof routes.

The supplied percentile bands and venue recommendations remain editorial
opinions. This audit strengthens the mathematical basis for the Fano upgrade;
it does not establish acceptance probabilities, exhaustive novelty, or a
publication decision. No fresh venue ranking is needed to choose the next
proof/presentation work. Publication-scope details are updated in
`2026-09-08-c1128-publication-scope.md`.

## Final ej+tt and Mystery ledger

The final pass asked what would most improve the result without increasing
its surface area. **ej:** the rational polynomial can encode the same spectrum
losslessly and its virtual extension uses ratios of monic polynomials.
**tt:** the real review commitments are the generic coefficient/lattice
comparison and uniform descended tangent-open geometry; additional numerical
checks or corollaries cannot replace them. This confirms repairs first,
unified Fano application second, and restrained supporting consequences.

| Unexplained or delicate feature | Exact disposition / owner |
|---|---|
| Resonance retains a nonzero obstruction | Algebraic transport and low-dimensional arguments pass; specialist review of the imported geometric comparison remains the proof-confidence boundary. |
| Complete family mathematics without intrinsic moduli interpretation | Marked geometry is explicit; recovery from an unmarked cubic, period-curve relationship and novelty remain a separately scoped follow-on gate. |
| Existence of a rationalization without executable maps | Not a proof gap in effective existence; C958 owns completion of forward/inverse ground-field maps and open conditions. |
| Higher finite stabilization levels | Unresolved; neither products nor the current global additive architecture supply them. No successor allocated by this audit. |
| Journal and commercial value | No acceptance/performance evidence established. Keep both outside theorem validation and manuscript expansion decisions. |

All planned findings belong in the task reports; the final discovery-track
review found no additional incidental observation requiring an entry. Existing
lane discovery-track ownership and the C958/C963/C965/C966 assignments remain
unchanged. C978/C956 remain open by author instruction. C1128 ends with this
concrete reviewable recommendation; implementation still requires the author's
post-audit inclusion decision. No push, email or other external action occurred.
