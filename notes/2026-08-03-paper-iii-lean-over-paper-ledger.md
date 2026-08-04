# Paper III: Lean results stronger than the manuscript claim

**Lane:** `clebsch`
**Date:** 2026-08-03 (running ledger)
**Task:** C815

Formalization repeatedly proves more than the manuscript states: a hypothesis
turns out to be unused, a statement holds over a larger ring or quantifier
range, or an input the paper cites as classical becomes kernel-checked. Paper I
hit this many times. This ledger records every such case for Paper III as it
appears, so that the manuscript can harvest the extra strength deliberately
rather than losing it.

Each row records what Lean proves, what the paper claims, and the disposition:
`harvest` means the manuscript should be strengthened by its owning task,
`keep-local` means the extra strength is reusable API with no manuscript
consequence, and `pending` means the comparison is not yet settled.

| Lean declaration | Lean proves | Manuscript claims | Disposition |
|---|---|---|---|
| `FourShadowRecognition.exists_scalar_mul_self_of_offDiagonal_zero` | the scalar-square conclusion without using symmetry or a vanishing diagonal | states the converse for symmetric zero-diagonal matrices | keep-local; the module docstring already records that both hypotheses are unused |
| `FourShadowRecognition.cubicsProportional_smul_iff` | recognition is invariant under any nonzero common edge scale, over an integral domain | no scale-invariance statement | pending: C816 decides whether the recognition packet enters the manuscript with this clause |
| `FourShadowRecognition.exists_mul_self_eq_scalar_of_cubicsProportional` | the weighted converse over an arbitrary integral domain | the paper works over `Q(sqrt 5)` and the integers | pending: same promotion decision |
| `AlignedTwoGraph.exists_monochromatic_triple` | the six-point bound `R(3,3) ≤ 6` with no symmetry hypothesis on the colouring, reading only increasing pairs | cites `R(3,3)=6` as a classical input, and uses only the upper bound | harvest on the trust side only: the result stays classically attributed in `literature-boundaries.md`, while the trust manifest and formal map stop listing it as an external human input |
| `AlignedTwoGraph.no_monochromatic_triple_five` | the sharpness half, by the pentagon colouring, so the six-point threshold is exact | the manuscript never needs or states sharpness | keep-local; it is what makes the paired statement the equality rather than the bound |
| `AlignedTwoGraph.exists_alignedAnchor` | anchor existence over an arbitrary type, with an unconstrained six-point family and an ordered index triple, and no supplied monochromatic triple | the proof supplies the anchor by citing Ramsey, on a finite labelled vertex set | harvest: OPER-4's anchor step becomes fully formal. Distinctness of the six points and their separation from the root remain caller obligations, so "deterministic search" and its twenty-test cost are still human |
| `FourShadowRecognition.pairTriangleSum_eq_zero_of_triangleCubic_translate` | vanishing pair moments from translation invariance alone, without proportionality of the two cubics | the human theorem derives translation invariance from proportionality | keep-local; it covers matrices whose two cubics are not proportional at all |
| `FourShadowRecognition` algebraic core (`matchingEvaluation_smul`, `triangleCubic_smul`, `triangleMixedDifference_eq_pairTriangleSum`) | holds over any commutative ring, with the integral-domain assumption explicitly omitted | the paper argues over a field | keep-local |
| `ClebschGoldenConference.conferenceMatrixOver_sq`, `conference_pairTriangleSum_eq_zero` | hold over every commutative ring, including characteristics 2 and 5 where `5 • 1` degenerates | the manuscript's argument forms `(I ± C/√q)/2` and speaks of eigenvalues, so it is characteristic-zero | keep-local; the degenerate characteristics carry no geometric content for the paper |
| `ClebschGoldenConference.conference_triangleCubic_translate` | translation invariance for every commutative ring, every argument, and every shift | the manuscript descends along the all-ones direction only | keep-local |
| `ClebschGoldenConference.triangleSign_switch`, `triangleCubic_switch` | assume only that each switching entry squares to one, not that it is `±1`, over any commutative ring | the manuscript switches by sign matrices | keep-local; admits strictly more switchings than the paper needs |
| `ClebschGoldenConference.triangleSign_four_point` | uses neither the zero diagonal nor `±1` entries, only symmetry and unit squares off the diagonal, for pairwise distinct labels | the manuscript states it for conference signings | keep-local |
| `ClebschGoldenConference.pairTriangleSum_eq_zero` | holds with `C * C = a • 1` for an arbitrary scalar, the value playing no role off the diagonal | the manuscript uses `q = 2d - 1` | keep-local |
| `ClebschGoldenConference.pairTriangleSum_eq_mul_mulApply` | needs symmetry alone: no zero diagonal, no unit entries, no conference equation | the manuscript works inside the conference setting | keep-local |
| `ClebschGoldenConference.sq_eq_five_of_pairTriangleSum_eq_zero` | the converse over any commutative ring, with no reality or characteristic assumption; all four hypotheses genuinely used | the manuscript argues over the reals | pending: relevant if C816 promotes the recognition packet |
| four-shadow orientation route as a whole | kernel reduction only; the compiled evaluator left the trust base | the manuscript does not describe the method | harvest into the verification section when C816 promotes the recognition packet |

Convention: a Lean proof being more general never licenses a novelty or
priority claim, and never changes the paper's attribution of a classical
result. Strength recorded here is mathematical scope and proof mode only.
