# C80 — secant-barrier survival and `Y_NK` absorption

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-24.

## Verdict

The proposed barrier split does not by itself prove the C80 descent.  The
secant deficit

```text
δ_q(s) = max(0, q - binom(s,2))
```

is a necessary-size clock for `capOK`, not a phase transition into `Y_NK`.
Past `δ_q(s)=0`, a cap can still be very far from `capOK`; even a post-barrier
`capOK` state can be N rather than P.

There is nevertheless a clean theorem hiding behind the proposal.  The total
capacity-two overload

```text
Ω(S) = Σ_{ℓ disjoint from S} max(0, |L(S)∩ℓ| - 2)
```

is monotone under every move, and whenever `Ω>0` the mover can make it
strictly decrease by playing any legal point on an overloaded line.  Thus
`capOK` (`Ω=0`) is always geometrically reachable, without using the secant
barrier.  What this does **not** control is the bit that matters:

```text
Grundy(G_S) = 0.
```

Consequently the requested “P-preserving survival, then absorption” is
equivalent to the original game-value problem unless a value-independent
controlled family and a response-closure lemma are supplied.  Calling the
intermediate states P-preserving merely assumes the missing theorem.

The corrected C80 target is one structural lemma:

> Find a value-independent family `F` containing the chosen escape child such
> that `F∩{Ω=0} ⊆ Y_NK`, and from every `S∈F` with `Ω(S)>0`, every opponent
> move has a reply returning to `F` with strictly smaller `Ω`.  When the
> opponent has not already lowered `Ω`, the reply may be taken on an
> overloaded line.

Induction on `Ω` would then prove every state in `F` is P.  The old barrier
clock remains useful only as the size-only fact that `δ_q(s)>0` forces
`Ω(S)>0`; it does not supply `F` or the reply.

## 1. Overload is the exact absorption coordinate

Let `A` be the full selected projective cap (including the two frame points),
and let

```text
L(A) = {x : A∪{x} is a cap}.
```

A capacity-two line is a line `ℓ` disjoint from `A`.  Put

```text
m_A(ℓ) = |L(A)∩ℓ|,
Ω(A) = Σ_{ℓ∩A=∅} max(0, m_A(ℓ)-2).
```

Then

```text
Ω(A)=0  iff  capOK(A).
```

### Lemma 1 — monotonicity

If `x∈L(A)`, then

```text
Ω(A∪{x}) ≤ Ω(A).
```

**Proof.**  Legal loci only shrink:
`L(A∪{x})⊆L(A)`.  A line disjoint from `A∪{x}` was already disjoint from
`A`; adding `x` creates no new capacity-two line.  On every surviving
capacity-two line the legal-point count therefore weakly decreases, while
every line through `x` disappears from the sum.  Each summand and the index
set can only decrease. ∎

### Lemma 2 — strict controllability

If `Ω(A)>0`, there is a legal move `x` with

```text
Ω(A∪{x}) < Ω(A).
```

Indeed, choose an overloaded capacity-two line `ℓ`, so
`m_A(ℓ)≥3`, and take any `x∈L(A)∩ℓ`.  After playing `x`, the line `ℓ` is no
longer disjoint from the selected cap, so its positive contribution
`m_A(ℓ)-2` vanishes.  Lemma 1 says no other contribution increases. ∎

### Corollary — geometric absorption

From every cap there is a legal continuation to `capOK`; a mover who, on
each of their turns, chooses a point on an overloaded line forces `Ω` to
drop on every such turn.  If play terminates first, the terminal state has
empty legal locus and hence `Ω=0`.

This is stronger than “post-barrier absorption into `capOK`”: it holds both
before and after the barrier.  It is weaker than absorption into `Y_NK`,
because `Y_NK` additionally requires `Grundy(G_A)=0`.

## 2. The secant barrier is not sufficient

The implication proved in the obstruction note is one-way:

```text
capOK(A)  ⟹  q ≤ binom(|A|,2).
```

Neither its converse nor a qualitative approximation to its converse holds.

### Proposition 3 — an infinite post-barrier `capOVER` family

Let `q=p^(2m+1)` for an odd prime `p` and `m≥1`.  Let
`H≤(F_q,+)` be an `F_p`-subspace of dimension `m+1`, so
`s=|H|=p^(m+1)`, and take the parabola cap

```text
A_H = { P_t=[t:t²:1] : t∈H } ⊂ PG(2,q).
```

Then

```text
q ≤ binom(s,2),
```

but the line at infinity is capacity-two and contains exactly

```text
q-s+1
```

legal points.  In particular `A_H` is `capOVER`, with overload tending to
infinity along the family.  The first instance is `q=27`, `s=9`, where the
line at infinity contains 19 legal points despite `binom(9,2)=36≥27`.

**Proof.**  Distinct points `P_t` lie on the nondegenerate conic
`X²=YZ`, hence form a cap.  The chord through `P_t,P_u`, `t≠u`, meets the
line at infinity `Z=0` at

```text
[1:t+u:0].
```

Because `H` is an additive subgroup of odd order, its restricted sumset is
exactly `H`: every `d∈H` has `d=t+u` with distinct `t,u∈H` (choose
`t≠d/2`), and no sum of two elements of `H` leaves `H`.  Thus the blocked
points at infinity are exactly `[1:d:0]`, `d∈H`.  The other `q-s` such
points and the vertical point `[0:1:0]` are legal, proving the count.

Finally

```text
binom(s,2)/q = (p-p^(-m))/2 ≥ 4/3,
```

using `p≥3`, `m≥1`.  Hence the state is already beyond the secant barrier.
Any cap can be built in any order, and a projectivity can send two of its
points to the residual frame, so these are genuine reachable residual-grid
states. ∎

### Proposition 4 — post-barrier `capOK` does not imply `Y_NK`

Let `q≥5` be odd and let `A` be a conic with one point removed.  Then
`|A|=q`, `δ_q(q)=0`, and the only legal move is the missing conic point.
Therefore `capOK(A)` holds, but its full conflict graph is `K₁`, with
Grundy value one.  The state is N, not `Y_NK`.

To see that no off-conic point is legal, use the involution induced on the
conic by projection from that point.  Its nonfixed orbits are chord pairs.
With only one conic point omitted, at least one such pair remains wholly in
`A` (for an internal point all conic points are paired; for an external point
there are two tangent fixed points and `(q-1)/2≥2` chord pairs).  The
off-conic point therefore lies on a secant of `A`.

Propositions 3 and 4 separate the two missing implications:

```text
δ=0  does not imply capOK,
δ=0 and capOK  do not imply P.
```

## 3. Why “P-preserving survival” is circular without `F`

The issue is game-theoretic, not geometric.  In any finite impartial
normal-play game:

1. from a P-position every move goes to an N-position;
2. from every N-position there is a move to a P-position; and
3. repeatedly choosing such replies eventually reaches a terminal
   P-position.

Every terminal cap state lies in `Y_NK`: its legal graph is empty and has
Grundy zero.  Hence:

> A cap position is P if and only if the second player has a
> “P-preserving survival and eventual `Y_NK` absorption” strategy.

The forward implication is just the P/N recursion plus finiteness; the
reverse implication is the asserted winning strategy.  Inserting the time at
which `δ` first reaches zero does not change either implication.  Therefore a
proof whose survivor family is defined as “the P-positions” is exactly the
desired theorem restated.

The noncircular induction must instead expose a family `F` by incidence,
orbit, or residual-hypergraph conditions, prove its response closure without
calling minimax, and invoke game value only at the `Y_NK` base.

## 4. Corrected induction theorem

Let `F` be a set of valid even-turn cap states satisfying:

1. **guard boundary:** if `S∈F` and `Ω(S)=0`, then
   `Grundy(G_S)=0`;
2. **overload response closure:** if `S∈F`, `Ω(S)>0`, and `o` is
   any legal opponent move, then there is a legal reply `p` such that
   `S+o+p∈F` and
   `Ω(S+o+p)<Ω(S)`.

Then every `S∈F` is P.

**Proof.**  Induct on `Ω(S)`.  At zero, guard boundary and the C523 theorem
give `S∈Y_NK`, hence P.  At positive overload, every opponent child has by
response closure a child in `F` of smaller overload, which is P by induction.
Thus every option from `S` is N, so `S` is P. ∎

The strict part of condition 2 is geometrically free once the opponent has
already lowered `Ω`, or once an `F`-preserving reply on an overloaded line is
known (Lemma 2).  The entire open content is therefore:

```text
after each opponent move, find a reply preserving one explicit
value-independent family F and making strict overload progress;
use an overloaded-line reply whenever the opponent made no progress.
```

The secant clock can remain as a coarse annotation.  Below the barrier,
`δ>0` implies `Ω>0` by the C80 obstruction theorem; an
opponent-response exchange sends `s` to `s+2` and decreases `δ` by
`2s+1`, truncated at zero.  After the barrier, `Ω`—not `δ`—measures the
remaining distance to `capOK`.

## `ej` + `tt` closeout

The free upgrade is Lemmas 1–2: the overload excess already introduced by
the fixed-depth obstruction is the exact monotone absorption coordinate.
This removes “how do we eventually reach `capOK`?” as a geometry question.

The Tao-style correction is that the secant barrier is not the induction
boundary.  It marks only where `capOK` stops being numerically impossible.
The actual boundary is `Ω=0`, and the actual theorem is response closure of a
structural family under strict-overload replies, with overloaded-line moves
providing strictness whenever the opponent does not.  This uses one induction
coordinate instead of an artificial before/after split.

A second cheap check gives both sharp countermodels.  The additive-subspace
parabola family shows that overload can remain extensive after `δ=0`; the
punctured conic shows that even `capOK` leaves one independent value bit.
Together they prevent the live handoff from silently promoting a necessary
count into a sufficient strategy condition.

No broader literature or cross-lane claim is implicated.  These are direct
finite-plane incidence and finite-game arguments owned by C80.

## Mystery ledger

- **[SETTLED negative] Does crossing `q=binom(s,2)` imply `capOK` or even
  bounded overload?** No.  The additive-subspace parabola family is
  post-barrier and has `q-s+1` legal points on one capacity-two line.
- **[SETTLED negative] Does post-barrier `capOK` imply `Y_NK`?** No.  A
  conic with one point removed has conflict graph `K₁` and Grundy one.
- **[SETTLED] Is there a deterministic absorption coordinate?** Yes.
  `Ω` is monotone under every move and strictly decreases after a move on an
  overloaded line; `Ω=0` is exactly `capOK`.
- **[SETTLED] Does the requested P-preserving formulation itself simplify
  the game theorem?** No.  Without a value-independent survivor family it is
  equivalent to the definition of a P-position.
- **[OPEN — owner C80] What is the structural survivor family `F`?** It must
  contain the chosen escape child, have `Y_NK` boundary at `Ω=0`, and be
  closed under replies that strictly lower `Ω` after every opponent move
  (using an overloaded-line reply whenever the opponent did not lower it).
  Existing static orbit, character, bounded-gadget, and bounded-depth families
  do not supply it.
- **[OPEN — owner C82 after C80] Can an algebraic packet count guarantee an
  `F`-preserving overloaded-line reply in every opponent fibre?** Still gated
  on C80 identifying `F`.

## Vibe

The literal barrier proof does not go through, but the failure is productive:
the size clock was only a necessary obstruction, while `Ω` is the exact
absorption clock.  C80 is now reduced to one honest, noncircular response
closure lemma; the remaining difficulty is entirely the game-value-preserving
family, not termination or secant counting.

go C80 cap identify a value-independent survivor family `F` and prove
strict-overload response closure into its `Y_NK` boundary
