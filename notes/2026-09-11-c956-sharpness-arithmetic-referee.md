# C956 — arithmetic referee report on the sharpness upgrade packet

Date: 2026-09-11. Lane: `cubic-threefolds`.

## Summary and contribution

**External sources read at full text: zero.** The source register below records
eight directly consulted works at partial depth, plus one historical source
known only through a consulted secondary source. This is an independent,
focused mathematical review of Parts VI–VIII and Appendix B, with the main
statements and reference roles read for context. It is not a referee report on
the unreviewed surface construction or the companion quantum theorems.

The submitted file is
`/home/tavis/Downloads/sharpness_upgrade_proof_packet.md`, prepared 9 September
2026, SHA-256
`1a94740f634a6ef4495fa8d1b02ee09c36855698615c10c19576de25f55f8820`.
The file is a proof/integration specification, not the final manuscript.

The arithmetic contribution is an explicit five-elliptic-factor isogeny
description whose potential toric ranks distinguish a positive-density
integral family, and then recover a selected quadratic-size set of rational
parameters. The applications to one-stabilization and rational torus actions
correctly identify their additional companion-paper dependencies. I found no
counterexample or major mathematical defect in these arithmetic deductions.
The optional unit-equation parametrization needs a small domain correction.

## Significance and scope

The rank profile is the useful arithmetic invariant here: it survives geometric
isogeny and avoids unnecessary comparison of arithmetic Frobenius polynomials.
It yields explicit negative certificates, and the squarefree restrictions
convert support data into injectivity without an isogeny-classification
theorem. These are substantial, concrete applications of the displayed
factorization.

The exact rational-action threshold is a direct invariant-field deduction from
an exact stabilization level. The packet appropriately credits the pre-existing
linearization mechanism in Popov [S3]. Its useful additional content here is
the sharp threshold and the arithmetically separated family defined over the
rationals. This review does not establish a priority verdict for either that
refinement or the arithmetic family; no forward-citation closure was attempted.

## Correctness

### 1. Smoothness, the component cover, and the S3 representation

The proof in §27 correctly separates the invertible, rank-one, and rank-zero
cases for the quadratic matrix. At a rank-one singular point, the condition
on the derivatives is precisely the failure of transversality between the
plane cubic and the determinant conic. At rank zero the three displayed
derivatives have no common projective zero in characteristic different from
two and three. The stated Weierstrass substitution is consistent with the
plane equation. The excluded parameters also give singular points on the
fixed plane. Thus the smooth-locus criterion has a written proof rather than
depending on sampled singularity checks.

For the triple cover, write its monic polynomial as

\[
z^3-\frac34(x^2+3y^2)z-ty^3.
\]

If one root is z, the discriminant of the residual quadratic is
\(3(x^2+3y^2-z^2)\). This equals the splitting class of the binary quadratic
form on the cubic component. It establishes the required identity of double
covers, not just equality of genera. The degree-three map is connected, and
simple branch monodromy consists of transpositions; its transitive group is
therefore S3. The six simple branch points give genus four for the Galois
closure and genus two for its A3 quotient. The quotient construction in
CMZ [S1, Proposition 2.8 and Theorem 2.9] matches the packet's use.

There is no representation-theoretic loss of an elliptic factor: the invariant
part has dimension zero, the sign part has dimension two, and the standard
part has dimension two. A transposition has a one-dimensional invariant
subspace in the standard representation, giving the elliptic multiplicity
space. Quotienting by the pullback of the elliptic quotient leaves one elliptic
factor and the genus-two sign part. This justifies (P6) up to geometric isogeny.

### 2. Twists and elliptic quotients

The discriminant of the monic cubic is square-equivalent to
\(-3[16t^2y^6-(x^2+3y^2)^3]\). On the conic the quadratic expression is
\(6(su+rv)^2\), and its component equation requires the class
\(-H_t/24\), hence the twist \(-6\). Both signs in (P7) are consistent.
The passage back to untwisted curves is permissible for geometric isogeny
and potential reduction; it is not an arithmetic trace identity over Q.

The two quotient maps for each genus-two curve give independent differential
pullbacks. For the reciprocal sextic, direct substitution gives
\(V_\pm^2=(U\pm2)(U^3-8s)\). The five displayed j-invariants and the
sum/product relations are internally consistent. The exceptional values
needed to keep the quotient curves smooth are already excluded by (P2).
No product principal polarization is asserted or needed.

### 3. Potential toric rank and separated integral parameters

For p at least five, all numerical constants in the two rational
j-invariants and the quadratic relation are p-adic units. If v(c) is
negative, the quadratic has root valuations v(c) and zero. If c is integral,
both roots are integral. Thus exactly two of the four nonconstant elliptic
factors are potentially multiplicative when v(c) is negative, before counting
E1. The criterion for potentially good elliptic reduction is verified in the
partial primary exposition [S8].

For reduced a/b, primes dividing a, b, or \(D=16a^2-27b^2\) cannot overlap
outside two and three. This proves the cases 1, 0, and 3 in (A1), respectively.
The geometric-isogeny argument is valid: an isogeny of these complex abelian
varieties is defined over a finite extension of Q, and can then be considered
at a place over p. On semistable Néron models, an isogeny and a quasi-inverse
induce maps of the torus parts whose composites are multiplication by a
nonzero integer, forcing equal torus dimensions. Finite extension of a
semistable model preserves that dimension. The final paper should supply a
precise standard reference for the semistable-model assertions in place of
the packet's generic [Reduction] placeholder.

Distinct positive squarefree integers prime to six have a distinguishing
prime at least five; the opposing rank can be zero or three, and neither
equals one. The separation proof therefore works even when the distinguishing
prime divides the other member's discriminant. The density \(3/\pi^2\) is
also correct. The optional recursive sequence uses less of the elliptic
decomposition; its good-reduction premise is covered by Achter [S2,
Theorem 3.4] over the relevant local base.

### 4. Squarefree rational parameters and coefficient height

The selected congruences make a and D prime to six. Squarefreeness of aD
forces coprimality of a and b, so the support reconstruction in (A3) really
recovers the reduced parameter. Positivity of a, b, and D removes all sign
ambiguities. Without these conditions the rank profile would not be
injective; the packet does not make that stronger claim.

For p at least five, the reduction of F has one or three distinct projective
zeros according to the quadratic character of three. The origin contributes
\(p^2\) lifts modulo \(p^2\); each nonzero point on the reduced zero locus
is smooth and has p lifts. Hence the local count
\(p^2+\ell_p p(p-1)\) is correct. The sector has area \(1/8\), and the
congruence sublattice has index twelve, giving the stated prefactor \(1/96\).

Xiao [S4, Theorem 1.1] applies with total degree three and maximum irreducible
factor degree two. Its hypotheses include nonzero discriminant and no fixed
square divisor; both hold. The sector/congruence adaptation can be supplied
without importing an additional tail estimate. Fix R at least three. In the
enclosing square, the count avoiding all prime squares for p at most R is
\(C_R H^2+O_R(H)\) by residue-class counting. The full squarefree count is
\(C H^2+o(H^2)\) by the cited theorem. Subtraction bounds all points surviving
these small primes but failing squarefreeness by
\((C_R-C)H^2+o_R(H^2)\). The same upper bound applies to any subset, including
the required sector and congruence classes. In that subset, finite-prime
counting gives the sector area times the congruence density times the partial
Euler product. First let H tend to infinity with R fixed, then let R grow;
\(C_R-C\) tends to zero. This proves exactly (A4). Positivity follows from
the local factors and convergence. The parent supplied this particularly
short proof during the final source discussion; I independently checked its
set subtraction and limits. It is a deduction from the square theorem, not a
verbatim sector theorem in Xiao. Integrate it as the promised short lemma.

Multiplying the cubic by 4b gives displayed integral coefficients of size
O(H), and reconstruction prevents repeated reduced parameters. The asserted
height conclusion is therefore correct in precisely the coefficient convention
used. It gives no height bound on a conjugating rational map.

### 5. Actions, finite subgroups, and the unit equation

For a rank-r subtorus of the coordinate scaling torus, saturation gives a
unimodular monomial change of variables; its invariant field adds s-r
variables to k(V). Adding m invariant variables permits linearization only
if m+s-r is at least s. At m=r, rationalization of the invariant field gives
an actual diagonal action. Thus the threshold r is correct, including the
rank-one and full rank-two cases. Over C a finite subgroup fixes a full-rank
monomial lattice, whose invariant field is again a purely transcendental
two-variable extension of k(V). This establishes the stated rationality of
the finite quotient. No regular affine action is implied.

For B.2, the valuations show that x and y are units outside the designated
places exactly as claimed. Conversely, the conjugacy constraint makes
x-y anti-invariant under the quadratic automorphism, so the recovered u is
rational when x differs from y. The group of conjugate pairs has rank
\(1+|S_L|\), not twice that rank. The bound
\(2^{8(|S_L|+2)}\) follows from the primary author version of the
unit-equation theorem [S6, Theorem 1.1]. The effectiveness assertion is
documented at survey depth in [S7]; this review has not audited an original
effective-height proof or implemented a complete solver.

## Exposition and organization

The arithmetic narrative is well ordered: factorization, reduction invariant,
simple integral family, then optional counting and candidate-set refinements.
Keeping the recursive construction in the appendix is sensible. The distinctions
between geometric and arithmetic isogenies, upper bounds and exactness, and
necessary tests and affirmative birationality are all essential and well stated.

The final manuscript should replace proof-specification instructions such as
"retain the correction" with ordinary mathematical prose. It should define
\(f_2:W\to E_t\) before the first pullback notation in §28 and explicitly
state that dimensions of the isotypic pieces are abelian-variety dimensions.

## Major comments

1. **No major defect found within the assigned arithmetic scope.** This finding
   does not validate the upper rationalization theorem, the three-dimensional
   moduli-image claim, or the companion lower-bound and Hodge-conservation
   inputs. Statements using them remain at their own review boundaries.
2. **Complete the source interface.** Integrate the now-verified
   sector/congruence lemma above and identify a precise semistable-reduction
   reference. These are reviewable additions with no required weakening of a
   headline. An older companion publication or DOI must not be used as support
   for a later Hodge-conservation theorem unless that theorem is actually in
   the cited version; this referee has not independently reviewed its proof.

## Minor comments and exact repairs

1. **B.2 has an extraneous solution.** Since two belongs to S, the pair
   \(x=y=1/2\) satisfies every displayed condition in (B1). It has no finite
   parameter u; it corresponds to the omitted point at infinity. Add
   \(x\ne y\) to (B1), or say its solution set minus this pair parametrizes
   the rational parameters. The finite upper bound and every headline survive.
2. **Say "finite set S of rational primes."** Finiteness is not stated in the
   defining sentence. An arbitrary infinite S makes the candidate-set claim
   false. The intended finite set is available from the displayed formula,
   so this repairs the statement without changing its application.
3. Define the map \(f_2\), and pin the cited source versions and actual theorem
   numbers when integrating. The source wording in §51 is not a final reference
   apparatus.

## Reasoned editorial recommendation

**Accept the reviewed arithmetic arguments after minor mathematical and
expository revision, conditional on the independently reviewed inputs named
above.** There is no arithmetic reason here to weaken the positive-density
family, the quadratic coefficient-height count, or the exact rational-action
threshold. The two literal unit-equation corrections are confined to an optional
appendix. Whole-paper acceptance would require the parent review's surface,
companion-input, and computational-replay gates; this report cannot replace them.

## Source register and actual read depth

The eight directly consulted works below are all **partial** reads. Cached PDFs
were accessed through their text extractions. None was a user-supplied scan set.
The hashes identify fetched bytes and do not assert full reading. Bibliographic
versions are not silently promoted to a published version. No citation-graph
search, MathSciNet coverage, or exhaustive literature search is claimed.

| ID | Source, depth, version, and exact reading boundary | Access and cache identity |
|---|---|---|
| S1 | Casalaina-Martin–Marquand–Zhang, *The moduli space of cubic threefolds with a non-Eckardt type involution via intermediate Jacobians*. **Partial**: Proposition 2.7; §2.3 quotient-polarization discussion; Proposition 2.8 and proof; Theorem 2.9 and proof. arXiv v2. | `arXiv:2210.14397`; https://arxiv.org/pdf/2210.14397v2 ; SHA-256 `6a8ce41af47def059a90f987f65cdda22c9540357d23ba80bdccc2dc8b351874`. |
| S2 | Achter, *Arithmetic Torelli maps for cubic surfaces and threefolds*. **Partial**: Remark 3.3, §3.3 Theorem 3.4 and proof, Corollary 3.5. arXiv v4. | `arXiv:1005.2131`; https://arxiv.org/pdf/1005.2131v4 ; SHA-256 `68d98147d7d06de410a7dfd29c95efb0653554231f9e1b507591751d8e71fe64`. |
| S3 | Popov, *Some subgroups of the Cremona groups*. **Partial**: Corollary 3, Theorem 4 and proof, Lemma 5 and proof, Corollary 4 and adjacent Theorem 5 statement. arXiv v4. | `arXiv:1110.2410`; https://arxiv.org/pdf/1110.2410v4 ; SHA-256 `0d08a8504457aa1c9292b6174639d6b1516cb3351f75ae5c0b372226ef223ff1`. |
| S4 | Xiao, *Power-free values of binary forms and the global determinant method*. **Partial**: introduction through Theorem 1.1 and its discussion; §7; opening of §8 through the bound on the prime range. arXiv v2. The degree-two case is explicitly credited there to earlier work. | `arXiv:1505.05587`; https://arxiv.org/pdf/1505.05587v2 ; SHA-256 `5fc1b0b9cc2f13a336e9f36064c803d12be9ae7f24df6639364295517e14ce63`. |
| S5 | Koymans–Pagano, *On the equation x+y=1 in finitely generated groups in positive characteristic*. **Partial**: §1 introduction, plus the opening definitions in §2. arXiv v4. The characteristic-zero bound is discussed there as an earlier result, not their new positive-characteristic theorem. Superseded as support for the constant by direct S6 consultation. | `arXiv:1610.08377`; https://arxiv.org/pdf/1610.08377v4 ; SHA-256 `7900c320c7e62a66d23b8fc0603f69c393a2212bbcecf4a9a6da9b7e76e10001`. |
| S6 | Beukers–Schlickewei, *The equation x+y=1 in finitely generated groups*. **Partial**: §1 through Theorem 1.1 and its following bound comparison. Author PDF dated 8 January 2007; not asserted byte-identical to the published 1996 paper. DOI identity checked against Crossref. | `10.4064/aa-78-2-189-199`; https://webspace.science.uu.nl/~beuke106/s-units.pdf ; SHA-256 `a79c55b8ac1979ab53966277b35a80c81dad1507297b434dbd341da385ada092`. |
| S7 | Evertse–Győry–Stewart, *Mahler's work on Diophantine equations and subsequent developments*. **Partial**: all of §5. arXiv v1. It is a survey; the original effective number-field unit bounds it describes were not independently read. | `arXiv:1806.00355`; https://arxiv.org/pdf/1806.00355v1 ; SHA-256 `e78f232b877d090eb263381eb43224916f027423631717da5c7b2d227576e319`. |
| S8 | Andrew Snowden, *Lecture 8: Elliptic curves over DVRs*, Math 679 course notes, 2013 course version accessed 2026-09-11. **Partial**: reduction definitions and behavior under extensions, through the potentially-good/j-integrality criterion and its example (web lines 9–56). | https://websites.umich.edu/~asnowden/teaching/2013/679/L08.html ; read through browser HTML. Direct byte download returned HTTP 403, so no disk-cache key or hash. |
| S9 | Greaves, *Power-free values of binary forms*. **Secondary only**: the 1992 result as stated and used in S4, introduction and §7. Original paper not opened; no original-version verdict. | The chain is S4, whose partial depth and byte identity are recorded above. No original cache key/hash consulted. |

The bounded web queries were `"1505.05587" "Theorem 1.1"`,
`"2210.14397" "Theorem 2.9"`,
`Beukers Schlickewei "equation x+y=1" pdf 1996`, and
`semistable abelian varieties toric rank isogeny invariant potential good elliptic j integral lecture notes`.
Search snippets were discovery aids, not proof substitutes. The first attempted
unit-equation portal returned HTTP 403; the author's PDF supplied the needed
theorem instead. No negative prior-art conclusion follows from these searches.

## Verification boundary and process note

This referee checked the displayed arguments and algebra by hand. It did not
run the embedded checker, modify a manuscript, run Lean, or assess a claimed
finite computational search. Full checker replay belongs to the parent review.
Existing cache PDF hashes were rechecked, and newly fetched PDFs were ingested
through the cache integrity checker.

The initial live-handoff command returned 19,898 original tokens and was
truncated. This was a command-shaping failure; the output was discarded as a
reading basis and replaced by explicit bounded section reads. One aggregate
tool response containing several bounded chunks also truncated; its affected
chunk was reread separately. No mathematical conclusion rests on omitted text.

## Mystery ledger — explicit ej + tt closeout

After the arithmetic acceptance check, the closeout pass asked whether an
unnecessary hypothesis concealed a cheaper proof or a stronger conclusion.
It settled the apparent mismatch between geometric twists and local arithmetic:
the invariant is potential toric rank, so all finite twisting disappears before
the comparison. It also settled why the profile takes values one and three:
the reciprocal pair contributes exactly one pole whenever E2 contributes one.
Neither point requires generic independence of the five elliptic factors.

No unresolved arithmetic mystery was found in the assigned claims. The exact
remaining gates are external: the surface/companion inputs and parent checker
replay, the final precise semistable citation, and integration of the proved
sector-sieve lemma. The closeout source discussion settled the latter proof:
subtracting the full squarefree asymptotic from the finite-prime square count
provides the needed tail without another theorem.
Optional B.3 still requires the separately proposed very-general pencil rigidity
theorem; this review makes no assertion about it. There is no reason to promote
that optional rigidity gate into a dependency of the arithmetic headlines.
