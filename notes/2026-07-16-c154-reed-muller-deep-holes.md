# C154 — Reed--Muller deep holes and the variety-equality residual

**Lane**: `relconic`

**Status:** REPORTED — no Reed--Muller counterexample found

## Verdict

The bounded Reed--Muller residual is closed.  No source located identifies the complete
deep-hole locus of a Reed--Muller, generalized Reed--Muller, or projective Reed--Muller code
with the full rational-point set of a named positive-dimensional variety.

The closest genuine predecessor is the classical first-order binary correspondence

```text
deep holes of RM(1,m)  <->  Boolean functions of maximum nonlinearity,
```

which, for even `m`, is the class of bent functions.  This is an exact description by a named
combinatorial/cryptographic class, not a statement that the deep-hole set is the rational-point
set of an algebraic variety.  Ozeki goes further for small `m`: selected unions of deep-hole
cores or cosets form Hamming association subschemes, and `RM(1,3)` yields a Johnson scheme.
Again, this is a metric association-scheme description, not a variety equality.

Accordingly, the manuscript boundary survives as previously formulated: the novelty is the
complete deep-hole locus being exactly all `F_q`-points of a named positive-dimensional
variety, not the older facts that Reed--Muller deep holes are bent/maximally nonlinear
functions or that deep holes can carry named combinatorial structures.  This is a bounded
negative literature result, not an exhaustive priority certificate.

## What was searched

The search used both vocabularies required by the task:

- `"deep holes" + Reed--Muller`, including first-order, generalized, and projective variants;
- covering radii `RM(r,m)`, maximum/high-order nonlinearity, bent functions, coset
  classification, and affine-equivalence classification;
- `bent function(s) + algebraic variety/rational points` to test the most plausible semantic
  collision directly;
- the named KLP, Dumer, and Abbe--Shpilka--Wigderson strands;
- recent exact/numerical covering-radius work through the 2025 literature visible on
  2026-07-16.

The shared cache was queried before fetching.  Seven primary PDFs were then cached, extracted,
and checked in the relevant theorem, classification, and conclusion sections.  Their extracted
texts were also searched for `variety`, `rational point`, `projective`, `algebraic geometry`,
`curve`, and `surface`.

## Primary-source findings

| Source | What it actually describes | C154 consequence |
|---|---|---|
| Ozeki, *A Study of Deep Holes in the First-Order Reed--Muller Codes* (2012) | Deep-hole coset cores for `RM(1,m)`, `m=3,4,5,6`; Hamming association subschemes; explicit small representatives | Strongest exact “named structure” near miss, but the structure is an association scheme, not a variety's rational points |
| Leducq, *On the covering radius of first order generalized Reed--Muller codes* (2011) | Radius bounds over arbitrary `F_q`; equality for even `m`; explicit quadratic functions attaining the radius | Exhibits maximizers, not the complete maximizer locus, and makes no variety equality |
| Wang, *The Covering Radius of the Reed--Muller Code `RM(2,7)` is 40* (2018/2019) | Affine-equivalence classes and Boolean-function nonlinearities used to prove an exact radius | Coset/function classification only |
| Gao--Kan--Li--Wang, *The Covering Radius of `RM(3,7)` is 20* (2022) | Classification into affine/coset types, followed by exclusion of larger nonlinearity | No geometric point-set description |
| Dougherty--Mauldin--Tiefenbruck (2021) | Certificate methods for minimum coset weights and relative covering radii | Boolean-polynomial/certificate language, not a complete deep-hole locus or variety |
| Elimelech--Wei--Schwartz (2021/2022) | Generalized covering-radius bounds and a recursive covering algorithm | Radius/algorithm strand; explicitly notes that most exact RM radii remain unknown |
| Gao (2025) | Numerical and asymptotic lower bounds from list decoding and monomial Boolean functions | Recent active work remains in function search, bounds, and relative-radius classification |

The 2024 `RM(4,8)` result of Gillot--Langevin likewise derives radius `26` from affine
classification of Boolean functions.  Its official full-text page uses classification/coset
language and supplies no variety-point-set identification.

## Named strands that do not answer the deep-hole-set question

- Kaufman--Lovett--Porat study weight distribution and list-decoding size for RM codes.  Their
  object is the number of nearby codewords, not a classification of farthest words.
- Abbe--Shpilka--Wigderson study capacity under random erasures/errors and RM weight
  distributions.  This is random-channel behavior, not worst-case deep holes.
- Dumer's RM work found here concerns recursive, list, and soft-decision decoding algorithms.
  It does not classify covering-radius achievers.
- Projective Reed--Muller searches returned minimum-distance, minimum-weight, and weight-enumerator
  work, but no paper describing a projective RM deep-hole set.  This is negative search evidence,
  not proof that no differently titled source exists.

## Evidence boundary

The search closes the only explicitly unsearched modern RM strand in the 2026-07-14 audit.
Residual priority risk remains in differently named older work, non-English literature, and the
general impossibility of proving an absence claim by search.  The safe wording remains
“no prior instance was located in the bounded audit,” with the mathematical pattern stated
precisely.  A bare “first connection between deep holes and geometry” would still be false.

## Cached source ledger

| Key | SHA-256 |
|---|---|
| `10.2206/kyushujm.66.449` | `7a9c1778d3e9f9d5a1ec42f20a79b801ebff49ae5214d2a50974ced5ea541135` |
| `arXiv:1102.2122` | `1fbfc7d0b0964f84ef7cd6559ce37e00a8b5fbadd3b0d4cb2413987b365dcf1e` |
| `arXiv:2107.09902` | `eb19be027bee813a2c96a9eea3504798acbef94b311d38ceeb173b6f2330f410` |
| `arXiv:1809.04864` | `3152b62da9d320051ad0637454c7f4af5a7b81e867645201d37a7d7d896c255c` |
| `arXiv:2206.10881` | `061f2a20477e3e3978c3236f390a382b7b45ce7bf84f8826925b858e71492914` |
| `arXiv:2106.13910` | `d20e989f326b2228f026cf00f34131d76df091507b1972317f44f733f3bb34eb` |
| `10.1587/transfun.2025EAP1015` | `de6f2698f72c6b542e1ebd97d76414ee0a24215d51d696e04dff3da9b4144e2a` |

Cache verification after ingest reported eleven entries and zero problems.

## Source links

- [Ozeki 2012](https://doi.org/10.2206/kyushujm.66.449)
- [Leducq 2011](https://arxiv.org/abs/1102.2122)
- [Wang 2018](https://arxiv.org/abs/1809.04864)
- [Gao--Kan--Li--Wang 2022](https://arxiv.org/abs/2206.10881)
- [Dougherty--Mauldin--Tiefenbruck 2021](https://arxiv.org/abs/2106.13910)
- [Elimelech--Wei--Schwartz 2021](https://arxiv.org/abs/2107.09902)
- [Gao 2025](https://doi.org/10.1587/transfun.2025EAP1015)
- [Gillot--Langevin 2024](https://doi.org/10.3934/amc.2023038)
- [Kaufman--Lovett--Porat 2012](https://doi.org/10.1109/TIT.2012.2184841)
- [Abbe--Shpilka--Wigderson](https://arxiv.org/abs/1411.4590)
- [Dumer](https://arxiv.org/abs/1703.05303)
