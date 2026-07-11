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

## Result (measured, all classes, q ∈ {11,13,17,19})

For every size-3 class, order the on-conic children into Stab-orbits by size:

| q  | classes | smallest-orbit-all-P | smallest-orbit-unique | frame-fixed-point-is-N |
|----|---------|----------------------|------------------------|------------------------|
| 11 |    8    |         8/8          |          8/8           |          0/8           |
| 13 |   12    |        12/12         |         12/12          |         0/12           |
| 17 |   21    |        21/21         |         21/21          |         0/21           |
| 19 |   27    |        27/27         |     17/27 (rest all-P) |         0/27           |

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
- It gives the C68b "P = rare/special" lead a precise mechanism: **special = smallest Stab-orbit =
  most symmetric completion.** Candidate proof mechanism (unproven): the most-symmetric completion
  has the largest point-automorphism group, giving the second player the richest pairing/mirror
  structure — consistent with the program's fixed-point-free-involution theme, but it is a game-value
  claim, not yet a theorem.

## Caveats / what is NOT proven (skeptic pass)

- **Measured, not proved**, and only at the four primes with committed feat dumps (q=11,13,17,19).
  q=25 is all-P (trivially consistent); q=5,7 non-depleted; q=9 is GF(9), skipped (script is
  prime-field). This is a **new, cleaner anchor conjecture**, stronger than L1, not a proof.
- **Not contradicted by round-1's refutation of "stabilizer-specialness ⇒ P"** — that refutation is
  at the *6-point bucket* level (the q=11 N bucket `{∞,0,1,2,3,4}` carries a V4 and defeats the
  *involutive-completion* selector). This anchor is a different object: the *size-3 frame*
  stabilizer acting on *child completions*, with the *smallest orbit* (not "has nontrivial stab")
  as the selector. The two are not the same statement; the empirical q=11 8/8 here is direct
  evidence this exact statement is not the refuted one. Still — the overlap in vocabulary is a
  warning: state the exact object in any Lean form.
- The game-value reduction (why the smallest-orbit completion is P) is the open lemma; the
  most-symmetric completion is a *candidate* P-witness, not a proven mirror. Do not claim P from
  symmetry without the pairing certificate (mirror-strategy-skeptic persona).

## Open next steps

1. **Extend the measurement** — confirm the anchor at the next order with solved on-conic data,
   and (decisively) at the next *depleted* order if a q=29 census is gated and run.
2. **Prove the game-value lemma** — "the smallest Stab(frame)-orbit completion is P" — via the
   point-stabilizer pairing structure (the size-2 D10 orbit at q=11 cls 4/7 has point-stabilizer
   order 5; the q=17 singletons have the full order-4 frame stabilizer). This is the A5 proof
   target that would close (ON) uniformly.
3. **Reconcile with L1 / C73** — the smallest-orbit anchor and L1 agree everywhere except the q=11
   knife-edge; characterize the L1 tie (D10 ⇒ 5 tied lines) against the D10 orbit split to see
   whether L1's failure is *exactly* "the incidence extremum tracks a large orbit, not the small
   one."
