# C80 — finite-signature congruence no-go

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

There is no q-independent **finite-state** congruence or finite exact
follower-game signature for the mixed-capacity residual transform, even after
restricting to the proved boundary family

```text
Y_NK ⊆ K_Ω.
```

For every odd `q`, large subsets of a conic seal all off-conic points. Their
residual games are free placement on the remaining conic points. Taking an
even number `n` of remaining points gives a `Y_NK` P-position whose exact
rooted game has height `n`. Distinct heights cannot be identified by any
move bisimulation or exact transition congruence.

Quantitatively, one order already contains at least

```text
floor((q-2)/4) + 1
```

pairwise inequivalent `Y_NK` P-positions. Hence the number of required exact
signature classes is unbounded in `q`.

This settles the finite-cardinality **exact-transition** reading of the
C547/C549 follower-signature program and corrects the preceding C80 queue wording:
“finite-dimensional” cannot mean a fixed finite type `β`.

It does **not** rule out a fixed number of algebraic coordinates with
unbounded ranges. Indeed this family itself is compressed by the single
integer `n`. The remaining C80 target is therefore a fixed-dimensional
unbounded-range algebraic congruence on the positive-overload response
family, not a finite-state automaton.

## 1. Conic sealing lemma

Let `C` be a nonsingular conic in `PG(2,q)`, `q` odd, and let `A⊆C`.
For the fixed-pair residual model, choose `C` through the opening pair and
require that pair to lie in `A`.
For an off-conic point `x`, projection through `x` induces an involution
`σ_x` on `C`: two conic points are paired exactly when their secant passes
through `x`; tangent points are fixed.

In odd characteristic, `σ_x` has zero or two fixed conic points. Therefore a
subset of `C` containing no complete nontrivial `σ_x`-pair has size at most

```text
(q+3)/2.
```

The upper value is attained only in the two-fixed-point case: take both
fixed points and at most one point from each of the `(q-1)/2` two-cycles.

### Lemma — large conic subsets seal the exterior

If

```text
|A| > (q+3)/2,
```

then every point outside `C` is illegal over the selected cap `A`.

**Proof.** For every off-conic `x`, the size bound forces `A` to contain both
members of some nontrivial `σ_x`-pair. Those two selected conic points and
`x` are collinear, so playing `x` would create a collinear triple. ∎

Every point of `C\A` remains legal, and every subset of `C\A` may be played,
because a conic is an arc. Thus the complete residual game over `A` is free
placement on

```text
n = q+1-|A|
```

vertices.

Equivalently, in the exact residual object from the preceding C80 report:

```text
V = C\A,
E = ∅,
active blocks = ∅.
```

It is therefore an overload-zero `Y_NK` state.

## 2. Unbounded exact signatures inside `K_Ω`

Choose any even integer `n≥0` satisfying

```text
n < (q-1)/2,
```

and choose `A⊆C` with `|A|=q+1-n`. The sealing lemma applies. The residual
is free placement on `n` vertices, whose Grundy value is `n mod 2=0`.
Consequently this state lies in

```text
Y_NK ⊆ K_Ω ⊆ P.
```

Let `G_n` denote the exact rooted game of free placement on `n` vertices.
After any move its follower is `G_{n-1}`; duplicate labelled choices do not
matter. Hence its canonical extensional signature satisfies

```text
sig(G_0) = ∅,
sig(G_n) = {sig(G_{n-1})}.
```

In particular, `G_n` has maximum remaining height `n`, and the signatures
`sig(G_n)` are pairwise distinct.

The permitted even integers are `n=2j` with `4j<q-1`. Their count is

```text
floor((q-2)/4) + 1.
```

This proves the claimed lower bound on exact congruence classes within the
P-valued overload-zero kernel itself.

### Corollary — no uniform finite exact follower type

There is no fixed finite type `β`, independent of `q`, through which the
exact rooted residual games—or all their exact child-game signatures—factor on
`Y_NK`.

Otherwise the number of congruence classes would be at most `|β|`, contrary
to the displayed lower bound as `q→∞`.

The same argument applies to any two-sided move bisimulation, deterministic
transition congruence, or exact game-tree quotient preserving terminality:
such relations preserve maximum remaining height.

## 3. Bearing on the prior evidence

C549 measured exact label-free growth:

```text
q17 → 8 root types, 21 child types;
q19 → 2,881 root types, 654 child types.
```

Those two finite orders could not prove asymptotic growth. The conic family
does: exact rooted type count is unbounded already in the simplest
overload-zero subfamily.

For C547's theorem

```text
child SG factors through a finite signature type β
⇒ SG is bounded by |β|
```

the present result excludes using exact rooted-game equivalence classes as
one q-independent finite `β`. It does **not** exclude a coarser type through
which child Grundy values happen to factor: on the constructed family,
parity already does so. The obstruction concerns exact transition
congruence, not a value-only mex bound.

The result does not contradict small nimbers. Every state in the constructed
P family has Grundy zero despite having a distinct exact rooted game. Exact
transition type is much finer than nimber, exactly as C549 observed in the
coupled q19 corpus.

## 4. Trust boundary

This is a proof, not a computational census.

Inputs:

- the standard conic secant involution in odd projective planes;
- its zero-or-two fixed-point dichotomy;
- the already proved `Y_NK` interpretation of overload-zero residuals;
- the exact residual move semantics from C547 and the preceding C80 report.

No maximum-arc theorem is used. The sealing threshold follows directly from
the involution cycle count, and the free-placement signature recursion is
elementary normal play.

The theorem applies to all odd prime powers `q`. It concerns exact
transition/game-tree congruence. It makes no claim against approximate
quotients, value-only maps, or fixed-dimensional coordinates with unbounded
entries.

## `ej` + `tt` closeout

The free upgrade is the location of the obstruction. One might expect
finite-signature failure only in the positive-overload coupled core, but it
already occurs in `Y_NK`, where all active triples and pair conflicts have
vanished. Therefore no refinement of overload gadgets can rescue a global
finite-state quotient.

The Tao-style correction is to distinguish three notions that the previous
queue wording compressed:

```text
finite state/type:             falsified here;
fixed-dimensional coordinates: still possible, with unbounded values;
value-only quotient:           much coarser and not a transition congruence.
```

The conic family itself demonstrates the distinction: exact rooted games
need unboundedly many states, while the single coordinate `n` describes all
of them and the single bit `n mod 2` gives their value.

Thus the next C80 candidate must state its algebra and update law explicitly.
A vector of finitely many counts, moments, or module parameters is admissible;
a fixed finite lookup type is not.

## Mystery ledger

- **[SETTLED negative] Can one q-independent finite follower-signature type
  encode the exact residual transform?** No, even on `Y_NK∩P`.
- **[SETTLED quantitative] How many exact classes are forced at one order?**
  At least `floor((q-2)/4)+1` P-valued classes from the sealed conic family.
- **[SETTLED conceptual] Does unbounded exact type imply unbounded Grundy?**
  No. Every constructed state has Grundy zero.
- **[OPEN — C80] Is there a fixed-dimensional algebraic coordinate system
  with unbounded entries that is closed under the residual move transform
  and exposes lower-`K_Ω` replies?** Not proved or falsified.
- **[OPEN — C80 crown] Can positive-overload escape roots be placed in
  `K_Ω` uniformly without recursive evaluation?** Still open.

## Vibe

This is a clean theorem-level negative that removes “finite automaton” from
the search space without harming algebraic renormalization. The next target
is narrower and better posed: finitely many unbounded coordinates with a
closed move law.

go C80 cap prove or falsify a fixed-dimensional unbounded-range algebraic
congruence for the positive-overload residual transform
