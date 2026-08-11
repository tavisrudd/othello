# Paper V alignment-import blind-review addendum

**Artifact reviewed:** `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`  
**SHA-256:** `f96e05078ffb49f8ca72e6089098c7d4f5f8bfa18aa039157346ed47ed48f7a4`  
**Identified commit:** `72904865c0ba27c22b8ef776c0ebf73b5968a402`  
**Review mode:** causal rereview of the final PDF, focused on the normalization-order defect and the six-point alignment import.

## Verdict

**GO.** The normalization-order MINOR is discharged, and the imported alignment lemma now strengthens the paper without diluting its theorem spine.

## Normalization-order repair

The logical order is now correct.

Proposition 2.1 claims only that the Paper-II projection is a metric chordal shadow whose actual cubic is normalized by its first nonzero coefficient. Its proof fixes the pivot scalar and establishes chordal placement. It no longer claims Definition 1.1 normalization.

Proposition 4.1 then takes precisely that coefficient-normalized generator, proves

\[
(q_\Pi-1)h=8c_B,
\]

and explicitly concludes: “In particular, $h$ is normalized in the sense of Definition 1.1.” The proposition's proof uses Proposition 2.1 only for the chordal-line identification and pivot scalar, then obtains the coefficient $8$ by comparison in the one-dimensional anti-invariant line. There is no forward dependency or circularity left.

The sentence in Proposition 2.1 that previews “the outer-difference coefficient is 8” is harmless: it is explicitly a normalization “used below,” not part of Proposition 2.1's conclusion, and Proposition 4.1 supplies the proof.

## Alignment-recognition integration

Lemma 3.4 remains correct, and its scope is now explicit: $S$ is defined as a Seidel matrix with zero diagonal and symmetric off-diagonal entries in $\{\pm1\}$. This closes the convention needed for the step from vanishing pair defects to $S^2=5I$.

The new closing material also gives the lemma a clear job in the series:

- diagonal switching and global complementation are checked, so the aligned family and square identity are shown to be intrinsic to the two-graph up to complement;
- Paper III's seven-point aligned-design faithfulness theorem is named at the exact interface;
- the lemma is identified as the sharp six-point failure locus, namely the unmarked conference locus;
- the recovered $A_5$-action is then stated to select the opposite pair needed by Paper V.

That paragraph resolves the earlier architectural concern. The lemma is not a premise of the selected-line groupoid equivalence, so inserting it as another clause of Theorem 1.2 is no longer necessary and could overload that statement. It now functions as a concise intrinsic-recognition corollary at the correct transition: after the six-set and conference pair are recovered, before outer difference produces the oriented companion. Its prominence in the abstract and conclusion is proportionate to this cross-paper role.

## Rendered check

The revised Proposition 2.1, Lemma 3.4 and Proposition 4.1 pages are cleanly rendered. The added definition and Paper-III bridge do not create crowding, a bad break, or a competing visual branch.

## Final assessment

The import now improves both levels of the paper:

1. conceptually, it characterizes the conference shadow as exactly the six-point information invisible to four-point alignment; and
2. structurally, it connects that failure locus to Paper III while leaving the main equivalence theorem focused on the marked chordal–conference round trip.

No remaining issue in this causal rereview warrants MINOR or MAJOR.
