# Paper III: Lean results stronger than the manuscript claim

**Lane:** `clebsch`
**Date:** 2026-08-03 (running ledger)

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
| `AlignedTwoGraph.exists_monochromatic_triple` | `R(3,3) = 6` kernel-checked, with no symmetry hypothesis, reading only increasing pairs | cites `R(3,3)=6` as a classical input, and the priority ledger records it as classical | harvest on the trust side only: the result stays classically attributed in `literature-boundaries.md`, while the trust manifest and formal map must stop listing it as an external human input |
| `AlignedTwoGraph.exists_alignedAnchor` | anchor existence with no supplied monochromatic triple | the proof supplies the anchor by citing Ramsey | harvest: OPER-4's "deterministic anchor discovery" becomes fully formal |

Convention: a Lean proof being more general never licenses a novelty or
priority claim, and never changes the paper's attribution of a classical
result. Strength recorded here is mathematical scope and proof mode only.
