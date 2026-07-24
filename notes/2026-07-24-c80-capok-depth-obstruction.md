# C80 — fixed-depth `capOK` routing obstruction

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-24.

## Verdict

The proposed uniform depth-2 crown

```text
∃ r, ∀ o, ∃ p:
  the leaf is capOK and its continuation complex is empty or pure one-dimensional
```

is false for a structural counting reason.  In the C524 routing shape the leaf
contains twelve selected projective points.  No twelve-point cap in
`PG(2,67)` can be `capOK`, independently of how `r`, `o`, and `p` are chosen.
The empty/pure-one-dimensional condition therefore never becomes relevant.

More generally, no fixed selected-set size can support a `capOK` residual for
all field orders.  Any uniform descent into `Y_NK` must have depth growing with
`q`, or C80 must replace `capOK` by a P-guard that permits genuine
capacity-two lines.

## Counting theorem

Let `A` be an `s`-cap in `PG(2,q)`, let `U` be its legal continuation locus,
and suppose `s < q+1`.  Write

```text
N = q² + q + 1
B = binom(s,2).
```

If every line disjoint from `A` contains at most two points of `U`—the
geometric `capOK` condition—then necessarily

```text
N - s - B(q-1)
  ≤ |U|
  ≤ 2(N - s(q+1) + B) / (q+1-s).                 (1)
```

### Lower bound

Because `A` is a cap, its `B` secants are distinct.  Each secant contains its
two points of `A` and `q-1` other points.  Every point outside `A` that is not
legal lies on at least one of these secants.  A union bound therefore gives

```text
|U| ≥ N - s - B(q-1).
```

Intersections among secants only improve this lower bound.

### Upper bound

Let `E₀` be the set of projective lines disjoint from `A`.  Counting lines
meeting `A`, with each secant counted twice in the initial point-line
incidence sum, gives

```text
|E₀| = N - s(q+1) + B.
```

For a legal point `u`, the `s` lines `ua`, `a ∈ A`, are distinct.  They are
exactly the lines through `u` meeting `A`: a line through `u` cannot contain
two points of `A`, since then `u` would lie on a secant and would not be
legal.  Hence exactly `q+1-s` lines of `E₀` pass through `u`.

Double-count incidences `(u,ℓ)` with `u ∈ U`, `ℓ ∈ E₀`, and `u ∈ ℓ`.
The point count is `|U|(q+1-s)`.  The `capOK` hypothesis makes the line count
at most `2|E₀|`.  This proves the upper bound in (1).

## The q=67 contradiction

The C524 leaf starts with the two burned-direction points, four further conic
points, and two intruders.  The moves `child`, `r`, `o`, and `p` add four more
points, so the leaf is a twelve-cap.

For `q=67`, `s=12`,

```text
N = 4557,   B = 66,   q+1-s = 56.
```

The two sides of (1) give

```text
|U| ≥ 4557 - 12 - 66·66 = 189,
|U| ≤ 2(4557 - 12·68 + 66)/56 = 7614/56 < 136.
```

This is impossible.  Thus no choice of `r`, no opponent move `o`, and no
reply `p` can produce a `capOK` leaf in this fixed-depth shape at `q=67`.
In particular, it cannot produce an empty or pure-one-dimensional `capOK`
continuation complex.

For completeness, substituting `s=12` into (1) yields the necessary
polynomial inequality

```text
q³ - 78q² + 792q - 715 ≤ 0.
```

Its left side is `2970` at `q=67` and is strictly increasing thereafter
(its derivative is positive for `q ≥ 67`).  The obstruction therefore holds
for every field order `q ≥ 67`, not only for the first odd prime example.

## Consequence for C80

C524's depth-2 closure at `q=13,17,19` is a real finite certificate but cannot
be the restriction of the proposed all-`q` theorem.  The obstruction is
independent of witness selection, minimax value, conic type, and the
pure-one-dimensional refinement: `capOK` itself is impossible at the fixed
leaf size.

The same inequality shows the scale of any repaired route.  If `s` stays
fixed while `q` grows, its lower bound is `q²-O(q)` whereas its upper bound is
`O(q)`.  Consequently a uniform `Y_NK` descent must select an unbounded
number of points; at the level of secant coverage, one needs
`binom(s,2)` on the order of `q`, hence at least square-root scale.  A bounded
number of opponent-response exchanges cannot suffice.

The viable C80 alternatives are therefore:

1. prove a variable-depth strategy that preserves a game invariant while the
   selected cap grows to the `capOK` scale; or
2. build a different proven-P terminal guard that retains controlled
   capacity-two lines instead of forcing a static Node--Kayles residual.

The first is the nearer continuation because it retains the proved C523
`Y_NK` base case and the C80(c) drain resource, but its induction measure must
carry game value through an unbounded number of exchanges.

## `ej` + `tt` closeout

The cheap upgrade is the general inequality (1), not merely the q=67
counterexample.  It explains *why* the finite depth-2 signal cannot
stabilize: fixed-size secants cover only `O(q)` points, leaving a quadratic
legal reservoir, while `capOK` permits only a linear reservoir by
point-line incidence counting.

The proof-design correction is also sharper than “try depth 3.”  Every fixed
depth fails eventually.  The right quantifier shape must include a stopping
time or induction depth depending on the state and on `q`; preserving
`∃r ∀o ∃p` for one exchange is insufficient.

## Mystery ledger

- **[SETTLED negative] Is the C528 empty/pure-one-dimensional `capOK` leaf a
  uniform all-odd-`q` crown?** No.  `q=67`, `s=12` gives the contradiction
  `189 ≤ |U| < 136`.
- **[SETTLED] Could another choice of the depth-2 witness rescue the crown?**
  No.  The obstruction applies to every twelve-cap and uses no witness
  features.
- **[SETTLED] Would any other fixed routing depth suffice?** Not uniformly.
  Inequality (1) rules out every fixed leaf size for all sufficiently large
  `q`.
- **[OPEN — owner C80] Can a variable-depth responder strategy reach
  `Y_NK` while preserving P after every opponent move?** No invariant or
  stopping-time proof is known.  This is now the highest-EV continuation.
- **[OPEN — alternative C80 guard] Is there a structurally P residual family
  allowing controlled active triples?** C547's residual-hypergraph package
  supplies vocabulary, but no such value theorem exists.

## Vibe

The requested theorem is decisively false, but the failure is unusually
useful: a two-line incidence count removes the entire bounded-depth search
space and explains the small-order illusion.  C80 now needs a genuinely
asymptotic game strategy, not a better finite witness selector.

go C80 cap prove a variable-depth P-preserving descent to `Y_NK`, with a
state-dependent stopping time and the secant-coverage bound as the depth
floor
