# C909 — priority audit of fixed-dimension finite-etale level families

Date: 2026-08-11

Status: bounded literature audit; no manuscript, PDF, mirror, Lean, or
certificate edit

This report concerns only the finite-etale C909 package: graph quotients of
elliptic powers, all-degree cohomological `PD(NS)` saturation, and the
resulting ppav/moduli statements. It does not search non-etale or `p`-typical
classification, Chow groups, or higher stabilization. Six named sources are
used below: **one full-text source and five partial reads**. This is not a
forward-citation closure.

## Executive verdict

The candidate theorem's individual ingredients have substantial classical
precedents, but the exact conjunction was not located in the bounded search:

* fixed-dimensional families of principally polarized varieties that are
  isomorphic as tori to products of elliptic curves, including irreducible
  (polarized-indecomposable) members and modular-curve parameters, are
  preempted by Carocca--González-Aguilera--Rodríguez;
* finite symplectic-module graph/Lagrangian gluings and their moduli loci are
  preempted at the finite-kernel level by Borówka;
* self-dual local lattices, affine-Grassmannian/local-model language, and
  finite-level Hecke infrastructure are standard adjacent frameworks;
* no exact predecessor was found for the fixed-(g), unbounded-(p^a)
  finite-etale graph presentation together with the explicit local order
  `O + p^a M_g(Z_p)`, pairwise separation of the levels, and ordinary
  integral cohomological `PD(NS)` saturation in every degree.

The safe priority wording is therefore “no exact predecessor was located in
the bounded search,” not “first elliptic-power family,” “first Hecke tower,”
or “new principal graph quotient.” The strongest potentially C909-specific
piece remains the marked graph-NS-to-ordinary-product bridge, uniformly in
the level. That statement is about ordinary integral cohomology, not Chow or
integral Hodge classes.

## Candidate package, component by component

| Candidate assertion | Audit status | Exact boundary |
|---|---|---|
| Quotient by a maximal-isotropic graph carries a principal polarization | classical | Standard finite symplectic/isogeny construction. |
| Fixed `g`, one example for every `a` | no exact predecessor located | Individual levels are standard local isogeny data; the unbounded fixed-dimension quantifier was not found as this graph construction. |
| Unramified degree-`g` slope algebra and self-adjoint trace generator | classical local algebra, exact package not located | Unramified extensions, trace forms, and Rosati/self-adjoint data are standard. No source was found stating this particular compatible graph-level family. |
| `End(A_a)\otimes Z_p = O+p^aM_g(Z_p)` | direct local calculation, not a literature novelty claim | The stabilizer computation is plausible, but global-to-local order identification and compatibility of the lifts must be written explicitly. |
| Pairwise nonisomorphism by order discriminant | elementary consequence if the preceding order identity is proved | Reduced-trace discriminant is intrinsic under a ring isomorphism, but the common rational matrix algebra and the away-from-`p` maximality need to be checked. |
| Polarized indecomposability | classical criterion | A product decomposition gives a Rosati-self-adjoint idempotent; the local-order argument is a useful realization in this family, not by itself a new moduli theorem. |
| Non-isotrivial modular-curve family at each level | classical level-structure/modular infrastructure | The level depends on `a`; this gives a sequence of finite covers, not automatically one compatible tower with maps `A_{a+1}\to A_a`. |
| All-degree ordinary integral cohomological `PD(NS)` saturation | no exact predecessor located | This is the strongest C909-specific bridge, conditional on the arbitrary-depth finite-etale graph-NS theorem. |

### Important audit gates in the candidate note

1. A compatible system is needed if the construction is called a single
   tower. Choosing an arbitrary isometry and generator separately over each
   `Z/p^a` gives levels, but not transition maps. A clean repair is to choose
   one integral unramified order `O/Z_p`, one generator with irreducible
   reduction, one trace-form isometry over `Z_p`, and take all reductions.

2. The displayed stabilizer is first a `p`-adic lattice stabilizer. To infer
   the completed global endomorphism order, use that the graph quotient
   changes the homology lattice only at `p`, so the order is maximal at every
   `q != p`, and then prove the local-global lattice equality. Without this
   sentence, (10) in the candidate note is a gap rather than a source-backed
   theorem.

3. The index calculation is consistent with
   `[M_g(Z_p):O+p^aM_g(Z_p)]=p^{a(g^2-g)}` once the maximal order is
   `M_g(O)`, but the discriminant normalization and the assertion that the
   global order has no other varying local contribution should be stated.
   Abstract ring isomorphisms extend to `M_g(Q)` and preserve reduced trace,
   so the `p`-valuation can distinguish levels after these checks.

4. “Extra Néron--Severi classes only enlarge the ordinary product image” does
   **not** by itself prove `PD(NS)=ordinary products` on CM fibres. Enlarging
   the input lattice can introduce new divided-power classes not controlled
   by a rank-one decomposition. Either exclude CM fibres from the full
   theorem or prove the saturation statement for their enlarged NS lattices.

5. The all-degree statement should continue to say “cohomological” and
   “marked graph presentation.” It is not an assertion that every geometric
   divisor after base change is new, nor an integral-Hodge or Chow statement.

## What the closest sources actually preempt

### Elliptic-power ppav families and irreducibility

Carocca--González-Aguilera--Rodríguez construct `rho`-decomposable ppavs,
show in their general classification that the underlying torus is a product
of elliptic curves, and treat irreducible root-system families. Their modular
centralizer calculations and Theorem 5.4 give fixed-dimensional families of
ppav isomorphism classes parameterized by modular curves. This directly
preempts a claim that an indecomposable ppav family arising from an elliptic
power, or a modular-curve parameter, is new. It does not give the candidate's
unbounded finite-etale `p^a` graph family, the order `O+p^aM_g`, or the
ordinary integral all-degree PD identity.

### Finite symplectic graph gluings and moduli loci

Borówka formulates the finite polarization kernel as a symplectic module and
identifies transverse maximal isotropics with graphs of antisymplectic maps;
the generalized Humbert locus is treated as an irreducible moduli locus.
This is the right predecessor for the kernel/graph and indecomposability
layers. It does not track a finite-etale slope algebra through all depths and
does not prove a divisor-product lattice theorem.

### Local-model and numerical-moduli language

Pappas--Zhu provide the self-dual lattice-chain, parahoric, affine
Grassmannian, and Schubert/local-model framework. It is an appropriate
chart-independent language for finite-level positions, but it does not
identify the C909 graph coefficient lattice or its rank-one/PD saturation.

Auffarth attaches numerical Néron--Severi classes to abelian subvarieties
using norm endomorphisms and studies moduli with fixed numerical data. This
supports the standard status of numerical indecomposability/moduli
invariants, not the explicit `p`-order or all-degree saturation.

Beckmann--de Gaay Fortman place integral Fourier and minimal-class questions
for abelian varieties in an integral cohomological setting. Their results are
adjacent to the phrase “integral cohomology generated by divisors,” but do not
state the marked finite-etale graph lattice identity used here.

Yu's tropical PSD theorem is relevant only as a valuation-side analogy: its
tropical rank-one hull does not supply an additive DVR endomorphism-order
classification or a ppav PD theorem.

## Priority conclusion

For the candidate as written, mark the following as **preempted/classical**:
maximal-isotropic principal quotients, finite symplectic graph language,
elliptic-power ppav families, modular-curve parameterization, and the general
Rosati-idempotent indecomposability criterion. Mark the following as **no
exact predecessor located** under this bounded audit: the conjunction

\[
\text{fixed }g\text{ and all }a\quad+quad
\text{finite-etale self-adjoint graph}\quad+
\operatorname{End}_p=O+p^aM_g(Z_p)\\
\quad+
\text{pairwise level separation}\quad+
\text{ordinary integral cohomological PD(NS) in all degrees}.
\]

The last line is a package-level negative, not proof that no component has
appeared in a source. The strongest defensible novelty sentence is:

> Finite symplectic graph gluings, fixed-dimensional elliptic-power ppav
> families, and modular-level constructions are known. In the bounded search
> recorded here, no exact predecessor was located for the marked
> finite-etale graph family whose explicit `p`-adic order separates all
> levels and whose full graph Néron--Severi lattice yields ordinary integral
> cohomological divided-power saturation in every degree.

Until the five audit gates above are closed, “tower” should be replaced by
“level family” in any priority-facing description.

## Search protocol and coverage

Load-bearing queries, recorded verbatim:

* `fixed dimension unbounded p-power isogeny tower elliptic power endomorphism order`
* `finite etale Hecke tower principally polarized abelian varieties elliptic powers`
* `"O + p^a M_g" endomorphism ring abelian variety`
* `"O+p^a" matrix order abelian variety`
* `"M_g(Z_p)" "endomorphism ring" abelian variety isogenous elliptic power`
* `"conductor" matrix order abelian variety elliptic power isogeny`

Search-result titles/abstracts/snippets were screened; no finite database set
was enumerated. The exact package was not found. MathSciNet is **NOT
COVERED** (institutional authentication unavailable); zbMATH Open is **NOT
systematically covered**; Google Scholar is **NOT COVERED** (automated access
blocked); OpenAlex, Crossref, and Semantic Scholar citation graphs were **NOT
RUN**. No exhaustive search of Hecke/Siegel monographs, matrix-order
literature, or all PEL local-model sources was attempted.

## Source records

### Angel Carocca, Víctor González-Aguilera, and Rubí E. Rodríguez,
*Weyl Groups and Abelian Varieties*

* Read depth: **partial** — cached arXiv preprint v1; read the Abstract and
  Introduction, §§2, 4, and 5, relying on Propositions 2.4, 4.1, 4.4, 5.2,
  Theorem 2.5, Corollary 2.8, Theorem 4.5, and Theorem 5.4.
* Access/version: `arXiv:math/0503340v1`, PDF/text cache.
* Cache key: `arXiv:math/0503340`.
* SHA-256:
  `c8e4287a8173c8b5f9ed80187f3463dedcd8a23edeb9d74964357b7eb117cf11`.

### Paweł Borówka, *Non-simple principally polarised abelian varieties*

* Read depth: **partial** — cached arXiv preprint v2; read the Introduction,
  §§2.1–2.2, §3.3, and §4.1, relying on Propositions 2.5, 2.13, 3.17 and
  Theorem 4.2.
* Access/version: `arXiv:1307.6591v2`, PDF/text cache.
* Cache key: `arXiv:1307.6591`.
* SHA-256:
  `3dc2b23f244620df88bdbbb48282dddf8dbab93aeaf7adb965594dc32611fc01`.

### G. Pappas and X. Zhu, *Local models of Shimura varieties and a
conjecture of Kottwitz*

* Read depth: **partial** — cached arXiv preprint v4; read the Introduction,
  §4.a, §6.b.2, §7.a, and §8.a, relying on Theorem 0.1, Proposition 7.1, and
  the self-dual-chain/Schubert descriptions.
* Access/version: `arXiv:1110.5588v4`, PDF/text cache.
* Cache key: `arXiv:1110.5588`.
* SHA-256:
  `cbb879126ff50a5431e06046edd55d1da3ee4d260ddd4d80202a043e21b18b27`.

### Robert Auffarth, *On a numerical characterization of non-simple
principally polarized abelian varieties*

* Read depth: **partial** — cached arXiv preprint v2; read the Introduction
  and §§2–3, relying on Theorems 2.6 and 3.1 and the moduli construction
  around Proposition 3.8.
* Access/version: `arXiv:1507.08618v2`, PDF/text cache.
* Cache key: `arXiv:1507.08618`.
* SHA-256:
  `0852d65b8250d47d0073c6c40e328e1d894c7a6c84e23f0fbb4d5b5b8c290e4d`.

### Thorsten Beckmann and Olivier de Gaay Fortman, *Integral Fourier
transforms and the integral Hodge conjecture for one-cycles on abelian
varieties*

* Read depth: **partial** — cached arXiv preprint; read the
  Abstract/Introduction, Theorem 3.8, and the product/minimal-class discussion
  around Corollary 4.1.
* Access/version: `arXiv:2202.05230`, cached PDF/text.
* Cache key: `arXiv:2202.05230`.
* SHA-256:
  `ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc`.

### Josephine Yu, *Tropicalizing the positive semidefinite cone*

* Read depth: **full text** — cached arXiv preprint v1; complete PDF/text
  read, relying on Theorems 1–2, Lemma 3, Theorem 4, and Corollary 6.
* Access/version: `arXiv:1309.6011v1`, cached PDF/text.
* Cache key: `arXiv:1309.6011`.
* SHA-256:
  `ed4e28307e5ac1815d3f391118a7a37548a4a8df070cd2aefec0bef49b6faea6`.
