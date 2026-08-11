# Paper V, Packet O: outer-six and marking cold referee

**Verdict: MAJOR**

## Hash

I read the frozen 18-page manuscript
`papers/clebsch-round-trip/golden_companion_reconstruction.pdf` first. Its
SHA-256 is

`c8427d8178e9a2d8534950cff5cd40422ebcb0ddb578e8181bf65137f781d3ba`,

which matches the supplied hash.

Public-source read depth was limited to sources cited by the manuscript for
the outer-six/invariant-theory claims:

- Howard--Millson--Snowden--Vakil [6], the complete public PDF, PDF/printed
  pp. 1--8 (in particular all of §§1.1--1.6 and 2.1--2.4).
- Pinardin--Zhang [8], public arXiv v1, PDF/printed pp. 23--36, exactly §6.2.

No other external source was used as evidence.

## Theorem in my own words

On the fixed five-dimensional quadratic augmentation representation of the
six Sylow-5 subgroups of (A_5), the paper claims that an actual normalized
chordal cubic and an oriented order-six conference package become mutually
recoverable once one of the two chordal lines is selected. The outer
normalizer involution acts linearly on the two-dimensional invariant cubic
pencil, and its difference from the identity sends the selected chordal
generator to the oriented conference generator. Forgetting the selected
line is claimed to leave exactly the free deck involution
(h\mapsto-q_\Pi h), while forgetting all signs and line choices gives a
sharp Klein-four ambiguity. These statements are asserted as equivalences
of metric groupoids, not merely as bijections of isomorphism classes.

## Earliest unsupported implication

The earliest unsupported implication is already in §1, p. 1, first
paragraph: the assertion that the invariant pencil over the paper's base
field (k=\mathbf F_{11}) has exactly two chordal points. The cited
Pinardin--Zhang §6.2 works throughout over (\mathbf C) and writes down two
complex chordal members (see its printed pp. 24--25); it supplies no
good-reduction or special-fibre argument at 11. Proposition 2.1 constructs
one (\mathbf F_{11})-member, and applying (q_\Pi) can construct a second,
but neither that proposition nor Proposition 4.1 excludes additional
chordal points over (\overline{\mathbf F}_{11}).

The smallest unresolved ambiguity is an additional non-fixed pair

\[
   \{L',q_\Pi L'\}
\]

in the characteristic-11 chordal locus. After rescaling a generator on
(L'), its nonzero outer difference would meet the paper's normalization
condition. The fibre over one unselected conference package would then have
at least four selected-line lifts, not the asserted two. Thus this gap reaches
Theorem 1.2(iv), Corollary 4.2's phrase "either chordal line," the paragraph
after Proposition 5.2, and the (C_2/V_4) counts in §5.1.

## Controlling findings

1. **The characteristic-11 chordal locus is not proved exhaustive
   (§1 p. 1; Proposition 4.1 and Corollary 4.2, p. 9; §5.1, p. 11).**
   The complex citation and construction of two special-fibre members do not
   show that the special fibre has exactly two reduced geometric points.
   Exact exhaustiveness is necessary for the claimed unselected (C_2)-fibre,
   not a cosmetic classification detail. This is a major gap, although it
   looks repairable by a finite, manuscript-visible characteristic-11
   calculation.

2. **The groupoids do not have determinate morphism sets (Definition 1.1,
   p. 3; Definition 5.1 and Proposition 5.2, p. 10).** The phrase
   "(G)-equivariant (Q_0)-isometries, switching, and the coordinated
   relabelings explicitly retained" never says whether (G) is fixed
   pointwise or transported through an automorphism. These are different
   categories. For the smallest witness, let (p=\rho(g_0)) be a noncentral
   inner axis relabeling. It preserves (Q_0) and is certainly a coordinated
   relabeling, but

   \[
      p\rho(g)=\rho(g_0gg_0^{-1})p,
   \]

   so it is not a strict (G)-equivariant map. An odd normalizer lift has the
   same problem with the outer automorphism. Consequently the sentence
   "every allowed coordinated relabeling ... induces one such isometry" does
   not prove full faithfulness under the literal definition; if "allowed" is
   instead defined to mean whatever makes the sentence true, the argument is
   circular. Switching is likewise not formulated as a morphism datum on the
   fixed augmentation carrier. Until morphisms are specified, Hom-bijections,
   automorphism groups, and the quotient groupoid are not checkable. This is
   independently major.

3. **The load-bearing scalar (8) is asserted rather than exhibited
   (Proposition 4.1, p. 9).** "Comparing one coefficient" names neither the
   monomial nor the two coefficient values in common coordinates. The exact
   scalar enters Definition 1.1, Theorem 1.2(ii), Corollary 4.2, and the
   reverse source maps in §6. This is likely a short local repair, but in the
   present text it is not an auditable paper proof once computational outputs
   are removed.

## Deletion test

Delete §11's checker, JSON, and every computational output. The following
parts of §§4--6 still have paper proofs: 

- 
  \(\dim \operatorname{Sym}^3(A_0^*)^G=2\);
- independence of (q_\Pi) from the scalar of an intertwiner and from a
  change of odd representative by (G), on invariant cubics;
- scalar rigidity from (\lambda^2=\lambda^3=1\);
- the formal identity
  ((q_\Pi-1)(-q_\Pi h)=(q_\Pi-1)h).

The deletion does not leave a proof that the geometric chordal locus in
characteristic 11 consists of one (q_\Pi)-pair, nor does it repair the
undefined morphism category. It also leaves the coefficient (8) as an
undisplayed comparison. Therefore the selected-line object-level inverse is
plausible conditionally, but the stated equivalence of groupoids and exact
unselected fibres do not survive the deletion test as proved results.

## Attribution / novelty

HMSV [6] supports the exceptional (S_6) permutation dictionaries, the
color swap under odd permutations, and the relevant five-dimensional outer
representations. It does not supply this paper's literal
(\mathbf F_{11})-linear operator, metric rigidification, coefficient (8),
or groupoid fibre calculation. Pinardin--Zhang [8, §6.2] supplies the complex
invariant cubic pencil and its two displayed complex chordal cubics, but not
the required characteristic-11 exhaustiveness.

Subject to those qualifications, the novelty boundary is accurately stated:
the marked compatibility, normalization, exact information loss, and
source-return packaging are not passed off as results of the cited papers.
I found a proof/categorical-definition defect, not a priority defect.

## Minimal repair

First, compute the chordal-member subscheme of
\(\mathbf P(\Pi_{\overline{\mathbf F}_{11}})\) in the manuscript and prove
that it is exactly two reduced points exchanged by (q_\Pi). A short
saturated-Jacobian/elimination certificate is enough, provided the equations
and conclusion are printed rather than delegated to the checker.

Second, replace the morphism clause by an explicit definition. For example,
a morphism can be a pair ((\sigma,F)), with
\(\sigma\in\operatorname{Aut}(G)) induced by an allowed element of the
six-set normalizer and

\[
   F\rho(g)=\rho'(\sigma(g))F,

\]

together with a separately defined switching gauge and precise preservation
of actual generators. Then define (u) and (q) as functors on that
groupoid, state which action-groupoid quotient
\(\mathcal C_{\mathrm{ch}}/\langle uq\rangle\) means, and recompute Hom sets
and isotropy. Finally, print the single coefficient comparison yielding
(8). After these changes, all of Theorem 1.2, Proposition 5.2, §5.1, and
the source-return claims in §6 must be re-read; the object-level construction
need not otherwise be replaced.
