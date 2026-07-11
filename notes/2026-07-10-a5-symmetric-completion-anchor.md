# A5 anchor — the most-symmetric on-conic completion is P (value-blind)

**2026-07-10 (Claude).** A5-lane result. Sharpens the (ON) anchor `maxonN(q) ≤ q−5`
(min-witness ≥ 1) from C73's L1 selector into a value-blind statement that survives the q=11
exception L1 fails on. Script: `rust/scripts/a5_exception_orbits.py` (pure parse of the committed
feat dumps + prime-field group theory; no new solves).

## Setup

On-conic child values are **Stab(frame)-invariant**: a projectivity fixing the 5-frame
`{∞, 0, t1, t2, t3}` transports the whole follower game (Lemma I / the full-PGL bridge, now the
Lean theorem `ProjectiveCap.Sym2Bridge.onconic_value_bridge`). So the P/N labels of the `q−4`
on-conic children are constant on orbits of `Stab(frame) ≤ PGL(2,q)` acting on the child
parameters `w ∈ F_q^* \ {t1,t2,t3}`. The orbit structure is **pure group theory** — value-blind.

## Result (measured, all classes, q ∈ {5,7,11,13,17,19})

For every size-3 class, order the on-conic children into Stab-orbits by size:

| q  | classes | smallest-orbit-all-P | smallest-orbit-unique | frame-fixed-point-is-N |
|----|---------|----------------------|------------------------|------------------------|
|  5 |    1    |         1/1          |          1/1           |          0/1           |
|  7 |    3    |         3/3          |          3/3           |          0/3           |
| 11 |    8    |         8/8          |          8/8           |          0/8           |
| 13 |   12    |        12/12         |         12/12          |         0/12           |
| 17 |   21    |        21/21         |         21/21          |         0/21           |
| 19 |   27    |        27/27         |     17/27 (rest all-P) |         0/27           |

q=5,7,13,19 are non-depleted (onP = q−4, every child P) so they only confirm consistency; the
**discriminating tests are the two depleted orders {11,17}**, and both pass with a nontrivial
selection (the anchor picks the rare P out of a majority-N child set). This is the full extent of
available solved per-child data — a third discriminating point requires the gated q=29 census
(q=23/25 were bucket-first, no per-child feat dump).

**Anchor (value-blind form):** the smallest Stab(frame)-orbit of on-conic children is P.
Equivalently — since a singleton orbit is a frame-fixed on-conic point — *whenever the frame
stabilizer fixes an on-conic child, that child is P; otherwise the smallest orbit is P.*
Consequences: **min-witness ≥ |smallest orbit| ≥ 1**, so (ON) holds; and **no frame-fixed
on-conic point is ever N**.

At the depleted orders the smallest orbit is always **unique** (no tie), so the selector is
unambiguous exactly where it must decide:

- **q=17 knife-edge** (cls 2/17/19, onP=1): `|Stab|=4`, children split `Nx4·Nx4·Nx4·Px1` — the
  unique P child **is** the frame-fixed singleton `Px1`.
- **q=11 knife-edge** (cls 4/7, onP=2): `|Stab|=10` (D10), **no singleton**; children split
  `Px2 + Nx5` — the P children are the smallest orbit (the size-5 orbit is the N block). This is
  exactly where C73's L1 (max-incidence secant) picks an N conic point and fails; the smallest-orbit
  anchor does not.
- q=19 is non-depleted (onP = q−4 = 15, every child P), so "smallest orbit all-P" is trivially
  satisfied and the ties are immaterial.

## Why this is progress

- It is a **single, uniform, value-blind existence witness** for an on-conic P child that holds at
  every tested order **including** the q=11 D10 exception — so A5's (ON) target no longer needs a
  separate exception layer at the selector-existence level. L1 needed a q=11 exception; this does not.
- It gives the C68b "P = rare/special" lead a precise, value-blind form: **special = smallest
  Stab-orbit = largest point-stabilizer = most symmetric completion.** (Orbit size = |Stab|/|point-stab|,
  so "smallest orbit" and "largest point-stabilizer" are the same statement.)

## The anchor strictly dominates C73's L1 (cross-check)

For every class, is L1's max-incidence on-conic pick inside the smallest Stab-orbit?

| q  | L1-pick-in-smallest-orbit | disagreements |
|----|---------------------------|---------------|
|  5 |            1/1            | —             |
|  7 |            3/3            | —             |
| 11 |            6/8            | **exactly cls 4, 7** (the knife-edge where L1 fails) |
| 13 |          12/12           | —             |
| 17 |          21/21           | —             |
| 19 |          25/27           | all-P noise (L1 picks a different **P** orbit, never an N one) |

So the anchor and L1 are the **same selector wherever L1 works**, and their only genuine
disagreements are the exact q=11 classes where L1 picks an N conic point and fails. The smallest-orbit
anchor is L1's fix — a strict generalization, not an independent coincidence.

## Mechanism: the point-stabilizer mirror is REFUTED (inverted across the depleted orders)

The natural proof route — "the most-symmetric completion is P because its point-stabilizer contains
a fixed-point-free mirror involution" — is **false**. Point-stabilizer of the P vs N orbits at the
knife-edge classes (`(orbit size, |point-stab|, contains an involution?)`):

| order            | P orbit        | N orbit(s)          |
|------------------|----------------|---------------------|
| q=17 (cls 2/17/19) | (1, 4, **True**)  | (4, 1, False) ×3    |
| q=11 (cls 4/7)     | (2, 5, **False**) | (5, 2, **True**)    |

At q=17 the P child's point-stabilizer has an involution; at q=11 it does **not** (order 5, odd —
the two P points are the fixed points of the order-5 element of the D10 frame stabilizer), and there
it is the **N** children that carry the involution. So "P ⟺ point-stab has a mirror involution" is
**exactly inverted between q=11 and q=17** — the same flip/control failure mode (q=11 small-field
signature dissolving at q=17) that killed the C64/C69 config-invariants, here striking the *mechanism*
rather than an invariant. The only q-uniform statement is the value-blind orbit-size one; **P-ness is
not explained by a static point-stabilizer symmetry.** This is consistent with C64's finding that the
value lives in the full game tree, not the terminal layer.

## Caveats / what is NOT proven (skeptic pass)

- **Measured, not proved.** Discriminating tests are only the two depleted primes {11,17}; the rest
  are non-depleted (all-P, trivially consistent). q=9 is GF(9), skipped (script is prime-field).
  A **new, cleaner anchor conjecture**, stronger than L1 — not a proof.
- **The obvious mechanism is refuted** (§ above): P-ness is not a point-stabilizer mirror involution
  (inverted q=11 ↔ q=17). So the anchor is a value-blind *selector*, not a *proof* of P.
- **Not contradicted by round-1's refutation of "stabilizer-specialness ⇒ P"** — that refutation is
  at the *6-point bucket* level (the q=11 N bucket `{∞,0,1,2,3,4}` carries a V4 and defeats the
  *involutive-completion* selector). This anchor is a different object: the *size-3 frame*
  stabilizer acting on *child completions*, with the *smallest orbit* as the selector. The empirical
  q=11 8/8 is direct evidence this exact statement is not the refuted one — but the mechanism
  inversion above shows *why* the refuted "specialness ⇒ P" implication fails, and warns against any
  Lean statement that reads P-ness off the stabilizer.

## (a′) The P-certificate is adaptive, not a pairing — and the knife-edge strategy is concentrated

Probing the committed reply-book certs (`notes/certs/gridcap-q{11,17}.cert`, C12) via
`rust/scripts/a5_cert_structure.py`. For every class at both depleted orders:

- **pure-pairing = False, fpf-involution = False, node-0-matching = False** — the emitted winning
  strategy is *never* a fixed involution on live cells: replies depend on the node (not the move
  alone), node-0 (move,reply) pairs are not a matching, and a few "sink" replies absorb many moves
  (e.g. q=11 cls 4 node 0: reply `4,2` answers ~7 distinct moves). So the certificate corroborates
  the (b) mechanism refutation **from the actual strategy** — P-ness is amortized/adaptive, not a
  mirror. (Caveat: this is the *emitted* cert, not a proof that *no* pairing strategy exists; but the
  natural symmetry-based pairings — point-stabilizer (b) and live-board fixed involution (here) — are
  both refuted, steering the proof to the amortized route.)
- **Knife-edge signature (quantified):** at the smallest-orbit/knife-edge classes the reply book is
  measurably *more concentrated* than generic classes — distinct node-0 replies **21–25 vs 39–54**,
  max fan-in **13–14 vs 5–11**, i.e. ~2× the reply-reuse per legal move. The rare, forced on-conic P
  child (onP=1 at q=17, the smallest orbit) has a **tighter, more-forced reply structure** — a
  candidate handle for the C61 forced-reply-automaton lane *specifically at the extremal classes*.

This aligns the A5 selector with the program's amortized-potential route: the anchor names the child;
its certificate is adaptive; the concentration signature says the extremal child is where the reply
structure is most nearly forced (most amenable to a finite-state / bounded-selector description).

## Open next steps (reshaped after the mechanism refutation)

The point-stabilizer-mirror proof route is dead, so the anchor does **not** shortcut the open
Good-closure/strategy problem via static symmetry. What it does give:

1. **A value-blind selector for the (ON) obligation** — "certify the smallest-Stab-orbit on-conic
   child." This tells the Cluster-2 open-core / reply-strategy machinery *which* on-conic child to
   build the P-certificate for at every class, replacing L1 (and covering the q=11 exception L1
   missed). Hand this to the C61-successor existential-selector lemma as the target child.
2. **The proof of P-ness stays a strategy problem, not a symmetry problem** — the amortized-potential
   / reply-book route (Cluster 2), now aimed at the smallest-orbit child specifically. The mechanism
   inversion is itself a constraint: any correct P-argument must NOT rely on a point-stabilizer
   involution (q=11 has none on the P orbit).
3. **A third discriminating order (q=29, gated)** remains the only way to test the anchor's
   *predictive* power beyond {11,17}; the mechanism refutation makes this more important, since we
   no longer have a structural reason to trust extrapolation.
