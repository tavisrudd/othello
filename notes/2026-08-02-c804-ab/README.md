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

The surrounding text, including the Tan sentences, is identical in both, so the
comparison isolates the one change. The companion demotion of the Tan
concession is gated on a separate atlas computation and is not part of this
A/B.

## Reader protocol

The reader must not have seen the manuscript or the adversarial pass, must be
given the two versions unlabelled and in an order they are not told, and must
not be told which is the current text. They answer two questions:

1. Which version presents the stronger contribution, and why?
2. Is version B's specialization claim correct? Attack it as a referee would:
   does the criterion cited really imply case (iv) at the stated parameters,
   does case (iv) assume anything the criterion does not supply, and does the
   passage claim anything about their Theorem 1 that it should not?

The second question decides adoption. A version that wins on preference and
loses on correctness is discarded, not softened.

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
