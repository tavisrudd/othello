# Claim, proof, and novelty ledger

## Audit boundary

No global first-priority claim appears in the manuscript.  The bounded audit
supporting its positioning read zero sources at full-text depth and one at
partial depth:

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1. Read depth: partial;
  cached as `arXiv:2608.20029`, PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.
  Sections checked: Theorem 2.4, Lemma 3.2, Theorem 3.4, Corollary 3.5,
  Proposition 4.1, Lemma 4.2, Corollary 4.3, the levels paragraph, and
  Propositions 5.1--5.2 at the uses made in the paper.

Two bounded title/snippet screens returned 45 displayed results for exact
queries concerning rationality of a nonrational `Y x A1` and unimodular OADP
torus quotients.  No displayed result met either discriminator. OpenAlex
resolved the pinned DataCite DOI `10.48550/arXiv.2608.20029` to W7203907824
with citing count zero; Crossref returned 404 and Semantic Scholar returned
429.  The required three-graph closure therefore failed. MathSciNet and a
systematic zbMATH search were not covered. The negative licenses no
"to our knowledge" sentence.

The durable audit with the verbatim search queries and service outcomes is
`notes/2026-08-24-c925-tz-priority-judo-synthesis.md` in the monorepo.

## Claim ledger

| label | claim | proof source | novelty wording |
|---|---|---|---|
| `thm:window` | A unimodular tangent window gives a rational torus quotient of an OADP variety. | Text proof; signed-minor orbit correction. | No priority claim. |
| `prop:slice` | All four Tschinkel--Zhang minimal Picard types admit the saturated rank-three window and a descended good slice. | Exact certificate plus incidence descent. | Complete only within the four types; no claim for all subgroups of `W(D5)`. |
| `thm:level-two` | `S x A2` is rational under the rational-point and stably-permutation hypotheses. | `thm:window`, `prop:slice`, and imported Tschinkel--Zhang/Voskresenskii results. | Stated as a theorem of this paper, without a global firstness claim. |
| `cor:cubics` | Both Tschinkel--Zhang cubic families become rational after `P2`. | Generic-fibre function-field argument. | Direct consequence; their universal-torsor theorem remains an input. |
| `cor:cancellation` | The two cubic threefolds have exact threshold two and yield `Y` nonrational with `Y x A1` rational. | `cor:cubics` plus the cited one-stabilization theorem. | No global firstness claim; the paper notes only the mathematical consequence. |
