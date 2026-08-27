# C956 source and claim ledger

## Source boundary

The theorem statements do not depend on a literature-absence claim.  The
source audit read the two load-bearing references below at targeted depth:

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1. Read depth: partial;
  cached as `arXiv:2608.20029`, PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.
  Sections checked: Theorem 2.4, Lemma 3.2, Theorem 3.4, Corollary 3.5,
  Proposition 4.1, Lemma 4.2, Corollary 4.3, the levels paragraph, and
  Propositions 5.1--5.2 at the uses made in the paper.
- Anthony Várilly-Alvarado, *Arithmetic of del Pezzo surfaces*, Theorem 2.1,
  for rationality of degree at least five del Pezzo surfaces with a rational
  point. Read depth: partial (Theorem 2.1); PDF SHA-256
  `ed5b1bbade653b7feab309b5d43a775fbc971cead2d904a4f0e94c1aca8271af`.

Two historical citations in the introduction are contextual rather than
load-bearing:

- Beauville--Colliot-Thélène--Sansuc--Swinnerton-Dyer, *Variétés stablement
  rationnelles non rationnelles*. Read depth: secondary only, through the
  discussion of the universal-torsor strategy in Tschinkel--Zhang,
  Introduction and Section 2; bibliographic metadata checked against the
  Annals/JSTOR record for DOI `10.2307/1971174`.
- N. I. Shepherd-Barron, *Stably rational irrational varieties*. Read depth:
  secondary only, through Tschinkel--Zhang's “Levels of stable rationality”
  paragraph following Remark 4.4, which attributes the type-`I_0` two-variable bound
  to this paper; bibliographic metadata taken from their reference list.

The historical source for tangent projection from an OADP variety was also
checked directly: Ciliberto--Mella--Russo, *Varieties with one apparent double
point*, arXiv:math/0210008v1. Read depth: partial (Theorem 4.1 and Corollary
4.2); cached as `arXiv:math/0210008`, PDF SHA-256
`aa68b601d43dd24b948fb2931d09a522880f9a4d9785342cc76805b0a0de1a56`.

The lower-bound input, T. Rudd, *Irrationality of cubic threefolds after one
stabilization*, was read at full-text depth in its paper-local source and
referee pass. The cited immutable release is Zenodo version 0.16.0, DOI
`10.5281/zenodo.22132303`; the Zenodo API metadata was checked on 2026-08-27.

The bounded novelty screen and its exact limitations remain in the durable
research report; the manuscript uses no "first" or "to our knowledge"
formulation derived from that screen.

## Claim ledger

| label | claim | proof source | scope |
|---|---|---|---|
| `thm:torus-quotient` | A saturated cocharacter lattice with the stated unimodularity property gives a rational torus quotient of a variety parametrized by generic tangent projection. | Text proof; signed-minor orbit correction and displayed inverse graph. | Reusable quotient theorem; all descent hypotheses are explicit. |
| `prop:tangent-section` | All four Tschinkel--Zhang minimal Picard types admit the required rank-three saturated sublattice and a descended good linear section. | Exact certificate plus incidence descent. | Complete only within the four types; no claim for all subgroups of `W(D5)`. |
| `thm:two-variable` | `S x A2` is rational under the rational-point and stably-permutation hypotheses. | `thm:torus-quotient`, `prop:tangent-section`, and imported Tschinkel--Zhang/Voskresenskii results. | The Cox/OADP geometry and four-type classification are imported. |
| `cor:cubics` | Both Tschinkel--Zhang cubic families become rational after `P2`. | Generic-fibre function-field argument. | Direct consequence; their universal-torsor theorem remains an input. |
| `thm:cubic-level` | For the two displayed cubic threefolds, the smallest `m` with `X x P^m` rational is two over `Q` and `C`. | `cor:cubics` plus the cited one-stabilization theorem. | The upper bound is specific to the two displayed cubics. |
| `cor:affine-line` | Each displayed cubic gives a nonrational smooth projective fourfold `Y` with `Y x A1` rational. | `thm:cubic-level` and a function-field identity. | Birational affine-line stabilization, not isomorphic-cylinder cancellation. |
| `cor:moduli` | The function `ell_C` is two at the displayed points and infinite at a very general complex point. | `thm:cubic-level` plus Engel--de Gaay Fortman--Schreieder Corollary 1.4. | The infinite value is only a very-general statement. |
