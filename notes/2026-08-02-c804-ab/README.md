# C804 blind A/B: the local-dimension-two positioning paragraph

Two versions of one passage of `papers/ame_lu/sections/01-introduction.tex`
(currently lines 108–119), which positions the paper's LU-to-LC theorem against
Van den Nest, Dehaene and De Moor. Neither is adopted. The adversarial pass that
gates the reframing is `notes/2026-08-02-c804-specialization-inversion.md`; it
returned survive-with-amendments, and version B implements those amendments.

- `version-a.tex` — the committed wording, frozen verbatim as the baseline.
- `version-b.tex` — the reframing: the marginal-cover criterion presented as a
  free-standing rigidity criterion at every local dimension, of which their
  case (iv) is the fully entangled local-dimension-two stabilizer
  specialization, with their Theorem 1 conceded and the prime-power analogue of
  Theorem 1 posed as open.

**Version B was rewritten on 2026-08-02** and now rests on the recognition-group
criterion of `notes/2026-08-02-c804-recognition-group-criterion.md`, which has
their Theorem 1 as well as case (iv) as specializations and holds at every local
dimension. It is written as if that criterion has been adopted into Section 3,
under the labels `prop:partial-weyl-marginal` and `cor:recognition-generation`.
**That adoption is a scope decision the user has not taken.** If it is refused,
version B does not compile and the A/B cannot run in this form.

Version B also depends on C807 (`notes/2026-08-02-c807-recognition-group-novelty-audit.md`),
which supplies the three citations it carries and the wording constraints it
obeys: "unifies" rather than "generalizes" at local dimension two, Jennrich by
way of Harshman plus Kruskal for the axis lemma, and Chang and Jing for the
tensor-uniqueness method. The bibliography entries are in
`papers/ame_lu/refs.bib`.

The surrounding text, including the Tan sentences, is identical in both, so the
comparison isolates the one change. The companion demotion of the Tan
concession is gated on a separate atlas computation and is not part of this
A/B.

## Reader protocol

The reader must not have seen the manuscript or the adversarial pass, must be
given the two versions unlabelled and in an order they are not told, and must
not be told which is the current text. They answer two questions:

1. Which version presents the stronger contribution, and why?
2. Is version B's subsumption claim correct? Attack it as a referee would.
   Does the criterion cited really have their Theorem 1 as its
   local-dimension-two stabilizer case, or only their Corollary 1 case (iv)?
   Does their theorem assume anything the criterion does not supply — in
   particular, is the transfer of the hypothesis to the second state accounted
   for, and is the full-entanglement condition needed? Is the "unifies, not
   strengthens" concession at local dimension two accurate, or is it either too
   generous or not generous enough? Are the three attributions carrying the
   weight the passage puts on them?

The second question decides adoption. A version that wins on preference and
loses on correctness is discarded, not softened.

The reader is given the two passages only. They are not told which is current,
which is ours, or that an audit exists — the audit's conclusions are the thing
under test, not an input to the test.

## Accompanying edits if version B is adopted

1. `03-lu-rigidity.tex`, Corollary `full-weyl-cover`: repair the party
   relabelling wording. As written it compares `ρ^φ_S` while allowing a
   permutation `π`; the operator to compare is `ρ^φ_{π(S)}`, or the corollary
   should be stated for a fixed labelling with the permutation absorbed first,
   as the proof of Theorem `lu-lc-rigidity` already does.
2. `03-lu-rigidity.tex`: add the step-by-step reduction as a remark after the
   corollary — the identification of `A_ω = 3` with the full-Weyl condition, the
   transfer to the second state by invariance of minimal supports under local
   unitaries, and the `|ω| ≥ 4` arity check. The introduction states the claim;
   the remark carries the check.
3. Any manuscript sentence quantifying the local-dimension-two overlap needs the
   standard four-qubit nonexistence and six-qubit existence citations. Version B
   deliberately makes no such statement, so this applies only if that
   observation is adopted later.
4. Section 3 must carry the criterion itself under the two labels version B
   cites, and the finiteness corollary, if stated, must be scoped above local
   dimension two with Englbrecht and Kraus cited (C807).
5. The Jennrich attribution for the axis lemma is already committed
   (`a742efca`) and is independent of this A/B.
