# C294 B3: change-of-coordinates strategy

**Date:** 2026-07-18

**Lane:** `crowns`

**Status:** E0 passed; task-local `E1`, the fixed-prefix relevance/ledger audit for `R`, is next,
not a larger value run or another generic separator-closure enlargement

## Decision

The recursive-separator program has reached its useful stopping point. Its replacement theorems
and exact kernels remain valid, but the measured live gain is too small to make generic closure
enlargement the default B3 strategy:

| signal | measured result |
|:--|--:|
| completed fixed-prefix absolute keys | 84,964 |
| labelled-core isomorphism removals | 943 |
| genuinely new transition mergers | 3 |
| compressed classes | 84,018 |
| phase-two learned hits | 681,569 |
| compressed versus exact traversal difference | none |
| compressed value classes avoided among touched classes | 66 |
| q=5 type-0 follower value | unknown |

The progress from 24 to 30 live vertices is explained completely by exact checkpoint reuse. It is
not evidence that the current separator congruence is approaching the 116-vertex follower.
Accordingly:

- do not raise the 100,000-state replay cap or repeat the ten-million-state run;
- do not enlarge piece size, separator count, or recursive closure without a new structural
  generator and a fixed-prefix gain first;
- retain the exact component, one-port, two-port, normal-form, and dictionary code as a falsifier
  and certificate kernel; and
- move from arbitrary residual-graph coordinates to coordinates supplied by the coloured Cayley
  geometry of the scar.

This is a strategy decision, not a new computational result. All displayed measurements are from
the tracked recursive-normal-form and two-phase dictionary bundles.

## Two distinct proof tracks

The pivot must not silently confuse exact value with outcome.

### Track V: exact-value quotient

A Track-V coordinate must preserve exact nimbers under a proved, scar-relevant composition law.
It can pass the existing B3 gate by returning the type-0 follower nimber and then the remaining six
values. Equality on a training census is not a replacement theorem.

### Track O: direct outcome certificate

A Track-O coordinate may forget nimbers and retain only enough information for a closed P/N
strategy. A P-template must supply a certified response to every legal move; an N-template must
supply one certified move to a P-template. Detached components and xor cannot be summarized by
P/N labels unless the certificate handles their interaction explicitly.

A successful Track-O certificate could cross the Crown-I silver outcome boundary while leaving the
exact follower nimber unknown. It would therefore trigger an explicit decision to narrow or revise
the B3 exit statement; it does not, by itself, satisfy the current exact-value gate.

## Coordinate foundation `C0`: coloured chambers, determinant sheets, and pair cycles

Keep the three Cayley generators coloured. A vertex is a group element `g`, and a colour-`i` edge
records the move from `g` to `s_i g`. The generator colours retain structure erased by abstract
graph isomorphism:

1. the square/nonsquare determinant character gives the two `PSL2` cosets;
2. each generator records whether its edge preserves or crosses those determinant sheets;
3. each pair `s_i,s_j` generates alternating cycles governed by the product order; and
4. the orbits of `<s_i,s_j>` give repeated, group-aligned blocks coupled by the third edge colour.

For determinant pattern `001`, the structural prediction to certify is two sheet-preserving edge
colours and one cross-sheet matching. The `011` types have a different coupling pattern and must
remain distinguished. The pair-order collision between types 2 and 3, and the determinant-class
distinction between the `(3,4,6)` types, are mandatory tests that the coordinate has not forgotten
the full/subfield boundary.

This coordinate is useful only if a mechanism below exploits it. A full coloured adjacency word,
or a complete Fourier transform of the live mask, is merely an expensive recoding.

## `E0`: bounded structural audit

Before writing another solver, create
`2026-07-17-c294-b3-coordinate-audit.{py,json,md,sha256}`. It should perform no game recursion and
emit, for type 0 and structural metadata only for the other six hard types:

- generator determinant bits and pair-product orders;
- sizes and coset counts of every `<s_i,s_j>` subgroup;
- alternating-cycle lengths and the third-colour matching between pair-cycle blocks;
- determinant-sheet transitions of every edge colour;
- the identity follower's deleted neighbourhood in all three coordinate systems;
- orbit counts of blocks, matching edges, and initial defects under the colour-preserving
  stabilizer; and
- a certified elimination ordering, with its maximum live vertex boundary, for each natural
  pair-cycle block order. A heuristic ordering is allowed as discovery output, but its width must
  be checked directly.

The audit must reconstruct the emitted coloured graph and compare its uncoloured adjacency with
the pinned generator output. A separately organized replay checks determinant transitions, pair
cycles, subgroup/coset partitions, and the claimed elimination widths.

`E0` is a routing experiment, not a value attempt. It chooses which of `R`, `A`, and `T` below is
cheap enough to try. Do not optimize the audit or extend it to a state census.

## Alternative `R`: scar-restricted typed contextual equivalence

### Change of coordinates

The B1 and two-port interfaces are congruences for arbitrary finite contexts. That strength is
sound but apparently much too discriminating. Replace an untyped arbitrary port by a typed port
recording generator colour, determinant sheet, pair-cycle orientation, and the allowed local
constructor in the selected Cayley scar.

Define the smallest equivalence stable only under the finite gluing/deletion grammar actually
generated by these typed chambers. This is a Myhill--Nerode-style coordinate for the scar, not a
claim of equivalence in every graph context.

### Proof obligation

Prove replacement by induction over the typed scar grammar. Every constructor must preserve the
equivalence, and the grammar must reconstruct every residual use admitted by the live solver. A
finite partition learned from values is only a conjecture until this closure check passes.

### Cheap falsifier and promotion gate

Use q=3 and the existing q=5 100,000-state prefix; generate no deeper states. Compare against the
labelled-core isomorphism baseline and report genuine cross-exact mergers separately.

- Stop on the first nimber conflict for Track V or failed response-closure obligation for Track O.
- Stop if the typed grammar needs essentially the whole absolute key to be closed.
- Promote to a live replay only if it removes at least 1% of the 84,964 fixed-prefix classes beyond
  the 943 known isomorphism removals, with zero relevant conflicts. This means at least 850 new
  classes removed, not another single-digit merger count.
- Open a larger value-run discussion only if the compressed 100,000-new-state replay reduces fresh
  connected evaluations or decompositions by at least 10% against the exact dictionary control,
  or returns an independently checked type-0 value within that fixed budget.

`R` is the first Track-V experiment because it directly tests whether the universal-context
requirement, rather than separator scarcity, is the source of over-refinement.

## Alternative `A`: adaptive group-frame response automaton

### Change of coordinates

Represent a position by a movable group frame plus a bounded defect record, rather than by its
exact residual mask. A frame may select a determinant-sheet identification, a pair-cycle
orientation, and one member of a finite palette of group-aligned matchings or block decompositions.
The defect records the local places where the current position departs from the frame.

After an opponent move, the response may both repair defects and switch to another certified
frame. This is not another fixed mirror: it does not require the intermediate residual to possess
a fixed-point-free involutory automorphism. The existing four-ply obstruction therefore remains a
mandatory adversarial corpus, but it does not logically exclude this mechanism.

### Proof obligation

Compile a finite response automaton whose nodes are symbolic P-templates. For every legal move
orbit from every template, record a legal response and a checked successor template. Every cycle
in the automaton must decrease live vertices after the opponent/response pair; termination then
comes from the finite board rather than an unproved ranking heuristic.

The exact graph kernel checks expansion of templates, move legality, coverage of all move orbits,
successor membership, and the initial follower. A separate checker must replay the emitted finite
certificate without trusting the synthesizer.

### Cheap falsifier and promotion gate

First synthesize only against the already tracked distance-three/four-ply residual corpus. Freeze
the frame palette, defect bound, template limit, and transition limit before synthesis; do not raise
them after a failure in the same experiment.

- Stop if frame switching merely stores an absolute residual mask or a growing exception table.
- Stop if any corpus move lacks a response within the frozen template language.
- Promote only when the initial type-0 follower is covered by a finite template family and the
  exact checker closes every legal move orbit, not merely the training corpus.

`A` has the highest theorem leverage because it seeks only the required P/N mechanism. A success
must be reported as Track O unless the automaton is strengthened to recover exact nimbers.

## Alternative `T`: transfer over algebraic blocks

### Change of coordinates

Choose one pair subgroup `<s_i,s_j>` and treat its cosets as alternating-cycle blocks. The third
edge colour supplies a fixed matching between vertices of those blocks. Eliminate whole blocks and
record the exact game interface on the still-live matching ports. This is a transfer system aligned
with repeated group geometry, rather than a search for arbitrary small graph separators.

The determinant-sheet decomposition is a second possible block system. For `001`, test whether the
single cross-sheet colour makes a two-layer transfer smaller than any pair-cycle order. For `011`,
do not assume that the same direction is useful.

### Cheap falsifier and promotion gate

`E0` must come first. Do not build a transfer solver if every natural elimination order exposes
more than 16 live vertex ports, or if block interfaces are almost all distinct on the fixed prefix.
If one direction passes that gate, construct its exact local transition algebra on q=3 and then on
the existing q=5 prefix.

Promote only under the same 1% fixed-prefix and 10% live-replay gates as `R`. A small quotient graph
with a large port boundary is a failure, not evidence for increasing the transfer width.

## Alternative `S`: coloured-face defect syndrome

### Change of coordinates

Treat the alternating two-colour cycles as faces of a chamber complex. Record localized defect
words and low-dimensional syndromes: determinant-sheet imbalance, face-boundary parity, run types
around each pair cycle, and incidence of defects shared by two face colours. A move changes only a
bounded neighbourhood of these features.

This route seeks a potential or repair law for `A`; it is not authorized as a pruning signature.
Counts or parities that merely correlate with P/N outcomes prove nothing.

### Cheap falsifier and promotion gate

Enumerate a fixed, preregistered feature family on the q=3 control, the completed q=5 prefix, and
the four-ply obstruction corpus. Report minimized equal-feature/different-value witnesses.

- Discard any Track-V syndrome at its first nimber conflict.
- Discard a Track-O syndrome unless it supports a closed response rule on every checked move orbit.
- Stop refinement if the syndrome requires more than half as many classes as the exact key while
  still lacking closure.

Only a syndrome that yields a small exact update law and a response or replacement theorem may
graduate into `A` or `R`.

## Alternative `F`: low-dimensional group-algebra probe

As a last discovery probe, project the indicator of played centres or deleted chambers onto a
small preregistered collection of group modules: the determinant character and permutation
modules coming from the audited coset actions. Translation of a move then has an exact linear
update before the nonlinear legality check.

The goal is a conserved syndrome, monotone defect, or equivariant reply selector. Do not use a
black-box classifier, optimize feature weights against the answer labels, or retain enough
coefficients to reconstruct the 120-bit mask. Any useful relation must be stated algebraically and
checked by the exact response kernel. If the probe does not produce such a relation on the fixed
corpora, close it as a bounded negative.

## Ordered experiment plan

1. **`E0` structural audit.** Certify the coloured sheet/cycle/coset coordinates and measured
   interface widths. No game recursion.
2. **One cheap Track-V pilot, `R`.** Minimize the typed scar grammar on the existing q=3/q=5
   completed states. Do not write a live solver unless the 1% genuine-reduction gate passes.
3. **One cheap Track-O pilot, `A`.** Use the `E0` frame palette and the existing four-ply corpus to
   seek a closed adaptive response language. Freeze its bounds before synthesis.
4. **Select at most one implementation route.** If `R` clears its gate, run the matched exact versus
   compressed 100,000-state replay. If `A` closes, emit and independently check the finite response
   certificate. Use `T` only when `E0` gives a boundary of at most 16 ports and neither earlier
   mechanism already dominates it.
5. **Use `S` or `F` only to generate a theorem candidate.** They are bounded discovery probes, not
   fallback ways to accumulate more state features.
6. **Stop explicitly if every route fails.** Record the minimized obstruction for each coordinate,
   leave the ten-million gate closed, and reconsider the silver theorem statement or shift effort
   to the independent Crown-II pilot. Do not return automatically to generic closure enlargement.

## Comparison protocol

Every computational pilot uses the same pinned graph conventions, q=3 control, q=5 type-0
100,000-state training prefix, and 100,000-new-state exact-dictionary replay. It must report:

- what information the coordinate forgets and the theorem that makes forgetting sound;
- total and genuine cross-exact mergers, with known graph-isomorphism removals separated;
- exact-value conflicts or response-closure failures and a minimized first witness;
- coordinate construction work, dictionary hits, new connected evaluations, decompositions,
  stop frontier, and returned value;
- a matched exact control in the same executable or an independently checked request trace; and
- canonical artifacts, hashes, replay commands, and an independent checker under the repository's
  evidence-bundle rules.

The live promotion threshold is a measured reduction against the exact checkpoint control, not a
smaller serialized dictionary, a larger frontier caused by spending more states, or a high count of
same-absolute-key hits.

## Immediate handoff

E0 is complete in `notes/2026-07-17-c294-b3-coordinate-audit.md`. Follow the serial queue in
`notes/2026-07-18-c294-relevance-ledgers-and-hybrid-mechanisms-brainstorm.md` and implement only
`E1`. Replay the existing q=3 control and fixed q=5 prefix without generating deeper states; measure
proof-DAG relevance, duplicate mex information, exact xor cancellations, bottom-up terminal parity,
actual `02` frontier records, local defect motifs, and the maximum possible class-reduction headroom
of each proposed typed coordinate. Emit the `notes/2026-07-17-c294-b3-relevance-ledger.*` evidence bundle with an
independent replay. Do not implement `E2` unless one candidate has headroom for 850 genuinely new
removals. The adaptive automaton, transfer, value solver, separator-cap increase, all-seven value
run, Lean work, and cross-lane edits are not part of `E1`.
