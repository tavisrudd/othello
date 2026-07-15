# C128 — exact mod-11 Klein forms and kernel-checked syzygy

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: REPORTED. The exact coefficient reduction and syzygy are certified; the decorative
Klein section was removed under C167 because its group/diagonal claims had no durable checker.

## Verdict

The polynomial claim is correct. In Klein's normalization, after setting `z₂=1`, the integer forms
used by the prior C125 computation are

\[
\begin{aligned}
 f&=x(x^{10}+11x^5-1),\\
 H&=-(x^{20}+1)+228(x^{15}-x^5)-494x^{10},\\
 T&=x^{30}+1+522(x^{25}-x^5)-10005(x^{20}+x^{10}).
\end{aligned}
\]

Their canonical coefficientwise reductions in `F₁₁[x]` are

\[
\begin{aligned}
 \bar f&=x^{11}-x,\\
 \bar H&=10x^{20}+8x^{15}+x^{10}+3x^5+10,\\
 \bar T&=x^{30}+5x^{25}+5x^{20}+5x^{10}+6x^5+1.
\end{aligned}
\]

Lean proves both the exact integer identity

\[
 H^3+T^2=1728f^5
\]

and, after applying the coefficient-reduction ring homomorphism and checking `1728=1` in `F₁₁`,

\[
 \bar H^3+\bar T^2=\bar f^5.
\]

The module also proves that the literal reduced polynomials equal the three displayed canonical
forms. This is stronger and less ambiguous than checking only a final expanded coefficient list.

## Durable artifact and validation

- Source: `lean/RelativeConicArcs/Q11KleinSyzygy.lean`.
- SHA-256: `c5676eaf5c5a245681276cc09dcd7649d9ac154187e1c44e5e7641863626ba77`.
- Validation:

  ```text
  choom -n 1000 -- nix develop --command lake env lean \
    RelativeConicArcs/Q11KleinSyzygy.lean
  ```

- Result: exit 0.
- Axiom audit printed by the module:

  ```text
  syzygy11 depends on axioms: [propext, Classical.choice, Quot.sound]
  ```

There is no `sorryAx` and no `native_decide`; `ring` constructs ordinary kernel-checkable proof
terms, and finite scalar equalities in `ZMod 11` use `decide`.

## Trust boundary

The certificate proves the transcribed one-variable integer identity, the coefficientwise map to
`ZMod 11`, the exact canonical reduced forms, and the reduced identity. It does **not** prove:

- that the transcribed normalization agrees with the cited Klein/Nash source;
- the passage from dehomogenized identities back to homogeneous binary forms (mathematically
  immediate here because both sides are homogeneous of total degree 60, but not encoded);
- `A₅` invariance, squarefreeness or root loci of the forms;
- faithful reduction of an integral icosahedral group model;
- the sextic-resolvent/diagonal/chord/pole identification.

Those last finite claims were previously reported from a scratchpad script only. A kernel check of
the syzygy cannot be used as evidence for them.

## Session-provenance audit

The user-requested `asg +show 9b212ae1` audit confirms the day's general provenance warning:
session computations were explicitly described as living in scratchpads and needing promotion.
The detailed C125 note points to
`/tmp/.../scratchpad/c125_klein_mod11.py`; despite saying the script was reproduced, it preserves
only a transcript, not executable source. The related subagent session was `32d73511`. Therefore the
old group order, conjugator, diagonal pairs, root-locus, and pole claims were not Git-durable.

The same full-session grep also records the corrected `252` history: the claim “all 252 six-arcs on
a conic” was explicitly retracted to `924` six-subsets, while `252` remained valid for the local
one-point perturbations. C165 and C171 now supply independent tracked checkers for the surviving
uses; C168 supplies the distinct frame-normalized concyclic count and histogram.

## Prime framing and manuscript disposition

The queue described a contradiction between “11 is prime to 60” and an exceptional-prime-dividing-
the-group framing. The literal contradiction had already disappeared from the current manuscript:
`11 ∤ 60`, and the mod-11 coincidence is exceptional because the coefficient 11 vanishes and the
12-point vertex divisor fills `PG(1,11)`, not because 11 divides `|A₅|`.

C167 removed the standalone Klein section and its abstract promise. That is the correct submission
posture: the certified syzygy is true but not load-bearing for the rigidity theorem, while the
section's more interesting group/diagonal assertions still lacked durable evidence. The certificate
remains a reusable exact artifact for a historical follow-on or a later short remark.
