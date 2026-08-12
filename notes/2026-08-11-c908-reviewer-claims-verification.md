# C908 external-reviewer literature claims: verification

Date: 2026-08-11. Auditor: research sub-agent (read-only except this file).
Deliverable: verdicts on two load-bearing literature claims made by an external (likely
machine-generated) reviewer of the cubic-stabilization epilogue paper. One verdict is an
absence claim (Claim 2), so `notes/literature-audit-conventions.md` binds.

## Opening summary

**Both claims check out.** Claim 1 is Voisin's Theorem 1.7, correct as an equivalence, with
one wrong word ("primitive" for "minimal"). Claim 2 names a real author, Moritz Hartlieb,
whose Math. Z. paper does classify the positive-dimensional PEL-type special families his
automorphism criterion detects, and the alternating-group Alt(5) family is one of exactly two
exceptional cases. The reviewer's real failing is an omission: they did not mention that
Engel–de Gaay Fortman–Schreieder settled the algebraicity of the minimal class **negatively**
for very general cubic threefolds in 2025, which flips Voisin's equivalence from an open
problem into a proved obstruction and re-scopes any PEL-family sweep.

**Read depths.** Sources named in this report: 15. Read at **full text**: 1 (Voisin
arXiv:1407.7261v2). Read at **partial**: 2 (Hartlieb arXiv:2304.03214v2 — abstract, §0, §2,
§5.3, §6 opening; Engel–de Gaay Fortman–Schreieder arXiv:2507.15704v3 — abstract and §1
statements only). **Secondary only**: 2 (Wei–Yu; González-Aguilera–Liendo, both via
Hartlieb's bibliography). **Abstract/metadata only**: 6 (Voisin's published JEMS version;
Hartlieb's published Math. Z. version; arXiv:2512.04902; Casalaina-Martin–Marquand–Zhang;
Casalaina-Martin–Zhang; van Geemen–Yamauchi). **Not opened, named for completeness**: 4
(Höring arXiv:0802.0978; Colliot-Thélène arXiv:1607.05673; the survey arXiv:2510.13679; EGS
§§2–8). No verdict here rests on a source read only at review level; no review service was
used. MathSciNet and zbMATH Open were NOT COVERED — see the Coverage statement.

Claims under test, verbatim from the task brief:

1. "for cubic threefolds universal CH_0-triviality is equivalent to algebraicity of the
   primitive class theta^4/4!" — attributed to Voisin.
2. "Hartlieb has classified the relevant positive-dimensional PEL-type special families
   [of cubic threefolds / their intermediate Jacobians] arising from his automorphism
   criterion, including the A_5 family."

---

## Claim 1 — VERIFIED (with one terminology slip)

**Source.** Claire Voisin, *On the universal CH0 group of cubic hypersurfaces*.
arXiv:1407.7261v2 [math.AG], 19 Sep 2015. Cache key `arXiv:1407.7261`,
sha256 `514e5634d920f4b8e9c6797f3de5ad34afea65624ba23cc764d329ebcdd2c4e4`, 29 pp.,
fetched 2026-08-10 from https://arxiv.org/pdf/1407.7261.
**Read depth: full text** (pdftotext extraction of the cached v2 preprint; sections read:
abstract, Introduction Theorems 1.1/1.6/1.7, Section 4 Corollary 4.4 / Theorem 4.5 /
Lemma 4.6). **Version read: arXiv v2 preprint, not the published J. Eur. Math. Soc.
version** — see "Published version" below.

**Exact statement (Theorem 1.7, p. 3):**

> Let X be a smooth cubic threefold. Then X has universally trivial CH0 group if and only
> if the class θ4/4! on J(X) is algebraic. This happens (at least) on a countable union of
> closed subvarieties of codimension ≤ 3 of the moduli space of X.

Restated as Corollary 4.4 (§4, p. 19):

> A smooth cubic threefold admits a Chow-theoretic decomposition of the diagonal (that is,
> its CH0 group is universally trivial) if and only if the class θ4/4! is algebraic on J(X).

Abstract, lines 12–14: "For cubic threefolds X, this turns out to be equivalent to the
algebraicity of the minimal class θ4/4! of the intermediate Jacobian J(X)."

**So the reviewer's Claim 1 is substantively correct.** It is a genuine two-way
equivalence, for every smooth cubic threefold over C, with no extra hypotheses in the
statement of Theorem 1.7.

**The one slip.** Voisin calls θ^4/4! the **minimal class**, never the "primitive class".
"Primitive" is a different notion in this literature (primitive cohomology
H^n(X,Q)_prim, which Voisin also uses in Theorem 1.3 for a distinct purpose). The
reviewer's "primitive class θ^4/4!" is a misnomer for "minimal class"; the object intended
is unambiguous.

**Definitions actually in force.**
- *Universally trivial CH0* (Voisin, following her [4] = Auel–Colliot-Thélène–Parimala
  style definition, as cited in her Introduction): CH0(X_L) = Z for every field L ⊇ C;
  equivalently, for L = C(X), the diagonal point δ_L is rationally equivalent over L to a
  constant point x_L; equivalently a Chow-theoretic decomposition of the diagonal
  ∆_X = X × x + Z in CH_n(X × X) with Z supported on D × X, D ⊊ X a divisor.
- *Minimal class*: θ^{g−1}/(g−1)! ∈ H^{2g−2}(J(X),Z) for J(X) of dimension g; for a cubic
  threefold g = 5, so the class is θ^4/4!. "Algebraic" = the class of a 1-cycle in J(X).

**Role of θ^4/4! algebraicity — both directions, and where each comes from.**
The equivalence is assembled from two of Voisin's other theorems, so the load-bearing
structure matters for any downstream use:

- *Necessity* (universal CH0-triviality ⇒ θ^4/4! algebraic). This is the new content.
  Theorem 1.6 (= Theorem 4.1): a rationally connected threefold X admits a *cohomological*
  decomposition of the diagonal iff (1) H^3(X,Z) is torsion-free, (2) there is a universal
  codimension-2 cycle in X × J(X), and (3) the minimal class θ^{g−1}/(g−1)! on J(X) is
  algebraic. Voisin states explicitly (p. 3, after Thm 1.6): "The main new result in this
  theorem is the fact that condition 3 above is implied by the existence of a cohomological
  decomposition of the diagonal. In particular, it is a necessary condition for stable
  rationality." She frames it as a variant of the Clemens–Griffiths criterion.
- *Sufficiency* (θ^4/4! algebraic ⇒ universal CH0-triviality). Proof of Corollary 4.4:
  cubic threefolds have torsion-free H^3, so condition (1) is free; condition (2) is *not*
  known outright, but Markushevich–Tikhomirov [19 in Voisin] give a parametrization of
  J(X) by a codim-2 cycle on B × X with rationally connected general fibers, and Voisin's
  earlier [29, Theorem 4.1] upgrades such a parametrization plus algebraicity of the
  minimal class to the existence of a universal codimension-2 cycle. Then Theorem 4.1
  gives a cohomological decomposition, and Theorem 1.1 (cubics: cohomological ⇒
  Chow-theoretic decomposition, given H^*(X,Z)/H^*(X,Z)_alg torsion-free) gives the
  Chow-theoretic one.

So θ^4/4! algebraicity is the *only* remaining obstruction for cubic threefolds; the other
two conditions of Theorem 1.6 are discharged (one outright, one conditionally on the same
algebraicity statement).

**Status of the algebraicity problem itself, per Voisin.** p. 3: "In the case of cubic
threefolds, the algebraicity of θ4/4! is a classical completely open problem." More
strongly: "it is not known if examples not satisfying 3 exist. More generally, it is not
known if there exists any principally polarized abelian variety (A,Θ) such that the minimal
class θ^{g−1}/(g−1)! is not algebraic on A, where g = dim A." For Fano threefolds whose
J(X) is a Prym variety, 2·θ^{g−1}/(g−1)! *is* known to be algebraic (Voisin cites [10] =
Beauville-type Prym reference).

**Voisin's own positive locus is an automorphism-defined family — directly relevant to
Claim 2.** Theorem 4.5 + Lemma 4.6 (§4, pp. 20–21): the non-empty countable union of
codimension-≤3 subvarieties of the moduli space of smooth cubic threefolds along which
θ^4/4! is algebraic is produced by the criterion "if (J(X),θ) is isogenous via an
odd-degree isogeny to (J(C), mθ_C) for some possibly reducible curve C, then θ^4/4! is
algebraic" (using that 2·θ^4/4! is algebraic by the Prym structure, and that the isogeny
degree and m are odd). Her explicit example is exactly an **automorphism-defined special
family**: cubics invariant under the order-3 coordinate automorphism
g*: (X0,X1,X2,X3,X4) ↦ (X0, jX1, j²X2, X3, X4), j = exp(2πi/3). The invariant part
H^3(X,Q)^inv has rank 6 (dim H^{2,1}(X)^inv = 3 via Griffiths residues), the lattice splits
up to a 3-power index into H_1 ⊕ H_2 giving ppav's A (dim 3) and B (dim 2) with an isogeny
A ⊕ B → J(X) pulling θ_X back to m(θ_A, θ_B), m a power of 3; A and B are Jacobians of
curves C_A, C_B and A ⊕ B is the Jacobian of C_A ∪_x C_B. Lemma 4.6: each choice of
sublattices H_1, H_2 gives a codim-≤3 subvariety of moduli along which θ^4/4! is algebraic.

(Auditor's inference, marked as mine: Voisin's Theorem 4.5 mechanism is a *different*
mechanism from Hartlieb's, even though both are automorphism-defined. Voisin's is an
isogeny-splitting/Prym-parity argument producing codim-≤3 loci where the minimal class is
algebraic; Hartlieb's is a CM/André–Oort special-subvariety criterion producing dim-1 and
dim-2 loci. They are not the same families and not the same conclusion. See Claim 2.)

**Published version.** Crossref: DOI 10.4171/jems/702, *Journal of the European
Mathematical Society* **19** (2017), no. 6, pp. 1619–1653.
**Read depth of the published version: abstract/metadata only** (Crossref record; a free
author copy exists at
https://webusers.imj-prg.fr/~claire.voisin/Articlesweb/chowcubicjems2017-019-006-01.pdf
but was not fetched). Theorem numbering quoted above is from arXiv v2; downstream work
cites the published version as [Voi17] and attributes the same statement to it (see next
section), so the numbering is very likely stable, but a manuscript citing "Theorem 1.7 of
[Voi17]" should be checked against the JEMS pagination before print.

### The algebraicity problem has since been SETTLED in the negative for very general cubics

This is the material development the reviewer did not mention, and it is more consequential
than either of their two claims.

**Source.** Philip Engel, Olivier de Gaay Fortman, Stefan Schreieder, *Matroids and the
integral Hodge conjecture for abelian varieties*. arXiv:2507.15704, v1 21 Jul 2025, v2
7 Aug 2025, v3 27 Mar 2026, 85 pp., math.AG + math.CO. Preprint; no journal reference as of
2026-08-11. Cache key `arXiv:2507.15704`,
sha256 `f0284c8249c07ab5e3d9e5e49504662fad26de205563ab5a48aea27e742741ee` (already in the
shared cache, fetched 2026-08-10 — an earlier session in this project had it).
**Read depth: partial** (pdftotext extraction of the cached v3; read: abstract and §1.1–1.2
statements Theorem 1.1, Corollary 1.2, Theorem 1.3, Corollary 1.4 and the surrounding
discussion. Proof sections 2–8 not read.)

> **Theorem 1.3.** Let Y ⊂ P⁴_C be a very general cubic hypersurface. Then the homology
> class of any curve C ⊂ JY on its intermediate Jacobian JY is an even multiple of the
> minimal class [Θ_Y]⁴/4! ∈ H₂(JY,Z).
>
> By [Voi17], Theorem 1.3 implies:
>
> **Corollary 1.4.** Very general cubic threefolds Y ⊂ P⁴_C do not admit a decomposition of
> the diagonal. Hence they are neither stably rational, nor retract rational, nor
> A¹-connected.

Companion general statement, Theorem 1.1: for a very general ppav (X,Θ) of dimension g ≥ 4
and any algebraic cycle Z ∈ CH^c(X) with 2 ≤ c ≤ g−1, [Z] = m·[Θ]^c/c! with m **even**;
this disproves the integral Hodge conjecture for abelian varieties. Corollary 1.2 computes
the image of the integral cycle class map exactly for very general ppav's of dimension 4
and 5. Method: tropically motivated, via multivariable Mumford constructions, monodromy,
and a new combinatorial invariant of regular matroids obstructing algebraicity of the
minimal curve class on the very general fiber of a matroidal degeneration.

The paper explicitly recognizes the Voisin equivalence as the bridge ("By [Voi17], Theorem
1.3 implies…") and restates Voisin's positive locus: "the smooth cubic threefolds which
admit a decomposition of the diagonal form a (non-empty) countable union of subvarieties of
their moduli, see [Voi17]."

Follow-up by the same three authors, **abstract/metadata only** (arXiv abstract page,
fetched 2026-08-11): arXiv:2512.04902, *Optimality of the Prym–Tyurin construction for
A₆*, submitted 4 Dec 2025 — "on a very general principally polarized abelian 6-fold, the
smallest multiple of the minimal curve class which can be represented by an algebraic cycle
is 6." Not cached.

**Consequence for the epilogue lane (auditor's inference, marked as mine).** After
Engel–de Gaay Fortman–Schreieder, Voisin's equivalence is no longer an open-ended
"classical completely open problem" as her 2015 text describes it. The generic side is
closed negatively, so the only live question on the CH₀ side is *which* special cubic
threefolds sit in the non-empty countable union where θ⁴/4! **is** algebraic. That is
exactly the terrain of Claim 2, which raises rather than lowers the value of a
special/PEL-family sweep — but changes its meaning from "look for the obstruction" to
"characterize the exceptional locus where the now-proved generic obstruction vanishes."

---

## Claim 2 — VERIFIED, and more accurate than expected; one word ("classified") needs a scope qualifier

**Hartlieb is a real author with exactly the paper described.**

**Source.** Moritz Hartlieb, *Special subvarieties in the locus of intermediate Jacobians of
cubic threefolds*. arXiv:2304.03214, v1 6 Apr 2023, v2 15 May 2023 ("Minor revision;
replaced Remark 5.8"), 28 pp. Published: *Mathematische Zeitschrift* **310** (2025), issue
3, DOI 10.1007/s00209-025-03745-3, published online 9 May 2025. Work is Hartlieb's Master's
thesis at the University of Bonn, advisor Daniel Huybrechts, supported by ERC Synergy Grant
HyperK (854361). Cache key `arXiv:2304.03214`,
sha256 `3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01` (already in the
shared cache, fetched 2026-07-26; I independently re-fetched
https://arxiv.org/pdf/2304.03214v2 on 2026-08-11 and the bytes hash identically).
**Read depth: partial** — pdftotext extraction of the cached **arXiv v2 preprint**, sections
read at full text: abstract, §0.2–0.3 (Theorems 0.2–0.5), §2 (Theorem 2.1, Example 2.2,
Theorem 2.4), §5.3 (Lemmas 5.5, 5.6, Proposition 5.7, Remark 5.8), §6 opening (Theorem 6.1,
Remarks 6.2, 6.3, start of proof). Sections 1, 3, 4 and the character tables read only in
grep excerpt. **The published Math. Z. version was NOT read** (abstract/metadata only, via
OpenAlex and Crossref); theorem numbering below is the preprint's.

### What the paper actually proves

**The criterion ("his automorphism criterion" — real, and it is his).**
For a finite G ⊆ GL(5,C), let M_G be the image in the moduli space M of smooth cubic
threefolds of the G-invariant smooth cubic forms, and J: M → A₅ the (locally closed
embedding) intermediate-Jacobian period map. Then

> **Theorem 0.3 (= Thm. 3.3).** Assume that (⋆⋆) dim M_G = dim (S²H^{2,1}(Y))^G holds for
> some smooth cubic threefold Y ∈ M_G. Then the closure of J(M_G) in A₅ is a special
> subvariety **of PEL-type**.

"PEL-type" is literally the paper's term (Thm. 3.3, line: "then the closure of J(M_G) in A₅
is a special subvariety (of PEL-type)"). The criterion is the cubic-threefold analogue of
Frediani–Ghigi–Penegini [FGP15, Thm. 1.4] for Jacobians of curves.

**The classification.** §6 opens: "It turns out that the examples discussed in the two
previous sections are the only examples of positive-dimensional special subvarieties
generically contained in the intermediate Jacobian locus that arise from the criterion given
in Theorem 0.3."

> **Theorem 0.4 (= Thm. 6.1).** Let G ⊆ GL(5,C) be a finite subgroup. If dim M_G > 0 and
> (⋆⋆) is satisfied, then either M_G is contained in the locus of cyclic cubic threefolds
> M^cyc, or G is isomorphic to Alt(4) or Alt(5) and M_G contains the Klein cubic threefold.

(The v2 text of Thm. 6.1 has a typo, "Autp4q or Autp5q" for Alt(4)/Alt(5); Theorem 0.4 in
the introduction and §5 throughout read Alt.)

> **Theorem 0.5 (= §5).** Up to conjugation, there is a unique subgroup G ⊆ GL(5,C)
> isomorphic to the alternating group Alt(4) (respectively Alt(5)) for which the closure of
> J(M_G) in A₅ is a special subvariety (of dimension two (respectively one)). Moreover, M_G
> contains the Klein cubic threefold and is thus not contained in the locus of cyclic cubic
> threefolds M^cyc.

Proof input: the classification of groups acting faithfully on smooth cubic threefolds by
Wei and Yu (below), enumerated with GAP over all 5-dimensional representations of the six
maximal groups, checking (⋆⋆).

### So: is there an "A₅ family", and does the classification include it?

Yes — and note the notational hazard, because both readings of "A₅" land on real objects in
this paper:

- **A₅ as the moduli space** of principally polarized abelian fivefolds. This is the
  paper's own usage throughout (the special subvarieties live *in* A₅).
- **A₅ as the alternating group Alt(5).** This is what the reviewer's "the A_5 family" must
  mean, and such a family exists and is one of the two exceptional cases of Theorem 0.4.

Details of the Alt(5) case (§5.3):
- **Lemma 5.5:** the locus of smooth cubic threefolds admitting an Alt(5) action has two
  irreducible components, M_{H₁} ∪ M_{H₂}, where Alt(5) ≅ H₁ ⊆ PSL(2,11) (character χ₅, the
  5-dimensional irreducible) and H₂ is the image of Alt(5) ⊆ Sym(5) → GL(5,C) by coordinate
  permutation (character χ₁+χ₄). M_{H₁} ∩ M_{H₂} = {Y₁, Y₆}.
- **Lemma 5.6:** M_{G_i} ∩ M̃_{Z/5Z} = M_{H_i}; and a cubic threefold admits an Alt(5)
  action iff it admits both an Alt(4) and a Z/5Z action.
- **Proposition 5.7:** the closure of J(M_{H₁}) in A₅ is a **one-dimensional** special
  subvariety; M_{H₁} contains the Klein cubic threefold and so is not inside M^cyc.
  Computation via GAP: dim U^{H₁} = ⟨S³χ₅, χ_triv⟩ = 2 (so the invariant cubics form a
  2-dimensional linear system — i.e. **a pencil**, which is presumably what "the A_5 pencil"
  in the epilogue means) and ⟨S²(det(χ₅)⊗χ₅), χ_triv⟩ = 1; χ₅ irreducible ⇒ centralizer of
  H₁ in GL(5,C) is 1-dimensional ⇒ dim M_{H₁} = 1.
- **Remark 5.8** (the remark v2 replaced): the intermediate Jacobians of members of M_{H₁}
  are all **isogenous to the self-product E⁵ of an elliptic curve** — because End(W₅) ≅ Q
  for the 5-dimensional irreducible Q-valued Alt(5)-representation W₅, via
  Birkenhake–Lange Thm 13.6.2. Credited to a comment by Bert van Geemen. Consequence
  recorded there: the set of intermediate Jacobians of maximal Picard number in J(M_{H₁}) is
  analytically dense (Beauville 2014). Footnote: van Geemen–Yamauchi show that a cubic
  threefold with an order-5 automorphism has J(Y) isogenous to E × B², B an abelian surface.

### The classification's exact scope — where the reviewer's word "classified" needs a hedge

1. **(⋆⋆) is sufficient, not necessary** (Remark 3.4 and §0.2 closing): there are groups
   G ⊊ H with M_G = M_H where G fails (⋆⋆) but H satisfies it, so J(M_G) is still special.
   Hartlieb states it as open whether there is a G ⊆ GL(5,C) with J(M_G) special but no
   H ⊆ GL(5,C) with M_G = M_H satisfying (⋆⋆). So Theorem 0.4 is a complete classification
   *of the positive-dimensional special families the criterion detects*, not provably of all
   positive-dimensional automorphism-defined special families. The reviewer's phrasing
   "arising from his automorphism criterion" is, to their credit, exactly this hedge.
2. **The cyclic branch is not itemized.** Theorem 0.4's first alternative is "M_G ⊆ M^cyc",
   the Allcock–Carlson–Toledo cyclic-cubic-threefold locus (Proposition 4.2: closure of
   J(M^cyc) in A₅ is a special subvariety; Corollary 4.3: any G whose F-lifting contains a
   conjugate of diag(ζ₃,1,1,1,1) with M_G ≠ ∅ gives a special subvariety). It is not broken
   into a list of individual families.
3. **dim M_G > 0 is required** (Remark 6.3): zero-dimensional exceptions exist outside
   M^cyc — Y₄ with Aut ≅ Z/16Z has CM on its intermediate Jacobian; the Klein cubic Y₅ with
   Aut ≅ PSL(2,11) has order-11 cyclic subgroups G with dim M_G = 0 satisfying (⋆⋆).
4. **What is classified is CM/special (André–Oort) structure**, not algebraicity of the
   minimal class. Hartlieb's paper does not mention θ⁴/4!, universal CH₀-triviality, or
   Voisin's criterion at all (grep over the full extracted text finds no occurrence). The
   reviewer's bundling of Claim 1 and Claim 2 into one story is theirs, not any source's.

### The underlying automorphism classification the reviewer alludes to

**Wei–Yu, verified.** Li Wei and Xun Yu, *Automorphism groups of smooth cubic threefolds*,
Journal of the Mathematical Society of Japan **72** (2020), no. 4, pp. 1327–1343,
DOI 10.2969/jmsj/83088308 (published 1 Oct 2020). Bibliographic detail confirmed
independently in Crossref; **read depth: secondary only** — the statement below is quoted
from Hartlieb's Theorem 2.1, whose own read depth is `partial` as recorded above. The
Wei–Yu paper itself was not fetched.

> **Theorem 2.1 ([WY20], as quoted by Hartlieb).** A group G has a faithful action on some
> smooth cubic threefold if and only if G is isomorphic to a subgroup of one of the
> following six groups: (Z/3Z)⁴⋊Sym(5), (((Z/3Z)²⋊Z/3Z)⋊Z/4Z)×Sym(3), Z/24Z, Z/16Z,
> PSL(2,11), Z/3Z×Sym(5).

Realizing cubics (Hartlieb Example 2.2, from [WY20, Ex. 3.1]): Y₁ = Fermat
x₀³+…+x₄³ with (Z/3Z)⁴⋊Sym(5); Y₂ with (((Z/3Z)²⋊Z/3Z)⋊Z/4Z)×Sym(3); Y₃ with Z/24Z;
Y₄ with Z/16Z; Y₅ = the Klein cubic x₀²x₁+x₁²x₂+x₂²x₃+x₃²x₄+x₄²x₀ with PSL(2,11);
Y₆ = x₀³+x₁²x₂+x₂²x₃+x₃²x₄+x₄²x₁ with Sym(5)×Z/3Z. Also relevant, same source:
[WY20, Thm. 4.11] every group of automorphisms of Y = V(F) admits an F-lifting to GL(5,C).

**No "Fu" classification of cubic-threefold automorphism groups was located.** The prime-
order case is González-Aguilera–Liendo, *Automorphisms of prime order of smooth cubic
n-folds*, Archiv der Mathematik **97** (2011), no. 1, pp. 25–37 (**secondary only**, via
Hartlieb's bibliography). The name "Fu" in the task brief appears to be a mis-recollection;
searching turned up no such work, and the classification Hartlieb relies on is Wei–Yu.
(Marked as the auditor's inference: absence of a Fu classification here is a weak negative —
it rests on the Hartlieb bibliography plus the searches logged below, not a dedicated sweep.)

**Adjacent works surfaced but not promoted** (all `abstract/metadata only`, from the
Semantic Scholar result set logged below): Casalaina-Martin–Marquand–Zhang, *The moduli
space of cubic threefolds with a non-Eckardt type involution* (IMRN, DOI
10.1093/imrn/rnad113); Casalaina-Martin–Zhang, *The moduli space of cubic surface pairs via
the intermediate Jacobians* (JLMS, DOI 10.1112/jlms.12419); van Geemen–Yamauchi, *On
intermediate Jacobians of cubic threefolds admitting an automorphism of order five*, Pure
Appl. Math. Q. **12** (2016), no. 1, pp. 141–164 — already in the shared cache as
`arXiv:1506.05346`, not opened for this audit.

---

## Bearing on a PEL-family defect sweep

Auditor's inferences, all marked as mine; none of this is asserted by any source read.

1. The two claims are individually sound but come from **disjoint literatures that do not
   cite each other**. Voisin's equivalence is about algebraicity of the minimal class and
   universal CH₀-triviality; Hartlieb's classification is about CM/André–Oort special
   subvarieties of PEL-type. Any argument that chains them is new work, not a citation.
2. The generic case is now closed against us: Engel–de Gaay Fortman–Schreieder Theorem 1.3
   proves θ⁴/4! is not algebraic for very general cubic threefolds. A sweep therefore cannot
   be framed as testing whether the obstruction is nontrivial — it is. It can only be framed
   as identifying members of Voisin's non-empty countable union of positive loci.
3. Hartlieb's Alt(5) pencil is a plausible candidate for such a positive locus, by a route
   that is visible but unproved from the sources read: Remark 5.8 gives J(Y) isogenous to E⁵
   for every Y ∈ M_{H₁}, and on E⁵ with a product polarization the minimal class is
   manifestly algebraic; Voisin's Theorem 4.5 turns an **odd-degree** isogeny to a
   (product-of-)Jacobian into algebraicity of θ⁴/4!, using that 2·θ⁴/4! is already algebraic
   by the Prym structure. **The parity of the isogeny degree is the whole question**, and
   neither Hartlieb (who does not compute it, and does not care about parity) nor Voisin (who
   uses a different, order-3-automorphism family) supplies it. If the degree is even the
   route gives nothing, since even multiples are exactly what EGS Theorem 1.3 already allows
   generically.
4. Voisin's own positive locus is much larger (codimension ≤ 3 in the 10-dimensional moduli
   space) than Hartlieb's special subvarieties (dimension 1 and 2). If a sweep's purpose is
   to exhibit cubic threefolds with algebraic minimal class, Voisin §4 already provides them
   directly and Hartlieb's PEL classification is not needed. Hartlieb's value is different:
   it says the *CM/PEL* structure available from automorphisms is exhausted, up to the (⋆⋆)
   gap, by the cyclic locus plus the Alt(4) and Alt(5) families containing the Klein cubic.
   A "PEL-family defect sweep" that expects a rich supply of positive-dimensional PEL
   families to sweep over should be re-scoped: there are two, of dimensions 2 and 1, plus the
   cyclic locus.
5. The one genuinely reportable inaccuracy in the reviewer text is calling θ⁴/4! the
   "primitive class" rather than the "minimal class". Everything else checked out. The
   reviewer's omission of Engel–de Gaay Fortman–Schreieder (July 2025, revised March 2026) is
   the more consequential gap, since it changes the status of Voisin's problem from open to
   generically settled.

---

## Search record

All searches run 2026-08-11 unless a fetch date is stated otherwise. No search engine
reported an error; empty results are distinguished from errors by the services returning a
well-formed response with a zero/absent result list, which is noted where it happened.

### Shared literature cache (first, before any web fetch)

| # | Command | Result | Stop condition |
|---|--------------------------------------------------------------------------|--------|----------------|
| 1 | `python3 /tmp/persistent/tavis/lit-search/bin/litcache.py list` filtered by `grep -iE 'voisin\|universal\|hartlieb\|cubic\|CH_0\|CH0\|jacobian'` | 20 hits shown, incl. `arXiv:1407.7261` (Voisin), `arXiv:0802.0978` (Höring), `arXiv:1607.05673` (Colliot-Thélène), `arXiv:1506.05346` (van Geemen–Yamauchi) | Both target papers found already cached; no fetch needed for Claim 1 |
| 2 | `litcache.py get arXiv:1407.7261 / 0802.0978 / 1607.05673` | metadata + text paths | — |
| 3 | `litcache.py get arXiv:2304.03214` | present, fetched 2026-07-26 | Independent re-fetch hashed identically |
| 4 | `litcache.py get arXiv:2507.15704` | present, fetched 2026-08-10 | Independent re-fetch hashed identically |
| 5 | `litcache.py add` attempted for both 2304.03214 and 2507.15704 | REFUSED, key already cached; sha256 compared and equal | No `--force`, no cache mutation. The cache was not modified by this audit. |

### Web search (WebSearch tool, US index)

| # | Verbatim query | Outcome |
|---|-----------------------------------------------------------------------|---------|
| 1 | `Hartlieb cubic threefold automorphisms special families intermediate Jacobian` | Top hit arXiv:2304.03214 (Hartlieb). Claim 2 author confirmed real on the first query. |
| 2 | `Moritz Hartlieb "special subvarieties" cubic threefolds automorphism criterion published journal` | Math. Z. 310 (2025) publication surfaced; confirmed independently in Crossref and OpenAlex below. |
| 3 | `algebraicity minimal class theta^4/4! cubic threefold intermediate Jacobian universally trivial CH_0 settled 2024 2025` | Surfaced the Engel–de Gaay Fortman(–Schreieder) matroid result and the survey arXiv:2510.13679 *Rationality of hypersurfaces*. |
| 4 | `Engel "de Gaay Fortman" matroid minimal class intermediate Jacobian cubic threefold not algebraic` | Identified the paper and third author Schreieder; pointed to Engel's homepage. |

### Direct fetches (WebFetch tool)

| # | URL | Purpose |
|---|-------------------------------------------------|---------|
| 1 | `https://arxiv.org/abs/2304.03214` | Verbatim abstract, version history, comments for Hartlieb |
| 2 | `https://philip-engel.github.io/` | Resolve the matroid paper to arXiv:2507.15704 and confirm coauthors |
| 3 | `https://arxiv.org/abs/2507.15704` | Verbatim abstract, version history (v3 27 Mar 2026), comments |
| 4 | `https://arxiv.org/abs/2512.04902` | Identify the follow-up named in the v3 comments field |
| 5 | `https://arxiv.org/pdf/2304.03214v2`, `https://arxiv.org/pdf/2507.15704v3` (curl) | Byte-level re-fetch to confirm cached blobs match |

### Citation graphs

Three graphs queried independently, as required for any verdict resting on an enumerated or
absent set. Here the relevant claim (Hartlieb exists and wrote this) came out **positive in
all three**, so no cross-graph negative is being relied on.

| # | Service | Verbatim query | Result |
|---|--------------------|--------------------------------------------------|--------|
| 1 | OpenAlex | `https://api.openalex.org/works?filter=raw_author_name.search:Hartlieb&per_page=25` | count 1376 — dominated by unrelated chemistry/mining/virology Hartliebs; the name-only filter is not selective. Discarded as a screen. |
| 2 | OpenAlex | `https://api.openalex.org/works?filter=title.search:special%20subvarieties%20intermediate%20Jacobians%20cubic%20threefolds&per_page=5` | count 2, both Moritz Hartlieb: the arXiv record (2023, DOI 10.48550/arxiv.2304.03214) and Mathematische Zeitschrift (2025, DOI 10.1007/s00209-025-03745-3) |
| 3 | Crossref | `https://api.crossref.org/works/10.1007/s00209-025-03745-3` | Hartlieb, *Special subvarieties in the locus of intermediate Jacobians of cubic threefolds*, Mathematische Zeitschrift **310**(3), published 2025-05-09, 34 references, cited-by 0 |
| 4 | Crossref | `https://api.crossref.org/works?query.bibliographic=Voisin+universal+CH0+group+of+cubic+hypersurfaces&rows=3` | Top hit DOI 10.4171/jems/702, JEMS **19**(6), 1619–1653, published 2017-04-27 |
| 5 | Crossref | `https://api.crossref.org/works?query.bibliographic=Wei+Yu+Automorphism+groups+of+smooth+cubic+threefolds&rows=2` | DOI 10.2969/jmsj/83088308, J. Math. Soc. Japan **72**(4), 2020-10-01 |
| 6 | Semantic Scholar | `https://api.semanticscholar.org/graph/v1/paper/search?query=special%20subvarieties%20intermediate%20Jacobians%20cubic%20threefolds&limit=5` | total 112; screened the top 5 by title+authors+venue. Hartlieb is rank 1 with ArXiv 2304.03214 and DOI 10.1007/s00209-025-03745-3, citationCount 0. Discriminator: title names special subvarieties or intermediate Jacobians of cubic threefolds. Four others recorded above as adjacent-not-promoted. |
| 7 | arXiv API | `export.arxiv.org/api/query?search_query=ti:"integral Hodge conjecture for abelian varieties"` and an `all:matroids AND all:"abelian varieties"` variant | **Not covered.** HTTP 301 on the http scheme, then HTTP 429 rate-limit on https. Distinguished from an empty result by the HTTP status. Substituted by WebFetch of the arXiv abstract pages (fetches 1, 3, 4 above), which reached the same records. |

**Zero-citation note.** Crossref and Semantic Scholar both report cited-by 0 for the
Hartlieb Math. Z. paper. Per the project's citation-negatives rule, a zero from one graph is
not evidence of no citations; two graphs agreeing on zero for a May-2025 publication is
consistent with normal indexing lag and is not load-bearing for anything in this report.
OpenAlex forward citations were not separately enumerated, so no forward-citation closure
claim is made for Hartlieb.

### Coverage statement

- **MathSciNet: NOT COVERED** — requires institutional authentication, unreachable from this
  session. Any "to our knowledge" sentence downstream of this audit stays hedged.
- **zbMATH Open: NOT COVERED** — not queried in this pass. Freely reachable, so this is a
  gap that could be closed cheaply if a stronger negative is ever needed on the "no other
  classification of positive-dimensional special/PEL cubic-threefold families exists" front.
- **Google Scholar: NOT COVERED** — blocks automated access.
- **arXiv full-text search API: could not access** (301/429, see above); arXiv abstract pages
  were reached directly instead.
- **Published versions not read:** Voisin JEMS 19(6) and Hartlieb Math. Z. 310(3). Both
  verdicts above rest on the arXiv preprints, with the published bibliographic detail taken
  from Crossref. Theorem numbers quoted are the preprints'.
- **Not read at all, named for completeness:** Wei–Yu (JMSJ 2020) — characterized only
  through Hartlieb; González-Aguilera–Liendo (Arch. Math. 2011); van Geemen–Yamauchi (PAMQ
  2016, cached as `arXiv:1506.05346` but not opened); the survey arXiv:2510.13679
  *Rationality of hypersurfaces*; Höring, *Minimal classes on the intermediate Jacobian of a
  generic cubic threefold* (cached as `arXiv:0802.0978`, not opened — relevant to any
  follow-up on the minimal-class question); EGS §§2–8.
- **Searched and found nothing:** no work by an author named "Fu" classifying automorphism
  groups of smooth cubic threefolds, across web searches 1–2 and the Hartlieb bibliography.
  This is a weak negative — no dedicated author sweep was run — and licenses only "the
  classification in use is Wei–Yu," not "no Fu paper exists."

### Cache actions taken

None. Both papers newly identified during this audit (`arXiv:2304.03214`,
`arXiv:2507.15704`) were **already present** in the shared cache with byte-identical
sha256 values, so `add` was correctly refused and not forced. Working copies of the two
PDFs were left in this session's scratchpad; they are redundant with the cache.

---

## Closing checklist: surfaces repeating these claims

Per `notes/literature-audit-conventions.md` § "Novelty text has one home", any surface
carrying a characterisation of the Voisin equivalence or of Hartlieb's classification should
be checked against this report. Not audited by this task, and named here so the omission is
traceable rather than silent:

- `papers/cubic-stabilization-epilogue/` manuscript sources (currently modified in the
  working tree) — not inspected by this audit.
- The cubic lane handoff `notes/handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md`
  and any claim–proof–novelty ledger for the epilogue paper — not inspected.
- `notes/2026-08-11-epilogue-section4-quantum-hostile-review.md` and the other dated epilogue
  review notes — not inspected.

Specifically: if any of those surfaces describes the algebraicity of θ⁴/4! for cubic
threefolds as an open problem, that wording is now stale for the very general case
(Engel–de Gaay Fortman–Schreieder Theorem 1.3), and if any calls it the "primitive" class,
the correct term is "minimal".

---

## Main-agent addendum (2026-08-11, marked as the directing agent's, not the auditor's)

Correction to inference 3 of "Bearing on a PEL-family defect sweep": the isogeny-degree
parity question for the Alt(5) pencil is not open in this project.  The cubic-stabilization
epilogue's fibrewise minimal-class theorem is precisely the positive answer on that family,
and it is what licenses the clebsch handoff's recorded consequence that every smooth
`A5` cubic is universally `CH_0`-trivial (via the Voisin equivalence verified above as
Claim 1).  The auditor did not read the epilogue lane and could not see this.

Consequently a Hartlieb-family sweep has, at queue time, exactly this shape: the Alt(5)
pencil (dimension one) is closed positively in-project; the open members are the Alt(4)
family (dimension two) and the non-itemized cyclic locus, with Voisin's own order-3
codimension-<=3 loci already positive inside the latter, and with Hartlieb's criterion
(**) sufficient-but-not-necessary as the stated completeness boundary.  The general
classification content remains C908 route B's p-typical theorem; no sweep task is
allocated by this note.
