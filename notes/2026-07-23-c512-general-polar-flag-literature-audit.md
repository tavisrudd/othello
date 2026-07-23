# C512 literature audit — split-free Hankel systems and coherent polar flags

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Verdict:** NOT PRE-EMPTED, with the
coverage qualifications below

## Opening summary

This audit asks whether the literature already proves an effective induction theorem for split-free
Hankel systems by coherently parameterized contractions of binary forms, including classification of
contained catalecticant/nucleus flags and an effective finite-field bound from lower splitting covers.

**Full-text count:** one newly located source was read at full text: Wang,
`arXiv:2606.12810v1` (all sections).  The audit also read Briand's Sections 1--2 at partial depth
and reuses the full-text/partial source spine of the C498 and C509 audits.  No read depth is inferred
from cache presence.

**Verdict.** No located source states C512's coherent polar-flag induction theorem.  The ingredients
are classical or newly well packaged: polars and catalecticants; equations for decomposable forms;
factorization statistics in linear polynomial families; and Chebotarev over finite-field varieties.
Most importantly, Wang's June 2026 paper now gives an unusually close general Galois framework for
splitting in polynomial families.  It pre-empts any claim that the Frobenius/monodromy engine itself is
new.  It does not impose Hankel overlap, retain the forbidden factor through iterated contractions,
classify polar flags contained in lower bad loci, or give C512's effective fixed-redundancy threshold.

## Fresh object search

The following web-index queries were run on 2026-07-23:

```text
site:arxiv.org binary forms catalecticant polar maps apolarity incidence
site:arxiv.org finite fields exceptional covers effective Chebotarev factorization patterns polynomial families
site:arxiv.org split-free linear systems binary forms finite fields totally split
"polar flag" binary form catalecticant
"first polar" "binary form" catalecticant
"split-free" "binary forms" finite field
"Hankel" "totally split" binary forms finite field
"catalecticant" "exceptional cover" finite field
```

The exact phrase `polar flag` was noisy and primarily returned unrelated uses of “polar.”  Searches by
the actual mathematical objects found the sources below, but no coherent Hankel-contraction induction
theorem.  This is a targeted object screen, not an exhaustive bibliography.

## Closest new source: splitting families via Galois theory

Tianhao Wang, *Splitting of Polynomial Families via Galois Theory*,
`arXiv:2606.12810v1` (11 June 2026) — **read depth: full text**, all sections, from the arXiv v1
PDF; cache key `arXiv:2606.12810`, SHA-256
`5dd4e19544335ebc2c75a184074e94adb91b78331930b5e8a643ae606021a107`.

Wang identifies specialization factorization type with Frobenius cycle type, separates arithmetic and
geometric monodromy, states Chebotarev density over an affine normal geometrically integral base, and
treats simultaneous splitting through linearly disjoint Galois extensions.  Section 5 gives the finite
étale-cover formulation over a normal finite-type scheme.  These are exactly the correct general
arithmetic semantics for C512's lower splitting cover.

The paper's estimates are asymptotic, with an unspecified `O(q^{-1/2})` constant.  It does not:

- specialize to apolar Hankel kernels or projective Reed--Solomon syndromes;
- formulate contraction by a marked linear factor or its collision diagonal;
- study the image of a binary form's consecutive-row polar line in a lower bad locus;
- classify contained catalecticant or modular-nucleus components; or
- turn a lower cover's genus/different/deletion data into C512's explicit threshold.

Accordingly C512 cites this work for the general Galois-splitting framework and supplies the
Hankel/polar geometry and the effective curve inequality.

## Polar, decomposable-form, and factorization inputs

Emmanuel Briand, *Covariants Vanishing on Totally Decomposable Forms*,
DOI `10.1007/978-3-0346-0201-3_14` — **read depth: partial**, repository PDF, Sections 1--2 and
Theorems 1--3; cache SHA-256
`61ae81446b0f31e8729afef3bdb854fb8cad26ef40c39048070272dcdb8e7951`.
Briand works over an algebraically closed characteristic-zero field.  Brill's and Gaeta's covariants
give equations for absolute decomposability (and, for Gaeta's variant, the union with the multiple-factor
locus) and motivate specialization to polynomial families.  This is relevant equation-making technology,
not rational complete splitting over finite fields and not a polar-flag induction.

Cesaratto--Matera--Pérez, *The distribution of factorization patterns on linear families of
polynomials over a finite field*, `arXiv:1408.7014` — **read depth: partial**, reused from the C498
audit (abstract, theorem statements, and its explicit linear-family factorization-count role).  It gives
positive main terms and explicit error constants for good linear families in characteristic greater than
two.  C512 does not claim this counting phenomenon; it isolates the exceptional Hankel families on which
the good-family hypotheses or monodromy fail.

Gmainer--Havlicek, *Nuclei of Normal Rational Curves*, `arXiv:1304.0088` —
**read depth: partial**, reused from C498 (abstract and Theorem 1), cache SHA-256
`da688c01e3953319ef93f17e1676fedf0470c590a0a348a853dabb11209526d0`.
Its binomial-coordinate nucleus criterion is the input for C512's modular linear subspaces.  C512's new
step is to intersect those subspaces with the consecutive-row polar functor and retain the resulting flag.

Aubry--Perret's singular-curve Weil bound — **read depth: abstract/metadata only**, reused from
C498's axis-B audit — and the ordinary Hasse--Weil bound supply the explicit curve estimate.  Wang
points instead to Jarden/Meagher/Kowalski/Fried--Jarden for Chebotarev; those works are
**secondary only here through Wang's full-text Sections 3.2 and 5**, not independently characterized.
C512 uses only the elementary consequence that a geometrically integral identity-twist curve of genus
`g` with a deletion divisor of degree `delta` has a rational witness once
`q + 1 - 2g sqrt(q) > delta`.

## Reused coding and deep-hole coverage

The C509 audit's coding axis is reused without re-resolving its pinned seeds:

- Zhang--Wan--Kaipa, `arXiv:1901.05445` / DOI `10.1109/TIT.2019.2940962` —
  **read depth: full text**, reused from C491/C498;
- Kaipa, `arXiv:1612.05447` / DOI `10.1109/TIT.2017.2706677` —
  **read depth: full text**, reused from C491/C498;
- Wu--Ding--Chen, `arXiv:2312.05534` — **read depth: full text**, reused from C498; and
- Xu, DOI `10.1051/wujns/2023281015` — **read depth: full text**, reused from C498.

C498 recorded separate OpenAlex/Crossref/Semantic Scholar counts and screened the largest citing sets
with a discriminator covering every `PRS(k)` with `k <= q-5`; C509's successor range was already inside
that screen.  C512 does not claim a new scalar covering radius or a solution of the arbitrary-redundancy
deep-hole problem.  Its novelty target is the conditional-but-effective induction architecture and its
contained/transverse dichotomy.

## Coverage and downstream wording

- **Fresh web-index object screen:** covered for the eight verbatim queries above.
- **Shared full-text cache:** covered for Wang and Briand; hashes recorded above.  The earlier C498/C509
  audits own the cache records for reused sources.
- **OpenAlex/Crossref/Semantic Scholar coding forward trees:** reused from C498/C509; not rerun one day
  later.
- **zbMATH Open:** not refreshed for C512.
- **MathSciNet:** NOT COVERED because institutional authentication is unavailable.
- **Google Scholar:** not used because automated access is blocked.

Any priority sentence must remain “to our knowledge.”  Do not claim novelty for polar differentiation,
apolarity, Brill/Gaeta equations, NRC nuclei, factorization statistics, Chebotarev, or Hasse--Weil.
The defensible C512 contribution is: an intrinsic coherent pointed-polar functor for Hankel systems; an
effective contained-or-transverse induction theorem with a closed formula for the field threshold; the
algorithmic classification of its catalecticant and modular-nucleus contained flags; and verification that
C498/C509 are its first two cases, including the q=19 coherence falsifier.
