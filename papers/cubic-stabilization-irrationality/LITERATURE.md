# Claim–proof–novelty ledger

Audit date: 11 September 2026. **Two external sources were read in full**;
the other consulted sources have the read depths listed below. This ledger
owns the paper's novelty qualifications. It distinguishes a proved result
from the separate, necessarily bounded search for predecessors.

## Contribution and prior work

| Row | Claim and proof in the manuscript | Prior work and qualified verdict |
| --- | --- | --- |
| N1 | The two-variable surface theorem: a rational point and stably permutation geometric Picard lattice imply rationality after A². The proof constructs a rational rank-three torus quotient and splits off the residual rank-two torus. | Tschinkel–Zhang supply the Cox geometry, four minimal Picard types and a uniform bound of eleven. Their account attributes the bound two for type I₀ to Shepherd-Barron. To our knowledge within the coverage below, the uniform bound two across the four types was not previously established. Shepherd-Barron's original chapter remains an access gap; no priority is claimed for the general idea of rational torus quotients or slices. |
| N2 | The uniform cubic-family theorem proves the upper bound for the displayed three-parameter family; the companion theorem supplies the lower bound. | The family belongs to the established non-Eckardt involution locus studied by Casalaina-Martin–Marquand–Zhang. Its pencil lies in Roulleau's established Klein-four locus; see the coordinate comparison below. The contribution is the uniform rationalization and exact stabilization level, not discovery of either ambient symmetry locus. To our knowledge within this audit, no predecessor for that uniform assertion on the displayed family was located. |
| N3 | The pencil's five elliptic factors give the potential toric rank formula and the separated-first-stabilizations theorem. The final birational conclusion uses the companion's Hodge-conservation theorem. | Elliptic-product decompositions and conic-bundle/Prym methods are prior tools. The arithmetic members are distinct, even up to geometric Jacobian isogeny, from the particular older families compared below. To our knowledge within this audit, no predecessor for this pencil's rank formula and positive-density separation statement was located. This is not a classification of all earlier Klein-four subfamilies. |
| N4 | The optional finite-partner result reduces rational parameters to finitely many unit-equation candidates. | This is an application of the cited unit-equation theorem and the paper's local rank formula. No new unit-equation theorem, complete implemented solver or affirmative birationality test is claimed. |

## The pencil is in a known symmetry locus

This coordinate comparison is a deduction from the displayed pencil and
Roulleau's normal form, rather than a claim made by Roulleau about our pencil.
Over Q(√3), put A = u + √3v, B = u − √3v and Y = √3y. Its equation becomes

\[
\tfrac12(z+Y)A^2+\tfrac12(z-Y)B^2+\tfrac34zx^2-xAB
 -z^3+\tfrac34Y^2z+\frac{t}{3\sqrt3}Y^3=0.
\]

Even sign changes of (x,A,B) give the Klein-four representation
L + L₁ + L₂ + 2T in Roulleau's §3.3. The remaining binary cubic has
discriminant (27−16t²)/16, nonzero for smooth members of the pencil;
over C a change of its two coordinates brings it to the binary form used
there. Thus the pencil is a subfamily of that known locus. Hartlieb's
Figure 1 records its dimension as four. The general three-parameter family
has the non-Eckardt involution (u,v) ↦ (−u,−v), in the known
six-dimensional involution locus.

## What the rank-three reduction distinguishes

The following comparison is our deduction from the manuscript's local
rank proposition and the cited isogeny decompositions. For every positive
integer n prime to six, D = 16n²−27 is prime to six and has |D| > 1.
Some prime p ≥ 5 therefore divides D, and J(X_n) has potential toric
rank three there. Potential toric rank is invariant under geometric
isogeny, after a common finite extension.

* Roulleau's twelve-elliptic-curve family has Jacobian isogenous to
  E₀³ × Eλ², where E₀ is the j = 0 elliptic curve. The fixed CM factor
  has potentially good reduction, so these products have potential toric
  rank zero or two. The Fermat case is included. Rank three excludes them.
* A product E⁵ has potential toric rank zero or five, so is also excluded.
* Van Geemen–Yamauchi, Proposition 1.5, give J ≃ E × B² for the
  order-five family, with Q(√5) embedded in End⁰(B). If such a Jacobian
  were isogenous to J(X_n), its surface B would split up to isogeny into
  elliptic curves. Two nonisogenous elliptic factors have endomorphism
  algebra a product of fields, each Q or imaginary quadratic; it cannot
  contain Q(√5). Thus B ≃ E′², and J ≃ E × E′⁴. Its potential toric
  rank is in {0,1,4,5}, again excluding three.

All comparisons are geometric and unpolarized. They apply to the
arithmetic members, not to every complex value of t. They establish
non-overlap with these specific families, not novelty of the ambient locus.

## Coverage and source depths

The bounded search used seven zbMATH Open queries (40 returned appearances),
24 web search queries (133 displayed result appearances), and the union of
the available citing lists for four pinned seeds. The search screened titles,
identifiers and years, with web snippets; sources involving quartic del Pezzo
stable rationalization, smooth cubic symmetry/isogeny families or arithmetic
isogeny separation were promoted for closer reading. This is not a recursive
search of the entire citation graph.

| Pinned seed | OpenAlex count | Crossref count | Semantic Scholar count |
| --- | ---: | ---: | ---: |
| arXiv:2608.20029; DOI 10.48550/arXiv.2608.20029 | 3 | Unregistered (404) | 0 |
| arXiv:1001.4855; DOI 10.1307/mmj/1310667979 | 12 | 7 | 16 |
| arXiv:1506.05346; published DOI 10.4310/PAMQ.2016.v12.n1.a5 | 2 | 2 | 4 |
| arXiv:2210.14397; DOI 10.1093/imrn/rnad113 | 1 | 0 | 2 |

The largest available sets and additional works in the other graphs were
screened. Roulleau's OpenAlex endpoint returned thirteen rows despite a
count of twelve, including a duplicate DOI. The order-five paper's preprint
and published records return different lists. All three OpenAlex citations
of the newest seed are this paper's own earlier deposits; they provide no
independent corroboration. Crossref supplies counts, not public citing lists.
Successful zero counts are distinguished from HTTP failures; throttled
Semantic Scholar requests were retried successfully using pinned identifiers.

**MathSciNet: NOT COVERED** (institutional authentication).
**Google Scholar: NOT COVERED** (automated access failed).
**Shepherd-Barron (2004), original chapter: NOT ACCESSED.** Its bound is
known here through the partial primary reading of Tschinkel–Zhang and
B. Z. Moroz's zbMATH review, whose account was not checked against the chapter.
These gaps prevent an exhaustive priority conclusion.

| Source/version consulted | Read depth and passages |
| --- | --- |
| [Tschinkel–Zhang, arXiv:2608.20029v2](https://arxiv.org/abs/2608.20029v2) | **partial**: pp. 13–20, stabilization levels and cubic constructions; earlier proof-input audit of §§2–4 reused. |
| [Roulleau, arXiv:1001.4855v2](https://arxiv.org/abs/1001.4855v2) | **full text**: all seventeen pages via PDF text; §2, Proposition 16 and the Fermat case are used. Published metadata was resolved separately; no full reading of the published version is claimed. |
| [Roulleau, arXiv:1304.4076v2](https://arxiv.org/abs/1304.4076v2) | **full text**: all ten pages via PDF text. Its conic-bundle/Prym finite-field zeta computations are neighboring arithmetic work, not a source for our potential-rank formula. |
| [Roulleau, arXiv:1002.4467v1](https://arxiv.org/abs/1002.4467v1) | **partial**: Theorem 3, pp. 11–13, especially §3.3; the Klein-four equation was also checked on the rendered PDF page. |
| [Roulleau, arXiv:0804.1861v2](https://arxiv.org/abs/0804.1861v2) | **partial**: pp. 15–16, Lemmas 29–30; supporting elliptic-isogeny discussion. |
| [Van Geemen–Yamauchi, arXiv:1506.05346v3](https://arxiv.org/abs/1506.05346v3) | **partial**: introduction and §§1.1–1.4 through the complete proof of Proposition 1.5, pp. 1–5. The published DOI was used for citation enumeration, not as a claim to have read the published version. |
| [Hartlieb, arXiv:2304.03214v2](https://arxiv.org/abs/2304.03214v2) | **partial**: pp. 11–13, Figure 1 and beginning of Proposition 5.2. |
| [Casalaina-Martin–Marquand–Zhang, arXiv:2210.14397v2](https://arxiv.org/abs/2210.14397v2) | **partial**, reused proof-input audit: §2 and Theorem 2.9. |
| [Corvaja–Zucconi, arXiv:2211.03397v2](https://arxiv.org/abs/2211.03397v2) | **partial**: introduction §§0.1–0.3, on integral points and potential density. No full-text exclusion is claimed. |
| [Lahoz–Naranjo–Rojas, arXiv:2106.08683v2](https://arxiv.org/abs/2106.08683v2) | **partial**: introduction through Theorems A–B and start of C. Semicanonical pencils here concern linear series on curves. |
| Shepherd-Barron, *Stably rational irrational varieties* (2004) | **review only**: B. Z. Moroz, zbMATH record 2135213; also **secondary only** through the Tschinkel–Zhang passage specified above. |
| [Rudd, September 2026 companion](references/one-stabilization-september-2026.pdf) | **partial**: cited theorem interfaces, reused from the integration audit. This literature audit does not independently validate its geometric proof. |
| Beukers–Schlickewei, author version dated 8 January 2007 | **partial**, reused proof-input audit: Theorem 1.1. |

The promoted metadata-only neighbors were the Eckardt cubic paper
(arXiv:2002.09861v3), Beshaj–Yamauchi's singular Prym paper
(arXiv:1609.03981v1), Feng's genus-one moduli paper
(arXiv:2506.16686v2), and the categorical Torelli paper
(arXiv:2405.20554v2): **abstract/metadata only**, arXiv landing pages.
Other unpromoted search members are covered by the set-level screen above;
their full texts were not ruled out. No claim in this ledger depends on
treating title screening as full-text reading.
