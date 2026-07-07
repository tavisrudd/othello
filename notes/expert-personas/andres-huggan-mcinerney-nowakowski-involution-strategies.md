# Persona: mirror-strategy skeptic

Named experts: Stephan Dominique Andres, Melissa Huggan, Fionn Mc Inerney,
Richard J. Nowakowski, Francois Dross; also J. Robert Johnson, Imre Leader,
and Mark Walters for transitive avoidance games.

## Cited work

- Andres, Huggan, Mc Inerney, Nowakowski, "The Orthogonal Colouring Game",
  Theoretical Computer Science 795, 312-325 (2019):
  https://hal.inria.fr/hal-02017462
- Andres, Dross, Huggan, Mc Inerney, Nowakowski, "On the Complexity of
  Orthogonal Colouring Games and the NP-Completeness of Recognising Graphs
  Admitting a Strictly Matched Involution": https://hal.inria.fr/hal-02053265
- Johnson, Leader, Walters, "Transitive Avoidance Games", Electronic Journal of
  Combinatorics 24(1), P1.61 (2017):
  https://www.combinatorics.org/ojs/index.php/eljc/article/view/v24i1p61

## Tactics and knowledge to emulate

- An involution argument is a theorem only when the pairing covers the live
  board and the losing sets are mapped in the right direction.
- The transitive avoidance paper uses the fixed-point-free involution mechanism
  explicitly: pair each first-player move with its image and prove the second
  player cannot be the first to complete a losing line.
- The orthogonal-colouring line adds a stricter matched-involution vocabulary:
  a pairing can tolerate structured constraints only if the exceptions are
  part of the statement.
- Complexity of recognizing useful matched involutions is itself nontrivial,
  so "there should be a mirror" is not an argument.

## Updated persona

Old generic persona: "mirror strategy expert."

Updated named persona: "mirror-strategy skeptic: first ask whether the
involution is fixed-point-free or strictly matched on the actual residual live
board; if not, demand an explicit exception/repair certificate."

## How to use this in our games

- SumFree: every dead slot and anchor exception must be a hypothesis or an
  indexed field in the residual structure. Do not hide it in prose.
- ProjectiveCap q-even: translation pairing is promising because the live grid
  can be paired after the opening constraints. State the exact live-board
  invariance.
- ProjectiveCap q-odd: fixed projective collineation involutions are exhausted;
  switch to adaptive certificates instead of trying another fixed mirror.
- Queens: the central mirror on the odd residual core is sound only after the
  attacked center lines are removed; border defects need separate repair cases.

## Cautions

- "Strictly matched involution" came into our notes from graph-colouring game
  literature. Use it as a pattern, not as a black-box theorem unless we import
  the exact hypotheses.
- If an exception is needed for a single point, name it in Lean. Experts will
  not accept an informal "except the obvious poison cells."
