# C528 — residual height and mex-spectrum closure

**Lane:** `cap`. **Task:** C528. **Date:** 2026-07-23.

## Verdict

The apparent bounded-defect signal from the prior census has a much simpler
complete explanation on its stated domain:

> Every frozen q17/q19 `capOVER` residual core has remaining game height at
> most **5**. Therefore its Grundy value is at most **5** by the already-proved
> general height bound.

This exhausts all 349 q17 and 48,084 q19 cores. The q19 result remains true
despite 3–47 active overload gadgets and 14–37 currently legal points because
the legal set is not the game height: secant creation kills most apparent
freedom after each move.

Thus the observed `SG <= 5` is not evidence for a Dawson/path-cycle
decomposition or a q-uniform bounded-boundary theorem. The proposed
whole-residual defect-skeleton target was trying to explain the wrong
quantity. The uniform crown returns to C80's direct question: prove the
depth-2 routing into `Y_NK`, rather than prove a new gadget Grundy calculus.

This is a bounded finite verdict. It proves no height-five theorem for general
odd q and makes no q23 claim.

## Exact height census

The recursion visits every legal continuation from each frozen root. Its
maximum selected-set depth is therefore the exact remaining game height.

| q | roots | exact root-height distribution | maximum SG by descendant depth |
|---:|---:|---|---|
| 17 | 349 | `3^205 4^78 5^66` | `5,4,3,2,1,0` at depths `0..5` |
| 19 | 48,084 | `4^23684 5^24400` | `5,4,3,2,1,0` at depths `0..5` |

The generic height principle was already proved in the C547 package:
`FiniteBuildGame.grundy_le_of_valid_card_bound` bounds SG from a uniform
bound on legal continuation cardinality (and the equivalent direct
game-height induction is recorded in the C528 predecessor report). The table
is the missing domain-specific hypothesis. It explains the full finite
`SG <= 5` observation without assigning values to individual gadgets.

The earlier cap-size bound gave only 9 at q17 and 11 at q19 because it ignored
the root's secant coverage. Exact residual height is the decisive statistic.

## Mex spectra

The root SG distributions reproduce the prior independent census exactly:

```text
q17: 1^5 2^26 3^263 4^52 5^3
q19: 1^20142 2^4629 4^11933 5^11380
```

Only six distinct root option-nimber sets occur at q17 and eight at q19.
Every set has width at most five. The q19 absence of SG 3 has the exact mex
description:

> Every q19 root whose options contain `0,1,2` also has an option of value 3.

Such roots therefore have SG 4 or 5. The remaining q19 roots miss 1 or 2 and
have SG 1 or 2. This is an exact description, not yet a structural geometry
theorem.

The attractive q17 refinement does not survive scale. At q17 every root has

```text
SG in {height, height - 2}
and SG ≡ height (mod 2).
```

At q19 the height-minus-SG distribution is

```text
0^22885 1^428 2^2090 3^12628 4^10053,
```

with 13,056 parity violations. The q17 parity/near-height law is therefore a
small-order artifact, not the missing uniform defect law.

## Cheapest local skeleton is value-impure

For each root move the probe records

```text
(number of incident active triple gadgets, load-one conflict degree).
```

Moves with the same pair routinely have different follower SG values inside
the same root. There are 36 such local signature classes at q17 and 156 at
q19; summed over signature/root incidences, 502 q17 and 163,103 q19 classes
are impure. This rules out the cheapest local defect label. It does not rule
out a richer global incidence quotient, but no such quotient is needed to
explain the finite ceiling.

## Bearing on C80

C528 began from the thought that unbounded static gadget complexity but tiny
SG forced a hidden bounded defect game. The height census removes that
inference:

```text
many legal vertices / many overload gadgets
does not imply
many remaining moves.
```

C524's depth-2 certificate remains the valuable dynamic fact. It already
routes every tested `capOVER` core into the proved `Y_NK` guard without
needing its exact nimber. A uniform proof should therefore target the
responder's routing move and its two-ply incidence consequences directly.
Reconstructing a full SG formula is strictly stronger and no longer
evidence-motivated.

The q23 gate should likewise test the proposed uniform routing lemma (or a
specific structural height statement if one is later derived), not rerun an
unguided SG-ceiling census.

## `ej` upgrade — the `Y_NK` leaves collapse to a two-move graph law

C524's certificate reaches `Y_NK` after exactly three moves from a C528 core:

```text
C --responder r--> G --opponent o--> G+o --responder p--> Y_NK.
```

Since every C528 root has height at most five, every such `Y_NK` leaf has
height at most two. This turns its apparently general Node--Kayles
Grundy-zero check into an elementary graph condition.

Let `H` be the static conflict graph of a `capOK` leaf. Node--Kayles play on
`H` is just independent-set building, so its remaining height is `alpha(H)`.
If `alpha(H) <= 2`, then

```text
SG(H) = 0
iff
H is empty, or alpha(H)=2 and H has no dominating vertex.
```

Indeed, after any move the surviving nonneighbors form a clique. A dominating
vertex gives an option to SG 0; every nondominating vertex gives an option to
the nonempty-clique value 1. Thus a nonempty root is P exactly when every
move has a nonempty clique follower.

Equivalently, writing the condition without Grundy recursion, the final reply
`p` must leave a `capOK` state in which:

1. every three legal cells contain a load-one conflict pair; and
2. every legal cell has a distinct compatible legal partner;

with the terminal empty state allowed separately. In complement-graph
language, the complement is triangle-free and has no isolated vertex.

This is a genuine simplification of C80's tested certificate. The 283 q17
cores of height at most four and all 23,684 q19 height-four cores must in fact
route to terminal leaves after the three certificate moves. Only the 66 q17
and 24,400 q19 height-five cores can use the nonterminal
`alpha=2`/no-dominating alternative.

For general odd q the missing premise is now crisp: either prove the
three-move leaf always has continuation height at most two, or prove the two
displayed bounded-arity incidence conditions directly for the chosen reply.
There are still q-dependent families of instances; “bounded” refers to arity,
not count. This is strictly more proof-shaped than computing an arbitrary
Node--Kayles nimber and is the highest-value handoff from C528 to C80.

## `tt` upgrade — pure one-dimensional continuation, not pairing

The cleanest object is the leaf's continuation complex. Under `capOK`, its
one-skeleton is the compatibility graph: a set of future moves is legal
exactly when it is a clique. Height at most two says this graph is
triangle-free. The no-dominating condition says it has no isolated vertex.
Consequently:

> A height-at-most-two `Y_NK` leaf is P exactly when its continuation
> complex is empty or pure one-dimensional: every maximal nonempty
> continuation has exactly two moves.

This removes two tempting overstatements.

- No perfect matching, Hall theorem, or persistent copycat is required.
  There is only one future response to supply, and it may depend on the
  opponent's move.
- The target is not a bounded table. It has the explicit quantifier shape

```text
exists r, for every o, exists p, such that
  capOK(leaf)
  and
  [leaf is terminal
   or
   (every legal x has some compatible y
    and no three legal cells are pairwise compatible)].
```

In projective-cap language the two bracketed conditions say “every legal
one-point extension has a legal mate” and “there is no legal three-point
extension.” This is the strongest useful C80 transfer: prove a
two-extendable-but-not-three-extendable leaf, rather than a Grundy identity.
It also identifies the right counting input for C82: pointwise mate
existence, not a global matching count.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello/rust
```

Generate and replay:

```text
python3 scripts/c528_mex_skeleton_probe.py
python3 scripts/c528_mex_skeleton_probe.py --check
```

The deterministic run reconstructs the complete frozen residual domains from
the committed q17/q19 C20 inputs, visits 22,607 q17 and 14,825,484 q19 chosen
sets, and records canonical aggregate tables plus a SHA-256 digest of sorted
per-root rows. There is no randomness.

Artifacts:

```text
scripts/c528_mex_skeleton_probe.py
  9,984 bytes
  sha256 5edad2ba5352abca0f97248ede886332fe93119b5aa28536aafc599bcc5ac9de

notes/2026-07-23-c528-mex-skeleton-probe.json
  61,115 bytes
  sha256 779081f4608bfc0d2e4d98e2125d19461ff8c1198cda7f52ed4884def6efb79c
```

Independent checks:

- the root SG distributions agree byte-for-count with C528's earlier full
  residual census, whose direct projective-geometry recursion checked all 349
  q17 roots and a deterministic 100-root q19 slice;
- a separate direct `PrimeGridGame.legal_mask` height recursion checked all
  349 q17 roots and obtained `3^205 4^78 5^66`, exactly matching the static
  rank-three recursion.

There is no second full q19 height implementation. The q19 height claim rests
on the tracked exact rank-three recursion, canonical replay, the already
Lean-checked residual-hypergraph equivalence, and the stated SG cross-check.
The certificate does not cover q23, arbitrary cap positions, or arbitrary odd
q.

## Mystery ledger — ej + tt closeout

- **[SETTLED] Why is frozen q17/q19 SG at most 5 despite up to 47 gadgets?**
  Every root has exact remaining height at most 5; the general SG-height
  theorem applies.
- **[SETTLED negative] Is the q17 law
  `SG in {height,height-2}` with matching parity uniform?** No. q19 has every
  gap from 0 through 4 and 13,056 parity violations.
- **[SETTLED negative] Does
  `(triple-incidence count, pair-conflict degree)` determine follower value?**
  No; it is impure already at q17 and massively so at q19.
- **[SETTLED] Why does SG 3 disappear at q19?** At the exact mex level, every
  root with options `0,1,2` also has option 3. This settles the finite
  enumeration question but does not supply a q-uniform geometry theorem.
- **[OPEN — owner C80] Why does the minimax-free depth-2 routing into `Y_NK`
  work uniformly?** q13/q17/q19 computation supports it; no all-q incidence
  proof exists. The `ej` pass sharpens the target: after the third certificate
  move, prove `capOK` plus terminality or the two-move graph law
  (`alpha=2`, no dominating vertex). The `tt` pass sharpens this again to an
  empty or pure one-dimensional continuation complex, with quantifiers
  `exists r, forall o, exists p`; the conditions are bounded-arity, not
  bounded-count.
- **[OPEN, later falsifier] Does any comparable height bound hold at q23 or
  beyond?** No frozen q23 domain was generated. Test only against a candidate
  theorem, not as an unguided census.

The first `ej` pass exposed exact residual height as the free invariant
already consumed by C547's theorem. The follow-up `ej` pass combined it with
C524's three-move bridge and collapsed every tested `Y_NK` leaf to a
terminal/two-move graph law. The first `tt` pass tested the stronger q17
height-parity pattern at q19 and killed it. The follow-up `tt` pass exposed
the exact quantifier order and the pure one-dimensional continuation-complex
form, ruling out an unnecessary matching/Hall layer. No incidental
discovery-track entry arose: all findings answer C528's planned value-law
question directly.

## Vibe

Decisive closure by premise correction. The spectacular-looking `SG <= 5`
signal is real but not deep on this corpus; exact height explains it. That is
good news for the main program because it removes an unnecessary gadget-SG
theory and points straight back to the cleaner, already certificate-shaped
uniform routing theorem.
