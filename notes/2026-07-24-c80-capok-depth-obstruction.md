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

The exact size obstruction is particularly clean:

```text
capOK for an s-cap (s ≥ 4)  ⟹  q ≤ binom(s,2).       (2)
```

Thus the required selected-set size is not just unbounded but at least

```text
ceil((1 + sqrt(1+8q))/2).
```

The failure beyond this threshold is also quantitatively large.  At the first
forbidden order `q=binom(s,2)+1`, every `s`-cap has total capacity-two
overload excess at least `6 binom(s,4)`, spread across at least
`binom(s-2,2)` disjoint-from-cap lines.  Thus a bounded active-triple patch
cannot repair the fixed-depth guard.

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

### Exact consequence: `q ≤ binom(s,2)`

Put `B=binom(s,2)` and

```text
c = B+1-s = (s-1)(s-2)/2.
```

Suppose for contradiction that `q ≥ B+1`.  The lower bound in (1) becomes

```text
|U| ≥ q(q+1-B)+c ≥ 2q+c ≥ 2q+3,
```

where the last inequality uses `s≥4`.  Meanwhile

```text
|E₀| = q(q+1-s)+c,
```

so the upper bound becomes

```text
|U| ≤ 2q + 2c/(q+1-s).
```

But `q≥B+1` gives `q+1-s≥c+1`, hence the final fraction is strictly less
than two.  Thus `|U|<2q+2`, contradicting `|U|≥2q+3`.  This proves (2).

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

Equivalently, the exact theorem gives `q≤binom(12,2)=66`.  The obstruction
therefore holds for every field order `q≥67`, not only for the first odd
prime example.

## `ej2` — unavoidable overload is extensive

For each line `ℓ` disjoint from `A`, put `m_ℓ=|U∩ℓ|` and define its
capacity-two overload excess by

```text
Ω(A) = Σ_ℓ max(0,m_ℓ-2).
```

The same incidence count gives a quantitative lower bound even without
`capOK`:

```text
Ω(A)
  ≥ |U|(q+1-s) - 2|E₀|
  ≥ [N-s-B(q-1)](q+1-s) - 2[N-s(q+1)+B].          (3)
```

Indeed, `Σm_ℓ=|U|(q+1-s)` and
`Σ max(0,m_ℓ-2) ≥ Σ(m_ℓ-2)`.

At the first forbidden order `q=B+1`, the final expression in (3) simplifies
exactly to

```text
s(s-1)(s-2)(s-3)/4 = 6 binom(s,4).
```

Since a projective line has at most `q+1` legal points, one overloaded line
contributes at most `q-1=B` to `Ω`.  Therefore at least

```text
ceil(6 binom(s,4)/B) = binom(s-2,2)
```

different disjoint-from-cap lines are overloaded.

For the C524 leaf (`s=12`, `q=67`), every possible leaf has

```text
Ω(A) ≥ 6 binom(12,4) = 2970
```

and at least `binom(10,2)=45` active capacity-two lines.  The obstruction is
therefore not a single exceptional triple gadget.  It is an extensive
rank-three residual, matching C528's observation that gadget count grows
with `q` and ruling out a fixed-depth repair by adding a bounded number of
controlled active triples.

## Consequence for C80

C524's depth-2 closure at `q=13,17,19` is a real finite certificate but cannot
be the restriction of the proposed all-`q` theorem.  The obstruction is
independent of witness selection, minimax value, conic type, and the
pure-one-dimensional refinement: `capOK` itself is impossible at the fixed
leaf size.

The exact theorem gives the scale of any repaired route.  A uniform `Y_NK`
descent must reach

```text
s ≥ s_min(q) := ceil((1 + sqrt(1+8q))/2).
```

In the C524 architecture the residual child has size nine, the first
responder move produces size ten, and each later opponent-response exchange
adds two selected points.  If `k` is the number of those exchanges, any
`capOK` stopping leaf must satisfy

```text
10 + 2k ≥ s_min(q),
k ≥ ceil((s_min(q)-10)/2).                         (4)
```

Hence `k ≥ sqrt(q/2)-5+O(1)`.  A bounded number of exchanges cannot suffice;
the obstruction is a quantitative depth floor, not only a fixed-depth
counterexample.  At `q=67`, (4) already forces `k≥2`, whereas C524 uses
`k=1`.

The viable C80 alternatives are therefore:

1. prove a variable-depth strategy that preserves a game invariant while the
   selected cap grows to the `capOK` scale; or
2. build a different proven-P terminal guard that retains controlled
   capacity-two lines instead of forcing a static Node--Kayles residual.

The first is the nearer continuation because it retains the proved C523
`Y_NK` base case and the C80(c) drain resource, but its induction measure must
carry game value through an unbounded number of exchanges.

## `ej` + `tt` closeout

The cheap upgrade is the exact corollary `q≤binom(s,2)`, not merely the q=67
counterexample.  It explains *why* the finite depth-2 signal cannot
stabilize and supplies an explicit square-root selected-size floor and the
exchange-depth lower bound (3).

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
  In fact `capOK` forces `q≤binom(s,2)`, so the C524 exchange count obeys the
  explicit lower bound (4).
- **[SETTLED] What scale must a repaired `Y_NK` descent reach?** At least
  `s_min(q)=ceil((1+sqrt(1+8q))/2)` selected points, or
  `sqrt(q/2)-5+O(1)` opponent-response exchanges in the current architecture.
- **[SETTLED by ej2] Could a bounded family of active-triple gadgets patch
  the fixed-depth guard?** No.  At `q=binom(s,2)+1`, every `s`-cap has
  overload excess at least `6binom(s,4)` on at least `binom(s-2,2)` lines;
  the twelve-cap instance forces excess 2970 on at least 45 lines.
- **[OPEN — owner C80] Can a variable-depth responder strategy reach
  `Y_NK` while preserving P after every opponent move?** No invariant or
  stopping-time proof is known.  This is now the highest-EV continuation.
- **[OPEN — alternative C80 guard] Is there a structurally P residual family
  allowing controlled active triples?** C547's residual-hypergraph package
  supplies vocabulary, but no such value theorem exists.

## Vibe

The requested theorem is decisively false, but the failure is unusually
useful: a two-line incidence count removes the entire bounded-depth search
space and explains the small-order illusion.  The `ej2` overload count also
removes bounded-gadget patching.  C80 now needs a genuinely asymptotic
game strategy over an extensive rank-three residual, not a better finite
witness selector.

go C80 cap prove a variable-depth P-preserving descent to `Y_NK`, with a
state-dependent stopping time and the secant-coverage bound as the depth
floor
